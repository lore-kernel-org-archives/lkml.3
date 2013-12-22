Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3LVUlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 15:41:49 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39442 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab3LVUlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 15:41:47 -0500
Message-ID: <52B74E81.4000305@oracle.com>
Date: Sun, 22 Dec 2013 15:41:37 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: kernfs: gpf when offlining cpus
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel, I've stumbled on 
the following spew.

Beyond regular trinity fuzzing, the machine was in the middle of attempting to offline all of it's 
cpus (64 of them).

[  696.029538] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  696.030042] Dumping ftrace buffer:
[  696.030042]    (ftrace buffer empty)
[  696.030042] Modules linked in:
[  696.030042] CPU: 49 PID: 18975 Comm: trinity-c574 Tainted: G        W    3.13.0-rc4-
next-20131220-sasha-00013-gf9a57f1-dirty #6
[  696.030042] task: ffff8801ced5b000 ti: ffff8801d384e000 task.ti: ffff8801d384e000
[  696.030042] RIP: 0010:[<ffffffff8135d5cb>]  [<ffffffff8135d5cb>] sysfs_file_ops+0x5b
/0x70
[  696.030042] RSP: 0018:ffff8801d384f858  EFLAGS: 00010202
[  696.030042] RAX: 0000000000000000 RBX: ffff88010bd938e0 RCX: 0000000000000001
[  696.030042] RDX: 6b6b6b6b6b6b6b6b RSI: ffff88007de8e6c8 RDI: 0000000000000286
[  696.030042] RBP: ffff8801d384f868 R08: 0000000000000000 R09: 0000000000000003
[  696.030042] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88012c1537c8
[  696.030042] R13: ffff88010bd938e0 R14: ffff88001b8ecb48 R15: ffff8801d384f8f0
[  696.030042] FS:  00007f63221d6700(0000) GS:ffff88003f400000(0000) knlGS:000000000000
0000
[  696.030042] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  696.030042] CR2: 000000000068c000 CR3: 00000001e8d66000 CR4: 00000000000006e0
[  696.030042] DR0: 0000000000697000 DR1: 0000000000000000 DR2: 0000000000000000
[  696.030042] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000010602
[  696.030042] Stack:
[  696.030042]  ffff8801d384f878 ffff88012c1537c8 ffff8801d384f898 ffffffff8135d68d
[  696.030042]  ffff88001a21f900 ffff88012c1537c8 0000000000000001 ffff8801d384f978
[  696.030042]  ffff8801d384f8a8 ffffffff813608b9 ffff8801d384f928 ffffffff812fdfba
[  696.030042] Call Trace:
[  696.030042]  [<ffffffff8135d68d>] sysfs_kf_seq_show+0x3d/0x130
[  696.030042]  [<ffffffff813608b9>] kernfs_seq_show+0x29/0x30
[  696.030042]  [<ffffffff812fdfba>] seq_read+0x1ba/0x430
[  696.030042]  [<ffffffff81361a69>] kernfs_fop_read+0x29/0x40
[  696.030042]  [<ffffffff812d48dc>] do_readv_writev+0x18c/0x2e0
[  696.030042]  [<ffffffff81361a40>] ? kernfs_file_direct_read+0x130/0x130
[  696.030042]  [<ffffffff812a3244>] ? alloc_pages_current+0x1f4/0x230
[  696.030042]  [<ffffffff8130a20c>] ? default_file_splice_read+0x12c/0x330
[  696.030042]  [<ffffffff81174b35>] ? sched_clock_local+0x25/0x90
[  696.030042]  [<ffffffff812d4c53>] vfs_readv+0x43/0x50
[  696.030042]  [<ffffffff8130a2d1>] default_file_splice_read+0x1f1/0x330
[  696.030042]  [<ffffffff8118dbce>] ? put_lock_stats+0xe/0x30
[  696.030042]  [<ffffffff812ab6bf>] ? deactivate_slab+0x8cf/0x920
[  696.030042]  [<ffffffff845db6d5>] ? _raw_spin_unlock+0x35/0x60
[  696.030042]  [<ffffffff812ab6bf>] ? deactivate_slab+0x8cf/0x920
[  696.030042]  [<ffffffff8106ea41>] ? dump_trace+0x2c1/0x2f0
[  696.030042]  [<ffffffff812aa831>] ? get_partial_node+0x471/0x4b0
[  696.030042]  [<ffffffff812dda86>] ? alloc_pipe_info+0x46/0xd0
[  696.030042]  [<ffffffff812a77fb>] ? set_track+0xab/0x100
[  696.030042]  [<ffffffff812abdf7>] ? __slab_alloc+0x677/0x6c0
[  696.030042]  [<ffffffff811930fd>] ? trace_hardirqs_on+0xd/0x10
[  696.030042]  [<ffffffff81194eea>] ? __lock_release+0x1da/0x1f0
[  696.030042]  [<ffffffff845e0030>] ? __do_page_fault+0x530/0x5a0
[  696.030042]  [<ffffffff812dda86>] ? alloc_pipe_info+0x46/0xd0
[  696.030042]  [<ffffffff81308410>] ? page_cache_pipe_buf_release+0x30/0x30
[  696.030042]  [<ffffffff81308f4a>] do_splice_to+0x8a/0xa0
[  696.030042]  [<ffffffff81309823>] splice_direct_to_actor+0xd3/0x1e0
[  696.030042]  [<ffffffff813081e0>] ? splice_from_pipe_begin+0x20/0x20
[  696.030042]  [<ffffffff813099d6>] do_splice_direct+0xa6/0xc0
[  696.030042]  [<ffffffff812d34ec>] ? rw_verify_area+0xcc/0x100
[  696.030042]  [<ffffffff812d3b67>] do_sendfile+0x1d7/0x3a0
[  696.030042]  [<ffffffff812d5431>] SyS_sendfile64+0x61/0xc0
[  696.030042]  [<ffffffff845e4e90>] tracesys+0xdd/0xe2
[  696.030042] Code: e8 eb 12 e3 ff 85 c0 75 17 be 21 00 00 00 48 c7 c7 1b 0d 7c 85 e8
b6 23 dd ff 66 0f 1f 44 00 00 48 8b 53 28 31 c0 48 85 d2 74 04 <48> 8b 42 08 48 83 c4 0
8 5b c9 c3 66 2e 0f 1f 84 00 00 00 00 00
[  696.030042] RIP  [<ffffffff8135d5cb>] sysfs_file_ops+0x5b/0x70
[  696.030042]  RSP <ffff8801d384f858>


Thanks,
Sasha
