Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3C0NME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:12:04 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44316 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab3C0NJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 09/17] drbd: only fail empty flushes if no good data is reachable
Date: Wed, 27 Mar 2013 14:08:41 +0100
Message-Id: <1364389729-17559-10-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

We completed empty flushes (blkdev_issue_flush()) with IO error
if we lost the local disk, even if we still have an established
replication link to a healthy remote disk.

Fix this to only report errors to upper layers,
if neither local nor remote data is reachable.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |   12 ++++++++----
 drivers/block/drbd/drbd_req.h |    8 ++++++++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 9f7ff1c..beefe65 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -263,8 +263,7 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 		else
 			root = &mdev->read_requests;
 		drbd_remove_request_interval(root, req);
-	} else if (!(s & RQ_POSTPONED))
-		D_ASSERT((s & (RQ_NET_MASK & ~RQ_NET_DONE)) == 0);
+	}
 
 	/* Before we can signal completion to the upper layers,
 	 * we may need to close the current transfer log epoch.
@@ -755,6 +754,11 @@ int __req_mod(struct drbd_request *req, enum drbd_req_event what,
 		D_ASSERT(req->rq_state & RQ_NET_PENDING);
 		mod_rq_state(req, m, RQ_NET_PENDING, RQ_NET_OK|RQ_NET_DONE);
 		break;
+
+	case QUEUE_AS_DRBD_BARRIER:
+		start_new_tl_epoch(mdev->tconn);
+		mod_rq_state(req, m, 0, RQ_NET_OK|RQ_NET_DONE);
+		break;
 	};
 
 	return rv;
@@ -975,8 +979,8 @@ static int drbd_process_write_request(struct drbd_request *req)
 		/* The only size==0 bios we expect are empty flushes. */
 		D_ASSERT(req->master_bio->bi_rw & REQ_FLUSH);
 		if (remote)
-			start_new_tl_epoch(mdev->tconn);
-		return 0;
+			_req_mod(req, QUEUE_AS_DRBD_BARRIER);
+		return remote;
 	}
 
 	if (!remote && !send_oos)
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index c08d229..978cb1a 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -88,6 +88,14 @@ enum drbd_req_event {
 	QUEUE_FOR_NET_READ,
 	QUEUE_FOR_SEND_OOS,
 
+	/* An empty flush is queued as P_BARRIER,
+	 * which will cause it to complete "successfully",
+	 * even if the local disk flush failed.
+	 *
+	 * Just like "real" requests, empty flushes (blkdev_issue_flush()) will
+	 * only see an error if neither local nor remote data is reachable. */
+	QUEUE_AS_DRBD_BARRIER,
+
 	SEND_CANCELED,
 	SEND_FAILED,
 	HANDED_OVER_TO_NETWORK,
-- 
1.7.9.5

