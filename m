Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030692AbaGRNLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:11:52 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17583 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761806AbaGRNLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:11:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ilya Dryomov <ilya.dryomov@inktank.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 094/170] rbd: handle parent_overlap on writes correctly
Date: Fri, 18 Jul 2014 14:11:39 +0200
Message-Id: <a355e863488c27d3afcad4eaf805ebdd5f6a6752.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilya Dryomov <ilya.dryomov@inktank.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/rbd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index af7b44ffd190..aeeb62e0981a 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1379,6 +1379,14 @@ static bool obj_request_exists_test(struct rbd_obj_request *obj_request)
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
@@ -2675,7 +2683,7 @@ static int rbd_img_obj_request_submit(struct rbd_obj_request *obj_request)
 	 */
 	if (!img_request_write_test(img_request) ||
 		!img_request_layered_test(img_request) ||
-		rbd_dev->parent_overlap <= obj_request->img_offset ||
+		!obj_request_overlaps_parent(obj_request) ||
 		((known = obj_request_known_test(obj_request)) &&
 			obj_request_exists_test(obj_request))) {
 
-- 
2.0.0

