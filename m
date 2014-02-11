Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaBKMTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:19:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaBKMTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:19:50 -0500
Date: Tue, 11 Feb 2014 04:18:08 -0800
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-47o4m03citrfg9y1vxic5asb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, nicolas.pitre@linaro.org, lethal@linux-sh.org,
        benh@kernel.crashing.org, linux@arm.linux.org.uk,
        preeti@linux.vnet.ibm.com, nico@linaro.org, tglx@linutronix.de,
        rjw@rjwysocki.net, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, nicolas.pitre@linaro.org, lethal@linux-sh.org,
        benh@kernel.crashing.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, nico@linaro.org, rjw@rjwysocki.net,
        tglx@linutronix.de, daniel.lezcano@linaro.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle, PPC:
  Remove redundant cpuidle_idle_call()
Git-Commit-ID: d8c6ad3184ca6516a5cf457af1afaa293d8f09c0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:18:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8c6ad3184ca6516a5cf457af1afaa293d8f09c0
Gitweb:     http://git.kernel.org/tip/d8c6ad3184ca6516a5cf457af1afaa293d8f09c0
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Wed, 29 Jan 2014 12:45:10 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Feb 2014 09:58:24 +0100

sched/idle, PPC: Remove redundant cpuidle_idle_call()

The core idle loop now takes care of it.  However a few things need
checking:

- Invocation of cpuidle_idle_call() in pseries_lpar_idle() happened
  through arch_cpu_idle() and was therefore always preceded by a call
  to ppc64_runlatch_off().  To preserve this property now that
  cpuidle_idle_call() is invoked directly from core code, a call to
  ppc64_runlatch_off() has been added to idle_loop_prolog() in
  platforms/pseries/processor_idle.c.

- Similarly, cpuidle_idle_call() was followed by ppc64_runlatch_off()
  so a call to the later has been added to idle_loop_epilog().

- And since arch_cpu_idle() always made sure to re-enable IRQs if they
  were not enabled, this is now
  done in idle_loop_epilog() as well.

The above was made in order to keep the execution flow close to the
original.  I don't know if that was strictly necessary. Someone well
aquainted with the platform details might find some room for possible
optimizations.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-sh@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linaro-kernel@lists.linaro.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-47o4m03citrfg9y1vxic5asb@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/platforms/pseries/setup.c | 34 ++++++++++++++--------------------
 drivers/cpuidle/cpuidle-pseries.c      |  5 +++++
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 8e639d7..c737d55 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -39,7 +39,6 @@
 #include <linux/irq.h>
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
-#include <linux/cpuidle.h>
 #include <linux/of.h>
 #include <linux/kexec.h>
 
@@ -356,29 +355,24 @@ early_initcall(alloc_dispatch_log_kmem_cache);
 
 static void pseries_lpar_idle(void)
 {
-	/* This would call on the cpuidle framework, and the back-end pseries
-	 * driver to  go to idle states
+	/*
+	 * Default handler to go into low thread priority and possibly
+	 * low power mode by cedeing processor to hypervisor
 	 */
-	if (cpuidle_idle_call()) {
-		/* On error, execute default handler
-		 * to go into low thread priority and possibly
-		 * low power mode by cedeing processor to hypervisor
-		 */
 
-		/* Indicate to hypervisor that we are idle. */
-		get_lppaca()->idle = 1;
+	/* Indicate to hypervisor that we are idle. */
+	get_lppaca()->idle = 1;
 
-		/*
-		 * Yield the processor to the hypervisor.  We return if
-		 * an external interrupt occurs (which are driven prior
-		 * to returning here) or if a prod occurs from another
-		 * processor. When returning here, external interrupts
-		 * are enabled.
-		 */
-		cede_processor();
+	/*
+	 * Yield the processor to the hypervisor.  We return if
+	 * an external interrupt occurs (which are driven prior
+	 * to returning here) or if a prod occurs from another
+	 * processor. When returning here, external interrupts
+	 * are enabled.
+	 */
+	cede_processor();
 
-		get_lppaca()->idle = 0;
-	}
+	get_lppaca()->idle = 0;
 }
 
 /*
diff --git a/drivers/cpuidle/cpuidle-pseries.c b/drivers/cpuidle/cpuidle-pseries.c
index 7ab564a..d486489 100644
--- a/drivers/cpuidle/cpuidle-pseries.c
+++ b/drivers/cpuidle/cpuidle-pseries.c
@@ -29,6 +29,7 @@ static struct cpuidle_state *cpuidle_state_table;
 
 static inline void idle_loop_prolog(unsigned long *in_purr)
 {
+	ppc64_runlatch_off();
 	*in_purr = mfspr(SPRN_PURR);
 	/*
 	 * Indicate to the HV that we are idle. Now would be
@@ -45,6 +46,10 @@ static inline void idle_loop_epilog(unsigned long in_purr)
 	wait_cycles += mfspr(SPRN_PURR) - in_purr;
 	get_lppaca()->wait_state_cycles = cpu_to_be64(wait_cycles);
 	get_lppaca()->idle = 0;
+
+	if (irqs_disabled())
+		local_irq_enable();
+	ppc64_runlatch_on();
 }
 
 static int snooze_loop(struct cpuidle_device *dev,
