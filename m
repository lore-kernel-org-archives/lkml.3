Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaBEWMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:12:33 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55011 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaBEWM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:12:29 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 14/51] x86, msr: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:37:05 +0530
Message-ID: <20140205220704.19080.32581.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-1618-0000-0000-0000056294F5
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

	cpu_maps_update_begin();

	for_each_online_cpu(cpu)
		init_cpu(cpu);

	/* Note the use of the double underscored version of the API */
	__register_cpu_notifier(&foobar_cpu_notifier);

	cpu_maps_update_done();


Fix the msr code in x86 by using this latter form of callback registration.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/msr.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 05266b5..f9e65ff 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -259,14 +259,15 @@ static int __init msr_init(void)
 		goto out_chrdev;
 	}
 	msr_class->devnode = msr_devnode;
-	get_online_cpus();
+
+	cpu_maps_update_begin();
 	for_each_online_cpu(i) {
 		err = msr_device_create(i);
 		if (err != 0)
 			goto out_class;
 	}
-	register_hotcpu_notifier(&msr_class_cpu_notifier);
-	put_online_cpus();
+	__register_hotcpu_notifier(&msr_class_cpu_notifier);
+	cpu_maps_update_done();
 
 	err = 0;
 	goto out;
@@ -275,7 +276,7 @@ out_class:
 	i = 0;
 	for_each_online_cpu(i)
 		msr_device_destroy(i);
-	put_online_cpus();
+	cpu_maps_update_done();
 	class_destroy(msr_class);
 out_chrdev:
 	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
@@ -286,13 +287,14 @@ out:
 static void __exit msr_exit(void)
 {
 	int cpu = 0;
-	get_online_cpus();
+
+	cpu_maps_update_begin();
 	for_each_online_cpu(cpu)
 		msr_device_destroy(cpu);
 	class_destroy(msr_class);
 	__unregister_chrdev(MSR_MAJOR, 0, NR_CPUS, "cpu/msr");
-	unregister_hotcpu_notifier(&msr_class_cpu_notifier);
-	put_online_cpus();
+	__unregister_hotcpu_notifier(&msr_class_cpu_notifier);
+	cpu_maps_update_done();
 }
 
 module_init(msr_init);

