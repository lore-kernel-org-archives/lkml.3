Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab3FGF5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:57:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19696 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3FGF5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:57:21 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-fa-51b1763f5e0c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: fix iget/iput of dir during recovery
Date: Fri, 07 Jun 2013 14:55:56 +0900
Message-id: <1370584557-20592-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zfV37so2BBjs3aFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfHr61bWglVyFTum
	v2JvYFwi2cXIySEhYCKx9+MDVghbTOLCvfVsXYxcHEICyxgl7pzYwQ5TNP/jZmaIxHRGicb9
	O8A6hATamCR2/6jsYuTgYBPQlti83wAkLCLALLFg6nlGkHpmgQmMEv8XvWcBSQgL2EucO/we
	bCiLgKpE25weRhCbV8Bd4umV41DLdCVW/3/ODtIsIfCcTaJ1ynM2iAYBiW+TD7GALJMQkJXY
	dIAZol5S4uCKGywTGAUXMDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAgJwd4djLcPWB9i
	TAYaN5FZSjQ5HxjCeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgjJHkMFZ+pnny52cdnvemu3Ujr5onTxfIvKAb/GSxlR+fIv+C6J3BPFc/+l+c
	/jks0fwWyxLBn4+Pe5hl3vVtaObiCXwy/8fWiwsCN823O19omt5n8rGI+cXm/zevedTc2ty9
	apG5LPdt7oxKxfQIt5bq6H3tn12Xmkw/NskzYcsVy4YHvRLpSizFGYmGWsxFxYkA+wF6gFcC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQV37so2BBicfq1pc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx6+tW1oJVchU7pr9ib2BcItnFyMkhIWAiMf/jZmYIW0ziwr31bF2MXBxC
	AtMZJRr372AFSQgJtDFJ7P5R2cXIwcEmoC2xeb8BSFhEgFliwdTzjCD1zAITGCX+L3rPApIQ
	FrCXOHf4PTuIzSKgKtE2p4cRxOYVcJd4euU4O8QyXYnV/5+zT2DkXsDIsIpRNLUguaA4KT3X
	UK84Mbe4NC9dLzk/dxMjOMCfSe1gXNlgcYhRgINRiYf356oNgUKsiWXFlbmHGCU4mJVEeNen
	bQwU4k1JrKxKLcqPLyrNSS0+xJgMtH0is5Rocj4w+vJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Q
	ah0oJJCeWJKanZpakFoEs4WJg1OqgXFvR9f1LI9JaecZvLV2zpJbOHV9b73NS0epSR9v/RQs
	riz5kK+Zd/d5YV3Uq8rHwWujjBufqzQwv7990GDJrynez6eLLDWpTda5ukem9cFKm68HV93h
	mHvwJtdqhdwHN1a1+okmZPzdszBq55YJM1cb1L7SUOJLrBbXWrXhS6jM9c9KVlnvttQrsRRn
	JBpqMRcVJwIActmIJ7QCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that iput is skipped after iget during the recovery.

In recover_dentry(),
 dir = f2fs_iget();
 ...
 if (de && inode->i_ino == le32_to_cpu(de->ino))
	goto out;

In this case, this dir is not able to be added in dirty_dir_inode_list.
The actual linking is done only when set_page_dirty() is called.

So let's add this newly got inode into the list explicitly, and put it at the
end of the recovery routine.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 55 +++++++++++++++++++++++++++++++++++++---------------
 fs/f2fs/f2fs.h       |  1 +
 fs/f2fs/recovery.c   |  1 +
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 6f56e57..9a77509 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -450,13 +450,30 @@ fail_no_cp:
 	return -EINVAL;
 }
 
-void set_dirty_dir_page(struct inode *inode, struct page *page)
+static int __add_dirty_inode(struct inode *inode, struct dir_inode_entry *new)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct list_head *head = &sbi->dir_inode_list;
-	struct dir_inode_entry *new;
 	struct list_head *this;
 
+	list_for_each(this, head) {
+		struct dir_inode_entry *entry;
+		entry = list_entry(this, struct dir_inode_entry, list);
+		if (entry->inode == inode)
+			return -EEXIST;
+	}
+	list_add_tail(&new->list, head);
+#ifdef CONFIG_F2FS_STAT_FS
+	sbi->n_dirty_dirs++;
+#endif
+	return 0;
+}
+
+void set_dirty_dir_page(struct inode *inode, struct page *page)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct dir_inode_entry *new;
+
 	if (!S_ISDIR(inode->i_mode))
 		return;
 retry:
@@ -469,25 +486,31 @@ retry:
 	INIT_LIST_HEAD(&new->list);
 
 	spin_lock(&sbi->dir_inode_lock);
-	list_for_each(this, head) {
-		struct dir_inode_entry *entry;
-		entry = list_entry(this, struct dir_inode_entry, list);
-		if (entry->inode == inode) {
-			kmem_cache_free(inode_entry_slab, new);
-			goto out;
-		}
-	}
-	list_add_tail(&new->list, head);
-#ifdef CONFIG_F2FS_STAT_FS
-	sbi->n_dirty_dirs++;
-#endif
+	if (__add_dirty_inode(inode, new))
+		kmem_cache_free(inode_entry_slab, new);
 
-	BUG_ON(!S_ISDIR(inode->i_mode));
-out:
 	inc_page_count(sbi, F2FS_DIRTY_DENTS);
 	inode_inc_dirty_dents(inode);
 	SetPagePrivate(page);
+	spin_unlock(&sbi->dir_inode_lock);
+}
+
+void add_dirty_dir_inode(struct inode *inode)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct dir_inode_entry *new;
+retry:
+	new = kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
+	if (!new) {
+		cond_resched();
+		goto retry;
+	}
+	new->inode = inode;
+	INIT_LIST_HEAD(&new->list);
 
+	spin_lock(&sbi->dir_inode_lock);
+	if (__add_dirty_inode(inode, new))
+		kmem_cache_free(inode_entry_slab, new);
 	spin_unlock(&sbi->dir_inode_lock);
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 40b137a..d6e63da 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1030,6 +1030,7 @@ void remove_orphan_inode(struct f2fs_sb_info *, nid_t);
 int recover_orphan_inodes(struct f2fs_sb_info *);
 int get_valid_checkpoint(struct f2fs_sb_info *);
 void set_dirty_dir_page(struct inode *, struct page *);
+void add_dirty_dir_inode(struct inode *);
 void remove_dirty_dir_inode(struct inode *);
 struct inode *check_dirty_dir_inode(struct f2fs_sb_info *, nid_t);
 void sync_dirty_dir_inodes(struct f2fs_sb_info *);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 539ca32..ddde14f 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -58,6 +58,7 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 			goto out;
 		}
 		set_inode_flag(F2FS_I(dir), FI_DELAY_IPUT);
+		add_dirty_dir_inode(dir);
 	}
 
 	name.len = le32_to_cpu(raw_inode->i_namelen);
-- 
1.8.1.3.566.gaa39828

