Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaFPS2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:28:18 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39606 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbaFPS2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:28:16 -0400
Message-ID: <539F373D.9070100@gmail.com>
Date: Mon, 16 Jun 2014 14:28:13 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-raid@vger.kernel.org
Subject: 3.16-rc1 kernel BUG triggered at mutex.c:586
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to boot 3.16.0-rc1+ (the + is a small vlan related patch) on a
tests system triggers the following BUG:

Jun 16 13:54:50 scratch kernel: BUG: sleeping function called from
invalid context at kernel/locking/mutex.c:586
Jun 16 13:54:50 scratch kernel: in_atomic(): 1, irqs_disabled(): 1, pid:
0, name: swapper/3
Jun 16 13:54:50 scratch kernel: 1 lock held by swapper/3/0:
Jun 16 13:54:50 scratch kernel: #0:
(&(&bitmap->counts.lock)->rlock){..-...}, at: [<ffffffff815729e8>]
bitmap_endwrite+0x58/0x230
Jun 16 13:54:50 scratch kernel: irq event stamp: 211959
Jun 16 13:54:50 scratch kernel: hardirqs last  enabled at (211958):
[<ffffffff8170f4d6>] _raw_spin_unlock_irqrestore+0x36/0x70
Jun 16 13:54:50 scratch kernel: hardirqs last disabled at (211959):
[<ffffffff8170fba9>] _raw_spin_lock_irqsave+0x29/0x70
Jun 16 13:54:50 scratch kernel: softirqs last  enabled at (211952):
[<ffffffff8108bab2>] _local_bh_enable+0x22/0x50
Jun 16 13:54:50 scratch kernel: softirqs last disabled at (211953):
[<ffffffff8108cc15>] irq_exit+0xc5/0xd0
Jun 16 13:54:50 scratch kernel: CPU: 3 PID: 0 Comm: swapper/3 Not
tainted 3.16.0-rc1+ #35
Jun 16 13:54:50 scratch kernel: Hardware name: Hewlett-Packard HP xw8400
Workstation/0A08h, BIOS 786D5 v02.38 10/25/2010
Jun 16 13:54:50 scratch kernel: 0000000000000000 ffff88047fcc3bd0
ffffffff81706ef2 ffffffff81c857e0
Jun 16 13:54:50 scratch kernel: ffff88047fcc3be0 ffffffff810b4dba
ffff88047fcc3c50 ffffffff8170c79c
Jun 16 13:54:50 scratch kernel: 0000000000000000 ffffffff81c85938
0000000000000046 0000000000000092
Jun 16 13:54:50 scratch kernel: Call Trace:
Jun 16 13:54:50 scratch kernel: <IRQ>  [<ffffffff81706ef2>]
dump_stack+0x4d/0x66
Jun 16 13:54:50 scratch kernel: [<ffffffff810b4dba>]
__might_sleep+0xfa/0x130
Jun 16 13:54:50 scratch kernel: [<ffffffff8170c79c>]
mutex_lock_nested+0x3c/0x3a0
Jun 16 13:54:50 scratch kernel: [<ffffffff81270f5a>]
kernfs_notify+0x8a/0x140
Jun 16 13:54:50 scratch kernel: [<ffffffff81572a49>]
bitmap_endwrite+0xb9/0x230
Jun 16 13:54:50 scratch kernel: [<ffffffffa027a823>]
close_write+0x93/0xb0 [raid1]
Jun 16 13:54:50 scratch kernel: [<ffffffffa027af89>]
r1_bio_write_done+0x29/0x50 [raid1]
Jun 16 13:54:50 scratch kernel: [<ffffffffa027c98f>]
raid1_end_write_request+0xcf/0x220 [raid1]
Jun 16 13:54:50 scratch kernel: [<ffffffff8132f0bb>] bio_endio+0x5b/0xa0
Jun 16 13:54:50 scratch kernel: [<ffffffff81335f60>]
blk_update_request+0x90/0x330
Jun 16 13:54:50 scratch kernel: [<ffffffff8133621c>]
blk_update_bidi_request+0x1c/0x80
Jun 16 13:54:50 scratch kernel: [<ffffffff8133656f>]
blk_end_bidi_request+0x1f/0x60
Jun 16 13:54:50 scratch kernel: [<ffffffff813365c0>]
blk_end_request+0x10/0x20
Jun 16 13:54:50 scratch kernel: [<ffffffff81497194>]
scsi_io_completion+0xf4/0x6e0
Jun 16 13:54:50 scratch kernel: [<ffffffff8148c613>]
scsi_finish_command+0xb3/0x110
Jun 16 13:54:50 scratch kernel: [<ffffffff81496fb7>]
scsi_softirq_done+0x137/0x160
Jun 16 13:54:50 scratch kernel: [<ffffffff8133cfe0>]
blk_done_softirq+0x90/0xb0
Jun 16 13:54:50 scratch kernel: [<ffffffff8108c705>]
__do_softirq+0x125/0x300
Jun 16 13:54:50 scratch kernel: [<ffffffff8108cc15>] irq_exit+0xc5/0xd0
Jun 16 13:54:50 scratch kernel: [<ffffffff810439d5>]
smp_call_function_single_interrupt+0x35/0x40
Jun 16 13:54:50 scratch kernel: [<ffffffff81711552>]
call_function_single_interrupt+0x72/0x80
Jun 16 13:54:50 scratch kernel: <EOI>  [<ffffffff81053fa6>] ?
native_safe_halt+0x6/0x10
Jun 16 13:54:50 scratch kernel: [<ffffffff810d891d>] ?
trace_hardirqs_on+0xd/0x10
Jun 16 13:54:50 scratch kernel: [<ffffffff8101e0c4>] default_idle+0x24/0xe0
Jun 16 13:54:50 scratch kernel: [<ffffffff8101ea6f>] arch_cpu_idle+0xf/0x20
Jun 16 13:54:50 scratch kernel: [<ffffffff810d0d1b>]
cpu_startup_entry+0x2cb/0x450
Jun 16 13:54:50 scratch kernel: [<ffffffff810fed4c>] ?
clockevents_register_device+0xbc/0x120
Jun 16 13:54:50 scratch kernel: [<ffffffff810442ee>]
start_secondary+0x1de/0x290
Jun 16 13:54:50 scratch kernel:
Jun 16 13:54:50 scratch kernel: =================================
Jun 16 13:54:50 scratch kernel: [ INFO: inconsistent lock state ]
Jun 16 13:54:50 scratch kernel: 3.16.0-rc1+ #35 Not tainted
Jun 16 13:54:50 scratch kernel: ---------------------------------
Jun 16 13:54:50 scratch kernel: inconsistent {SOFTIRQ-ON-W} ->
{IN-SOFTIRQ-W} usage.
Jun 16 13:54:50 scratch kernel: swapper/3/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
Jun 16 13:54:50 scratch kernel: (kernfs_mutex){+.?.+.}, at:
[<ffffffff81270f5a>] kernfs_notify+0x8a/0x140
Jun 16 13:54:50 scratch kernel: {SOFTIRQ-ON-W} state was registered at:
Jun 16 13:54:50 scratch kernel:  [<ffffffff810d8f66>]
__lock_acquire+0x316/0x1a60
Jun 16 13:54:50 scratch kernel:  [<ffffffff810dae72>]
lock_acquire+0xa2/0x130
Jun 16 13:54:50 scratch kernel:  [<ffffffff8170c7ca>]
mutex_lock_nested+0x6a/0x3a0
Jun 16 13:54:50 scratch kernel:  [<ffffffff8127066f>]
kernfs_activate+0x1f/0xf0
Jun 16 13:54:50 scratch kernel:  [<ffffffff81270a08>]
kernfs_create_root+0xe8/0x110
Jun 16 13:54:50 scratch kernel:  [<ffffffff81d73567>] sysfs_init+0x13/0x51
Jun 16 13:54:50 scratch kernel:  [<ffffffff81d70d06>] mnt_init+0x118/0x225
Jun 16 13:54:50 scratch kernel:  [<ffffffff81d70923>]
vfs_caches_init+0x99/0x115
Jun 16 13:54:50 scratch kernel:  [<ffffffff81d43022>]
start_kernel+0x3ec/0x443
Jun 16 13:54:50 scratch kernel:  [<ffffffff81d425ee>]
x86_64_start_reservations+0x2a/0x2c
Jun 16 13:54:50 scratch kernel:  [<ffffffff81d4272e>]
x86_64_start_kernel+0x13e/0x14d
Jun 16 13:54:50 scratch kernel: irq event stamp: 211959
Jun 16 13:54:50 scratch kernel: hardirqs last  enabled at (211958):
[<ffffffff8170f4d6>] _raw_spin_unlock_irqrestore+0x36/0x70
Jun 16 13:54:50 scratch kernel: hardirqs last disabled at (211959):
[<ffffffff8170fba9>] _raw_spin_lock_irqsave+0x29/0x70
Jun 16 13:54:50 scratch kernel: softirqs last  enabled at (211952):
[<ffffffff8108bab2>] _local_bh_enable+0x22/0x50
Jun 16 13:54:50 scratch kernel: softirqs last disabled at (211953):
[<ffffffff8108cc15>] irq_exit+0xc5/0xd0
Jun 16 13:54:50 scratch kernel:
other info that might help us debug this:
Jun 16 13:54:50 scratch kernel: Possible unsafe locking scenario:

Jun 16 13:54:50 scratch kernel:       CPU0
Jun 16 13:54:50 scratch kernel:       ----
Jun 16 13:54:50 scratch kernel:  lock(kernfs_mutex);
Jun 16 13:54:50 scratch kernel:  <Interrupt>
Jun 16 13:54:50 scratch kernel:    lock(kernfs_mutex);
Jun 16 13:54:50 scratch kernel:
 *** DEADLOCK ***

Jun 16 13:54:50 scratch kernel: 1 lock held by swapper/3/0:
Jun 16 13:54:50 scratch kernel: #0:
(&(&bitmap->counts.lock)->rlock){..-...}, at: [<ffffffff815729e8>]
bitmap_endwrite+0x58/0x230
Jun 16 13:54:50 scratch kernel:
stack backtrace:
Jun 16 13:54:50 scratch kernel: CPU: 3 PID: 0 Comm: swapper/3 Not
tainted 3.16.0-rc1+ #35
Jun 16 13:54:50 scratch kernel: Hardware name: Hewlett-Packard HP xw8400
Workstation/0A08h, BIOS 786D5 v02.38 10/25/2010
Jun 16 13:54:50 scratch kernel: ffffffff82638c50 ffff88047fcc3a20
ffffffff81706ef2 ffff8804695edb40
Jun 16 13:54:50 scratch kernel: ffff88047fcc3a70 ffffffff81702a16
0000000000000001 ffff880400000000
Jun 16 13:54:50 scratch kernel: ffff880400000000 0000000000000006
ffff8804695edb40 ffffffff810d7c20
Jun 16 13:54:50 scratch kernel: Call Trace:
Jun 16 13:54:50 scratch kernel: <IRQ>  [<ffffffff81706ef2>]
dump_stack+0x4d/0x66
Jun 16 13:54:50 scratch kernel: [<ffffffff81702a16>]
print_usage_bug+0x1f3/0x204
Jun 16 13:54:50 scratch kernel: [<ffffffff810d7c20>] ?
check_usage_backwards+0x140/0x140
Jun 16 13:54:50 scratch kernel: [<ffffffff810d8622>] mark_lock+0x222/0x2b0
Jun 16 13:54:50 scratch kernel: [<ffffffff810d8f08>]
__lock_acquire+0x2b8/0x1a60
Jun 16 13:54:50 scratch kernel: [<ffffffff8101779d>] ?
show_trace_log_lvl+0x4d/0x60
Jun 16 13:54:50 scratch kernel: [<ffffffff810163f4>] ?
show_stack_log_lvl+0xa4/0x190
Jun 16 13:54:50 scratch kernel: [<ffffffff810dae72>] lock_acquire+0xa2/0x130
Jun 16 13:54:50 scratch kernel: [<ffffffff81270f5a>] ?
kernfs_notify+0x8a/0x140
Jun 16 13:54:50 scratch kernel: [<ffffffff8170c7ca>]
mutex_lock_nested+0x6a/0x3a0
Jun 16 13:54:50 scratch kernel: [<ffffffff81270f5a>] ?
kernfs_notify+0x8a/0x140
Jun 16 13:54:50 scratch kernel: [<ffffffff81270f5a>]
kernfs_notify+0x8a/0x140
Jun 16 13:54:50 scratch kernel: [<ffffffff81572a49>]
bitmap_endwrite+0xb9/0x230
Jun 16 13:54:50 scratch kernel: [<ffffffffa027a823>]
close_write+0x93/0xb0 [raid1]
Jun 16 13:54:50 scratch kernel: [<ffffffffa027af89>]
r1_bio_write_done+0x29/0x50 [raid1]
Jun 16 13:54:50 scratch kernel: [<ffffffffa027c98f>]
raid1_end_write_request+0xcf/0x220 [raid1]
Jun 16 13:54:50 scratch kernel: [<ffffffff8132f0bb>] bio_endio+0x5b/0xa0
Jun 16 13:54:50 scratch kernel: [<ffffffff81335f60>]
blk_update_request+0x90/0x330
Jun 16 13:54:50 scratch kernel: [<ffffffff8133621c>]
blk_update_bidi_request+0x1c/0x80
Jun 16 13:54:50 scratch kernel: [<ffffffff8133656f>]
blk_end_bidi_request+0x1f/0x60
Jun 16 13:54:50 scratch kernel: [<ffffffff813365c0>]
blk_end_request+0x10/0x20
Jun 16 13:54:50 scratch kernel: [<ffffffff81497194>]
scsi_io_completion+0xf4/0x6e0
Jun 16 13:54:50 scratch kernel: [<ffffffff8148c613>]
scsi_finish_command+0xb3/0x110
Jun 16 13:54:50 scratch kernel: [<ffffffff81496fb7>]
scsi_softirq_done+0x137/0x160
Jun 16 13:54:50 scratch kernel: [<ffffffff8133cfe0>]
blk_done_softirq+0x90/0xb0
Jun 16 13:54:50 scratch kernel: [<ffffffff8108c705>]
__do_softirq+0x125/0x300
Jun 16 13:54:50 scratch kernel: [<ffffffff8108cc15>] irq_exit+0xc5/0xd0
Jun 16 13:54:50 scratch kernel: [<ffffffff810439d5>]
smp_call_function_single_interrupt+0x35/0x40
Jun 16 13:54:50 scratch kernel: [<ffffffff81711552>]
call_function_single_interrupt+0x72/0x80
Jun 16 13:54:50 scratch kernel: <EOI>  [<ffffffff81053fa6>] ?
native_safe_halt+0x6/0x10
Jun 16 13:54:50 scratch kernel: [<ffffffff810d891d>] ?
trace_hardirqs_on+0xd/0x10
Jun 16 13:54:50 scratch kernel: [<ffffffff8101e0c4>] default_idle+0x24/0xe0
Jun 16 13:54:50 scratch kernel: [<ffffffff8101ea6f>] arch_cpu_idle+0xf/0x20
Jun 16 13:54:50 scratch kernel: [<ffffffff810d0d1b>]
cpu_startup_entry+0x2cb/0x450
Jun 16 13:54:50 scratch kernel: [<ffffffff810fed4c>] ?
clockevents_register_device+0xbc/0x120
Jun 16 13:54:50 scratch kernel: [<ffffffff810442ee>]
start_secondary+0x1de/0x290

Is this a known issue?  Are there any patches I can help
test?

Thanks
-vlad
