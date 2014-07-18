Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935249AbaGRNfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:35:52 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17726 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030741AbaGRNOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:14:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Thornber <thornber@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 154/170] dm io: fix a race condition in the wake up code for sync_io
Date: Fri, 18 Jul 2014 14:12:39 +0200
Message-Id: <64755b9bed72f0f706c89aed38e478fa8b5f5dd3.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Thornber <thornber@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 10f1d5d111e8aed46a0f1179faf9a3cf422f689e upstream.

There's a race condition between the atomic_dec_and_test(&io->count)
in dec_count() and the waking of the sync_io() thread.  If the thread
is spuriously woken immediately after the decrement it may exit,
making the on stack io struct invalid, yet the dec_count could still
be using it.

Fix this race by using a completion in sync_io() and dec_count().

Reported-by: Minfei Huang <huangminfei@ucloud.cn>
Signed-off-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-io.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 2a20986a2fec..e60c2eaea7bb 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -10,6 +10,7 @@
 #include <linux/device-mapper.h>
 
 #include <linux/bio.h>
+#include <linux/completion.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/sched.h>
@@ -32,7 +33,7 @@ struct dm_io_client {
 struct io {
 	unsigned long error_bits;
 	atomic_t count;
-	struct task_struct *sleeper;
+	struct completion *wait;
 	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
@@ -121,8 +122,8 @@ static void dec_count(struct io *io, unsigned int region, int error)
 			invalidate_kernel_vmap_range(io->vma_invalidate_address,
 						     io->vma_invalidate_size);
 
-		if (io->sleeper)
-			wake_up_process(io->sleeper);
+		if (io->wait)
+			complete(io->wait);
 
 		else {
 			unsigned long r = io->error_bits;
@@ -385,6 +386,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	 */
 	volatile char io_[sizeof(struct io) + __alignof__(struct io) - 1];
 	struct io *io = (struct io *)PTR_ALIGN(&io_, __alignof__(struct io));
+	DECLARE_COMPLETION_ONSTACK(wait);
 
 	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
 		WARN_ON(1);
@@ -393,7 +395,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
-	io->sleeper = current;
+	io->wait = &wait;
 	io->client = client;
 
 	io->vma_invalidate_address = dp->vma_invalidate_address;
@@ -401,15 +403,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 
 	dispatch_io(rw, num_regions, where, dp, io, 1);
 
-	while (1) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-
-		if (!atomic_read(&io->count))
-			break;
-
-		io_schedule();
-	}
-	set_current_state(TASK_RUNNING);
+	wait_for_completion_io(&wait);
 
 	if (error_bits)
 		*error_bits = io->error_bits;
@@ -432,7 +426,7 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 	io = mempool_alloc(client->pool, GFP_NOIO);
 	io->error_bits = 0;
 	atomic_set(&io->count, 1); /* see dispatch_io() */
-	io->sleeper = NULL;
+	io->wait = NULL;
 	io->client = client;
 	io->callback = fn;
 	io->context = context;
-- 
2.0.0

