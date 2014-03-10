Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaCJUlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:41:03 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39358 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaCJUk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:40:59 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v3 42/52] octeon,
 watchdog: Fix CPU hotplug callback registration
To: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        srivatsa.bhat@linux.vnet.ibm.com, Wim Van Sebroeck <wim@iguana.be>,
        Ingo Molnar <mingo@kernel.org>, linux-watchdog@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 02:10:43 +0530
Message-ID: <20140310204042.10746.60098.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031020-0260-0000-0000-000004832C25
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


Fix the watchdog code in octeon by using this latter form of callback
registration.

Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-watchdog@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/watchdog/octeon-wdt-main.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/octeon-wdt-main.c b/drivers/watchdog/octeon-wdt-main.c
index 4612088..4baf2d7 100644
--- a/drivers/watchdog/octeon-wdt-main.c
+++ b/drivers/watchdog/octeon-wdt-main.c
@@ -708,10 +708,13 @@ static int __init octeon_wdt_init(void)
 
 	cpumask_clear(&irq_enabled_cpus);
 
+	cpu_notifier_register_begin();
 	for_each_online_cpu(cpu)
 		octeon_wdt_setup_interrupt(cpu);
 
-	register_hotcpu_notifier(&octeon_wdt_cpu_notifier);
+	__register_hotcpu_notifier(&octeon_wdt_cpu_notifier);
+	cpu_notifier_register_done();
+
 out:
 	return ret;
 }
@@ -725,7 +728,8 @@ static void __exit octeon_wdt_cleanup(void)
 
 	misc_deregister(&octeon_wdt_miscdev);
 
-	unregister_hotcpu_notifier(&octeon_wdt_cpu_notifier);
+	cpu_notifier_register_begin();
+	__unregister_hotcpu_notifier(&octeon_wdt_cpu_notifier);
 
 	for_each_online_cpu(cpu) {
 		int core = cpu2core(cpu);
@@ -734,6 +738,9 @@ static void __exit octeon_wdt_cleanup(void)
 		/* Free the interrupt handler */
 		free_irq(OCTEON_IRQ_WDOG0 + core, octeon_wdt_poke_irq);
 	}
+
+	cpu_notifier_register_done();
+
 	/*
 	 * Disable the boot-bus memory, the code it points to is soon
 	 * to go missing.

