Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3CDQr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:47:29 -0500
Received: from mail-qc0-f202.google.com ([209.85.216.202]:42987 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765Ab3CDQr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:47:27 -0500
From: Paul Taysom <taysom@chromium.org>
To: agk@redhat.com
Cc: dm-devel@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, msb@chromium.org, mpatocka@redhat.com,
        olofj@chromium.org, Paul Taysom <taysom@chromium.org>
Subject: [PATCH] md: dm-verity: Fix to avoid a deadlock in dm-bufio
Date: Mon,  4 Mar 2013 08:45:48 -0800
Message-Id: <1362415549-18653-1-git-send-email-taysom@chromium.org>
X-Mailer: git-send-email 1.8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the dm-verity prefetching to use a worker thread to avoid
a deadlock in dm-bufio.

If generic_make_request is called recursively, it queues the I/O
request on the current->bio_list without making the I/O request
and returns. The routine making the recursive call cannot wait
for the I/O to complete.

The deadlock occurred when one thread grabbed the bufio_client
mutex and waited for an I/O to complete but the I/O was queued
on another thread’s current->bio_list and it was waiting to get
the mutex held by the first thread.

The fix allows only one I/O request from dm-verity to dm-bufio
per thread. To do this, the prefetch requests were queued on worker
threads.

In addition to avoiding the deadlock, this fix made a slight
improvement in performance.

seconds_kernel_to_login:
  with prefetch:    8.43s
  without prefetch: 9.2s
  worker prefetch:  8.28s

Signed-off-by: Paul Taysom <taysom@chromium.org>
---
 drivers/md/dm-verity.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 52cde98..7313498 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -93,6 +93,13 @@ struct dm_verity_io {
 	 */
 };
 
+struct dm_verity_prefetch_work {
+	struct work_struct work;
+	struct dm_bufio_client *bufio;
+	sector_t block;
+	unsigned n_blocks;
+};
+
 static struct shash_desc *io_hash_desc(struct dm_verity *v, struct dm_verity_io *io)
 {
 	return (struct shash_desc *)(io + 1);
@@ -419,6 +426,17 @@ static void verity_end_io(struct bio *bio, int error)
 	queue_work(io->v->verify_wq, &io->work);
 }
 
+
+static void do_verity_prefetch_work(struct work_struct *work)
+{
+	struct dm_verity_prefetch_work *vw =
+		container_of(work, struct dm_verity_prefetch_work, work);
+
+	dm_bufio_prefetch(vw->bufio, vw->block, vw->n_blocks);
+
+	kfree(vw);
+}
+
 /*
  * Prefetch buffers for the specified io.
  * The root buffer is not prefetched, it is assumed that it will be cached
@@ -427,6 +445,7 @@ static void verity_end_io(struct bio *bio, int error)
 static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
 {
 	int i;
+	struct dm_verity_prefetch_work *vw;
 
 	for (i = v->levels - 2; i >= 0; i--) {
 		sector_t hash_block_start;
@@ -449,8 +468,14 @@ static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
 				hash_block_end = v->hash_blocks - 1;
 		}
 no_prefetch_cluster:
-		dm_bufio_prefetch(v->bufio, hash_block_start,
-				  hash_block_end - hash_block_start + 1);
+		vw = kmalloc(sizeof(*vw), GFP_KERNEL);
+		if (!vw)  /* Just prefetching, ignore errors */
+			return;
+		vw->bufio = v->bufio;
+		vw->block = hash_block_start;
+		vw->n_blocks = hash_block_end - hash_block_start + 1;
+		INIT_WORK(&vw->work, do_verity_prefetch_work);
+		queue_work(v->verify_wq, &vw->work);
 	}
 }
 
-- 
1.8.1.3

