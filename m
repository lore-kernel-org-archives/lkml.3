Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3H2U5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:57:37 -0400
Received: from mail-de.keymile.com ([195.8.104.250]:53340 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab3H2U5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:57:36 -0400
From: "Falauto, Gerlando" <Gerlando.Falauto@keymile.com>
To: "Falauto, Gerlando" <Gerlando.Falauto@keymile.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
CC: "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>
Date: Thu, 29 Aug 2013 22:56:50 +0200
Subject: kernel deadlock
Thread-Topic: kernel deadlock
Thread-Index: AQHOpPpIvso+e1NOskuHH261kV92Dw==
Message-ID: <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net>
References: <521F6D06.1040107@keymile.com>
In-Reply-To: <521F6D06.1040107@keymile.com>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Aug 2013 20:57:29.0118 (UTC) FILETIME=[5F7DC3E0:01CEA4FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I ran into the deadlock situation reported at the bottom.
Actually, on my latest 3.10 kernel for some reason I don't get the
report (the kernel just hangs for some reason), so it took me quite some
time to track it down.

Once I figured the trigger to the machine hanging was adjtimex(), I
reverted everything (between 3.9 to 3.10) that was touching
kernel/time/timekeeping/timekeeping.c and kernel/time/ntp.c, I double
checked that indeed the problem was not happening anymore, and finally
started bisecting, landing on the following offending commit.
THEN, and ONLY THEN, did I get the &%""ç+"% deadlock report.

Do you guys have any ideas what could be wrong and how to fix it?

Thank you,
Gerlando

commit 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40
Author: John Stultz <john.stultz@linaro.org>
Date:   Fri Mar 22 11:37:28 2013 -0700

     timekeeping: Hold timekeepering locks in do_adjtimex and hardpps

     In moving the NTP state to be protected by the timekeeping locks,
     be sure to acquire the timekeeping locks prior to calling
     ntp functions.

     Cc: Thomas Gleixner <tglx@linutronix.de>
     Cc: Richard Cochran <richardcochran@gmail.com>
     Cc: Prarit Bhargava <prarit@redhat.com>
     Signed-off-by: John Stultz <john.stultz@linaro.org>

=================================
[ INFO: inconsistent lock state ]
3.10.0-04864-g346ecc9-dirty #16 Not tainted
---------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
SAKEY/738 [HC0[0]:SC0[0]:HE1:SE1] takes:
  (timekeeper_lock){?.-...}, at: [<c004a3e4>] do_adjtimex+0x64/0xbc
{IN-HARDIRQ-W} state was registered at:
   [<c0055138>] __lock_acquire+0xabc/0x1bb8
   [<c0056838>] lock_acquire+0xa8/0x15c
   [<c04c14ec>] _raw_spin_lock_irqsave+0x50/0x64
   [<c00497a4>] do_timer+0x2c/0xa54
   [<c004e7f4>] tick_periodic+0x74/0x9c
   [<c004e834>] tick_handle_periodic+0x18/0x7c
   [<c001349c>] orion_timer_interrupt+0x24/0x34
   [<c0069c2c>] handle_irq_event_percpu+0x5c/0x300
   [<c0069f0c>] handle_irq_event+0x3c/0x5c
   [<c006c194>] handle_level_irq+0x8c/0xe8
   [<c0069574>] generic_handle_irq+0x30/0x4c
   [<c000951c>] handle_IRQ+0x30/0x84
   [<c04c2178>] __irq_svc+0x38/0xa0
   [<c06cf15c>] calibrate_delay+0x350/0x4e4
   [<c06986e0>] start_kernel+0x23c/0x2c4
   [<0000803c>] 0x803c
irq event stamp: 32358
hardirqs last  enabled at (32357): [<c0008c64>] ret_fast_syscall+0x24/0x44
hardirqs last disabled at (32358): [<c04c14bc>]
_raw_spin_lock_irqsave+0x20/0x64
softirqs last  enabled at (32160): [<c001e234>] __do_softirq+0x1b8/0x308
softirqs last disabled at (32137): [<c001e77c>] irq_exit+0xa0/0xd8

other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(timekeeper_lock);
   <Interrupt>
     lock(timekeeper_lock);

  *** DEADLOCK ***

1 lock held by SAKEY/738:
  #0:  (timekeeper_lock){?.-...}, at: [<c004a3e4>] do_adjtimex+0x64/0xbc

stack backtrace:
CPU: 0 PID: 738 Comm: SAKEY Not tainted 3.10.0-04864-g346ecc9-dirty #16
[<c000d67c>] (unwind_backtrace+0x0/0xf0) from [<c000b530>]
(show_stack+0x10/0x14)
[<c000b530>] (show_stack+0x10/0x14) from [<c04ba07c>]
(print_usage_bug.part.27+0x218/0x280)
[<c04ba07c>] (print_usage_bug.part.27+0x218/0x280) from [<c0053058>]
(mark_lock+0x538/0x6bc)
[<c0053058>] (mark_lock+0x538/0x6bc) from [<c005326c>]
(mark_held_locks+0x90/0x124)
[<c005326c>] (mark_held_locks+0x90/0x124) from [<c00533a8>]
(trace_hardirqs_on_caller+0xa8/0x23c)
[<c00533a8>] (trace_hardirqs_on_caller+0xa8/0x23c) from [<c04c1c60>]
(_raw_spin_unlock_irq+0x24/0x5c)
[<c04c1c60>] (_raw_spin_unlock_irq+0x24/0x5c) from [<c004ac8c>]
(__do_adjtimex+0x17c/0x65c)
[<c004ac8c>] (__do_adjtimex+0x17c/0x65c) from [<c004a404>]
(do_adjtimex+0x84/0xbc)
[<c004a404>] (do_adjtimex+0x84/0xbc) from [<c001d62c>]
(SyS_adjtimex+0x50/0xa8)
[<c001d62c>] (SyS_adjtimex+0x50/0xa8) from [<c0008c40>]
(ret_fast_syscall+0x0/0x44)

