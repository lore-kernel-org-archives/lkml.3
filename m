Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab3JQVLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:11:50 -0400
Received: from science.horizon.com ([71.41.210.146]:52481 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932286Ab3JQVLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:11:46 -0400
Date: 17 Oct 2013 17:11:43 -0400
Message-ID: <20131017211143.1712.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: jack@suse.cz, viro@ZenIV.linux.org.uk
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@horizon.com
In-Reply-To: <20131009172336.GH13318@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Note that do_group_exit() is preceded by
>                spin_unlock_irq(&sighand->siglock);
> so no matter what happened in callers, irq is enabled.  I'd suggest sticking
> such BUG_ON() into __fput() and trying to reproduce that crap...

Well, it happened again (error appended).  Can you please clarify what you mean
by "such BUG_ON()"; I'm having a hard time following the RCU code and determining
all the situations under which __fput() might be called.

Given that __fput() includes might_sleep(), how about I enable CONFIG_DEBUG_ATOMIC_SLEEP?

[280344.098552] ------------[ cut here ]------------
[280344.098575] kernel BUG at fs/buffer.c:1268!
[280344.098590] invalid opcode: 0000 [#1] SMP 
[280344.098608] Modules linked in: fuse ftdi_sio usbserial iTCO_wdt
[280344.098635] CPU: 1 PID: 4298 Comm: iceweasel Not tainted 3.11.5-00008-ga1818c5 #98
[280344.098661] Hardware name: Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3H-B3, BIOS F13 03/20/2012
[280344.098692] task: ffff88020abb2080 ti: ffff880204852000 task.ti: ffff880204852000
[280344.098717] RIP: 0010:[<ffffffff810eac61>]  [<ffffffff810eac61>] check_irqs_on+0xb/0xf
[280344.098748] RSP: 0018:ffff880204853788  EFLAGS: 00210046
[280344.098767] RAX: 0000000000200082 RBX: 0000000000001000 RCX: ffff8802145ca800
[280344.098792] RDX: 0000000000001000 RSI: 0000000000b800f2 RDI: ffff8802165a0d00
[280344.098816] RBP: ffff880204853788 R08: 0000000000000171 R09: 0000000000000002
[280344.098840] R10: 0000000000000002 R11: ffff88011e738ff0 R12: ffff8802165a0d00
[280344.098864] R13: 0000000000b800f2 R14: ffff88008da3ef40 R15: ffff880216acbc00
[280344.098889] FS:  0000000000000000(0000) GS:ffff88021fa40000(0000) knlGS:0000000000000000
[280344.098916] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[280344.098936] CR2: 00000000f7609bb0 CR3: 00000002117b6000 CR4: 00000000000407e0
[280344.098959] Stack:
[280344.098967]  ffff8802048537f8 ffffffff810eae74 0000000000000000 0000000000000000
[280344.098996]  0000000000000000 0000000000000000 0000000000000001 0000000000000001
[280344.099025]  0000000000000000 0000000000000000 0000000000000010 0000000000001000
[280344.099054] Call Trace:
[280344.099065]  [<ffffffff810eae74>] __find_get_block+0x1c/0x176
[280344.099086]  [<ffffffff810ebfd4>] __getblk+0x20/0x27e
[280344.099106]  [<ffffffff8109d193>] ? put_page+0x21/0x30
[280344.099124]  [<ffffffff810eaac7>] ? __find_get_block_slow+0x123/0x13a
[280344.099147]  [<ffffffff8111dc57>] __ext4_get_inode_loc+0xf5/0x32f
[280344.099169]  [<ffffffff8111f6e1>] ext4_get_inode_loc+0x29/0x2e
[280344.099190]  [<ffffffff81120e81>] ext4_reserve_inode_write+0x1f/0x7a
[280344.099212]  [<ffffffff81120f12>] ext4_mark_inode_dirty+0x36/0x19b
[280344.099234]  [<ffffffff81122dda>] ext4_dirty_inode+0x3b/0x54
[280344.099254]  [<ffffffff810e5e88>] __mark_inode_dirty+0x2d/0x196
[280344.099275]  [<ffffffff8113d430>] ext4_free_blocks+0x636/0x6dd
[280344.099296]  [<ffffffff8113528b>] ext4_ext_remove_space+0x568/0xa53
[280344.099319]  [<ffffffff81142002>] ? ext4_es_free_extent+0x52/0x55
[280344.099340]  [<ffffffff81142699>] ? __es_remove_extent+0x1fb/0x2a1
[280344.099362]  [<ffffffff81136702>] ext4_ext_truncate+0x84/0xa8
[280344.099382]  [<ffffffff81121d2b>] ext4_truncate+0x187/0x21c
[280344.099402]  [<ffffffff811223d0>] ext4_evict_inode+0x1ab/0x2a0
[280344.099423]  [<ffffffff810dc927>] evict+0xa2/0x151
[280344.099440]  [<ffffffff810dcf0a>] iput+0x121/0x12a
[280344.099458]  [<ffffffff810d96f6>] dentry_kill+0x109/0x123
[280344.099478]  [<ffffffff810d97e3>] dput+0xd3/0xe2
[280344.099495]  [<ffffffff810cb097>] __fput+0x1b5/0x1cb
[280344.099513]  [<ffffffff810cb0d9>] ____fput+0x9/0xb
[280344.099531]  [<ffffffff8104b841>] task_work_run+0x78/0x8e
[280344.099551]  [<ffffffff81038557>] do_exit+0x378/0x841
[280344.099569]  [<ffffffff81040202>] ? __sigqueue_free+0x34/0x37
[280344.099590]  [<ffffffff81040605>] ? __dequeue_signal+0xa8/0xfd
[280344.099610]  [<ffffffff81039522>] do_group_exit+0x3f/0x95
[280344.099630]  [<ffffffff81042843>] get_signal_to_deliver+0x423/0x443
[280344.099652]  [<ffffffff81001cf0>] do_signal+0x44/0x5c3
[280344.099671]  [<ffffffff81041849>] ? do_send_sig_info+0x58/0x6d
[280344.099691]  [<ffffffff81002294>] do_notify_resume+0x25/0x58
[280344.099712]  [<ffffffff814478a0>] int_signal+0x12/0x17
[280344.099729] Code: 80 4d 00 20 4d 8b 6d 08 48 ff c3 4c 3b 6d d0 75 b7 5a 4c 89 e0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 48 89 e5 9c 58 f6 c4 02 75 02 <0f> 0b 5d c3 55 48 81 fa ff 0f 00 00 48 89 e5 48 89 77 10 76 02 
[280344.099862] RIP  [<ffffffff810eac61>] check_irqs_on+0xb/0xf
[280344.099883]  RSP <ffff880204853788>
[280344.108415] ---[ end trace 68f14daef5901df3 ]---
[280344.108416] Fixing recursive fault but reboot is needed!
