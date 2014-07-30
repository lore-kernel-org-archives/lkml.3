Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaG3Jwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:52:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbaG3Jwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:52:33 -0400
Date: Wed, 30 Jul 2014 11:52:29 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 07/22] Replace the XIP page fault handler with the DAX
 page fault handler
Message-ID: <20140730095229.GA19205@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <c2e602f401a580c4fac54b9b8f4a6f8dd0ac1071.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409102758.GM32103@quack.suse.cz>
 <20140409205111.GG5727@linux.intel.com>
 <20140409214331.GQ32103@quack.suse.cz>
 <20140729121259.GL6754@linux.intel.com>
 <20140729210457.GA17807@quack.suse.cz>
 <20140729212333.GO6754@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <20140729212333.GO6754@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 29-07-14 17:23:33, Matthew Wilcox wrote:
> On Tue, Jul 29, 2014 at 11:04:57PM +0200, Jan Kara wrote:
> > > Path 1:
> > > 
> > > ext4_fallocate ->
> > >  ext4_punch_hole ->
> > >   ext4_inode_attach_jinode() -> ... ->
> > >     lock_map_acquire(&handle->h_lockdep_map);
> > >   truncate_pagecache_range() ->
> > >    unmap_mapping_range() ->
> > >     mutex_lock(&mapping->i_mmap_mutex);
> >   This is strange. I don't see how ext4_inode_attach_jinode() can ever lead
> > to lock_map_acquire(&handle->h_lockdep_map). Can you post a full trace for
> > this?
> 
> Unfortunately, lockdep finds the inversion in the other order, so I
> have the backtraces of this path hitting the i_mmap_mutex while already
> holding jbd_mutex:
  I see the problem now. How about an attached patch? Do you see other
lockdep warnings with it?

								Honza
> 
>  ======================================================
>  [ INFO: possible circular locking dependency detected ]
>  3.16.0-rc6+ #91 Tainted: G        W    
>  -------------------------------------------------------
>  fstest/31836 is trying to acquire lock:
>   (jbd2_handle){+.+.+.}, at: [<ffffffffa00f5333>] start_this_handle+0x193/0x630 [jbd2]
>  
>  but task is already holding lock:
>   (&mapping->i_mmap_mutex){+.+...}, at: [<ffffffff8124c0a0>] do_dax_fault+0x4e0/0x640
>  
>  which lock already depends on the new lock.
>  
>  
>  the existing dependency chain (in reverse order) is:
>  
>  -> #1 (&mapping->i_mmap_mutex){+.+...}:
>         [<ffffffff810cfa22>] lock_acquire+0xb2/0x1f0
>         [<ffffffff815cad15>] mutex_lock_nested+0x75/0x420
>         [<ffffffff811acf4b>] unmap_mapping_range+0x6b/0x180
>         [<ffffffff811901ba>] truncate_pagecache_range+0x4a/0x60
>         [<ffffffffa020af41>] ext4_punch_hole+0x4d1/0x530 [ext4]
>         [<ffffffffa0235356>] ext4_fallocate+0x156/0xb70 [ext4]
>         [<ffffffff811f3c19>] do_fallocate+0x119/0x1b0
>         [<ffffffff811f3cf3>] SyS_fallocate+0x43/0x70
>         [<ffffffff815cf8a9>] system_call_fastpath+0x16/0x1b
>  
>  -> #0 (jbd2_handle){+.+.+.}:
>         [<ffffffff810ce9e1>] __lock_acquire+0x1d01/0x1eb0
>         [<ffffffff810cfa22>] lock_acquire+0xb2/0x1f0
>         [<ffffffffa00f538e>] start_this_handle+0x1ee/0x630 [jbd2]
>         [<ffffffffa00f5c04>] jbd2__journal_start+0xd4/0x260 [jbd2]
>         [<ffffffffa0235f6d>] __ext4_journal_start_sb+0x6d/0x190 [ext4]
>         [<ffffffffa0206fca>] _ext4_get_block+0x16a/0x1c0 [ext4]
>         [<ffffffffa0207036>] ext4_get_block+0x16/0x20 [ext4]
>         [<ffffffff8124c199>] do_dax_fault+0x5d9/0x640
>         [<ffffffff8124c23f>] dax_fault+0x3f/0x90
>         [<ffffffffa01ff975>] ext4_dax_fault+0x15/0x20 [ext4]
>         [<ffffffff811ab6d1>] __do_fault+0x41/0xd0
>         [<ffffffff811ae7f5>] do_shared_fault.isra.56+0x35/0x220
>         [<ffffffff811af983>] handle_mm_fault+0x303/0xf70
>         [<ffffffff81062d2c>] __do_page_fault+0x1ec/0x5b0
>         [<ffffffff81063112>] do_page_fault+0x22/0x30
>         [<ffffffff815d18b8>] page_fault+0x28/0x30
>  
>  other info that might help us debug this:
>  
>   Possible unsafe locking scenario:
>  
>         CPU0                    CPU1
>         ----                    ----
>    lock(&mapping->i_mmap_mutex);
>                                 lock(jbd2_handle);
>                                 lock(&mapping->i_mmap_mutex);
>    lock(jbd2_handle);
>  
>   *** DEADLOCK ***
>  
>  3 locks held by fstest/31836:
>   #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81062cc2>] __do_page_fault+0x182/0x5b0
>   #1:  (sb_pagefaults){++++..}, at: [<ffffffff8124c27a>] dax_fault+0x7a/0x90
>   #2:  (&mapping->i_mmap_mutex){+.+...}, at: [<ffffffff8124c0a0>] do_dax_fault+0x4e0/0x640
>  
>  stack backtrace:
>  CPU: 6 PID: 31836 Comm: fstest Tainted: G        W     3.16.0-rc6+ #91
>  Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Q87M-D2H, BIOS F6 08/03/2013
>   ffffffff825e63e0 ffff8800a0fc78c0 ffffffff815c6bc3 ffffffff825e63e0
>   ffff8800a0fc7900 ffffffff815c4e59 ffff8800a0fc7970 ffff8800a88f4a50
>   ffff8800a88f4af8 ffff8800a88f5280 0000000000000003 ffff8800a88f5248
>  Call Trace:
>   [<ffffffff815c6bc3>] dump_stack+0x4d/0x66
>   [<ffffffff815c4e59>] print_circular_bug+0x201/0x20f
>   [<ffffffff810ce9e1>] __lock_acquire+0x1d01/0x1eb0
>   [<ffffffff81023b00>] ? cyc2ns_read_end+0x20/0x20
>   [<ffffffff810cfa22>] lock_acquire+0xb2/0x1f0
>   [<ffffffffa00f5333>] ? start_this_handle+0x193/0x630 [jbd2]
>   [<ffffffffa00f538e>] start_this_handle+0x1ee/0x630 [jbd2]
>   [<ffffffffa00f5333>] ? start_this_handle+0x193/0x630 [jbd2]
>   [<ffffffffa00f5020>] ? new_handle+0x20/0x60 [jbd2]
>   [<ffffffffa00f5c04>] jbd2__journal_start+0xd4/0x260 [jbd2]
>   [<ffffffffa0206fca>] ? _ext4_get_block+0x16a/0x1c0 [ext4]
>   [<ffffffffa0235f6d>] __ext4_journal_start_sb+0x6d/0x190 [ext4]
>   [<ffffffffa0206fca>] _ext4_get_block+0x16a/0x1c0 [ext4]
>   [<ffffffffa0207036>] ext4_get_block+0x16/0x20 [ext4]
>   [<ffffffff8124c199>] do_dax_fault+0x5d9/0x640
>   [<ffffffffa0207020>] ? _ext4_get_block+0x1c0/0x1c0 [ext4]
>   [<ffffffffa0207020>] ? _ext4_get_block+0x1c0/0x1c0 [ext4]
>   [<ffffffff8124c23f>] dax_fault+0x3f/0x90
>   [<ffffffffa01ff975>] ext4_dax_fault+0x15/0x20 [ext4]
>   [<ffffffff811ab6d1>] __do_fault+0x41/0xd0
>   [<ffffffff811ae7f5>] do_shared_fault.isra.56+0x35/0x220
>   [<ffffffff811af983>] handle_mm_fault+0x303/0xf70
>   [<ffffffff810ca676>] ? __lock_is_held+0x56/0x80
>   [<ffffffff81062d2c>] __do_page_fault+0x1ec/0x5b0
>   [<ffffffff8119dc3c>] ? vm_mmap_pgoff+0x9c/0xc0
>   [<ffffffff810c80cf>] ? up_write+0x1f/0x40
>   [<ffffffff8119dc3c>] ? vm_mmap_pgoff+0x9c/0xc0
>   [<ffffffff8133e1ea>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>   [<ffffffff81063112>] do_page_fault+0x22/0x30
>   [<ffffffff815d18b8>] page_fault+0x28/0x30
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--EeQfGwPcQSOJBaQU
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Avoid-lock-inversion-between-i_mmap_mutex-and-t.patch"

>From c01c905cf3c4c6304a5ea9836389d9cf0d575884 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 30 Jul 2014 11:49:07 +0200
Subject: [PATCH] ext4: Avoid lock inversion between i_mmap_mutex and
 transaction start

When DAX is enabled, it uses i_mmap_mutex as a protection against
truncate during page fault. This inevitably forces i_mmap_mutex to rank
outside of a transaction start and thus we have to avoid calling
pagecache purging operations when transaction is started.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8a064734e6eb..494a8645d63e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3631,13 +3631,19 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
 
-	/* Now release the pages again to reduce race window */
+	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
+	ext4_mark_inode_dirty(handle, inode);
+	ext4_journal_stop(handle);
+
+	/*
+	 * Now release the pages again to reduce race window. This has to happen
+	 * outside of a transaction to avoid lock inversion on i_mmap_mutex
+	 * when DAX is enabled.
+	 */
 	if (last_block_offset > first_block_offset)
 		truncate_pagecache_range(inode, first_block_offset,
 					 last_block_offset);
-
-	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	goto out_dio;
 out_stop:
 	ext4_journal_stop(handle);
 out_dio:
-- 
1.8.1.4


--EeQfGwPcQSOJBaQU--
