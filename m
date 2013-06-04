Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3FDW5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:57:55 -0400
Received: from 1wt.eu ([62.212.114.60]:35735 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab3FDWn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:27 -0400
Message-Id: <20130604172135.161007388@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Willy Tarreau <w@1wt.eu>
Subject: [ 117/184] jbd: Delay discarding buffers in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 journal_unmap_buffer

From: Jan Kara <jack@suse.cz>

Delay discarding buffers in journal_unmap_buffer until
we know that "add to orphan" operation has definitely been
committed, otherwise the log space of committing transation
may be freed and reused before truncate get committed, updates
may get lost if crash happens.

This patch is a backport of JBD2 fix by dingdinghua <dingdinghua@nrchpc.ac.cn>.

Signed-off-by: Jan Kara <jack@suse.cz>
(cherry picked from commit 86963918965eb8fe0c8ae009e7c1b4c630f533d5)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/jbd/commit.c      | 10 +++++-----
 fs/jbd/transaction.c | 43 +++++++++++++++++++++++++++++++------------
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 17d29a8..2a5cdd0 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -867,12 +867,12 @@ restart_loop:
 		/* A buffer which has been freed while still being
 		 * journaled by a previous transaction may end up still
 		 * being dirty here, but we want to avoid writing back
-		 * that buffer in the future now that the last use has
-		 * been committed.  That's not only a performance gain,
-		 * it also stops aliasing problems if the buffer is left
-		 * behind for writeback and gets reallocated for another
+		 * that buffer in the future after the "add to orphan"
+		 * operation been committed,  That's not only a performance
+		 * gain, it also stops aliasing problems if the buffer is
+		 * left behind for writeback and gets reallocated for another
 		 * use in a different page. */
-		if (buffer_freed(bh)) {
+		if (buffer_freed(bh) && !jh->b_next_transaction) {
 			clear_buffer_freed(bh);
 			clear_buffer_jbddirty(bh);
 		}
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 006f9ad..99e9fea 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1864,6 +1864,21 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 	if (!jh)
 		goto zap_buffer_no_jh;
 
+	/*
+	 * We cannot remove the buffer from checkpoint lists until the
+	 * transaction adding inode to orphan list (let's call it T)
+	 * is committed.  Otherwise if the transaction changing the
+	 * buffer would be cleaned from the journal before T is
+	 * committed, a crash will cause that the correct contents of
+	 * the buffer will be lost.  On the other hand we have to
+	 * clear the buffer dirty bit at latest at the moment when the
+	 * transaction marking the buffer as freed in the filesystem
+	 * structures is committed because from that moment on the
+	 * buffer can be reallocated and used by a different page.
+	 * Since the block hasn't been freed yet but the inode has
+	 * already been added to orphan list, it is safe for us to add
+	 * the buffer to BJ_Forget list of the newest transaction.
+	 */
 	transaction = jh->b_transaction;
 	if (transaction == NULL) {
 		/* First case: not on any transaction.  If it
@@ -1929,16 +1944,15 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 			goto zap_buffer;
 		}
 		/*
-		 * If it is committing, we simply cannot touch it.  We
-		 * can remove it's next_transaction pointer from the
-		 * running transaction if that is set, but nothing
-		 * else. */
+		 * The buffer is committing, we simply cannot touch
+		 * it. So we just set j_next_transaction to the
+		 * running transaction (if there is one) and mark
+		 * buffer as freed so that commit code knows it should
+		 * clear dirty bits when it is done with the buffer.
+		 */
 		set_buffer_freed(bh);
-		if (jh->b_next_transaction) {
-			J_ASSERT(jh->b_next_transaction ==
-					journal->j_running_transaction);
-			jh->b_next_transaction = NULL;
-		}
+		if (journal->j_running_transaction && buffer_jbddirty(bh))
+			jh->b_next_transaction = journal->j_running_transaction;
 		journal_put_journal_head(jh);
 		spin_unlock(&journal->j_list_lock);
 		jbd_unlock_bh_state(bh);
@@ -2120,7 +2134,7 @@ void journal_file_buffer(struct journal_head *jh,
  */
 void __journal_refile_buffer(struct journal_head *jh)
 {
-	int was_dirty;
+	int was_dirty, jlist;
 	struct buffer_head *bh = jh2bh(jh);
 
 	J_ASSERT_JH(jh, jbd_is_locked_bh_state(bh));
@@ -2142,8 +2156,13 @@ void __journal_refile_buffer(struct journal_head *jh)
 	__journal_temp_unlink_buffer(jh);
 	jh->b_transaction = jh->b_next_transaction;
 	jh->b_next_transaction = NULL;
-	__journal_file_buffer(jh, jh->b_transaction,
-				jh->b_modified ? BJ_Metadata : BJ_Reserved);
+	if (buffer_freed(bh))
+		jlist = BJ_Forget;
+	else if (jh->b_modified)
+		jlist = BJ_Metadata;
+	else
+		jlist = BJ_Reserved;
+	__journal_file_buffer(jh, jh->b_transaction, jlist);
 	J_ASSERT_JH(jh, jh->b_transaction->t_state == T_RUNNING);
 
 	if (was_dirty)
-- 
1.7.12.2.21.g234cd45.dirty



