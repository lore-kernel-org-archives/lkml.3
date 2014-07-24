Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935458AbaGXKXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:23:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54681 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758814AbaGXJrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 025/128] rbd: handle parent_overlap on writes correctly
Date: Thu, 24 Jul 2014 10:44:34 +0100
Message-Id: <1406195177-8656-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <ilya.dryomov@inktank.com>

commit 9638556a276125553549fdfe349c464481ec2f39 upstream.

The following check in rbd_img_obj_request_submit()

    rbd_dev->parent_overlap <= obj_request->img_offset

allows the fall through to the non-layered write case even if both
parent_overlap and obj_request->img_offset belong to the same RADOS
object.  This leads to data corruption, because the area to the left of
parent_overlap ends up unconditionally zero-filled instead of being
populated with parent data.  Suppose we want to write 1M to offset 6M
of image bar, which is a clone of foo@snap; object_size is 4M,
parent_overlap is 5M:

    rbd_data.<id>.0000000000000001
     ---------------------|----------------------|------------
    | should be copyup'ed | should be zeroed out | write ...
     ---------------------|----------------------|------------
   4M                    5M                     6M
                    parent_overlap    obj_request->img_offset

4..5M should be copyup'ed from foo, yet it is zero-filled, just like
5..6M is.

Given that the only striping mode kernel client currently supports is
chunking (i.e. stripe_unit == object_size, stripe_count == 1), round
parent_overlap up to the next object boundary for the purposes of the
overlap check.

Signed-off-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Reviewed-by: Josh Durgin <josh.durgin@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index eebf3d6ec8db..cabe12e8390b 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1375,6 +1375,14 @@ static bool obj_request_exists_test(struct rbd_obj_request *obj_request)
 	return test_bit(OBJ_REQ_EXISTS, &obj_request->flags) != 0;
 }
 
+static bool obj_request_overlaps_parent(struct rbd_obj_request *obj_request)
+{
+	struct rbd_device *rbd_dev = obj_request->img_request->rbd_dev;
+
+	return obj_request->img_offset <
+	    round_up(rbd_dev->parent_overlap, rbd_obj_bytes(&rbd_dev->header));
+}
+
 static void rbd_obj_request_get(struct rbd_obj_request *obj_request)
 {
 	dout("%s: obj %p (was %d)\n", __func__, obj_request,
@@ -2662,7 +2670,7 @@ static int rbd_img_obj_request_submit(struct rbd_obj_request *obj_request)
 	 */
 	if (!img_request_write_test(img_request) ||
 		!img_request_layered_test(img_request) ||
-		rbd_dev->parent_overlap <= obj_request->img_offset ||
+		!obj_request_overlaps_parent(obj_request) ||
 		((known = obj_request_known_test(obj_request)) &&
 			obj_request_exists_test(obj_request))) {
 
-- 
1.9.1

