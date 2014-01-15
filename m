Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaAOV7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:59:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41220 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaAOV7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:59:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 033/166] dm snapshot: avoid snapshot space leak on crash
Date: Wed, 15 Jan 2014 13:50:47 -0800
Message-Id: <1389822780-4729-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 230c83afdd9cd384348475bea1e14b80b3b6b1b8 upstream.

There is a possible leak of snapshot space in case of crash.

The reason for space leaking is that chunks in the snapshot device are
allocated sequentially, but they are finished (and stored in the metadata)
out of order, depending on the order in which copying finished.

For example, supposed that the metadata contains the following records
SUPERBLOCK
METADATA (blocks 0 ... 250)
DATA 0
DATA 1
DATA 2
...
DATA 250

Now suppose that you allocate 10 new data blocks 251-260. Suppose that
copying of these blocks finish out of order (block 260 finished first
and the block 251 finished last). Now, the snapshot device looks like
this:
SUPERBLOCK
METADATA (blocks 0 ... 250, 260, 259, 258, 257, 256)
DATA 0
DATA 1
DATA 2
...
DATA 250
DATA 251
DATA 252
DATA 253
DATA 254
DATA 255
METADATA (blocks 255, 254, 253, 252, 251)
DATA 256
DATA 257
DATA 258
DATA 259
DATA 260

Now, if the machine crashes after writing the first metadata block but
before writing the second metadata block, the space for areas DATA 250-255
is leaked, it contains no valid data and it will never be used in the
future.

This patch makes dm-snapshot complete exceptions in the same order they
were allocated, thus fixing this bug.

Note: when backporting this patch to the stable kernel, change the version
field in the following way:
* if version in the stable kernel is {1, 11, 1}, change it to {1, 12, 0}
* if version in the stable kernel is {1, 10, 0} or {1, 10, 1}, change it
  to {1, 10, 2}
Userspace reads the version to determine if the bug was fixed, so the
version change is needed.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-snap.c | 71 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 8b36c52..b06482b 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -66,6 +66,18 @@ struct dm_snapshot {
 
 	atomic_t pending_exceptions_count;
 
+	/* Protected by "lock" */
+	sector_t exception_start_sequence;
+
+	/* Protected by kcopyd single-threaded callback */
+	sector_t exception_complete_sequence;
+
+	/*
+	 * A list of pending exceptions that completed out of order.
+	 * Protected by kcopyd single-threaded callback.
+	 */
+	struct list_head out_of_order_list;
+
 	mempool_t *pending_pool;
 
 	struct dm_exception_table pending;
@@ -170,6 +182,14 @@ struct dm_snap_pending_exception {
 	 */
 	int started;
 
+	/* There was copying error. */
+	int copy_error;
+
+	/* A sequence number, it is used for in-order completion. */
+	sector_t exception_sequence;
+
+	struct list_head out_of_order_entry;
+
 	/*
 	 * For writing a complete chunk, bypassing the copy.
 	 */
@@ -1092,6 +1112,9 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->valid = 1;
 	s->active = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
+	s->exception_start_sequence = 0;
+	s->exception_complete_sequence = 0;
+	INIT_LIST_HEAD(&s->out_of_order_list);
 	init_rwsem(&s->lock);
 	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
@@ -1441,6 +1464,19 @@ static void commit_callback(void *context, int success)
 	pending_complete(pe, success);
 }
 
+static void complete_exception(struct dm_snap_pending_exception *pe)
+{
+	struct dm_snapshot *s = pe->snap;
+
+	if (unlikely(pe->copy_error))
+		pending_complete(pe, 0);
+
+	else
+		/* Update the metadata if we are persistent */
+		s->store->type->commit_exception(s->store, &pe->e,
+						 commit_callback, pe);
+}
+
 /*
  * Called when the copy I/O has finished.  kcopyd actually runs
  * this code so don't block.
@@ -1450,13 +1486,32 @@ static void copy_callback(int read_err, unsigned long write_err, void *context)
 	struct dm_snap_pending_exception *pe = context;
 	struct dm_snapshot *s = pe->snap;
 
-	if (read_err || write_err)
-		pending_complete(pe, 0);
+	pe->copy_error = read_err || write_err;
 
-	else
-		/* Update the metadata if we are persistent */
-		s->store->type->commit_exception(s->store, &pe->e,
-						 commit_callback, pe);
+	if (pe->exception_sequence == s->exception_complete_sequence) {
+		s->exception_complete_sequence++;
+		complete_exception(pe);
+
+		while (!list_empty(&s->out_of_order_list)) {
+			pe = list_entry(s->out_of_order_list.next,
+					struct dm_snap_pending_exception, out_of_order_entry);
+			if (pe->exception_sequence != s->exception_complete_sequence)
+				break;
+			s->exception_complete_sequence++;
+			list_del(&pe->out_of_order_entry);
+			complete_exception(pe);
+		}
+	} else {
+		struct list_head *lh;
+		struct dm_snap_pending_exception *pe2;
+
+		list_for_each_prev(lh, &s->out_of_order_list) {
+			pe2 = list_entry(lh, struct dm_snap_pending_exception, out_of_order_entry);
+			if (pe2->exception_sequence < pe->exception_sequence)
+				break;
+		}
+		list_add(&pe->out_of_order_entry, lh);
+	}
 }
 
 /*
@@ -1551,6 +1606,8 @@ __find_pending_exception(struct dm_snapshot *s,
 		return NULL;
 	}
 
+	pe->exception_sequence = s->exception_start_sequence++;
+
 	dm_insert_exception(&s->pending, &pe->e);
 
 	return pe;
@@ -2190,7 +2247,7 @@ static struct target_type origin_target = {
 
 static struct target_type snapshot_target = {
 	.name    = "snapshot",
-	.version = {1, 11, 1},
+	.version = {1, 12, 0},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
-- 
1.8.3.2

