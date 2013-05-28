Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab3E1Cdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 22:33:55 -0400
Received: from m59-178.qiye.163.com ([123.58.178.59]:59529 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab3E1Cdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 22:33:54 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 May 2013 22:33:53 EDT
From: Li Wang <liwang@ubuntukylin.com>
To: linux-ext4@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Zheng Liu <gnehzuil.liu@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Li Wang <liwang@ubuntukylin.com>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: [PATCH v4] ext4: Avoid unnecessarily writing back dirty pages before  hole punching
Date: Tue, 28 May 2013 10:23:25 +0800
Message-Id: <1369707805-11976-1-git-send-email-liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20130527144727.GA3877@quack.suse.cz>
References: <20130527144727.GA3877@quack.suse.cz>
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUhVQ0lCQkJCQklITEtNS05PTFdZCQ4XHghZQVkoKz0kKzooKCQyNSQz
	Pjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQiPigkMjUkMz46Pz4pQUtVS0A4NC41
	LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41OjVBS1VLQD8iNTo2MjgkMisk
	NTQkMjUkMz46Pz4pQUtVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80
	PzoiJDg1LyRLJEpLS0FLVUtAMiskSiQzNC4pJDg1LyRLJEpLS0FLVUtAMiskSiQ2MjUuLz4kODUv
	JEskSktBS1VLQDIrJEhLJDYyNS4vPiQ4NS8kSyROS0FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktB
	S1VLQCguOSQ#QUpVTk5APTUkKC45JD41LDQpPygkMzcxJEpLS0lLSkFLVUlDWQY+
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSE1CTEtMQ0lPSUNDVTMWGhIX
	VRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHgY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For hole punching, currently ext4 will synchronously write back the
dirty pages fit into the hole, since the data on the disk responding
to those pages are to be deleted, it is benefical to directly release
those pages, no matter they are dirty or not, except the ordered case.

Signed-off-by: Li Wang <liwang@ubuntukylin.com>
Signed-off-by: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
Hi Jan,
  Did you mean this?
  It seems you donot like the jbd2_journal_begin_ordered_discard:),
However, what do you think of calling jbd2_journal_begin_ordered_punch_hole()
from jbd2_journal_begin_ordered_truncate()? In my option, 
the two guys stand at the same level. Nevertheless, 
it is up to your choice.
---
 fs/ext4/inode.c       |   27 ++++++++++++++++-----------
 fs/jbd2/journal.c     |    2 +-
 fs/jbd2/transaction.c |   29 ++++++-----------------------
 include/linux/jbd2.h  |   33 +++++++++++++++++++++++++++++++--
 4 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d6382b8..844d1b8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3569,6 +3569,16 @@ int ext4_can_truncate(struct inode *inode)
 	return 0;
 }
 
+static inline int ext4_begin_ordered_punch_hole(struct inode *inode,
+					       loff_t start, loff_t length)
+{
+	if (!EXT4_I(inode)->jinode)
+		return 0;
+	return jbd2_journal_begin_ordered_punch_hole(EXT4_JOURNAL(inode),
+						    EXT4_I(inode)->jinode,
+						    start, start+length-1);
+}
+
 /*
  * ext4_punch_hole: punches a hole in a file by releaseing the blocks
  * associated with the given offset and length
@@ -3602,17 +3612,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 
 	trace_ext4_punch_hole(inode, offset, length);
 
-	/*
-	 * Write out all dirty pages to avoid race conditions
-	 * Then release them.
-	 */
-	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-		ret = filemap_write_and_wait_range(mapping, offset,
-						   offset + length - 1);
-		if (ret)
-			return ret;
-	}
-
 	mutex_lock(&inode->i_mutex);
 	/* It's not possible punch hole on append only file */
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode)) {
@@ -3644,6 +3643,12 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	first_page_offset = first_page << PAGE_CACHE_SHIFT;
 	last_page_offset = last_page << PAGE_CACHE_SHIFT;
 
+	if (ext4_should_order_data(inode)) {
+		ret = ext4_begin_ordered_punch_hole(inode, offset, length);
+		if (ret)
+			return ret;
+	}
+
 	/* Now release the pages */
 	if (last_page_offset > first_page_offset) {
 		truncate_pagecache_range(inode, first_page_offset,
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 9545757..7af4e4f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -97,7 +97,7 @@ EXPORT_SYMBOL(jbd2_journal_force_commit);
 EXPORT_SYMBOL(jbd2_journal_file_inode);
 EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
-EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
+EXPORT_SYMBOL(jbd2_journal_begin_ordered_punch_hole);
 EXPORT_SYMBOL(jbd2_inode_cache);
 
 static void __journal_abort_soft (journal_t *journal, int errno);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 10f524c..262b1c3 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2305,29 +2305,10 @@ done:
 	return 0;
 }
 
-/*
- * File truncate and transaction commit interact with each other in a
- * non-trivial way.  If a transaction writing data block A is
- * committing, we cannot discard the data by truncate until we have
- * written them.  Otherwise if we crashed after the transaction with
- * write has committed but before the transaction with truncate has
- * committed, we could see stale data in block A.  This function is a
- * helper to solve this problem.  It starts writeout of the truncated
- * part in case it is in the committing transaction.
- *
- * Filesystem code must call this function when inode is journaled in
- * ordered mode before truncation happens and after the inode has been
- * placed on orphan list with the new inode size. The second condition
- * avoids the race that someone writes new data and we start
- * committing the transaction after this function has been called but
- * before a transaction for truncate is started (and furthermore it
- * allows us to optimize the case where the addition to orphan list
- * happens in the same transaction as write --- we don't have to write
- * any data in such case).
- */
-int jbd2_journal_begin_ordered_truncate(journal_t *journal,
+
+int jbd2_journal_begin_ordered_punch_hole(journal_t *journal,
 					struct jbd2_inode *jinode,
-					loff_t new_size)
+					loff_t start, loff_t end)
 {
 	transaction_t *inode_trans, *commit_trans;
 	int ret = 0;
@@ -2346,10 +2327,12 @@ int jbd2_journal_begin_ordered_truncate(journal_t *journal,
 	spin_unlock(&journal->j_list_lock);
 	if (inode_trans == commit_trans) {
 		ret = filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
-			new_size, LLONG_MAX);
+			start, end);
 		if (ret)
 			jbd2_journal_abort(journal, ret);
 	}
 out:
 	return ret;
 }
+
+
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 6e051f4..8eb7865 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1126,12 +1126,41 @@ extern int	   jbd2_journal_clear_err  (journal_t *);
 extern int	   jbd2_journal_bmap(journal_t *, unsigned long, unsigned long long *);
 extern int	   jbd2_journal_force_commit(journal_t *);
 extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
-extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
-				struct jbd2_inode *inode, loff_t new_size);
+extern int	   jbd2_journal_begin_ordered_punch_hole(journal_t *,
+					struct jbd2_inode *,
+					loff_t, loff_t);
 extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
 extern void	   jbd2_journal_release_jbd_inode(journal_t *journal, struct jbd2_inode *jinode);
 
 /*
+ * File truncate and transaction commit interact with each other in a
+ * non-trivial way.  If a transaction writing data block A is
+ * committing, we cannot discard the data by truncate until we have
+ * written them.  Otherwise if we crashed after the transaction with
+ * write has committed but before the transaction with truncate has
+ * committed, we could see stale data in block A.  This function is a
+ * helper to solve this problem.  It starts writeout of the truncated
+ * part in case it is in the committing transaction.
+ *
+ * Filesystem code must call this function when inode is journaled in
+ * ordered mode before truncation happens and after the inode has been
+ * placed on orphan list with the new inode size. The second condition
+ * avoids the race that someone writes new data and we start
+ * committing the transaction after this function has been called but
+ * before a transaction for truncate is started (and furthermore it
+ * allows us to optimize the case where the addition to orphan list
+ * happens in the same transaction as write --- we don't have to write
+ * any data in such case).
+ */
+static inline int jbd2_journal_begin_ordered_truncate(journal_t *journal,
+					struct jbd2_inode *jinode,
+					loff_t new_size)
+{
+	return jbd2_journal_begin_ordered_punch_hole(journal, jinode,
+						  new_size, LLONG_MAX);
+}
+
+/*
  * journal_head management
  */
 struct journal_head *jbd2_journal_add_journal_head(struct buffer_head *bh);
-- 
1.7.9.5


