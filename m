Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3H0BHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3H0BHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>
Subject: [ 74/74] bcache: FUA fixes
Date: Mon, 26 Aug 2013 18:09:12 -0700
Message-Id: <20130827010439.572991759@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <koverstreet@google.com>

commit e49c7c374e7aacd1f04ecbc21d9dbbeeea4a77d6 upstream.

Journal writes need to be marked FUA, not just REQ_FLUSH. And btree node
writes have... weird ordering requirements.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/btree.c   |   23 +++++++++++++++++++++--
 drivers/md/bcache/journal.c |    2 +-
 drivers/md/bcache/request.c |   13 ++++++++++++-
 3 files changed, 34 insertions(+), 4 deletions(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -326,10 +326,25 @@ static void do_btree_write(struct btree
 	i->csum		= btree_csum_set(b, i);
 
 	btree_bio_init(b);
-	b->bio->bi_rw	= REQ_META|WRITE_SYNC;
+	b->bio->bi_rw	= REQ_META|WRITE_SYNC|REQ_FUA;
 	b->bio->bi_size	= set_blocks(i, b->c) * block_bytes(b->c);
 	bch_bio_map(b->bio, i);
 
+	/*
+	 * If we're appending to a leaf node, we don't technically need FUA -
+	 * this write just needs to be persisted before the next journal write,
+	 * which will be marked FLUSH|FUA.
+	 *
+	 * Similarly if we're writing a new btree root - the pointer is going to
+	 * be in the next journal entry.
+	 *
+	 * But if we're writing a new btree node (that isn't a root) or
+	 * appending to a non leaf btree node, we need either FUA or a flush
+	 * when we write the parent with the new pointer. FUA is cheaper than a
+	 * flush, and writes appending to leaf nodes aren't blocking anything so
+	 * just make all btree node writes FUA to keep things sane.
+	 */
+
 	bkey_copy(&k.key, &b->key);
 	SET_PTR_OFFSET(&k.key, 0, PTR_OFFSET(&k.key, 0) + bset_offset(b, i));
 
@@ -2142,6 +2157,9 @@ int bch_btree_insert(struct btree_op *op
 void bch_btree_set_root(struct btree *b)
 {
 	unsigned i;
+	struct closure cl;
+
+	closure_init_stack(&cl);
 
 	BUG_ON(!b->written);
 
@@ -2155,8 +2173,9 @@ void bch_btree_set_root(struct btree *b)
 	b->c->root = b;
 	__bkey_put(b->c, &b->key);
 
-	bch_journal_meta(b->c, NULL);
+	bch_journal_meta(b->c, &cl);
 	pr_debug("%s for %pf", pbtree(b), __builtin_return_address(0));
+	closure_sync(&cl);
 }
 
 /* Cache lookup */
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -622,7 +622,7 @@ static void journal_write_unlocked(struc
 		bio_reset(bio);
 		bio->bi_sector	= PTR_OFFSET(k, i);
 		bio->bi_bdev	= ca->bdev;
-		bio->bi_rw	= REQ_WRITE|REQ_SYNC|REQ_META|REQ_FLUSH;
+		bio->bi_rw	= REQ_WRITE|REQ_SYNC|REQ_META|REQ_FLUSH|REQ_FUA;
 		bio->bi_size	= sectors << 9;
 
 		bio->bi_end_io	= journal_write_endio;
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1053,9 +1053,20 @@ static void request_write(struct cached_
 		trace_bcache_writethrough(s->orig_bio);
 		closure_bio_submit(bio, cl, s->d);
 	} else {
-		s->op.cache_bio = bio;
 		trace_bcache_writeback(s->orig_bio);
 		bch_writeback_add(dc, bio_sectors(bio));
+
+		if (s->op.flush_journal) {
+			/* Also need to send a flush to the backing device */
+			s->op.cache_bio = bio_clone_bioset(bio, GFP_NOIO,
+							   dc->disk.bio_split);
+
+			bio->bi_size = 0;
+			bio->bi_vcnt = 0;
+			closure_bio_submit(bio, cl, s->d);
+		} else {
+			s->op.cache_bio = bio;
+		}
 	}
 out:
 	closure_call(&s->op.cl, bch_insert_data, NULL, cl);


