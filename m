Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab3LWFDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 00:03:25 -0500
Received: from mdfmta004.mxout.tch.inty.net ([91.221.169.45]:44195 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750711Ab3LWFDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 00:03:23 -0500
Message-ID: <52B7C416.9030404@lougher.demon.co.uk>
Date: Mon, 23 Dec 2013 05:03:18 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Chanho Min <chanho.min@lge.com>
CC: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        HyoJun Im <hyojun.im@lge.com>, gunho.lee@lge.com,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] Squashfs: add asynchronous read support
References: <1387171826-20110-1-git-send-email-chanho.min@lge.com>
In-Reply-To: <1387171826-20110-1-git-send-email-chanho.min@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-MDF-HostID: 17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/13 05:30, Chanho Min wrote:
> This patch removes synchronous wait for the up-to-date of buffer in the
> file system level. Instead all operations after submit_bh are moved into
> the End-of-IO handler and its associated workeque. It decompresses/copies
> data into pages and unlock them asynchronously.
>
> This patch enhances the performance of Squashfs in most cases.
> Especially, large file reading is improved significantly.

Hi,

The following is the summarised results of a set of
comprehensive tests of the asynchronous patch against the current
synchronous Squashfs readpage implementation.

The following tables should be fairly self-explanatory, but,
the testing methodology was:

Generate a series of Squashfs filesystems, with block size
1024K, 512K, 256K, 128K and 64K.

Then for each filesystem

Run "dd if=/mnt/file of=/dev/null bs=X"

Where X is 4K, 8K, 16K, 32K, 64K, 128K, 256K, 512K, and 1024K

For each dd, run it against six different Squashfs modules,
configured with the following different options:

1. SQUASHFS_READ_DATA_ASYNC selected, SQUASHFS_DECOMP_SINGLE selected
    i.e. Async patch and single threaded decompression
    == Asyn Single in following tables

2. SQUASHFS_READ_DATA_ASYNC *not* selected, SQUASHFS_DECOMP_SINGLE selected
    i.e. No Async patch and single threaded decompression
    == No Asyn Single in following tables

3. SQUASHFS_READ_DATA_ASYNC selected, SQUASHFS_DECOMP_MULTI selected
    i.e. Async patch and multi-threaded decompression
    == Asyn Multi in following tables

4. SQUASHFS_READ_DATA_ASYNC *not* selected, SQUASHFS_DECOMP_MULTI selected
    i.e. No Async patch and multi-threaded decompression
    == No Asyn Multi in following tables

5. SQUASHFS_READ_DATA_ASYNC selected, SQUASHFS_DECOMP_MULTI_PERCPU selected
    i.e. Async patch and percpu multi-threaded decompression
    == Asyn Percpu in following tables

6. SQUASHFS_READ_DATA_ASYNC *not* selected, SQUASHFS_DECOMP_MULTI_PERCPU selected
    i.e. No Async patch and percpu multi-threaded decompression
    == No Asyn Percpu in following tables

The figures in the following tables are the MB/s reported by dd.

The tests were performed on a KVM guest with 4 cores and 4Gb of
memory, running on a core i5 based host.

The Squashfs filesystem was on "/dev/hdb".

/mnt/file is a 3Gb file, average compression 22% (635 Mb)

Squashfs: gzip filesystem 1024K blocks

	Asyn	No Asyn	Asyn	No Asyn	Asyn	No Asyn
	Single	Single	Multi	Multi	Percpu	Percpu
-------------------------------------------------------
4K:	89.4	97.5	89.9	98.1	90.6	99.1
8K:	89.9	99.0	89.7	99.4	90.3	99.4
16K:	90.6	99.8	90.8	100	90.2	97.0
32K:	90.3	98.7	90.3	98.0	89.9	101
64K:	90.3	97.6	90.2	97.1	90.1	99.7
128K:	90.4	98.6	90.2	97.6	90.7	98.5
256K:	89.7	96.9	89.8	99.2	90.2	101
512K:	89.7	98.9	90.8	98.1	89.4	97.8
1024K:	89.3	98.0	89.6	98.6	88.7	96.4

Squashfs: gzip filesystem 512K blocks	

	Asyn	No Asyn	Asyn	No Asyn	Asyn	No Asyn
	Single	Single	Multi	Multi	Percpu	Percpu
-------------------------------------------------------
4K:	68.5	94.9	67.6	99.0	68.9	97.0
8K:	69.3	101	68.9	94.3	69.0	97.2
16K:	68.9	98.6	69.4	98.9	68.8	98.0
32K:	68.6	96.5	69.4	98.9	69.4	108
64K:	68.7	92.9	69.7	101	68.8	98.2
128K:	67.4	102	68.7	90.3	69.4	100
256K:	68.7	95.1	68.2	99.7	68.5	97.7
512K:	69.9	114	82.0	104	74.2	94.4
1024K:	71.6	105	79.2	105	69.1	98.0

Squashfs: gzip filesystem 256K blocks

	Asyn	No Asyn	Asyn	No Asyn	Asyn	No Asyn
	Single	Single	Multi	Multi	Percpu	Percpu
-------------------------------------------------------
4K:	53.6	92.2	54.6	87.5	53.7	82.1
8K:	53.5	87.3	53.5	85.0	53.5	85.7
16K:	53.1	89.0	53.8	95.7	53.5	91.1
32K:	54.0	95.9	53.8	98.7	53.9	85.3
64K:	53.7	86.9	53.4	103	53.4	86.3
128K:	53.2	94.4	53.6	100	53.7	97.9
256K:	55.5	101	53.0	94.1	53.3	87.0
512K:	53.1	93.0	53.4	87.7	53.2	89.8
1024K:	53.2	91.4	52.7	91.3	53.0	95.4

A couple of points about the above can be noticed:

1. With a Squashfs block size of 256K and greater, Squashfs
    readpage() does its own readahead.  This means the asynchronous
    readpage is never called multiply (to run in parallel), because
    there is never any more work to do after the first readpage().

    The above results therefore reflect the basic performance of
    the asynchronous readpage implementation versus the
    synchronous readpage implementation.

2. It can be seen in all cases the asynchronous readpage implementation
    performs worse than the synchronous readpage implementation.

    This varies from 10% worse (1024K blocks) to a huge 44% worse
    (256K blocks).

    In otherwords, the smaller the filesystem block size the more
    readpage calls, and the greater performance hit.

Squashfs: gzip filesystem 128K blocks

	Asyn	No Asyn	Asyn	No Asyn	Asyn	No Asyn
	Single	Single	Multi	Multi	Percpu	Percpu
-------------------------------------------------------
4K:	44.7	49.2	43.0	47.0	42.7	48.9
8K:	43.0	48.6	43.0	48.2	43.0	49.8
16K:	42.9	47.9	43.0	47.5	43.1	47.4
32K:	42.9	47.2	43.0	46.1	42.9	47.1
64K:	50.7	47.0	55.1	53.1	55.2	49.6
128K:	51.1	47.6	54.9	49.2	55.7	48.7
256K:	51.0	49.5	54.7	48.2	57.3	49.3
512K:	53.6	48.2	55.2	47.6	54.9	48.3
1024K:	51.1	47.9	54.7	47.5	54.6	46.5

A couple of points about the above can be noticed:

1. A filesystem block size of 128K means a single readpage call
    no longer performs all the readahead.  Thus allowing the
    possibility of simultaneous asynchronous readpage calls.

2. dd block sizes of 32K and less show worse performance
    for the asynchronous readpage implementation, similar to
    the previous results.

    An ftrace of the kernel shows no parallel async readpage calls
    are taking place.

3. Block sizes of 64K and above show readahead taking place, with
    parallel asynchronous readpages.

    This is confirmed by an ftrace of the kernel.

    The performance improvement ranges from 7.9% to 16%, or 1.079x and
    1.16x the performance of the synchronous readpage() implementation.

Overall of the above 108 datapoint sets, 15 show an improvement
of between 7.9%-16%, and 93 show a performance decrease of
between 10%-44%.  86% of the performance tests are worse.

This is the not terribly good "good" results.

Worse is the fact I have got constant kernel oopses testing the
asynchronous patch (note I received no kernel oopses without the
asynchronous patch).  I have included two of the kernel oopses
here.  All the kernel oopses are different, but all point to the
fact the asynchronous patch introduces races with the page state
within the page cache/VFS layer.

1. Ooops 1.

BUG: Bad page state in process kworker/0:3  pfn:11f618
page:ffffea00047d8600 count:0 mapcount:0 mapping:ffff88003c1081b8 index:0x2ea8
page flags: 0x800000000000000a(error|uptodate)
BUG: Bad page state in process kworker/0:3  pfn:5020b
page:ffffea00014082c0 count:0 mapcount:0 mapping:ffff88003c1081b8 index:0x2ea9
page flags: 0x400000000000000a(error|uptodate)
BUG: Bad page state in process kworker/0:3  pfn:5020a
page:ffffea0001408280 count:0 mapcount:0 mapping:ffff88003c1081b8 index:0x2eaa
page flags: 0x400000000000000a(error|uptodate)
BUG: Bad page state in process kworker/0:3  pfn:50209
page:ffffea0001408240 count:0 mapcount:0 mapping:ffff88003c1081b8 index:0x2eab
page flags: 0x400000000000000a(error|uptodate)
BUG: Bad page state in process kworker/0:3  pfn:50208
page:ffffea0001408200 count:0 mapcount:0 mapping:ffff88003c1081b8 index:0x2eac
page flags: 0x400000000000000a(error|uptodate)
BUG: Bad page state in process kworker/0:3  pfn:50207
page:ffffea00014081c0 count:0 mapcount:0 mapping:ffff88003c1081b8 index:0x2ead
page flags: 0x400000000000000a(error|uptodate)
BUG: Bad page state in process kworker/0:3  pfn:50205
page:ffffea0001408140 count:0 mapcount:0 mapping:ffff88003c1081b8 index:0x2eae
page flags: 0x400000000000000a(error|uptodate)
BUG: Bad page state in process kworker/0:3  pfn:50204
page:ffffea0001408100 count:0 mapcount:0 mapping:ffff88003c1081b8 index:0x2eaf
page flags: 0x400000000000000a(error|uptodate)
stack segment: 0000 [#1] SMP
Modules linked in: squashfs [last unloaded: squashfs]
CPU: 0 PID: 2698 Comm: klogd Tainted: G    B        3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff8800da85cec0 ti: ffff88011a6b6000 task.ti: ffff88011a6b6000
RIP: 0010:[<ffffffff81106026>]  [<ffffffff81106026>] __kmalloc_track_caller+0x56/0x130
RSP: 0018:ffff88011a6b7c20  EFLAGS: 00010206
RAX: 0000000000000000 RBX: ffff8800dbbd9700 RCX: 000000000009689f
RDX: 000000000009689e RSI: 0000000000000000 RDI: 00000000000001bf
RBP: 32206365443e313c R08: 0000000000015480 R09: 0000000000000003
R10: ffff8800da85cec0 R11: 0000000000000246 R12: 00000000000106d0
R13: 00000000000001c0 R14: ffffffff81658bb0 R15: ffff88011b001840
FS:  00007fe94d6c36f0(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 000000011a60c000 CR4: 00000000000006f0
Stack:
  ffff8800dbbd9700 ffff88011a6b7c8f 00000000000004d0 00000000000001c0
  0000000000000000 7fffffffffffffff ffffffff81658ae9 ffff8800dbbd9700
  00000000000004d0 0000000000000000 ffff88011b001900 000000000000004d
Call Trace:
  [<ffffffff81658ae9>] ? __kmalloc_reserve.isra.40+0x29/0x80
  [<ffffffff81658bb0>] ? __alloc_skb+0x70/0x280
  [<ffffffff81652b77>] ? sock_alloc_send_pskb+0x197/0x3d0
  [<ffffffff816f0ce5>] ? unix_dgram_sendmsg+0x165/0x640
  [<ffffffff81113aaf>] ? path_lookupat+0x6f/0x790
  [<ffffffff8164f8b5>] ? sock_aio_write+0xf5/0x130
  [<ffffffff810342ff>] ? __do_page_fault+0x2af/0x460
  [<ffffffff81107e8c>] ? do_sync_write+0x5c/0x90
  [<ffffffff81108575>] ? vfs_write+0x155/0x1c0
  [<ffffffff81108b48>] ? SyS_write+0x48/0xa0
  [<ffffffff81725352>] ? system_call_fastpath+0x16/0x1b
Code: 89 c7 76 61 49 8b 0f 65 48 03 0c 25 c8 cc 00 00 48 8b 51 08 48 8b 29 48 85 ed 0f 84 a8 00 00 00 49 63 47 20 48 8d 4a 01 4d 8b 07 <48> 8b 5c 05 00 48 89 e8 65 49 0f c7 08 0f 94 c0 84 c0 74 c5 49
RIP  [<ffffffff81106026>] __kmalloc_track_caller+0x56/0x130
  RSP <ffff88011a6b7c20>
---[ end trace 5e8d5e5a2d98a915 ]---
note: klogd[2698] exited with preempt_count 1
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1495 at fs/buffer.c:1204 __find_get_block+0x1c5/0x220()
VFS: brelse: Trying to free free buffer
Modules linked in: squashfs [last unloaded: squashfs]
CPU: 0 PID: 1495 Comm: jbd2/hda1-8 Tainted: G    B D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  0000000000000009 ffffffff8171e362 ffff8800dbb43b38 ffffffff8103ca27
  ffff880113bbb270 ffff8800dbb43b88 0000000000000008 ffff880113bbb000
  0000000000001000 ffffffff8103ca8c ffffffff819818c8 0000000000000018
Call Trace:
  [<ffffffff8171e362>] ? dump_stack+0x41/0x51
  [<ffffffff8103ca27>] ? warn_slowpath_common+0x77/0x90
  [<ffffffff8103ca8c>] ? warn_slowpath_fmt+0x4c/0x50
  [<ffffffff81136b85>] ? __find_get_block+0x1c5/0x220
  [<ffffffff811370ae>] ? __getblk+0x9e/0x2e0
  [<ffffffff811f2980>] ? jbd2_journal_get_descriptor_buffer+0x30/0x90
  [<ffffffff811eaa71>] ? journal_submit_commit_record.isra.10+0x61/0x1c0
  [<ffffffff811ebcae>] ? jbd2_journal_commit_transaction+0x10de/0x17d0
  [<ffffffff81065d13>] ? try_to_wake_up+0xd3/0x290
  [<ffffffff811f0ee5>] ? kjournald2+0xb5/0x250
  [<ffffffff8106f980>] ? __wake_up_sync+0x10/0x10
  [<ffffffff811f0e30>] ? commit_timeout+0x10/0x10
  [<ffffffff8105a226>] ? kthread+0xc6/0xe0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
  [<ffffffff817252ac>] ? ret_from_fork+0x7c/0xb0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
---[ end trace 5e8d5e5a2d98a916 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1495 at fs/buffer.c:1204 __find_get_block+0x1c5/0x220()
VFS: brelse: Trying to free free buffer
Modules linked in: squashfs [last unloaded: squashfs]
CPU: 0 PID: 1495 Comm: jbd2/hda1-8 Tainted: G    B D W    3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  0000000000000009 ffffffff8171e362 ffff8800dbb43b98 ffffffff8103ca27
  ffff880113bbb2d8 ffff8800dbb43be8 0000000000000008 ffff880060e47f70
  0000000000001000 ffffffff8103ca8c ffffffff819818c8 0000000000000018
Call Trace:
  [<ffffffff8171e362>] ? dump_stack+0x41/0x51
  [<ffffffff8103ca27>] ? warn_slowpath_common+0x77/0x90
  [<ffffffff8103ca8c>] ? warn_slowpath_fmt+0x4c/0x50
  [<ffffffff81136b85>] ? __find_get_block+0x1c5/0x220
  [<ffffffff811370ae>] ? __getblk+0x9e/0x2e0
  [<ffffffff811f2980>] ? jbd2_journal_get_descriptor_buffer+0x30/0x90
  [<ffffffff811eb6aa>] ? jbd2_journal_commit_transaction+0xada/0x17d0
  [<ffffffff817209ea>] ? __schedule+0x2aa/0x810
  [<ffffffff81065d13>] ? try_to_wake_up+0xd3/0x290
  [<ffffffff811f0ee5>] ? kjournald2+0xb5/0x250
  [<ffffffff8106f980>] ? __wake_up_sync+0x10/0x10
  [<ffffffff811f0e30>] ? commit_timeout+0x10/0x10
  [<ffffffff8105a226>] ? kthread+0xc6/0xe0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
  [<ffffffff817252ac>] ? ret_from_fork+0x7c/0xb0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
---[ end trace 5e8d5e5a2d98a917 ]---

2. Oops 2

BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffffa05c8ad6>] zlib_uncompress+0xc6/0x190 [squashfs]
PGD 69239067 PUD 89e0e067 PMD 0
Oops: 0000 [#1] SMP
Modules linked in: squashfs [last unloaded: squashfs]
CPU: 1 PID: 4877 Comm: kworker/1:3 Not tainted 3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Workqueue: events squashfs_async_work [squashfs]
task: ffff8800da9f3b10 ti: ffff880074e46000 task.ti: ffff880074e46000
RIP: 0010:[<ffffffffa05c8ad6>]  [<ffffffffa05c8ad6>] zlib_uncompress+0xc6/0x190 [squashfs]
RSP: 0018:ffff880074e47d18  EFLAGS: 00010283
RAX: 00000000000002f4 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff880000000000 RSI: 0000000000000000 RDI: ffff8800db3bc640
RBP: ffff88011a62e600 R08: 000000000000010c R09: 0000000000000881
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000881
R13: 0000000000000000 R14: 000000000000010c R15: ffff88011a5e0c60
FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 0000000057bd8000 CR4: 00000000000006e0
Stack:
  ffff88011a5e08a8 ffff8800db270800 ffff8800db270800 ffff88011a5e08a8
  ffff88011a5e08a0 ffff88011a62e600 0000000000000003 000000000000010c
  ffffffffa05c83f4 ffff8800db3bc640 ffff8800db3bc640 00000881000127c0
Call Trace:
  [<ffffffffa05c83f4>] ? squashfs_decompress+0x64/0xa0 [squashfs]
  [<ffffffffa05c4109>] ? squashfs_buffer_read_async+0x69/0x2e0 [squashfs]
  [<ffffffff810536d5>] ? process_one_work+0x175/0x3f0
  [<ffffffff81054224>] ? worker_thread+0x114/0x3a0
  [<ffffffff81054110>] ? manage_workers.isra.26+0x290/0x290
  [<ffffffff8105a226>] ? kthread+0xc6/0xe0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
  [<ffffffff817252ac>] ? ret_from_fork+0x7c/0xb0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
Code: 8b 47 08 b9 01 00 00 00 85 c0 75 30 41 39 dd 7d 2b 48 8b 44 24 08 49 63 f5 48 8b 74 f5 00 8b 40 08 44 29 f0 44 39 e0 41 0f 4f c4 <4c> 03 76 28 41 29 c4 41 89 47 08 4d 89 37 45 31 f6 41 8b 77 20
RIP  [<ffffffffa05c8ad6>] zlib_uncompress+0xc6/0x190 [squashfs]
  RSP <ffff880074e47d18>
CR2: 0000000000000028
---[ end trace e66a56dcb454c870 ]---
note: kworker/1:3[4877] exited with preempt_count 1
BUG: unable to handle kernel paging request at ffffffffffffffc8
IP: [<ffffffff8105a85c>] kthread_data+0xc/0x20
PGD 1c0c067 PUD 1c0e067 PMD 0
Oops: 0000 [#2] SMP
Modules linked in: squashfs [last unloaded: squashfs]
CPU: 1 PID: 4877 Comm: kworker/1:3 Tainted: G      D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff8800da9f3b10 ti: ffff880074e46000 task.ti: ffff880074e46000
RIP: 0010:[<ffffffff8105a85c>]  [<ffffffff8105a85c>] kthread_data+0xc/0x20
RSP: 0018:ffff880074e47988  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff88011fc927c0
RDX: 000000000000b9c7 RSI: 0000000000000001 RDI: ffff8800da9f3b10
RBP: ffff880074e47a98 R08: 8000000000000000 R09: 0000000000000001
R10: 000000000000b885 R11: 0000000000000000 R12: ffff8800da9f3df0
R13: 0000000000000001 R14: ffff8800da9f3b00 R15: ffff8800da9f3b10
FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 0000000057bd8000 CR4: 00000000000006e0
Stack:
  ffffffff81054d8d ffff88011fc927c0 ffffffff81720b3d ffff8800da9f3b10
  ffff880074e47fd8 00000000000127c0 00000000000127c0 ffff8800da9f3b10
  0000000000000001 0000000000000000 0000000000000206 ffff880074e47a68
Call Trace:
  [<ffffffff81054d8d>] ? wq_worker_sleeping+0xd/0x80
  [<ffffffff81720b3d>] ? __schedule+0x3fd/0x810
  [<ffffffff812b22eb>] ? debug_object_active_state+0x12b/0x170
  [<ffffffff8103d330>] ? will_become_orphaned_pgrp+0xb0/0xb0
  [<ffffffff8103e072>] ? do_exit+0x6a2/0x9f0
  [<ffffffff81005a8a>] ? oops_end+0x6a/0x90
  [<ffffffff8171b805>] ? no_context+0x25e/0x26a
  [<ffffffff810342ff>] ? __do_page_fault+0x2af/0x460
  [<ffffffff8106d263>] ? idle_balance+0x193/0x1a0
  [<ffffffff817243fa>] ? _raw_spin_unlock_irq+0xa/0x10
  [<ffffffff81062597>] ? finish_task_switch+0x57/0xa0
  [<ffffffff817209ea>] ? __schedule+0x2aa/0x810
  [<ffffffff81724be2>] ? page_fault+0x22/0x30
  [<ffffffffa05c8ad6>] ? zlib_uncompress+0xc6/0x190 [squashfs]
  [<ffffffffa05c8a48>] ? zlib_uncompress+0x38/0x190 [squashfs]
  [<ffffffffa05c83f4>] ? squashfs_decompress+0x64/0xa0 [squashfs]
  [<ffffffffa05c4109>] ? squashfs_buffer_read_async+0x69/0x2e0 [squashfs]
  [<ffffffff810536d5>] ? process_one_work+0x175/0x3f0
  [<ffffffff81054224>] ? worker_thread+0x114/0x3a0
  [<ffffffff81054110>] ? manage_workers.isra.26+0x290/0x290
  [<ffffffff8105a226>] ? kthread+0xc6/0xe0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
  [<ffffffff817252ac>] ? ret_from_fork+0x7c/0xb0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
Code: 88 02 00 00 48 8b 40 b8 48 c1 e8 02 83 e0 01 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 88 02 00 00 <48> 8b 40 c8 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f
RIP  [<ffffffff8105a85c>] kthread_data+0xc/0x20
  RSP <ffff880074e47988>
CR2: ffffffffffffffc8
---[ end trace e66a56dcb454c871 ]---
Fixing recursive fault but reboot is needed!
hda: lost interrupt
hda: ide_dma_sff_timer_expiry: DMA status (0x64)
hdc: lost interrupt

ðBUG: spinlock lockup suspected on CPU#1, kworker/1:3/4877
  lock: 0xffff88011fc927c0, .magic: dead4ead, .owner: kworker/1:3/4877, .owner_cpu: 1
CPU: 1 PID: 4877 Comm: kworker/1:3 Tainted: G      D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  0000000088c1cfb8 ffffffff8171e362 ffff88011fc927c0 ffffffff81073169
  ffff88011fc927c0 ffff880074e47708 0000000000000000 ffffffff817207de
  ffff8800da9f3b10 ffff880074e47fd8 00000000000127c0 00000000000127c0
Call Trace:
  [<ffffffff8171e362>] ? dump_stack+0x41/0x51
  [<ffffffff81073169>] ? do_raw_spin_lock+0x69/0x140
  [<ffffffff817207de>] ? __schedule+0x9e/0x810
  [<ffffffff8107d450>] ? wake_up_klogd+0x30/0x40
  [<ffffffff8171c3a5>] ? printk+0x54/0x56
  [<ffffffff8103e2d9>] ? do_exit+0x909/0x9f0
  [<ffffffff81005a8a>] ? oops_end+0x6a/0x90
  [<ffffffff8171b805>] ? no_context+0x25e/0x26a
  [<ffffffff810342ff>] ? __do_page_fault+0x2af/0x460
  [<ffffffff81099deb>] ? __sprint_symbol+0x8b/0xe0
  [<ffffffff812a4c06>] ? string.isra.5+0x36/0xe0
  [<ffffffff812a504c>] ? symbol_string.isra.10+0x5c/0xa0
  [<ffffffff81724be2>] ? page_fault+0x22/0x30
  [<ffffffff8105a85c>] ? kthread_data+0xc/0x20
  [<ffffffff81054d8d>] ? wq_worker_sleeping+0xd/0x80
  [<ffffffff81720b3d>] ? __schedule+0x3fd/0x810
  [<ffffffff812b22eb>] ? debug_object_active_state+0x12b/0x170
  [<ffffffff8103d330>] ? will_become_orphaned_pgrp+0xb0/0xb0
  [<ffffffff8103e072>] ? do_exit+0x6a2/0x9f0
  [<ffffffff81005a8a>] ? oops_end+0x6a/0x90
  [<ffffffff8171b805>] ? no_context+0x25e/0x26a
  [<ffffffff810342ff>] ? __do_page_fault+0x2af/0x460
  [<ffffffff8106d263>] ? idle_balance+0x193/0x1a0
  [<ffffffff817243fa>] ? _raw_spin_unlock_irq+0xa/0x10
  [<ffffffff81062597>] ? finish_task_switch+0x57/0xa0
  [<ffffffff817209ea>] ? __schedule+0x2aa/0x810
  [<ffffffff81724be2>] ? page_fault+0x22/0x30
  [<ffffffffa05c8ad6>] ? zlib_uncompress+0xc6/0x190 [squashfs]
  [<ffffffffa05c8a48>] ? zlib_uncompress+0x38/0x190 [squashfs]
  [<ffffffffa05c83f4>] ? squashfs_decompress+0x64/0xa0 [squashfs]
  [<ffffffffa05c4109>] ? squashfs_buffer_read_async+0x69/0x2e0 [squashfs]
  [<ffffffff810536d5>] ? process_one_work+0x175/0x3f0
  [<ffffffff81054224>] ? worker_thread+0x114/0x3a0
  [<ffffffff81054110>] ? manage_workers.isra.26+0x290/0x290
  [<ffffffff8105a226>] ? kthread+0xc6/0xe0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
  [<ffffffff817252ac>] ? ret_from_fork+0x7c/0xb0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
sending NMI to all CPUs:
NMI backtrace for cpu 1
CPU: 1 PID: 4877 Comm: kworker/1:3 Tainted: G      D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff8800da9f3b10 ti: ffff880074e46000 task.ti: ffff880074e46000
RIP: 0010:[<ffffffff8102f8e7>]  [<ffffffff8102f8e7>] flat_send_IPI_mask+0x57/0x80
RSP: 0018:ffff880074e475b8  EFLAGS: 00010046
RAX: 0000000000000c00 RBX: 0000000000000c00 RCX: 0000000000000006
RDX: ffffffff81c1e140 RSI: 0000000000000002 RDI: 0000000000000300
RBP: 0000000000000096 R08: 0000000000000400 R09: 0000000000000267
R10: 0000000000000266 R11: 0000000000000006 R12: 000000000000000f
R13: 0000000000000001 R14: ffffffffffffffc8 R15: ffff8800da9f3b10
FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 0000000057bd8000 CR4: 00000000000006e0
Stack:
  0000000200000001 0000000000002710 0000000088c1cfb8 0000000088c1cfb8
  ffffffff8102c9b7 ffff88011fc927c0 ffffffff8107316e ffff88011fc927c0
  ffff880074e47708 0000000000000000 ffffffff817207de ffff8800da9f3b10
Call Trace:
  [<ffffffff8102c9b7>] ? arch_trigger_all_cpu_backtrace+0x47/0x80
  [<ffffffff8107316e>] ? do_raw_spin_lock+0x6e/0x140
  [<ffffffff817207de>] ? __schedule+0x9e/0x810
  [<ffffffff8107d450>] ? wake_up_klogd+0x30/0x40
  [<ffffffff8171c3a5>] ? printk+0x54/0x56
  [<ffffffff8103e2d9>] ? do_exit+0x909/0x9f0
  [<ffffffff81005a8a>] ? oops_end+0x6a/0x90
  [<ffffffff8171b805>] ? no_context+0x25e/0x26a
  [<ffffffff810342ff>] ? __do_page_fault+0x2af/0x460
  [<ffffffff81099deb>] ? __sprint_symbol+0x8b/0xe0
  [<ffffffff812a4c06>] ? string.isra.5+0x36/0xe0
  [<ffffffff812a504c>] ? symbol_string.isra.10+0x5c/0xa0
  [<ffffffff81724be2>] ? page_fault+0x22/0x30
  [<ffffffff8105a85c>] ? kthread_data+0xc/0x20
  [<ffffffff81054d8d>] ? wq_worker_sleeping+0xd/0x80
  [<ffffffff81720b3d>] ? __schedule+0x3fd/0x810
  [<ffffffff812b22eb>] ? debug_object_active_state+0x12b/0x170
  [<ffffffff8103d330>] ? will_become_orphaned_pgrp+0xb0/0xb0
  [<ffffffff8103e072>] ? do_exit+0x6a2/0x9f0
  [<ffffffff81005a8a>] ? oops_end+0x6a/0x90
  [<ffffffff8171b805>] ? no_context+0x25e/0x26a
  [<ffffffff810342ff>] ? __do_page_fault+0x2af/0x460
  [<ffffffff8106d263>] ? idle_balance+0x193/0x1a0
  [<ffffffff817243fa>] ? _raw_spin_unlock_irq+0xa/0x10
  [<ffffffff81062597>] ? finish_task_switch+0x57/0xa0
  [<ffffffff817209ea>] ? __schedule+0x2aa/0x810
  [<ffffffff81724be2>] ? page_fault+0x22/0x30
  [<ffffffffa05c8ad6>] ? zlib_uncompress+0xc6/0x190 [squashfs]
  [<ffffffffa05c8a48>] ? zlib_uncompress+0x38/0x190 [squashfs]
  [<ffffffffa05c83f4>] ? squashfs_decompress+0x64/0xa0 [squashfs]
  [<ffffffffa05c4109>] ? squashfs_buffer_read_async+0x69/0x2e0 [squashfs]
  [<ffffffff810536d5>] ? process_one_work+0x175/0x3f0
  [<ffffffff81054224>] ? worker_thread+0x114/0x3a0
  [<ffffffff81054110>] ? manage_workers.isra.26+0x290/0x290
  [<ffffffff8105a226>] ? kthread+0xc6/0xe0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
  [<ffffffff817252ac>] ? ret_from_fork+0x7c/0xb0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
Code: 25 00 b3 5f ff f6 c4 10 75 f2 44 89 e0 c1 e0 18 89 04 25 10 b3 5f ff 89 f0 09 d8 80 cf 04 83 fe 02 0f 44 c3 89 04 25 00 b3 5f ff <55> 9d 48 83 c4 08 5b 5d 41 5c c3 89 74 24 04 ff 92 50 01 00 00
NMI backtrace for cpu 2
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 115.138 msecs
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff88011b07c1a0 ti: ffff88011b0fa000 task.ti: ffff88011b0fa000
RIP: 0010:[<ffffffff8100ae3b>]  [<ffffffff8100ae3b>] default_idle+0x1b/0xa0
RSP: 0018:ffff88011b0fbf00  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0100000000000000
RDX: 0100000000000000 RSI: 0000000000000000 RDI: ffff88011fd0d280
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88011b0fbfd8
R13: ffff88011b0fbfd8 R14: ffffffff81cd8fd0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 000000011a7e3000 CR4: 00000000000006e0
Stack:
  0000000000000000 ffff88011b0fbfd8 ffffffff8107f1a1 ffff88011b0fbfd8
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff8107f1a1>] ? cpu_startup_entry+0x141/0x220
Code: 9c 2d 05 00 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 8b 05 dd 6e cc 00 55 65 8b 2c 25 1c b0 00 00 53 85 c0 7f 17 fb f4 <8b> 05 c7 6e cc 00 65 8b 2c 25 1c b0 00 00 85 c0 7f 3b 5b 5d c3
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 141.182 msecs
NMI backtrace for cpu 0
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffffffff81c10480 ti: ffffffff81c00000 task.ti: ffffffff81c00000
RIP: 0010:[<ffffffff8100ae3b>]  [<ffffffff8100ae3b>] default_idle+0x1b/0xa0
RSP: 0018:ffffffff81c01f68  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffffffffffff RCX: 0100000000000000
RDX: 0100000000000000 RSI: 0000000000000000 RDI: ffff88011fc0d280
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81c01fd8
R13: ffffffff81c01fd8 R14: ffffffff81cd8fd0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 00000000daa9f000 CR4: 00000000000006f0
Stack:
  ffffffffffffffff ffffffff81c01fd8 ffffffff8107f1a1 ffffffff81c01fd8
  ffffffffffffffff ffffffff81d82920 ffff88011ffcd540 ffffffff81d892c0
  0000000000000000 0000000000000000 ffffffff81cf4d9c ffffffff81cf4849
Call Trace:
  [<ffffffff8107f1a1>] ? cpu_startup_entry+0x141/0x220
  [<ffffffff81cf4d9c>] ? start_kernel+0x376/0x381
  [<ffffffff81cf4849>] ? repair_env_string+0x58/0x58
Code: 9c 2d 05 00 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 8b 05 dd 6e cc 00 55 65 8b 2c 25 1c b0 00 00 53 85 c0 7f 17 fb f4 <8b> 05 c7 6e cc 00 65 8b 2c 25 1c b0 00 00 85 c0 7f 3b 5b 5d c3
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 141.252 msecs
NMI backtrace for cpu 3
CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff88011b07c830 ti: ffff88011b0fc000 task.ti: ffff88011b0fc000
RIP: 0010:[<ffffffff8100ae3b>]  [<ffffffff8100ae3b>] default_idle+0x1b/0xa0
RSP: 0018:ffff88011b0fdf00  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0100000000000000
RDX: 0100000000000000 RSI: 0000000000000000 RDI: ffff88011fd8d280
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88011b0fdfd8
R13: ffff88011b0fdfd8 R14: ffffffff81cd8fd0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 00000000dbb8f000 CR4: 00000000000006e0
Stack:
  0000000000000000 ffff88011b0fdfd8 ffffffff8107f1a1 ffff88011b0fdfd8
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff8107f1a1>] ? cpu_startup_entry+0x141/0x220
Code: 9c 2d 05 00 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 8b 05 dd 6e cc 00 55 65 8b 2c 25 1c b0 00 00 53 85 c0 7f 17 fb f4 <8b> 05 c7 6e cc 00 65 8b 2c 25 1c b0 00 00 85 c0 7f 3b 5b 5d c3
hda: DMA interrupt recovery
hda: lost interrupt
hda: ide_dma_sff_timer_expiry: DMA status (0x64)
hda: DMA interrupt recovery
hda: lost interrupt
ide-atapi: cmd 0x3 timed out
hdc: lost interrupt
hda: lost interrupt
hda: lost interrupt
BUG: spinlock lockup suspected on CPU#3, syslogd/2719
  lock: 0xffff88011fc927c0, .magic: dead4ead, .owner: kworker/1:3/4877, .owner_cpu: 1
CPU: 3 PID: 2719 Comm: syslogd Tainted: G      D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  0000000088c1cfb8 ffffffff8171e362 ffff88011fc927c0 ffffffff81073169
  ffff88011b36c1a0 00000000000127c0 ffff88011fc927c0 ffffffff81065fc6
  0000000000000000 ffff88011b36c1a0 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff8171e362>] ? dump_stack+0x41/0x51
  [<ffffffff81073169>] ? do_raw_spin_lock+0x69/0x140
  [<ffffffff81065fc6>] ? wake_up_new_task+0x96/0x170
  [<ffffffff8103bdaf>] ? do_fork+0x12f/0x2f0
  [<ffffffff81122d50>] ? __fd_install+0x20/0x50
  [<ffffffff817255f9>] ? stub_clone+0x69/0x90
  [<ffffffff81725352>] ? system_call_fastpath+0x16/0x1b
sending NMI to all CPUs:
NMI backtrace for cpu 3
CPU: 3 PID: 2719 Comm: syslogd Tainted: G      D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff8800d9d541a0 ti: ffff8800dbb8a000 task.ti: ffff8800dbb8a000
RIP: 0010:[<ffffffff8102f8e7>]  [<ffffffff8102f8e7>] flat_send_IPI_mask+0x57/0x80
RSP: 0018:ffff8800dbb8be60  EFLAGS: 00010046
RAX: 0000000000000c00 RBX: 0000000000000c00 RCX: 000000000000fefd
RDX: ffffffff81c1e140 RSI: 0000000000000002 RDI: 0000000000000300
RBP: 0000000000000086 R08: 0000000000000400 R09: 00000000000002fe
R10: 00000000000002fd R11: 0000000000000006 R12: 000000000000000f
R13: ffff88011b36c6a8 R14: 0000000000000246 R15: 0000000000001311
FS:  00007f71050c86f0(0000) GS:ffff88011fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000060ce00 CR3: 00000000daa9f000 CR4: 00000000000006e0
Stack:
  0000000200000001 0000000000002710 0000000088c1cfb8 0000000088c1cfb8
  ffffffff8102c9b7 ffff88011fc927c0 ffffffff8107316e ffff88011b36c1a0
  00000000000127c0 ffff88011fc927c0 ffffffff81065fc6 0000000000000000
Call Trace:
  [<ffffffff8102c9b7>] ? arch_trigger_all_cpu_backtrace+0x47/0x80
  [<ffffffff8107316e>] ? do_raw_spin_lock+0x6e/0x140
  [<ffffffff81065fc6>] ? wake_up_new_task+0x96/0x170
  [<ffffffff8103bdaf>] ? do_fork+0x12f/0x2f0
  [<ffffffff81122d50>] ? __fd_install+0x20/0x50
  [<ffffffff817255f9>] ? stub_clone+0x69/0x90
  [<ffffffff81725352>] ? system_call_fastpath+0x16/0x1b
Code: 25 00 b3 5f ff f6 c4 10 75 f2 44 89 e0 c1 e0 18 89 04 25 10 b3 5f ff 89 f0 09 d8 80 cf 04 83 fe 02 0f 44 c3 89 04 25 00 b3 5f ff <55> 9d 48 83 c4 08 5b 5d 41 5c c3 89 74 24 04 ff 92 50 01 00 00
NMI backtrace for cpu 1
CPU: 1 PID: 4877 Comm: kworker/1:3 Tainted: G      D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff8800da9f3b10 ti: ffff880074e46000 task.ti: ffff880074e46000
RIP: 0010:[<ffffffff81073222>]  [<ffffffff81073222>] do_raw_spin_lock+0x122/0x140
RSP: 0018:ffff880074e475f0  EFLAGS: 00000002
RAX: 0000000000000027 RBX: ffff88011fc927c0 RCX: 000000007beba1ad
RDX: 0000000000000028 RSI: 0000000000000001 RDI: 0000000000230471
RBP: 0000000088c1cfb8 R08: 0000000000000400 R09: 0000000000000267
R10: 0000000000000266 R11: 0000000000000006 R12: 0000000088c1cfb8
R13: 0000000000000001 R14: ffffffffffffffc8 R15: ffff8800da9f3b10
FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 0000000057bd8000 CR4: 00000000000006e0
Stack:
  ffff88011fc927c0 ffff880074e47708 0000000000000000 ffffffff817207de
  ffff8800da9f3b10 ffff880074e47fd8 00000000000127c0 00000000000127c0
  ffff8800da9f3b10 0000000000000000 0000000000000001 ffffffff8107d450
Call Trace:
  [<ffffffff817207de>] ? __schedule+0x9e/0x810
  [<ffffffff8107d450>] ? wake_up_klogd+0x30/0x40
  [<ffffffff8171c3a5>] ? printk+0x54/0x56
  [<ffffffff8103e2d9>] ? do_exit+0x909/0x9f0
  [<ffffffff81005a8a>] ? oops_end+0x6a/0x90
  [<ffffffff8171b805>] ? no_context+0x25e/0x26a
  [<ffffffff810342ff>] ? __do_page_fault+0x2af/0x460
  [<ffffffff81099deb>] ? __sprint_symbol+0x8b/0xe0
  [<ffffffff812a4c06>] ? string.isra.5+0x36/0xe0
  [<ffffffff812a504c>] ? symbol_string.isra.10+0x5c/0xa0
  [<ffffffff81724be2>] ? page_fault+0x22/0x30
  [<ffffffff8105a85c>] ? kthread_data+0xc/0x20
  [<ffffffff81054d8d>] ? wq_worker_sleeping+0xd/0x80
  [<ffffffff81720b3d>] ? __schedule+0x3fd/0x810
  [<ffffffff812b22eb>] ? debug_object_active_state+0x12b/0x170
  [<ffffffff8103d330>] ? will_become_orphaned_pgrp+0xb0/0xb0
  [<ffffffff8103e072>] ? do_exit+0x6a2/0x9f0
  [<ffffffff81005a8a>] ? oops_end+0x6a/0x90
  [<ffffffff8171b805>] ? no_context+0x25e/0x26a
  [<ffffffff810342ff>] ? __do_page_fault+0x2af/0x460
  [<ffffffff8106d263>] ? idle_balance+0x193/0x1a0
  [<ffffffff817243fa>] ? _raw_spin_unlock_irq+0xa/0x10
  [<ffffffff81062597>] ? finish_task_switch+0x57/0xa0
  [<ffffffff817209ea>] ? __schedule+0x2aa/0x810
  [<ffffffff81724be2>] ? page_fault+0x22/0x30
  [<ffffffffa05c8ad6>] ? zlib_uncompress+0xc6/0x190 [squashfs]
  [<ffffffffa05c8a48>] ? zlib_uncompress+0x38/0x190 [squashfs]
  [<ffffffffa05c83f4>] ? squashfs_decompress+0x64/0xa0 [squashfs]
  [<ffffffffa05c4109>] ? squashfs_buffer_read_async+0x69/0x2e0 [squashfs]
  [<ffffffff810536d5>] ? process_one_work+0x175/0x3f0
  [<ffffffff81054224>] ? worker_thread+0x114/0x3a0
  [<ffffffff81054110>] ? manage_workers.isra.26+0x290/0x290
  [<ffffffff8105a226>] ? kthread+0xc6/0xe0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
  [<ffffffff817252ac>] ? ret_from_fork+0x7c/0xb0
  [<ffffffff8105a160>] ? kthread_create_on_node+0x1a0/0x1a0
Code: 00 e9 40 ff ff ff 48 c7 c6 ae 72 9a 81 48 89 df e8 08 90 6a 00 e9 1b ff ff ff 48 c7 c6 cd 1c 97 81 e8 f7 8f 6a 00 e9 f7 fe ff ff <0f> b6 03 38 c2 0f 84 56 ff ff ff f3 90 90 eb f0 66 66 66 66 66
NMI backtrace for cpu 2
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 160.716 msecs
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff88011b07c1a0 ti: ffff88011b0fa000 task.ti: ffff88011b0fa000
RIP: 0010:[<ffffffff8100ae3b>]  [<ffffffff8100ae3b>] default_idle+0x1b/0xa0
RSP: 0018:ffff88011b0fbf00  EFLAGS: 00000246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0100000000000000
RDX: 0100000000000000 RSI: 0000000000000000 RDI: ffff88011fd0d280
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88011b0fbfd8
R13: ffff88011b0fbfd8 R14: ffffffff81cd8fd0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffffff600400 CR3: 00000000db23b000 CR4: 00000000000006e0
Stack:
  0000000000000000 ffff88011b0fbfd8 ffffffff8107f1a1 ffff88011b0fbfd8
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
  [<ffffffff8107f1a1>] ? cpu_startup_entry+0x141/0x220
Code: 9c 2d 05 00 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 8b 05 dd 6e cc 00 55 65 8b 2c 25 1c b0 00 00 53 85 c0 7f 17 fb f4 <8b> 05 c7 6e cc 00 65 8b 2c 25 1c b0 00 00 85 c0 7f 3b 5b 5d c3
INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 202.778 msecs
NMI backtrace for cpu 0
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D      3.13.0-rc3+ #32
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffffffff81c10480 ti: ffffffff81c00000 task.ti: ffffffff81c00000
RIP: 0010:[<ffffffff8100ae3b>]  [<ffffffff8100ae3b>] default_idle+0x1b/0xa0
RSP: 0018:ffffffff81c01f68  EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffffffffffffffff RCX: 0100000000000000
RDX: 0100000000000000 RSI: 0000000000000000 RDI: ffff88011fc0d280
R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81c01fd8
R13: ffffffff81c01fd8 R14: ffffffff81cd8fd0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000608060 CR3: 0000000031f37000 CR4: 00000000000006f0
Stack:
  ffffffffffffffff ffffffff81c01fd8 ffffffff8107f1a1 ffffffff81c01fd8
  ffffffffffffffff ffffffff81d82920 ffff88011ffcd540 ffffffff81d892c0
  0000000000000000 0000000000000000 ffffffff81cf4d9c ffffffff81cf4849
Call Trace:
  [<ffffffff8107f1a1>] ? cpu_startup_entry+0x141/0x220
  [<ffffffff81cf4d9c>] ? start_kernel+0x376/0x381
  [<ffffffff81cf4849>] ? repair_env_string+0x58/0x58
Code: 9c 2d 05 00 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 8b 05 dd 6e cc 00 55 65 8b 2c 25 1c b0 00 00 53 85 c0 7f 17 fb f4 <8b> 05 c7 6e cc 00 65 8b 2c 25 1c b0 00 00 85 c0 7f 3b 5b 5d c3
qemu: terminating on signal 15 from pid 7695
*****************************************************************

To summarise, I am entirely unconvinced about the merits of
adding the asynchronous patch.  Two last points need to be made here:

1. Squashfs's readpage() is fairly unique and unusual, in that it
    does readahead itself and adds multiple pages to the page cache in
    one call, this is obviously because Squashfs blocks tend to be much
    larger than the page size.  Conversely, most other filesystems
    readpage() routines add the page it has been called to read and
    that is it.  As such making Squashfs readpage() asynchronous
    offers the real risk of introducing page races within code that
    does not exist with the synchronous Squashfs readpage() implementation
    or with other filesystem's asynchronous readpage() implementations.

    The fact that the asynchronous Squashfs readpage() implementation
    shows worse performance than the synchronous readpage() implementation
    when multiple asynchronous readpage() calls do not take place, and
    generates kernel oopses when multiple asynchronous readpage()
    calls do take place, shows that the above fears are borne out.

2. An observation which may not be immediately obvious.

   Let's look again at the performance results, specifically the best
   results for the asynchronous patch where it outperforms
   the synchronous readpage().

Squashfs: gzip filesystem 128K blocks

	Asyn	No Asyn	Asyn	No Asyn	Asyn	No Asyn
	Single	Single	Multi	Multi	Percpu	Percpu
-------------------------------------------------------
32K:	42.9	47.2	43.0	46.1	42.9	47.1
64K:	50.7	47.0	55.1	53.1	55.2	49.6
128K:	51.1	47.6	54.9	49.2	55.7	48.7
256K:	51.0	49.5	54.7	48.2	57.3	49.3
512K:	53.6	48.2	55.2	47.6	54.9	48.3
1024K:	51.1	47.9	54.7	47.5	54.6	46.5

Now compare them against the performance results for 256K block filesystems.

Squashfs: gzip filesystem 256K blocks

	Asyn	No Asyn	Asyn	No Asyn	Asyn	No Asyn
	Single	Single	Multi	Multi	Percpu	Percpu
-------------------------------------------------------
32K:	54.0	95.9	53.8	98.7	53.9	85.3
64K:	53.7	86.9	53.4	103	53.4	86.3
128K:	53.2	94.4	53.6	100	53.7	97.9
256K:	55.5	101	53.0	94.1	53.3	87.0
512K:	53.1	93.0	53.4	87.7	53.2	89.8
1024K:	53.2	91.4	52.7	91.3	53.0	95.4

So you're using a 128K block filesystem and add asynchronous readpage
to gain a 16% improvement.  A somewhat better approach would be to
move to a 256K block filesystem, and gain a 74% performance boost.

Phillip
