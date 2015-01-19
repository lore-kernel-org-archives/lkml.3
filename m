Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbbASMZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:25:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46372 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbbASMZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:25:41 -0500
X-AuditID: cbfee61a-f79c06d000004e71-27-54bcf7b48e3d
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH RESEND] f2fs: fix to release count of meta page in
 ->invalidatepage
Date: Mon, 19 Jan 2015 20:24:37 +0800
Message-id: <007701d033e2$fec89c90$fc59d5b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdAz4nv9a4KZCGdVR4aX9mqbVT07Eg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd0t3/eEGLRd0rC4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxtrnZ5kL
	zghX9N7YyNrAuFCgi5GTQ0LARGL3r+NMELaYxIV769lAbCGB6YwSzU/Uuxi5gOwfjBJ3tkxn
	BEmwCahILO/4D9YgIuAlMWn/CRYQm1nAQ6Kx4zsriC0sEC+xZvohdhCbRUBV4se0dqB6Dg5e
	AUuJhevA9vIKCEr8mHwPqlVLYv1OiBuYBeQlNq95ywxxj4LEjrOvGSFW6Un8ut0LVS8usfHI
	LZYJjAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOKCfSe1g
	XNlgcYhRgINRiYeXI2BPiBBrYllxZe4hRgkOZiUR3oAvQCHelMTKqtSi/Pii0pzU4kOM0hws
	SuK8SvZtIUIC6YklqdmpqQWpRTBZJg5OqQbGKUd7L2xYLsssJpy/vT6mWNCtXPDkGj65sAmb
	inQOqjYERclPiXZ+HcK2RUz5d6VB4PRujlduPLXJcm6HJ/LckvuwXUzPdsVON/NIfY+scJWL
	D/rC5ph5rlo1sWJ7uD7Lhn8bZhWU3+Spj+es3Kj0qpF1+aX5LKGuT7f9mekme0CpPZH32lsl
	luKMREMt5qLiRAAHK5zBZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will encounter deadloop in below scenario:

1. increase page count for F2FS_DIRTY_META type in following path:
->recover_fsync_data
  ->recover_data
    ->do_recover_data
      ->recover_data_page
        ->change_curseg
          ->write_sum_page
            ->set_page_dirty
2. fail in recover_data()
3. invalidate meta pages in truncate_inode_pages_final without decreasing page
   count.
4. deadloop when sync_meta_pages as page count will always be non-zero.

message:
NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!

 [<c1129a37>] pagevec_lookup_tag+0x27/0x30
 [<f0e774c7>] sync_meta_pages+0x87/0x160 [f2fs]
 [<f0e86dd9>] recover_fsync_data+0xeb9/0xf10 [f2fs]
 [<f0e75398>] f2fs_fill_super+0x888/0x980 [f2fs]
 [<c11733ca>] mount_bdev+0x16a/0x1a0
 [<f0e7180f>] f2fs_mount+0x1f/0x30 [f2fs]
 [<c1173da6>] mount_fs+0x36/0x170
 [<c118b6f5>] vfs_kern_mount+0x55/0xe0
 [<c118d63f>] do_mount+0x1df/0x9f0
 [<c118e110>] SyS_mount+0x70/0xb0
 [<c15a0c48>] sysenter_do_call+0x12/0x12

To avoid page count leak, let's add ->invalidatepage and ->releasepage in
f2fs_meta_aops as f2fs_node_aops to release meta page count correctly.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 9f5317c..63bf844 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -302,16 +302,35 @@ static int f2fs_set_meta_page_dirty(struct page *page)
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
 		inc_page_count(F2FS_P_SB(page), F2FS_DIRTY_META);
+		SetPagePrivate(page);
 		f2fs_trace_pid(page);
 		return 1;
 	}
 	return 0;
 }
 
+static void f2fs_invalidate_meta_page(struct page *page, unsigned int offset,
+				      unsigned int length)
+{
+	struct inode *inode = page->mapping->host;
+
+	if (PageDirty(page))
+		dec_page_count(F2FS_I_SB(inode), F2FS_DIRTY_META);
+	ClearPagePrivate(page);
+}
+
+static int f2fs_release_meta_page(struct page *page, gfp_t wait)
+{
+	ClearPagePrivate(page);
+	return 1;
+}
+
 const struct address_space_operations f2fs_meta_aops = {
 	.writepage	= f2fs_write_meta_page,
 	.writepages	= f2fs_write_meta_pages,
 	.set_page_dirty	= f2fs_set_meta_page_dirty,
+	.invalidatepage = f2fs_invalidate_meta_page,
+	.releasepage	= f2fs_release_meta_page,
 };
 
 static void __add_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
-- 
2.2.1


