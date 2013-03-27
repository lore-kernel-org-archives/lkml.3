Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3C0LNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:13:06 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:33206 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3C0LM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:12:28 -0400
X-IronPort-AV: E=Sophos;i="4.84,917,1355097600"; 
   d="scan'208";a="2955627"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v1 7/7] xen-block: implement indirect descriptors
Date: Wed, 27 Mar 2013 12:10:43 +0100
Message-ID: <1364382643-3711-8-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
In-Reply-To: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
References: <1364382643-3711-1-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indirect descriptors introduce a new block operation
(BLKIF_OP_INDIRECT) that passes grant references instead of segments
in the request. This grant references are filled with arrays of
blkif_request_segment_aligned, this way we can send more segments in a
request.

The proposed implementation sets the maximum number of indirect grefs
(frames filled with blkif_request_segment_aligned) to 256 in the
backend and 32 in the frontend. The value in the frontend has been
chosen experimentally, and the backend value has been set to a sane
value that allows expanding the maximum number of indirect descriptors
in the frontend if needed.

The migration code has changed from the previous implementation, in
which we simply remapped the segments on the shared ring. Now the
maximum number of segments allowed in a request can change depending
on the backend, so we have to requeue all the requests in the ring and
in the queue and split the bios in them if they are bigger than the
new maximum number of segments.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xen.org
---
 drivers/block/xen-blkback/blkback.c |  136 +++++++---
 drivers/block/xen-blkback/common.h  |   82 ++++++-
 drivers/block/xen-blkback/xenbus.c  |    8 +
 drivers/block/xen-blkfront.c        |  490 +++++++++++++++++++++++++++++------
 include/xen/interface/io/blkif.h    |   26 ++
 5 files changed, 621 insertions(+), 121 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index f8c838e..f16a7c9 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -69,7 +69,7 @@ MODULE_PARM_DESC(reqs, "Number of blkback requests to allocate per backend");
  * IO workloads.
  */
 
-static int xen_blkif_max_buffer_pages = 704;
+static int xen_blkif_max_buffer_pages = 1024;
 module_param_named(max_buffer_pages, xen_blkif_max_buffer_pages, int, 0644);
 MODULE_PARM_DESC(max_buffer_pages,
 "Maximum number of free pages to keep in each block backend buffer");
@@ -85,7 +85,7 @@ MODULE_PARM_DESC(max_buffer_pages,
  * algorithm.
  */
 
-static int xen_blkif_max_pgrants = 352;
+static int xen_blkif_max_pgrants = 1056;
 module_param_named(max_persistent_grants, xen_blkif_max_pgrants, int, 0644);
 MODULE_PARM_DESC(max_persistent_grants,
                  "Maximum number of grants to map persistently");
@@ -631,10 +631,6 @@ purge_gnt_list:
 	return 0;
 }
 
-struct seg_buf {
-	unsigned int offset;
-	unsigned int nsec;
-};
 /*
  * Unmap the grant references, and also remove the M2P over-rides
  * used in the 'pending_req'.
@@ -808,29 +804,71 @@ out_of_memory:
 	return -ENOMEM;
 }
 
-static int xen_blkbk_map_seg(struct blkif_request *req,
-			     struct pending_req *pending_req,
+static int xen_blkbk_map_seg(struct pending_req *pending_req,
 			     struct seg_buf seg[],
 			     struct page *pages[])
 {
-	int i, rc;
-	grant_ref_t grefs[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	int rc;
 
-	for (i = 0; i < req->u.rw.nr_segments; i++)
-		grefs[i] = req->u.rw.seg[i].gref;
-
-	rc = xen_blkbk_map(pending_req->blkif, grefs,
+	rc = xen_blkbk_map(pending_req->blkif, pending_req->grefs,
 	                   pending_req->persistent_gnts,
 	                   pending_req->grant_handles, pending_req->pages,
-	                   req->u.rw.nr_segments,
+	                   pending_req->nr_pages,
 	                   (pending_req->operation != BLKIF_OP_READ));
-	if (rc)
-		return rc;
 
-	for (i = 0; i < req->u.rw.nr_segments; i++)
-		seg[i].offset = (req->u.rw.seg[i].first_sect << 9);
+	return rc;
+}
 
-	return 0;
+static int xen_blkbk_parse_indirect(struct blkif_request *req,
+                                    struct pending_req *pending_req,
+                                    struct seg_buf seg[],
+                                    struct phys_req *preq)
+{
+	struct persistent_gnt **persistent =
+		pending_req->indirect_persistent_gnts;
+	struct page **pages = pending_req->indirect_pages;
+	struct xen_blkif *blkif = pending_req->blkif;
+	int indirect_grefs, rc, n, nseg, i;
+	struct blkif_request_segment_aligned *segments = NULL;
+
+	nseg = pending_req->nr_pages;
+	indirect_grefs = (nseg + SEGS_PER_INDIRECT_FRAME - 1) /
+		         SEGS_PER_INDIRECT_FRAME;
+
+	rc = xen_blkbk_map(blkif, req->u.indirect.indirect_grefs,
+	                   persistent, pending_req->indirect_handles,
+	                   pages, indirect_grefs, true);
+	if (rc)
+		goto unmap;
+
+	for (n = 0, i = 0; n < nseg; n++) {
+		if ((n % SEGS_PER_INDIRECT_FRAME) == 0) {
+			/* Map indirect segments */
+			if (segments)
+				kunmap_atomic(segments);
+			segments =
+				kmap_atomic(pages[n/SEGS_PER_INDIRECT_FRAME]);
+		}
+		i = n % SEGS_PER_INDIRECT_FRAME;
+		pending_req->grefs[n] = segments[i].gref;
+		seg[n].nsec = segments[i].last_sect -
+			segments[i].first_sect + 1;
+		seg[n].offset = (segments[i].first_sect << 9);
+		if ((segments[i].last_sect >= (PAGE_SIZE >> 9)) ||
+	    	    (segments[i].last_sect <
+	    	     segments[i].first_sect)) {
+			rc = -EINVAL;
+			goto unmap;
+		}
+		preq->nr_sects += seg[n].nsec;
+	}
+
+unmap:
+	if (segments)
+		kunmap_atomic(segments);
+	xen_blkbk_unmap(blkif, pending_req->indirect_handles,
+                        pages, persistent, indirect_grefs);
+	return rc;
 }
 
 static int dispatch_discard_io(struct xen_blkif *blkif,
@@ -1003,6 +1041,7 @@ __do_block_io_op(struct xen_blkif *blkif)
 		case BLKIF_OP_WRITE:
 		case BLKIF_OP_WRITE_BARRIER:
 		case BLKIF_OP_FLUSH_DISKCACHE:
+		case BLKIF_OP_INDIRECT:
 			if (dispatch_rw_block_io(blkif, &req, pending_req))
 				goto done;
 			break;
@@ -1049,17 +1088,28 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 				struct pending_req *pending_req)
 {
 	struct phys_req preq;
-	struct seg_buf seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct seg_buf *seg = pending_req->seg;
 	unsigned int nseg;
 	struct bio *bio = NULL;
-	struct bio *biolist[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct bio **biolist = pending_req->biolist;
 	int i, nbio = 0;
 	int operation;
 	struct blk_plug plug;
 	bool drain = false;
 	struct page **pages = pending_req->pages;
+	unsigned short req_operation;
+
+	req_operation = req->operation == BLKIF_OP_INDIRECT ?
+	                req->u.indirect.indirect_op : req->operation;
+	if ((req->operation == BLKIF_OP_INDIRECT) &&
+	    (req_operation != BLKIF_OP_READ) &&
+	    (req_operation != BLKIF_OP_WRITE)) {
+		pr_debug(DRV_PFX "Invalid indirect operation (%u)\n",
+		         req_operation);
+		goto fail_response;
+	}
 
-	switch (req->operation) {
+	switch (req_operation) {
 	case BLKIF_OP_READ:
 		blkif->st_rd_req++;
 		operation = READ;
@@ -1081,33 +1131,47 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	}
 
 	/* Check that the number of segments is sane. */
-	nseg = req->u.rw.nr_segments;
+	nseg = req->operation == BLKIF_OP_INDIRECT ?
+	       req->u.indirect.nr_segments : req->u.rw.nr_segments;
 
 	if (unlikely(nseg == 0 && operation != WRITE_FLUSH) ||
-	    unlikely(nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) {
+	    unlikely((req->operation != BLKIF_OP_INDIRECT) &&
+	             (nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) ||
+	    unlikely((req->operation == BLKIF_OP_INDIRECT) &&
+	             (nseg > MAX_INDIRECT_SEGMENTS))) {
 		pr_debug(DRV_PFX "Bad number of segments in request (%d)\n",
 			 nseg);
 		/* Haven't submitted any bio's yet. */
 		goto fail_response;
 	}
 
-	preq.sector_number = req->u.rw.sector_number;
 	preq.nr_sects      = 0;
 
 	pending_req->blkif     = blkif;
 	pending_req->id        = req->u.rw.id;
-	pending_req->operation = req->operation;
+	pending_req->operation = req_operation;
 	pending_req->status    = BLKIF_RSP_OKAY;
 	pending_req->nr_pages  = nseg;
 
-	for (i = 0; i < nseg; i++) {
-		seg[i].nsec = req->u.rw.seg[i].last_sect -
-			req->u.rw.seg[i].first_sect + 1;
-		if ((req->u.rw.seg[i].last_sect >= (PAGE_SIZE >> 9)) ||
-		    (req->u.rw.seg[i].last_sect < req->u.rw.seg[i].first_sect))
+	if (req->operation != BLKIF_OP_INDIRECT) {
+		preq.dev               = req->u.rw.handle;
+		preq.sector_number     = req->u.rw.sector_number;
+		for (i = 0; i < nseg; i++) {
+			pending_req->grefs[i] = req->u.rw.seg[i].gref;
+			seg[i].nsec = req->u.rw.seg[i].last_sect -
+				req->u.rw.seg[i].first_sect + 1;
+			seg[i].offset = (req->u.rw.seg[i].first_sect << 9);
+			if ((req->u.rw.seg[i].last_sect >= (PAGE_SIZE >> 9)) ||
+		    	    (req->u.rw.seg[i].last_sect <
+		    	     req->u.rw.seg[i].first_sect))
+				goto fail_response;
+			preq.nr_sects += seg[i].nsec;
+		}
+	} else {
+		preq.dev               = req->u.indirect.handle;
+		preq.sector_number     = req->u.indirect.sector_number;
+		if (xen_blkbk_parse_indirect(req, pending_req, seg, &preq))
 			goto fail_response;
-		preq.nr_sects += seg[i].nsec;
-
 	}
 
 	if (xen_vbd_translate(&preq, blkif, operation) != 0) {
@@ -1144,7 +1208,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	 * the hypercall to unmap the grants - that is all done in
 	 * xen_blkbk_unmap.
 	 */
-	if (xen_blkbk_map_seg(req, pending_req, seg, pages))
+	if (xen_blkbk_map_seg(pending_req, seg, pages))
 		goto fail_flush;
 
 	/*
@@ -1210,7 +1274,7 @@ static int dispatch_rw_block_io(struct xen_blkif *blkif,
 	                pending_req->nr_pages);
  fail_response:
 	/* Haven't submitted any bio's yet. */
-	make_response(blkif, req->u.rw.id, req->operation, BLKIF_RSP_ERROR);
+	make_response(blkif, req->u.rw.id, req_operation, BLKIF_RSP_ERROR);
 	free_req(blkif, pending_req);
 	msleep(1); /* back off a bit */
 	return -EIO;
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index debff44..30bffcc 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -50,6 +50,17 @@
 		 __func__, __LINE__, ##args)
 
 
+/*
+ * This is the maximum number of segments that would be allowed in indirect
+ * requests. This value will also be passed to the frontend.
+ */
+#define MAX_INDIRECT_SEGMENTS 256
+
+#define SEGS_PER_INDIRECT_FRAME \
+(PAGE_SIZE/sizeof(struct blkif_request_segment_aligned))
+#define MAX_INDIRECT_GREFS \
+((MAX_INDIRECT_SEGMENTS + SEGS_PER_INDIRECT_FRAME - 1)/SEGS_PER_INDIRECT_FRAME)
+
 /* Not a real protocol.  Used to generate ring structs which contain
  * the elements common to all protocols only.  This way we get a
  * compiler-checkable way to use common struct elements, so we can
@@ -83,12 +94,23 @@ struct blkif_x86_32_request_other {
 	uint64_t       id;           /* private guest value, echoed in resp  */
 } __attribute__((__packed__));
 
+struct blkif_x86_32_request_indirect {
+	uint8_t        indirect_op;
+	uint16_t       nr_segments;
+	uint64_t       id;
+	blkif_sector_t sector_number;
+	blkif_vdev_t   handle;
+	uint16_t       _pad1;
+	grant_ref_t    indirect_grefs[BLKIF_MAX_INDIRECT_GREFS_PER_REQUEST];
+} __attribute__((__packed__));
+
 struct blkif_x86_32_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
 	union {
 		struct blkif_x86_32_request_rw rw;
 		struct blkif_x86_32_request_discard discard;
 		struct blkif_x86_32_request_other other;
+		struct blkif_x86_32_request_indirect indirect;
 	} u;
 } __attribute__((__packed__));
 
@@ -127,12 +149,24 @@ struct blkif_x86_64_request_other {
 	uint64_t       id;           /* private guest value, echoed in resp  */
 } __attribute__((__packed__));
 
+struct blkif_x86_64_request_indirect {
+	uint8_t        indirect_op;
+	uint16_t       nr_segments;
+	uint32_t       _pad1; /* offsetof(blkif_..,u.indirect.id)==8   */
+	uint64_t       id;
+	blkif_sector_t sector_number;
+	blkif_vdev_t   handle;
+	uint16_t       _pad2;
+	grant_ref_t    indirect_grefs[BLKIF_MAX_INDIRECT_GREFS_PER_REQUEST];
+} __attribute__((__packed__));
+
 struct blkif_x86_64_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
 	union {
 		struct blkif_x86_64_request_rw rw;
 		struct blkif_x86_64_request_discard discard;
 		struct blkif_x86_64_request_other other;
+		struct blkif_x86_64_request_indirect indirect;
 	} u;
 } __attribute__((__packed__));
 
@@ -257,6 +291,11 @@ struct xen_blkif {
 	wait_queue_head_t	waiting_to_free;
 };
 
+struct seg_buf {
+	unsigned long offset;
+	unsigned int nsec;
+};
+
 /*
  * Each outstanding request that we've passed to the lower device layers has a
  * 'pending_req' allocated to it. Each buffer_head that completes decrements
@@ -271,9 +310,16 @@ struct pending_req {
 	unsigned short		operation;
 	int			status;
 	struct list_head	free_list;
-	struct page		*pages[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	struct persistent_gnt	*persistent_gnts[BLKIF_MAX_SEGMENTS_PER_REQUEST];
-	grant_handle_t		grant_handles[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct page		*pages[MAX_INDIRECT_SEGMENTS];
+	struct persistent_gnt	*persistent_gnts[MAX_INDIRECT_SEGMENTS];
+	grant_handle_t		grant_handles[MAX_INDIRECT_SEGMENTS];
+	grant_ref_t		grefs[MAX_INDIRECT_SEGMENTS];
+	/* Indirect descriptors */
+	struct persistent_gnt	*indirect_persistent_gnts[MAX_INDIRECT_GREFS];
+	struct page		*indirect_pages[MAX_INDIRECT_GREFS];
+	grant_handle_t		indirect_handles[MAX_INDIRECT_GREFS];
+	struct seg_buf		seg[MAX_INDIRECT_SEGMENTS];
+	struct bio		*biolist[MAX_INDIRECT_SEGMENTS];
 };
 
 
@@ -312,7 +358,7 @@ struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be);
 static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 					struct blkif_x86_32_request *src)
 {
-	int i, n = BLKIF_MAX_SEGMENTS_PER_REQUEST;
+	int i, n = BLKIF_MAX_SEGMENTS_PER_REQUEST, j = MAX_INDIRECT_GREFS;
 	dst->operation = src->operation;
 	switch (src->operation) {
 	case BLKIF_OP_READ:
@@ -335,6 +381,19 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;
+	case BLKIF_OP_INDIRECT:
+		dst->u.indirect.indirect_op = src->u.indirect.indirect_op;
+		dst->u.indirect.nr_segments = src->u.indirect.nr_segments;
+		dst->u.indirect.handle = src->u.indirect.handle;
+		dst->u.indirect.id = src->u.indirect.id;
+		dst->u.indirect.sector_number = src->u.indirect.sector_number;
+		barrier();
+		if (j > dst->u.indirect.nr_segments)
+			j = dst->u.indirect.nr_segments;
+		for (i = 0; i < j; i++)
+			dst->u.indirect.indirect_grefs[i] =
+				src->u.indirect.indirect_grefs[i];
+		break;
 	default:
 		/*
 		 * Don't know how to translate this op. Only get the
@@ -348,7 +407,7 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 static inline void blkif_get_x86_64_req(struct blkif_request *dst,
 					struct blkif_x86_64_request *src)
 {
-	int i, n = BLKIF_MAX_SEGMENTS_PER_REQUEST;
+	int i, n = BLKIF_MAX_SEGMENTS_PER_REQUEST, j = MAX_INDIRECT_GREFS;
 	dst->operation = src->operation;
 	switch (src->operation) {
 	case BLKIF_OP_READ:
@@ -371,6 +430,19 @@ static inline void blkif_get_x86_64_req(struct blkif_request *dst,
 		dst->u.discard.sector_number = src->u.discard.sector_number;
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;
+	case BLKIF_OP_INDIRECT:
+		dst->u.indirect.indirect_op = src->u.indirect.indirect_op;
+		dst->u.indirect.nr_segments = src->u.indirect.nr_segments;
+		dst->u.indirect.handle = src->u.indirect.handle;
+		dst->u.indirect.id = src->u.indirect.id;
+		dst->u.indirect.sector_number = src->u.indirect.sector_number;
+		barrier();
+		if (j > dst->u.indirect.nr_segments)
+			j = dst->u.indirect.nr_segments;
+		for (i = 0; i < j; i++)
+			dst->u.indirect.indirect_grefs[i] =
+				src->u.indirect.indirect_grefs[i];
+		break;
 	default:
 		/*
 		 * Don't know how to translate this op. Only get the
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index bf7344f..172cf89 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -703,6 +703,14 @@ again:
 		goto abort;
 	}
 
+	err = xenbus_printf(xbt, dev->nodename, "max-indirect-segments", "%u",
+	                    MAX_INDIRECT_SEGMENTS);
+	if (err) {
+		xenbus_dev_fatal(dev, err, "writing %s/max-indirect-segments",
+				 dev->nodename);
+		goto abort;
+	}
+
 	err = xenbus_printf(xbt, dev->nodename, "sectors", "%llu",
 			    (unsigned long long)vbd_sz(&be->blkif->vbd));
 	if (err) {
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index a894f88..ecbc26a 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -74,12 +74,30 @@ struct grant {
 struct blk_shadow {
 	struct blkif_request req;
 	struct request *request;
-	struct grant *grants_used[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct grant **grants_used;
+	struct grant **indirect_grants;
+};
+
+struct split_bio {
+	struct bio *bio;
+	atomic_t pending;
+	int err;
 };
 
 static DEFINE_MUTEX(blkfront_mutex);
 static const struct block_device_operations xlvbd_block_fops;
 
+/*
+ * Maximum number of segments in indirect requests, the actual value used by
+ * the frontend driver is the minimum of this value and the value provided
+ * by the backend driver.
+ */
+
+static int xen_blkif_max_segments = 32;
+module_param_named(max_segments, xen_blkif_max_segments, int, 0);
+MODULE_PARM_DESC(max_segments,
+"Maximum number of segments in indirect requests");
+
 #define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
 
 /*
@@ -98,7 +116,7 @@ struct blkfront_info
 	enum blkif_state connected;
 	int ring_ref;
 	struct blkif_front_ring ring;
-	struct scatterlist sg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	struct scatterlist *sg;
 	unsigned int evtchn, irq;
 	struct request_queue *rq;
 	struct work_struct work;
@@ -114,6 +132,8 @@ struct blkfront_info
 	unsigned int discard_granularity;
 	unsigned int discard_alignment;
 	unsigned int feature_persistent:1;
+	unsigned int max_indirect_segments;
+	unsigned int sector_size;
 	int is_ready;
 };
 
@@ -142,6 +162,14 @@ static DEFINE_SPINLOCK(minor_lock);
 
 #define DEV_NAME	"xvd"	/* name in /dev */
 
+#define SEGS_PER_INDIRECT_FRAME \
+	(PAGE_SIZE/sizeof(struct blkif_request_segment_aligned))
+#define INDIRECT_GREFS(_segs) \
+	((_segs + SEGS_PER_INDIRECT_FRAME - 1)/SEGS_PER_INDIRECT_FRAME)
+#define MIN(_a, _b) ((_a) < (_b) ? (_a) : (_b))
+
+static int blkfront_setup_indirect(struct blkfront_info *info);
+
 static int get_id_from_freelist(struct blkfront_info *info)
 {
 	unsigned long free = info->shadow_free;
@@ -358,7 +386,8 @@ static int blkif_queue_request(struct request *req)
 	struct blkif_request *ring_req;
 	unsigned long id;
 	unsigned int fsect, lsect;
-	int i, ref;
+	int i, ref, n;
+	struct blkif_request_segment_aligned *segments = NULL;
 
 	/*
 	 * Used to store if we are able to queue the request by just using
@@ -369,21 +398,27 @@ static int blkif_queue_request(struct request *req)
 	grant_ref_t gref_head;
 	struct grant *gnt_list_entry = NULL;
 	struct scatterlist *sg;
+	int nseg, max_grefs;
 
 	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
 		return 1;
 
-	/* Check if we have enought grants to allocate a requests */
-	if (info->persistent_gnts_c < BLKIF_MAX_SEGMENTS_PER_REQUEST) {
+	max_grefs = info->max_indirect_segments ?
+	            info->max_indirect_segments +
+	            INDIRECT_GREFS(info->max_indirect_segments) :
+	            BLKIF_MAX_SEGMENTS_PER_REQUEST;
+
+	/* Check if we have enough grants to allocate a requests */
+	if (info->persistent_gnts_c < max_grefs) {
 		new_persistent_gnts = 1;
 		if (gnttab_alloc_grant_references(
-		    BLKIF_MAX_SEGMENTS_PER_REQUEST - info->persistent_gnts_c,
+		    max_grefs - info->persistent_gnts_c,
 		    &gref_head) < 0) {
 			gnttab_request_free_callback(
 				&info->callback,
 				blkif_restart_queue_callback,
 				info,
-				BLKIF_MAX_SEGMENTS_PER_REQUEST);
+				max_grefs);
 			return 1;
 		}
 	} else
@@ -394,42 +429,74 @@ static int blkif_queue_request(struct request *req)
 	id = get_id_from_freelist(info);
 	info->shadow[id].request = req;
 
-	ring_req->u.rw.id = id;
-	ring_req->u.rw.sector_number = (blkif_sector_t)blk_rq_pos(req);
-	ring_req->u.rw.handle = info->handle;
-
-	ring_req->operation = rq_data_dir(req) ?
-		BLKIF_OP_WRITE : BLKIF_OP_READ;
-
-	if (req->cmd_flags & (REQ_FLUSH | REQ_FUA)) {
-		/*
-		 * Ideally we can do an unordered flush-to-disk. In case the
-		 * backend onlysupports barriers, use that. A barrier request
-		 * a superset of FUA, so we can implement it the same
-		 * way.  (It's also a FLUSH+FUA, since it is
-		 * guaranteed ordered WRT previous writes.)
-		 */
-		ring_req->operation = info->flush_op;
-	}
-
 	if (unlikely(req->cmd_flags & (REQ_DISCARD | REQ_SECURE))) {
 		/* id, sector_number and handle are set above. */
 		ring_req->operation = BLKIF_OP_DISCARD;
 		ring_req->u.discard.nr_sectors = blk_rq_sectors(req);
+		ring_req->u.discard.id = id;
+		ring_req->u.discard.sector_number =
+			(blkif_sector_t)blk_rq_pos(req);
 		if ((req->cmd_flags & REQ_SECURE) && info->feature_secdiscard)
 			ring_req->u.discard.flag = BLKIF_DISCARD_SECURE;
 		else
 			ring_req->u.discard.flag = 0;
 	} else {
-		ring_req->u.rw.nr_segments = blk_rq_map_sg(req->q, req,
-							   info->sg);
-		BUG_ON(ring_req->u.rw.nr_segments >
-		       BLKIF_MAX_SEGMENTS_PER_REQUEST);
-
-		for_each_sg(info->sg, sg, ring_req->u.rw.nr_segments, i) {
+		BUG_ON(info->max_indirect_segments == 0 &&
+		       req->nr_phys_segments > BLKIF_MAX_SEGMENTS_PER_REQUEST);
+		BUG_ON(info->max_indirect_segments &&
+		       req->nr_phys_segments > info->max_indirect_segments);
+		nseg = blk_rq_map_sg(req->q, req, info->sg);
+		ring_req->u.rw.id = id;
+		if (nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST) {
+			/*
+			 * The indirect operation can only be a BLKIF_OP_READ or
+			 * BLKIF_OP_WRITE
+			 */
+			BUG_ON(req->cmd_flags & (REQ_FLUSH | REQ_FUA));
+			ring_req->operation = BLKIF_OP_INDIRECT;
+			ring_req->u.indirect.indirect_op = rq_data_dir(req) ?
+				BLKIF_OP_WRITE : BLKIF_OP_READ;
+			ring_req->u.indirect.sector_number =
+				(blkif_sector_t)blk_rq_pos(req);
+			ring_req->u.indirect.handle = info->handle;
+			ring_req->u.indirect.nr_segments = nseg;
+		} else {
+			ring_req->u.rw.sector_number =
+				(blkif_sector_t)blk_rq_pos(req);
+			ring_req->u.rw.handle = info->handle;
+			ring_req->operation = rq_data_dir(req) ?
+				BLKIF_OP_WRITE : BLKIF_OP_READ;
+			if (req->cmd_flags & (REQ_FLUSH | REQ_FUA)) {
+		/*
+		 * Ideally we can do an unordered flush-to-disk. In case the
+		 * backend onlysupports barriers, use that. A barrier request
+		 * a superset of FUA, so we can implement it the same
+		 * way.  (It's also a FLUSH+FUA, since it is
+		 * guaranteed ordered WRT previous writes.)
+		 */
+				ring_req->operation = info->flush_op;
+			}
+			ring_req->u.rw.nr_segments = nseg;
+		}
+		for_each_sg(info->sg, sg, nseg, i) {
 			fsect = sg->offset >> 9;
 			lsect = fsect + (sg->length >> 9) - 1;
 
+			if ((ring_req->operation == BLKIF_OP_INDIRECT) &&
+			    (i % SEGS_PER_INDIRECT_FRAME == 0)) {
+				if (segments)
+					kunmap_atomic(segments);
+
+				n = i / SEGS_PER_INDIRECT_FRAME;
+				gnt_list_entry = get_grant(&gref_head, info);
+				info->shadow[id].indirect_grants[n] =
+					gnt_list_entry;
+				segments = kmap_atomic(
+					pfn_to_page(gnt_list_entry->pfn));
+				ring_req->u.indirect.indirect_grefs[n] =
+					gnt_list_entry->gref;
+			}
+
 			gnt_list_entry = get_grant(&gref_head, info);
 			ref = gnt_list_entry->gref;
 
@@ -461,13 +528,23 @@ static int blkif_queue_request(struct request *req)
 				kunmap_atomic(bvec_data);
 				kunmap_atomic(shared_data);
 			}
-
-			ring_req->u.rw.seg[i] =
-					(struct blkif_request_segment) {
-						.gref       = ref,
-						.first_sect = fsect,
-						.last_sect  = lsect };
+			if (ring_req->operation != BLKIF_OP_INDIRECT) {
+				ring_req->u.rw.seg[i] =
+						(struct blkif_request_segment) {
+							.gref       = ref,
+							.first_sect = fsect,
+							.last_sect  = lsect };
+			} else {
+				n = i % SEGS_PER_INDIRECT_FRAME;
+				segments[n] =
+					(struct blkif_request_segment_aligned) {
+							.gref       = ref,
+							.first_sect = fsect,
+							.last_sect  = lsect };
+			}
 		}
+		if (segments)
+			kunmap_atomic(segments);
 	}
 
 	info->ring.req_prod_pvt++;
@@ -542,7 +619,8 @@ wait:
 		flush_requests(info);
 }
 
-static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
+static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size,
+                                unsigned int segments)
 {
 	struct request_queue *rq;
 	struct blkfront_info *info = gd->private_data;
@@ -571,7 +649,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 	blk_queue_max_segment_size(rq, PAGE_SIZE);
 
 	/* Ensure a merged request will fit in a single I/O ring slot. */
-	blk_queue_max_segments(rq, BLKIF_MAX_SEGMENTS_PER_REQUEST);
+	blk_queue_max_segments(rq, segments);
 
 	/* Make sure buffer addresses are sector-aligned. */
 	blk_queue_dma_alignment(rq, 511);
@@ -588,13 +666,14 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 static void xlvbd_flush(struct blkfront_info *info)
 {
 	blk_queue_flush(info->rq, info->feature_flush);
-	printk(KERN_INFO "blkfront: %s: %s: %s %s\n",
+	printk(KERN_INFO "blkfront: %s: %s: %s %s %s\n",
 	       info->gd->disk_name,
 	       info->flush_op == BLKIF_OP_WRITE_BARRIER ?
 		"barrier" : (info->flush_op == BLKIF_OP_FLUSH_DISKCACHE ?
 		"flush diskcache" : "barrier or flush"),
 	       info->feature_flush ? "enabled" : "disabled",
-	       info->feature_persistent ? "using persistent grants" : "");
+	       info->feature_persistent ? "using persistent grants" : "",
+	       info->max_indirect_segments ? "using indirect descriptors" : "");
 }
 
 static int xen_translate_vdev(int vdevice, int *minor, unsigned int *offset)
@@ -734,7 +813,9 @@ static int xlvbd_alloc_gendisk(blkif_sector_t capacity,
 	gd->driverfs_dev = &(info->xbdev->dev);
 	set_capacity(gd, capacity);
 
-	if (xlvbd_init_blk_queue(gd, sector_size)) {
+	if (xlvbd_init_blk_queue(gd, sector_size,
+	                         info->max_indirect_segments ? :
+	                         BLKIF_MAX_SEGMENTS_PER_REQUEST)) {
 		del_gendisk(gd);
 		goto release;
 	}
@@ -818,6 +899,7 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 {
 	struct grant *persistent_gnt;
 	struct grant *n;
+	int i, j, segs;
 
 	/* Prevent new requests being issued until we fix things up. */
 	spin_lock_irq(&info->io_lock);
@@ -843,6 +925,47 @@ static void blkif_free(struct blkfront_info *info, int suspend)
 	}
 	BUG_ON(info->persistent_gnts_c != 0);
 
+	kfree(info->sg);
+	info->sg = NULL;
+	for (i = 0; i < BLK_RING_SIZE; i++) {
+		/*
+		 * Clear persistent grants present in requests already
+		 * on the shared ring
+		 */
+		if (!info->shadow[i].request)
+			goto free_shadow;
+
+		segs = info->shadow[i].req.operation == BLKIF_OP_INDIRECT ?
+		       info->shadow[i].req.u.indirect.nr_segments :
+		       info->shadow[i].req.u.rw.nr_segments;
+		for (j = 0; j < segs; j++) {
+			persistent_gnt = info->shadow[i].grants_used[j];
+			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
+			__free_page(pfn_to_page(persistent_gnt->pfn));
+			kfree(persistent_gnt);
+		}
+
+		if (info->shadow[i].req.operation != BLKIF_OP_INDIRECT)
+			/*
+			 * If this is not an indirect operation don't try to
+			 * free indirect segments
+			 */
+			goto free_shadow;
+
+		for (j = 0; j < INDIRECT_GREFS(segs); j++) {
+			persistent_gnt = info->shadow[i].indirect_grants[j];
+			gnttab_end_foreign_access(persistent_gnt->gref, 0, 0UL);
+			__free_page(pfn_to_page(persistent_gnt->pfn));
+			kfree(persistent_gnt);
+		}
+
+free_shadow:
+		kfree(info->shadow[i].grants_used);
+		info->shadow[i].grants_used = NULL;
+		kfree(info->shadow[i].indirect_grants);
+		info->shadow[i].indirect_grants = NULL;
+	}
+
 	/* No more gnttab callback work. */
 	gnttab_cancel_free_callback(&info->callback);
 	spin_unlock_irq(&info->io_lock);
@@ -873,6 +996,10 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 	char *bvec_data;
 	void *shared_data;
 	unsigned int offset = 0;
+	int nseg;
+
+	nseg = s->req.operation == BLKIF_OP_INDIRECT ?
+		s->req.u.indirect.nr_segments : s->req.u.rw.nr_segments;
 
 	if (bret->operation == BLKIF_OP_READ) {
 		/*
@@ -885,7 +1012,7 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 			BUG_ON((bvec->bv_offset + bvec->bv_len) > PAGE_SIZE);
 			if (bvec->bv_offset < offset)
 				i++;
-			BUG_ON(i >= s->req.u.rw.nr_segments);
+			BUG_ON(i >= nseg);
 			shared_data = kmap_atomic(
 				pfn_to_page(s->grants_used[i]->pfn));
 			bvec_data = bvec_kmap_irq(bvec, &flags);
@@ -897,10 +1024,17 @@ static void blkif_completion(struct blk_shadow *s, struct blkfront_info *info,
 		}
 	}
 	/* Add the persistent grant into the list of free grants */
-	for (i = 0; i < s->req.u.rw.nr_segments; i++) {
+	for (i = 0; i < nseg; i++) {
 		list_add(&s->grants_used[i]->node, &info->persistent_gnts);
 		info->persistent_gnts_c++;
 	}
+	if (s->req.operation == BLKIF_OP_INDIRECT) {
+		for (i = 0; i < INDIRECT_GREFS(nseg); i++) {
+			list_add(&s->indirect_grants[i]->node,
+			         &info->persistent_gnts);
+			info->persistent_gnts_c++;
+		}
+	}
 }
 
 static irqreturn_t blkif_interrupt(int irq, void *dev_id)
@@ -1034,14 +1168,6 @@ static int setup_blkring(struct xenbus_device *dev,
 	SHARED_RING_INIT(sring);
 	FRONT_RING_INIT(&info->ring, sring, PAGE_SIZE);
 
-	sg_init_table(info->sg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
-
-	/* Allocate memory for grants */
-	err = fill_grant_buffer(info, BLK_RING_SIZE *
-	                              BLKIF_MAX_SEGMENTS_PER_REQUEST);
-	if (err)
-		goto fail;
-
 	err = xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
 	if (err < 0) {
 		free_page((unsigned long)sring);
@@ -1223,13 +1349,84 @@ static int blkfront_probe(struct xenbus_device *dev,
 	return 0;
 }
 
+/*
+ * This is a clone of md_trim_bio, used to split a bio into smaller ones
+ */
+static void trim_bio(struct bio *bio, int offset, int size)
+{
+	/* 'bio' is a cloned bio which we need to trim to match
+	 * the given offset and size.
+	 * This requires adjusting bi_sector, bi_size, and bi_io_vec
+	 */
+	int i;
+	struct bio_vec *bvec;
+	int sofar = 0;
+
+	size <<= 9;
+	if (offset == 0 && size == bio->bi_size)
+		return;
+
+	bio->bi_sector += offset;
+	bio->bi_size = size;
+	offset <<= 9;
+	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
+
+	while (bio->bi_idx < bio->bi_vcnt &&
+	       bio->bi_io_vec[bio->bi_idx].bv_len <= offset) {
+		/* remove this whole bio_vec */
+		offset -= bio->bi_io_vec[bio->bi_idx].bv_len;
+		bio->bi_idx++;
+	}
+	if (bio->bi_idx < bio->bi_vcnt) {
+		bio->bi_io_vec[bio->bi_idx].bv_offset += offset;
+		bio->bi_io_vec[bio->bi_idx].bv_len -= offset;
+	}
+	/* avoid any complications with bi_idx being non-zero*/
+	if (bio->bi_idx) {
+		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,
+			(bio->bi_vcnt - bio->bi_idx) * sizeof(struct bio_vec));
+		bio->bi_vcnt -= bio->bi_idx;
+		bio->bi_idx = 0;
+	}
+	/* Make sure vcnt and last bv are not too big */
+	bio_for_each_segment(bvec, bio, i) {
+		if (sofar + bvec->bv_len > size)
+			bvec->bv_len = size - sofar;
+		if (bvec->bv_len == 0) {
+			bio->bi_vcnt = i;
+			break;
+		}
+		sofar += bvec->bv_len;
+	}
+}
+
+static void split_bio_end(struct bio *bio, int error)
+{
+	struct split_bio *split_bio = bio->bi_private;
+
+	if (error)
+		split_bio->err = error;
+
+	if (atomic_dec_and_test(&split_bio->pending)) {
+		split_bio->bio->bi_phys_segments = 0;
+		bio_endio(split_bio->bio, split_bio->err);
+		kfree(split_bio);
+	}
+	bio_put(bio);
+}
 
 static int blkif_recover(struct blkfront_info *info)
 {
 	int i;
-	struct blkif_request *req;
+	struct request *req, *n;
 	struct blk_shadow *copy;
-	int j;
+	int rc;
+	struct bio *bio, *cloned_bio;
+	struct bio_list bio_list, merge_bio;
+	unsigned int segs;
+	int pending, offset, size;
+	struct split_bio *split_bio;
+	struct list_head requests;
 
 	/* Stage 1: Make a safe copy of the shadow state. */
 	copy = kmemdup(info->shadow, sizeof(info->shadow),
@@ -1244,36 +1441,64 @@ static int blkif_recover(struct blkfront_info *info)
 	info->shadow_free = info->ring.req_prod_pvt;
 	info->shadow[BLK_RING_SIZE-1].req.u.rw.id = 0x0fffffff;
 
-	/* Stage 3: Find pending requests and requeue them. */
+	rc = blkfront_setup_indirect(info);
+	if (rc) {
+		kfree(copy);
+		return rc;
+	}
+
+	segs = info->max_indirect_segments ? : BLKIF_MAX_SEGMENTS_PER_REQUEST;
+	blk_queue_max_segments(info->rq, segs);
+	bio_list_init(&bio_list);
+	INIT_LIST_HEAD(&requests);
 	for (i = 0; i < BLK_RING_SIZE; i++) {
 		/* Not in use? */
 		if (!copy[i].request)
 			continue;
 
-		/* Grab a request slot and copy shadow state into it. */
-		req = RING_GET_REQUEST(&info->ring, info->ring.req_prod_pvt);
-		*req = copy[i].req;
-
-		/* We get a new request id, and must reset the shadow state. */
-		req->u.rw.id = get_id_from_freelist(info);
-		memcpy(&info->shadow[req->u.rw.id], &copy[i], sizeof(copy[i]));
-
-		if (req->operation != BLKIF_OP_DISCARD) {
-		/* Rewrite any grant references invalidated by susp/resume. */
-			for (j = 0; j < req->u.rw.nr_segments; j++)
-				gnttab_grant_foreign_access_ref(
-					req->u.rw.seg[j].gref,
-					info->xbdev->otherend_id,
-					pfn_to_mfn(copy[i].grants_used[j]->pfn),
-					0);
+		/*
+		 * Get the bios in the request so we can re-queue them.
+		 */
+		if (copy[i].request->cmd_flags &
+		    (REQ_FLUSH | REQ_FUA | REQ_DISCARD | REQ_SECURE)) {
+			/*
+			 * Flush operations don't contain bios, so
+			 * we need to requeue the whole request
+			 */
+			list_add(&copy[i].request->queuelist, &requests);
+			continue;
 		}
-		info->shadow[req->u.rw.id].req = *req;
-
-		info->ring.req_prod_pvt++;
+		merge_bio.head = copy[i].request->bio;
+		merge_bio.tail = copy[i].request->biotail;
+		bio_list_merge(&bio_list, &merge_bio);
+		copy[i].request->bio = NULL;
+		blk_put_request(copy[i].request);
 	}
 
 	kfree(copy);
 
+	/*
+	 * Empty the queue, this is important because we might have
+	 * requests in the queue with more segments than what we
+	 * can handle now.
+	 */
+	spin_lock_irq(&info->io_lock);
+	while ((req = blk_fetch_request(info->rq)) != NULL) {
+		if (req->cmd_flags &
+		    (REQ_FLUSH | REQ_FUA | REQ_DISCARD | REQ_SECURE)) {
+			list_add(&req->queuelist, &requests);
+			continue;
+		}
+		merge_bio.head = req->bio;
+		merge_bio.tail = req->biotail;
+		bio_list_merge(&bio_list, &merge_bio);
+		req->bio = NULL;
+		if (req->cmd_flags & (REQ_FLUSH | REQ_FUA))
+			pr_alert("diskcache flush request found!\n");
+		__blk_put_request(info->rq, req);
+	}
+	spin_unlock_irq(&info->io_lock);
+
 	xenbus_switch_state(info->xbdev, XenbusStateConnected);
 
 	spin_lock_irq(&info->io_lock);
@@ -1281,14 +1506,50 @@ static int blkif_recover(struct blkfront_info *info)
 	/* Now safe for us to use the shared ring */
 	info->connected = BLKIF_STATE_CONNECTED;
 
-	/* Send off requeued requests */
-	flush_requests(info);
-
 	/* Kick any other new requests queued since we resumed */
 	kick_pending_request_queues(info);
 
+	list_for_each_entry_safe(req, n, &requests, queuelist) {
+		/* Requeue pending requests (flush or discard) */
+		list_del_init(&req->queuelist);
+		BUG_ON(req->nr_phys_segments > segs);
+		blk_requeue_request(info->rq, req);
+	}
 	spin_unlock_irq(&info->io_lock);
 
+	while ((bio = bio_list_pop(&bio_list)) != NULL) {
+		/* Traverse the list of pending bios and re-queue them */
+		if (bio_segments(bio) > segs) {
+			/*
+			 * This bio has more segments than what we can
+			 * handle, we have to split it.
+			 */
+			pending = (bio_segments(bio) + segs - 1) / segs;
+			split_bio = kzalloc(sizeof(*split_bio), GFP_NOIO);
+			BUG_ON(split_bio == NULL);
+			atomic_set(&split_bio->pending, pending);
+			split_bio->bio = bio;
+			for (i = 0; i < pending; i++) {
+				offset = (i * segs * PAGE_SIZE) >> 9;
+				size = MIN((segs * PAGE_SIZE) >> 9,
+				           (bio->bi_size >> 9) - offset);
+				cloned_bio = bio_clone(bio, GFP_NOIO);
+				BUG_ON(cloned_bio == NULL);
+				trim_bio(cloned_bio, offset, size);
+				cloned_bio->bi_private = split_bio;
+				cloned_bio->bi_end_io = split_bio_end;
+				submit_bio(cloned_bio->bi_rw, cloned_bio);
+			}
+			/*
+			 * Now we have to wait for all those smaller bios to
+			 * end, so we can also end the "parent" bio.
+			 */
+			continue;
+		}
+		/* We don't need to split this bio */
+		submit_bio(bio->bi_rw, bio);
+	}
+
 	return 0;
 }
 
@@ -1308,8 +1569,12 @@ static int blkfront_resume(struct xenbus_device *dev)
 	blkif_free(info, info->connected == BLKIF_STATE_CONNECTED);
 
 	err = talk_to_blkback(dev, info);
-	if (info->connected == BLKIF_STATE_SUSPENDED && !err)
-		err = blkif_recover(info);
+
+	/*
+	 * We have to wait for the backend to switch to
+	 * connected state, since we want to read which
+	 * features it supports.
+	 */
 
 	return err;
 }
@@ -1387,6 +1652,62 @@ static void blkfront_setup_discard(struct blkfront_info *info)
 	kfree(type);
 }
 
+static int blkfront_setup_indirect(struct blkfront_info *info)
+{
+	unsigned int indirect_segments, segs;
+	int err, i;
+
+	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
+			    "max-indirect-segments", "%u", &indirect_segments,
+			    NULL);
+	if (err) {
+		info->max_indirect_segments = 0;
+		segs = BLKIF_MAX_SEGMENTS_PER_REQUEST;
+	} else {
+		info->max_indirect_segments = MIN(indirect_segments,
+		                                  xen_blkif_max_segments);
+		segs = info->max_indirect_segments;
+	}
+	info->sg = kzalloc(sizeof(info->sg[0]) * segs, GFP_KERNEL);
+	if (info->sg == NULL)
+		goto out_of_memory;
+	sg_init_table(info->sg, segs);
+
+	err = fill_grant_buffer(info,
+	                        (segs + INDIRECT_GREFS(segs)) * BLK_RING_SIZE);
+	if (err)
+		goto out_of_memory;
+
+	for (i = 0; i < BLK_RING_SIZE; i++) {
+		info->shadow[i].grants_used = kzalloc(
+			sizeof(info->shadow[i].grants_used[0]) * segs,
+			GFP_NOIO);
+		if (info->max_indirect_segments)
+			info->shadow[i].indirect_grants = kzalloc(
+				sizeof(info->shadow[i].indirect_grants[0]) *
+				INDIRECT_GREFS(segs),
+				GFP_NOIO);
+		if ((info->shadow[i].grants_used == NULL) ||
+		     (info->max_indirect_segments &&
+		     (info->shadow[i].indirect_grants == NULL)))
+			goto out_of_memory;
+	}
+
+
+	return 0;
+
+out_of_memory:
+	kfree(info->sg);
+	info->sg = NULL;
+	for (i = 0; i < BLK_RING_SIZE; i++) {
+		kfree(info->shadow[i].grants_used);
+		info->shadow[i].grants_used = NULL;
+		kfree(info->shadow[i].indirect_grants);
+		info->shadow[i].indirect_grants = NULL;
+	}
+	return -ENOMEM;
+}
+
 /*
  * Invoked when the backend is finally 'ready' (and has told produced
  * the details about the physical device - #sectors, size, etc).
@@ -1414,8 +1735,9 @@ static void blkfront_connect(struct blkfront_info *info)
 		set_capacity(info->gd, sectors);
 		revalidate_disk(info->gd);
 
-		/* fall through */
+		return;
 	case BLKIF_STATE_SUSPENDED:
+		blkif_recover(info);
 		return;
 
 	default:
@@ -1436,6 +1758,7 @@ static void blkfront_connect(struct blkfront_info *info)
 				 info->xbdev->otherend);
 		return;
 	}
+	info->sector_size = sector_size;
 
 	info->feature_flush = 0;
 	info->flush_op = 0;
@@ -1483,6 +1806,13 @@ static void blkfront_connect(struct blkfront_info *info)
 	else
 		info->feature_persistent = persistent;
 
+	err = blkfront_setup_indirect(info);
+	if (err) {
+		xenbus_dev_fatal(info->xbdev, err, "setup_indirect at %s",
+				 info->xbdev->otherend);
+		return;
+	}
+
 	err = xlvbd_alloc_gendisk(sectors, info, binfo, sector_size);
 	if (err) {
 		xenbus_dev_fatal(info->xbdev, err, "xlvbd_add at %s",
diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index ffd4652..893bee2 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -102,6 +102,8 @@ typedef uint64_t blkif_sector_t;
  */
 #define BLKIF_OP_DISCARD           5
 
+#define BLKIF_OP_INDIRECT          6
+
 /*
  * Maximum scatter/gather segments per request.
  * This is carefully chosen so that sizeof(struct blkif_ring) <= PAGE_SIZE.
@@ -109,6 +111,16 @@ typedef uint64_t blkif_sector_t;
  */
 #define BLKIF_MAX_SEGMENTS_PER_REQUEST 11
 
+#define BLKIF_MAX_INDIRECT_GREFS_PER_REQUEST 8
+
+struct blkif_request_segment_aligned {
+	grant_ref_t gref;        /* reference to I/O buffer frame        */
+	/* @first_sect: first sector in frame to transfer (inclusive).   */
+	/* @last_sect: last sector in frame to transfer (inclusive).     */
+	uint8_t     first_sect, last_sect;
+	uint16_t    _pad; /* padding to make it 8 bytes, so it's cache-aligned */
+} __attribute__((__packed__));
+
 struct blkif_request_rw {
 	uint8_t        nr_segments;  /* number of segments                   */
 	blkif_vdev_t   handle;       /* only for read/write requests         */
@@ -147,12 +159,26 @@ struct blkif_request_other {
 	uint64_t     id;           /* private guest value, echoed in resp  */
 } __attribute__((__packed__));
 
+struct blkif_request_indirect {
+	uint8_t        indirect_op;
+	uint16_t       nr_segments;
+#ifdef CONFIG_X86_64
+	uint32_t       _pad1;        /* offsetof(blkif_...,u.indirect.id) == 8 */
+#endif
+	uint64_t       id;
+	blkif_sector_t sector_number;
+	blkif_vdev_t   handle;
+	uint16_t       _pad2;
+	grant_ref_t    indirect_grefs[BLKIF_MAX_INDIRECT_GREFS_PER_REQUEST];
+} __attribute__((__packed__));
+
 struct blkif_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
 	union {
 		struct blkif_request_rw rw;
 		struct blkif_request_discard discard;
 		struct blkif_request_other other;
+		struct blkif_request_indirect indirect;
 	} u;
 } __attribute__((__packed__));
 
-- 
1.7.7.5 (Apple Git-26)

