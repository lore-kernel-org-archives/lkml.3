Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237Ab3GWSEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:04:37 -0400
Received: from sauhun.de ([89.238.76.85]:51174 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933840Ab3GWSEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:04:35 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org
Subject: [PATCH 27/27] thermal: ti-bandgap: cleanup resource allocation
Date: Tue, 23 Jul 2013 20:02:00 +0200
Message-Id: <1374602524-3398-28-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When cleaning up usage of devm_ioremap_resource, I found that resource
allocation in this driver is ugly and buggy. If resource[0] is not
found, bgp->base will end up NULL, so OOPS. All other resources get
ioremapped, but their pointers are discarded, so why bother. So, let's
keep things simple. Just remap resource[0] and pass the error, if any.
Compile tested only, due to no hardware.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Please apply via the subsystem-tree.

 drivers/thermal/ti-soc-thermal/ti-bandgap.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 9dfd471..416be5d 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -1130,7 +1130,6 @@ static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 	const struct of_device_id *of_id;
 	struct ti_bandgap *bgp;
 	struct resource *res;
-	int i;
 
 	/* just for the sake */
 	if (!node) {
@@ -1156,21 +1155,10 @@ static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	i = 0;
-	do {
-		void __iomem *chunk;
-
-		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-		if (!res)
-			break;
-		chunk = devm_ioremap_resource(&pdev->dev, res);
-		if (i == 0)
-			bgp->base = chunk;
-		if (IS_ERR(chunk))
-			return ERR_CAST(chunk);
-
-		i++;
-	} while (res);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	bgp->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(bgp->base))
+		return bgp->base;
 
 	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
 		bgp->tshut_gpio = of_get_gpio(node, 0);
-- 
1.7.10.4

