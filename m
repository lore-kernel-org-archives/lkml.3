Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbaBAD3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:29:06 -0500
Received: from gnurou.org ([207.192.72.5]:51801 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbaBAD20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 22:28:26 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc: Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Eric Brower <ebrower@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 09/16] drm/nouveau/fb: support platform devices
Date: Sat,  1 Feb 2014 12:16:51 +0900
Message-Id: <1391224618-3794-10-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use abstracted resource query functions to allow FB core to handle
both PCI and platform devices.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
index 45470e1..0670ae3 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
@@ -70,8 +70,7 @@ nvc0_fb_dtor(struct nouveau_object *object)
 	struct nvc0_fb_priv *priv = (void *)object;
 
 	if (priv->r100c10_page) {
-		pci_unmap_page(device->pdev, priv->r100c10, PAGE_SIZE,
-			       PCI_DMA_BIDIRECTIONAL);
+		nv_device_unmap_page(device, priv->r100c10);
 		__free_page(priv->r100c10_page);
 	}
 
@@ -94,10 +93,8 @@ nvc0_fb_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 
 	priv->r100c10_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (priv->r100c10_page) {
-		priv->r100c10 = pci_map_page(device->pdev, priv->r100c10_page,
-					     0, PAGE_SIZE,
-					     PCI_DMA_BIDIRECTIONAL);
-		if (pci_dma_mapping_error(device->pdev, priv->r100c10))
+		priv->r100c10 = nv_device_map_page(device, priv->r100c10_page);
+		if (!priv->r100c10)
 			return -EFAULT;
 	}
 
-- 
1.8.5.3

