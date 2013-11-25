Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3KYDUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 22:20:41 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50761 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3KYDUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 22:20:39 -0500
Message-ID: <1385349629.21903.4.camel@phoenix>
Subject: ARM: nommu: DEBUG_LOCKS_WARN_ON(!depth)
From: Axel Lin <axel.lin@ingics.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 25 Nov 2013 11:20:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing on a nommu platform (arm7tdmi SoC).
Using current Linus' tree + out-of-tree patches for this SoC.
I got below hang while executing ls (busybox) after boot.

/ # ls
[   51.036191] ------------[ cut here ]------------
[   51.042242] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:3312 lock_set_class+0x5c8/0x660()
[   51.051426] DEBUG_LOCKS_WARN_ON(!depth)
[   51.055842] CPU: 0 PID: 1 Comm:  Not tainted 3.13.0-rc1-00100-g4b061f7-dirty #1917
[   51.065415] [<0000c430>] (unwind_backtrace+0x0/0xe0) from [<0000ae58>] (show_stack+0x10/0x14)
[   51.075781] [<0000ae58>] (show_stack+0x10/0x14) from [<0000f7b0>] (warn_slowpath_common+0x58/0x78)
[   51.086549] [<0000f7b0>] (warn_slowpath_common+0x58/0x78) from [<0000f814>] (warn_slowpath_fmt+0x2c/0x3c)
[   51.098162] [<0000f814>] (warn_slowpath_fmt+0x2c/0x3c) from [<00036d9c>] (lock_set_class+0x5c8/0x660)
[   50.934805] [<00036d9c>] (lock_set_class+0x5c8/0x660) from [<000367d4>] (lock_set_class+0x0/0x660)
[   50.945255] [<000367d4>] (lock_set_class+0x0/0x660) from [<00000000>] (  (null))
[   50.953242] ---[ end trace 7d1e4eb800000001 ]---

BTW, I also hit below hangup once a few days ago (just before 3.13-rc1 release).

below is my timers config:
#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

/ # ls /bin
[   81.272231] BUG: scheduling while atomic: ls/33/0x0037a001
[   81.284450] 2 locks held by ls/33:
[   81.292221]  #0: [   81.292221]  #0:  ( (&type->i_mutex_dir_key&type->i_mutex_dir_key){+.+.+.}){+.+.+.}[   81.304370] BUG: recent printk recursion!
[   81.304370] BUG: recent printk recursion!
, at: , at: [<0006c9c8>] lookup_slow+0x30/0xa0
[<0006c9c8>] lookup_slow+0x30/0xa0
[   81.323810]  #1: [   81.323810]  #1:  ( (&sb->s_type->i_lock_key&sb->s_type->i_lock_key#13#13){+.+...}){+.+...}, at: , at: [<000764cc>] d_instantia8
[<000764cc>] d_instantiate+0x28/0x48
[   81.345069] irq event stamp: 3753
[   81.352717] hardirqs last  enabled at (3753): [   81.352717] hardirqs last  enabled at (3753): [<002943dc>] _raw_spin_unlock_irqrestore+0x3c/0x5c
[<002943dc>] _raw_spin_unlock_irqrestore+0x3c/0x5c
[   81.372183] hardirqs last disabled at (3752): [   81.372183] hardirqs last disabled at (3752): [<00294254>] _raw_spin_lock_irqsave+0x1c/0x68
[<00294254>] _raw_spin_lock_irqsave+0x1c/0x68
[   81.216282] softirqs last  enabled at (3712): [   81.216282] softirqs last  enabled at (3712): [<000127ec>] __do_softirq+0x190/0x20c
[<000127ec>] __do_softirq+0x190/0x20c
[   81.233554] softirqs last disabled at (3705): [   81.233554] softirqs last disabled at (3705): [<00012c1c>] irq_exit+0x90/0xb8
[<00012c1c>] irq_exit+0x90/0xb8
[   81.250354] CPU: 0 PID: 0 Comm: ���z Tainted: G        W    3.12.0-11171-g6adc047-dirty #1911
[   81.270570] [<0000c430>] (unwind_backtrace+0x0/0xe0) from [<0000ae58>] (show_stack+0x10/0x14)
[   81.290277] [<0000ae58>] (show_stack+0x10/0x14) from [<0028dd8c>] (__schedule_bug+0x5c/0x74)
[   81.309935] [<0028dd8c>] (__schedule_bug+0x5c/0x74) from [<00290c00>] (__schedule+0x58/0x38c)
[   81.329818] [<00290c00>] (__schedule+0x58/0x38c) from [<002908f4>] (do_nanosleep+0x78/0xd0)
[   81.349258] [<002908f4>] (do_nanosleep+0x78/0xd0) from [<00029418>] (hrtimer_nanosleep+0x88/0x10c)
[   81.369874] [<00029418>] (hrtimer_nanosleep+0x88/0x10c) from [<00025680>] (common_nsleep+0x0/0x20)

Thanks for any comments and advices.
Regards,
Axel


