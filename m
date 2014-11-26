Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaKZCHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 21:07:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:47468 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbaKZCHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 21:07:40 -0500
Date: Tue, 25 Nov 2014 18:07:33 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2 v2] f2fs: make clean the page before writing
Message-ID: <20141126020733.GA47165@jaegeuk-mac02>
References: <1416958796-39186-1-git-send-email-jaegeuk@kernel.org>
 <1416958796-39186-2-git-send-email-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416958796-39186-2-git-send-email-jaegeuk@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:
 o fix to handle # of dirty pages

If a page is set to be written to the disk, we can make clean the page.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inline.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 914b6d3..e27f290 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -84,7 +84,7 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 		.type = DATA,
 		.rw = WRITE_SYNC | REQ_PRIO,
 	};
-	int err;
+	int dirty, err;
 
 	f2fs_bug_on(F2FS_I_SB(dn->inode), page->index);
 
@@ -110,12 +110,17 @@ int f2fs_convert_inline_page(struct dnode_of_data *dn, struct page *page)
 	kunmap_atomic(dst_addr);
 	SetPageUptodate(page);
 no_update:
+	/* clear dirty state */
+	dirty = clear_page_dirty_for_io(page);
+
 	/* write data page to try to make data consistent */
 	set_page_writeback(page);
 
 	write_data_page(page, dn, &new_blk_addr, &fio);
 	update_extent_cache(new_blk_addr, dn);
 	f2fs_wait_on_page_writeback(page, DATA);
+	if (dirty)
+		inode_dec_dirty_pages(dn->inode);
 
 	/* clear inline data and flag after data writeback */
 	truncate_inline_data(dn->inode_page, 0);
-- 
2.1.1

