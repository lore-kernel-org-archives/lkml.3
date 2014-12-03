Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaLCDqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 22:46:09 -0500
Received: from mail-2.alumni.tu-berlin.de ([130.149.5.29]:36257 "EHLO
	mail-2.alumni.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbaLCDqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 22:46:07 -0500
X-tubIT-Incoming-IP: 66.181.131.84
Message-ID: <547E8779.6030900@slac.stanford.edu>
Date: Tue, 02 Dec 2014 19:46:01 -0800
From: Till Straumann <strauman@slac.stanford.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] BUG: sleeping function called from invalid context (arm CONFIG_PREEMPT_RT_FULL
 )
In-Reply-To: 547D27AE.5070900@slac.stanford.edu
Content-Type: multipart/mixed;
 boundary="------------090602040803090109040104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090602040803090109040104
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

OK. I think I could come up with a fix. It mirrors what the x86 code does:

1. Let arch-dependent (arm) signal.h defines ARCH_RT_DELAYS_SIGNAL_SEND 
(ifdef CONFIG_PREEMPT_RT_FULL)
2. This causes the vanilla force_sig_info() code to defer the actual 
work until later, setting
    the TIF_NOTIFY_RESUME flag. However, the existing code only tests 
'in_atomic()' - which I replaced
    by '(in_atomic() || irqs_disabled())'. Seems X86 does never call 
this with IRQs disabled - otherwise
    it would trigger a BUG message, too (since the check tests both 
conditions).
3. I added a few lines to ARM's 'do_work_pending' which are analogous to 
the code in X86's 'do_notify_resume()'.
    The addition causes the deferred force_sig_info() to be executed at 
a point where interrupts are
    enabled.

Patch against vanilla 3.14.12 with rt9 preempt patch applied.

With this patch applied I no longer receive the BUG message.

HTH
-Till


> I - very reproducibly - get this 'BUG' message
>
> [ 6462.460032] Unhandled fault: external abort on non-linefetch (0x018) at 0xb6fdd000
> [ 6462.460042] BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:905
> [ 6462.460049] in_atomic(): 0, irqs_disabled(): 128, pid: 1488, name: ldfilt
> [ 6462.460053] no locks held by ldfilt/1488.
> [ 6462.460057] irq event stamp: 1790
> [ 6462.460081] hardirqs last  enabled at (1789): [<c000ed10>] no_work_pending+0x8/0x2c
> [ 6462.460096] hardirqs last disabled at (1790): [<c05bf834>] __dabt_usr+0x34/0x40
> [ 6462.460116] softirqs last  enabled at (0): [<c0021594>] copy_process.part.50+0x498/0x170c
> [ 6462.460124] softirqs last disabled at (0): [<  (null)>]   (null)
> [ 6462.460135] CPU: 0 PID: 1488 Comm: ldfilt Tainted: G           O 3.14.12-rt9-xilinx #25
> [ 6462.460161] [<c0015f6c>] (unwind_backtrace) from [<c0012cc0>] (show_stack+0x20/0x24)
> [ 6462.460182] [<c0012cc0>] (show_stack) from [<c05ba9ac>] (dump_stack+0x7c/0xcc)
> [ 6462.460208] [<c05ba9ac>] (dump_stack) from [<c00574b8>] (__might_sleep+0x1a0/0x1d8)
> [ 6462.460225] [<c00574b8>] (__might_sleep) from [<c05bea40>] (rt_spin_lock+0x30/0x64)
> [ 6462.460240] [<c05bea40>] (rt_spin_lock) from [<c0036b44>] (force_sig_info+0x38/0xe8)
> [ 6462.460254] [<c0036b44>] (force_sig_info) from [<c00130c0>] (arm_notify_die+0x50/0x60)
> [ 6462.460266] [<c00130c0>] (arm_notify_die) from [<c000845c>] (do_DataAbort+0x94/0xa8)
> [ 6462.460280] [<c000845c>] (do_DataAbort) from [<c05bf83c>] (__dabt_usr+0x3c/0x40)
> [ 6462.460285] Exception stack(0xd2e65fb0 to 0xd2e65ff8)
> [ 6462.460295] 5fa0:                                     0189d008 00000001 00001000 b6fdd000
> [ 6462.460308] 5fc0: 00011cf0 b6fbc078 0189d008 00009530 00000000 be9b9ad0 ffffffff 00000000
> [ 6462.460317] 5fe0: 00000000 be9b9a98 b6fa6c30 00008ad4 20000010 ffffffff
> [ 6462.478073] Unhandled fault: external abort on non-linefetch (0x018) at 0xb6f2a000
>
> on my CONFIG_PREEMPT_RT_FULL system:
> #uname -a
> Linux buildroot 3.14.12-rt9 #25 SMP PREEMPT RT Fri Nov 28 09:42:05 PST 2014 armv7l GNU/Linux
>
> when accessing a mmapped, non-existing device from user-space.
>
> I'm not an ARM expert but I suspect that when the exception is taken
> interrupts are disabled and probably not re-enabled by the exception
> handler (irqs_disabled(): 128).
>
> arm_notify_die() calls force_sig_info() which may block (under RT_PREEMPT_FULL).
>
> In 'force_sig_info()' we find
>
> /*
>  * On some archs, PREEMPT_RT has to delay sending a signal from a trap
>  * since it can not enable preemption, and the signal code's spin_locks
>  * turn into mutexes. Instead, it must set TIF_NOTIFY_RESUME which will
>  * send the signal on exit of the trap.
>  */
> #ifdef ARCH_RT_DELAYS_SIGNAL_SEND
>
> and if this CPP symbol is defined there is a codepath that
> delays signal delivery and never blocks.
>
> Perhaps the arm support should use this facility?
>
> Unfortunately I'm not familiar enough with this CPU arch to propose
> a fix.
>
> Best regards
> - Till
>
> PS: Please CC me on any replies since I'm not a lkml subscriber; thanks.

--------------090602040803090109040104
Content-Type: text/x-patch;
 name="linux-3.14.12-rt9-sleeping_fcn_bug.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linux-3.14.12-rt9-sleeping_fcn_bug.diff"

--- linux-3.14.12/kernel/signal.c.orig	2014-12-02 18:50:24.472593199 -0800
+++ linux-3.14.12/kernel/signal.c	2014-12-02 18:56:35.581041811 -0800
@@ -1340,7 +1340,7 @@
  * send the signal on exit of the trap.
  */
 #ifdef ARCH_RT_DELAYS_SIGNAL_SEND
-	if (in_atomic()) {
+	if (in_atomic() || irqs_disabled()) {
 		if (WARN_ON_ONCE(t != current))
 			return 0;
 		if (WARN_ON_ONCE(t->forced_info.si_signo))
--- linux-3.14.12/arch/arm/kernel/signal.c.orig	2014-12-02 18:30:13.275058413 -0800
+++ linux-3.14.12/arch/arm/kernel/signal.c	2014-12-02 18:33:24.727574197 -0800
@@ -592,6 +593,15 @@
 				}
 				syscall = 0;
 			} else {
+
+#ifdef ARCH_RT_DELAYS_SIGNAL_SEND
+				if (unlikely(current->forced_info.si_signo)) {
+					struct task_struct *t = current;
+					force_sig_info(t->forced_info.si_signo,	&t->forced_info, t);
+					t->forced_info.si_signo = 0;
+				}
+#endif
+
 				clear_thread_flag(TIF_NOTIFY_RESUME);
 				tracehook_notify_resume(regs);
 			}
--- linux-3.14.12/arch/arm/include/asm/signal.h.orig	2014-12-02 18:28:12.469745395 -0800
+++ linux-3.14.12/arch/arm/include/asm/signal.h	2014-12-02 18:29:53.760172049 -0800
@@ -1,6 +1,20 @@
 #ifndef _ASMARM_SIGNAL_H
 #define _ASMARM_SIGNAL_H
 
+/*
+ * Because exceptions run with IRQs 
+ * disabled while calling arm_notify_die(), but arm_notify_die() may call
+ * force_sig_info() which will grab the signal spin_locks for the
+ * task, which in PREEMPT_RT_FULL are mutexes.  By defining
+ * ARCH_RT_DELAYS_SIGNAL_SEND the force_sig_info() will set
+ * TIF_NOTIFY_RESUME and set up the signal to be sent on exit of the
+ * trap.
+ */
+#if defined(CONFIG_PREEMPT_RT_FULL)
+#define ARCH_RT_DELAYS_SIGNAL_SEND
+#endif
+
+
 #include <uapi/asm/signal.h>
 
 /* Most things should be clean enough to redefine this at will, if care

--------------090602040803090109040104--
