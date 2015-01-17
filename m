Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbbAQIF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 03:05:28 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:60357 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbbAQIF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 03:05:27 -0500
Date: Sat, 17 Jan 2015 09:05:19 +0100
From: Heinz Diehl <htd+ml@fritha.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.18.3
Message-ID: <20150117080519.GA1863@fritha.org>
References: <20150116183905.GA15290@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <20150116183905.GA15290@kroah.com>
Organization: private site
OpenPGP: id=60F4A92C; url=http://www.fritha.org/htd.asc;
 preference=signencrypt
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Provags-ID: V03:K0:z4iMqq8TPMziVNR40E5Cm5yY3slCNm4tpEEec8gF3Hd2dDWDttg
 DHCcnbvhjYmuVtb7GXjyi8Yo7+lgRggSYNw6f59dEcwqvNxXy9ztaorcPFLB7ekbbJV89Ed
 /NHr/WsfAK9LPogQU6NvrauIq+NzttUSw2kvfxpm4a4SITcSvDOr3R6ODlI+YFXhdWbpcFH
 /3uLWqAZl4hbRb1gO29WA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 16.01.2015, Greg KH wrote: 

> I'm announcing the release of the 3.18.3 kernel.

Since 3.18, machines with Ironlake Intel Graphics are left with a
black screen when booting into X. I reported the bug here:

https://www.libreoffice.org/bugzilla/show_bug.cgi?id=87330

And there are several reports of the same bug in the Bugzilla.
The problem is fixed in current mainline, but still present in
3.18.3. The patch which fixes the problem is attached, maybe it should
be applied to -stable as well?

Thanks,
 Heinz.


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2b387059817fd100cddc5a97118d63e3f3fade74..d472fcc8379c062bd56a3876fc6ef22258f14a91.patch"

>From d472fcc8379c062bd56a3876fc6ef22258f14a91 Mon Sep 17 00:00:00 2001
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Mon, 24 Nov 2014 11:12:42 +0100
Subject: drm/i915: Disallow pin ioctl completely for kms drivers

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
Cc: stable@vger.kernel.org # requires c4d69da167fa967749a and v3.8
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index fd17cca..97b86a5 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -4263,7 +4263,7 @@ i915_gem_pin_ioctl(struct drm_device *dev, void *data,
 	struct drm_i915_gem_object *obj;
 	int ret;
 
-	if (INTEL_INFO(dev)->gen >= 6)
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
 		return -ENODEV;
 
 	ret = i915_mutex_lock_interruptible(dev);
@@ -4319,6 +4319,9 @@ i915_gem_unpin_ioctl(struct drm_device *dev, void *data,
 	struct drm_i915_gem_object *obj;
 	int ret;
 
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		return -ENODEV;
+
 	ret = i915_mutex_lock_interruptible(dev);
 	if (ret)
 		return ret;
-- 
cgit v0.10.2


--+QahgC5+KEYLbs62--
