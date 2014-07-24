Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934953AbaGXJvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:51:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55227 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934868AbaGXJtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 125/128] rbd: use reference counts for image requests
Date: Thu, 24 Jul 2014 10:46:14 +0100
Message-Id: <1406195177-8656-126-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@linaro.org>

commit 0f2d5be792b0466b06797f637cfbb0f64dbb408c upstream.

Each image request contains a reference count, but to date it has
not actually been used.  (I think this was just an oversight.) A
recent report involving rbd failing an assertion shed light on why
and where we need to use these reference counts.

Every OSD request associated with an object request uses
rbd_osd_req_callback() as its callback function.  That function will
call a helper function (dependent on the type of OSD request) that
will set the object request's "done" flag if the object request if
appropriate.  If that "done" flag is set, the object request is
passed to rbd_obj_request_complete().

In rbd_obj_request_complete(), requests are processed in sequential
order.  So if an object request completes before one of its
predecessors in the image request, the completion is deferred.
Otherwise, if it's a completing object's "turn" to be completed, it
is passed to rbd_img_obj_end_request(), which records the result of
the operation, accumulates transferred bytes, and so on.  Next, the
successor to this request is checked and if it is marked "done",
(deferred) completion processing is performed on that request, and
so on.  If the last object request in an image request is completed,
rbd_img_request_complete() is called, which (typically) destroys
the image request.

There is a race here, however.  The instant an object request is
marked "done" it can be provided (by a thread handling completion of
one of its predecessor operations) to rbd_img_obj_end_request(),
which (for the last request) can then lead to the image request
getting torn down.  And this can happen *before* that object has
itself entered rbd_img_obj_end_request().  As a result, once it
*does* enter that function, the image request (and even the object
request itself) may have been freed and become invalid.

All that's necessary to avoid this is to properly count references
to the image requests.  We tear down an image request's object
requests all at once--only when the entire image request has
completed.  So there's no need for an image request to count
references for its object requests.  However, we don't want an
image request to go away until the last of its object requests
has passed through rbd_img_obj_callback().  In other words,
we don't want rbd_img_request_complete() to necessarily
result in the image request being destroyed, because it may
get called before we've finished processing on all of its
object requests.

So the fix is to add a reference to an image request for
each of its object requests.  The reference can be viewed
as representing an object request that has not yet finished
its call to rbd_img_obj_callback().  That is emphasized by
getting the reference right after assigning that as the image
object's callback function.  The corresponding release of that
reference is done at the end of rbd_img_obj_callback(), which
every image object request passes through exactly once.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index cabe12e8390b..9568cacdd6a4 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1399,6 +1399,13 @@ static void rbd_obj_request_put(struct rbd_obj_request *obj_request)
 	kref_put(&obj_request->kref, rbd_obj_request_destroy);
 }
 
+static void rbd_img_request_get(struct rbd_img_request *img_request)
+{
+	dout("%s: img %p (was %d)\n", __func__, img_request,
+	     atomic_read(&img_request->kref.refcount));
+	kref_get(&img_request->kref);
+}
+
 static bool img_request_child_test(struct rbd_img_request *img_request);
 static void rbd_parent_request_destroy(struct kref *kref);
 static void rbd_img_request_destroy(struct kref *kref);
@@ -2152,6 +2159,7 @@ static void rbd_img_obj_callback(struct rbd_obj_request *obj_request)
 	img_request->next_completion = which;
 out:
 	spin_unlock_irq(&img_request->completion_lock);
+	rbd_img_request_put(img_request);
 
 	if (!more)
 		rbd_img_request_complete(img_request);
@@ -2248,6 +2256,7 @@ static int rbd_img_request_fill(struct rbd_img_request *img_request,
 			goto out_partial;
 		obj_request->osd_req = osd_req;
 		obj_request->callback = rbd_img_obj_callback;
+		rbd_img_request_get(img_request);
 
 		osd_req_op_extent_init(osd_req, 0, opcode, offset, length,
 						0, 0);
-- 
1.9.1

