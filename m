Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3LTXk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 18:40:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23440 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3LTXk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 18:40:57 -0500
Message-ID: <52B4D581.40103@oracle.com>
Date: Fri, 20 Dec 2013 18:40:49 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: module: BUG in copy_module_from_fd
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel, I've stumbled on 
the following spew.

This reproduced twice with the same call trace, so I suspect it's something specific with the way
the module subsystem calls vfs_getattr rather than something odd in vfs.

[ 1694.568277] BUG: unable to handle kernel paging request at ffff88022adf8010
[ 1694.570053] IP: [<ffffffff812d77ed>] generic_fillattr+0xd/0xa0
[ 1694.570053] PGD 8577067 PUD 42effb067 PMD 42eea4067 PTE 800000022adf8060
[ 1694.570053] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1694.570053] Dumping ftrace buffer:
[ 1694.570053]    (ftrace buffer empty)
[ 1694.570053] Modules linked in:
[ 1694.570053] CPU: 60 PID: 35977 Comm: trinity-child60 Tainted: G        W    3.13.0-r
c4-next-20131219-sasha-00014-g94c0243-dirty #4166
[ 1694.570053] task: ffff8801064b8000 ti: ffff88013b56a000 task.ti: ffff88013b56a000
[ 1694.570053] waiting module removal not supported: please upgrade
[ 1694.570053] RIP: 0010:[<ffffffff812d77ed>]  [<ffffffff812d77ed>] generic_fillattr+0x
d/0xa0
[ 1694.570053] RSP: 0018:ffff88013b56bdd8  EFLAGS: 00010246
[ 1694.570053] RAX: ffff88022adf8000 RBX: ffff88018d5202d0 RCX: ffff8801584537b0
[ 1694.570053] RDX: 0000000000000001 RSI: ffff88013b56be28 RDI: ffff88022c450550
[ 1694.570053] RBP: ffff88013b56bdd8 R08: ffff88022c450550 R09: 0000000000000000
[ 1694.570053] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88013b56be28
[ 1694.570053] R13: ffff88013b56bee8 R14: 0000000000000000 R15: 0000000000000193
[ 1694.570053] FS:  00007f9d4b25f700(0000) GS:ffff880066000000(0000) knlGS:000000000000
0000
[ 1694.570053] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1694.570053] CR2: ffff88022adf8010 CR3: 000000013b565000 CR4: 00000000000006e0
[ 1694.570053] Stack:
[ 1694.570053]  ffff88013b56bde8 ffffffff812d78b8 ffff88013b56be08 ffffffff812d7ea7
[ 1694.570053]  ffff88018d5202c0 0000000000000000 ffff88013b56bec8 ffffffff811d76e5
[ 1694.570053]  0000000000000001 ffffffff811759a6 ffff88013b56be58 ffffffff81194e1a
[ 1694.570053] Call Trace:
[ 1694.570053]  [<ffffffff812d78b8>] vfs_getattr_nosec+0x38/0x40
[ 1694.570053]  [<ffffffff812d7ea7>] vfs_getattr+0x37/0x50
[ 1694.570053]  [<ffffffff811d76e5>] copy_module_from_fd+0x65/0x150
[ 1694.570053]  [<ffffffff811759a6>] ? vtime_account_user+0x96/0xb0
[ 1694.570053]  [<ffffffff81194e1a>] ? __lock_release+0x1da/0x1f0
[ 1694.570053]  [<ffffffff811759a6>] ? vtime_account_user+0x96/0xb0
[ 1694.570053]  [<ffffffff81249358>] ? context_tracking_user_exit+0xb8/0x1d0
[ 1694.570053]  [<ffffffff819dfc88>] ? security_capable+0x18/0x20
[ 1694.570053]  [<ffffffff811dd443>] SyS_finit_module+0xa3/0x100
[ 1694.570053]  [<ffffffff843a6fd0>] tracesys+0xdd/0xe2
[ 1694.570053] Code: 89 c8 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 c3 90 90 
90 90 90 90 55 48 89 e5 66 66 66 66 90 48 8b 47 28 <8b> 40 10 89 46 08 48 8b 47 40 48 89 06 0f b7 07 
66 89 46 0c 8b
[ 1694.570053] RIP  [<ffffffff812d77ed>] generic_fillattr+0xd/0xa0
[ 1694.570053]  RSP <ffff88013b56bdd8>
[ 1694.570053] CR2: ffff88022adf8010


Thanks,
Sasha
