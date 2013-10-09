Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3JIPS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:18:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3JIPS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:18:56 -0400
Date: Wed, 9 Oct 2013 17:18:53 +0200
From: Jan Kara <jack@suse.cz>
To: George Spelvin <linux@horizon.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Message-ID: <20131009151853.GA25608@quack.suse.cz>
References: <20131009115502.16230.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009115502.16230.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 09-10-13 07:55:02, George Spelvin wrote:
> This is a newly built machine (although out of "tested" parts), so RAM
> problems are not unthinkable, but I had the chance to capture this so
> it seemed worth reporting.
> 
> i7-2xxx CPU, 8GB RAM, file system is ext4 on RAID-1.
> The local patches are to a char device driver (remote control/rf
> subsystem) that isn't even active ATM.
> 
> The BUG, BTW, is
> static inline void check_irqs_on(void)
> {
> #ifdef irqs_disabled
>         BUG_ON(irqs_disabled());
> #endif
> }
> 
> I'm not sure which config options are most important.
> One that comes to mind is CONFIG_PREEMPT_VOLUNTARY=y
  This is really weird. We are delivering a signal to a task. While task is
returning from kernel space we are running queued task works and one of
that works is dropping last file reference. Ext4 then does some data
flushing and at that point we find out irqs are disabled. It isn't really
clear to me where in that call chain got irqs disabled. I went through it
and didn't find any such place... If this is reproducible, there would be
ways to debug this (like irq tracing). Otherwise I'm not sure... I'm CCing
Al since he was digging in this code recently. Maybe he will have some
idea.

								Honza 
 
 
> [88395.501925] ------------[ cut here ]------------
> [88395.501952] kernel BUG at fs/buffer.c:1268!
> [88395.501970] invalid opcode: 0000 [#1] SMP 
> [88395.501992] Modules linked in: battery nfsd exportfs fuse ftdi_sio usbserial r8169 aesni_intel aes_x86_64 ablk_helper cryptd iTCO_wdt lrw gf128mul glue_helper mii
> [88395.502089] CPU: 0 PID: 4971 Comm: iceweasel Not tainted 3.11.4-00008-g9838365 #97
> [88395.502125] Hardware name: Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3H-B3, BIOS F13 03/20/2012
> [88395.502168] task: ffff880210b62080 ti: ffff8802014cc000 task.ti: ffff8802014cc000
> [88395.502194] RIP: 0010:[<ffffffff810e115a>]  [<ffffffff810e115a>] check_irqs_on+0xb/0xf
> [88395.502226] RSP: 0018:ffff8802014cd6e0  EFLAGS: 00210046
> [88395.502245] RAX: 0000000000200086 RBX: 0000000000001000 RCX: ffff8802146e8000
> [88395.502269] RDX: 0000000000001000 RSI: 0000000000d00206 RDI: ffff8802165789c0
> [88395.502293] RBP: ffff8802014cd6e0 R08: 00000000000001a3 R09: 0000000000000003
> [88395.502317] R10: 0000000000000003 R11: ffff88020b265ae0 R12: ffff8802165789c0
> [88395.502341] R13: 0000000000d00206 R14: ffff88020092c920 R15: ffff880216ace400
> [88395.502365] FS:  0000000000000000(0000) GS:ffff88021fa00000(0000) knlGS:0000000000000000
> [88395.502393] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [88395.502413] CR2: 0000000000000000 CR3: 0000000001614000 CR4: 00000000000407f0
> [88395.502436] Stack:
> [88395.502444]  ffff8802014cd750 ffffffff810e136d ffffea000305e900 ffff8802014cd7a8
> [88395.502473]  0000000000200292 ffff8802014cd788 ffff8802014cd720 ffffffff811af692
> [88395.502501]  ffff8802014cd750 ffffffff8108aeba 0000000000000010 0000000000001000
> [88395.502530] Call Trace:
> [88395.502541]  [<ffffffff810e136d>] __find_get_block+0x1c/0x176
> [88395.502563]  [<ffffffff811af692>] ? radix_tree_lookup_slot+0xe/0x10
> [88395.502586]  [<ffffffff8108aeba>] ? find_get_page+0x41/0x63
> [88395.502606]  [<ffffffff810e24cd>] __getblk+0x20/0x27e
> [88395.502625]  [<ffffffff8111411d>] __ext4_get_inode_loc+0xf5/0x32f
> [88395.502646]  [<ffffffff81115ba7>] ext4_get_inode_loc+0x29/0x2e
> [88395.502667]  [<ffffffff81117347>] ext4_reserve_inode_write+0x1f/0x7a
> [88395.502690]  [<ffffffff811173d8>] ext4_mark_inode_dirty+0x36/0x19b
> [88395.502713]  [<ffffffff8113f773>] ? jbd2_journal_dirty_metadata+0x1b5/0x1f0
> [88395.502737]  [<ffffffff81128f99>] __ext4_ext_dirty+0x5a/0x63
> [88395.502758]  [<ffffffff8112a67b>] ext4_ext_insert_extent+0xd8f/0xdcf
> [88395.502780]  [<ffffffff8112c9ab>] ext4_ext_map_blocks+0xc68/0xe01
> [88395.502802]  [<ffffffff81115607>] ext4_map_blocks+0x27b/0x42b
> [88395.502823]  [<ffffffff811178f5>] ext4_writepages+0x3b8/0x814
> [88395.502844]  [<ffffffff81436b02>] ? _raw_spin_lock+0x9/0xb
> [88395.502865]  [<ffffffff81092550>] do_writepages+0x19/0x27
> [88395.502884]  [<ffffffff8108baf1>] __filemap_fdatawrite_range+0x50/0x52
> [88395.502907]  [<ffffffff8108bb0a>] filemap_flush+0x17/0x19
> [88395.502926]  [<ffffffff81115a21>] ext4_alloc_da_blocks+0x21/0x23
> [88395.502947]  [<ffffffff81110c0b>] ext4_release_file+0x20/0x95
> [88395.502968]  [<ffffffff810c14cd>] __fput+0xf2/0x1cb
> [88395.502985]  [<ffffffff810c15d2>] ____fput+0x9/0xb
> [88395.503003]  [<ffffffff81041d3a>] task_work_run+0x78/0x8e
> [88395.503023]  [<ffffffff8102ea67>] do_exit+0x378/0x841
> [88395.503042]  [<ffffffff81036712>] ? __sigqueue_free+0x34/0x37
> [88395.503062]  [<ffffffff81036b15>] ? __dequeue_signal+0xa8/0xfd
> [88395.503083]  [<ffffffff8102fa32>] do_group_exit+0x3f/0x95
> [88395.503103]  [<ffffffff81038d53>] get_signal_to_deliver+0x423/0x443
> [88395.503125]  [<ffffffff81001cf0>] do_signal+0x44/0x5c3
> [88395.503144]  [<ffffffff81037d59>] ? do_send_sig_info+0x58/0x6d
> [88395.503165]  [<ffffffff81002294>] do_notify_resume+0x25/0x58
> [88395.503185]  [<ffffffff814376e0>] int_signal+0x12/0x17
> [88395.503203] Code: 80 4d 00 20 4d 8b 6d 08 48 ff c3 4c 3b 6d d0 75 b7 5a 4c 89 e0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 48 89 e5 9c 58 f6 c4 02 75 02 <0f> 0b 5d c3 55 48 81 fa ff 0f 00 00 48 89 e5 48 89 77 10 76 02 
> [88395.503336] RIP  [<ffffffff810e115a>] check_irqs_on+0xb/0xf
> [88395.503356]  RSP <ffff8802014cd6e0>
> [88395.511861] ---[ end trace 2480df9f92ab983b ]---
> [88395.511862] Fixing recursive fault but reboot is needed!
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
