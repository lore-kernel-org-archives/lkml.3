Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124Ab3K1Pe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:34:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab3K1PeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:34:24 -0500
Date: Thu, 28 Nov 2013 16:34:20 +0100
From: Jan Kara <jack@suse.cz>
To: George Spelvin <linux@horizon.com>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Message-ID: <20131128153420.GA21176@quack.suse.cz>
References: <20131101005056.21134.qmail@science.horizon.com>
 <20131128050906.20215.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <20131128050906.20215.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 28-11-13 00:09:06, George Spelvin wrote:
> Well, it finally triggered.
> 
> 
> Not *that* long before, I fiddled with a USB thumb drive, which
> I'll mention here, but I don't think it's connected.
> 
> [2328294.996152] usb 1-1.3: new high-speed USB device number 6 using ehci-pci
> [2328295.080347] usb 1-1.3: New USB device found, idVendor=0781, idProduct=556c
> [2328295.080351] usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [2328295.080352] usb 1-1.3: Product: Ultra
> [2328295.080353] usb 1-1.3: Manufacturer: SanDisk
> [2328295.080354] usb 1-1.3: SerialNumber: 20054861120C8D407604
> [2328295.829526] usb-storage 1-1.3:1.0: USB Mass Storage device detected
> [2328295.829571] scsi6 : usb-storage 1-1.3:1.0
> [2328295.829615] usbcore: registered new interface driver usb-storage
> [2328296.832215] scsi 6:0:0:0: Direct-Access     SanDisk  Ultra            1.20 PQ: 0 ANSI: 5
> [2328296.832343] sd 6:0:0:0: Attached scsi generic sg3 type 0
> [2328296.833579] sd 6:0:0:0: [sdc] 15633408 512-byte logical blocks: (8.00 GB/7.45 GiB)
> [2328296.834942] sd 6:0:0:0: [sdc] Write Protect is off
> [2328296.834944] sd 6:0:0:0: [sdc] Mode Sense: 43 00 00 00
> [2328296.835947] sd 6:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
> [2328296.848345]  sdc: sdc1
> [2328296.851338] sd 6:0:0:0: [sdc] Attached SCSI removable disk
> [2328361.332585] FAT-fs (sdc1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
> [2335705.838834] usb 1-1.3: USB disconnect, device number 6
> 
> 
> The next thing in the kernel log is the might_sleep() warning (followed by
> the oops):
> 
> [2348070.539862] BUG: sleeping function called from invalid context at fs/ext4/mballoc.c:4791
> [2348070.539865] in_atomic(): 0, irqs_disabled(): 1, pid: 4635, name: iceweasel
> [2348070.539867] CPU: 4 PID: 4635 Comm: iceweasel Tainted: G        W    3.11.5-00009-g06a2442 #100
> [2348070.539868] Hardware name: Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3H-B3, BIOS F13 03/20/2012
> [2348070.539870]  ffff88011379f4e0 ffff8801a30179a8 ffffffff81561017 0000000000000002
> [2348070.539872]  ffff8801a30179b8 ffffffff8106a06f ffff8801a3017a90 ffffffff81197a3e
> [2348070.539874]  ffff880011306f68 ffff8801a3017fd8 00000001a30179f8 0000000000f15fd1
> [2348070.539876] Call Trace:
> [2348070.539881]  [<ffffffff81561017>] dump_stack+0x54/0x74
> [2348070.539884]  [<ffffffff8106a06f>] __might_sleep+0xcf/0xf0
> [2348070.539887]  [<ffffffff81197a3e>] ext4_free_blocks+0x53e/0xa90
  Thanks for the report. So this is the last might_sleep() we have added.
Interesting. I've also realized it isn't a stack overflow problem because
irqs_disabled() check in might_sleep() checks real setting of a flag in the
processor flags.

I went again through the several calls between last two might_sleep() calls
but I didn't find anything suspicious. So let's narrow this down a bit more
by the attached patch (to be applied on top of your previous patch).
Thanks!

								Honza

> [2348070.539889]  [<ffffffff8118c286>] ext4_ext_remove_space+0x806/0xe20
> [2348070.539891]  [<ffffffff8118e568>] ext4_ext_truncate+0xb8/0xe0
> [2348070.539894]  [<ffffffff811749a5>] ext4_truncate+0x2b5/0x300
> [2348070.539895]  [<ffffffff81175458>] ext4_evict_inode+0x3f8/0x430
> [2348070.539898]  [<ffffffff8111acca>] evict+0xba/0x1c0
> [2348070.539899]  [<ffffffff8111b67b>] iput+0x10b/0x1b0
> [2348070.539901]  [<ffffffff81117468>] dput+0x278/0x350
> [2348070.539904]  [<ffffffff811032da>] __fput+0x16a/0x240
> [2348070.539905]  [<ffffffff811033e9>] ____fput+0x9/0x10
> [2348070.539909]  [<ffffffff8105e63c>] task_work_run+0x9c/0xd0
> [2348070.539911]  [<ffffffff81045547>] do_exit+0x2a7/0x9d0
> [2348070.539914]  [<ffffffff8104fc1e>] ? __sigqueue_free.part.13+0x2e/0x40
> [2348070.539915]  [<ffffffff81046aee>] do_group_exit+0x3e/0xb0
> [2348070.539917]  [<ffffffff81052a90>] get_signal_to_deliver+0x1b0/0x5f0
> [2348070.539919]  [<ffffffff81002133>] do_signal+0x43/0x940
> [2348070.539921]  [<ffffffff810519e8>] ? do_send_sig_info+0x58/0x80
> [2348070.539923]  [<ffffffff81002a8d>] do_notify_resume+0x5d/0x80
> [2348070.539925]  [<ffffffff81568f60>] int_signal+0x12/0x17
> [2348070.539931] ------------[ cut here ]------------
> [2348070.539950] kernel BUG at fs/buffer.c:1268!
> [2348070.539962] invalid opcode: 0000 [#1] SMP 
> [2348070.539976] Modules linked in: nls_utf8 nls_cp437 vfat fat usb_storage fuse pl2303 ftdi_sio usbserial iTCO_wdt
> [2348070.540018] CPU: 4 PID: 4635 Comm: iceweasel Tainted: G        W    3.11.5-00009-g06a2442 #100
> [2348070.540040] Hardware name: Gigabyte Technology Co., Ltd. Z68A-D3H-B3/Z68A-D3H-B3, BIOS F13 03/20/2012
> [2348070.540063] task: ffff88021688cf00 ti: ffff8801a3016000 task.ti: ffff8801a3016000
> [2348070.540082] RIP: 0010:[<ffffffff8156053e>]  [<ffffffff8156053e>] check_irqs_on.part.16+0x4/0x6
> [2348070.540108] RSP: 0018:ffff8801a3017798  EFLAGS: 00010046
> [2348070.540122] RAX: 0000000000000082 RBX: ffff8801a3017928 RCX: ffff8802162bd000
> [2348070.540141] RDX: 0000000000001000 RSI: 0000000000980080 RDI: ffff8802171b6b00
> [2348070.540159] RBP: ffff8801a3017798 R08: 0000000000000002 R09: 0000000000000002
> [2348070.540177] R10: ffff8802162bd000 R11: ffff8801a301751e R12: ffff8802171b6b00
> [2348070.540195] R13: 0000000000001000 R14: ffff880213a70600 R15: ffff880215228c00
> [2348070.540214] FS:  0000000000000000(0000) GS:ffff88021fb00000(0000) knlGS:0000000000000000
> [2348070.540235] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [2348070.540250] CR2: 00000000f4832a3c CR3: 000000000180c000 CR4: 00000000000407e0
> [2348070.540268] Stack:
> [2348070.540274]  ffff8801a3017808 ffffffff8112e547 ffff8801a30177b0 0000000000000092
> [2348070.540297]  ffffffff81568f60 ffffffff81732ff4 ffffffff81568f60 ffffffff810987bd
> [2348070.540320]  00000000ffe743c4 ffff8801a30177f0 ffff8801a3017928 ffff8802171b6b00
> [2348070.540342] Call Trace:
> [2348070.540352]  [<ffffffff8112e547>] __find_get_block+0x1d7/0x1e0
> [2348070.540369]  [<ffffffff81568f60>] ? int_signal+0x12/0x17
> [2348070.540384]  [<ffffffff81568f60>] ? int_signal+0x12/0x17
> [2348070.540400]  [<ffffffff810987bd>] ? __module_text_address+0xd/0x60
> [2348070.540417]  [<ffffffff8112e570>] __getblk+0x20/0x2f0
> [2348070.540432]  [<ffffffff8116fe46>] __ext4_get_inode_loc+0x106/0x410
> [2348070.540448]  [<ffffffff81171df8>] ext4_get_inode_loc+0x18/0x20
> [2348070.540465]  [<ffffffff811735a1>] ext4_reserve_inode_write+0x21/0x90
> [2348070.540482]  [<ffffffff81173659>] ext4_mark_inode_dirty+0x49/0x1a0
> [2348070.540499]  [<ffffffff811760eb>] ext4_dirty_inode+0x3b/0x60
> [2348070.540515]  [<ffffffff81127d3d>] __mark_inode_dirty+0x2d/0x230
> [2348070.540532]  [<ffffffff81197cbc>] ext4_free_blocks+0x7bc/0xa90
> [2348070.540548]  [<ffffffff8118c286>] ext4_ext_remove_space+0x806/0xe20
> [2348070.540565]  [<ffffffff8118e568>] ext4_ext_truncate+0xb8/0xe0
> [2348070.540581]  [<ffffffff811749a5>] ext4_truncate+0x2b5/0x300
> [2348070.540597]  [<ffffffff81175458>] ext4_evict_inode+0x3f8/0x430
> [2348070.540613]  [<ffffffff8111acca>] evict+0xba/0x1c0
> [2348070.540627]  [<ffffffff8111b67b>] iput+0x10b/0x1b0
> [2348070.540641]  [<ffffffff81117468>] dput+0x278/0x350
> [2348070.540655]  [<ffffffff811032da>] __fput+0x16a/0x240
> [2348070.540669]  [<ffffffff811033e9>] ____fput+0x9/0x10
> [2348070.540683]  [<ffffffff8105e63c>] task_work_run+0x9c/0xd0
> [2348070.540698]  [<ffffffff81045547>] do_exit+0x2a7/0x9d0
> [2348070.540713]  [<ffffffff8104fc1e>] ? __sigqueue_free.part.13+0x2e/0x40
> [2348070.540730]  [<ffffffff81046aee>] do_group_exit+0x3e/0xb0
> [2348070.540745]  [<ffffffff81052a90>] get_signal_to_deliver+0x1b0/0x5f0
> [2348070.540762]  [<ffffffff81002133>] do_signal+0x43/0x940
> [2348070.540777]  [<ffffffff810519e8>] ? do_send_sig_info+0x58/0x80
> [2348070.540793]  [<ffffffff81002a8d>] do_notify_resume+0x5d/0x80
> [2348070.540809]  [<ffffffff81568f60>] int_signal+0x12/0x17
> [2348070.540823] Code: 4d 85 e4 74 1d 41 80 44 24 58 01 65 48 8b 04 25 b0 b7 00 00 ff 88 44 e0 ff ff 4c 89 e7 e8 bb 6c bb ff 5b 41 5c 5d c3 55 48 89 e5 <0f> 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 
> [2348070.540943] RIP  [<ffffffff8156053e>] check_irqs_on.part.16+0x4/0x6
> [2348070.540961]  RSP <ffff8801a3017798>
> [2348070.547170] ---[ end trace 41094c9a65f45b94 ]---
> [2348070.547171] Fixing recursive fault but reboot is needed!
> 
> 
> Here's the debug patch from last month's e-mail, for reference.
> The one that tripped is the last hunk.
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 4bbbf13b..e6f0d6b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4734,6 +4734,7 @@ do_more:
>  	if (err)
>  		goto error_return;
>  
> +	might_sleep();
>  	if ((flags & EXT4_FREE_BLOCKS_METADATA) && ext4_handle_valid(handle)) {
>  		struct ext4_free_data *new_entry;
>  		/*
> @@ -4741,6 +4742,7 @@ do_more:
>  		 * be used until this transaction is committed
>  		 */
>  	retry:
> +		might_sleep();
>  		new_entry = kmem_cache_alloc(ext4_free_data_cachep, GFP_NOFS);
>  		if (!new_entry) {
>  			/*
> @@ -4756,6 +4758,7 @@ do_more:
>  		new_entry->efd_count = count_clusters;
>  		new_entry->efd_tid = handle->h_transaction->t_tid;
>  
> +		might_sleep();
>  		ext4_lock_group(sb, block_group);
>  		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
>  		ext4_mb_free_metadata(handle, &e4b, new_entry);
> @@ -4773,7 +4776,7 @@ do_more:
>  					 err);
>  		}
>  
> -
> +		might_sleep();
>  		ext4_lock_group(sb, block_group);
>  		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
>  		mb_free_blocks(inode, &e4b, bit, count_clusters);
> @@ -4785,6 +4788,7 @@ do_more:
>  	ext4_group_desc_csum_set(sb, block_group, gdp);
>  	ext4_unlock_group(sb, block_group);
>  	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
> +	might_sleep();
>  
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--fUYQa+Pmc3FrFX/N
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Debug-irqs.patch"

>From 0868c52e3a67c43b2e0f2eb3275e6d994b5f3bdd Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 28 Nov 2013 15:36:53 +0100
Subject: [PATCH] Debug irqs

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 267c14e3a19e..d22f9690aaf6 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4760,8 +4760,11 @@ do_more:
 
 		might_sleep();
 		ext4_lock_group(sb, block_group);
+		WARN_ON(irqs_disabled());
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
+		WARN_ON(irqs_disabled());
 		ext4_mb_free_metadata(handle, &e4b, new_entry);
+		WARN_ON(irqs_disabled());
 	} else {
 		/* need to update group_info->bb_free and bitmap
 		 * with group lock held. generate_buddy look at
@@ -4779,15 +4782,23 @@ do_more:
 
 		might_sleep();
 		ext4_lock_group(sb, block_group);
+		WARN_ON(irqs_disabled());
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
+		WARN_ON(irqs_disabled());
 		mb_free_blocks(inode, &e4b, bit, count_clusters);
+		WARN_ON(irqs_disabled());
 	}
 
 	ret = ext4_free_group_clusters(sb, gdp) + count_clusters;
+	WARN_ON(irqs_disabled());
 	ext4_free_group_clusters_set(sb, gdp, ret);
+	WARN_ON(irqs_disabled());
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh);
+	WARN_ON(irqs_disabled());
 	ext4_group_desc_csum_set(sb, block_group, gdp);
+	WARN_ON(irqs_disabled());
 	ext4_unlock_group(sb, block_group);
+	WARN_ON(irqs_disabled());
 	percpu_counter_add(&sbi->s_freeclusters_counter, count_clusters);
 	might_sleep();
 
-- 
1.8.1.4


--fUYQa+Pmc3FrFX/N--
