Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaENO6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:58:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42721 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbaENO6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:58:47 -0400
Subject: [RFC PATCH v1 14/16] drm/radeon: use rcu waits in some ioctls
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Date: Wed, 14 May 2014 16:58:45 +0200
Message-ID: <20140514145845.21163.15680.stgit@patser>
In-Reply-To: <20140514145134.21163.32350.stgit@patser>
References: <20140514145134.21163.32350.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_gem.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gem.c b/drivers/gpu/drm/radeon/radeon_gem.c
index d09650c1d720..7ba883843668 100644
--- a/drivers/gpu/drm/radeon/radeon_gem.c
+++ b/drivers/gpu/drm/radeon/radeon_gem.c
@@ -107,9 +107,12 @@ static int radeon_gem_set_domain(struct drm_gem_object *gobj,
 	}
 	if (domain == RADEON_GEM_DOMAIN_CPU) {
 		/* Asking for cpu access wait for object idle */
-		r = radeon_bo_wait(robj, NULL, false);
-		if (r) {
-			printk(KERN_ERR "Failed to wait for object !\n");
+		r = reservation_object_wait_timeout_rcu(robj->tbo.resv, true, true, 30 * HZ);
+		if (!r)
+			r = -EBUSY;
+
+		if (r < 0 && r != -EINTR) {
+			printk(KERN_ERR "Failed to wait for object: %i\n", r);
 			return r;
 		}
 	}
@@ -357,14 +360,20 @@ int radeon_gem_wait_idle_ioctl(struct drm_device *dev, void *data,
 	struct drm_radeon_gem_wait_idle *args = data;
 	struct drm_gem_object *gobj;
 	struct radeon_bo *robj;
-	int r;
+	int r = 0;
+	long ret;
 
 	gobj = drm_gem_object_lookup(dev, filp, args->handle);
 	if (gobj == NULL) {
 		return -ENOENT;
 	}
 	robj = gem_to_radeon_bo(gobj);
-	r = radeon_bo_wait(robj, NULL, false);
+	ret = reservation_object_wait_timeout_rcu(robj->tbo.resv, true, true, 30 * HZ);
+	if (ret == 0)
+		r = -EBUSY;
+	else if (ret < 0)
+		r = ret;
+
 	/* callback hw specific functions if any */
 	if (rdev->asic->ioctl_wait_idle)
 		robj->rdev->asic->ioctl_wait_idle(rdev, robj);

