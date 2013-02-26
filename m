Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011Ab3BZCWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 21:22:34 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:36890 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab3BZCWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 21:22:33 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 00/10] ipc MSG_COPY fixes
Date: Mon, 25 Feb 2013 21:21:37 -0500
Message-Id: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Over the weekend testing with trinity on KVM, I hit a similar oops
(pasted below) to what others have already reported here
     http://lkml.indiana.edu/hypermail/linux/kernel/1302.2/01465.html

While trying to uncover the underlying cause of the list corruption,
I uncovered two other bugs which are addressed in
  ipc: Fix potential oops when src msg > 4k w/ MSG_COPY
  ipc: Don't allocate a copy larger than max

The other cleanup was incidental to trying to uncover the oops (so far
unsuccessfully).

Can the alloc_msg() be further simplified to allocate one block with
vmalloc() and link the msg segments in-place?


[   86.026309] BUG: unable to handle kernel paging request at 0000000000058134
[   86.035004] IP: [<ffffffff813087d0>] testmsg.isra.5+0x30/0x60
[   86.035004] PGD 5ff2d067 PUD 5ee34067 PMD 0
[   86.035004] Oops: 0000 [#1] PREEMPT SMP
[   86.035004] Modules linked in: can_bcm bridge stp dlci af_rxrpc .......
[   86.035004] CPU 5
[   86.035004] Pid: 1736, comm: trinity-child37 Not tainted 3.9.0-next-20130220+ldsem-xeon+lockdep #20130220+ldsem Bochs Bochs
[   86.035004] RIP: 0010:[<ffffffff813087d0>]  [<ffffffff813087d0>] testmsg.isra.5+0x30/0x60
[   86.035004] RSP: 0018:ffff88005ee2fe78  EFLAGS: 00010246
[   86.035004] RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000001
[   86.035004] RDX: 0000000000000004 RSI: 8000000000000000 RDI: 0000000000058134
[   86.035004] RBP: ffff88005ee2fe78 R08: 0000000b0ff40000 R09: 0000000000000000
[   86.035004] R10: 0000000000000001 R11: 0000000000000000 R12: 8000000000000000
[   86.035004] R13: ffff880061275c20 R14: 0000000000058124 R15: ffff880061275b70
[   86.035004] FS:  00007f9b37442700(0000) GS:ffff88007d400000(0000) knlGS:0000000000000000
[   86.035004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   86.035004] CR2: 0000000000058134 CR3: 000000005ff2c000 CR4: 00000000000007e0
[   86.035004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   86.035004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   86.035004] Process trinity-child37 (pid: 1736, threadinfo ffff88005ee2e000, task ffff88005edaa440)
[   86.035004] Stack:
[   86.035004]  ffff88005ee2ff68 ffffffff81309c06 00000000001d5b00 ffff88005edaa440
[   86.035004]  ffff88005edaa440 ffff88005edaa440 0000000000000000 ffffffff813085e0
[   86.035004]  0000000000000000 ffff88005ff7e458 0000000000000000 00000000006fe000
[   86.035004] Call Trace:
[   86.035004]  [<ffffffff81309c06>] do_msgrcv+0x1d6/0x6a0
[   86.035004]  [<ffffffff813085e0>] ? load_msg+0x180/0x180
[   86.035004]  [<ffffffff810d473d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[   86.035004]  [<ffffffff813b52fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   86.035004]  [<ffffffff8130a0e5>] sys_msgrcv+0x15/0x20
[   86.035004]  [<ffffffff817aebd9>] system_call_fastpath+0x16/0x1b
[   86.035004] Code: 55 83 fa 02 48 89 e5 74 32 7e 10 83 fa 03 74 3b 83 fa 04 74 16 31 c0 5d c3 66 90 83 fa 01 b8 01 00 00 00 74 f2 31 c0 eb ee 66 90 <48> 39 37 b8 01 00 00 00 7e e2 31 c0 eb de 66 90 48 3b 37 75 d5 
[   86.035004] RIP  [<ffffffff813087d0>] testmsg.isra.5+0x30/0x60
[   86.035004]  RSP <ffff88005ee2fe78>
[   86.035004] CR2: 0000000000058134
[   86.183799] ---[ end trace f8a403aaa782a5b4 ]---



Peter Hurley (10):
  ipc: Fix potential oops when src msg > 4k w/ MSG_COPY
  ipc: Clamp with min()
  ipc: Separate msg allocation from userspace copy
  ipc: Tighten msg copy loops
  ipc: Set EFAULT as default error in load_msg()
  ipc: Don't allocate a copy larger than max
  ipc: Remove msg handling from queue scan
  ipc: Implement MSG_COPY as a new receive mode
  ipc: Simplify msg list search
  ipc: Refactor msg list search into separate function

 ipc/msg.c     |  84 +++++++++++++++++++++-----------------------
 ipc/msgutil.c | 109 +++++++++++++++++++++++++++-------------------------------
 2 files changed, 90 insertions(+), 103 deletions(-)

-- 
1.8.1.2

