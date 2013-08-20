Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3HTPQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:16:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24856 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3HTPQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:16:05 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=mVp6cRoBB8kA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jyE7P5GObSEA:10 a=-n4FZ2bsAJO2NpbtDhMA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 20 Aug 2013 11:16:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Kent Overstreet <kmo@daterainc.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] bcache: Remove use of down/up_read_non_owner()
Message-ID: <20130820111602.3cea203c@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The down/up_read_non_owner() is a nasty hack in the API of the rwsem
operations. It was once removed, but then resurrected for use with
bcache. Not only is the API an abomination to the rwsem API, it also
prevents bcache from ever being compiled with PREEMPT_RT, as the RT
kernel requires all rwsems to have an owner.

Instead of keeping the down/up_read_non_owner() around, it is better to
modify the one user of it and have it do something a bit differently.

>From reading the bcache code, the reason for the non_owner usage is
that a request is made, and writers must wait for that request to
finish before they can continue. But because the request is completed
by another task, the rwsem can not be held for read and then released
on completion.

Instead of abusing the rwsem code for this, I added a refcount
"nr_requests" to the cached_dev structure as well as a "write_waiters"
wait queue. When a request is to be made, the rwsem is still taken for
read, but this time with an owner. The refcount is incremented and
before exiting the function, the rwsem is released.

The writer will then take the rwsem for write, check the refcount, if
it is not zero, it will release the rwsem, add itself to a wait_event()
waiting for refcount to become zero, and then try again.

This should be a suitable replacement for the abuse of the rwsem
non_owner API.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Index: linux-trace.git/drivers/md/bcache/bcache.h
===================================================================
--- linux-trace.git.orig/drivers/md/bcache/bcache.h
+++ linux-trace.git/drivers/md/bcache/bcache.h
@@ -486,6 +486,15 @@ struct cached_dev {
 	atomic_t		running;
 
 	/*
+	 * Requests in progress.
+	 */
+	atomic_t		nr_requests;
+	/*
+	 * Writers waiting for requests to finish.
+	 */
+	wait_queue_head_t	write_waiters;
+
+	/*
 	 * Writes take a shared lock from start to finish; scanning for dirty
 	 * data to refill the rb tree requires an exclusive lock.
 	 */
Index: linux-trace.git/drivers/md/bcache/request.c
===================================================================
--- linux-trace.git.orig/drivers/md/bcache/request.c
+++ linux-trace.git/drivers/md/bcache/request.c
@@ -998,7 +998,9 @@ static void cached_dev_write_complete(st
 	struct search *s = container_of(cl, struct search, cl);
 	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
-	up_read_non_owner(&dc->writeback_lock);
+	if (atomic_dec_return(&dc->nr_requests) == 0)
+		wake_up(&dc->write_waiters);
+	
 	cached_dev_bio_complete(cl);
 }
 
@@ -1024,7 +1026,8 @@ static void request_write(struct cached_
 	bch_keybuf_check_overlapping(&s->op.c->moving_gc_keys, &start, &end);
 
 	check_should_skip(dc, s);
-	down_read_non_owner(&dc->writeback_lock);
+	down_read(&dc->writeback_lock);
+	atomic_inc(&dc->nr_requests);
 
 	if (bch_keybuf_check_overlapping(&dc->writeback_keys, &start, &end)) {
 		s->op.skip	= false;
@@ -1053,6 +1056,7 @@ static void request_write(struct cached_
 	}
 out:
 	closure_call(&s->op.cl, bch_insert_data, NULL, cl);
+	up_read(&dc->writeback_lock);
 	continue_at(cl, cached_dev_write_complete, NULL);
 skip:
 	s->op.skip = true;
Index: linux-trace.git/drivers/md/bcache/super.c
===================================================================
--- linux-trace.git.orig/drivers/md/bcache/super.c
+++ linux-trace.git/drivers/md/bcache/super.c
@@ -1081,6 +1081,8 @@ static void register_bdev(struct cache_s
 	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;
 	get_page(sb_page);
 
+	init_waitqueue_head(&dc->write_waiters);
+
 	if (cached_dev_init(dc, sb->block_size << 9))
 		goto err;
 
Index: linux-trace.git/drivers/md/bcache/writeback.c
===================================================================
--- linux-trace.git.orig/drivers/md/bcache/writeback.c
+++ linux-trace.git/drivers/md/bcache/writeback.c
@@ -121,6 +121,20 @@ static void dirty_init(struct keybuf_key
 	bch_bio_map(bio, NULL);
 }
 
+/*
+ * If requests are in transit, we must wait for them to finish.
+ */
+static void down_writeback_lock(struct cached_dev *dc)
+{
+again:
+	down_write(&dc->writeback_lock);
+	if (atomic_read(&dc->nr_requests)) {
+		up_write(&dc->writeback_lock);
+		wait_event(dc->write_waiters, !atomic_read(&dc->nr_requests));
+		goto again;
+	}
+}
+
 static void refill_dirty(struct closure *cl)
 {
 	struct cached_dev *dc = container_of(cl, struct cached_dev,
@@ -134,7 +148,7 @@ static void refill_dirty(struct closure
 	    !dc->writeback_running)
 		closure_return(cl);
 
-	down_write(&dc->writeback_lock);
+	down_writeback_lock(dc);
 
 	if (!atomic_read(&dc->has_dirty)) {
 		SET_BDEV_STATE(&dc->sb, BDEV_STATE_CLEAN);
