Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3JaUne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 16:43:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab3JaUnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 16:43:33 -0400
Date: Thu, 31 Oct 2013 21:43:30 +0100
From: Jan Kara <jack@suse.cz>
To: George Spelvin <linux@horizon.com>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk
Subject: Re: 3.11.4: kernel BUG at fs/buffer.c:1268
Message-ID: <20131031204330.GA18566@quack.suse.cz>
References: <20131031142525.GA1933@quack.suse.cz>
 <20131031163051.12625.qmail@science.horizon.com>
 <20131031203725.GA17693@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20131031203725.GA17693@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 31-10-13 21:37:25, Jan Kara wrote:
> On Thu 31-10-13 12:30:51, George Spelvin wrote:
> > Jan Kara <jack@suse.cz> wrote:
> > > On Thu 31-10-13 05:58:16, George Spelvin wrote:
> > >> [x.908259] Call Trace:
> > >> [x.908265]  [<ffffffff81561d7f>] dump_stack+0x54/0x74
> > >> [x.908268]  [<ffffffff81069d2f>] __might_sleep+0xcf/0xf0
> > >> [x.908271]  [<ffffffff8119079b>] ext4_journal_check_start+0x1b/0xa0
> > >> [x.908273]  [<ffffffff81190871>] __ext4_journal_start_sb+0x21/0x80
> > >> [x.908276]  [<ffffffff81177795>] ext4_dirty_inode+0x25/0x60
> > >> [x.908280]  [<ffffffff811296ed>] __mark_inode_dirty+0x2d/0x230
> > >> [x.908283]  [<ffffffff811992bc>] ext4_free_blocks+0x73c/0xa30
> > >> [x.908285]  [<ffffffff8118d936>] ext4_ext_remove_space+0x806/0xe20
> > >> [x.908287]  [<ffffffff8119fb14>] ? ext4_es_free_extent+0x54/0x60
> > >> [x.908289]  [<ffffffff8118fc18>] ext4_ext_truncate+0xb8/0xe0
> > >> [x.908291]  [<ffffffff81176065>] ext4_truncate+0x2b5/0x300
> > >> [x.908292]  [<ffffffff81176b18>] ext4_evict_inode+0x3f8/0x430
> > >> [x.908295]  [<ffffffff8111c69a>] evict+0xba/0x1c0
> > >> [x.908297]  [<ffffffff8111d04b>] iput+0x10b/0x1b0
> > >> [x.908298]  [<ffffffff81118e38>] dput+0x278/0x350
> > >> [x.908301]  [<ffffffff81104d0a>] __fput+0x16a/0x240
> > >> [x.908303]  [<ffffffff81104e19>] ____fput+0x9/0x10
> > >> [x.908306]  [<ffffffff8105e30c>] task_work_run+0x9c/0xd0
> > >> [x.908309]  [<ffffffff810451f7>] do_exit+0x2a7/0x9d0
> > >> [x.908311]  [<ffffffff8104f8ce>] ? __sigqueue_free.part.13+0x2e/0x40
> > >> [x.908312]  [<ffffffff8104679e>] do_group_exit+0x3e/0xb0
> > >> [x.908315]  [<ffffffff81052740>] get_signal_to_deliver+0x1b0/0x5f0
> > >> [x.908317]  [<ffffffff81002133>] do_signal+0x43/0x940
> > >> [x.908319]  [<ffffffff81051698>] ? do_send_sig_info+0x58/0x80
> > >> [x.908320]  [<ffffffff81002a8d>] do_notify_resume+0x5d/0x80
> > >> [x.908323]  [<ffffffff81569ca0>] int_signal+0x12/0x17
> > >
> > >   This is really fishy. So ext4_free_blocks() has might_sleep() just at its
> > > beginning so at that point irqs were enabled. ext4_dirty_inode() ends up
> > > having the might_sleep() check also at its beginning (from
> > > ext4_journal_check_start()) so the disabling must have happened somewhere
> > > in between.
> > 
> > Thanks a lot for your debugging help!
> > 
> > > The __mark_inode_dirty() call likely comes from dquot_free_block(). Can you
> > > attach your current .config and also output of /proc/mounts? Depending on
> > > that I'll see what other points checked for sleepable context. Definitely
> > > ext4_journal_get_write_access() and ext4_mb_load_buddy() check for
> > > might_sleep() as well and there's not much happening between that and the
> > > call to dquot_free_block() in ext4_free_blocks(). Strange. 
> > 
> > "grep -v '^#' .config | cat -s" appended, and here's /proc/mounts.
> > The NFS mount with hostname, path, and IP address redacted is a a
> > read-only mount of "useful stuff" that was completely idle at the time.
> > (It's not a home directory or /usr/share or anything.)
> > 
> > rootfs / rootfs rw 0 0
> > /dev/root / ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
> > tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=805136k,mode=755 0 0
> > tmpfs /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
> > proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
> > sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
> > devtmpfs /dev devtmpfs rw,relatime,size=10240k,nr_inodes=1006234,mode=755 0 0
> > tmpfs /run/shm tmpfs rw,nosuid,nodev,noexec,relatime,size=6643400k 0 0
> > devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620 0 0
> > fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
> > /dev/md2 /home ext4 rw,relatime,data=ordered 0 0
> > tmpfs /tmp tmpfs rw,relatime,size=16777216k 0 0
> > rpc_pipefs /var/lib/nfs/rpc_pipefs rpc_pipefs rw,relatime 0 0
> > server:/export/redacted /red/acted nfs ro,nosuid,nodev,noexec,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=0.1.2.3,mountvers=3,mountport=2050,mountproto=udp,local_lock=none,addr=0.1.2.3 0 0
>   Thanks for info. So ext4 mount options look pretty normal, quota is
> disabled meaning that really the last place doing might_sleep() check is
> ext4_mb_load_buddy(). The only thing that somewhat catched my eye is
> CONFIG_SLUB.
> 
> So can you add attached patch which adds couple more might_sleep() into
> ext4_free_blocks(). Also you can enable CONFIG_DEBUG_STACKOVERWLOW just to
> make sure we aren't really overflowing the stack. Also you can try using
> CONFIG_SLAB instead of CONFIG_SLUB to rule out some oddity in that
> allocator.
  Forgot to attach the patch...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--CE+1k2dSO48ffgeK
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Sprinkle-some-might_sleep-checks-into-the-code.patch"

>From 0babe605cb5b71bec811c7c8676c3f6a97b148d4 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 31 Oct 2013 21:22:57 +0100
Subject: [PATCH] Sprinkle some might_sleep() checks into the code.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a41e3ba8cfaa..8b6bdb975e10 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4757,6 +4757,7 @@ do_more:
 	if (err)
 		goto error_return;
 
+	might_sleep();
 	if ((flags & EXT4_FREE_BLOCKS_METADATA) && ext4_handle_valid(handle)) {
 		struct ext4_free_data *new_entry;
 		/*
@@ -4764,6 +4765,7 @@ do_more:
 		 * be used until this transaction is committed
 		 */
 	retry:
+		might_sleep();
 		new_entry = kmem_cache_alloc(ext4_free_data_cachep, GFP_NOFS);
 		if (!new_entry) {
 			/*
@@ -4779,6 +4781,7 @@ do_more:
 		new_entry->efd_count = count_clusters;
 		new_entry->efd_tid = handle->h_transaction->t_tid;
 
+		might_sleep();
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
 		ext4_mb_free_metadata(handle, &e4b, new_entry);
@@ -4796,7 +4799,7 @@ do_more:
 					 err);
 		}
 
-
+		might_sleep();
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
 		mb_free_blocks(inode, &e4b, bit, count_clusters);
@@ -4807,6 +4810,7 @@ do_more:
 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bitmap_bh);
 	ext4_group_desc_csum_set(sb, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
+	might_sleep();
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
-- 
1.8.1.4


--CE+1k2dSO48ffgeK--
