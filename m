Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494Ab3LIWjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 17:39:13 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:40931 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754286Ab3LIWjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 17:39:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj8SAJtFplJ5LHyk/2dsb2JhbABZgwc4pGUDjzGFUIEsF3SCZhwjGCQ0BSUDIROIAQ7AYRcWjnqEOgOYE4ExiRuHSIM9KA
Date: Tue, 10 Dec 2013 09:39:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org
Subject: [HANG 3.13-rc3] blk-mq/virtio: mkfs.ext4 hangs in
 blk_mq_wait_for_tags
Message-ID: <20131209223905.GU31386@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Another day, another blkmq/virtio problem. Running mkfs.ext4 on a
sparse 100TB VM file image, it hangs hard while writing superblock
information:

$ tests/fsmark-50-test-ext4.sh
mke2fs 1.43-WIP (20-Jun-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
1677721600 inodes, 26843545600 blocks
1342177280 blocks (5.00%) reserved for the super user
First data block=0
819200 block groups
32768 blocks per group, 32768 fragments per group
2048 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
        102400000, 214990848, 512000000, 550731776, 644972544, 1934917632,
        2560000000, 3855122432, 5804752896, 12800000000, 17414258688

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: 

It writes a few superblocks, then hangs. Immediately after it stops
updating that last line, I see this:

root@test4:~# echo w > /proc/sysrq-trigger 
[   79.408153] SysRq : Show Blocked State
[   79.408832]   task                        PC stack   pid father
[   79.409860] mke2fs          D ffff88011bc13100  3904  4242   4241 0x00000002
[   79.411074]  ffff88021a737978 0000000000000086 ffff8800dbb9de40 0000000000013100
[   79.412009]  ffff88021a737fd8 0000000000013100 ffff88011ac7af20 ffff8800dbb9de40
[   79.412009]  ffff88021a737988 ffffe8fcfbc038d0 ffff88011b39c058 ffff88011b39c040
[   79.412009] Call Trace:
[   79.412009]  [<ffffffff81ae36d9>] schedule+0x29/0x70
[   79.412009]  [<ffffffff8178863e>] percpu_ida_alloc+0x16e/0x330
[   79.412009]  [<ffffffff810cf393>] ? finish_wait+0x63/0x80
[   79.412009]  [<ffffffff810cf3f0>] ? __init_waitqueue_head+0x40/0x40
[   79.412009]  [<ffffffff8175f30f>] blk_mq_wait_for_tags+0x1f/0x40
[   79.412009]  [<ffffffff8175e28e>] blk_mq_alloc_request_pinned+0x4e/0x110
[   79.412009]  [<ffffffff8175eacb>] blk_mq_make_request+0x41b/0x500
[   79.412009]  [<ffffffff81753552>] generic_make_request+0xc2/0x110
[   79.412009]  [<ffffffff81754a1c>] submit_bio+0x6c/0x120
[   79.412009]  [<ffffffff811d1dd3>] _submit_bh+0x133/0x200
[   79.412009]  [<ffffffff811d1eb0>] submit_bh+0x10/0x20
[   79.412009]  [<ffffffff811d5298>] __block_write_full_page+0x1b8/0x370
[   79.412009]  [<ffffffff811d3e30>] ? block_read_full_page+0x320/0x320
[   79.412009]  [<ffffffff811d8450>] ? I_BDEV+0x10/0x10
[   79.412009]  [<ffffffff811d8450>] ? I_BDEV+0x10/0x10
[   79.412009]  [<ffffffff811d5541>] block_write_full_page_endio+0xf1/0x100
[   79.412009]  [<ffffffff811d5565>] block_write_full_page+0x15/0x20
[   79.412009]  [<ffffffff811d8908>] blkdev_writepage+0x18/0x20
[   79.412009]  [<ffffffff8115668a>] __writepage+0x1a/0x50
[   79.412009]  [<ffffffff81157055>] write_cache_pages+0x225/0x470
[   79.412009]  [<ffffffff81156670>] ? mapping_tagged+0x20/0x20
[   79.412009]  [<ffffffff811572ed>] generic_writepages+0x4d/0x70
[   79.412009]  [<ffffffff810c4d0f>] ? __dequeue_entity+0x2f/0x50
[   79.412009]  [<ffffffff81158bd1>] do_writepages+0x21/0x50
[   79.412009]  [<ffffffff8114e199>] __filemap_fdatawrite_range+0x59/0x60
[   79.412009]  [<ffffffff81ae7e8e>] ? _raw_spin_unlock_irq+0xe/0x20
[   79.412009]  [<ffffffff8114e1da>] filemap_write_and_wait_range+0x3a/0x80
[   79.412009]  [<ffffffff811d8b14>] blkdev_fsync+0x24/0x50
[   79.412009]  [<ffffffff811cf898>] do_fsync+0x58/0x80
[   79.412009]  [<ffffffff81aeb8e5>] ? do_async_page_fault+0x35/0xc0
[   79.412009]  [<ffffffff811cfb30>] SyS_fsync+0x10/0x20
[   79.412009]  [<ffffffff81af08e9>] system_call_fastpath+0x16/0x1b

And a coupel of seconds later the VM hangs hard - console,
networking, everything just stops dead and it doesn't even respond
ot an nmi from the qemu command console.

The test is exactly the same as described in the previous problem I
had:

http://marc.info/?l=linux-kernel&m=138621901319333&w=2

The only difference is that I'm trying to run the concurrent create
workload on ext4 now, not XFS, and it's failing in mkfs.ext4 during
the setup code....

At this point, I have to ask: is anyone doing high IOPS testing on
virtio/blk_mq? This is the third regression I've hit since it was
merged, and I'm really not stressing this code nearly as much as
some of the hardware out there is capable of doing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
