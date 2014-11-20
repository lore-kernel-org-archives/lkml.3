Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbaKTGph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 01:45:37 -0500
Received: from mail.kernel.org ([198.145.19.201]:41510 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaKTGpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 01:45:35 -0500
Date: Wed, 19 Nov 2014 22:45:33 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Changman Lee <cm224.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 1/3] f2fs: call flush_dcache_page when the
 page was updated
Message-ID: <20141120064533.GA8860@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1416436510-6251-1-git-send-email-jaegeuk@kernel.org>
 <20141120060410.GB3117@lcm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120060410.GB3117@lcm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 03:04:10PM +0900, Changman Lee wrote:
> Hi Jaegeuk,
> 
> We should call flush_dcache_page before kunmap because the purpose of the cache flush is to address aliasing problem related to virtual address.

Oh, I just followed zero_user_segments below.

static inline void zero_user_segments(struct page *page,
	unsigned start1, unsigned end1,
	unsigned start2, unsigned end2)
{
	void *kaddr = kmap_atomic(page);

	BUG_ON(end1 > PAGE_SIZE || end2 > PAGE_SIZE);

	if (end1 > start1)
		memset(kaddr + start1, 0, end1 - start1);

	if (end2 > start2)
		memset(kaddr + start2, 0, end2 - start2);

	kunmap_atomic(kaddr);
	flush_dcache_page(page);
}

Is this a wrong reference? Or, a bug?

Anyway I modified as below.

Thanks,

>From 7cb7b27c8cd2efc8a31d79239bef5b41c6e79216 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Tue, 18 Nov 2014 10:50:21 -0800
Subject: [PATCH] f2fs: call flush_dcache_page when the page was updated

Whenever f2fs updates mapped pages, it needs to call flush_dcache_page.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/dir.c    | 7 ++++++-
 fs/f2fs/inline.c | 2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 5a49995..fabf4ee 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -287,8 +287,10 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
 	f2fs_wait_on_page_writeback(page, type);
 	de->ino = cpu_to_le32(inode->i_ino);
 	set_de_type(de, inode);
-	if (!f2fs_has_inline_dentry(dir))
+	if (!f2fs_has_inline_dentry(dir)) {
+		flush_dcache_page(page);
 		kunmap(page);
+	}
 	set_page_dirty(page);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(dir);
@@ -365,6 +367,7 @@ static int make_empty_dir(struct inode *inode,
 	make_dentry_ptr(&d, (void *)dentry_blk, 1);
 	do_make_empty_dir(inode, parent, &d);
 
+	flush_dcache_page(dentry_page);
 	kunmap_atomic(dentry_blk);
 
 	set_page_dirty(dentry_page);
@@ -578,6 +581,7 @@ fail:
 		update_inode_page(dir);
 		clear_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
 	}
+	flush_dcache_page(dentry_page);
 	kunmap(dentry_page);
 	f2fs_put_page(dentry_page, 1);
 	return err;
@@ -660,6 +664,7 @@ void f2fs_delete_entry(struct f2fs_dir_entry *dentry, struct page *page,
 	bit_pos = find_next_bit_le(&dentry_blk->dentry_bitmap,
 			NR_DENTRY_IN_BLOCK,
 			0);
+	flush_dcache_page(page);
 	kunmap(page); /* kunmap - pair of f2fs_find_entry */
 	set_page_dirty(page);
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index f26fb87..4291c1f 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -106,6 +106,7 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 	src_addr = inline_data_addr(dn->inode_page);
 	dst_addr = kmap_atomic(page);
 	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
+	flush_dcache_page(page);
 	kunmap_atomic(dst_addr);
 	SetPageUptodate(page);
 no_update:
@@ -357,6 +358,7 @@ static int f2fs_convert_inline_dir(struct inode *dir, struct page *ipage,
 	memcpy(dentry_blk->filename, inline_dentry->filename,
 					NR_INLINE_DENTRY * F2FS_SLOT_LEN);
 
+	flush_dcache_page(page);
 	kunmap_atomic(dentry_blk);
 	SetPageUptodate(page);
 	set_page_dirty(page);
-- 
2.1.1


