Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765845Ab3DKU3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:29:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15675 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676Ab3DKU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:18 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=-MeZNGs1UEgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=UL1szQ_TZQYA:10 a=20KFwNOVAAAA:8 a=cm27Pg_UAAAA:8 a=VwQbUJbxAAAA:8 a=zDsiSVk7fVgs92TGPGIA:9 a=jEp0ucaQiEUA:10 a=zv9_9hqRWm8A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202554.184669336@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Paul Taysom <taysom@chromium.org>, Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>, <stable@kernel.org>
Subject: [ 049/171 ] dm verity: avoid deadlock
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0049-dm-verity-avoid-deadlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 3b6b7813b198b578aa7e04e4047ddb8225c37b7f ]

A deadlock was found in the prefetch code in the dm verity map
function.  This patch fixes this by transferring the prefetch
to a worker thread and skipping it completely if kmalloc fails.

If generic_make_request is called recursively, it queues the I/O
request on the current->bio_list without making the I/O request
and returns. The routine making the recursive call cannot wait
for the I/O to complete.

The deadlock occurs when one thread grabs the bufio_client
mutex and waits for an I/O to complete but the I/O is queued
on another thread's current->bio_list and is waiting to get
the mutex held by the first thread.

The fix recognises that prefetching is not essential.  If memory
can be allocated, it queues the prefetch request to the worker thread,
but if not, it does nothing.

Signed-off-by: Paul Taysom <taysom@chromium.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/dm-bufio.c  |    2 ++
 drivers/md/dm-verity.c |   39 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cc06a1e..c0fc827 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1029,6 +1029,8 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 {
 	struct blk_plug plug;
 
+	BUG_ON(dm_bufio_in_request());
+
 	blk_start_plug(&plug);
 	dm_bufio_lock(c);
 
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 892ae27..dd5ba3b 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -95,6 +95,13 @@ struct dm_verity_io {
 	 */
 };
 
+struct dm_verity_prefetch_work {
+	struct work_struct work;
+	struct dm_verity *v;
+	sector_t block;
+	unsigned n_blocks;
+};
+
 static struct shash_desc *io_hash_desc(struct dm_verity *v, struct dm_verity_io *io)
 {
 	return (struct shash_desc *)(io + 1);
@@ -428,15 +435,18 @@ static void verity_end_io(struct bio *bio, int error)
  * The root buffer is not prefetched, it is assumed that it will be cached
  * all the time.
  */
-static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
+static void verity_prefetch_io(struct work_struct *work)
 {
+	struct dm_verity_prefetch_work *pw =
+		container_of(work, struct dm_verity_prefetch_work, work);
+	struct dm_verity *v = pw->v;
 	int i;
 
 	for (i = v->levels - 2; i >= 0; i--) {
 		sector_t hash_block_start;
 		sector_t hash_block_end;
-		verity_hash_at_level(v, io->block, i, &hash_block_start, NULL);
-		verity_hash_at_level(v, io->block + io->n_blocks - 1, i, &hash_block_end, NULL);
+		verity_hash_at_level(v, pw->block, i, &hash_block_start, NULL);
+		verity_hash_at_level(v, pw->block + pw->n_blocks - 1, i, &hash_block_end, NULL);
 		if (!i) {
 			unsigned cluster = *(volatile unsigned *)&dm_verity_prefetch_cluster;
 
@@ -456,6 +466,25 @@ no_prefetch_cluster:
 		dm_bufio_prefetch(v->bufio, hash_block_start,
 				  hash_block_end - hash_block_start + 1);
 	}
+
+	kfree(pw);
+}
+
+static void verity_submit_prefetch(struct dm_verity *v, struct dm_verity_io *io)
+{
+	struct dm_verity_prefetch_work *pw;
+
+	pw = kmalloc(sizeof(struct dm_verity_prefetch_work),
+		GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
+
+	if (!pw)
+		return;
+
+	INIT_WORK(&pw->work, verity_prefetch_io);
+	pw->v = v;
+	pw->block = io->block;
+	pw->n_blocks = io->n_blocks;
+	queue_work(v->verify_wq, &pw->work);
 }
 
 /*
@@ -504,7 +533,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio,
 	memcpy(io->io_vec, bio_iovec(bio),
 	       io->io_vec_size * sizeof(struct bio_vec));
 
-	verity_prefetch_io(v, io);
+	verity_submit_prefetch(v, io);
 
 	generic_make_request(bio);
 
@@ -875,7 +904,7 @@ bad:
 
 static struct target_type verity_target = {
 	.name		= "verity",
-	.version	= {1, 0, 0},
+	.version	= {1, 2, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
-- 
1.7.10.4


