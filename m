Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826Ab3HNL6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:58:35 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49960 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692Ab3HNL6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:58:33 -0400
Subject: [RFC V2 PATCH 1/6] powerpc: Free up the IPI message slot of ipi
 call function (PPC_MSG_CALL_FUNC)
To: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, galak@kernel.crashing.org,
        deepthi@linux.vnet.ibm.com, benh@kernel.crashing.org,
        paulmck@linux.vnet.ibm.com, arnd@arndb.de, linux-pm@vger.kernel.org,
        rostedt@goodmis.org, rjw@sisk.pl, john.stultz@linaro.org,
        tglx@linutronix.de, chenhui.zhao@freescale.com, michael@ellerman.id.au,
        r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 14 Aug 2013 17:25:52 +0530
Message-ID: <20130814115552.5193.55070.stgit@preeti.in.ibm.com>
In-Reply-To: <20130814115311.5193.32212.stgit@preeti.in.ibm.com>
References: <20130814115311.5193.32212.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081411-0260-0000-0000-00000377C351
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

The IPI handlers for both PPC_MSG_CALL_FUNC and PPC_MSG_CALL_FUNC_SINGLE
map to a common implementation - generic_smp_call_function_single_interrupt().
So, we can consolidate them and save one of the IPI message slots, (which are
precious, since only 4 of those slots are available).

So, implement the functionality of PPC_MSG_CALL_FUNC using
PPC_MSG_CALL_FUNC_SINGLE itself and release its IPI message slot, so that it
can be used for something else in the future, if desired.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/smp.h          |    2 +-
 arch/powerpc/kernel/smp.c               |   12 +++++-------
 arch/powerpc/platforms/cell/interrupt.c |    2 +-
 arch/powerpc/platforms/ps3/smp.c        |    2 +-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/smp.h b/arch/powerpc/include/asm/smp.h
index ffbaabe..51bf017 100644
--- a/arch/powerpc/include/asm/smp.h
+++ b/arch/powerpc/include/asm/smp.h
@@ -117,7 +117,7 @@ extern int cpu_to_core_id(int cpu);
  *
  * Make sure this matches openpic_request_IPIs in open_pic.c, or what shows up
  * in /proc/interrupts will be wrong!!! --Troy */
-#define PPC_MSG_CALL_FUNCTION   0
+#define PPC_MSG_UNUSED		0
 #define PPC_MSG_RESCHEDULE      1
 #define PPC_MSG_CALL_FUNC_SINGLE	2
 #define PPC_MSG_DEBUGGER_BREAK  3
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 38b0ba6..bc41e9f 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -111,9 +111,9 @@ int smp_generic_kick_cpu(int nr)
 }
 #endif /* CONFIG_PPC64 */
 
-static irqreturn_t call_function_action(int irq, void *data)
+static irqreturn_t unused_action(int irq, void *data)
 {
-	generic_smp_call_function_interrupt();
+	/* This slot is unused and hence available for use, if needed */
 	return IRQ_HANDLED;
 }
 
@@ -144,14 +144,14 @@ static irqreturn_t debug_ipi_action(int irq, void *data)
 }
 
 static irq_handler_t smp_ipi_action[] = {
-	[PPC_MSG_CALL_FUNCTION] =  call_function_action,
+	[PPC_MSG_UNUSED] =  unused_action, /* Slot available for future use */
 	[PPC_MSG_RESCHEDULE] = reschedule_action,
 	[PPC_MSG_CALL_FUNC_SINGLE] = call_function_single_action,
 	[PPC_MSG_DEBUGGER_BREAK] = debug_ipi_action,
 };
 
 const char *smp_ipi_name[] = {
-	[PPC_MSG_CALL_FUNCTION] =  "ipi call function",
+	[PPC_MSG_UNUSED] =  "ipi unused",
 	[PPC_MSG_RESCHEDULE] = "ipi reschedule",
 	[PPC_MSG_CALL_FUNC_SINGLE] = "ipi call function single",
 	[PPC_MSG_DEBUGGER_BREAK] = "ipi debugger",
@@ -221,8 +221,6 @@ irqreturn_t smp_ipi_demux(void)
 		all = xchg(&info->messages, 0);
 
 #ifdef __BIG_ENDIAN
-		if (all & (1 << (24 - 8 * PPC_MSG_CALL_FUNCTION)))
-			generic_smp_call_function_interrupt();
 		if (all & (1 << (24 - 8 * PPC_MSG_RESCHEDULE)))
 			scheduler_ipi();
 		if (all & (1 << (24 - 8 * PPC_MSG_CALL_FUNC_SINGLE)))
@@ -265,7 +263,7 @@ void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 	unsigned int cpu;
 
 	for_each_cpu(cpu, mask)
-		do_message_pass(cpu, PPC_MSG_CALL_FUNCTION);
+		do_message_pass(cpu, PPC_MSG_CALL_FUNC_SINGLE);
 }
 
 #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
diff --git a/arch/powerpc/platforms/cell/interrupt.c b/arch/powerpc/platforms/cell/interrupt.c
index 2d42f3b..28166e4 100644
--- a/arch/powerpc/platforms/cell/interrupt.c
+++ b/arch/powerpc/platforms/cell/interrupt.c
@@ -213,7 +213,7 @@ static void iic_request_ipi(int msg)
 
 void iic_request_IPIs(void)
 {
-	iic_request_ipi(PPC_MSG_CALL_FUNCTION);
+	iic_request_ipi(PPC_MSG_UNUSED);
 	iic_request_ipi(PPC_MSG_RESCHEDULE);
 	iic_request_ipi(PPC_MSG_CALL_FUNC_SINGLE);
 	iic_request_ipi(PPC_MSG_DEBUGGER_BREAK);
diff --git a/arch/powerpc/platforms/ps3/smp.c b/arch/powerpc/platforms/ps3/smp.c
index 4b35166..488f069 100644
--- a/arch/powerpc/platforms/ps3/smp.c
+++ b/arch/powerpc/platforms/ps3/smp.c
@@ -74,7 +74,7 @@ static int __init ps3_smp_probe(void)
 		* to index needs to be setup.
 		*/
 
-		BUILD_BUG_ON(PPC_MSG_CALL_FUNCTION    != 0);
+		BUILD_BUG_ON(PPC_MSG_UNUSED	      != 0);
 		BUILD_BUG_ON(PPC_MSG_RESCHEDULE       != 1);
 		BUILD_BUG_ON(PPC_MSG_CALL_FUNC_SINGLE != 2);
 		BUILD_BUG_ON(PPC_MSG_DEBUGGER_BREAK   != 3);

