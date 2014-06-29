Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaF2X1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 19:27:45 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:63824 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaF2X11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 19:27:27 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Leilei Shang <shangll@marvell.com>,
        Peter Korsgaard <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v2] i2c: busses: i2c-pxa.c:  Fix for possible null pointer dereferenc
Date: Mon, 30 Jun 2014 01:28:36 +0200
Message-Id: <1404084516-901-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404084516-901-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1404084516-901-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for possible null pointer dereferenc, and there is a risk for memory leak in when something unexpected happens and the function returns.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/i2c/busses/i2c-pxa.c |   37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index be671f7..886877a 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1141,10 +1141,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	struct resource *res = NULL;
 	int ret, irq;
 
-	i2c = kzalloc(sizeof(struct pxa_i2c), GFP_KERNEL);
+	i2c = devm_kzalloc(&dev->dev, sizeof(struct pxa_i2c), GFP_KERNEL);
 	if (!i2c) {
 		ret = -ENOMEM;
-		goto emalloc;
+		goto err_nothing_to_release;
 	}
 
 	/* Default adapter num to device id; i2c_pxa_probe_dt can override. */
@@ -1154,18 +1154,19 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	if (ret > 0)
 		ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
 	if (ret < 0)
-		goto eclk;
+		goto err_nothing_to_release;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(dev, 0);
 	if (res == NULL || irq < 0) {
 		ret = -ENODEV;
-		goto eclk;
+		goto err_nothing_to_release;
 	}
 
-	if (!request_mem_region(res->start, resource_size(res), res->name)) {
+	if (!devm_request_mem_region(&dev->dev, res->start,
+				resource_size(res), res->name)) {
 		ret = -ENOMEM;
-		goto eclk;
+		goto emalloc;
 	}
 
 	i2c->adap.owner   = THIS_MODULE;
@@ -1176,16 +1177,16 @@ static int i2c_pxa_probe(struct platform_device *dev)
 
 	strlcpy(i2c->adap.name, "pxa_i2c-i2c", sizeof(i2c->adap.name));
 
-	i2c->clk = clk_get(&dev->dev, NULL);
+	i2c->clk = devm_clk_get(&dev->dev, NULL);
 	if (IS_ERR(i2c->clk)) {
 		ret = PTR_ERR(i2c->clk);
-		goto eclk;
+		goto emalloc;
 	}
 
-	i2c->reg_base = ioremap(res->start, resource_size(res));
-	if (!i2c->reg_base) {
+	i2c->reg_base = devm_ioremap(&dev->dev, res->start, resource_size(res));
+	if (IS_ERR(i2c->reg_base)) {
 		ret = -EIO;
-		goto eremap;
+		goto emalloc;
 	}
 
 	i2c->reg_ibmr = i2c->reg_base + pxa_reg_layout[i2c_type].ibmr;
@@ -1227,10 +1228,10 @@ static int i2c_pxa_probe(struct platform_device *dev)
 		i2c->adap.algo = &i2c_pxa_pio_algorithm;
 	} else {
 		i2c->adap.algo = &i2c_pxa_algorithm;
-		ret = request_irq(irq, i2c_pxa_handler, IRQF_SHARED,
-				  dev_name(&dev->dev), i2c);
+		ret = devm_request_irq(&dev->dev, irq, i2c_pxa_handler,
+				 IRQF_SHARED, dev_name(&dev->dev), i2c);
 		if (ret)
-			goto ereqirq;
+			goto emalloc;
 	}
 
 	i2c_pxa_reset(i2c);
@@ -1261,15 +1262,9 @@ static int i2c_pxa_probe(struct platform_device *dev)
 eadapt:
 	if (!i2c->use_pio)
 		free_irq(irq, i2c);
-ereqirq:
-	clk_disable_unprepare(i2c->clk);
-	iounmap(i2c->reg_base);
-eremap:
-	clk_put(i2c->clk);
-eclk:
-	kfree(i2c);
 emalloc:
 	release_mem_region(res->start, resource_size(res));
+err_nothing_to_release:
 	return ret;
 }
 
-- 
1.7.10.4

