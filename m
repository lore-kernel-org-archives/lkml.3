Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbaAIXM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:12:57 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31364 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaAIXMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:12:54 -0500
Message-ID: <52CF2CEC.3010003@oracle.com>
Date: Thu, 09 Jan 2014 18:12:44 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, slava@dubeyko.com,
        Kent Overstreet <kmo@daterainc.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: hfsplus: kernel panic in hfsplus_brec_lenoff
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel
I've stumbled on the following spew:

[ 5835.181300] BUG: unable to handle kernel paging request at ffff880055a3cffa
[ 5835.182211] IP: [<ffffffff81adbb42>] memcpy+0x12/0x110
[ 5835.182723] PGD 8d98067 PUD 22fc82067 PMD 22fbd4067 PTE 8000000055a3c060
[ 5835.183547] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 5835.184143] Dumping ftrace buffer:
[ 5835.184561]    (ftrace buffer empty)
[ 5835.184914] Modules linked in:
[ 5835.185338] CPU: 2 PID: 29032 Comm: trinity-main Tainted: G        W 
3.13.0-rc7-next-20140108-sasha-00011-g249c5bb-dirty #51
[ 5835.186436] task: ffff88005fe23000 ti: ffff88005d2da000 task.ti: ffff88005d2da000
[ 5835.190087] RIP: 0010:[<ffffffff81adbb42>]  [<ffffffff81adbb42>] memcpy+0x12/0x110
[ 5835.190087] RSP: 0018:ffff88005d2db9c0  EFLAGS: 00010202
[ 5835.190087] RAX: ffff88005d2dba28 RBX: ffff88005d2dba28 RCX: 0000000000000004
[ 5835.190868] RDX: 0000000000000004 RSI: ffff880055a3cffa RDI: ffff88005d2dba28
[ 5835.190868] RBP: ffff88005d2dba18 R08: 0000000000000012 R09: ffff880000000000
[ 5835.190868] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000004
[ 5835.190868] R13: 0000000000000004 R14: 0000000000000004 R15: ffff88005d1c9860
[ 5835.190868] FS:  00007fa01dd66700(0000) GS:ffff88005f000000(0000) knlGS:0000000000000000
[ 5835.190868] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5835.190868] CR2: ffff880055a3cffa CR3: 0000000058f2c000 CR4: 00000000000006e0
[ 5835.190868] DR0: 0000000000697000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5835.190868] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[ 5835.190868] Stack:
[ 5835.190868]  ffffffff8149dbf0 ffff880000000000 0000160000000000 0000000000000012
[ 5835.190868]  ffffea0001568f00 ffff88005d1c9888 ffff88005d2dba76 ffff88005d1c9860
[ 5835.190868]  0000000000000001 ffffffff8149fcd0 ffff88005d2dba76 ffff88005d2dba48
[ 5835.190868] Call Trace:
[ 5835.190868]  [<ffffffff8149dbf0>] ? hfsplus_bnode_read+0xb0/0x140
[ 5835.190868]  [<ffffffff8149fcd0>] ? hfsplus_brec_keylen+0xc0/0xc0
[ 5835.190868]  [<ffffffff8149ee73>] hfsplus_brec_lenoff+0x33/0x50
[ 5835.190868]  [<ffffffff8149e0cc>] ? hfsplus_bnode_find+0x5c/0x2b0
[ 5835.190868]  [<ffffffff8149fdb7>] __hfsplus_brec_find+0x67/0x150
[ 5835.190868]  [<ffffffff811a24cd>] ? trace_hardirqs_on+0xd/0x10
[ 5835.190868]  [<ffffffff814a02fd>] ? hfsplus_find_init+0x6d/0xb0
[ 5835.190868]  [<ffffffff814a00cc>] hfsplus_brec_find+0xac/0x140
[ 5835.190868]  [<ffffffff81183e05>] ? sched_clock_local+0x25/0x90
[ 5835.190868]  [<ffffffff8149fcd0>] ? hfsplus_brec_keylen+0xc0/0xc0
[ 5835.190868]  [<ffffffff8149baff>] hfsplus_readdir+0x9f/0x480
[ 5835.190868]  [<ffffffff811e68e6>] ? __module_text_address+0x16/0x70
[ 5835.190868]  [<ffffffff811e6970>] ? is_module_text_address+0x30/0x60
[ 5835.190868]  [<ffffffff810b7214>] ? kvm_clock_read+0x24/0x50
[ 5835.190868]  [<ffffffff81077eed>] ? sched_clock+0x1d/0x30
[ 5835.190868]  [<ffffffff81183e05>] ? sched_clock_local+0x25/0x90
[ 5835.190868]  [<ffffffff810b7214>] ? kvm_clock_read+0x24/0x50
[ 5835.190868]  [<ffffffff81077eed>] ? sched_clock+0x1d/0x30
[ 5835.190868]  [<ffffffff810b7214>] ? kvm_clock_read+0x24/0x50
[ 5835.190868]  [<ffffffff81077eed>] ? sched_clock+0x1d/0x30
[ 5835.190868]  [<ffffffff81183e05>] ? sched_clock_local+0x25/0x90
[ 5835.190868]  [<ffffffff81183f78>] ? sched_clock_cpu+0x108/0x120
[ 5835.190868]  [<ffffffff811a3b2a>] ? __lock_acquire+0x4ca/0x580
[ 5835.190868]  [<ffffffff8119cf3a>] ? get_lock_stats+0x2a/0x60
[ 5835.190868]  [<ffffffff811a1ef9>] ? mark_held_locks+0x109/0x140
[ 5835.190868]  [<ffffffff846231d8>] ? mutex_lock_killable_nested+0x4b8/0x620
[ 5835.190868]  [<ffffffff811a24cd>] ? trace_hardirqs_on+0xd/0x10
[ 5835.190868]  [<ffffffff8462320f>] ? mutex_lock_killable_nested+0x4ef/0x620
[ 5835.190868]  [<ffffffff812fc83b>] ? iterate_dir+0x5b/0xe0
[ 5835.190868]  [<ffffffff812fc83b>] ? iterate_dir+0x5b/0xe0
[ 5835.190868]  [<ffffffff812fc864>] iterate_dir+0x84/0xe0
[ 5835.190868]  [<ffffffff812fca40>] SyS_getdents+0x90/0x100
[ 5835.190868]  [<ffffffff812fcb40>] ? SyS_old_readdir+0x90/0x90
[ 5835.190868]  [<ffffffff84630610>] tracesys+0xdd/0xe2
[ 5835.190868] Code: b6 c0 eb 07 0f 1f 44 00 00 31 c0 48 83 c4 08 5b c9 c3 90 90 90 90 90 90 90 48 
89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d1 <f3> a4 c3 20 4c 8b 06 4c 8b 4e 08 4c 8b 56 10 4c 
8b 5e 18 48 8d
[ 5835.190868] RIP  [<ffffffff81adbb42>] memcpy+0x12/0x110
[ 5835.190868]  RSP <ffff88005d2db9c0>
[ 5835.190868] CR2: ffff880055a3cffa


Thanks,
Sasha
