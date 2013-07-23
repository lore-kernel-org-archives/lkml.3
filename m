Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935197Ab3GWWgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:36:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934821Ab3GWW1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        YoungJun Cho <yj44.cho@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 081/103] drm/gem: fix not to assign error value to gem name
Date: Tue, 23 Jul 2013 15:26:32 -0700
Message-Id: <20130723220429.411000534@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YoungJun Cho <yj44.cho@samsung.com>

commit 2e07fb229396f99fc173d8612f0f83ea9de0341b upstream.

If idr_alloc() is failed, obj->name can be error value. Also
it cleans up duplicated flink processing code.

This regression has been introduced in

commit 2e928815c1886fe628ed54623aa98d0889cf5509
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Feb 27 17:04:08 2013 -0800

    drm: convert to idr_alloc()

Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_gem.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -453,25 +453,21 @@ drm_gem_flink_ioctl(struct drm_device *d
 	spin_lock(&dev->object_name_lock);
 	if (!obj->name) {
 		ret = idr_alloc(&dev->object_name_idr, obj, 1, 0, GFP_NOWAIT);
-		obj->name = ret;
-		args->name = (uint64_t) obj->name;
-		spin_unlock(&dev->object_name_lock);
-		idr_preload_end();
-
 		if (ret < 0)
 			goto err;
-		ret = 0;
+
+		obj->name = ret;
 
 		/* Allocate a reference for the name table.  */
 		drm_gem_object_reference(obj);
-	} else {
-		args->name = (uint64_t) obj->name;
-		spin_unlock(&dev->object_name_lock);
-		idr_preload_end();
-		ret = 0;
 	}
 
+	args->name = (uint64_t) obj->name;
+	ret = 0;
+
 err:
+	spin_unlock(&dev->object_name_lock);
+	idr_preload_end();
 	drm_gem_object_unreference_unlocked(obj);
 	return ret;
 }


