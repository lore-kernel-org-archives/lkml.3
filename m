Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaGHAi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:38:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaGGXyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilya Dryomov <ilya.dryomov@inktank.com>,
        Josh Durgin <josh.durgin@inktank.com>
Subject: [PATCH 3.14 47/94] rbd: handle parent_overlap on writes correctly
Date: Mon,  7 Jul 2014 16:57:37 -0700
Message-Id: <20140707235758.179337069@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1366,6 +1366,14 @@ static bool obj_request_exists_test(stru
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
@@ -2656,7 +2664,7 @@ static int rbd_img_obj_request_submit(st
 	 */
 	if (!img_request_write_test(img_request) ||
 		!img_request_layered_test(img_request) ||
-		rbd_dev->parent_overlap <= obj_request->img_offset ||
+		!obj_request_overlaps_parent(obj_request) ||
 		((known = obj_request_known_test(obj_request)) &&
 			obj_request_exists_test(obj_request))) {
 


