Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935594Ab3BTPA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:00:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62867 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933491Ab3BTPAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:00:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: Re[10]: [PATCH v3] mfd: syscon: Add non-DT support
Date: Wed, 20 Feb 2013 15:00:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Dong Aisheng <dong.aisheng@linaro.org>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <201302201114.49304.arnd@arndb.de> <1361364471.967042408@f233.mail.ru>
In-Reply-To: <1361364471.967042408@f233.mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302201500.18803.arnd@arndb.de>
X-Provags-ID: V02:K0:dMtTcmNn9RhdxVHMqdDQvWsXHOry+c+RMXd/2doGS0H
 BGf0Rcb/b+dIGDIxyitGSD38xmZftTn8QffedDa2DNgKj8NZ7m
 yo97ul/+OwTAcvagI7i+4/nzY4em6fqyewx71OPOfu6x+JcsKJ
 Vo81STOKEYf6Tjgg9eKG4mxMBfK0fBgv7u1DTgy4vC359+2vnk
 IADE3mWoqhaQF4rhG2ivkDigT/UAb/P1ybomuMFB2HYB0LB10H
 twUyqM6NiZopSCKLBNzSxl+sA2Yh4cE3lEkzCZefmV6ifYraCH
 Erf9OiET4+HcbqFkzl+ezk6jNAQhqAme3TNSR/m154QXjMs7+X
 pRNPFFRDB159HMrBpqro=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013, Alexander Shiyan wrote:
> OK. I can convert platform to DT, no so easy, but possible.
> But I will use syscon as way to using DT (and MULTIPLATFORM in the future),
> this mean that I should completely drop ATAG support from this platform
> (since I cannot use syscon device without DT support, but several platform devices
> need to use system-wide registers).
> Arnd, if its OK for you, I will use this way. (I talking about CLPS711X, you know it :) ).

Ah, I should have realized that this is about clps711x when the patch
is coming from you ;-)

This is an existing platform, and I would not require you to move it to
devicetree just for supporting syscon, although it may be a good idea
to make that move in the long run.

For clps711x, we know that there is only one syscon register set, so you
could do a very simple patch like below. Basically we don't need to
treat the absence of DT information as an error, and a call to
syscon_regmap_lookup_by_compatible or syscon_regmap_lookup_by_phandle
will always return the syscon device that was registered first, or
-EPROBE_DEFER for any error.

	Arnd


diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 3f10591..d3c06c6 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -59,9 +59,6 @@ struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
 	struct regmap *regmap;
 
 	syscon_np = of_find_compatible_node(NULL, NULL, s);
-	if (!syscon_np)
-		return ERR_PTR(-ENODEV);
-
 	regmap = syscon_node_to_regmap(syscon_np);
 	of_node_put(syscon_np);
 
@@ -76,9 +73,6 @@ struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
 	struct regmap *regmap;
 
 	syscon_np = of_parse_phandle(np, property, 0);
-	if (!syscon_np)
-		return ERR_PTR(-ENODEV);
-
 	regmap = syscon_node_to_regmap(syscon_np);
 	of_node_put(syscon_np);
 
@@ -100,26 +94,22 @@ static struct regmap_config syscon_regmap_config = {
 static int syscon_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
 	struct syscon *syscon;
-	struct resource res;
+	struct resource *res;
 	int ret;
 
-	if (!np)
-		return -ENOENT;
-
 	syscon = devm_kzalloc(dev, sizeof(struct syscon),
 			    GFP_KERNEL);
 	if (!syscon)
 		return -ENOMEM;
 
-	syscon->base = of_iomap(np, 0);
-	if (!syscon->base)
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
 		return -EADDRNOTAVAIL;
 
-	ret = of_address_to_resource(np, 0, &res);
-	if (ret)
-		return ret;
+	syscon->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!syscon->base)
+		return -ENOMEM;
 
 	syscon_regmap_config.max_register = res.end - res.start - 3;
 	syscon->regmap = devm_regmap_init_mmio(dev, syscon->base,
