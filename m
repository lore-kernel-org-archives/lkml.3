Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaCJUhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:37:04 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45653 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbaCJUhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:37:00 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 16/52] x86, cpuid: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        srivatsa.bhat@linux.vnet.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        x86@kernel.org, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 02:06:44 +0530
Message-ID: <20140310203644.10746.75727.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031020-5816-0000-0000-00000CC3DD15
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

Instead, the correct and race-free way of performing the callback
registration is:

	cpu_notifier_register_begin();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	/* Note the use of the double underscored version of the API */
	__register_cpu_notifier(&foobar_cpu_notifier);

	cpu_notifier_register_done();


Fix the cpuid code in x86 by using this latter form of callback registration.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/cpuid.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 7d9481c..3225ae6c 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -198,14 +198,15 @@ static int __init cpuid_init(void)
 		goto out_chrdev;
 	}
 	cpuid_class->devnode = cpuid_devnode;
-	get_online_cpus();
+
+	cpu_notifier_register_begin();
 	for_each_online_cpu(i) {
 		err = cpuid_device_create(i);
 		if (err != 0)
 			goto out_class;
 	}
-	register_hotcpu_notifier(&cpuid_class_cpu_notifier);
-	put_online_cpus();
+	__register_hotcpu_notifier(&cpuid_class_cpu_notifier);
+	cpu_notifier_register_done();
 
 	err = 0;
 	goto out;
@@ -215,7 +216,7 @@ out_class:
 	for_each_online_cpu(i) {
 		cpuid_device_destroy(i);
 	}
-	put_online_cpus();
+	cpu_notifier_register_done();
 	class_destroy(cpuid_class);
 out_chrdev:
 	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
@@ -227,13 +228,13 @@ static void __exit cpuid_exit(void)
 {
 	int cpu = 0;
 
-	get_online_cpus();
+	cpu_notifier_register_begin();
 	for_each_online_cpu(cpu)
 		cpuid_device_destroy(cpu);
 	class_destroy(cpuid_class);
 	__unregister_chrdev(CPUID_MAJOR, 0, NR_CPUS, "cpu/cpuid");
-	unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
-	put_online_cpus();
+	__unregister_hotcpu_notifier(&cpuid_class_cpu_notifier);
+	cpu_notifier_register_done();
 }
 
 module_init(cpuid_init);

