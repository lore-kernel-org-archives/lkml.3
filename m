Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3JaOZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:25:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab3JaOZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:25:29 -0400
Date: Thu, 31 Oct 2013 15:25:25 +0100
From: Jan Kara <jack@suse.cz>
To: George Spelvin <linux@horizon.com>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Message-ID: <20131031142525.GA1933@quack.suse.cz>
References: <20131017213108.GC14677@quack.suse.cz>
 <20131031095816.9913.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031095816.9913.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Thu 31-10-13 05:58:16, George Spelvin wrote:
> Sorry for the long delay between updates, but it took a while to
> re-trigger the bug.  It seems to be caused by iceweasel crashing due to
> some OOM condition.
> 
> Anyway, here's the stack dump with CONFIG_DEBUG_ATOMIC_SLEEP enabled.
> (x = 1166866 seconds of uptime.)
  Thanks!

> [x.908244] BUG: sleeping function called from invalid context at fs/ext4/ext4_jbd2.c:45
> [x.908248] in_atomic(): 0, irqs_disabled(): 1, pid: 15216, name: iceweasel
> [x.908250] CPU: 6 PID: 15216 Comm: iceweasel Not tainted 3.11.5-00008-ga1818c5 #99
> [x.908252] Hardware name: Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3H-B3, BIOS F13 03/20/2012
> [x.908253]  0000000000000002 ffff88010d249908 ffffffff81561d7f ffff88021549a000
> [x.908255]  ffff88010d249918 ffffffff81069d2f ffff88010d249930 ffffffff8119079b
> [x.908257]  ffff88021549a000 ffff88010d249968 ffffffff81190871 ffff8800cc7b8c20
> [x.908259] Call Trace:
> [x.908265]  [<ffffffff81561d7f>] dump_stack+0x54/0x74
> [x.908268]  [<ffffffff81069d2f>] __might_sleep+0xcf/0xf0
> [x.908271]  [<ffffffff8119079b>] ext4_journal_check_start+0x1b/0xa0
> [x.908273]  [<ffffffff81190871>] __ext4_journal_start_sb+0x21/0x80
> [x.908276]  [<ffffffff81177795>] ext4_dirty_inode+0x25/0x60
> [x.908280]  [<ffffffff811296ed>] __mark_inode_dirty+0x2d/0x230
> [x.908283]  [<ffffffff811992bc>] ext4_free_blocks+0x73c/0xa30
> [x.908285]  [<ffffffff8118d936>] ext4_ext_remove_space+0x806/0xe20
> [x.908287]  [<ffffffff8119fb14>] ? ext4_es_free_extent+0x54/0x60
> [x.908289]  [<ffffffff8118fc18>] ext4_ext_truncate+0xb8/0xe0
> [x.908291]  [<ffffffff81176065>] ext4_truncate+0x2b5/0x300
> [x.908292]  [<ffffffff81176b18>] ext4_evict_inode+0x3f8/0x430
> [x.908295]  [<ffffffff8111c69a>] evict+0xba/0x1c0
> [x.908297]  [<ffffffff8111d04b>] iput+0x10b/0x1b0
> [x.908298]  [<ffffffff81118e38>] dput+0x278/0x350
> [x.908301]  [<ffffffff81104d0a>] __fput+0x16a/0x240
> [x.908303]  [<ffffffff81104e19>] ____fput+0x9/0x10
> [x.908306]  [<ffffffff8105e30c>] task_work_run+0x9c/0xd0
> [x.908309]  [<ffffffff810451f7>] do_exit+0x2a7/0x9d0
> [x.908311]  [<ffffffff8104f8ce>] ? __sigqueue_free.part.13+0x2e/0x40
> [x.908312]  [<ffffffff8104679e>] do_group_exit+0x3e/0xb0
> [x.908315]  [<ffffffff81052740>] get_signal_to_deliver+0x1b0/0x5f0
> [x.908317]  [<ffffffff81002133>] do_signal+0x43/0x940
> [x.908319]  [<ffffffff81051698>] ? do_send_sig_info+0x58/0x80
> [x.908320]  [<ffffffff81002a8d>] do_notify_resume+0x5d/0x80
> [x.908323]  [<ffffffff81569ca0>] int_signal+0x12/0x17
  This is really fishy. So ext4_free_blocks() has might_sleep() just at its
beginning so at that point irqs were enabled. ext4_dirty_inode() ends up
having the might_sleep() check also at its beginning (from
ext4_journal_check_start()) so the disabling must have happened somewhere
inbetween.

The __mark_inode_dirty() call likely comes from dquot_free_block(). Can you
attach your current .config and also output of /proc/mounts? Depending on
that I'll see what other points checked for sleepable context. Definitely
ext4_journal_get_write_access() and ext4_mb_load_buddy() check for
might_sleep() as well and there's not much happening between that and the
call to dquot_free_block() in ext4_free_blocks(). Strange. 

								Honza

> [x.908329] ------------[ cut here ]------------
> [x.908352] kernel BUG at fs/buffer.c:1268!
> [x.908370] invalid opcode: 0000 [#1] SMP 
> [x.908391] Modules linked in: pl2303 fuse ftdi_sio usbserial iTCO_wdt
> [x.908425] CPU: 6 PID: 15216 Comm: iceweasel Not tainted 3.11.5-00008-ga1818c5 #99
> [x.908460] Hardware name: Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3H-B3, BIOS F13 03/20/2012
> [x.908484] task: ffff8801124ae800 ti: ffff88010d248000 task.ti: ffff88010d248000
> [x.908504] RIP: 0010:[<ffffffff815612a6>]  [<ffffffff815612a6>] check_irqs_on.part.19+0x4/0x6
> [x.908529] RSP: 0018:ffff88010d249798  EFLAGS: 00210046
> [x.908543] RAX: 0000000000200082 RBX: ffff88010d249928 RCX: ffff880215a5c000
> [x.908562] RDX: 0000000000001000 RSI: 000000000038005b RDI: ffff8802164296c0
> [x.908580] RBP: ffff88010d249798 R08: 0000000000000000 R09: 0000000000000000
> [x.908599] R10: ffff880215a5c000 R11: ffff88010d24947e R12: ffff8802164296c0
> [x.908617] R13: 0000000000001000 R14: ffff88021fbdbe00 R15: ffff88021549a000
> [x.908635] FS:  0000000000000000(0000) GS:ffff88021fb80000(0000) knlGS:0000000000000000
> [x.908656] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [x.908672] CR2: 0000000000000000 CR3: 000000000180c000 CR4: 00000000000407e0
> [x.908690] Stack:
> [x.908696]  ffff88010d249808 ffffffff8112feb7 000000000000b760 ffff88010d2498f0
> [x.908720]  ffff88021fb83fc0 ffff88010d2498e8 ffff88010d249840 ffffffff81004b7f
> [x.908743]  ffff88010d24980c 000000000d2498f0 ffff88010d249928 ffff8802164296c0
> [x.908766] Call Trace:
> [x.908776]  [<ffffffff8112feb7>] __find_get_block+0x1d7/0x1e0
> [x.908793]  [<ffffffff81004b7f>] ? dump_trace+0x17f/0x2d0
> [x.908808]  [<ffffffff8112fee0>] __getblk+0x20/0x2f0
> [x.908823]  [<ffffffff81171516>] __ext4_get_inode_loc+0x106/0x410
> [x.908840]  [<ffffffff81004d7f>] ? show_stack_log_lvl+0xaf/0x1a0
> [x.908857]  [<ffffffff811734b8>] ext4_get_inode_loc+0x18/0x20
> [x.908874]  [<ffffffff81174c61>] ext4_reserve_inode_write+0x21/0x90
> [x.908891]  [<ffffffff81561d7f>] ? dump_stack+0x54/0x74
> [x.908906]  [<ffffffff81174d19>] ext4_mark_inode_dirty+0x49/0x1a0
> [x.908924]  [<ffffffff811777ab>] ext4_dirty_inode+0x3b/0x60
> [x.908940]  [<ffffffff811296ed>] __mark_inode_dirty+0x2d/0x230
> [x.908957]  [<ffffffff811992bc>] ext4_free_blocks+0x73c/0xa30
> [x.908974]  [<ffffffff8118d936>] ext4_ext_remove_space+0x806/0xe20
> [x.908991]  [<ffffffff8119fb14>] ? ext4_es_free_extent+0x54/0x60
> [x.909008]  [<ffffffff8118fc18>] ext4_ext_truncate+0xb8/0xe0
> [x.909025]  [<ffffffff81176065>] ext4_truncate+0x2b5/0x300
> [x.909041]  [<ffffffff81176b18>] ext4_evict_inode+0x3f8/0x430
> [x.909057]  [<ffffffff8111c69a>] evict+0xba/0x1c0
> [x.909071]  [<ffffffff8111d04b>] iput+0x10b/0x1b0
> [x.909084]  [<ffffffff81118e38>] dput+0x278/0x350
> [x.909099]  [<ffffffff81104d0a>] __fput+0x16a/0x240
> [x.909113]  [<ffffffff81104e19>] ____fput+0x9/0x10
> [x.909127]  [<ffffffff8105e30c>] task_work_run+0x9c/0xd0
> [x.909143]  [<ffffffff810451f7>] do_exit+0x2a7/0x9d0
> [x.909157]  [<ffffffff8104f8ce>] ? __sigqueue_free.part.13+0x2e/0x40
> [x.909175]  [<ffffffff8104679e>] do_group_exit+0x3e/0xb0
> [x.909190]  [<ffffffff81052740>] get_signal_to_deliver+0x1b0/0x5f0
> [x.909207]  [<ffffffff81002133>] do_signal+0x43/0x940
> [x.909222]  [<ffffffff81051698>] ? do_send_sig_info+0x58/0x80
> [x.909238]  [<ffffffff81002a8d>] do_notify_resume+0x5d/0x80
> [x.909254]  [<ffffffff81569ca0>] int_signal+0x12/0x17
> [x.909267] Code: 4d 85 e4 74 1d 41 80 44 24 58 01 65 48 8b 04 25 b0 b7 00 00 ff 88 44 e0 ff ff 4c 89 e7 e8 23 79 bb ff 5b 41 5c 5d c3 55 48 89 e5 <0f> 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 
> [x.909390] RIP  [<ffffffff815612a6>] check_irqs_on.part.19+0x4/0x6
> [x.909408]  RSP <ffff88010d249798>
> [x.915643] ---[ end trace 379d96cb0444fcb3 ]---
> [x.915645] Fixing recursive fault but reboot is needed!
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
