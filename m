Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab3EGOB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:01:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42408 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117Ab3EGNln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 072/118] ext4/jbd2: don't wait (forever) for stale tid caused by wraparound
Date: Tue,  7 May 2013 14:38:38 +0100
Message-Id: <1367933964-1564-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit d76a3a77113db020d9bb1e894822869410450bd9 upstream.

In the case where an inode has a very stale transaction id (tid) in
i_datasync_tid or i_sync_tid, it's possible that after a very large
(2**31) number of transactions, that the tid number space might wrap,
causing tid_geq()'s calculations to fail.

Commit deeeaf13 "jbd2: fix fsync() tid wraparound bug", later modified
by commit e7b04ac0 "jbd2: don't wake kjournald unnecessarily",
attempted to fix this problem, but it only avoided kjournald spinning
forever by fixing the logic in jbd2_log_start_commit().

Unfortunately, in the codepaths in fs/ext4/fsync.c and fs/ext4/inode.c
that might call jbd2_log_start_commit() with a stale tid, those
functions will subsequently call jbd2_log_wait_commit() with the same
stale tid, and then wait for a very long time.  To fix this, we
replace the calls to jbd2_log_start_commit() and
jbd2_log_wait_commit() with a call to a new function,
jbd2_complete_transaction(), which will correctly handle stale tid's.

As a bonus, jbd2_complete_transaction() will avoid locking
j_state_lock for writing unless a commit needs to be started.  This
should have a small (but probably not measurable) improvement for
ext4's scalability.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Reported-by: George Barnett <gbarnett@atlassian.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/fsync.c      |  3 +--
 fs/ext4/inode.c      |  3 +--
 fs/jbd2/journal.c    | 31 +++++++++++++++++++++++++++++++
 include/linux/jbd2.h |  1 +
 4 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index bb6c7d8..a8d03a4 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -260,8 +260,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (journal->j_flags & JBD2_BARRIER &&
 	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
 		needs_barrier = true;
-	jbd2_log_start_commit(journal, commit_tid);
-	ret = jbd2_log_wait_commit(journal, commit_tid);
+	ret = jbd2_complete_transaction(journal, commit_tid);
 	if (needs_barrier)
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
  out:
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c14b394..0ec3a3f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -216,8 +216,7 @@ void ext4_evict_inode(struct inode *inode)
 			journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 			tid_t commit_tid = EXT4_I(inode)->i_datasync_tid;
 
-			jbd2_log_start_commit(journal, commit_tid);
-			jbd2_log_wait_commit(journal, commit_tid);
+			jbd2_complete_transaction(journal, commit_tid);
 			filemap_write_and_wait(&inode->i_data);
 		}
 		truncate_inode_pages(&inode->i_data, 0);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0f16edd..dfb0e5b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -699,6 +699,37 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
 }
 
 /*
+ * When this function returns the transaction corresponding to tid
+ * will be completed.  If the transaction has currently running, start
+ * committing that transaction before waiting for it to complete.  If
+ * the transaction id is stale, it is by definition already completed,
+ * so just return SUCCESS.
+ */
+int jbd2_complete_transaction(journal_t *journal, tid_t tid)
+{
+	int	need_to_wait = 1;
+
+	read_lock(&journal->j_state_lock);
+	if (journal->j_running_transaction &&
+	    journal->j_running_transaction->t_tid == tid) {
+		if (journal->j_commit_request != tid) {
+			/* transaction not yet started, so request it */
+			read_unlock(&journal->j_state_lock);
+			jbd2_log_start_commit(journal, tid);
+			goto wait_commit;
+		}
+	} else if (!(journal->j_committing_transaction &&
+		     journal->j_committing_transaction->t_tid == tid))
+		need_to_wait = 0;
+	read_unlock(&journal->j_state_lock);
+	if (!need_to_wait)
+		return 0;
+wait_commit:
+	return jbd2_log_wait_commit(journal, tid);
+}
+EXPORT_SYMBOL(jbd2_complete_transaction);
+
+/*
  * Log buffer allocation routines:
  */
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 3efc43f..deee02a 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1211,6 +1211,7 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t tid);
 int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
 int jbd2_journal_force_commit_nested(journal_t *journal);
 int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
+int jbd2_complete_transaction(journal_t *journal, tid_t tid);
 int jbd2_log_do_checkpoint(journal_t *journal);
 int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid);
 
-- 
1.8.1.2

