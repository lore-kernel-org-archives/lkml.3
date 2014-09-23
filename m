Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaIWAJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:09:54 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35246 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaIWAJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:09:53 -0400
Date: Mon, 22 Sep 2014 17:09:49 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>
Subject: kernel BUG at kernel/smpboot.c:134!
Message-ID: <20140923000949.GV1193@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm asking here just to see if anyone had any good suggestions for me
here, or if the BUG() I hit looks familiar to anyone; I'm not expecting
anyone to solve my problem for me.

I've been testing out CPU hotplug [1] on an ARM v7 A15-based SMP system,
and I've seen various sorts of oopses, crashes, etc., most of which seem
to be in the scheduler code. Sometimes my $PC is somewhere out in the
weeds (jumping to 0x00000000, or some address not in the kernel text
region).

Anyway, the most promising result--for debugging purposes--was when I
was toggling CPU#1 on/off with a loop like this:

	while :
	do
		echo 0 > /sys/devices/system/cpu/cpu1/online
		echo 1 > /sys/devices/system/cpu/cpu1/online
	done

which managed to trigger the following BUG(), after about 4700 cycles
(oddly, on multiple occasions, failures happen at around 4700 to 4800
cycles):

...
[  164.737561] CPU1: Booted secondary processor
[  164.785821] CPU1: shutdown
[  164.788883] ------------[ cut here ]------------
[  164.793537] kernel BUG at kernel/smpboot.c:134!
[  164.793540] Internal error: Oops - BUG: 0 [#1] SMP ARM
[  164.793547] Modules linked in:
[  164.793553] CPU: 2 PID: 3 Comm: ksoftirqd/0 Not tainted 3.14.13-1.0pre-00342-g95275cee3dcd #220
[  164.793557] task: cd087140 ti: cd09a000 task.ti: cd09a000
[  164.793569] PC is at smpboot_thread_fn+0x174/0x17c
[  164.793572] LR is at smpboot_thread_fn+0x40/0x17c
[  164.793576] pc : [<c0046bb4>]    lr : [<c0046a80>]    psr: 800f0013
[  164.793576] sp : cd09bf40  ip : 00000000  fp : 00000000
[  164.793577] r10: cd09a000  r9 : 00000002  r8 : 00000000
[  164.793580] r7 : 00000001  r6 : c0f89548  r5 : cd09a000  r4 : cd03abc0
[  164.793582] r3 : 00000002  r2 : cd09bf40  r1 : 00000000  r0 : 00000000
[  164.793586] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  164.793589] Control: 30c5387d  Table: 0d35b5c0  DAC: 55555555
[  164.793592] Process ksoftirqd/0 (pid: 3, stack limit = 0xcd09a240)
[  164.793594] Stack: (0xcd09bf40 to 0xcd09c000)
[  164.793600] bf40: cd087140 cd03ab80 00000000 cd03abc0 c0046a40 00000000 00000000 00000000
[  164.793604] bf60: 00000000 c0040424 52bdbfb4 00000001 00000000 cd03abc0 00000000 00030003
[  164.793608] bf80: cd09bf80 cd09bf80 00000000 00000000 cd09bf90 cd09bf90 cd09bfac cd03ab80
[  164.793611] bfa0: c0040350 00000000 00000000 c000edb8 00000000 00000000 00000000 00000000
[  164.793614] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[  164.793617] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 87fd818d 2b1a63eb
[  164.793630] [<c0046bb4>] (smpboot_thread_fn) from [<c0040424>] (kthread+0xd4/0xec)
[  164.793639] [<c0040424>] (kthread) from [<c000edb8>] (ret_from_fork+0x14/0x3c)
[  164.793644] Code: e1a00004 eb0204ba e3a00000 e8bd8ff8 (e7f001f2) 
[  164.793651] ---[ end trace d7127a76ecca6b80 ]---

This test is on a 3.14.13-based kernel, but I retested on a more recent
kernel (around 3.17-rc3), and I see very similar corruption and failures
(although I haven't yet triggered this specific BUG() in my limited
testing).

Any comments are welcome. I'll try to remember to update here if I
figure anything out.

Thanks,
Brian

[1] I actually encountered errors while testing suspend-to-RAM, but I
    (correctly) suspected the problems were occurring in the hotplug /
    disable_nonboot_cpus() code path.
