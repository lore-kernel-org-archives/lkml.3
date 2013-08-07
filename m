Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab3HGVZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:25:37 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:53531 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342Ab3HGVZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:25:33 -0400
MIME-Version: 1.0
Date: Wed, 7 Aug 2013 23:25:32 +0200
Message-ID: <CAAfyv37GWJeT6WqWD-oHURzY8RGBjWnD9CpJ5V+48APXp0e+KA@mail.gmail.com>
Subject: next-20130807: possible circular locking dependency detected
From: Belisko Marek <marek.belisko@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this today when boot gta04 machine (dts is mostly same as for
beagle-xm) on today's linux-next (with 3.11-rc4 it's not happening):

[    4.404602] ======================================================
[    4.411102] [ INFO: possible circular locking dependency detected ]
[    4.417694] 3.11.0-rc4-next-20130807-dirty #2 Not tainted
[    4.423339] -------------------------------------------------------
[    4.429931] getty/767 is trying to acquire lock:
[    4.434783]  (&tty->termios_rwsem){++++..}, at: [<c0308f24>]
n_tty_read+0x3ec/0x958
[    4.442871]
[    4.442871] but task is already holding lock:
[    4.449005]  (&ldata->atomic_read_lock){+.+...}, at: [<c0309100>]
n_tty_read+0x5c8/0x958
[    4.457519]
[    4.457519] which lock already depends on the new lock.
[    4.457519]
[    4.466094]
[    4.466094] the existing dependency chain (in reverse order) is:
[    4.473968]
-> #1 (&ldata->atomic_read_lock){+.+...}:
[    4.479461]        [<c0099800>] lock_acquire+0xa0/0xfc
[    4.484893]        [<c0508a34>] mutex_lock_interruptible_nested+0x4c/0x420
[    4.492126]        [<c0309100>] n_tty_read+0x5c8/0x958
[    4.497528]        [<c030367c>] tty_read+0x78/0xc8
[    4.502563]        [<c0112ba8>] vfs_read+0x98/0x140
[    4.507690]        [<c01132a0>] SyS_read+0x3c/0x78
[    4.512725]        [<c0013b00>] ret_fast_syscall+0x0/0x48
[    4.518432]
-> #0 (&tty->termios_rwsem){++++..}:
[    4.523468]        [<c0098e50>] __lock_acquire+0x195c/0x1b08
[    4.529418]        [<c0099800>] lock_acquire+0xa0/0xfc
[    4.534820]        [<c050a178>] down_read+0x30/0x40
[    4.539947]        [<c0308f24>] n_tty_read+0x3ec/0x958
[    4.545349]        [<c030367c>] tty_read+0x78/0xc8
[    4.550384]        [<c0112ba8>] vfs_read+0x98/0x140
[    4.555511]        [<c01132a0>] SyS_read+0x3c/0x78
[    4.560546]        [<c0013b00>] ret_fast_syscall+0x0/0x48
[    4.566253]
[    4.566253] other info that might help us debug this:
[    4.566253]
[    4.574645]  Possible unsafe locking scenario:
[    4.574645]
[    4.580871]        CPU0                    CPU1
[    4.585601]        ----                    ----
[    4.590362]   lock(&ldata->atomic_read_lock);
[    4.594940]                                lock(&tty->termios_rwsem);
[    4.601715]                                lock(&ldata->atomic_read_lock);
[    4.608947]   lock(&tty->termios_rwsem);
[    4.613067]
[    4.613067]  *** DEADLOCK ***
[    4.613067]
[    4.619293] 2 locks held by getty/767:
[    4.623229]  #0:  (&tty->ldisc_sem){.+.+.+}, at: [<c030ac84>]
tty_ldisc_ref_wait+0x14/0x3c
[    4.631958]  #1:  (&ldata->atomic_read_lock){+.+...}, at:
[<c0309100>] n_tty_read+0x5c8/0x958
[    4.640930]
[    4.640930] stack backtrace:
[    4.645507] CPU: 0 PID: 767 Comm: getty Not tainted
3.11.0-rc4-next-20130807-dirty #2
[    4.653778] [<c001b8a4>] (unwind_backtrace+0x0/0xec) from
[<c0017af8>] (show_stack+0x10/0x14)
[    4.662719] [<c0017af8>] (show_stack+0x10/0x14) from [<c0506c88>]
(dump_stack+0x7c/0x94)
[    4.671234] [<c0506c88>] (dump_stack+0x7c/0x94) from [<c0504abc>]
(print_circular_bug+0x27c/0x2d0)
[    4.680633] [<c0504abc>] (print_circular_bug+0x27c/0x2d0) from
[<c0098e50>] (__lock_acquire+0x195c/0x1b08)
[    4.690795] [<c0098e50>] (__lock_acquire+0x195c/0x1b08) from
[<c0099800>] (lock_acquire+0xa0/0xfc)
[    4.700195] [<c0099800>] (lock_acquire+0xa0/0xfc) from [<c050a178>]
(down_read+0x30/0x40)
[    4.708801] [<c050a178>] (down_read+0x30/0x40) from [<c0308f24>]
(n_tty_read+0x3ec/0x958)
[    4.717407] [<c0308f24>] (n_tty_read+0x3ec/0x958) from [<c030367c>]
(tty_read+0x78/0xc8)
[    4.725891] [<c030367c>] (tty_read+0x78/0xc8) from [<c0112ba8>]
(vfs_read+0x98/0x140)
[    4.734130] [<c0112ba8>] (vfs_read+0x98/0x140) from [<c01132a0>]
(SyS_read+0x3c/0x78)
[    4.742370] [<c01132a0>] (SyS_read+0x3c/0x78) from [<c0013b00>]
(ret_fast_syscall+0x0/0x48)

marek
-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
