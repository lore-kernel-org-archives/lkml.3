Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaKWNQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 08:16:45 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:57097 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbaKWNQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 08:16:41 -0500
X-IronPort-AV: E=Sophos;i="5.07,443,1413237600"; 
   d="scan'208";a="109083691"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Airlie <airlied@linux.ie>
Cc: kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] drivers/gpu/drm: fix error return code
Date: Sun, 23 Nov 2014 14:11:18 +0100
Message-Id: <1416748278-22881-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1416748278-22881-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1416748278-22881-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/gpu/drm/gma500/psb_drv.c         |    8 ++++++--
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
index 6ec3a90..e405414 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -306,12 +306,16 @@ static int psb_driver_load(struct drm_device *dev, unsigned long flags)
 		goto out_err;
 
 	dev_priv->mmu = psb_mmu_driver_init(dev, 1, 0, 0);
-	if (!dev_priv->mmu)
+	if (!dev_priv->mmu) {
+		ret = -ENOMEM;
 		goto out_err;
+	}
 
 	dev_priv->pf_pd = psb_mmu_alloc_pd(dev_priv->mmu, 1, 0);
-	if (!dev_priv->pf_pd)
+	if (!dev_priv->pf_pd) {
+		ret = -ENOMEM;
 		goto out_err;
+	}
 
 	ret = psb_do_init(dev);
 	if (ret)
diff --git a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
index 56c6055..c0fb5fa 100644
--- a/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
+++ b/drivers/gpu/drm/omapdrm/omap_dmm_tiler.c
@@ -678,6 +678,7 @@ static int omap_dmm_probe(struct platform_device *dev)
 				&omap_dmm->refill_pa, GFP_KERNEL);
 	if (!omap_dmm->refill_va) {
 		dev_err(&dev->dev, "could not allocate refill memory\n");
+		ret = -ENOMEM;
 		goto fail;
 	}
 

