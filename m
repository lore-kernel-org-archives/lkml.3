Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3IKFYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:24:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab3IKE50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:26 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=QvokGGp3bIEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=UvywPkygd4UA:10 a=6rqHouBjAAAA:8 a=TBVoxVdAAAAA:8 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=taGs_qngAAAA:8 a=pGLkceISAAAA:8 a=69EAbJreAAAA:8 a=E0F6PzzqAAAA:8 a=T2h1Z_K7z-JURIdn7sYA:9 a=TAmEwCHjoHMA:10 a=rW6DTWptwo0A:10 a=n7Cch7CHiCMA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=EfJqPEOeqlMA:10 a=eFmMTfMF8WMA:10 a=WBMzfHH9iblSQDSm:21 a=7H76bqxUhs84UoSQ:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042910.933175138@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [112/251] drm/i915: fix long-standing SNB regression in power consumption
 after resume v2
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0112-drm-i915-fix-long-standing-SNB-regression-in-power-c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

[ Upstream commit 7dcd2677ea912573d9ed4bcd629b0023b2d11505 ]

This patch fixes regression in power consumtion of sandy bridge gpu, which
exists since v3.6 Sometimes after resuming from s2ram gpu starts thinking that
it's extremely busy. After that it never reaches rc6 state.

Bug exists since kernel v3.6:

commit b4ae3f22d238617ca11610b29fde16cf8c0bc6e0
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Thu Jun 14 11:04:48 2012 -0700

    drm/i915: load boot context at driver init time

For some reason RC6 is already enabled at the beginning of resuming process.
Following initliaztion breaks some internal state and confuses RPS engine.
This patch disables RC6 at the beginnig of resume and initialization.

I've rearranged initialization sequence, because intel_disable_gt_powersave()
needs initialized force_wake_get/put and some locks from the dev_priv.

Note: The culprit in the initialization sequence seems to be the write
to MBCTL added in the above mentioned commit. The first version of
this patch just held a forcewake reference across the clock gating
init functions, which seems to have been enought to gather quite a few
positive test reports. But since that smelled a bit like ad-hoc
duct-tape v2 now just disables rps/rc6 across the entire hw setup.

References: https://bugs.freedesktop.org/show_bug.cgi?id=54089
References: https://bugzilla.kernel.org/show_bug.cgi?id=58971
References: https://patchwork.kernel.org/patch/2827634/ (patch v1)
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[danvet: Add note about v1 vs. v2 of this patch and use standard
layout for the commit citation. Also add the tested-bys from v1 and a
cc: stable.]
Cc: stable@vger.kernel.org (Note: tiny conflict due to the addition of
the backlight lock in 3.11)
Tested-by: Alexander Kaltsas <alexkaltsas@gmail.com> (v1)
Tested-by: rocko <rockorequin@hotmail.com> (v1)
Tested-by: JohnMB <johnmbryant@sky.com> (v1)
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_dma.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 0969a7c..4c6e9dd 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1465,6 +1465,11 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	dev_priv->dev = dev;
 	dev_priv->info = info;
 
+	spin_lock_init(&dev_priv->irq_lock);
+	spin_lock_init(&dev_priv->error_lock);
+	spin_lock_init(&dev_priv->rps_lock);
+	spin_lock_init(&dev_priv->dpio_lock);
+
 	if (i915_get_bridge_dev(dev)) {
 		ret = -EIO;
 		goto free_priv;
@@ -1585,11 +1590,6 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 	if (!IS_I945G(dev) && !IS_I945GM(dev))
 		pci_enable_msi(dev->pdev);
 
-	spin_lock_init(&dev_priv->irq_lock);
-	spin_lock_init(&dev_priv->error_lock);
-	spin_lock_init(&dev_priv->rps_lock);
-	spin_lock_init(&dev_priv->dpio_lock);
-
 	if (IS_IVYBRIDGE(dev) || IS_HASWELL(dev))
 		dev_priv->num_pipe = 3;
 	else if (IS_MOBILE(dev) || !IS_GEN2(dev))
-- 
1.7.10.4


