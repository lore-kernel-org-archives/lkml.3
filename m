Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbaE2Fj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:39:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbaE2Eeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Alex Elder <elder@linaro.org>
Subject: [PATCH 3.14 015/140] rbd: fix error paths in rbd_img_request_fill()
Date: Wed, 28 May 2014 21:32:34 -0700
Message-Id: <20140529043051.261098590@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2253,7 +2253,7 @@ out_partial:
 	rbd_obj_request_put(obj_request);
 out_unwind:
 	for_each_obj_request_safe(img_request, obj_request, next_obj_request)
-		rbd_obj_request_put(obj_request);
+		rbd_img_obj_request_del(img_request, obj_request);
 
 	return -ENOMEM;
 }


