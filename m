Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaF2I01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 04:26:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbaF2I0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 04:26:23 -0400
Date: Sun, 29 Jun 2014 11:26:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Brian Lane <bcl@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: virt_blk BUG: sleeping function called from invalid context
Message-ID: <20140629082637.GA23942@redhat.com>
References: <CA+5PVA4h2hQJLrAm4eEZ8oUgGiAjq2y5eAyBcJWxK_FiQXnuQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4h2hQJLrAm4eEZ8oUgGiAjq2y5eAyBcJWxK_FiQXnuQg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 07:57:38AM -0400, Josh Boyer wrote:
> Hi All,
> 
> We've had a report[1] of the virt_blk driver causing a lot of spew
> because it's calling a sleeping function from an invalid context.  The
> backtrace is below.  This is with kernel v3.16-rc2-69-gd91d66e88ea9.

Hi Jens, pls see below - it looks like the call to blk_mq_end_io
from IRQ context is causing the issue.
IIUC you switched virtio to this from __blk_end_request_all in

commit 1cf7e9c68fe84248174e998922b39e508375e7c1
    virtio_blk: blk-mq support

Is this always safe?
I note that at least one other driver is doing this:
drivers/block/mtip32xx/mtip32xx.c

Thanks!

> The reporter is on CC and can give you relevant details.
> 
> josh
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1113805
> 
> [drm] Initialized bochs-drm 1.0.0 20130925 for 0000:00:02.0 on minor 0
>  virtio-pci 0000:00:05.0: irq 40 for MSI/MSI-X
>  virtio-pci 0000:00:05.0: irq 41 for MSI/MSI-X
>   vda: vda1 vda2
>  virtio-pci 0000:00:06.0: irq 42 for MSI/MSI-X
>  virtio-pci 0000:00:06.0: irq 43 for MSI/MSI-X
>   vdb: vdb1
>  tsc: Refined TSC clocksource calibration: 3392.169 MHz
>  md: bind<vdb1>
>  mdadm (350) used greatest stack depth: 12384 bytes left
>  md: bind<vda2>
>  md: raid1 personality registered for level 1
>  md/raid1:md127: active with 2 out of 2 mirrors
>  created bitmap (1 pages) for device md127
>  md127: bitmap initialized from disk: read 1 pages, set 0 of 153 bits
>  md127: detected capacity change from 0 to 10203693056
>   md127: unknown partition table
>  systemd-cryptsetup[358]: Set cipher aes, mode xts-plain64, key size
> 512 bits for device
> /dev/disk/by-uuid/6972a564-542d-498b-b3a0-7d71c2e966a2.
>   md127: unknown partition table
>   md127: unknown partition table
>  dracut-initqueue[296]: Scanning devices dm-0  for LVM logical volumes
> fedora-foo1/root fedora-foo1/swap fedora-foo1/root fedora-foo1/swap
>  dracut-initqueue[296]: inactive '/dev/fedora-foo1/root' [7.42 GiB] inherit
>  dracut-initqueue[296]: inactive '/dev/fedora-foo1/swap' [2.00 GiB] inherit
>  systemd-fsck[662]: /dev/mapper/fedora--foo1-root: clean, 22215/486720
> files, 222526/1944576 blocks
>  BUG: sleeping function called from invalid context at
> kernel/locking/mutex.c:586
>  in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/1
>  2 locks held by swapper/1/0:
>   #0:  (&(&vblk->vq_lock)->rlock){-.-...}, at: [<ffffffffa0039042>]
> virtblk_done+0x42/0xe0 [virtio_blk]
>   #1:  (&(&bitmap->counts.lock)->rlock){-.....}, at:
> [<ffffffff81633718>] bitmap_endwrite+0x68/0x240
>  irq event stamp: 33518
>  hardirqs last  enabled at (33515): [<ffffffff8102544f>] default_idle+0x1f/0x230
>  hardirqs last disabled at (33516): [<ffffffff818122ed>]
> common_interrupt+0x6d/0x72
>  softirqs last  enabled at (33518): [<ffffffff810a1272>]
> _local_bh_enable+0x22/0x50
>  softirqs last disabled at (33517): [<ffffffff810a29e0>] irq_enter+0x60/0x80
>  CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.16.0-0.rc2.git2.1.fc21.x86_64 #1
>  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>   0000000000000000 f90db13964f4ee05 ffff88007d403b80 ffffffff81807b4c
>   0000000000000000 ffff88007d403ba8 ffffffff810d4f14 0000000000000000
>   0000000000441800 ffff880078fa1780 ffff88007d403c38 ffffffff8180caf2
>  Call Trace:
>   <IRQ>  [<ffffffff81807b4c>] dump_stack+0x4d/0x66
>   [<ffffffff810d4f14>] __might_sleep+0x184/0x240
>   [<ffffffff8180caf2>] mutex_lock_nested+0x42/0x440
>   [<ffffffff810e1de6>] ? local_clock+0x16/0x30
>   [<ffffffff810fc23f>] ? lock_release_holdtime.part.28+0xf/0x200
>   [<ffffffff812d76a0>] kernfs_notify+0x90/0x150
>   [<ffffffff8163377c>] bitmap_endwrite+0xcc/0x240
>   [<ffffffffa00de863>] close_write+0x93/0xb0 [raid1]
>   [<ffffffffa00df029>] r1_bio_write_done+0x29/0x50 [raid1]
>   [<ffffffffa00e0474>] raid1_end_write_request+0xe4/0x260 [raid1]
>   [<ffffffff813acb8b>] bio_endio+0x6b/0xa0
>   [<ffffffff813b46c4>] blk_update_request+0x94/0x420
>   [<ffffffff813bf0ea>] blk_mq_end_io+0x1a/0x70
>   [<ffffffffa00392c2>] virtblk_request_done+0x32/0x80 [virtio_blk]
>   [<ffffffff813c0648>] __blk_mq_complete_request+0x88/0x120
>   [<ffffffff813c070a>] blk_mq_complete_request+0x2a/0x30
>   [<ffffffffa0039066>] virtblk_done+0x66/0xe0 [virtio_blk]
>   [<ffffffffa002535a>] vring_interrupt+0x3a/0xa0 [virtio_ring]
>   [<ffffffff81116177>] handle_irq_event_percpu+0x77/0x340
>   [<ffffffff8111647d>] handle_irq_event+0x3d/0x60
>   [<ffffffff81119436>] handle_edge_irq+0x66/0x130
>   [<ffffffff8101c3e4>] handle_irq+0x84/0x150
>   [<ffffffff818146ad>] do_IRQ+0x4d/0xe0
>   [<ffffffff818122f2>] common_interrupt+0x72/0x72
>   <EOI>  [<ffffffff8105f706>] ? native_safe_halt+0x6/0x10
>   [<ffffffff81025454>] default_idle+0x24/0x230
>   [<ffffffff81025f9f>] arch_cpu_idle+0xf/0x20
>   [<ffffffff810f5adc>] cpu_startup_entry+0x37c/0x7b0
>   [<ffffffff8104df1b>] start_secondary+0x25b/0x300
> 
>  =================================
>  [ INFO: inconsistent lock state ]
>  3.16.0-0.rc2.git2.1.fc21.x86_64 #1 Not tainted
>  ---------------------------------
>  inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
>  swapper/1/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>   (kernfs_mutex){?.+.+.}, at: [<ffffffff812d76a0>] kernfs_notify+0x90/0x150
>  {HARDIRQ-ON-W} state was registered at:
>    [<ffffffff811004b2>] __lock_acquire+0x942/0x1ca0
>    [<ffffffff811020f4>] lock_acquire+0xa4/0x1d0
>    [<ffffffff8180cb35>] mutex_lock_nested+0x85/0x440
>    [<ffffffff812d6d6f>] kernfs_activate+0x1f/0xf0
>    [<ffffffff812d7140>] kernfs_create_root+0xf0/0x110
>    [<ffffffff821f1ddc>] sysfs_init+0x13/0x51
>    [<ffffffff821ef5af>] mnt_init+0x107/0x231
>    [<ffffffff821ef213>] vfs_caches_init+0x98/0x106
>    [<ffffffff821bdfb0>] start_kernel+0x44f/0x4bc
>    [<ffffffff821bd4d7>] x86_64_start_reservations+0x2a/0x2c
>    [<ffffffff821bd626>] x86_64_start_kernel+0x14d/0x170
>  irq event stamp: 33518
>  hardirqs last  enabled at (33515): [<ffffffff8102544f>] default_idle+0x1f/0x230
>  hardirqs last disabled at (33516): [<ffffffff818122ed>]
> common_interrupt+0x6d/0x72
>  softirqs last  enabled at (33518): [<ffffffff810a1272>]
> _local_bh_enable+0x22/0x50
>  softirqs last disabled at (33517): [<ffffffff810a29e0>] irq_enter+0x60/0x80
> 
>                                               other info that might
> help us debug this:
>   Possible unsafe locking scenario:
>         CPU0
>         ----
>    lock(kernfs_mutex);
>    <Interrupt>
>      lock(kernfs_mutex);
> 
>                                                *** DEADLOCK ***
>  2 locks held by swapper/1/0:
>   #0:  (&(&vblk->vq_lock)->rlock){-.-...}, at: [<ffffffffa0039042>]
> virtblk_done+0x42/0xe0 [virtio_blk]
>   #1:  (&(&bitmap->counts.lock)->rlock){-.....}, at:
> [<ffffffff81633718>] bitmap_endwrite+0x68/0x240
> 
>                                               stack backtrace:
>  CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.16.0-0.rc2.git2.1.fc21.x86_64 #1
>  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>   0000000000000000 f90db13964f4ee05 ffff88007d4039d0 ffffffff81807b4c
>   ffff88007bcb19d0 ffff88007d403a20 ffffffff81805358 0000000000000000
>   0000000000000000 0000000000000001 ffff88007bcb25a8 ffff88007bcb19d0
>  Call Trace:
>   <IRQ>  [<ffffffff81807b4c>] dump_stack+0x4d/0x66
>   [<ffffffff81805358>] print_usage_bug+0x1f0/0x205
>   [<ffffffff810ff450>] mark_lock+0x610/0x6d0
>   [<ffffffff810fe520>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
>   [<ffffffff81100614>] __lock_acquire+0xaa4/0x1ca0
>   [<ffffffff8101dc4d>] ? show_trace_log_lvl+0x4d/0x60
>   [<ffffffff8101c8ad>] ? show_stack_log_lvl+0xad/0x1b0
>   [<ffffffff811020f4>] lock_acquire+0xa4/0x1d0
>   [<ffffffff812d76a0>] ? kernfs_notify+0x90/0x150
>   [<ffffffff8180cb35>] mutex_lock_nested+0x85/0x440
>   [<ffffffff812d76a0>] ? kernfs_notify+0x90/0x150
>   [<ffffffff810fc23f>] ? lock_release_holdtime.part.28+0xf/0x200
>   [<ffffffff812d76a0>] ? kernfs_notify+0x90/0x150
>   [<ffffffff812d76a0>] kernfs_notify+0x90/0x150
>   [<ffffffff8163377c>] bitmap_endwrite+0xcc/0x240
>   [<ffffffffa00de863>] close_write+0x93/0xb0 [raid1]
>   [<ffffffffa00df029>] r1_bio_write_done+0x29/0x50 [raid1]
>   [<ffffffffa00e0474>] raid1_end_write_request+0xe4/0x260 [raid1]
>   [<ffffffff813acb8b>] bio_endio+0x6b/0xa0
>   [<ffffffff813b46c4>] blk_update_request+0x94/0x420
>   [<ffffffff813bf0ea>] blk_mq_end_io+0x1a/0x70
>   [<ffffffffa00392c2>] virtblk_request_done+0x32/0x80 [virtio_blk]
>   [<ffffffff813c0648>] __blk_mq_complete_request+0x88/0x120
>   [<ffffffff813c070a>] blk_mq_complete_request+0x2a/0x30
>   [<ffffffffa0039066>] virtblk_done+0x66/0xe0 [virtio_blk]
>   [<ffffffffa002535a>] vring_interrupt+0x3a/0xa0 [virtio_ring]
>   [<ffffffff81116177>] handle_irq_event_percpu+0x77/0x340
>   [<ffffffff8111647d>] handle_irq_event+0x3d/0x60
>   [<ffffffff81119436>] handle_edge_irq+0x66/0x130
>   [<ffffffff8101c3e4>] handle_irq+0x84/0x150
>   [<ffffffff818146ad>] do_IRQ+0x4d/0xe0
>   [<ffffffff818122f2>] common_interrupt+0x72/0x72
>   <EOI>  [<ffffffff8105f706>] ? native_safe_halt+0x6/0x10
>   [<ffffffff81025454>] default_idle+0x24/0x230
>   [<ffffffff81025f9f>] arch_cpu_idle+0xf/0x20
>   [<ffffffff810f5adc>] cpu_startup_entry+0x37c/0x7b0
>   [<ffffffff8104df1b>] start_secondary+0x25b/0x30
