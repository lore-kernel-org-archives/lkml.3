Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3F1SCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:02:35 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:54635 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3F1SCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:02:34 -0400
Message-ID: <51CDCFA3.9080101@hds.com>
Date: Fri, 28 Jun 2013 14:02:11 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org, rostedt@goodmis.org,
        hpa@zytor.com
CC: mingo@elte.hu, tglx@linutronix.de
Subject: [PATCH -tip] x86,trace: Add irq_enter/exit() in smp_trace_reschedule_interrupt()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-28_08:2013-06-28,2013-06-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1306280141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reschedule vector tracepoints may be called in cpu idle state.
This causes lockdep check warning below.

The tracepoint requires rcu but for accuracy it also
requires irq_enter() (tracepoints record the irq context), thus, the
tracepoint interrupt handler should be calling irq_enter() and not
rcu_irq_enter() (irq_enter() calls rcu_irq_enter()).

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
[   50.726359] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc6-00004-gcf910e8 #190
[   50.726965] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011

[   50.727417]  00000001 00000001 79c53f04 798bd9f9 79c53f2c 79077a70 79b412c6 79b41fd1
[   50.728159]  00000001 00000000 79c5ef8c 87147c58 00000000 79c55800 79c53f38 79010b65
[   50.728849]  79c52000 79c53f7c 798c720e 79c52000 79c5ef8c 00000004 00000000 79c55800
[   50.729532] Call Trace:
[   50.729730]  [<798bd9f9>] dump_stack+0x16/0x18
[   50.730072]  [<79077a70>] lockdep_rcu_suspicious+0xf2/0xfa
[   50.730498]  [<79010b65>] smp_trace_reschedule_interrupt+0x1c8/0x1d0
[   50.730979]  [<798c720e>] trace_reschedule_interrupt+0x36/0x3c
[   50.731214]  [<7901875f>] ? native_safe_halt+0x5/0x7
[   50.731214]  [<790085cc>] default_idle+0xb1/0x1e2
[   50.731214]  [<79008d05>] arch_cpu_idle+0xe/0x10
[   50.731214]  [<79069ddf>] cpu_startup_entry+0x1e4/0x2c3
[   50.731214]  [<798adb34>] rest_init+0x12c/0x132
[   50.731214]  [<798ada08>] ? __read_lock_failed+0x14/0x14
[   50.731214]  [<79d309e4>] start_kernel+0x38d/0x393
[   50.731214]  [<79d30489>] ? repair_env_string+0x51/0x51
[   50.731214]  [<79d302c3>] i386_start_kernel+0x79/0x7d
[   50.771947] OK
[   50.772099] Testing event reschedule_entry: OK

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/kernel/smp.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

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
-- 
1.7.1

