Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765251Ab3DKU1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:27:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18255 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760833Ab3DKU0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:24 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=HWtWBGnRnkMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=s7rnLD5xGRQA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202555.211182555@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, Jan Kara <jack@suse.cz>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 055/171 ] jbd2: fix use after free in jbd2_journal_dirty_metadata()
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0055-jbd2-fix-use-after-free-in-jbd2_journal_dirty_metada.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit ad56edad089b56300fd13bb9eeb7d0424d978239 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/jbd2/transaction.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index fb1ab953..9427cf1 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1046,9 +1046,12 @@ out:
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
@@ -1100,17 +1103,18 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
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
 
@@ -1201,6 +1205,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	spin_unlock(&journal->j_list_lock);
 out_unlock_bh:
 	jbd_unlock_bh_state(bh);
+	jbd2_journal_put_journal_head(jh);
 out:
 	JBUFFER_TRACE(jh, "exit");
 	WARN_ON(ret);	/* All errors are bugs, so dump the stack */
-- 
1.7.10.4


