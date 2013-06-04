Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3FDXIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:08:19 -0400
Received: from 1wt.eu ([62.212.114.60]:35530 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab3FDWmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:40 -0400
Message-Id: <20130604172135.202386396@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Willy Tarreau <w@1wt.eu>
Subject: [ 118/184] jbd: Fix assertion failure in commit code due to
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 lacking transaction credits

From: Jan Kara <jack@suse.cz>

ext3 users of data=journal mode with blocksize < pagesize were occasionally
hitting assertion failure in journal_commit_transaction() checking whether the
transaction has at least as many credits reserved as buffers attached.  The
core of the problem is that when a file gets truncated, buffers that still need
checkpointing or that are attached to the committing transaction are left with
buffer_mapped set. When this happens to buffers beyond i_size attached to a
page stradding i_size, subsequent write extending the file will see these
buffers and as they are mapped (but underlying blocks were freed) things go
awry from here.

The assertion failure just coincidentally (and in this case luckily as we would
start corrupting filesystem) triggers due to journal_head not being properly
cleaned up as well.

Under some rare circumstances this bug could even hit data=ordered mode users.
There the assertion won't trigger and we would end up corrupting the
filesystem.

We fix the problem by unmapping buffers if possible (in lots of cases we just
need a buffer attached to a transaction as a place holder but it must not be
written out anyway). And in one case, we just have to bite the bullet and wait
for transaction commit to finish.

Reviewed-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Jan Kara <jack@suse.cz>
(cherry picked from commit 09e05d4805e6c524c1af74e524e5d0528bb3fef3)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/jbd/commit.c      | 45 +++++++++++++++++++++++++++---------
 fs/jbd/transaction.c | 64 ++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 78 insertions(+), 31 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 2a5cdd0..1060d48 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -85,7 +85,12 @@ nope:
 static void release_data_buffer(struct buffer_head *bh)
 {
 	if (buffer_freed(bh)) {
+		WARN_ON_ONCE(buffer_dirty(bh));
 		clear_buffer_freed(bh);
+		clear_buffer_mapped(bh);
+		clear_buffer_new(bh);
+		clear_buffer_req(bh);
+		bh->b_bdev = NULL;
 		release_buffer_page(bh);
 	} else
 		put_bh(bh);
@@ -864,17 +869,35 @@ restart_loop:
 		 * there's no point in keeping a checkpoint record for
 		 * it. */
 
-		/* A buffer which has been freed while still being
-		 * journaled by a previous transaction may end up still
-		 * being dirty here, but we want to avoid writing back
-		 * that buffer in the future after the "add to orphan"
-		 * operation been committed,  That's not only a performance
-		 * gain, it also stops aliasing problems if the buffer is
-		 * left behind for writeback and gets reallocated for another
-		 * use in a different page. */
-		if (buffer_freed(bh) && !jh->b_next_transaction) {
-			clear_buffer_freed(bh);
-			clear_buffer_jbddirty(bh);
+		/*
+		 * A buffer which has been freed while still being journaled by
+		 * a previous transaction.
+		 */
+		if (buffer_freed(bh)) {
+			/*
+			 * If the running transaction is the one containing
+			 * "add to orphan" operation (b_next_transaction !=
+			 * NULL), we have to wait for that transaction to
+			 * commit before we can really get rid of the buffer.
+			 * So just clear b_modified to not confuse transaction
+			 * credit accounting and refile the buffer to
+			 * BJ_Forget of the running transaction. If the just
+			 * committed transaction contains "add to orphan"
+			 * operation, we can completely invalidate the buffer
+			 * now. We are rather throughout in that since the
+			 * buffer may be still accessible when blocksize <
+			 * pagesize and it is attached to the last partial
+			 * page.
+			 */
+			jh->b_modified = 0;
+			if (!jh->b_next_transaction) {
+				clear_buffer_freed(bh);
+				clear_buffer_jbddirty(bh);
+				clear_buffer_mapped(bh);
+				clear_buffer_new(bh);
+				clear_buffer_req(bh);
+				bh->b_bdev = NULL;
+			}
 		}
 
 		if (buffer_jbddirty(bh)) {
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 99e9fea..4eff79c 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1838,15 +1838,16 @@ static int __dispose_buffer(struct journal_head *jh, transaction_t *transaction)
  * We're outside-transaction here.  Either or both of j_running_transaction
  * and j_committing_transaction may be NULL.
  */
-static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
+static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
+				int partial_page)
 {
 	transaction_t *transaction;
 	struct journal_head *jh;
 	int may_free = 1;
-	int ret;
 
 	BUFFER_TRACE(bh, "entry");
 
+retry:
 	/*
 	 * It is safe to proceed here without the j_list_lock because the
 	 * buffers cannot be stolen by try_to_free_buffers as long as we are
@@ -1874,10 +1875,18 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 	 * clear the buffer dirty bit at latest at the moment when the
 	 * transaction marking the buffer as freed in the filesystem
 	 * structures is committed because from that moment on the
-	 * buffer can be reallocated and used by a different page.
+	 * block can be reallocated and used by a different page.
 	 * Since the block hasn't been freed yet but the inode has
 	 * already been added to orphan list, it is safe for us to add
 	 * the buffer to BJ_Forget list of the newest transaction.
+	 *
+	 * Also we have to clear buffer_mapped flag of a truncated buffer
+	 * because the buffer_head may be attached to the page straddling
+	 * i_size (can happen only when blocksize < pagesize) and thus the
+	 * buffer_head can be reused when the file is extended again. So we end
+	 * up keeping around invalidated buffers attached to transactions'
+	 * BJ_Forget list just to stop checkpointing code from cleaning up
+	 * the transaction this buffer was modified in.
 	 */
 	transaction = jh->b_transaction;
 	if (transaction == NULL) {
@@ -1904,13 +1913,9 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 			 * committed, the buffer won't be needed any
 			 * longer. */
 			JBUFFER_TRACE(jh, "checkpointed: add to BJ_Forget");
-			ret = __dispose_buffer(jh,
+			may_free = __dispose_buffer(jh,
 					journal->j_running_transaction);
-			journal_put_journal_head(jh);
-			spin_unlock(&journal->j_list_lock);
-			jbd_unlock_bh_state(bh);
-			spin_unlock(&journal->j_state_lock);
-			return ret;
+			goto zap_buffer;
 		} else {
 			/* There is no currently-running transaction. So the
 			 * orphan record which we wrote for this file must have
@@ -1918,13 +1923,9 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 			 * the committing transaction, if it exists. */
 			if (journal->j_committing_transaction) {
 				JBUFFER_TRACE(jh, "give to committing trans");
-				ret = __dispose_buffer(jh,
+				may_free = __dispose_buffer(jh,
 					journal->j_committing_transaction);
-				journal_put_journal_head(jh);
-				spin_unlock(&journal->j_list_lock);
-				jbd_unlock_bh_state(bh);
-				spin_unlock(&journal->j_state_lock);
-				return ret;
+				goto zap_buffer;
 			} else {
 				/* The orphan record's transaction has
 				 * committed.  We can cleanse this buffer */
@@ -1945,10 +1946,24 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 		}
 		/*
 		 * The buffer is committing, we simply cannot touch
-		 * it. So we just set j_next_transaction to the
-		 * running transaction (if there is one) and mark
-		 * buffer as freed so that commit code knows it should
-		 * clear dirty bits when it is done with the buffer.
+		 * it. If the page is straddling i_size we have to wait
+		 * for commit and try again.
+		 */
+		if (partial_page) {
+			tid_t tid = journal->j_committing_transaction->t_tid;
+
+			journal_put_journal_head(jh);
+			spin_unlock(&journal->j_list_lock);
+			jbd_unlock_bh_state(bh);
+			spin_unlock(&journal->j_state_lock);
+			log_wait_commit(journal, tid);
+			goto retry;
+		}
+		/*
+		 * OK, buffer won't be reachable after truncate. We just set
+		 * j_next_transaction to the running transaction (if there is
+		 * one) and mark buffer as freed so that commit code knows it
+		 * should clear dirty bits when it is done with the buffer.
 		 */
 		set_buffer_freed(bh);
 		if (journal->j_running_transaction && buffer_jbddirty(bh))
@@ -1971,6 +1986,14 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 	}
 
 zap_buffer:
+	/*
+	 * This is tricky. Although the buffer is truncated, it may be reused
+	 * if blocksize < pagesize and it is attached to the page straddling
+	 * EOF. Since the buffer might have been added to BJ_Forget list of the
+	 * running transaction, journal_get_write_access() won't clear
+	 * b_modified and credit accounting gets confused. So clear b_modified
+	 * here. */
+	jh->b_modified = 0;
 	journal_put_journal_head(jh);
 zap_buffer_no_jh:
 	spin_unlock(&journal->j_list_lock);
@@ -2019,7 +2042,8 @@ void journal_invalidatepage(journal_t *journal,
 		if (offset <= curr_off) {
 			/* This block is wholly outside the truncation point */
 			lock_buffer(bh);
-			may_free &= journal_unmap_buffer(journal, bh);
+			may_free &= journal_unmap_buffer(journal, bh,
+							 offset > 0);
 			unlock_buffer(bh);
 		}
 		curr_off = next_off;
-- 
1.7.12.2.21.g234cd45.dirty



