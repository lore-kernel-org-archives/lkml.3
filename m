Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaGPVNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:13:00 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47416 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaGPVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:12:55 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Leilei Shang <shangll@marvell.com>,
        Peter Korsgaard <peter@korsgaard.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v4] i2c: busses: i2c-pxa.c:  Fix for possible null pointer dereference
Date: Wed, 16 Jul 2014 23:14:11 +0200
Message-Id: <1405545251-13087-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405545251-13087-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1405545251-13087-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for possible null pointer dereference, and there was a risk for
memory leak if something unexpected happens and the function returns.
It now uses the Managed Device Resource instead.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/i2c/busses/i2c-pxa.c |   65 ++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 43 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index be671f7..0d0605c 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1141,11 +1141,9 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	struct resource *res = NULL;
 	int ret, irq;
 
-	i2c = kzalloc(sizeof(struct pxa_i2c), GFP_KERNEL);
-	if (!i2c) {
-		ret = -ENOMEM;
-		goto emalloc;
-	}
+	i2c = devm_kzalloc(&dev->dev, sizeof(struct pxa_i2c), GFP_KERNEL);
+	if (!i2c)
+		return -ENOMEM;
 
 	/* Default adapter num to device id; i2c_pxa_probe_dt can override. */
 	i2c->adap.nr = dev->id;
@@ -1154,19 +1152,16 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	if (ret > 0)
 		ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
 	if (ret < 0)
-		goto eclk;
+		return ret;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(dev, 0);
-	if (res == NULL || irq < 0) {
-		ret = -ENODEV;
-		goto eclk;
-	}
+	if (res == NULL || irq < 0)
+		return -ENODEV;
 
-	if (!request_mem_region(res->start, resource_size(res), res->name)) {
-		ret = -ENOMEM;
-		goto eclk;
-	}
+	if (!devm_request_mem_region(&dev->dev, res->start,
+				resource_size(res), res->name))
+		return -ENOMEM;
 
 	i2c->adap.owner   = THIS_MODULE;
 	i2c->adap.retries = 5;
@@ -1176,17 +1171,13 @@ static int i2c_pxa_probe(struct platform_device *dev)
 
 	strlcpy(i2c->adap.name, "pxa_i2c-i2c", sizeof(i2c->adap.name));
 
-	i2c->clk = clk_get(&dev->dev, NULL);
-	if (IS_ERR(i2c->clk)) {
-		ret = PTR_ERR(i2c->clk);
-		goto eclk;
-	}
+	i2c->clk = devm_clk_get(&dev->dev, NULL);
+	if (IS_ERR(i2c->clk))
+		return PTR_ERR(i2c->clk);
 
-	i2c->reg_base = ioremap(res->start, resource_size(res));
-	if (!i2c->reg_base) {
-		ret = -EIO;
-		goto eremap;
-	}
+	i2c->reg_base = devm_ioremap_resource(&adev->dev, res));
+	if (IS_ERR(i2c->reg_base))
+		return -EIO;
 
 	i2c->reg_ibmr = i2c->reg_base + pxa_reg_layout[i2c_type].ibmr;
 	i2c->reg_idbr = i2c->reg_base + pxa_reg_layout[i2c_type].idbr;
@@ -1227,10 +1218,12 @@ static int i2c_pxa_probe(struct platform_device *dev)
 		i2c->adap.algo = &i2c_pxa_pio_algorithm;
 	} else {
 		i2c->adap.algo = &i2c_pxa_algorithm;
-		ret = request_irq(irq, i2c_pxa_handler, IRQF_SHARED,
-				  dev_name(&dev->dev), i2c);
-		if (ret)
-			goto ereqirq;
+		ret = devm_request_irq(&dev->dev, irq, i2c_pxa_handler,
+				 IRQF_SHARED, dev_name(&dev->dev), i2c);
+		if (ret) {
+			clk_disable_unprepare(i2c->clk);
+			return ret;
+		}
 	}
 
 	i2c_pxa_reset(i2c);
@@ -1244,7 +1237,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	ret = i2c_add_numbered_adapter(&i2c->adap);
 	if (ret < 0) {
 		printk(KERN_INFO "I2C: Failed to add bus\n");
-		goto eadapt;
+		return ret;
 	}
 
 	platform_set_drvdata(dev, i2c);
@@ -1257,20 +1250,6 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	       dev_name(&i2c->adap.dev));
 #endif
 	return 0;
-
-eadapt:
-	if (!i2c->use_pio)
-		free_irq(irq, i2c);
-ereqirq:
-	clk_disable_unprepare(i2c->clk);
-	iounmap(i2c->reg_base);
-eremap:
-	clk_put(i2c->clk);
-eclk:
-	kfree(i2c);
-emalloc:
-	release_mem_region(res->start, resource_size(res));
-	return ret;
 }
 
 static int i2c_pxa_remove(struct platform_device *dev)
-- 
1.7.10.4

