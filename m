Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab3J2SKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:10:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59663 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3J2SKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:10:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 25/81] xen-blkfront: use a different scatterlist for each request
Date: Tue, 29 Oct 2013 11:03:46 -0700
Message-Id: <1383069882-11437-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

commit b7649158a0d241f8d53d13ff7441858539e16656 upstream.

In blkif_queue_request blkfront iterates over the scatterlist in order
to set the segments of the request, and in blkif_completion blkfront
iterates over the raw request, which makes it hard to know the exact
position of the source and destination memory positions.

This can be solved by allocating a scatterlist for each request, that
will be keep until the request is finished, allowing us to copy the
data back to the original memory without having to iterate over the
raw request.

Oracle-Bug: 16660413 - LARGE ASYNCHRONOUS READS APPEAR BROKEN ON 2.6.39-400
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-and-Tested-by: Anne Milicia <anne.milicia@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/xen-blkfront.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2e39eaf..3331cb1 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -76,6 +76,7 @@ struct blk_shadow {
 	struct request *request;
 	unsigned long frame[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	struct grant *grants_used[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct scatterlist sg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
 static DEFINE_MUTEX(blkfront_mutex);
@@ -99,7 +100,6 @@ struct blkfront_info
 	enum blkif_state connected;
 	int ring_ref;
 	struct blkif_front_ring ring;
-	struct scatterlist sg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	unsigned int evtchn, irq;
 	struct request_queue *rq;
 	struct work_struct work;
@@ -362,11 +362,11 @@ static int blkif_queue_request(struct request *req)
 			ring_req->u.discard.flag = 0;
 	} else {
 		ring_req->u.rw.nr_segments = blk_rq_map_sg(req->q, req,
-							   info->sg);
+							   info->shadow[id].sg);
 		BUG_ON(ring_req->u.rw.nr_segments >
 		       BLKIF_MAX_SEGMENTS_PER_REQUEST);
 
-		for_each_sg(info->sg, sg, ring_req->u.rw.nr_segments, i) {
+		for_each_sg(info->shadow[id].sg, sg, ring_req->u.rw.nr_segments, i) {
 			fsect = sg->offset >> 9;
 			lsect = fsect + (sg->length >> 9) - 1;
 
@@ -839,12 +839,12 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 			     struct blkif_response *bret)
 {
 	int i = 0;
-	struct bio_vec *bvec;
-	struct req_iterator iter;
-	unsigned long flags;
+	struct scatterlist *sg;
 	char *bvec_data;
 	void *shared_data;
-	unsigned int offset = 0;
+	int nseg;
+
+	nseg = s->req.u.rw.nr_segments;
 
 	if (bret->operation == BLKIF_OP_READ) {
 		/*
@@ -853,19 +853,16 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 		 * than PAGE_SIZE, we have to keep track of the current offset,
 		 * to be sure we are copying the data from the right shared page.
 		 */
-		rq_for_each_segment(bvec, s->request, iter) {
-			BUG_ON((bvec->bv_offset + bvec->bv_len) > PAGE_SIZE);
-			if (bvec->bv_offset < offset)
-				i++;
-			BUG_ON(i >= s->req.u.rw.nr_segments);
+		for_each_sg(s->sg, sg, nseg, i) {
+			BUG_ON(sg->offset + sg->length > PAGE_SIZE);
 			shared_data = kmap_atomic(
 				pfn_to_page(s->grants_used[i]->pfn));
-			bvec_data = bvec_kmap_irq(bvec, &flags);
-			memcpy(bvec_data, shared_data + bvec->bv_offset,
-				bvec->bv_len);
-			bvec_kunmap_irq(bvec_data, &flags);
+			bvec_data = kmap_atomic(sg_page(sg));
+			memcpy(bvec_data   + sg->offset,
+			       shared_data + sg->offset,
+			       sg->length);
+			kunmap_atomic(bvec_data);
 			kunmap_atomic(shared_data);
-			offset = bvec->bv_offset + bvec->bv_len;
 		}
 	}
 	/* Add the persistent grant into the list of free grants */
@@ -994,7 +991,7 @@ static int setup_blkring(struct xenbus_device *dev,
 			 struct blkfront_info *info)
 {
 	struct blkif_sring *sring;
-	int err;
+	int err, i;
 
 	info->ring_ref = GRANT_INVALID_REF;
 
@@ -1006,7 +1003,8 @@ static int setup_blkring(struct xenbus_device *dev,
 	SHARED_RING_INIT(sring);
 	FRONT_RING_INIT(&info->ring, sring, PAGE_SIZE);
 
-	sg_init_table(info->sg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
+	for (i = 0; i < BLK_RING_SIZE; i++)
+		sg_init_table(info->shadow[i].sg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
 
 	err = xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
 	if (err < 0) {
-- 
1.8.1.2

