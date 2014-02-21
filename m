Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbaBUMvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:51:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47240 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbaBUMvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: linux-raid@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        NeilBrown <neilb@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 102/121] md/raid5: Fix CPU hotplug callback registration
Date: Fri, 21 Feb 2014 12:48:46 +0000
Message-Id: <1392986945-9693-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 789b5e0315284463617e106baad360cb9e8db3ac upstream.

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

Cc: linux-raid@vger.kernel.org
Fixes: 36d1c6476be51101778882897b315bd928c8c7b5
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
[Srivatsa: Fixed the unregister_cpu_notifier() deadlock, added the
free_scratch_buffer() helper to condense code further and wrote the changelog.]
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/raid5.c | 90 ++++++++++++++++++++++++++----------------------------
 1 file changed, 44 insertions(+), 46 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a40b969..f64379b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5037,23 +5037,43 @@ raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks)
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
@@ -5079,15 +5099,7 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
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
@@ -5095,10 +5107,7 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
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
@@ -5110,40 +5119,29 @@ static int raid456_cpu_notify(struct notifier_block *nfb, unsigned long action,
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
-- 
1.9.0

