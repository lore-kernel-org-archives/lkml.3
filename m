Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaGHI0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:26:41 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12178 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaGHI0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:26:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 08 Jul 2014 01:15:54 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 2/6] drm/nouveau: map pages using DMA API on platform devices
Date: Tue, 8 Jul 2014 17:25:57 +0900
Message-ID: <1404807961-30530-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
References: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_to_phys() is not the correct way to obtain the DMA address of a
buffer on a non-PCI system. Use the DMA API functions for this, which
are portable and will allow us to use other DMA API functions for
buffer synchronization.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/device/base.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/device/base.c b/drivers/gpu/drm/nouveau/core/engine/device/base.c
index 18c8c7245b73..e4e9e64988fe 100644
--- a/drivers/gpu/drm/nouveau/core/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/core/engine/device/base.c
@@ -489,7 +489,10 @@ nv_device_map_page(struct nouveau_device *device, struct page *page)
 		if (pci_dma_mapping_error(device->pdev, ret))
 			ret = 0;
 	} else {
-		ret = page_to_phys(page);
+		ret = dma_map_page(&device->platformdev->dev, page, 0,
+				   PAGE_SIZE, DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(&device->platformdev->dev, ret))
+			ret = 0;
 	}
 
 	return ret;
@@ -501,6 +504,9 @@ nv_device_unmap_page(struct nouveau_device *device, dma_addr_t addr)
 	if (nv_device_is_pci(device))
 		pci_unmap_page(device->pdev, addr, PAGE_SIZE,
 			       PCI_DMA_BIDIRECTIONAL);
+	else
+		dma_unmap_page(&device->platformdev->dev, addr,
+			       PAGE_SIZE, DMA_BIDIRECTIONAL);
 }
 
 int
-- 
2.0.0

