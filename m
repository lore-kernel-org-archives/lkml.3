Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab3GEGsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:48:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58762 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab3GEGsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:48:54 -0400
Date: Thu, 4 Jul 2013 23:48:28 -0700
From: tip-bot for Seiji Aguchi <tipbot@zytor.com>
Message-ID: <tip-4787c368a9bca39e173d702389ee2eaf0520abc1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, seiji.aguchi@hds.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, seiji.aguchi@hds.com, tglx@linutronix.de
In-Reply-To: <51CDCFA3.9080101@hds.com>
References: <51CDCFA3.9080101@hds.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/tracing: Add irq_enter/exit()
  in smp_trace_reschedule_interrupt()
Git-Commit-ID: 4787c368a9bca39e173d702389ee2eaf0520abc1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 04 Jul 2013 23:48:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4787c368a9bca39e173d702389ee2eaf0520abc1
Gitweb:     http://git.kernel.org/tip/4787c368a9bca39e173d702389ee2eaf0520abc1
Author:     Seiji Aguchi <seiji.aguchi@hds.com>
AuthorDate: Fri, 28 Jun 2013 14:02:11 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 2 Jul 2013 09:52:31 +0200

x86/tracing: Add irq_enter/exit() in smp_trace_reschedule_interrupt()

Reschedule vector tracepoints may be called in cpu idle state.
This causes lockdep check warning below.

The tracepoint requires rcu but for accuracy it also
requires irq_enter() (tracepoints record the irq context), thus,
the tracepoint interrupt handler should be calling irq_enter()
and not rcu_irq_enter() (irq_enter() calls rcu_irq_enter()).

So, add irq_enter/exit() to smp_trace_reschedule_interrupt()
with common pre/post processing functions, smp_entering_irq()
and exiting_irq() (exiting_irq() calls just irq_exit()
 in arch/x86/include/asm/apic.h),
because these can be shared among reschedule, call_function,
and call_function_single vectors.

[   50.720557] Testing event reschedule_exit:
[   50.721349]
[   50.721502] ===============================
[   50.721835] [ INFO: suspicious RCU usage. ]
[   50.722169] 3.10.0-rc6-00004-gcf910e8 #190 Not tainted
[   50.722582] -------------------------------
[   50.722915] /c/kernel-tests/src/linux/arch/x86/include/asm/trace/irq_vectors.h:50 suspicious rcu_dereference_check() usage!
[   50.723770]
[   50.723770] other info that might help us debug this:
[   50.723770]
[   50.724385]
[   50.724385] RCU used illegally from idle CPU!
[   50.724385] rcu_scheduler_active = 1, debug_locks = 0
[   50.725232] RCU used illegally from extended quiescent state!
[   50.725690] no locks held by swapper/0/0.
[   50.726010]
[   50.726010] stack backtrace:
[...]

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/51CDCFA3.9080101@hds.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
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
