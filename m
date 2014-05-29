Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349AbaE2OWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:22:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59314 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933147AbaE2Nta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ilya Dryomov <ilya.dryomov@inktank.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 026/103] rbd: fix error paths in rbd_img_request_fill()
Date: Thu, 29 May 2014 15:48:11 +0200
Message-Id: <6319dbe1fba8a83813b672db8cc4fe4a70906fbd.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilya Dryomov <ilya.dryomov@inktank.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index cb1db2979d3d..db60c91804c3 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2272,7 +2272,7 @@ out_partial:
 	rbd_obj_request_put(obj_request);
 out_unwind:
 	for_each_obj_request_safe(img_request, obj_request, next_obj_request)
-		rbd_obj_request_put(obj_request);
+		rbd_img_obj_request_del(img_request, obj_request);
 
 	return -ENOMEM;
 }
-- 
1.9.3

