Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaAMQdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:33:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53401 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbaAMQDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Durgin <josh.durgin@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 123/208] rbd: fix buffer size for writes to images with snapshots
Date: Mon, 13 Jan 2014 15:59:24 +0000
Message-Id: <1389628849-1614-124-git-send-email-luis.henriques@canonical.com>
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

commit 03507db631c94a48e316c7f638ffb2991544d617 upstream.

rbd_osd_req_create() needs to know the snapshot context size to create
a buffer large enough to send it with the message front. It gets this
from the img_request, which was not set for the obj_request yet. This
resulted in trying to write past the end of the front payload, hitting
this BUG:

libceph: BUG_ON(p > msg->front.iov_base + msg->front.iov_len);

Fix this by associating the obj_request with its img_request
immediately after it's created, before the osd request is created.

Fixes: http://tracker.ceph.com/issues/5760
Suggested-by: Alex Elder <alex.elder@linaro.org>
Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Alex Elder <alex.elder@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 45aa20a..0ab2829 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2203,6 +2203,11 @@ static int rbd_img_request_fill(struct rbd_img_request *img_request,
 		rbd_segment_name_free(object_name);
 		if (!obj_request)
 			goto out_unwind;
+		/*
+		 * set obj_request->img_request before creating the
+		 * osd_request so that it gets the right snapc
+		 */
+		rbd_img_obj_request_add(img_request, obj_request);
 
 		if (type == OBJ_REQUEST_BIO) {
 			unsigned int clone_size;
@@ -2244,11 +2249,6 @@ static int rbd_img_request_fill(struct rbd_img_request *img_request,
 					obj_request->pages, length,
 					offset & ~PAGE_MASK, false, false);
 
-		/*
-		 * set obj_request->img_request before formatting
-		 * the osd_request so that it gets the right snapc
-		 */
-		rbd_img_obj_request_add(img_request, obj_request);
 		if (write_request)
 			rbd_osd_req_format_write(obj_request);
 		else
-- 
1.8.3.2

