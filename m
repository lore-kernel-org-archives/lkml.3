Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaCJUmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:42:05 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56285 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbaCJUmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:42:01 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 46/52] xen, balloon: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, Ingo Molnar <mingo@kernel.org>,
        xen-devel@lists.xenproject.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 02:11:45 +0530
Message-ID: <20140310204144.10746.62444.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031020-6102-0000-0000-0000051B2F8D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

The xen balloon driver doesn't take get/put_online_cpus() around this code,
but that is also buggy, since it can miss CPU hotplug events in between the
initialization and callback registration:

	for_each_online_cpu(cpu)
		init_cpu(cpu);
		   ^
		   |  Race window; Can miss CPU hotplug events here.
		   v
	register_cpu_notifier(&foobar_cpu_notifier);

Interestingly, the balloon code in xen can simply be reorganized as shown
below, to have a race-free method to register hotplug callbacks, without even
taking get/put_online_cpus(). This is because the initialization performed for
already online CPUs is exactly the same as that performed for CPUs that come
online later. Moreover, the code has checks in place to avoid double
initialization.

	register_cpu_notifier(&foobar_cpu_notifier);

	get_online_cpus();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	put_online_cpus();

A hotplug operation that occurs between registering the notifier and calling
get_online_cpus(), won't disrupt anything, because the code takes care to
perform the memory allocations only once.

So reorganize the balloon code in xen this way to fix the issues with CPU
hotplug callback registration.

Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: xen-devel@lists.xenproject.org
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/xen/balloon.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 37d06ea..dd79549 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -592,19 +592,29 @@ static void __init balloon_add_region(unsigned long start_pfn,
 	}
 }
 
+static int alloc_balloon_scratch_page(int cpu)
+{
+	if (per_cpu(balloon_scratch_page, cpu) != NULL)
+		return 0;
+
+	per_cpu(balloon_scratch_page, cpu) = alloc_page(GFP_KERNEL);
+	if (per_cpu(balloon_scratch_page, cpu) == NULL) {
+		pr_warn("Failed to allocate balloon_scratch_page for cpu %d\n", cpu);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+
 static int balloon_cpu_notify(struct notifier_block *self,
 				    unsigned long action, void *hcpu)
 {
 	int cpu = (long)hcpu;
 	switch (action) {
 	case CPU_UP_PREPARE:
-		if (per_cpu(balloon_scratch_page, cpu) != NULL)
-			break;
-		per_cpu(balloon_scratch_page, cpu) = alloc_page(GFP_KERNEL);
-		if (per_cpu(balloon_scratch_page, cpu) == NULL) {
-			pr_warn("Failed to allocate balloon_scratch_page for cpu %d\n", cpu);
+		if (alloc_balloon_scratch_page(cpu))
 			return NOTIFY_BAD;
-		}
 		break;
 	default:
 		break;
@@ -624,15 +634,17 @@ static int __init balloon_init(void)
 		return -ENODEV;
 
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-		for_each_online_cpu(cpu)
-		{
-			per_cpu(balloon_scratch_page, cpu) = alloc_page(GFP_KERNEL);
-			if (per_cpu(balloon_scratch_page, cpu) == NULL) {
-				pr_warn("Failed to allocate balloon_scratch_page for cpu %d\n", cpu);
+		register_cpu_notifier(&balloon_cpu_notifier);
+
+		get_online_cpus();
+		for_each_online_cpu(cpu) {
+			if (alloc_balloon_scratch_page(cpu)) {
+				put_online_cpus();
+				unregister_cpu_notifier(&balloon_cpu_notifier);
 				return -ENOMEM;
 			}
 		}
-		register_cpu_notifier(&balloon_cpu_notifier);
+		put_online_cpus();
 	}
 
 	pr_info("Initialising balloon driver\n");

