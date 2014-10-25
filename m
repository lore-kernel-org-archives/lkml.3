Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087AbaJYA3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 20:29:46 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:38731 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaJYA3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 20:29:44 -0400
Message-ID: <544AEEF1.30506@gmail.com>
Date: Fri, 24 Oct 2014 20:29:37 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Slow dc3dd in 3.18 on x86
References: <544AA317.8070609@gmail.com> <yq1r3xxtfa7.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1r3xxtfa7.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/14 15:54, Martin K. Petersen wrote:
>>>>>> "Michael" == Michael L Semon <mlsemon35@gmail.com> writes:
>
> Michael> This week, a simple `dc3dd wipe=/dev/sda5` operation had speeds
> Michael> cut from 10-15 MB/s down to less than 1.8 MB/s.  With this
> Michael> method, syncs took so long that magic SysRq keys were needed to
> Michael> stop the PC.  A bisect let me here:
>
> That commit itself doesn't do anything.
>
> I was concerned that somehow integrity got enabled by accident and you
> were bogged down by checksum calculations but I see no evidence that
> this would be happening. Ran a few tests on ATA systems here.
>
> So I'm puzzled.
>
> Please let me know if the disk has an integrity profile in sysfs.
>

It appears that I botched a `git bisect replay` when I was close to the end.
I'm several commits off, and the actual commit seems to be this one, using
the `git branch ...; get checkout ...` method:

commit 4eaf99beadcefbf126fa05e66fb40fca999e09fd
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Fri Sep 26 19:20:06 2014 -0400

     block: Don't merge requests if integrity flags differ

     We'd occasionally merge requests with conflicting integrity flags.
     Introduce a merge helper which checks that the requests have compatible
     integrity payloads.

     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
     Reviewed-by: Christoph Hellwig <hch@lst.de>
     Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
     Signed-off-by: Jens Axboe <axboe@fb.com>

There was nothing regarding integrity in /sys/block/sda.  I was under the
impression that both bio integrity and T10 checksums require hardware
support from good hardware, so the config items have always been shut
off.  If these are really generic interfaces for all scsi/libata hardware,
let me know!  I'd love to try the new facility.

The drive in question is this (from smartctl):

Model Family:     Western Digital Caviar
Device Model:     WDC WD600BB-75CAA0
Serial Number:    WD-WMA8F2149190
Firmware Version: 16.06V16
User Capacity:    60,022,480,896 bytes [60.0 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   5
ATA Standard is:  Exact ATA specification draft version not indicated

This test machine is in its infancy, so the dwarf tools and perf aren't
loaded yet.  The closest I can get to error messages is to re-enact the
dc3dd case:

root@kyhorse:~# dc3dd wipe=/dev/sda5

dc3dd 7.1.614 started at 2014-10-24 18:35:08 -0400
compiled options:
command line: dc3dd wipe=/dev/sda5
device size: 3145728 sectors (probed)
sector size: 512 bytes (probed)
                                                                               
20709376 bytes (20 M) copied ( 1%), 0.101421 s, 195 M/s

# starts off nicely, but give it a minute or two, and...
                                                                               
177569792 bytes (169 M) copied (11%), 88.0277 s, 1.9 M/s
^C^C^C

# `killall dc3dd` did not work even when adding -4, -6, and -9; so use
#the magic SysRq keys at the keyboard...

[  451.335299] SysRq : Terminate All Tasks
[  452.160255] SysRq : Kill All Tasks
[  453.015607] SysRq : Terminate All Tasks
[  453.443829] SysRq : Kill All Tasks
[  453.949758] SysRq : Emergency Sync
  
Welcome to Linux 3.17.0-rc5+ (ttyS0)

kyhorse login: [  458.109242] SysRq : Emergency Remount R/O
[  461.656730] SysRq : Emergency Sync
[  468.111580] SysRq : Terminate All Tasks
[  468.818737] SysRq : Kill All Tasks
[  469.219577] SysRq : Terminate All Tasks
[  469.568710] SysRq : Kill All Tasks
  
Welcome to Linux 3.17.0-rc5+ (ttyS0)

kyhorse login: root Password:
Last login: Fri Oct 24 18:34:45 -0400 2014 on /dev/ttyS0.

root@kyhorse:~# shutdown -h now
Broadcast message from root@kyhorse (ttyS0) (Fri Oct 24 18:37:42 2014):
The system is going down for system halt NOW!

# it stalled for several minutes, so use the SysRq keys again...

[  505.694083] SysRq : DEBUG

Entering kdb (current=0xc159ee40, pid 0) on processor 0 due to Keyboard Entry
[0]kdb> ps
35 sleeping system daemon (state M) processes suppressed,
use 'ps A' to see all.
Task Addr       Pid   Parent [*] cpu State Thread     Command
0xc159ee40        0        0  1    0   R  0xc159f0f0 *swapper/0

0xef050000        1        0  0    0   S  0xef0502b0  init
0xef051590        6        2  0    0   D  0xef051840  kworker/u2:0
0xef101590       20        2  0    0   D  0xef101840  kworker/0:1
0xee506f70      109        1  0    0   D  0xee507220  udevd
0xeebdccf0      357        1  0    0   Z  0xeebdcfa0  dc3dd
0xeebde6d0      359        1  0    0   D  0xeebde980  dc3dd
0xeebdeb20      362        2  0    0   D  0xeebdedd0  kworker/0:2
0xee584450      392        2  0    0   D  0xee584700  kworker/0:3
0xeebdc8a0      415        1  0    0   S  0xeebdcb50  agetty
0xeebdd140      416        1  0    0   S  0xeebdd3f0  agetty
0xeebdf3c0      417        1  0    0   S  0xeebdf670  bash
0xeebdd590      418        1  0    0   S  0xeebdd840  agetty
0xeebdef70      419        1  0    0   S  0xeebdf220  agetty
0xeebdde30      420        1  0    0   S  0xeebde0e0  agetty
0xeebdd9e0      421        1  0    0   S  0xeebddc90  agetty
0xee98ef70      434      417  0    0   D  0xee98f220  shutdown

[0]kdb> btp 357
Stack traceback for pid 357
0xeebdccf0      357        1  0    0   Z  0xeebdcfa0  dc3dd
  eea13e18 00000046 c102f962 00000001 eea13e10 c166b480 00000000 c166b480
  c0046a00 eebdd590 ef836480 eebdccf0 c107bfcf 00000000 ffffffec b6d34000
  c122f7d7 eeba4540 eeba454c 00000246 eea13dfc c122f7d7 eeba4540 eeba454c
Call Trace:
  [<c102f962>] ? gup_pmd_range+0x2d/0x4d
  [<c107bfcf>] ? exit_robust_list+0x55/0xf5
  [<c122f7d7>] ? put_io_context+0x6a/0x71
  [<c122f7d7>] ? put_io_context+0x6a/0x71
  [<c122f862>] ? put_io_context_active+0x84/0x9a
  [<c1425eec>] schedule+0x23/0x51
  [<c10366cd>] do_exit+0x542/0x7f3
  [<c103c7a5>] ? recalc_sigpending+0x13/0x2f
  [<c10369e3>] do_group_exit+0x34/0x92
  [<c103eb3f>] get_signal+0x16e/0x54b
  [<c1053b9e>] ? sched_slice.isra.54+0x50/0x7d
  [<c10017d4>] do_signal+0x1e/0x855
  [<c107c12d>] ? do_futex+0xbe/0x81a
  [<c10565f9>] ? check_preempt_wakeup+0xfc/0x1b6
  [<c104ef28>] ? check_preempt_curr+0x6b/0x7c
  [<c1050c74>] ? wake_up_new_task+0xf1/0x132
  [<c107c915>] ? SyS_futex+0x8c/0x149
  [<c1002058>] do_notify_resume+0x4d/0x64
  [<c1428fc1>] work_notifysig+0x16/0x1d

[0]kdb> btp 359
Stack traceback for pid 359
0xeebde6d0      359        1  0    0   D  0xeebde980  dc3dd
  ed999c60 00000086 00000001 eea056c0 eea20818 c166b480 ee9d8b10 c166b480
  c0046a00 c159ee40 ef836480 eebde6d0 ed999c34 c122adda 00000000 00000000
  00000000 00000010 ed999c44 00000000 ee9d8b10 ed999c60 00000286 00000286
Call Trace:
  [<c122adda>] ? queue_unplugged+0x2c/0x7a
  [<c1426242>] io_schedule+0x55/0x98
  [<c122a666>] get_request+0x19b/0x4dc
  [<c105baab>] ? __wake_up_common+0x6b/0x6b
  [<c122d089>] blk_queue_bio+0x9f/0x26b
  [<c10b2428>] ? mempool_alloc_slab+0x13/0x15
  [<c122b9de>] generic_make_request+0x88/0xb4
  [<c122ba4e>] submit_bio+0x44/0xde
  [<c1225015>] ? bio_alloc_bioset+0x131/0x1de
  [<c110b237>] _submit_bh+0x1b9/0x21b
  [<c110c53e>] __block_write_full_page.constprop.25+0x1c4/0x334
  [<c110d5c0>] ? bh_submit_read+0x87/0x87
  [<c110c759>] block_write_full_page+0xab/0xba
  [<c110d5c0>] ? bh_submit_read+0x87/0x87
  [<c110d947>] blkdev_writepage+0x14/0x16
  [<c10b6dc8>] __writepage+0x10/0x31
  [<c10b6db8>] ? global_dirtyable_memory+0x98/0x98
  [<c10b813b>] write_cache_pages+0x1a4/0x3af
  [<c10b6db8>] ? global_dirtyable_memory+0x98/0x98
  [<c10b837a>] generic_writepages+0x34/0x4e
  [<c10b83ae>] do_writepages+0x1a/0x2d
  [<c10af546>] __filemap_fdatawrite_range+0x54/0x5a
  [<c10af98d>] filemap_write_and_wait+0x38/0x66
  [<c110dc46>] __sync_blockdev+0x1b/0x30
  [<c110ddc0>] __blkdev_put+0x4a/0x12f
  [<c110ec95>] blkdev_put+0x40/0xe6
  [<c110ed5a>] blkdev_close+0x1f/0x23
  [<c10e4c6a>] __fput+0xc4/0x189
  [<c10e4d63>] ____fput+0xd/0xf
  [<c10479bf>] task_work_run+0x6b/0x93
  [<c1002051>] do_notify_resume+0x46/0x64
  [<c1428fc1>] work_notifysig+0x16/0x1d
  [<c1420000>] ? acpi_os_unmap_iomem+0x1b/0xc5

[A full "dumpall" from kdb is available.]

Should you need it, the kernel config should be here:

https://drive.google.com/file/d/0B41268QKoNjtYUVDakNmdmdKMHM/view

Thanks again!

Michael



