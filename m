Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaBEWSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:18:15 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:58972 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbaBEWSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:18:09 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 45/51] md, raid5: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        stable@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:42:45 +0530
Message-ID: <20140205221244.19080.70910.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-7014-0000-0000-00000448B6D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Subsystems that want to register CPU hotplug callbacks, as well as perform
initialization for the CPUs that are already online, often do it as shown
below:

	get_online_cpus();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	register_cpu_notifier(&foobar_cpu_notifier);

	put_online_cpus();

This is wrong, since it is prone to ABBA deadlocks involving the
cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
with CPU hotplug operations).

Interestingly, the raid5 code can actually prevent double initialization and
hence can use the following simplified form of callback registration:

	register_cpu_notifier(&foobar_cpu_notifier);

	get_online_cpus();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	put_online_cpus();

A hotplug operation that occurs between registering the notifier and calling
get_online_cpus(), won't disrupt anything, because the code takes care to
perform the memory allocations only once.

So reorganize the code in raid5 this way to fix the deadlock with callback
registration.

Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Cc: stable@vger.kernel.org
[Srivatsa: Fixed the unregister_cpu_notifier() deadlock, added the
free_scratch_buffer() helper to condense code further and wrote the changelog.]
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/md/raid5.c |   90 +++++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f1feade..16f5c21 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5514,23 +5514,43 @@ raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 	return sectors * (raid_disks - conf->max_degraded);
 }
 
+static void free_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
+{
+	safe_put_page(percpu->spare_page);
+	kfree(percpu->scribble);
+	percpu->spare_page = NULL;
+	percpu->scribble = NULL;
+}
+
+static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu *percpu)
+{
+	if (conf->level == 6 && !percpu->spare_page)
+		percpu->spare_page = alloc_page(GFP_KERNEL);
+	if (!percpu->scribble)
+		percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
+
+	if (!percpu->scribble || (conf->level == 6 && !percpu->spare_page)) {
+		free_scratch_buffer(conf, percpu);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static void raid5_free_percpu(struct r5conf *conf)
 {
-	struct raid5_percpu *percpu;
 	unsigned long cpu;
 
 	if (!conf->percpu)
 		return;
 
-	get_online_cpus();
-	for_each_possible_cpu(cpu) {
-		percpu = per_cpu_ptr(conf->percpu, cpu);
-		safe_put_page(percpu->spare_page);
-		kfree(percpu->scribble);
-	}
 #ifdef CONFIG_HOTPLUG_CPU
 	unregister_cpu_notifier(&conf->cpu_notify);
 #endif
+
+	get_online_cpus();
+	for_each_possible_cpu(cpu)
+		free_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
 	put_online_cpus();
 
 	free_percpu(conf->percpu);
@@ -5557,15 +5577,7 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (conf->level == 6 && !percpu->spare_page)
-			percpu->spare_page = alloc_page(GFP_KERNEL);
-		if (!percpu->scribble)
-			percpu->scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
-
-		if (!percpu->scribble ||
-		    (conf->level == 6 && !percpu->spare_page)) {
-			safe_put_page(percpu->spare_page);
-			kfree(percpu->scribble);
+		if (alloc_scratch_buffer(conf, percpu)) {
 			pr_err("%s: failed memory allocation for cpu%ld\n",
 			       __func__, cpu);
 			return notifier_from_errno(-ENOMEM);
@@ -5573,10 +5585,7 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		safe_put_page(percpu->spare_page);
-		kfree(percpu->scribble);
-		percpu->spare_page = NULL;
-		percpu->scribble = NULL;
+		free_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
 		break;
 	default:
 		break;
@@ -5588,40 +5597,29 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
 static int raid5_alloc_percpu(struct r5conf *conf)
 {
 	unsigned long cpu;
-	struct page *spare_page;
-	struct raid5_percpu __percpu *allcpus;
-	void *scribble;
-	int err;
+	int err = 0;
 
-	allcpus = alloc_percpu(struct raid5_percpu);
-	if (!allcpus)
+	conf->percpu = alloc_percpu(struct raid5_percpu);
+	if (!conf->percpu)
 		return -ENOMEM;
-	conf->percpu = allcpus;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	conf->cpu_notify.notifier_call = raid456_cpu_notify;
+	conf->cpu_notify.priority = 0;
+	err = register_cpu_notifier(&conf->cpu_notify);
+	if (err)
+		return err;
+#endif
 
 	get_online_cpus();
-	err = 0;
 	for_each_present_cpu(cpu) {
-		if (conf->level == 6) {
-			spare_page = alloc_page(GFP_KERNEL);
-			if (!spare_page) {
-				err = -ENOMEM;
-				break;
-			}
-			per_cpu_ptr(conf->percpu, cpu)->spare_page = spare_page;
-		}
-		scribble = kmalloc(conf->scribble_len, GFP_KERNEL);
-		if (!scribble) {
-			err = -ENOMEM;
+		err = alloc_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
+		if (err) {
+			pr_err("%s: failed memory allocation for cpu%ld\n",
+			       __func__, cpu);
 			break;
 		}
-		per_cpu_ptr(conf->percpu, cpu)->scribble = scribble;
 	}
-#ifdef CONFIG_HOTPLUG_CPU
-	conf->cpu_notify.notifier_call = raid456_cpu_notify;
-	conf->cpu_notify.priority = 0;
-	if (err == 0)
-		err = register_cpu_notifier(&conf->cpu_notify);
-#endif
 	put_online_cpus();
 
 	return err;

