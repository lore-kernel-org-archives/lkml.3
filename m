Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbaBAD3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:29:08 -0500
Received: from gnurou.org ([207.192.72.5]:51788 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbaBAD20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [RFC 08/16] drm/nouveau/mc: support platform devices
Date: Sat,  1 Feb 2014 12:16:50 +0900
Message-Id: <1391224618-3794-9-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use abstracted resource query functions, and obtain the IRQ from the
correct bus.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h |  1 +
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c    | 43 +++++++++++++++---------
 2 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/mc.h b/drivers/gpu/drm/nouveau/core/include/subdev/mc.h
index adc88b7..7c551b5 100644
--- a/drivers/gpu/drm/nouveau/core/include/subdev/mc.h
+++ b/drivers/gpu/drm/nouveau/core/include/subdev/mc.h
@@ -12,6 +12,7 @@ struct nouveau_mc_intr {
 struct nouveau_mc {
 	struct nouveau_subdev base;
 	bool use_msi;
+	unsigned int irq;
 };
 
 static inline struct nouveau_mc *
diff --git a/drivers/gpu/drm/nouveau/core/subdev/mc/base.c b/drivers/gpu/drm/nouveau/core/subdev/mc/base.c
index b4b9943..081fd96 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/base.c
@@ -93,8 +93,8 @@ _nouveau_mc_dtor(struct nouveau_object *object)
 {
 	struct nouveau_device *device = nv_device(object);
 	struct nouveau_mc *pmc = (void *)object;
-	free_irq(device->pdev->irq, pmc);
-	if (pmc->use_msi)
+	free_irq(pmc->irq, pmc);
+	if (nv_device_is_pci(device) && pmc->use_msi)
 		pci_disable_msi(device->pdev);
 	nouveau_subdev_destroy(&pmc->base);
 }
@@ -114,22 +114,25 @@ nouveau_mc_create_(struct nouveau_object *parent, struct nouveau_object *engine,
 	if (ret)
 		return ret;
 
-	switch (device->pdev->device & 0x0ff0) {
-	case 0x00f0:
-	case 0x02e0:
-		/* BR02? NFI how these would be handled yet exactly */
-		break;
-	default:
-		switch (device->chipset) {
-		case 0xaa: break; /* reported broken, nv also disable it */
-		default:
-			pmc->use_msi = true;
+	if (nv_device_is_pci(device))
+		switch (device->pdev->device & 0x0ff0) {
+		case 0x00f0:
+		case 0x02e0:
+			/* BR02? NFI how these would be handled yet exactly */
 			break;
+		default:
+			switch (device->chipset) {
+			case 0xaa:
+				/* reported broken, nv also disable it */
+				break;
+			default:
+				pmc->use_msi = true;
+				break;
 		}
 	}
 
 	pmc->use_msi = nouveau_boolopt(device->cfgopt, "NvMSI", pmc->use_msi);
-	if (pmc->use_msi && oclass->msi_rearm) {
+	if (nv_device_is_pci(device) && pmc->use_msi && oclass->msi_rearm) {
 		pmc->use_msi = pci_enable_msi(device->pdev) == 0;
 		if (pmc->use_msi) {
 			nv_info(pmc, "MSI interrupts enabled\n");
@@ -139,8 +142,18 @@ nouveau_mc_create_(struct nouveau_object *parent, struct nouveau_object *engine,
 		pmc->use_msi = false;
 	}
 
-	ret = request_irq(device->pdev->irq, nouveau_mc_intr,
-			  IRQF_SHARED, "nouveau", pmc);
+	if (nv_device_is_pci(device)) {
+		pmc->irq = device->pdev->irq;
+	} else {
+		int irq = platform_get_irq_byname(device->platformdev, "stall");
+		if (irq < 0)
+			return irq;
+		pmc->irq = irq;
+	}
+
+	ret = request_irq(pmc->irq, nouveau_mc_intr, IRQF_SHARED, "nouveau",
+			  pmc);
+
 	if (ret < 0)
 		return ret;
 
-- 
1.8.5.3

