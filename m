Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaF0PLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:11:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaF0PLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:11:21 -0400
Date: Fri, 27 Jun 2014 16:11:06 +0100
From: Joe Thornber <thornber@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com, snitzer@redhat.com, neilb@suse.de,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minfei Huang <huangminfei@ucloud.cn>
Subject: Re: [dm-devel] [PATCH] dm-io: Prevent the danging point of the sync
 io callback function
Message-ID: <20140627151105.GA30592@debian>
Mail-Followup-To: device-mapper development <dm-devel@redhat.com>,
	agk@redhat.com, snitzer@redhat.com, neilb@suse.de,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	Minfei Huang <huangminfei@ucloud.cn>
References: <1403841690-4401-1-git-send-email-huangminfei@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403841690-4401-1-git-send-email-huangminfei@ucloud.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 12:01:30PM +0800, Minfei Huang wrote:
> The io address in callback function will become the danging point,
> cause by the thread of sync io wakes up by other threads
> and return to relieve the io address,

Yes, well found.  I prefer the following fix however.

- Joe



Author: Joe Thornber <ejt@redhat.com>
Date:   Fri Jun 27 15:49:29 2014 +0100

    [dm-io] Fix a race condition in the wake up code for sync_io
    
    There's a race condition between the atomic_dec_and_test(&io->count)
    in dec_count() and the waking of the sync_io() thread.  If the thread
    is spuriously woken immediately after the decrement it may exit,
    making the on the stack io struct invalid, yet the dec_count could
    still be using it.
    
    There are smaller fixes than the one here (eg, just take the io object
    off the stack).  But I feel this code could use a clean up.
    
    - simplify dec_count().
    
      - It always calls a callback fn now.
      - It always frees the io object back to the pool.
    
    - sync_io()
    
      - Take the io object off the stack and allocate it from the pool the
        same as async_io.
      - Use a completion object rather than an explicit io_schedule()
        loop.  The callback triggers the completion.
    
    Reported by: Minfei Huang

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 3842ac7..a0982e81 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -10,6 +10,7 @@
 #include <linux/device-mapper.h>
 
 #include <linux/bio.h>
+#include <linux/completion.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -32,7 +33,6 @@ struct dm_io_client {
 struct io {
 	unsigned long error_bits;
 	atomic_t count;
-	struct task_struct *sleeper;
 	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
@@ -111,28 +111,27 @@ static void retrieve_io_and_region_from_bio(struct bio *bio, struct io **io,
  * We need an io object to keep track of the number of bios that
  * have been dispatched for a particular io.
  *---------------------------------------------------------------*/
-static void dec_count(struct io *io, unsigned int region, int error)
+static void complete_io(struct io *io)
 {
-	if (error)
-		set_bit(region, &io->error_bits);
+	unsigned long error_bits = io->error_bits;
+	io_notify_fn fn = io->callback;
+	void *context = io->context;
 
-	if (atomic_dec_and_test(&io->count)) {
-		if (io->vma_invalidate_size)
-			invalidate_kernel_vmap_range(io->vma_invalidate_address,
-						     io->vma_invalidate_size);
+	if (io->vma_invalidate_size)
+		invalidate_kernel_vmap_range(io->vma_invalidate_address,
+					     io->vma_invalidate_size);
 
-		if (io->sleeper)
-			wake_up_process(io->sleeper);
+	mempool_free(io, io->client->pool);
+	fn(error_bits, context);
+}
 
-		else {
-			unsigned long r = io->error_bits;
-			io_notify_fn fn = io->callback;
-			void *context = io->context;
+static void dec_count(struct io *io, unsigned int region, int error)
+{
+	if (error)
+		set_bit(region, &io->error_bits);
 
-			mempool_free(io, io->client->pool);
-			fn(r, context);
-		}
-	}
+	if (atomic_dec_and_test(&io->count))
+		complete_io(io);
 }
 
 static void endio(struct bio *bio, int error)
@@ -375,48 +374,49 @@ static void dispatch_io(int rw, unsigned int num_regions,
 	dec_count(io, 0, 0);
 }
 
+struct sync_io {
+	unsigned long error_bits;
+	struct completion complete;
+};
+
+static void sync_complete(unsigned long error, void *context)
+{
+	struct sync_io *sio = context;
+	sio->error_bits = error;
+	complete(&sio->complete);
+}
+
 static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 		   struct dm_io_region *where, int rw, struct dpages *dp,
 		   unsigned long *error_bits)
 {
-	/*
-	 * gcc <= 4.3 can't do the alignment for stack variables, so we must
-	 * align it on our own.
-	 * volatile prevents the optimizer from removing or reusing
-	 * "io_" field from the stack frame (allowed in ANSI C).
-	 */
-	volatile char io_[sizeof(struct io) + __alignof__(struct io) - 1];
-	struct io *io = (struct io *)PTR_ALIGN(&io_, __alignof__(struct io));
+	struct io *io;
+	struct sync_io sio;
 
 	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
 		WARN_ON(1);
 		return -EIO;
 	}
 
+	init_completion(&sio.complete);
+
+	io = mempool_alloc(client->pool, GFP_NOIO);
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
-	io->sleeper = current;
+	io->callback = sync_complete;
+	io->context = &sio;
 	io->client = client;
 
 	io->vma_invalidate_address = dp->vma_invalidate_address;
 	io->vma_invalidate_size = dp->vma_invalidate_size;
 
 	dispatch_io(rw, num_regions, where, dp, io, 1);
-
-	while (1) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-
-		if (!atomic_read(&io->count))
-			break;
-
-		io_schedule();
-	}
-	set_current_state(TASK_RUNNING);
+	wait_for_completion_io(&sio.complete);
 
 	if (error_bits)
-		*error_bits = io->error_bits;
+		*error_bits = sio.error_bits;
 
-	return io->error_bits ? -EIO : 0;
+	return sio.error_bits ? -EIO : 0;
 }
 
 static int async_io(struct dm_io_client *client, unsigned int num_regions,
@@ -434,7 +434,6 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 	io = mempool_alloc(client->pool, GFP_NOIO);
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
-	io->sleeper = NULL;
 	io->client = client;
 	io->callback = fn;
 	io->context = context;

