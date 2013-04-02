Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415Ab3DBXRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:17:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab3DBWMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 027/124] xen/blkback: correctly respond to unknown, non-native requests
Date: Tue,  2 Apr 2013 15:10:09 -0700
Message-Id: <20130402221107.317022749@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 0e367ae46503cfe7791460c8ba8434a5d60b2bd5 upstream.

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
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/xen-blkback/blkback.c |   31 +++++++++++++++++++++++++++----
 drivers/block/xen-blkback/common.h  |   25 +++++++++++++++++++++++++
 include/xen/interface/io/blkif.h    |   10 ++++++++++
 3 files changed, 62 insertions(+), 4 deletions(-)

--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -679,6 +679,16 @@ static int dispatch_discard_io(struct xe
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
@@ -800,17 +810,30 @@ __do_block_io_op(struct xen_blkif *blkif
 
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
 			break;
+		default:
+			if (dispatch_other_io(blkif, &req, pending_req))
+				goto done;
+			break;
+		}
 
 		/* Yield point for this unbounded loop. */
 		cond_resched();
 	}
-
+done:
 	return more_to_do;
 }
 
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -77,11 +77,18 @@ struct blkif_x86_32_request_discard {
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
 
@@ -113,11 +120,19 @@ struct blkif_x86_64_request_discard {
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
 
@@ -278,6 +293,11 @@ static inline void blkif_get_x86_32_req(
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
@@ -309,6 +329,11 @@ static inline void blkif_get_x86_64_req(
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
 


