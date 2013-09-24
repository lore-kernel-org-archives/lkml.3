Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab3IXGTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:19:03 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46075 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3IXGS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:18:59 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>,
        stable@vger.kernel.org
Subject: [PATCH 06/11] bcache: Fix a writeback performance regression
Date: Mon, 23 Sep 2013 23:17:31 -0700
Message-Id: <1380003456-19938-7-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Background writeback works by scanning the btree for dirty data and
adding those keys into a fixed size buffer, then for each dirty key in
the keybuf writing it to the backing device.

When read_dirty() finishes and it's time to scan for more dirty data, we
need to wait for the outstanding writeback IO to finish - they still
take up slots in the keybuf (so that foreground writes can check for
them to avoid races) - without that wait, we'll continually rescan when
we'll be able to add at most a key or two to the keybuf, and that takes
locks that starves foreground IO. Doh.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/bcache.h    |  7 +++----
 drivers/md/bcache/util.c      | 11 ++++++++++-
 drivers/md/bcache/util.h      | 12 +++++++++---
 drivers/md/bcache/writeback.c | 43 +++++++++++++++++++++----------------------
 4 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index b39f6f0..0f12382 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -498,7 +498,7 @@ struct cached_dev {
 	 */
 	atomic_t		has_dirty;
 
-	struct ratelimit	writeback_rate;
+	struct bch_ratelimit	writeback_rate;
 	struct delayed_work	writeback_rate_update;
 
 	/*
@@ -507,10 +507,9 @@ struct cached_dev {
 	 */
 	sector_t		last_read;
 
-	/* Number of writeback bios in flight */
-	atomic_t		in_flight;
+	/* Limit number of writeback bios in flight */
+	struct semaphore	in_flight;
 	struct closure_with_timer writeback;
-	struct closure_waitlist	writeback_wait;
 
 	struct keybuf		writeback_keys;
 
diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index 98eb811..420dad5 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -190,7 +190,16 @@ void bch_time_stats_update(struct time_stats *stats, uint64_t start_time)
 	stats->last = now ?: 1;
 }
 
-unsigned bch_next_delay(struct ratelimit *d, uint64_t done)
+/**
+ * bch_next_delay() - increment @d by the amount of work done, and return how
+ * long to delay until the next time to do some work.
+ *
+ * @d - the struct bch_ratelimit to update
+ * @done - the amount of work done, in arbitrary units
+ *
+ * Returns the amount of time to delay by, in jiffies
+ */
+uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done)
 {
 	uint64_t now = local_clock();
 
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index 1ae2a73..ea345c6 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -450,17 +450,23 @@ read_attribute(name ## _last_ ## frequency_units)
 	(ewma) >> factor;						\
 })
 
-struct ratelimit {
+struct bch_ratelimit {
+	/* Next time we want to do some work, in nanoseconds */
 	uint64_t		next;
+
+	/*
+	 * Rate at which we want to do work, in units per nanosecond
+	 * The units here correspond to the units passed to bch_next_delay()
+	 */
 	unsigned		rate;
 };
 
-static inline void ratelimit_reset(struct ratelimit *d)
+static inline void bch_ratelimit_reset(struct bch_ratelimit *d)
 {
 	d->next = local_clock();
 }
 
-unsigned bch_next_delay(struct ratelimit *d, uint64_t done);
+uint64_t bch_next_delay(struct bch_ratelimit *d, uint64_t done);
 
 #define __DIV_SAFE(n, d, zero)						\
 ({									\
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 22cbff5..27ac519 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -94,11 +94,15 @@ static void update_writeback_rate(struct work_struct *work)
 
 static unsigned writeback_delay(struct cached_dev *dc, unsigned sectors)
 {
+	uint64_t ret;
+
 	if (atomic_read(&dc->disk.detaching) ||
 	    !dc->writeback_percent)
 		return 0;
 
-	return bch_next_delay(&dc->writeback_rate, sectors * 10000000ULL);
+	ret = bch_next_delay(&dc->writeback_rate, sectors * 10000000ULL);
+
+	return min_t(uint64_t, ret, HZ);
 }
 
 /* Background writeback */
@@ -208,7 +212,7 @@ normal_refill:
 
 	up_write(&dc->writeback_lock);
 
-	ratelimit_reset(&dc->writeback_rate);
+	bch_ratelimit_reset(&dc->writeback_rate);
 
 	/* Punt to workqueue only so we don't recurse and blow the stack */
 	continue_at(cl, read_dirty, dirty_wq);
@@ -318,9 +322,7 @@ static void write_dirty_finish(struct closure *cl)
 	}
 
 	bch_keybuf_del(&dc->writeback_keys, w);
-	atomic_dec_bug(&dc->in_flight);
-
-	closure_wake_up(&dc->writeback_wait);
+	up(&dc->in_flight);
 
 	closure_return_with_destructor(cl, dirty_io_destructor);
 }
@@ -349,7 +351,7 @@ static void write_dirty(struct closure *cl)
 
 	closure_bio_submit(&io->bio, cl, &io->dc->disk);
 
-	continue_at(cl, write_dirty_finish, dirty_wq);
+	continue_at(cl, write_dirty_finish, system_wq);
 }
 
 static void read_dirty_endio(struct bio *bio, int error)
@@ -369,7 +371,7 @@ static void read_dirty_submit(struct closure *cl)
 
 	closure_bio_submit(&io->bio, cl, &io->dc->disk);
 
-	continue_at(cl, write_dirty, dirty_wq);
+	continue_at(cl, write_dirty, system_wq);
 }
 
 static void read_dirty(struct closure *cl)
@@ -394,12 +396,9 @@ static void read_dirty(struct closure *cl)
 
 		if (delay > 0 &&
 		    (KEY_START(&w->key) != dc->last_read ||
-		     jiffies_to_msecs(delay) > 50)) {
-			w->private = NULL;
-
-			closure_delay(&dc->writeback, delay);
-			continue_at(cl, read_dirty, dirty_wq);
-		}
+		     jiffies_to_msecs(delay) > 50))
+			while (delay)
+				delay = schedule_timeout(delay);
 
 		dc->last_read	= KEY_OFFSET(&w->key);
 
@@ -424,15 +423,10 @@ static void read_dirty(struct closure *cl)
 
 		trace_bcache_writeback(&w->key);
 
-		closure_call(&io->cl, read_dirty_submit, NULL, &dc->disk.cl);
+		down(&dc->in_flight);
+		closure_call(&io->cl, read_dirty_submit, NULL, cl);
 
 		delay = writeback_delay(dc, KEY_SIZE(&w->key));
-
-		atomic_inc(&dc->in_flight);
-
-		if (!closure_wait_event(&dc->writeback_wait, cl,
-					atomic_read(&dc->in_flight) < 64))
-			continue_at(cl, read_dirty, dirty_wq);
 	}
 
 	if (0) {
@@ -442,7 +436,11 @@ err:
 		bch_keybuf_del(&dc->writeback_keys, w);
 	}
 
-	refill_dirty(cl);
+	/*
+	 * Wait for outstanding writeback IOs to finish (and keybuf slots to be
+	 * freed) before refilling again
+	 */
+	continue_at(cl, refill_dirty, dirty_wq);
 }
 
 /* Init */
@@ -484,6 +482,7 @@ void bch_sectors_dirty_init(struct cached_dev *dc)
 
 void bch_cached_dev_writeback_init(struct cached_dev *dc)
 {
+	sema_init(&dc->in_flight, 64);
 	closure_init_unlocked(&dc->writeback);
 	init_rwsem(&dc->writeback_lock);
 
@@ -513,7 +512,7 @@ void bch_writeback_exit(void)
 
 int __init bch_writeback_init(void)
 {
-	dirty_wq = create_singlethread_workqueue("bcache_writeback");
+	dirty_wq = create_workqueue("bcache_writeback");
 	if (!dirty_wq)
 		return -ENOMEM;
 
-- 
1.8.4.rc3

