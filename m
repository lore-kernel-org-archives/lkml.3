Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbaFCLk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:40:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43406 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbaFCLkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 042/138] rbd: fix error paths in rbd_img_request_fill()
Date: Tue,  3 Jun 2014 12:38:08 +0100
Message-Id: <1401795584-22664-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <ilya.dryomov@inktank.com>

commit 42dd037c08c7cd6e3e9af7824b0c1d063f838885 upstream.

Doing rbd_obj_request_put() in rbd_img_request_fill() error paths is
not only insufficient, but also triggers an rbd_assert() in
rbd_obj_request_destroy():

    Assertion failure in rbd_obj_request_destroy() at line 1867:

    rbd_assert(obj_request->img_request == NULL);

rbd_img_obj_request_add() adds obj_requests to the img_request, the
opposite is rbd_img_obj_request_del().  Use it.

Fixes: http://tracker.ceph.com/issues/7327

Signed-off-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 1af45c286501..eebf3d6ec8db 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2268,7 +2268,7 @@ out_partial:
 	rbd_obj_request_put(obj_request);
 out_unwind:
 	for_each_obj_request_safe(img_request, obj_request, next_obj_request)
-		rbd_obj_request_put(obj_request);
+		rbd_img_obj_request_del(img_request, obj_request);
 
 	return -ENOMEM;
 }
-- 
1.9.1

