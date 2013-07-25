Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3GYTAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:00:17 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:64380 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756279Ab3GYTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:00:14 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 25 Jul 2013 20:00:06 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
Message-ID: <20130725190006.GD11514@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>,
	linux-next <linux-next@vger.kernel.org>
References: <20130725163150.GD6493@cantiga.alporthouse.com>
 <CA+icZUWmpZK0jO_G1ec446WftzXDvSdnHLcQrkmBSHA7fSAqcw@mail.gmail.com>
 <20130725170144.GE6493@cantiga.alporthouse.com>
 <CA+icZUUOmoFY3JDZOYmiP3dV9KAR_8WYfEDQhaynKmhXCLpF9w@mail.gmail.com>
 <20130725172616.GA11514@cantiga.alporthouse.com>
 <CA+icZUUpnQ_=bTtK-0-qG90GjV38oeVe2E1v-KdLZQFQWH21GQ@mail.gmail.com>
 <CA+icZUXz+6MgbW952fU_da1-RfX8CSZp76gJnOwGDNsd-rdebA@mail.gmail.com>
 <CA+icZUV+D8PvEysipfg9nPXp3ON1QSA7DiFdpYFpdesFF5c0sw@mail.gmail.com>
 <20130725184504.GC11514@cantiga.alporthouse.com>
 <CA+icZUVLXxA5LPxzTjyhP5gryNUH3OY+vutoXQj6ydtCU0msbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVLXxA5LPxzTjyhP5gryNUH3OY+vutoXQj6ydtCU0msbA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 08:50:59PM +0200, Sedat Dilek wrote:
> Against what tree is this applicable? It is definitely not drm-intel-nightly.

Applied cleanly to nightly here, but just in case here's a rebased version:

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 3a5d4ba..5818fe8 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1527,30 +1527,39 @@ i915_gem_mmap_gtt(struct drm_file *file,
 	struct drm_i915_gem_object *obj;
 	int ret;
 
+	printk(KERN_ERR "Hello!\n");
+
 	ret = i915_mutex_lock_interruptible(dev);
-	if (ret)
+	if (ret) {
+		DRM_DEBUG_DRIVER("interrupted: ret=%d\n", ret);
 		return ret;
+	}
 
 	obj = to_intel_bo(drm_gem_object_lookup(dev, file, handle));
 	if (&obj->base == NULL) {
+		DRM_DEBUG_DRIVER("Unknown object handle %d\n", handle);
 		ret = -ENOENT;
 		goto unlock;
 	}
 
 	if (obj->base.size > dev_priv->gtt.mappable_end) {
+		DRM_DEBUG_DRIVER("Object (%d) larger than mappable aperture (%d) > %d\n",
+				(int)obj->base.size, (int)dev_priv->gtt.mappable_end);
 		ret = -E2BIG;
 		goto out;
 	}
 
 	if (obj->madv != I915_MADV_WILLNEED) {
-		DRM_ERROR("Attempting to mmap a purgeable buffer\n");
+		DRM_DEBUG_DRIVER("Attempting to mmap a purgeable buffer\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
 	ret = i915_gem_object_create_mmap_offset(obj);
-	if (ret)
+	if (ret) {
+		DRM_DEBUG_DRIVER("Failed to allocate mmap offset (ret=%d)\n", ret);
 		goto out;
+	}
 
 	*offset = drm_vma_node_offset_addr(&obj->base.vma_node);
 
@@ -1558,6 +1567,7 @@ out:
 	drm_gem_object_unreference(&obj->base);
 unlock:
 	mutex_unlock(&dev->struct_mutex);
+	DRM_DEBUG_DRIVER("done, ret=%d\n", ret);
 	return ret;
 }

-- 
Chris Wilson, Intel Open Source Technology Centre
