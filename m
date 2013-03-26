Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934840Ab3CZPve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:51:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53807 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965062Ab3CZPWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 065/150] jbd2: fix use after free in jbd2_journal_dirty_metadata()
Date: Tue, 26 Mar 2013 15:19:24 +0000
Message-Id: <1364311249-14454-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit ad56edad089b56300fd13bb9eeb7d0424d978239 upstream.

jbd2_journal_dirty_metadata() didn't get a reference to journal_head it
was working with. This is OK in most of the cases since the journal head
should be attached to a transaction but in rare occasions when we are
journalling data, __ext4_journalled_writepage() can race with
jbd2_journal_invalidatepage() stripping buffers from a page and thus
journal head can be freed under hands of jbd2_journal_dirty_metadata().

Fix the problem by getting own journal head reference in
jbd2_journal_dirty_metadata() (and also in jbd2_journal_set_triggers()
which can possibly have the same issue).

Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/jbd2/transaction.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 2fb20f5..399e4ee 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1047,9 +1047,12 @@ out:
 void jbd2_journal_set_triggers(struct buffer_head *bh,
 			       struct jbd2_buffer_trigger_type *type)
 {
-	struct journal_head *jh = bh2jh(bh);
+	struct journal_head *jh = jbd2_journal_grab_journal_head(bh);
 
+	if (WARN_ON(!jh))
+		return;
 	jh->b_triggers = type;
+	jbd2_journal_put_journal_head(jh);
 }
 
 void jbd2_buffer_frozen_trigger(struct journal_head *jh, void *mapped_data,
@@ -1101,17 +1104,18 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
-	struct journal_head *jh = bh2jh(bh);
+	struct journal_head *jh;
 	int ret = 0;
 
-	jbd_debug(5, "journal_head %p\n", jh);
-	JBUFFER_TRACE(jh, "entry");
 	if (is_handle_aborted(handle))
 		goto out;
-	if (!buffer_jbd(bh)) {
+	jh = jbd2_journal_grab_journal_head(bh);
+	if (!jh) {
 		ret = -EUCLEAN;
 		goto out;
 	}
+	jbd_debug(5, "journal_head %p\n", jh);
+	JBUFFER_TRACE(jh, "entry");
 
 	jbd_lock_bh_state(bh);
 
@@ -1202,6 +1206,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	spin_unlock(&journal->j_list_lock);
 out_unlock_bh:
 	jbd_unlock_bh_state(bh);
+	jbd2_journal_put_journal_head(jh);
 out:
 	JBUFFER_TRACE(jh, "exit");
 	WARN_ON(ret);	/* All errors are bugs, so dump the stack */
-- 
1.8.1.2

