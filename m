Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3K2Kou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:44:50 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45858 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3K2Kos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:44:48 -0500
Subject: [PATCH V4 1/9] powerpc: Free up the slot of
 PPC_MSG_CALL_FUNC_SINGLE IPI message
To: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Fri, 29 Nov 2013 16:11:26 +0530
Message-ID: <20131129104126.651.47022.stgit@preeti.in.ibm.com>
In-Reply-To: <20131129104010.651.23117.stgit@preeti.in.ibm.com>
References: <20131129104010.651.23117.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112910-0928-0000-0000-00000423B0E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

The IPI handlers for both PPC_MSG_CALL_FUNC and PPC_MSG_CALL_FUNC_SINGLE map
to a common implementation - generic_smp_call_function_single_interrupt(). So,
we can consolidate them and save one of the IPI message slots, (which are
precious on powerpc, since only 4 of those slots are available).

So, implement the functionality of PPC_MSG_CALL_FUNC_SINGLE using
PPC_MSG_CALL_FUNC itself and release its IPI message slot, so that it can be
used for something else in the future, if desired.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
Acked-by: Geoff Levand <geoff@infradead.org> [For the PS3 part]
---

 arch/powerpc/include/asm/smp.h          |    2 +-
 arch/powerpc/kernel/smp.c               |   12 +++++-------
 arch/powerpc/platforms/cell/interrupt.c |    2 +-
 arch/powerpc/platforms/ps3/smp.c        |    2 +-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
index 084e080..9f7356b 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -120,7 +120,7 @@ extern int cpu_to_core_id(int cpu);
  * in /proc/interrupts will be wrong!!! --Troy */
 #define PPC_MSG_CALL_FUNCTION   0
 #define PPC_MSG_RESCHEDULE      1
-#define PPC_MSG_CALL_FUNC_SINGLE	2
+#define PPC_MSG_UNUSED		2
 #define PPC_MSG_DEBUGGER_BREAK  3
 
 /* for irq controllers that have dedicated ipis per message (4) */
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index a3b64f3..c2bd8d6 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -145,9 +145,9 @@ static irqreturn_t reschedule_action(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t call_function_single_action(int irq, void *data)
+static irqreturn_t unused_action(int irq, void *data)
 {
-	generic_smp_call_function_single_interrupt();
+	/* This slot is unused and hence available for use, if needed */
 	return IRQ_HANDLED;
 }
 
@@ -168,14 +168,14 @@ static irqreturn_t debug_ipi_action(int irq, void *data)
 static irq_handler_t smp_ipi_action[] = {
 	[PPC_MSG_CALL_FUNCTION] =  call_function_action,
 	[PPC_MSG_RESCHEDULE] = reschedule_action,
-	[PPC_MSG_CALL_FUNC_SINGLE] = call_function_single_action,
+	[PPC_MSG_UNUSED] = unused_action,
 	[PPC_MSG_DEBUGGER_BREAK] = debug_ipi_action,
 };
 
 const char *smp_ipi_name[] = {
 	[PPC_MSG_CALL_FUNCTION] =  "ipi call function",
 	[PPC_MSG_RESCHEDULE] = "ipi reschedule",
-	[PPC_MSG_CALL_FUNC_SINGLE] = "ipi call function single",
+	[PPC_MSG_UNUSED] = "ipi unused",
 	[PPC_MSG_DEBUGGER_BREAK] = "ipi debugger",
 };
 
@@ -251,8 +251,6 @@ irqreturn_t smp_ipi_demux(void)
 			generic_smp_call_function_interrupt();
 		if (all & IPI_MESSAGE(PPC_MSG_RESCHEDULE))
 			scheduler_ipi();
-		if (all & IPI_MESSAGE(PPC_MSG_CALL_FUNC_SINGLE))
-			generic_smp_call_function_single_interrupt();
 		if (all & IPI_MESSAGE(PPC_MSG_DEBUGGER_BREAK))
 			debug_ipi_action(0, NULL);
 	} while (info->messages);
@@ -280,7 +278,7 @@ EXPORT_SYMBOL_GPL(smp_send_reschedule);
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	do_message_pass(cpu, PPC_MSG_CALL_FUNC_SINGLE);
+	do_message_pass(cpu, PPC_MSG_CALL_FUNCTION);
 }
 
 void arch_send_call_function_ipi_mask(const struct cpumask *mask)
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 2d42f3b..adf3726 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -215,7 +215,7 @@ void iic_request_IPIs(void)
 {
 	iic_request_ipi(PPC_MSG_CALL_FUNCTION);
 	iic_request_ipi(PPC_MSG_RESCHEDULE);
-	iic_request_ipi(PPC_MSG_CALL_FUNC_SINGLE);
+	iic_request_ipi(PPC_MSG_UNUSED);
 	iic_request_ipi(PPC_MSG_DEBUGGER_BREAK);
 }
 
diff --git a/arch/powerpc/platforms/ps3/smp.c b/arch/powerpc/platforms/ps3/smp.c
index 4b35166..00d1a7c 100644
--- a/arch/powerpc/platforms/ps3/smp.c
+++ b/arch/powerpc/platforms/ps3/smp.c
@@ -76,7 +76,7 @@ static int __init ps3_smp_probe(void)
 
 		BUILD_BUG_ON(PPC_MSG_CALL_FUNCTION    != 0);
 		BUILD_BUG_ON(PPC_MSG_RESCHEDULE       != 1);
-		BUILD_BUG_ON(PPC_MSG_CALL_FUNC_SINGLE != 2);
+		BUILD_BUG_ON(PPC_MSG_UNUSED	      != 2);
 		BUILD_BUG_ON(PPC_MSG_DEBUGGER_BREAK   != 3);
 
 		for (i = 0; i < MSG_COUNT; i++) {

