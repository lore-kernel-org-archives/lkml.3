Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3GHKzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 06:55:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49991 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab3GHKzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 06:55:44 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <kishon@ti.com>, <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] musb: omap: Fix: pass all the resources to musb core
Date: Mon, 8 Jul 2013 16:25:29 +0530
Message-ID: <1373280929-19052-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 09fc7d (usb: musb: fix incorrect usage of resource pointer)
assumes musb core will always have only 2 resources. But for OMAP
platforms there can be 3 resources (2 irq resource and 1 iomem
resource). Fixed it here.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/omap2430.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 5b6113a..5bbef78 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -481,7 +481,7 @@ static u64 omap2430_dmamask = DMA_BIT_MASK(32);
 
 static int omap2430_probe(struct platform_device *pdev)
 {
-	struct resource			musb_resources[2];
+	struct resource			musb_resources[3];
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct omap_musb_board_data	*data;
 	struct platform_device		*musb;
@@ -489,6 +489,7 @@ static int omap2430_probe(struct platform_device *pdev)
 	struct device_node		*np = pdev->dev.of_node;
 	struct musb_hdrc_config		*config;
 	int				ret = -ENOMEM;
+	int				i = 0;
 
 	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
@@ -571,15 +572,12 @@ static int omap2430_probe(struct platform_device *pdev)
 	memset(musb_resources, 0x00, sizeof(*musb_resources) *
 			ARRAY_SIZE(musb_resources));
 
-	musb_resources[0].name = pdev->resource[0].name;
-	musb_resources[0].start = pdev->resource[0].start;
-	musb_resources[0].end = pdev->resource[0].end;
-	musb_resources[0].flags = pdev->resource[0].flags;
-
-	musb_resources[1].name = pdev->resource[1].name;
-	musb_resources[1].start = pdev->resource[1].start;
-	musb_resources[1].end = pdev->resource[1].end;
-	musb_resources[1].flags = pdev->resource[1].flags;
+	for (i = 0; i < ARRAY_SIZE(musb_resources); i++) {
+		musb_resources[i].name = pdev->resource[i].name;
+		musb_resources[i].start = pdev->resource[i].start;
+		musb_resources[i].end = pdev->resource[i].end;
+		musb_resources[i].flags = pdev->resource[i].flags;
+	}
 
 	ret = platform_device_add_resources(musb, musb_resources,
 			ARRAY_SIZE(musb_resources));
-- 
1.7.10.4

