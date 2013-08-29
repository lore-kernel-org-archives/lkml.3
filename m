Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab3H2Xp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:45:28 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35591 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3H2Xp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:45:26 -0400
Message-ID: <521FDD12.7050000@linaro.org>
Date: Thu, 29 Aug 2013 16:45:22 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Falauto, Gerlando" <Gerlando.Falauto@keymile.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>
Subject: Re: kernel deadlock
References: <521F6D06.1040107@keymile.com> <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net>
In-Reply-To: <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2013 01:56 PM, Falauto, Gerlando wrote:
> Hi everyone,
>
> I ran into the deadlock situation reported at the bottom.
> Actually, on my latest 3.10 kernel for some reason I don't get the
> report (the kernel just hangs for some reason), so it took me quite some
> time to track it down.
>
> Once I figured the trigger to the machine hanging was adjtimex(), I
> reverted everything (between 3.9 to 3.10) that was touching
> kernel/time/timekeeping/timekeeping.c and kernel/time/ntp.c, I double
> checked that indeed the problem was not happening anymore, and finally
> started bisecting, landing on the following offending commit.
> THEN, and ONLY THEN, did I get the &%""ç+"% deadlock report.
>
> Do you guys have any ideas what could be wrong and how to fix it?

Thanks for the report!

What exactly is your process for reproducing the issue?


> [ INFO: inconsistent lock state ]
> 3.10.0-04864-g346ecc9-dirty #16 Not tainted
> ---------------------------------
> inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
> SAKEY/738 [HC0[0]:SC0[0]:HE1:SE1] takes:
>   (timekeeper_lock){?.-...}, at: [<c004a3e4>] do_adjtimex+0x64/0xbc
> {IN-HARDIRQ-W} state was registered at:
>    [<c0055138>] __lock_acquire+0xabc/0x1bb8
>    [<c0056838>] lock_acquire+0xa8/0x15c
>    [<c04c14ec>] _raw_spin_lock_irqsave+0x50/0x64
>    [<c00497a4>] do_timer+0x2c/0xa54
>    [<c004e7f4>] tick_periodic+0x74/0x9c
>    [<c004e834>] tick_handle_periodic+0x18/0x7c
>    [<c001349c>] orion_timer_interrupt+0x24/0x34
>    [<c0069c2c>] handle_irq_event_percpu+0x5c/0x300
>    [<c0069f0c>] handle_irq_event+0x3c/0x5c
>    [<c006c194>] handle_level_irq+0x8c/0xe8
>    [<c0069574>] generic_handle_irq+0x30/0x4c
>    [<c000951c>] handle_IRQ+0x30/0x84
>    [<c04c2178>] __irq_svc+0x38/0xa0
>    [<c06cf15c>] calibrate_delay+0x350/0x4e4
>    [<c06986e0>] start_kernel+0x23c/0x2c4
>    [<0000803c>] 0x803c
> irq event stamp: 32358
> hardirqs last  enabled at (32357): [<c0008c64>] ret_fast_syscall+0x24/0x44
> hardirqs last disabled at (32358): [<c04c14bc>]
> _raw_spin_lock_irqsave+0x20/0x64
> softirqs last  enabled at (32160): [<c001e234>] __do_softirq+0x1b8/0x308
> softirqs last disabled at (32137): [<c001e77c>] irq_exit+0xa0/0xd8
>
> other info that might help us debug this:
>   Possible unsafe locking scenario:
>
>         CPU0
>         ----
>    lock(timekeeper_lock);
>    <Interrupt>
>      lock(timekeeper_lock);
>
>   *** DEADLOCK ***
>
> 1 lock held by SAKEY/738:
>   #0:  (timekeeper_lock){?.-...}, at: [<c004a3e4>] do_adjtimex+0x64/0xbc
>
> stack backtrace:
> CPU: 0 PID: 738 Comm: SAKEY Not tainted 3.10.0-04864-g346ecc9-dirty #16
> [<c000d67c>] (unwind_backtrace+0x0/0xf0) from [<c000b530>]
> (show_stack+0x10/0x14)
> [<c000b530>] (show_stack+0x10/0x14) from [<c04ba07c>]
> (print_usage_bug.part.27+0x218/0x280)
> [<c04ba07c>] (print_usage_bug.part.27+0x218/0x280) from [<c0053058>]
> (mark_lock+0x538/0x6bc)
> [<c0053058>] (mark_lock+0x538/0x6bc) from [<c005326c>]
> (mark_held_locks+0x90/0x124)
> [<c005326c>] (mark_held_locks+0x90/0x124) from [<c00533a8>]
> (trace_hardirqs_on_caller+0xa8/0x23c)
> [<c00533a8>] (trace_hardirqs_on_caller+0xa8/0x23c) from [<c04c1c60>]
> (_raw_spin_unlock_irq+0x24/0x5c)
> [<c04c1c60>] (_raw_spin_unlock_irq+0x24/0x5c) from [<c004ac8c>]
> (__do_adjtimex+0x17c/0x65c)
> [<c004ac8c>] (__do_adjtimex+0x17c/0x65c) from [<c004a404>]
> (do_adjtimex+0x84/0xbc)
> [<c004a404>] (do_adjtimex+0x84/0xbc) from [<c001d62c>]
> (SyS_adjtimex+0x50/0xa8)
> [<c001d62c>] (SyS_adjtimex+0x50/0xa8) from [<c0008c40>]
> (ret_fast_syscall+0x0/0x44)

Hrmm. So I'm a little confused by the report, as we hold the write lock
on the timekeeper_lock disabling irqs, so I'm not sure I see how the irq
could trigger to cause the deadlock. In fact, all the timekeeper_lock
users save irqs.

Hrmm. I dunno. :(

Thomas, you have a guess?

Let me know how you trigger it and I'll see if I can't reproduce it myself.

thanks
-john



