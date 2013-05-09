Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab3EIWdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:33:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab3EIWdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:33:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Widawsky <ben@bwidawsk.net>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 41/73] drm/i915: Use MLC (l3$) for context objects
Date: Thu,  9 May 2013 15:32:04 -0700
Message-Id: <20130509222802.415453430@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 4615d4c9e27eda42c3e965f208a4b4065841498c upstream.

Enabling context support increases SwapBuffers latency by about 20%
(measured on an i7-3720qm). We can offset that loss slightly by enabling
faster caching for the contexts. As they are not backed by any
particular cache (such as the sampler or render caches) our only option
is to select the generic mid-level cache. This reduces the latency of
the swap by about 5%.

Oddly this effect can be observed running smokin-guns on IVB at
1280x1024:
Using BLT copies for swaps: 151.67 fps
Using Render copies for swaps (unpatched):  141.70 fps
With contexts disabled: 150.23 fps
With contexts in L3$: 150.77 fps

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ben Widawsky <ben@bwidawsk.net>
Cc: Kenneth Graunke <kenneth@whitecape.org>
Reviewed-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_context.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -157,6 +157,13 @@ create_hw_context(struct drm_device *dev
 		return ERR_PTR(-ENOMEM);
 	}
 
+	if (INTEL_INFO(dev)->gen >= 7) {
+		ret = i915_gem_object_set_cache_level(ctx->obj,
+						      I915_CACHE_LLC_MLC);
+		if (ret)
+			goto err_out;
+	}
+
 	/* The ring associated with the context object is handled by the normal
 	 * object tracking code. We give an initial ring value simple to pass an
 	 * assertion in the context switch code.


