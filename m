Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3CZVng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:43:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3CZVnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:43:35 -0400
Date: Tue, 26 Mar 2013 14:43:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kent Overstreet <koverstreet@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree (akpm
 and block tree related)
Message-Id: <20130326144332.6307a66b95268521e89f95b1@linux-foundation.org>
In-Reply-To: <20130327083535.22ef6a9046f4b53e161481de@canb.auug.org.au>
References: <20130326170554.f9f113fa24a1e5ec6d5d1ee6@canb.auug.org.au>
	<20130326195523.GB24935@google.com>
	<20130326131051.a47fe83fdbdab4b824394f18@linux-foundation.org>
	<20130327083535.22ef6a9046f4b53e161481de@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013 08:35:35 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Guys,
> 
> On Tue, 26 Mar 2013 13:10:51 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 26 Mar 2013 12:55:23 -0700 Kent Overstreet <koverstreet@google.com> wrote:
> > 
> > > On Tue, Mar 26, 2013 at 05:05:54PM +1100, Stephen Rothwell wrote:
> > > > 
> > > > After merging the final tree, today's linux-next build
> > > > produced this warning:
> > > > 
> > > > fs/bio.c: In function 'submit_bio_wait':
> > > > fs/bio.c:786:17: warning: assignment from incompatible pointer type [enabled by default]
> > > > 
> > > > This is due to an interaction between commit 9e882242c ("block: Add
> > > > submit_bio_wait(), remove from md") from the block tree and commit
> > > > "block: prep work for batch completion" from the akpm tree.
> > > 
> > > In hindsight maybe it would've been better if the batch completion stuff
> > > had gone in via Jens' tree, though I'm sure there would've still been
> > > some conflicts.
> > > 
> > > What's the procedure for me to fix these? I can send you a fixup patch
> > > but if you've pushed this version of linux-next somewhere public I'm not
> > > sure where to look.
> > 
> > Stephen and I quietly fix up this sort of thing.
> 
> Yeah, though a hint might be nice.  It looks like these completion
> routines just need the batch argument added, right?

yup.

From: Andrew Morton <akpm@linux-foundation.org>
Subject: block-prep-work-for-batch-completion-fix-2

fs/bio.c: In function 'submit_bio_wait':
fs/bio.c:786: warning: assignment from incompatible pointer type

Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/bio.c~block-prep-work-for-batch-completion-fix-2 fs/bio.c
--- a/fs/bio.c~block-prep-work-for-batch-completion-fix-2
+++ a/fs/bio.c
@@ -760,7 +760,8 @@ struct submit_bio_ret {
 	int error;
 };
 
-static void submit_bio_wait_endio(struct bio *bio, int error)
+static void submit_bio_wait_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct submit_bio_ret *ret = bio->bi_private;
 
_











From: Andrew Morton <akpm@linux-foundation.org>
Subject: block-prep-work-for-batch-completion-fix-3

Cc: Kent Overstreet <koverstreet@google.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/btree.c     |    3 ++-
 drivers/md/bcache/io.c        |    6 ++++--
 drivers/md/bcache/journal.c   |    9 ++++++---
 drivers/md/bcache/movinggc.c  |    3 ++-
 drivers/md/bcache/request.c   |    9 ++++++---
 drivers/md/bcache/request.h   |    3 +--
 drivers/md/bcache/super.c     |   11 +++++++----
 drivers/md/bcache/writeback.c |    8 +++++---
 8 files changed, 33 insertions(+), 19 deletions(-)

diff -puN drivers/md/bcache/btree.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/btree.c
--- a/drivers/md/bcache/btree.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/btree.c
@@ -133,7 +133,8 @@ static uint64_t btree_csum_set(struct bt
 	return crc ^ 0xffffffffffffffff;
 }
 
-static void btree_bio_endio(struct bio *bio, int error)
+static void btree_bio_endio(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct btree *b = container_of(cl, struct btree, io.cl);
diff -puN drivers/md/bcache/io.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/io.c
--- a/drivers/md/bcache/io.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/io.c
@@ -9,7 +9,8 @@
 #include "bset.h"
 #include "debug.h"
 
-static void bch_bi_idx_hack_endio(struct bio *bio, int error)
+static void bch_bi_idx_hack_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct bio *p = bio->bi_private;
 
@@ -199,7 +200,8 @@ static void bch_bio_submit_split_done(st
 	mempool_free(s, s->p->bio_split_hook);
 }
 
-static void bch_bio_submit_split_endio(struct bio *bio, int error)
+static void bch_bio_submit_split_endio(struct bio *bio, int error,
+				       struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
diff -puN drivers/md/bcache/journal.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/journal.c
--- a/drivers/md/bcache/journal.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/journal.c
@@ -22,7 +22,8 @@
  * bit.
  */
 
-static void journal_read_endio(struct bio *bio, int error)
+static void journal_read_endio(struct bio *bio, int error,
+			       struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	closure_put(cl);
@@ -390,7 +391,8 @@ found:
 
 #define last_seq(j)	((j)->seq - fifo_used(&(j)->pin) + 1)
 
-static void journal_discard_endio(struct bio *bio, int error)
+static void journal_discard_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct journal_device *ja =
 		container_of(bio, struct journal_device, discard_bio);
@@ -535,7 +537,8 @@ void bch_journal_next(struct journal *j)
 		pr_debug("journal_pin full (%zu)", fifo_used(&j->pin));
 }
 
-static void journal_write_endio(struct bio *bio, int error)
+static void journal_write_endio(struct bio *bio, int error,
+				struct batch_complete *batch)
 {
 	struct journal_write *w = bio->bi_private;
 
diff -puN drivers/md/bcache/movinggc.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/movinggc.c
--- a/drivers/md/bcache/movinggc.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/movinggc.c
@@ -61,7 +61,8 @@ static void write_moving_finish(struct c
 	closure_return_with_destructor(cl, moving_io_destructor);
 }
 
-static void read_moving_endio(struct bio *bio, int error)
+static void read_moving_endio(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	struct moving_io *io = container_of(bio->bi_private,
 					    struct moving_io, s.cl);
diff -puN drivers/md/bcache/request.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/request.c
--- a/drivers/md/bcache/request.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/request.c
@@ -456,7 +456,8 @@ static void bch_insert_data_error(struct
 	bch_journal(cl);
 }
 
-static void bch_insert_data_endio(struct bio *bio, int error)
+static void bch_insert_data_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct btree_op *op = container_of(cl, struct btree_op, cl);
@@ -621,7 +622,8 @@ void bch_btree_insert_async(struct closu
 
 /* Common code for the make_request functions */
 
-static void request_endio(struct bio *bio, int error)
+static void request_endio(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 
@@ -636,7 +638,8 @@ static void request_endio(struct bio *bi
 	closure_put(cl);
 }
 
-void bch_cache_read_endio(struct bio *bio, int error)
+void bch_cache_read_endio(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct bbio *b = container_of(bio, struct bbio, bio);
 	struct closure *cl = bio->bi_private;
diff -puN drivers/md/bcache/request.h~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/request.h
--- a/drivers/md/bcache/request.h~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/request.h
@@ -29,11 +29,10 @@ struct search {
 	struct btree_op		op;
 };
 
-void bch_cache_read_endio(struct bio *, int);
+void bch_cache_read_endio(struct bio *, int, struct batch_complete *batch);
 int bch_get_congested(struct cache_set *);
 void bch_insert_data(struct closure *cl);
 void bch_btree_insert_async(struct closure *);
-void bch_cache_read_endio(struct bio *, int);
 
 void bch_open_buckets_free(struct cache_set *);
 int bch_open_buckets_alloc(struct cache_set *);
diff -puN drivers/md/bcache/super.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/super.c
--- a/drivers/md/bcache/super.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/super.c
@@ -202,7 +202,8 @@ err:
 	return err;
 }
 
-static void write_bdev_super_endio(struct bio *bio, int error)
+static void write_bdev_super_endio(struct bio *bio, int error,
+				   struct batch_complete *batch)
 {
 	struct cached_dev *dc = bio->bi_private;
 	/* XXX: error checking */
@@ -263,7 +264,8 @@ void bch_write_bdev_super(struct cached_
 	closure_return(cl);
 }
 
-static void write_super_endio(struct bio *bio, int error)
+static void write_super_endio(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	struct cache *ca = bio->bi_private;
 
@@ -304,7 +306,7 @@ void bcache_write_super(struct cache_set
 
 /* UUID io */
 
-static void uuid_endio(struct bio *bio, int error)
+static void uuid_endio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct cache_set *c = container_of(cl, struct cache_set, uuid_write.cl);
@@ -468,7 +470,8 @@ static struct uuid_entry *uuid_find_empt
  * disk.
  */
 
-static void prio_endio(struct bio *bio, int error)
+static void prio_endio(struct bio *bio, int error,
+		       struct batch_complete *batch)
 {
 	struct cache *ca = bio->bi_private;
 
diff -puN drivers/md/bcache/writeback.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/writeback.c
--- a/drivers/md/bcache/writeback.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/writeback.c
@@ -253,7 +253,8 @@ static void write_dirty_finish(struct cl
 	closure_return_with_destructor(cl, dirty_io_destructor);
 }
 
-static void dirty_endio(struct bio *bio, int error)
+static void dirty_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	struct keybuf_key *w = bio->bi_private;
 	struct dirty_io *io = w->private;
@@ -281,7 +282,8 @@ static void write_dirty(struct closure *
 	continue_at(cl, write_dirty_finish, dirty_wq);
 }
 
-static void read_dirty_endio(struct bio *bio, int error)
+static void read_dirty_endio(struct bio *bio, int error,
+			     struct batch_complete *batch)
 {
 	struct keybuf_key *w = bio->bi_private;
 	struct dirty_io *io = w->private;
@@ -289,7 +291,7 @@ static void read_dirty_endio(struct bio
 	bch_count_io_errors(PTR_CACHE(io->dc->disk.c, &w->key, 0),
 			    error, "reading dirty data from cache");
 
-	dirty_endio(bio, error);
+	dirty_endio(bio, error, NULL);
 }
 
 static void read_dirty_submit(struct closure *cl)
_

