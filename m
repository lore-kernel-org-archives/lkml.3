Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab3EJIQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:16:52 -0400
Received: from sauhun.de ([89.238.76.85]:60425 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab3EJIQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:50 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org
Subject: [RFC 15/42] drivers/mtd/maps: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:00 +0200
Message-Id: <1368173847-5661-16-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/mtd/maps/autcpu12-nvram.c |    7 +------
 drivers/mtd/maps/lantiq-flash.c   |    8 +-------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/maps/autcpu12-nvram.c b/drivers/mtd/maps/autcpu12-nvram.c
index c3525d2..58853b0 100644
--- a/drivers/mtd/maps/autcpu12-nvram.c
+++ b/drivers/mtd/maps/autcpu12-nvram.c
@@ -47,15 +47,10 @@ static int autcpu12_nvram_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, priv);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get memory resource\n");
-		return -ENOENT;
-	}
-
 	priv->map.bankwidth	= 4;
 	priv->map.phys		= res->start;
 	priv->map.size		= resource_size(res);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->map.virt = devm_ioremap_resource(&pdev->dev, res);
 	strcpy((char *)priv->map.name, res->name);
 	if (IS_ERR(priv->map.virt))
diff --git a/drivers/mtd/maps/lantiq-flash.c b/drivers/mtd/maps/lantiq-flash.c
index d1da6ed..f405c34 100644
--- a/drivers/mtd/maps/lantiq-flash.c
+++ b/drivers/mtd/maps/lantiq-flash.c
@@ -127,16 +127,10 @@ ltq_mtd_probe(struct platform_device *pdev)
 	ltq_mtd = kzalloc(sizeof(struct ltq_mtd), GFP_KERNEL);
 	platform_set_drvdata(pdev, ltq_mtd);
 
-	ltq_mtd->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!ltq_mtd->res) {
-		dev_err(&pdev->dev, "failed to get memory resource\n");
-		err = -ENOENT;
-		goto err_out;
-	}
-
 	ltq_mtd->map = kzalloc(sizeof(struct map_info), GFP_KERNEL);
 	ltq_mtd->map->phys = ltq_mtd->res->start;
 	ltq_mtd->map->size = resource_size(ltq_mtd->res);
+	ltq_mtd->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	ltq_mtd->map->virt = devm_ioremap_resource(&pdev->dev, ltq_mtd->res);
 	if (IS_ERR(ltq_mtd->map->virt)) {
 		err = PTR_ERR(ltq_mtd->map->virt);
-- 
1.7.10.4

