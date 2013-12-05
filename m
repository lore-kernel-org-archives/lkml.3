Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3LEEuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 23:50:05 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:10028 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab3LEEuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 23:50:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugOAI8FoFJ5LHyk/2dsb2JhbABZgwc4pDwDjzGFT4EaF3SCJQEBBScTHCMQCAMYCSUPBSUDIROIAcEkFxaOFwEBTweEMwOYE4pMh0iDPSiBNQ
Date: Thu, 5 Dec 2013 15:49:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [OOPS, 3.13-rc2] null ptr in dio_complete()
Message-ID: <20131205044954.GL8803@dastard>
References: <20131203215940.GX10988@dastard>
 <20131204015837.GJ10988@dastard>
 <20131204033815.GK10988@dastard>
 <20131204034712.GM5051@kernel.dk>
 <20131204041749.GL10988@dastard>
 <20131204235656.GG8803@dastard>
 <20131205034143.GU5051@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205034143.GU5051@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 08:41:43PM -0700, Jens Axboe wrote:
> On Thu, Dec 05 2013, Dave Chinner wrote:
> > On Wed, Dec 04, 2013 at 03:17:49PM +1100, Dave Chinner wrote:
> > > On Tue, Dec 03, 2013 at 08:47:12PM -0700, Jens Axboe wrote:
> > > > On Wed, Dec 04 2013, Dave Chinner wrote:
> > > > > On Wed, Dec 04, 2013 at 12:58:38PM +1100, Dave Chinner wrote:
> > > > > > On Wed, Dec 04, 2013 at 08:59:40AM +1100, Dave Chinner wrote:
> > > > > > > Hi Jens,
> > > > > > > 
> > > > > > > Not sure who to direct this to or CC, so I figured you are the
> > > > > > > person to do that. I just had xfstests generic/299 (an AIO/DIO test)
> > > > > > > oops in dio_complete() like so:
> > > > > > > 
> > > ....
> > > > > > > [ 9650.590630]  <IRQ>
> > > > > > > [ 9650.590630]  [<ffffffff811ddae3>] dio_complete+0xa3/0x140
> > > > > > > [ 9650.590630]  [<ffffffff811ddc2a>] dio_bio_end_aio+0x7a/0x110
> > > > > > > [ 9650.590630]  [<ffffffff811ddbb5>] ? dio_bio_end_aio+0x5/0x110
> > > > > > > [ 9650.590630]  [<ffffffff811d8a9d>] bio_endio+0x1d/0x30
> > > > > > > [ 9650.590630]  [<ffffffff8175d65f>] blk_mq_complete_request+0x5f/0x120
> > > > > > > [ 9650.590630]  [<ffffffff8175d736>] __blk_mq_end_io+0x16/0x20
> > > > > > > [ 9650.590630]  [<ffffffff8175d7a8>] blk_mq_end_io+0x68/0xd0
> > > > > > > [ 9650.590630]  [<ffffffff818539a7>] virtblk_done+0x67/0x110
> > > > > > > [ 9650.590630]  [<ffffffff817f74c5>] vring_interrupt+0x35/0x60
> > > .....
> > > > > > And I just hit this from running xfs_repair which is doing
> > > > > > multithreaded direct IO directly on /dev/vdc:
> > > > > > 
> > > ....
> > > > > > [ 1776.510446] IP: [<ffffffff81755b6a>] blk_account_io_done+0x6a/0x180
> > > ....
> > > > > > [ 1776.512577]  [<ffffffff8175e4b8>] blk_mq_complete_request+0xb8/0x120
> > > > > > [ 1776.512577]  [<ffffffff8175e536>] __blk_mq_end_io+0x16/0x20
> > > > > > [ 1776.512577]  [<ffffffff8175e5a8>] blk_mq_end_io+0x68/0xd0
> > > > > > [ 1776.512577]  [<ffffffff81852e47>] virtblk_done+0x67/0x110
> > > > > > [ 1776.512577]  [<ffffffff817f7925>] vring_interrupt+0x35/0x60
> > > > > > [ 1776.512577]  [<ffffffff810e48a4>] handle_irq_event_percpu+0x54/0x1e0
> > > .....
> > > > > > So this is looking like another virtio+blk_mq problem....
> > > > > 
> > > > > This one is definitely reproducable. Just hit it again...
> > > > 
> > > > I'll take a look at this. You don't happen to have gdb dumps of the
> > > > lines associated with those crashes? Just to save me some digging
> > > > time...
> > > 
> > > Only this:
> > > 
> > > (gdb) l *(dio_complete+0xa3)
> > > 0xffffffff811ddae3 is in dio_complete (fs/direct-io.c:282).
> > > 277                     }
> > > 278
> > > 279                     aio_complete(dio->iocb, ret, 0);
> > > 280             }
> > > 281
> > > 282             kmem_cache_free(dio_cache, dio);
> > > 283             return ret;
> > > 284     }
> > > 285
> > > 286     static void dio_aio_complete_work(struct work_struct *work)
> > > 
> > > And this:
> > > 
> > > (gdb) l *(blk_account_io_done+0x6a)
> > > 0xffffffff81755b6a is in blk_account_io_done (block/blk-core.c:2049).
> > > 2044                    int cpu;
> > > 2045
> > > 2046                    cpu = part_stat_lock();
> > > 2047                    part = req->part;
> > > 2048
> > > 2049                    part_stat_inc(cpu, part, ios[rw]);
> > > 2050                    part_stat_add(cpu, part, ticks[rw], duration);
> > > 2051                    part_round_stats(cpu, part);
> > > 2052                    part_dec_in_flight(part, rw);
> > > 2053
> > > 
> > > as I've rebuild the kernel with different patches since the one
> > > running on the machine that is triggering the problem.
> > 
> > Any update on this, Jens? I've hit this blk_account_io_done() panic
> > 10 times in the past 2 hours while trying to do xfs_repair
> > testing....
> 
> No, sorry, no updates yet... I haven't had time to look into it today.
> To reproduce tomorrow, can you mail me your exact setup (kvm invocation,
> etc) and how your guest is setup and if there's any special way I need
> to run xfstest or xfs_repair?

The virtio device that I'm hitting is "/mnt/fast-ssd/vm-100TB-sparse.img"
which is a 100TB file on a 160GB XFS filesystem on an SSD, created
with

$ xfs_io -f -c "truncate 100t" -c "extsize 1m" /mnt/fast-ssd/vm-100TB-sparse.img

If I stat it, I get:

$ xfs_io -c stat /mnt/fast-ssd/vm-100TB-sparse.img 
fd.path = "/mnt/fast-ssd/vm-100TB-sparse.img"
fd.flags = non-sync,non-direct,read-write
stat.ino = 131
stat.type = regular file
stat.size = 109951162777600
stat.blocks = 259333400
fsxattr.xflags = 0x800 [----------e---]
fsxattr.projid = 0
fsxattr.extsize = 1048576
fsxattr.nextents = 83108
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136
$

The VM is run by this script:

$ cat run-vm-4.sh 
#!/bin/sh
sudo /usr/bin/qemu-system-x86_64 \
        -no-fd-bootchk \
        -localtime \
        -boot c \
        -serial pty \
        -nographic \
        -alt-grab \
        -smp 16 -m 16384 \
        -machine accel=kvm \
        -hda /vm-images/vm-4/root.img \
        -drive file=/vm-images/vm-4/vm-4-test.img,if=virtio,cache=none \
        -drive file=/vm-images/vm-4/vm-4-scratch.img,if=virtio,cache=none \
        -drive file=/mnt/fast-ssd/vm-100TB-sparse.img,if=virtio,cache=none \
        -drive file=/mnt/large/vm-17TB.img,if=virtio,cache=none \
        -net nic,vlan=0,macaddr=00:e4:b6:63:63:70,model=virtio \
        -net tap,vlan=0,script=/vm-images/qemu-ifup,downscript=no \
        -kernel /vm-images/vm-4/vmlinuz \
        -append "console=ttyS0,115200 root=/dev/sda1 numa=fake=4"
$

Inside the guest, I make and populate the XFS filesystem with 50m
inodes like so:

$ $ head -20 fsmark-50-test-xfs.sh 
#!/bin/bash

sudo umount /mnt/scratch > /dev/null 2>&1
sudo mkfs.xfs -f $@ -l size=131072b /dev/vdc
sudo mount -o nobarrier,logbsize=256k /dev/vdc /mnt/scratch
sudo chmod 777 /mnt/scratch
cd /home/dave/src/fs_mark-3.3/
sudo sh -c "echo 1 > /proc/sys/fs/xfs/stats_clear"
time ./fs_mark  -D  10000  -S0  -n  100000  -s  0  -L  32 \
        -d  /mnt/scratch/0  -d  /mnt/scratch/1 \
        -d  /mnt/scratch/2  -d  /mnt/scratch/3 \
        -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
        -d  /mnt/scratch/6  -d  /mnt/scratch/7 \
        -d  /mnt/scratch/8  -d  /mnt/scratch/9 \
        -d  /mnt/scratch/10  -d  /mnt/scratch/11 \
        -d  /mnt/scratch/12  -d  /mnt/scratch/13 \
        -d  /mnt/scratch/14  -d  /mnt/scratch/15 \
        | tee >(stats --trim-outliers | tail -1 1>&2)
sync
sudo umount /mnt/scratch > /dev/null 2>&1
$

It takes about 4 minutes to create all the files here, then
I run repair like this:

$ xfs_repair -v -v -t 1 -o bhash=32768 -o ag_stride=15 /dev/vdc

xfs_repair is driving around 15-18,000 read IOPS from 6-7 threads
on my hardware and takes around 15 minutes to run to completion.
Every second run on average dies with this setup.

I made some mods to xfs-repair this morning and I was getting it to
pushupwards of 60000 read IOPS from ~30 threads using ag_stride=3.
That was tending to trigger the problem in a couple of minutes.

So, really, this is just a highly concurrent, high IOPS direct IO
read workload....

I've also got other VMs running xfstests at much, much lower loads
and concurrency (e.g. 1/2p VMs with image files stored on spinning
rust) that are hitting this same problem once every few hours....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
