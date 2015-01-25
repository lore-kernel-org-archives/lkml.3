Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbbAYS6J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:58:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57892 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbbAYSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 3.18 041/183] drm/i915: Disallow pin ioctl completely for kms drivers
Date: Sun, 25 Jan 2015 10:06:03 -0800
Message-Id: <20150125180811.962211985@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit d472fcc8379c062bd56a3876fc6ef22258f14a91 upstream.

The problem here is that SNA pins batchbuffers to etch out a bit more
performance. Iirc it started out as a w/a for i830M (which we've
implemented in the kernel since a long time already). The problem is
that the pin ioctl wasn't added in

commit d23db88c3ab233daed18709e3a24d6c95344117f
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri May 23 08:48:08 2014 +0200

    drm/i915: Prevent negative relocation deltas from wrapping

Fix this by simply disallowing pinning from userspace so that the
kernel is in full control of batch placement again. Especially since
distros are moving towards running X as non-root, so most users won't
even be able to see any benefits.

UMS support is dead now, but we need this minimal patch for
backporting. Follow-up patch will remove the pin ioctl code
completely.

Note to backporters: You must have both

commit b45305fce5bb1abec263fcff9d81ebecd6306ede
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Mon Dec 17 16:21:27 2012 +0100

    drm/i915: Implement workaround for broken CS tlb on i830/845

which laned in 3.8 and

commit c4d69da167fa967749aeb70bc0e94a457e5d00c1
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Mon Sep 8 14:25:41 2014 +0100

    drm/i915: Evict CS TLBs between batches

which is also marked cc: stable. Otherwise this could introduce a
regression by disabling the userspace w/a without the kernel w/a being
fully functional on i830/45.

References: https://bugs.freedesktop.org/show_bug.cgi?id=76554#c116
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4193,7 +4193,7 @@ i915_gem_pin_ioctl(struct drm_device *de
 	struct drm_i915_gem_object *obj;
 	int ret;
 
-	if (INTEL_INFO(dev)->gen >= 6)
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
 		return -ENODEV;
 
 	ret = i915_mutex_lock_interruptible(dev);
@@ -4249,6 +4249,9 @@ i915_gem_unpin_ioctl(struct drm_device *
 	struct drm_i915_gem_object *obj;
 	int ret;
 
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		return -ENODEV;
+
 	ret = i915_mutex_lock_interruptible(dev);
 	if (ret)
 		return ret;


