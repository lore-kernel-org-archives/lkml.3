Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab3AOXbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:31:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:46742 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933625Ab3AOWwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Julien Cristau <jcristau@debian.org>
Subject: [ 120/171] drm/i915: dont pwrite tiled objects through the gtt
Date: Tue, 15 Jan 2013 14:44:45 -0800
Message-Id: <20130115224322.006093853@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit c07496fa61f4c5cb2addd1c57f6b22fcaeea2eeb upstream.

... we will botch up the bit17 swizzling. Furthermore tiled pwrite is
a (now) unused slowpath, so no one really cares.

This fixes the last swizzling issues I have with i-g-t on my bit17
swizzling i915G. No regression, it's been broken since the dawn of
gem, but it's nice for regression tracking when really _all_ i-g-t
tests work.

Actually this is not true, Chris Wilson noticed while reviewing this
patch that the commit

commit d9e86c0ee60f323e890484628f351bf50fa9a15d
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Wed Nov 10 16:40:20 2010 +0000

    drm/i915: Pipelined fencing [infrastructure]

contained a functional change that broke things.

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[jcristau: adjust context for 3.4]
Signed-off-by: Julien Cristau <jcristau@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_gem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -928,6 +928,7 @@ i915_gem_pwrite_ioctl(struct drm_device
 	}
 
 	if (obj->gtt_space &&
+	    obj->tiling_mode == I915_TILING_NONE &&
 	    obj->base.write_domain != I915_GEM_DOMAIN_CPU) {
 		ret = i915_gem_object_pin(obj, 0, true);
 		if (ret)


