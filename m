Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967740Ab3HICHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:07:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967544Ab3HIB7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 073/102] xen-blkfront: use a different scatterlist for each request
Date: Thu,  8 Aug 2013 18:57:49 -0700
Message-Id: <20130809015027.421581341@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
CC: stable@vger.kernel.org
Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reported-and-Tested-by: Anne Milicia <anne.milicia@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/block/xen-blkfront.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -75,6 +75,7 @@ struct blk_shadow {
 	struct blkif_request req;
 	struct request *request;
 	struct grant *grants_used[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct scatterlist sg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 };
 
 static DEFINE_MUTEX(blkfront_mutex);
@@ -98,7 +99,6 @@ struct blkfront_info
 	enum blkif_state connected;
 	int ring_ref;
 	struct blkif_front_ring ring;
-	struct scatterlist sg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	unsigned int evtchn, irq;
 	struct request_queue *rq;
 	struct work_struct work;
@@ -422,11 +422,11 @@ static int blkif_queue_request(struct re
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
 
@@ -867,12 +867,12 @@ static void blkif_completion(struct blk_
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
@@ -881,19 +881,16 @@ static void blkif_completion(struct blk_
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
@@ -1022,7 +1019,7 @@ static int setup_blkring(struct xenbus_d
 			 struct blkfront_info *info)
 {
 	struct blkif_sring *sring;
-	int err;
+	int err, i;
 
 	info->ring_ref = GRANT_INVALID_REF;
 
@@ -1034,7 +1031,8 @@ static int setup_blkring(struct xenbus_d
 	SHARED_RING_INIT(sring);
 	FRONT_RING_INIT(&info->ring, sring, PAGE_SIZE);
 
-	sg_init_table(info->sg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
+	for (i = 0; i < BLK_RING_SIZE; i++)
+		sg_init_table(info->shadow[i].sg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
 
 	/* Allocate memory for grants */
 	err = fill_grant_buffer(info, BLK_RING_SIZE *


