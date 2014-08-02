Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaHBH1Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 03:27:24 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19549 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHBH1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 03:27:22 -0400
X-AuditID: cbfee61a-f79e46d00000134f-2a-53dc92c6afcb
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: avoid skipping recover_inline_xattr after
 recover_inline_data
Date: Sat, 02 Aug 2014 15:26:04 +0800
Message-id: <021901cfae23$2afd3780$80f7a680$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: Ac+uHVoGYhi58G8jTjaDrAFieSjbRA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQd1jk+4EG3S9lrG4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Jq24wlbwVLDi247/jA2MT/i6GDk5JARMJJ53zGKDsMUkLtxbD2RzcQgJTGeUuH1hFjOE84NR
	YuHh6cwgVWwCKhLLO/4zgdgiAl4Sk/afYAGxmQUyJe41zQCq4eAQFkiQOHSCAyTMIqAq8fnR
	RFYQm1fAUuLGv/VsELagxI/J96BatSTW7zzOBGHLS2xe85YZ4iAFiR1nXzNCxMUlNh65xQKx
	Vk/i/KvNrBMYBWYhGTULyahZSEbNQtK+gJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw
	cD+T2sG4ssHiEKMAB6MSD6/BvtvBQqyJZcWVuYcYJTiYlUR4y9zuBAvxpiRWVqUW5ccXleak
	Fh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgPH0j7tXMOdXv+c6rc308rWv/Mcfv
	m3Xj9N6D3F9qfTf+604rL/LxUr8hevjF2ffm8+6tvLRrtfL8Tted0/eGzpp7vz2a5YT4PJmp
	FzWNFz3Sfhr42uLKFdvTb1JzX696tcRl0rHPOXbtIYWF781XJp88wbxsw61P3BLZp3Mk/8lq
	zutaLV+2u1iJpTgj0VCLuag4EQAEeIcCagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we recover data of inode in roll-forward procedure, and the inode has both
inline data and inline xattr. We may skip recovering inline xattr if we recover
inline data form node page first.
This patch will fix the problem that we lost inline xattr data in above
scenario.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h     | 1 +
 fs/f2fs/node.c     | 4 +---
 fs/f2fs/recovery.c | 2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 14b9f74..9832279 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1204,6 +1204,7 @@ void alloc_nid_done(struct f2fs_sb_info *, nid_t);
 void alloc_nid_failed(struct f2fs_sb_info *, nid_t);
 void recover_node_page(struct f2fs_sb_info *, struct page *,
 		struct f2fs_summary *, struct node_info *, block_t);
+void recover_inline_xattr(struct inode *, struct page *);
 bool recover_xattr_data(struct inode *, struct page *, block_t);
 int recover_inode_page(struct f2fs_sb_info *, struct page *);
 int restore_node_summary(struct f2fs_sb_info *, unsigned int,
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a90f51d..feba8c1 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1549,7 +1549,7 @@ void recover_node_page(struct f2fs_sb_info *sbi, struct page *page,
 	clear_node_page_dirty(page);
 }
 
-static void recover_inline_xattr(struct inode *inode, struct page *page)
+void recover_inline_xattr(struct inode *inode, struct page *page)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	void *src_addr, *dst_addr;
@@ -1588,8 +1588,6 @@ bool recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
 	nid_t new_xnid = nid_of_node(page);
 	struct node_info ni;
 
-	recover_inline_xattr(inode, page);
-
 	if (!f2fs_has_xattr_block(ofs_of_node(page)))
 		return false;
 
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index b2aa53b..fe1c6d9 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -300,6 +300,8 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 	struct node_info ni;
 	int err = 0, recovered = 0;
 
+	recover_inline_xattr(inode, page);
+
 	if (recover_inline_data(inode, page))
 		goto out;
 
-- 
2.0.1.474.g72c7794


