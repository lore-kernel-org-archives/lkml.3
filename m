Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbaCDJLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:11:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57173 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbaCDJJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:09:05 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 1/5] drivers: bus: omap_l3: Convert to use devm_kzalloc
Date: Tue, 4 Mar 2014 11:08:26 +0200
Message-ID: <1393924110-11132-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393924110-11132-1-git-send-email-peter.ujfalusi@ti.com>
References: <1393924110-11132-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can remove the kfree() calls from probe and remove.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/bus/omap_l3_noc.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index feeecae623f6..d25d727e7cfb 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -134,7 +134,7 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	struct resource	*res;
 	int ret;
 
-	l3 = kzalloc(sizeof(*l3), GFP_KERNEL);
+	l3 = devm_kzalloc(&pdev->dev, sizeof(*l3), GFP_KERNEL);
 	if (!l3)
 		return -ENOMEM;
 
@@ -142,15 +142,13 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "couldn't find resource 0\n");
-		ret = -ENODEV;
-		goto err0;
+		return -ENODEV;
 	}
 
 	l3->l3_base[0] = ioremap(res->start, resource_size(res));
 	if (!l3->l3_base[0]) {
 		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err0;
+		return -ENOMEM;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
@@ -214,8 +212,6 @@ err2:
 	iounmap(l3->l3_base[1]);
 err1:
 	iounmap(l3->l3_base[0]);
-err0:
-	kfree(l3);
 	return ret;
 }
 
@@ -228,7 +224,6 @@ static int omap4_l3_remove(struct platform_device *pdev)
 	iounmap(l3->l3_base[0]);
 	iounmap(l3->l3_base[1]);
 	iounmap(l3->l3_base[2]);
-	kfree(l3);
 
 	return 0;
 }
-- 
1.9.0

