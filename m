Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaAMQEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:04:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53417 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbaAMQDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Durgin <josh.durgin@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 127/208] rbd: make rbd_obj_notify_ack() synchronous
Date: Mon, 13 Jan 2014 15:59:28 +0000
Message-Id: <1389628849-1614-128-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit 20e0af67ce88c657d0601977b9941a2256afbdaa upstream.

The only user of rbd_obj_notify_ack() is rbd_watch_cb(). It used
asynchronously with no tracking of when the notify ack completes, so
it may still be in progress when the osd_client is shut down.  This
results in a BUG() since the osd client assumes no requests are in
flight when it stops. Since all notifies are flushed before the
osd_client is stopped, waiting for the notify ack to complete before
returning from the watch callback ensures there are no notify acks in
flight during shutdown.

Rename rbd_obj_notify_ack() to rbd_obj_notify_ack_sync() to reflect
its new synchronous nature.

Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 16f6966..d88a27d 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2808,7 +2808,7 @@ out_err:
 	obj_request_done_set(obj_request);
 }
 
-static int rbd_obj_notify_ack(struct rbd_device *rbd_dev, u64 notify_id)
+static int rbd_obj_notify_ack_sync(struct rbd_device *rbd_dev, u64 notify_id)
 {
 	struct rbd_obj_request *obj_request;
 	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
@@ -2823,16 +2823,17 @@ static int rbd_obj_notify_ack(struct rbd_device *rbd_dev, u64 notify_id)
 	obj_request->osd_req = rbd_osd_req_create(rbd_dev, false, obj_request);
 	if (!obj_request->osd_req)
 		goto out;
-	obj_request->callback = rbd_obj_request_put;
 
 	osd_req_op_watch_init(obj_request->osd_req, 0, CEPH_OSD_OP_NOTIFY_ACK,
 					notify_id, 0, 0);
 	rbd_osd_req_format_read(obj_request);
 
 	ret = rbd_obj_request_submit(osdc, obj_request);
-out:
 	if (ret)
-		rbd_obj_request_put(obj_request);
+		goto out;
+	ret = rbd_obj_request_wait(obj_request);
+out:
+	rbd_obj_request_put(obj_request);
 
 	return ret;
 }
@@ -2852,7 +2853,7 @@ static void rbd_watch_cb(u64 ver, u64 notify_id, u8 opcode, void *data)
 	if (ret)
 		rbd_warn(rbd_dev, "header refresh error (%d)\n", ret);
 
-	rbd_obj_notify_ack(rbd_dev, notify_id);
+	rbd_obj_notify_ack_sync(rbd_dev, notify_id);
 }
 
 /*
-- 
1.8.3.2

