Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab3D2KWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:22:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14787 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab3D2KWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:22:22 -0400
X-AuditID: cbfee68d-b7f016d000007930-4c-517e49dcbf2f
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: use f2fs_iget_nowait again
Date: Mon, 29 Apr 2013 19:21:18 +0900
Message-id: <1367230878-10113-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t8zY907nnWBBg/XWFhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfHycS9jwQSJiq5N
	V1kbGDcLdzFycEgImEj8XhnQxcgJZIpJXLi3nq2LkYtDSGAZo0Tzj40sMDU7roRBxBcxSrRu
	nQlV1MYk8eTOBSaQIjYBbYnN+w1ABokIMEssmHqeEaSGWWACo8T/Re9ZQBLCAoYSLz/tBLNZ
	BFQlXk7bCGbzCrhLHPpykBXiCl2J1f+fs0PY99kkju8yh6gXkPg2+RDUQbISmw4wQ5RIShxc
	cYNlAqPgAkaGVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxgh4de7g/H2AetDjMlA4yYyS4km
	5wPDN68k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jKnb79vqVF985JSxevWqr8xnJj32OD7bOJnrzL/Uc/lRby59ul5k8OCXPqNG/P4vzbJlj1Su
	9J6/2uJn5XZla1fkog9rpt9raNKxZZFqMT17Onby3IYGt6/xp7VfHQli37xu45VFxsmNrcoX
	J168IzLLVlxy4haVxe+f627xZvg1t3SVTt632T+UWIozEg21mIuKEwEEi0rfVQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd07nnWBBtuWm1hc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jx8nEvY8EEiYquTVdZGxg3C3cxcnBICJhI7LgS1sXICWSKSVy4t56ti5GL
	Q0hgEaNE69aZUE4bk8STOxeYQBrYBLQlNu83AGkQEWCWWDD1PCNIDbPABEaJ/4ves4AkhAUM
	JV5+2glmswioSrycthHM5hVwlzj05SArxDZdidX/n7NPYORewMiwilE0tSC5oDgpPddIrzgx
	t7g0L10vOT93EyM4wJ9J72Bc1WBxiFGAg1GJhzdgc22gEGtiWXFl7iFGCQ5mJRHeM451gUK8
	KYmVValF+fFFpTmpxYcYk4G2T2SWEk3OB0ZfXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwdrF5deUWNmefLZ+3Jk5lb+utuGP6z3sSZ86U0W7J7G1WXhiS
	9PrF0nuJ13//lLrCKztJ7ei6niKLepUS/mS9HUtiOIPOzNxTK/yw3/vMOY9KMbFf3wP+6O26
	WmC3nf2F7qSPSmbsOxcqRJa8W+vl6pc3o7luvYu93Cve8hmfhaztbj13+TBfiaU4I9FQi7mo
	OBEAEdXQxbQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, I removed f2fs_iget_nowait() through the commit:
d4686d56ec912d55fd8a9d6d509de50de24e90ab
f2fs: avoid balanc_fs during evict_inode.

But, there is another error scenario as follows.

Thread 1:
- writeback_sb_inodes
 - do_writepages
  - f2fs_write_data_pages
   - write_cache_pages
    - f2fs_write_data_page
     - f2fs_balance_fs
      - wait mutex_lock(gc_mutex)

Thread 2:
- f2fs_balance_fs
 - mutex_lock(gc_mutex)
 - f2fs_gc
  - f2fs_iget
   - wait iget_locked(inode->i_lock)

Thread 3:
- do_unlinkat
 - iput
  - lock(inode->i_lock)
   - evict
    - inode_wait_for_writeback

The above three threads are able to incur deadlock condition.
In order to address this issue, let's use f2fs_iget_nowait again in f2fs_gc so
that thread 2 doesn't need to wait for inode->i_lock.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h  |  1 +
 fs/f2fs/gc.c    |  2 +-
 fs/f2fs/inode.c | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 20aab02..6fd872f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -893,6 +893,7 @@ long f2fs_compat_ioctl(struct file *, unsigned int, unsigned long);
  * inode.c
  */
 void f2fs_set_inode_flags(struct inode *);
+struct inode *f2fs_iget_nowait(struct super_block *, unsigned long);
 struct inode *f2fs_iget(struct super_block *, unsigned long);
 void update_inode(struct inode *, struct page *);
 int update_inode_page(struct inode *);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 25a1f7e..4b43b3f 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -580,7 +580,7 @@ next_step:
 		ofs_in_node = le16_to_cpu(entry->ofs_in_node);
 
 		if (phase == 2) {
-			inode = f2fs_iget(sb, dni.ino);
+			inode = f2fs_iget_nowait(sb, dni.ino);
 			if (IS_ERR(inode))
 				continue;
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 91ac7f9..a0879c3 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -18,6 +18,11 @@
 
 #include <trace/events/f2fs.h>
 
+struct f2fs_iget_args {
+	u64 ino;
+	int on_free;
+};
+
 void f2fs_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = F2FS_I(inode)->i_flags;
@@ -37,6 +42,34 @@ void f2fs_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_DIRSYNC;
 }
 
+static int f2fs_iget_test(struct inode *inode, void *data)
+{
+	struct f2fs_iget_args *args = data;
+
+	if (inode->i_ino != args->ino)
+		return 0;
+	if (inode->i_state & (I_FREEING | I_WILL_FREE)) {
+		args->on_free = 1;
+		return 0;
+	}
+	return 1;
+}
+
+struct inode *f2fs_iget_nowait(struct super_block *sb, unsigned long ino)
+{
+	struct f2fs_iget_args args = {
+		.ino = ino,
+		.on_free = 0
+	};
+	struct inode *inode = ilookup5(sb, ino, f2fs_iget_test, &args);
+
+	if (inode)
+		return inode;
+	if (!args.on_free)
+		return f2fs_iget(sb, ino);
+	return ERR_PTR(-ENOENT);
+}
+
 static int do_read_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-- 
1.8.1.3.566.gaa39828

