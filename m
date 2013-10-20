Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab3JTWtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 18:49:13 -0400
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:60142 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751816Ab3JTWtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 18:49:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:4:41:69:355:379:541:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2196:2198:2199:2200:2393:2538:2559:2562:2693:2731:2828:2902:3138:3139:3140:3141:3142:3865:3866:3867:3870:3874:4321:4385:4605:5007:6119:6299:7652:7808:7875:7903:7904:8603:9010:9040:9592:10004:10394:10848:11026:11473:11657:11658:11914:12043:12291:12294:12296:12438:12517:12519:12555:12679:12683:13255:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: river26_32b2612c26434
X-Filterd-Recvd-Size: 18590
Message-ID: <1382309346.2041.61.camel@joe-AO722>
Subject: [PATCH next] md: bcache: Add missing newlines to logging messages,
 & misc neatening
From: Joe Perches <joe@perches.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 20 Oct 2013 15:49:06 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logging messages require terminating newlines to avoid possible
interleaving by other messages.  Add them.

Convert bch_cache_set_error printk/vprintk/printk sequence
to use vsprintf extension %pV to eliminate any possible
interleaving.

Convert some variadic macro uses of ... to fmt, ... to
make clear the message use of the macro.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/md/bcache/bcache.h   | 20 ++++++-------
 drivers/md/bcache/bset.c     |  5 ++--
 drivers/md/bcache/btree.c    |  8 ++---
 drivers/md/bcache/io.c       |  2 +-
 drivers/md/bcache/journal.c  | 14 ++++-----
 drivers/md/bcache/movinggc.c |  2 +-
 drivers/md/bcache/request.c  |  4 +--
 drivers/md/bcache/super.c    | 71 +++++++++++++++++++++++---------------------
 drivers/md/bcache/sysfs.c    |  2 +-
 9 files changed, 66 insertions(+), 62 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 4beb55a..c10cfaa 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -801,34 +801,34 @@ static inline void bkey_init(struct bkey *k)
 
 /* Error handling macros */
 
-#define btree_bug(b, ...)						\
+#define btree_bug(b, fmt, ...)						\
 do {									\
-	if (bch_cache_set_error((b)->c, __VA_ARGS__))			\
+	if (bch_cache_set_error((b)->c, fmt, ##__VA_ARGS__))		\
 		dump_stack();						\
 } while (0)
 
-#define cache_bug(c, ...)						\
+#define cache_bug(c, fmt, ...)						\
 do {									\
-	if (bch_cache_set_error(c, __VA_ARGS__))			\
+	if (bch_cache_set_error(c, fmt, ##__VA_ARGS__))			\
 		dump_stack();						\
 } while (0)
 
-#define btree_bug_on(cond, b, ...)					\
+#define btree_bug_on(cond, b, fmt, ...)					\
 do {									\
 	if (cond)							\
-		btree_bug(b, __VA_ARGS__);				\
+		btree_bug(b, fmt, ##__VA_ARGS__);			\
 } while (0)
 
-#define cache_bug_on(cond, c, ...)					\
+#define cache_bug_on(cond, c, fmt, ...)					\
 do {									\
 	if (cond)							\
-		cache_bug(c, __VA_ARGS__);				\
+		cache_bug(c, fmt, ##__VA_ARGS__);			\
 } while (0)
 
-#define cache_set_err_on(cond, c, ...)					\
+#define cache_set_err_on(cond, c, fmt, ...)				\
 do {									\
 	if (cond)							\
-		bch_cache_set_error(c, __VA_ARGS__);			\
+		bch_cache_set_error(c, fmt, ##__VA_ARGS__);		\
 } while (0)
 
 /* Looping macros */
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 7d388b8..7c6a681 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -401,8 +401,9 @@ void inorder_test(void)
 		unsigned i = 1, j = rounddown_pow_of_two(size - 1);
 
 		if (!(size % 4096))
-			printk(KERN_NOTICE "loop %u, %llu per us\n", size,
-			       done / ktime_us_delta(ktime_get(), start));
+			pr_notice("loop %u, %llu per us\n",
+				  size,
+				  done / ktime_us_delta(ktime_get(), start));
 
 		while (1) {
 			if (__inorder_to_tree(i, size, extra) != j)
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 1ccb702..ca132e5 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1612,7 +1612,7 @@ static void bch_btree_gc(struct cache_set *c)
 		closure_sync(&writes);
 
 		if (ret && ret != -EAGAIN)
-			pr_warn("gc failed!");
+			pr_warn("gc failed!\n");
 	} while (ret);
 
 	available = bch_btree_gc_finish(c);
@@ -2134,7 +2134,7 @@ err:
 	    n1 == ERR_PTR(-EAGAIN))
 		return -EAGAIN;
 
-	pr_warn("couldn't split");
+	pr_warn("couldn't split\n");
 	return -ENOMEM;
 }
 
@@ -2251,7 +2251,7 @@ int bch_btree_insert(struct cache_set *c, struct keylist *keys,
 	if (ret) {
 		struct bkey *k;
 
-		pr_err("error %i", ret);
+		pr_err("error %i\n", ret);
 
 		while ((k = bch_keylist_pop(keys)))
 			bkey_put(c, k);
@@ -2535,7 +2535,7 @@ struct keybuf_key *bch_keybuf_next_rescan(struct cache_set *c,
 			break;
 
 		if (bkey_cmp(&buf->last_scanned, end) >= 0) {
-			pr_debug("scan finished");
+			pr_debug("scan finished\n");
 			break;
 		}
 
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index 9056632..2e5b388 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -332,7 +332,7 @@ void bch_count_io_errors(struct cache *ca, int error, const char *m)
 		errors >>= IO_ERROR_SHIFT;
 
 		if (errors < ca->set->error_limit)
-			pr_err("%s: IO error on %s, recovering",
+			pr_err("%s: IO error on %s, recovering\n",
 			       bdevname(ca->bdev, buf), m);
 		else
 			bch_cache_set_error(ca->set,
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 41d0b6a..9f7614f 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -44,7 +44,7 @@ static int journal_read_bucket(struct cache *ca, struct list_head *list,
 
 	closure_init_stack(&cl);
 
-	pr_debug("reading %llu", (uint64_t) bucket);
+	pr_debug("reading %llu\n", (uint64_t) bucket);
 
 	while (offset < ca->sb.bucket_size) {
 reread:		left = ca->sb.bucket_size - offset;
@@ -152,7 +152,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 		uint64_t seq;
 
 		bitmap_zero(bitmap, SB_JOURNAL_BUCKETS);
-		pr_debug("%u journal buckets", ca->sb.njournal_buckets);
+		pr_debug("%u journal buckets\n", ca->sb.njournal_buckets);
 
 		/*
 		 * Read journal buckets ordered by golden ratio hash to quickly
@@ -172,7 +172,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 		 * If that fails, check all the buckets we haven't checked
 		 * already
 		 */
-		pr_debug("falling back to linear search");
+		pr_debug("falling back to linear search\n");
 
 		for (l = find_first_zero_bit(bitmap, ca->sb.njournal_buckets);
 		     l < ca->sb.njournal_buckets;
@@ -185,7 +185,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 bsearch:
 		/* Binary search */
 		m = r = find_next_bit(bitmap, ca->sb.njournal_buckets, l + 1);
-		pr_debug("starting binary search, l %u r %u", l, r);
+		pr_debug("starting binary search, l %u r %u\n", l, r);
 
 		while (l + 1 < r) {
 			seq = list_entry(list->prev, struct journal_replay,
@@ -205,7 +205,7 @@ bsearch:
 		 * Read buckets in reverse order until we stop finding more
 		 * journal entries
 		 */
-		pr_debug("finishing up: m %u njournal_buckets %u",
+		pr_debug("finishing up: m %u njournal_buckets %u\n",
 			 m, ca->sb.njournal_buckets);
 		l = m;
 
@@ -336,7 +336,7 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 		entries++;
 	}
 
-	pr_info("journal replay done, %i keys in %i entries, seq %llu",
+	pr_info("journal replay done, %i keys in %i entries, seq %llu\n",
 		keys, entries, end);
 err:
 	while (!list_empty(list)) {
@@ -531,7 +531,7 @@ void bch_journal_next(struct journal *j)
 	j->cur->data->keys	= 0;
 
 	if (fifo_full(&j->pin))
-		pr_debug("journal_pin full (%zu)", fifo_used(&j->pin));
+		pr_debug("journal_pin full (%zu)\n", fifo_used(&j->pin));
 }
 
 static void journal_write_endio(struct bio *bio, int error)
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index db72d65..fb8ca5f 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -228,7 +228,7 @@ void bch_moving_gc(struct cache_set *c)
 
 		ca->gc_move_threshold = bucket_heap_top(ca);
 
-		pr_debug("threshold %u", ca->gc_move_threshold);
+		pr_debug("threshold %u\n", ca->gc_move_threshold);
 	}
 
 	mutex_unlock(&c->bucket_lock);
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 49ee1cf..0c24b9d 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -260,7 +260,7 @@ static void bch_data_invalidate(struct closure *cl)
 	struct data_insert_op *op = container_of(cl, struct data_insert_op, cl);
 	struct bio *bio = op->bio;
 
-	pr_debug("invalidating %i sectors from %llu",
+	pr_debug("invalidating %i sectors from %llu\n",
 		 bio_sectors(bio), (uint64_t) bio->bi_sector);
 
 	while (bio_sectors(bio)) {
@@ -524,7 +524,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 
 	if (bio->bi_sector & (c->sb.block_size - 1) ||
 	    bio_sectors(bio) & (c->sb.block_size - 1)) {
-		pr_debug("skipping unaligned io");
+		pr_debug("skipping unaligned io\n");
 		goto skip;
 	}
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index dec15cd..2f5a5ad 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -113,7 +113,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 	for (i = 0; i < SB_JOURNAL_BUCKETS; i++)
 		sb->d[i] = le64_to_cpu(s->d[i]);
 
-	pr_debug("read sb version %llu, flags %llu, seq %llu, journal size %u",
+	pr_debug("read sb version %llu, flags %llu, seq %llu, journal size %u\n",
 		 sb->version, sb->flags, sb->seq, sb->keys);
 
 	err = "Not a bcache superblock";
@@ -257,7 +257,7 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 
 	out->csum = csum_set(out);
 
-	pr_debug("ver %llu, flags %llu, seq %llu",
+	pr_debug("ver %llu, flags %llu, seq %llu\n",
 		 sb->version, sb->flags, sb->seq);
 
 	submit_bio(REQ_WRITE, bio);
@@ -360,11 +360,11 @@ static void uuid_io(struct cache_set *c, unsigned long rw,
 	}
 
 	bch_bkey_to_text(buf, sizeof(buf), k);
-	pr_debug("%s UUIDs at %s", rw & REQ_WRITE ? "wrote" : "read", buf);
+	pr_debug("%s UUIDs at %s\n", rw & REQ_WRITE ? "wrote" : "read", buf);
 
 	for (u = c->uuids; u < c->uuids + c->nr_uuids; u++)
 		if (!bch_is_zero(u->uuid, 16))
-			pr_debug("Slot %zi: %pU: %s: 1st: %u last: %u inv: %u",
+			pr_debug("Slot %zi: %pU: %s: 1st: %u last: %u inv: %u\n",
 				 u - c->uuids, u->uuid, u->label,
 				 u->first_reg, u->last_reg, u->invalidated);
 
@@ -538,7 +538,7 @@ void bch_prio_write(struct cache *ca)
 	atomic_long_add(ca->sb.bucket_size * prio_buckets(ca),
 			&ca->meta_sectors_written);
 
-	pr_debug("free %zu, free_inc %zu, unused %zu", fifo_used(&ca->free),
+	pr_debug("free %zu, free_inc %zu, unused %zu\n", fifo_used(&ca->free),
 		 fifo_used(&ca->free_inc), fifo_used(&ca->unused));
 
 	for (i = prio_buckets(ca) - 1; i >= 0; --i) {
@@ -604,10 +604,10 @@ static void prio_read(struct cache *ca, uint64_t bucket)
 			prio_io(ca, bucket, READ_SYNC);
 
 			if (p->csum != bch_crc64(&p->magic, bucket_bytes(ca) - 8))
-				pr_warn("bad csum reading priorities");
+				pr_warn("bad csum reading priorities\n");
 
 			if (p->magic != pset_magic(&ca->sb))
-				pr_warn("bad magic reading priorities");
+				pr_warn("bad magic reading priorities\n");
 
 			bucket = p->next_bucket;
 			d = p->data;
@@ -725,7 +725,7 @@ static void bcache_device_free(struct bcache_device *d)
 {
 	lockdep_assert_held(&bch_register_lock);
 
-	pr_info("%s stopped", d->disk->disk_name);
+	pr_info("%s stopped\n", d->disk->disk_name);
 
 	if (d->c)
 		bcache_device_detach(d);
@@ -884,7 +884,7 @@ void bch_cached_dev_run(struct cached_dev *dc)
 
 	if (sysfs_create_link(&d->kobj, &disk_to_dev(d->disk)->kobj, "dev") ||
 	    sysfs_create_link(&disk_to_dev(d->disk)->kobj, &d->kobj, "bcache"))
-		pr_debug("error creating sysfs link");
+		pr_debug("error creating sysfs link\n");
 }
 
 static void cached_dev_detach_finish(struct work_struct *w)
@@ -912,7 +912,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 
 	mutex_unlock(&bch_register_lock);
 
-	pr_info("Caching disabled for %s", bdevname(dc->bdev, buf));
+	pr_info("Caching disabled for %s\n", bdevname(dc->bdev, buf));
 
 	/* Drop ref we took in cached_dev_detach() */
 	closure_put(&dc->disk.cl);
@@ -950,18 +950,18 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 		return -ENOENT;
 
 	if (dc->disk.c) {
-		pr_err("Can't attach %s: already attached", buf);
+		pr_err("Can't attach %s: already attached\n", buf);
 		return -EINVAL;
 	}
 
 	if (test_bit(CACHE_SET_STOPPING, &c->flags)) {
-		pr_err("Can't attach %s: shutting down", buf);
+		pr_err("Can't attach %s: shutting down\n", buf);
 		return -EINVAL;
 	}
 
 	if (dc->sb.block_size < c->sb.block_size) {
 		/* Will die */
-		pr_err("Couldn't attach %s: block size less than set's block size",
+		pr_err("Couldn't attach %s: block size less than set's block size\n",
 		       buf);
 		return -EINVAL;
 	}
@@ -978,13 +978,13 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 
 	if (!u) {
 		if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
-			pr_err("Couldn't find uuid for %s in set", buf);
+			pr_err("Couldn't find uuid for %s in set\n", buf);
 			return -ENOENT;
 		}
 
 		u = uuid_find_empty(c);
 		if (!u) {
-			pr_err("Not caching %s, no room for UUID", buf);
+			pr_err("Not caching %s, no room for UUID\n", buf);
 			return -EINVAL;
 		}
 	}
@@ -1033,7 +1033,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	bch_cached_dev_run(dc);
 	bcache_device_link(&dc->disk, c, "bdev");
 
-	pr_info("Caching %s as %s on set %pU",
+	pr_info("Caching %s as %s on set %pU\n",
 		bdevname(dc->bdev, buf), dc->disk.disk->disk_name,
 		dc->disk.c->sb.set_uuid);
 	return 0;
@@ -1161,7 +1161,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	if (bch_cache_accounting_add_kobjs(&dc->accounting, &dc->disk.kobj))
 		goto err;
 
-	pr_info("registered backing device %s", bdevname(bdev, name));
+	pr_info("registered backing device %s\n", bdevname(bdev, name));
 
 	list_add(&dc->list, &uncached_devices);
 	list_for_each_entry(c, &bch_cache_sets, list)
@@ -1173,7 +1173,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 
 	return;
 err:
-	pr_notice("error opening %s: %s", bdevname(bdev, name), err);
+	pr_notice("error opening %s: %s\n", bdevname(bdev, name), err);
 	bcache_device_stop(&dc->disk);
 }
 
@@ -1255,7 +1255,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 
 	u = uuid_find_empty(c);
 	if (!u) {
-		pr_err("Can't create volume, no room for UUID");
+		pr_err("Can't create volume, no room for UUID\n");
 		return -EINVAL;
 	}
 
@@ -1276,6 +1276,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 __printf(2, 3)
 bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	if (c->on_error != ON_ERROR_PANIC &&
@@ -1286,13 +1287,15 @@ bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...)
 	acquire_console_sem();
 	*/
 
-	printk(KERN_ERR "bcache: error on %pU: ", c->sb.set_uuid);
-
 	va_start(args, fmt);
-	vprintk(fmt, args);
-	va_end(args);
 
-	printk(", disabling caching\n");
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_ERR "bcache: error on %pU: %pV, disabling caching\n",
+	       c->sb.set_uuid, &vaf);
+
+	va_end(args);
 
 	if (c->on_error == ON_ERROR_PANIC)
 		panic("panic forced after error\n");
@@ -1342,7 +1345,7 @@ static void cache_set_free(struct closure *cl)
 	list_del(&c->list);
 	mutex_unlock(&bch_register_lock);
 
-	pr_info("Cache set %pU unregistered", c->sb.set_uuid);
+	pr_info("Cache set %pU unregistered\n", c->sb.set_uuid);
 	wake_up(&unregister_wait);
 
 	closure_debug_destroy(&c->cl);
@@ -1532,7 +1535,7 @@ static void run_cache_set(struct cache_set *c)
 		if (bch_journal_read(c, &journal))
 			goto err;
 
-		pr_debug("btree_journal_read() done");
+		pr_debug("btree_journal_read() done\n");
 
 		err = "no journal entries found";
 		if (list_empty(&journal))
@@ -1574,7 +1577,7 @@ static void run_cache_set(struct cache_set *c)
 
 		bch_journal_mark(c, &journal);
 		bch_btree_gc_finish(c);
-		pr_debug("btree_check() done");
+		pr_debug("btree_check() done\n");
 
 		/*
 		 * bcache_journal_next() can't happen sooner, or
@@ -1603,7 +1606,7 @@ static void run_cache_set(struct cache_set *c)
 
 		bch_journal_replay(c, &journal);
 	} else {
-		pr_notice("invalidating existing data");
+		pr_notice("invalidating existing data\n");
 
 		for_each_cache(ca, c, i) {
 			unsigned j;
@@ -1726,7 +1729,7 @@ found:
 		memcpy(c->sb.set_uuid, ca->sb.set_uuid, 16);
 		c->sb.flags             = ca->sb.flags;
 		c->sb.seq		= ca->sb.seq;
-		pr_debug("set version = %llu", c->sb.version);
+		pr_debug("set version = %llu\n", c->sb.version);
 	}
 
 	ca->set = c;
@@ -1845,10 +1848,10 @@ static void register_cache(struct cache_sb *sb, struct page *sb_page,
 	if (err)
 		goto err;
 
-	pr_info("registered cache device %s", bdevname(bdev, name));
+	pr_info("registered cache device %s\n", bdevname(bdev, name));
 	return;
 err:
-	pr_notice("error opening %s: %s", bdevname(bdev, name), err);
+	pr_notice("error opening %s: %s\n", bdevname(bdev, name), err);
 	kobject_put(&ca->kobj);
 }
 
@@ -1958,7 +1961,7 @@ err_close:
 	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 err:
 	if (attr != &ksysfs_register_quiet)
-		pr_info("error opening %s: %s", path, err);
+		pr_info("error opening %s: %s\n", path, err);
 	ret = -EINVAL;
 	goto out;
 }
@@ -2010,9 +2013,9 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		finish_wait(&unregister_wait, &wait);
 
 		if (stopped)
-			pr_info("All devices stopped");
+			pr_info("All devices stopped\n");
 		else
-			pr_notice("Timeout waiting for devices to be closed");
+			pr_notice("Timeout waiting for devices to be closed\n");
 out:
 		mutex_unlock(&bch_register_lock);
 	}
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 80d4c2b..c2fa7a8 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -265,7 +265,7 @@ STORE(__cached_dev)
 				return size;
 		}
 
-		pr_err("Can't attach %s: cache set not found", buf);
+		pr_err("Can't attach %s: cache set not found\n", buf);
 		size = v;
 	}
 


