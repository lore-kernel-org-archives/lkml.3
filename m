Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaBEWRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:17:16 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:58737 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017AbaBEWRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:17:09 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 40/51] octeon, watchdog: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:41:44 +0530
Message-ID: <20140205221144.19080.47455.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-7014-0000-0000-00000448B6A5
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


Fix the watchdog code in octeon by using this latter form of callback
registration.

Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/watchdog/octeon-wdt-main.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/octeon-wdt-main.c b/drivers/watchdog/octeon-wdt-main.c
index 4612088..c991acf 100644
--- a/drivers/watchdog/octeon-wdt-main.c
+++ b/drivers/watchdog/octeon-wdt-main.c
@@ -708,10 +708,13 @@ static int __init octeon_wdt_init(void)
 
 	cpumask_clear(&irq_enabled_cpus);
 
+	cpu_maps_update_begin();
 	for_each_online_cpu(cpu)
 		octeon_wdt_setup_interrupt(cpu);
 
-	register_hotcpu_notifier(&octeon_wdt_cpu_notifier);
+	__register_hotcpu_notifier(&octeon_wdt_cpu_notifier);
+	cpu_maps_update_done();
+
 out:
 	return ret;
 }
@@ -725,7 +728,8 @@ static void __exit octeon_wdt_cleanup(void)
 
 	misc_deregister(&octeon_wdt_miscdev);
 
-	unregister_hotcpu_notifier(&octeon_wdt_cpu_notifier);
+	cpu_maps_update_begin();
+	__unregister_hotcpu_notifier(&octeon_wdt_cpu_notifier);
 
 	for_each_online_cpu(cpu) {
 		int core = cpu2core(cpu);
@@ -734,6 +738,9 @@ static void __exit octeon_wdt_cleanup(void)
 		/* Free the interrupt handler */
 		free_irq(OCTEON_IRQ_WDOG0 + core, octeon_wdt_poke_irq);
 	}
+
+	cpu_maps_update_done();
+
 	/*
 	 * Disable the boot-bus memory, the code it points to is soon
 	 * to go missing.

