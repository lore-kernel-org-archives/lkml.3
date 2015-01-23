Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbbAWPxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:53:45 -0500
Received: from relay.parallels.com ([195.214.232.42]:48729 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbbAWPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:53:43 -0500
Message-ID: <1422028412.6345.6.camel@tkhai>
Subject: [RFC] sched, x86: Prevent resched interrupts if task in kernel mode
 and !CONFIG_PREEMPT
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 23 Jan 2015 18:53:32 +0300
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's useless to send reschedule interrupts in such situations. The earliest
point, where schedule() call is possible, is sysret_careful(). But in that
function we directly test TIF_NEED_RESCHED.

So it's possible to get rid of that type of interrupts.

How about this idea? Is set_bit() cheap on x86 machines?
---
 arch/x86/kernel/entry_64.S |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c653dc4..a046ba8 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -409,6 +409,13 @@ GLOBAL(system_call_after_swapgs)
 	movq_cfi rax,(ORIG_RAX-ARGOFFSET)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
+#if !defined(CONFIG_PREEMPT) || !defined(SMP)
+	/*
+	 * Tell resched_curr() do not send useless interrupts to us.
+	 * Kernel isn't preemptible till sysret_careful() anyway.
+	 */
+	LOCK ; bts $TIF_POLLING_NRFLAG,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+#endif
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz tracesys
 system_call_fastpath:
@@ -427,6 +434,9 @@ GLOBAL(system_call_after_swapgs)
  * Has incomplete stack frame and undefined top of stack.
  */
 ret_from_sys_call:
+#if !defined(CONFIG_PREEMPT) || !defined(SMP)
+	LOCK ; btr $TIF_POLLING_NRFLAG,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
+#endif
 	movl $_TIF_ALLWORK_MASK,%edi
 	/* edi:	flagmask */
 sysret_check:



