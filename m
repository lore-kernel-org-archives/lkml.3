Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbaFQDoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:44:15 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37377 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbaFQDoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:44:13 -0400
Message-ID: <1402976650.5151.10.camel@marge.simpson.net>
Subject: Re: 3.16-rc1 kernel BUG triggered at mutex.c:586
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Date: Tue, 17 Jun 2014 05:44:10 +0200
In-Reply-To: <539F373D.9070100@gmail.com>
References: <539F373D.9070100@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 14:28 -0400, Vlad Yasevich wrote: 
> Trying to boot 3.16.0-rc1+ (the + is a small vlan related patch) on a
> tests system triggers the following BUG:

It's easier for developers to read if you dump dmesg, or at least tell
your mail client to please not make a line-wrapped mess of your report.

<replaces the gawd awful mess your mailer made> 

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586
in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/3
1 lock held by swapper/3/0:
#0: (&(&bitmap->counts.lock)->rlock){..-...}, at: [<ffffffff815729e8>] bitmap_endwrite+0x58/0x230 211959
hardirqs last  enabled at (211958): [<ffffffff8170f4d6>] _raw_spin_unlock_irqrestore+0x36/0x70
hardirqs last disabled at (211959): [<ffffffff8170fba9>] _raw_spin_lock_irqsave+0x29/0x70
softirqs last  enabled at (211952): [<ffffffff8108bab2>] _local_bh_enable+0x22/0x50
softirqs last disabled at (211953): [<ffffffff8108cc15>] irq_exit+0xc5/0xd0
swapper/3 Not tainted 3.16.0-rc1+ #35 Hewlett-Packard HP xw8400 Workstation/0A08h, BIOS 786D5 v02.38 10/25/2010
0000000000000000 ffff88047fcc3bd0
ffffffff81706ef2 ffffffff81c857e0
ffff88047fcc3be0 ffffffff810b4dba
ffff88047fcc3c50 ffffffff8170c79c
0000000000000000 ffffffff81c85938
0000000000000046 0000000000000092
Call Trace:
<IRQ>
[<ffffffff81706ef2>] dump_stack+0x4d/0x66
[<ffffffff810b4dba>] __might_sleep+0xfa/0x130
[<ffffffff8170c79c>] mutex_lock_nested+0x3c/0x3a0
[<ffffffff81270f5a>] kernfs_notify+0x8a/0x140
[<ffffffff81572a49>] bitmap_endwrite+0xb9/0x230
[<ffffffffa027a823>] close_write+0x93/0xb0 [raid1]
[<ffffffffa027af89>] r1_bio_write_done+0x29/0x50 [raid1]
[<ffffffffa027c98f>] raid1_end_write_request+0xcf/0x220 [raid1]
[<ffffffff8132f0bb>] bio_endio+0x5b/0xa0
[<ffffffff81335f60>] blk_update_request+0x90/0x330
[<ffffffff8133621c>] blk_update_bidi_request+0x1c/0x80
[<ffffffff8133656f>] blk_end_bidi_request+0x1f/0x60
[<ffffffff813365c0>] blk_end_request+0x10/0x20
[<ffffffff81497194>] scsi_io_completion+0xf4/0x6e0
[<ffffffff8148c613>] scsi_finish_command+0xb3/0x110
[<ffffffff81496fb7>] scsi_softirq_done+0x137/0x160
[<ffffffff8133cfe0>] blk_done_softirq+0x90/0xb0
[<ffffffff8108c705>] __do_softirq+0x125/0x300
[<ffffffff8108cc15>] irq_exit+0xc5/0xd0
[<ffffffff810439d5>] smp_call_function_single_interrupt+0x35/0x40
[<ffffffff81711552>] call_function_single_interrupt+0x72/0x80
<EOI>
[<ffffffff81053fa6>] ?  native_safe_halt+0x6/0x10
[<ffffffff810d891d>] ?  trace_hardirqs_on+0xd/0x10
[<ffffffff8101e0c4>] default_idle+0x24/0xe0
[<ffffffff8101ea6f>] arch_cpu_idle+0xf/0x20
[<ffffffff810d0d1b>] cpu_startup_entry+0x2cb/0x450
[<ffffffff810fed4c>] ?  clockevents_register_device+0xbc/0x120
[<ffffffff810442ee>] start_secondary+0x1de/0x290
=================================

inconsistent lock state ]
3.16.0-rc1+ #35 Not tainted
---------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/3/0 [HC0[0]:SC1[1]:HE0:SE0] takes: (kernfs_mutex){+.?.+.}, at: [<ffffffff81270f5a>] kernfs_notify+0x8a/0x140
{SOFTIRQ-ON-W} state was registered at:
 [<ffffffff810d8f66>] __lock_acquire+0x316/0x1a60
 [<ffffffff810dae72>] lock_acquire+0xa2/0x130
 [<ffffffff8170c7ca>] mutex_lock_nested+0x6a/0x3a0
 [<ffffffff8127066f>] kernfs_activate+0x1f/0xf0
 [<ffffffff81270a08>] kernfs_create_root+0xe8/0x110
 [<ffffffff81d73567>] sysfs_init+0x13/0x51
 [<ffffffff81d70d06>] mnt_init+0x118/0x225
 [<ffffffff81d70923>] vfs_caches_init+0x99/0x115
 [<ffffffff81d43022>] start_kernel+0x3ec/0x443
 [<ffffffff81d425ee>] x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81d4272e>] x86_64_start_kernel+0x13e/0x14d
211959 hardirqs last  enabled at (211958): [<ffffffff8170f4d6>] _raw_spin_unlock_irqrestore+0x36/0x70
hardirqs last disabled at (211959): [<ffffffff8170fba9>] _raw_spin_lock_irqsave+0x29/0x70
softirqs last  enabled at (211952): [<ffffffff8108bab2>] _local_bh_enable+0x22/0x50
softirqs last disabled at (211953): [<ffffffff8108cc15>] irq_exit+0xc5/0xd0

other info that might help us debug this:
Possible unsafe locking scenario:

      CPU0
      ----
 lock(kernfs_mutex);
 <Interrupt>
 lock(kernfs_mutex);

 *** DEADLOCK ***

1 lock held by swapper/3/0:
#0: (&(&bitmap->counts.lock)->rlock){..-...}, at: [<ffffffff815729e8>] bitmap_endwrite+0x58/0x230
stack backtrace: swapper/3 Not tainted 3.16.0-rc1+ #35 Hewlett-Packard HP xw8400 Workstation/0A08h, BIOS 786D5 v02.38 10/25/2010
ffffffff82638c50 ffff88047fcc3a20
ffffffff81706ef2 ffff8804695edb40
ffff88047fcc3a70 ffffffff81702a16
0000000000000001 ffff880400000000
ffff880400000000 0000000000000006
ffff8804695edb40 ffffffff810d7c20
Call Trace:
<IRQ>
[<ffffffff81706ef2>] dump_stack+0x4d/0x66
[<ffffffff81702a16>] print_usage_bug+0x1f3/0x204
[<ffffffff810d7c20>] ?  check_usage_backwards+0x140/0x140
[<ffffffff810d8622>] mark_lock+0x222/0x2b0
[<ffffffff810d8f08>] __lock_acquire+0x2b8/0x1a60
[<ffffffff8101779d>] ?  show_trace_log_lvl+0x4d/0x60
[<ffffffff810163f4>] ?  show_stack_log_lvl+0xa4/0x190
[<ffffffff810dae72>] lock_acquire+0xa2/0x130
[<ffffffff81270f5a>] ?  kernfs_notify+0x8a/0x140
[<ffffffff8170c7ca>] mutex_lock_nested+0x6a/0x3a0
[<ffffffff81270f5a>] ?  kernfs_notify+0x8a/0x140
[<ffffffff81270f5a>] kernfs_notify+0x8a/0x140
[<ffffffff81572a49>] bitmap_endwrite+0xb9/0x230
[<ffffffffa027a823>] close_write+0x93/0xb0 [raid1]
[<ffffffffa027af89>] r1_bio_write_done+0x29/0x50 [raid1]
[<ffffffffa027c98f>] raid1_end_write_request+0xcf/0x220 [raid1]
[<ffffffff8132f0bb>] bio_endio+0x5b/0xa0
[<ffffffff81335f60>] blk_update_request+0x90/0x330
[<ffffffff8133621c>] blk_update_bidi_request+0x1c/0x80
[<ffffffff8133656f>] blk_end_bidi_request+0x1f/0x60
[<ffffffff813365c0>] blk_end_request+0x10/0x20
[<ffffffff81497194>] scsi_io_completion+0xf4/0x6e0
[<ffffffff8148c613>] scsi_finish_command+0xb3/0x110
[<ffffffff81496fb7>] scsi_softirq_done+0x137/0x160
[<ffffffff8133cfe0>] blk_done_softirq+0x90/0xb0
[<ffffffff8108c705>] __do_softirq+0x125/0x300
[<ffffffff8108cc15>] irq_exit+0xc5/0xd0
[<ffffffff810439d5>] smp_call_function_single_interrupt+0x35/0x40
[<ffffffff81711552>] call_function_single_interrupt+0x72/0x80
<EOI>
[<ffffffff81053fa6>] ?  native_safe_halt+0x6/0x10
[<ffffffff810d891d>] ?  trace_hardirqs_on+0xd/0x10
[<ffffffff8101e0c4>] default_idle+0x24/0xe0
[<ffffffff8101ea6f>] arch_cpu_idle+0xf/0x20
[<ffffffff810d0d1b>] cpu_startup_entry+0x2cb/0x450
[<ffffffff810fed4c>] ?  clockevents_register_device+0xbc/0x120
[<ffffffff810442ee>] start_secondary+0x1de/0x290


> Is this a known issue?  Are there any patches I can help
> test?

