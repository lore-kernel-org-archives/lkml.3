Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3H3KL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:11:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21366 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab3H3KLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:11:25 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-c8-52206fcb074d
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] of/platform: add error reporting to of_amba_device_create()
Date: Fri, 30 Aug 2013 12:11:17 +0200
Message-id: <1464891.8oCRh2189n@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t9jAd3T+QpBBodO6FrMP3KO1eLAnx2M
	Fpd3zWGzOLziAJMDi8eCz1fYPe5c28Pm8XmTXABzFJdNSmpOZllqkb5dAlfGliXbmApmClfc
	uHaXsYFxF38XIyeHhICJxMZtPxghbDGJC/fWs3UxcnEICSxilPhyo40Vwmlhkui+8ZcZpIpN
	wEpiYvsqsA4RAS2JJ3M+A3VwcDALpEo8XccJEhYW8JE4ev8PWDmLgKrEyu67bCA2r4CmxJqZ
	rawgtqiAp8SnSUuZIeKCEj8m32MBsZkF5CX27Z/KCmFrSazfeZxpAiPfLCRls5CUzUJStoCR
	eRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcAg+k97BuKrB4hCjAAejEg9vw1T5ICHWxLLi
	ytxDjBIczEoivBWpCkFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbB
	ZJk4OKUaGGM14prc+zc8CHbtWKa45YO75vNn3hGzd9/dv9m7Y2PQqn+TZnJbhHyfxhy6f+7a
	nKu1f9tDl76dvfzcYlHN1EWS6R9LDvqtK908/eubHMmwjH0LdRvZTh2MWOz5KZjvTn5pWMKD
	oz02YXMenpA9+yK9YnI242ctrZnn2++2rwtqnvFdP6b75lElluKMREMt5qLiRACv+Jl1PQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add error reporting to of_amba_device_create() so the user knows
when (and why) some device tree nodes fail to initialize.

Also while at it fix the function to return an error value on error.

[ The issue was spotted on Universal C210 board (using revision 0 of
  ARM Exynos4210 SoC) on which initialization was silently failing
  for PL330 MDMA1 device tree node (it was using the wrong addres
  resulting in amba_device_add() returning -ENODEV). ]

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/of/platform.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index b0d1ff8..cab4d0a 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -264,8 +264,11 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 		return NULL;
 
 	dev = amba_device_alloc(NULL, 0, 0);
-	if (!dev)
-		return NULL;
+	if (!dev) {
+		pr_err("%s(): amba_device_alloc() failed for %s\n",
+		       __func__, node->full_name);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	/* setup generic device info */
 	dev->dev.coherent_dma_mask = ~0;
@@ -290,18 +293,24 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 		dev->irq[i] = irq_of_parse_and_map(node, i);
 
 	ret = of_address_to_resource(node, 0, &dev->res);
-	if (ret)
+	if (ret) {
+		pr_err("%s(): of_address_to_resource() failed (%d) for %s\n",
+		       __func__, ret, node->full_name);
 		goto err_free;
+	}
 
 	ret = amba_device_add(dev, &iomem_resource);
-	if (ret)
+	if (ret) {
+		pr_err("%s(): amba_device_add() failed (%d) for %s\n",
+		       __func__, ret, node->full_name);
 		goto err_free;
+	}
 
 	return dev;
 
 err_free:
 	amba_device_put(dev);
-	return NULL;
+	return ERR_PTR(ret);
 }
 #else /* CONFIG_ARM_AMBA */
 static struct amba_device *of_amba_device_create(struct device_node *node,
@@ -374,7 +383,11 @@ static int of_platform_bus_create(struct device_node *bus,
 	}
 
 	if (of_device_is_compatible(bus, "arm,primecell")) {
-		of_amba_device_create(bus, bus_id, platform_data, parent);
+		/*
+		 * Don't return an error here to keep compatibility with older
+		 * device tree files.
+		 */
+		(void)of_amba_device_create(bus, bus_id, platform_data, parent);
 		return 0;
 	}
 
-- 
1.8.2.3


