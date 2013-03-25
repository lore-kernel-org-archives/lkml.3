Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3CYBYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:24:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34058 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756179Ab3CYBQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:12 -0400
Message-Id: <20130325010529.347444888@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:15 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Jan Kara <jack@suse.cz>,
        Zheng Liu <gnehzuil.liu@gmail.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 051/104] jbd2: fix use after free in jbd2_journal_dirty_metadata()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jbd2/transaction.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1016,9 +1016,12 @@ out:
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
@@ -1070,17 +1073,18 @@ int jbd2_journal_dirty_metadata(handle_t
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
 
@@ -1171,6 +1175,7 @@ int jbd2_journal_dirty_metadata(handle_t
 	spin_unlock(&journal->j_list_lock);
 out_unlock_bh:
 	jbd_unlock_bh_state(bh);
+	jbd2_journal_put_journal_head(jh);
 out:
 	JBUFFER_TRACE(jh, "exit");
 	WARN_ON(ret);	/* All errors are bugs, so dump the stack */


