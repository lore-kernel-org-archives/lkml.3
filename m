Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab3LSAZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:25:20 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43706 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab3LSAZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:25:18 -0500
Message-ID: <52B23CEA.7090405@oracle.com>
Date: Wed, 18 Dec 2013 19:25:14 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: fs: gpf in simple_setattr
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running latest -next kernel, I've stumbled on 
the following spew.

This happens when sb is dereferenced in __mark_inode_dirty():

                 if (sb->s_op->dirty_inode) <--- HERE
                         sb->s_op->dirty_inode(inode, flags);

'sb' is pointing to a memory full of poisoned memory (6b6b6b6b6b6b6b6b).

[  590.469520] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  590.470737] Dumping ftrace buffer:
[  590.471331]    (ftrace buffer empty)
[  590.471903] Modules linked in:
[  590.472349] CPU: 3 PID: 9685 Comm: trinity-child97 Tainted: G        W 
3.13.0-rc4-next-20131218-sasha-00013-g2cebb9b-dirty #4156
[  590.472396] task: ffff8800bc520000 ti: ffff8800bc4fa000 task.ti: ffff8800bc4fa000
[  590.472396] RIP: 0010:[<ffffffff81302d34>]  [<ffffffff81302d34>] __mark_inode_dirty+0xd4/0x360
[  590.475691] RSP: 0018:ffff8800bc4fbda8  EFLAGS: 00010246
[  590.475691] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8802f9002530 RCX: 000000006b6b6b6b
[  590.475691] RDX: 0000000000000000 RSI: 0000000000000007 RDI: ffff8802f9002530
[  590.475691] RBP: ffff8800bc4fbdc8 R08: 0000000000000000 R09: 0000000000000000
[  590.475691] R10: 0000000000000001 R11: 0000000000000002 R12: 0000000000000007
[  590.475691] R13: 0000000000000000 R14: ffff8802f8795668 R15: ffff8802f9002530
[  590.475691] FS:  00007f9bba1b7700(0000) GS:ffff8801c8000000(0000) knlGS:0000000000000000
[  590.475691] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  590.475691] CR2: 00007f9bba17da44 CR3: 00000000bc4e6000 CR4: 00000000000006e0
[  590.475691] Stack:
[  590.475691]  ffff8802f9002530 ffff8800bc4fbe98 0000000000000000 ffff880161244000
[  590.475691]  ffff8800bc4fbdf8 ffffffff8130001b ffff8800bc4fbde8 0000000000001846
[  590.475691]  ffff8800bc4fbe98 0000000000000000 ffff8800bc4fbe78 ffffffff812f3016
[  590.475691] Call Trace:
[  590.475691]  [<ffffffff8130001b>] simple_setattr+0x5b/0x70
[  590.475691]  [<ffffffff812f3016>] notify_change+0x216/0x300
[  590.475691]  [<ffffffff812d0180>] ? zs_malloc+0x1b0/0x200
[  590.475691]  [<ffffffff812d0b15>] chown_common+0x135/0x1c0
[  590.475691]  [<ffffffff812d0c20>] SyS_fchown+0x80/0xd0
[  590.475691]  [<ffffffff843a6d50>] tracesys+0xdd/0xe2
[  590.494436] VFS: Warning: trinity-child15 using old stat() call. Recompile your binary.
[  590.475691] Code: c5 10 48 89 de ff d0 49 8b 45 00 48 85 c0 75 e7 65 ff 0c 25 5c da 00 00 0f 94 
c0 84 c0 74 08 e8 b3 33 d7 ff 0f 1f 00 49 8b 46 30 <48> 8b 40 10 48 85 c0 74 08 44 89 e6 48 89 df ff 
d0 8b 05 bd 6b
[  590.475691] RIP  [<ffffffff81302d34>] __mark_inode_dirty+0xd4/0x360
[  590.475691]  RSP <ffff8800bc4fbda8>


Thanks,
Sasha
