Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaEWOhQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:37:16 -0400
Received: from mail1.windriver.com ([147.11.146.13]:46666 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaEWOhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:37:14 -0400
Message-ID: <537F5CEE.5000409@windriver.com>
Date: Fri, 23 May 2014 10:36:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: BUG: sleeping function called from invalid context (do_force_sig_info)
References: <537E83C0.9040406@meduna.org>
In-Reply-To: <537E83C0.9040406@meduna.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-05-22 07:09 PM, Stanislav Meduna wrote:
> Hi,
> 
> this is on a i.MX28 running a 3.12.19-rt30
> 
> [27284.008123] BUG: sleeping function called from invalid context at /home/nxtdev/Kernels/linux-stable-rt/kernel/rtmutex.c:673
> [27284.008143] in_atomic(): 0, irqs_disabled(): 128, pid: 1335, name: nxt

Would be worthwhile to enable irq on/off debugging so you get the
output from print_irqtrace_events() here to see who last futzed with
interrupts.  Probably a broken driver leaving interrupts off?

> [27284.008170] CPU: 0 PID: 1335 Comm: nxt Not tainted 3.12.19-rt30+ #178
> [27284.008255] [<c0014440>] (unwind_backtrace+0x0/0xf4) from [<c00124cc>] (show_stack+0x10/0x14)
> [27284.008306] [<c00124cc>] (show_stack+0x10/0x14) from [<c028b6a8>] (rt_spin_lock+0x18/0x2c)
> [27284.008348] [<c028b6a8>] (rt_spin_lock+0x18/0x2c) from [<c002a7ec>] (do_force_sig_info+0x20/0xd8)
> [27284.008387] [<c002a7ec>] (do_force_sig_info+0x20/0xd8) from [<c0016720>] (__do_user_fault+0x88/0xc8)

Dies because of non-raw siglock in do_force_sig_info:

        spin_lock_irqsave(&t->sighand->siglock, flags);

and we aren't going to convert that one to raw either.

> [27284.008419] [<c0016720>] (__do_user_fault+0x88/0xc8) from [<c0016c2c>] (do_bad_area+0x64/0x70)
> [27284.008452] [<c0016c2c>] (do_bad_area+0x64/0x70) from [<c0016ca4>] (do_translation_fault+0x6c/0xa8)
> [27284.008483] [<c0016ca4>] (do_translation_fault+0x6c/0xa8) from [<c000867c>] (do_DataAbort+0x34/0x98)
> [27284.008520] [<c000867c>] (do_DataAbort+0x34/0x98) from [<c0012ebc>] (__dabt_usr+0x3c/0x40)
> [27284.008531] Exception stack(0xc1173fb0 to 0xc1173ff8)
> [27284.008554] 3fa0:                                     b6634b48 d6634b44 d6634a94 07ffffff
> [27284.008583] 3fc0: b6634c1c b6ef1160 b6ef1000 00000152 b6635460 b6ee6b34 00000000 b6634b4c
> [27284.008605] 3fe0: 00000152 b6634a80 001f813c 00203888 60000010 ffffffff
> 
> There are some changes to the stock 3.12.19-rt30 (added drivers) where
> I can not exclude that there is some bug lurking, and a bug in userspace
> is even more probable; I am just forwarding it because of the sleeping
> from invalid context thing.
> 
> After a reboot I am unfortunately not able to easily reproduce it. There
> was no core dump (they are enabled) and the application did not exit
> (there is no SEGV handler).

It is calling user_fault and not kernel_fault, so if you create a broken
program that intentionally tries to stomp on memory it doesn't own, can
you then reproduce it?   You might not, if the culprit leaving IRQs off
only does so sporadically -- in which case you'd want to keep re-launching
the broken program in a tight loop while exercising the various drivers.

Paul.
--

> 
> Thanks
> 
