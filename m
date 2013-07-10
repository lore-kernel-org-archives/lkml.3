Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab3GJOcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:32:51 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34214 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3GJOcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:32:50 -0400
Date: Wed, 10 Jul 2013 16:32:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fix
Message-ID: <20130710143246.GA28552@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 4787c368a9bca39e173d702389ee2eaf0520abc1 x86/tracing: Add irq_enter/exit() in smp_trace_reschedule_interrupt()

irq-tracing fixlet.

 Thanks,

	Ingo

------------------>
Seiji Aguchi (1):
      x86/tracing: Add irq_enter/exit() in smp_trace_reschedule_interrupt()


 arch/x86/kernel/smp.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index f4fe0b8..cdaa347 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -265,23 +265,30 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 	 */
 }
 
-void smp_trace_reschedule_interrupt(struct pt_regs *regs)
+static inline void smp_entering_irq(void)
 {
 	ack_APIC_irq();
+	irq_enter();
+}
+
+void smp_trace_reschedule_interrupt(struct pt_regs *regs)
+{
+	/*
+	 * Need to call irq_enter() before calling the trace point.
+	 * __smp_reschedule_interrupt() calls irq_enter/exit() too (in
+	 * scheduler_ipi(). This is OK, since those functions are allowed
+	 * to nest.
+	 */
+	smp_entering_irq();
 	trace_reschedule_entry(RESCHEDULE_VECTOR);
 	__smp_reschedule_interrupt();
 	trace_reschedule_exit(RESCHEDULE_VECTOR);
+	exiting_irq();
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
 }
 
-static inline void call_function_entering_irq(void)
-{
-	ack_APIC_irq();
-	irq_enter();
-}
-
 static inline void __smp_call_function_interrupt(void)
 {
 	generic_smp_call_function_interrupt();
@@ -290,14 +297,14 @@ static inline void __smp_call_function_interrupt(void)
 
 void smp_call_function_interrupt(struct pt_regs *regs)
 {
-	call_function_entering_irq();
+	smp_entering_irq();
 	__smp_call_function_interrupt();
 	exiting_irq();
 }
 
 void smp_trace_call_function_interrupt(struct pt_regs *regs)
 {
-	call_function_entering_irq();
+	smp_entering_irq();
 	trace_call_function_entry(CALL_FUNCTION_VECTOR);
 	__smp_call_function_interrupt();
 	trace_call_function_exit(CALL_FUNCTION_VECTOR);
@@ -312,14 +319,14 @@ static inline void __smp_call_function_single_interrupt(void)
 
 void smp_call_function_single_interrupt(struct pt_regs *regs)
 {
-	call_function_entering_irq();
+	smp_entering_irq();
 	__smp_call_function_single_interrupt();
 	exiting_irq();
 }
 
 void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
 {
-	call_function_entering_irq();
+	smp_entering_irq();
 	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
 	__smp_call_function_single_interrupt();
 	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
