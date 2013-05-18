Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab3ERDO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:14:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684Ab3ERDAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:15 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9kWdfSMoVHkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-A6U4JZ64oYA:10 a=taGs_qngAAAA:8 a=PSgcYXQzAAAA:8 a=IWxJrl5LAAAA:8 a=cGMaF8Z7J5CfVMR4TXoA:9 a=n7Cch7CHiCMA:10 a=3k7bIPdiljcA:10 a=Cu9E_DCszsQA:10 a=jeBq3FmKZ4MA:10 a=KJKTsv-BUkteaBEt:21 a=qy2dhLuJIBM9ek1X:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021659.810315279@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Ben Widawsky <ben@bwidawsk.net>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 113/136 ] drm/i915: Use MLC (l3$) for context objects
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0113-drm-i915-Use-MLC-l3-for-context-objects.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 4615d4c9e27eda42c3e965f208a4b4065841498c ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/i915_gem_context.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem_context.c b/drivers/gpu/drm/i915/i915_gem_context.c
index a9d58d7..dda0d35 100644
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -155,6 +155,13 @@ create_hw_context(struct drm_device *dev,
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
-- 
1.7.10.4


