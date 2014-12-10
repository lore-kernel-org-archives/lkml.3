Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaLJKqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:46:08 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41266 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaLJKqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:46:06 -0500
Date: Wed, 10 Dec 2014 11:46:24 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Richard Weinberger <richard@nod.at>
Cc: Ley Foon Tan <lftan@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: [BUG] uml panics with "Segfault with no mm" in v3.19-rc
Message-ID: <20141210104624.GB32280@tucsk.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The guilty commit is:

  00f634bc522d "asm-generic: add generic futex for !CONFIG_SMP"

And the backtrace:

#0  0x00007ffff7866457 in kill () from /lib64/libc.so.6
#1  0x000000006002a454 in uml_abort () at arch/um/os-Linux/util.c:93
#2  0x000000006002a7e5 in os_dump_core () at arch/um/os-Linux/util.c:148
#3  0x000000006001b48a in panic_exit (self=<optimized out>, unused1=<optimized out>, unused2=<optimized out>) at arch/um/kernel/um_arch.c:240
#4  0x000000006004e4df in notifier_call_chain (nl=<optimized out>, val=6, v=0xffffffff, nr_to_call=-1, nr_calls=0x0) at kernel/notifier.c:93
#5  0x000000006004e558 in __atomic_notifier_call_chain (nr_calls=<optimized out>, nr_to_call=<optimized out>, v=<optimized out>, val=<optimized out>, nh=<optimized out>) at kernel/notifier.c:183
#6  atomic_notifier_call_chain (nh=<optimized out>, val=<optimized out>, v=<optimized out>) at kernel/notifier.c:193
#7  0x0000000060238570 in panic (fmt=<optimized out>) at kernel/panic.c:133
#8  0x000000006001ad91 in segv (fi=..., ip=1610803493, is_user=<optimized out>, regs=0x602c1840 <cpu0_irqstack+6208>) at arch/um/kernel/trap.c:218
#9  0x000000006001b0f8 in segv_handler (sig=<optimized out>, unused_si=<optimized out>, regs=<optimized out>) at arch/um/kernel/trap.c:191
#10 0x0000000060029238 in sig_handler_common (sig=11, si=0x602c1d30 <cpu0_irqstack+7472>, mc=<optimized out>) at arch/um/os-Linux/signal.c:44
#11 0x0000000060029304 in sig_handler (sig=<optimized out>, si=<optimized out>, mc=<optimized out>) at arch/um/os-Linux/signal.c:231
#12 0x0000000060028dfd in hard_handler (sig=<optimized out>, si=0x6, p=<optimized out>) at arch/um/os-Linux/signal.c:165
#13 <signal handler called>
#14 memcpy () at arch/x86/um/../lib/memcpy_64.S:160
#15 0x000000006001c13d in copy_from_user (to=0x61c49e28, from=<optimized out>, n=<optimized out>) at arch/um/kernel/skas/uaccess.c:145
#16 0x0000000060072618 in futex_atomic_cmpxchg_inatomic (newval=<optimized out>, oldval=<optimized out>, uaddr=<optimized out>, uval=<optimized out>) at include/asm-generic/futex.h:109
#17 cmpxchg_futex_value_locked (curval=0x61c49e28, uaddr=0x0, uval=<optimized out>, newval=<optimized out>) at kernel/futex.c:596
#18 0x0000000060008b70 in futex_detect_cmpxchg () at kernel/futex.c:3020
#19 futex_init () at kernel/futex.c:3043
#20 0x00000000600166ba in do_one_initcall (fn=0x60008adf <futex_init>) at init/main.c:791

Thanks,
Miklos
