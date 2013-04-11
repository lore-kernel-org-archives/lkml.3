Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422669Ab3DKVCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:02:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935759Ab3DKUtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:18 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=626yYgrjiasA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=am4ONh6etqsA:10 a=tHz9FfFoAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=JcQFdGsVJVlXZi1lAFUA:9 a=6O0IECtVFhoA:10 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202601.539190646@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 094/171 ] xen/blkback: correctly respond to unknown, non-native requests
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0094-xen-blkback-correctly-respond-to-unknown-non-native-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

[ Upstream commit 0e367ae46503cfe7791460c8ba8434a5d60b2bd5 ]

If the frontend is using a non-native protocol (e.g., a 64-bit
frontend with a 32-bit backend) and it sent an unrecognized request,
the request was not translated and the response would have the
incorrect ID.  This may cause the frontend driver to behave
incorrectly or crash.

Since the ID field in the request is always in the same place,
regardless of the request type we can get the correct ID and make a
valid response (which will report BLKIF_RSP_EOPNOTSUPP).

This bug affected 64-bit SLES 11 guests when using a 32-bit backend.
This guest does a BLKIF_OP_RESERVED_1 (BLKIF_OP_PACKET in the SLES
source) and would crash in blkif_int() as the ID in the response would
be invalid.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: stable@vger.kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/block/xen-blkback/blkback.c |   31 +++++++++++++++++++++++++++----
 drivers/block/xen-blkback/common.h  |   25 +++++++++++++++++++++++++
 include/xen/interface/io/blkif.h    |   10 ++++++++++
 3 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index c6decb9..c85d91a 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -422,6 +422,16 @@ static int dispatch_discard_io(struct xen_blkif *blkif,
 	return err;
 }
 
+static int dispatch_other_io(struct xen_blkif *blkif,
+			     struct blkif_request *req,
+			     struct pending_req *pending_req)
+{
+	free_req(pending_req);
+	make_response(blkif, req->u.other.id, req->operation,
+		      BLKIF_RSP_EOPNOTSUPP);
+	return -EIO;
+}
+
 static void xen_blk_drain_io(struct xen_blkif *blkif)
 {
 	atomic_set(&blkif->drain, 1);
@@ -543,17 +553,30 @@ __do_block_io_op(struct xen_blkif *blkif)
 
 		/* Apply all sanity checks to /private copy/ of request. */
 		barrier();
-		if (unlikely(req.operation == BLKIF_OP_DISCARD)) {
+
+		switch (req.operation) {
+		case BLKIF_OP_READ:
+		case BLKIF_OP_WRITE:
+		case BLKIF_OP_WRITE_BARRIER:
+		case BLKIF_OP_FLUSH_DISKCACHE:
+			if (dispatch_rw_block_io(blkif, &req, pending_req))
+				goto done;
+			break;
+		case BLKIF_OP_DISCARD:
 			free_req(pending_req);
 			if (dispatch_discard_io(blkif, &req))
-				break;
-		} else if (dispatch_rw_block_io(blkif, &req, pending_req))
+				goto done;
+			break;
+		default:
+			if (dispatch_other_io(blkif, &req, pending_req))
+				goto done;
 			break;
+		}
 
 		/* Yield point for this unbounded loop. */
 		cond_resched();
 	}
-
+done:
 	return more_to_do;
 }
 
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 9ad3b5e..fc2a486 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -76,11 +76,18 @@ struct blkif_x86_32_request_discard {
 	uint64_t       nr_sectors;
 } __attribute__((__packed__));
 
+struct blkif_x86_32_request_other {
+	uint8_t        _pad1;
+	blkif_vdev_t   _pad2;
+	uint64_t       id;           /* private guest value, echoed in resp  */
+} __attribute__((__packed__));
+
 struct blkif_x86_32_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
 	union {
 		struct blkif_x86_32_request_rw rw;
 		struct blkif_x86_32_request_discard discard;
+		struct blkif_x86_32_request_other other;
 	} u;
 } __attribute__((__packed__));
 
@@ -112,11 +119,19 @@ struct blkif_x86_64_request_discard {
 	uint64_t       nr_sectors;
 } __attribute__((__packed__));
 
+struct blkif_x86_64_request_other {
+	uint8_t        _pad1;
+	blkif_vdev_t   _pad2;
+	uint32_t       _pad3;        /* offsetof(blkif_..,u.discard.id)==8   */
+	uint64_t       id;           /* private guest value, echoed in resp  */
+} __attribute__((__packed__));
+
 struct blkif_x86_64_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
 	union {
 		struct blkif_x86_64_request_rw rw;
 		struct blkif_x86_64_request_discard discard;
+		struct blkif_x86_64_request_other other;
 	} u;
 } __attribute__((__packed__));
 
@@ -262,6 +277,11 @@ static inline void blkif_get_x86_32_req(struct blkif_request *dst,
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;
 	default:
+		/*
+		 * Don't know how to translate this op. Only get the
+		 * ID so failure can be reported to the frontend.
+		 */
+		dst->u.other.id = src->u.other.id;
 		break;
 	}
 }
@@ -293,6 +313,11 @@ static inline void blkif_get_x86_64_req(struct blkif_request *dst,
 		dst->u.discard.nr_sectors = src->u.discard.nr_sectors;
 		break;
 	default:
+		/*
+		 * Don't know how to translate this op. Only get the
+		 * ID so failure can be reported to the frontend.
+		 */
+		dst->u.other.id = src->u.other.id;
 		break;
 	}
 }
diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
index ee338bf..2af8fdb 100644
--- a/include/xen/interface/io/blkif.h
+++ b/include/xen/interface/io/blkif.h
@@ -138,11 +138,21 @@ struct blkif_request_discard {
 	uint8_t        _pad3;
 } __attribute__((__packed__));
 
+struct blkif_request_other {
+	uint8_t      _pad1;
+	blkif_vdev_t _pad2;        /* only for read/write requests         */
+#ifdef CONFIG_X86_64
+	uint32_t     _pad3;        /* offsetof(blkif_req..,u.other.id)==8*/
+#endif
+	uint64_t     id;           /* private guest value, echoed in resp  */
+} __attribute__((__packed__));
+
 struct blkif_request {
 	uint8_t        operation;    /* BLKIF_OP_???                         */
 	union {
 		struct blkif_request_rw rw;
 		struct blkif_request_discard discard;
+		struct blkif_request_other other;
 	} u;
 } __attribute__((__packed__));
 
-- 
1.7.10.4


