Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaDRQgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:36:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42387 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbaDRQeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:34:13 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>, Jonathan Cameron <jic23@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <prabhakar.csengg@gmail.com>,
        <santosh.shilimkar@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <sergei.shtylyov@cogentembedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2 2/4] net: davinci_mdio: use devm_* api
Date: Fri, 18 Apr 2014 20:24:55 +0300
Message-ID: <1397841897-9170-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397841897-9170-1-git-send-email-grygorii.strashko@ti.com>
References: <1397841897-9170-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_* API for memory allocation and to get device's clock
to simplify driver's code.

Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/davinci_mdio.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
index 0cca9de..eda4946 100644
--- a/drivers/net/ethernet/ti/davinci_mdio.c
+++ b/drivers/net/ethernet/ti/davinci_mdio.c
@@ -321,15 +321,14 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 	struct phy_device *phy;
 	int ret, addr;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	data->bus = mdiobus_alloc();
+	data->bus = devm_mdiobus_alloc(dev, 0);
 	if (!data->bus) {
 		dev_err(dev, "failed to alloc mii bus\n");
-		ret = -ENOMEM;
-		goto bail_out;
+		return -ENOMEM;
 	}
 
 	if (dev->of_node) {
@@ -354,7 +353,7 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
-	data->clk = clk_get(&pdev->dev, "fck");
+	data->clk = devm_clk_get(dev, "fck");
 	if (IS_ERR(data->clk)) {
 		dev_err(dev, "failed to get device clock\n");
 		ret = PTR_ERR(data->clk);
@@ -406,16 +405,9 @@ static int davinci_mdio_probe(struct platform_device *pdev)
 	return 0;
 
 bail_out:
-	if (data->bus)
-		mdiobus_free(data->bus);
-
-	if (data->clk)
-		clk_put(data->clk);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-	kfree(data);
-
 	return ret;
 }
 
@@ -423,18 +415,12 @@ static int davinci_mdio_remove(struct platform_device *pdev)
 {
 	struct davinci_mdio_data *data = platform_get_drvdata(pdev);
 
-	if (data->bus) {
+	if (data->bus)
 		mdiobus_unregister(data->bus);
-		mdiobus_free(data->bus);
-	}
 
-	if (data->clk)
-		clk_put(data->clk);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-	kfree(data);
-
 	return 0;
 }
 
-- 
1.7.9.5

