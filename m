Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab3H3LRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:17:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26718 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3H3LRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:17:38 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-cd-52207f50b98a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] of/platform: add error reporting to of_amba_device_create()
Date: Fri, 30 Aug 2013 13:17:29 +0200
Message-id: <2891140.lVrJfIiCi5@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAd2AeoUggz+nVCzmHznHanHgzw5G
	i8u75rBZHF5xgMmBxWPB5yvsHneu7WHz+LxJLoA5issmJTUnsyy1SN8ugSvj8LHXTAVfBCp2
	H+xnbGA8ydvFyMEhIWAicfFPVhcjJ5ApJnHh3nq2LkYuDiGBRYwSvfPXMEE4LUwS3x70MIFU
	sQlYSUxsX8UIYosIaEk8mfOZDWQQs0CqxNN1nCBhYQF/idNH5zCChFkEVCWuzFYBCfMKaEpM
	m3+SHcQWFfCU+DRpKTNEXFDix+R7LCA2s4C8xL79U1khbC2J9TuPM01g5JuFpGwWkrJZSMoW
	MDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgOv2dSOxhXNlgcYhTgYFTi4X0QLB8kxJpY
	VlyZe4hRgoNZSYS3IlUhSIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILU
	IpgsEwenVAOjnrOv3js2z83OXQfjnm+QuL7ysedBtYehCTGXyqQ+n3/+Qnm5mKm7Bq9B9NRz
	py4mKzr0PTnyUUYg/du1JeW3fXYdyL8W6689r/fo1iyXz4p/DfjPT5I2NUrOPnMnImid7+tT
	u7Nc7N4Y5rislbcPkvbkXz3txZEkyzmK7xL1nV6HXnZyY5quxFKckWioxVxUnAgAanybnzsC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add error reporting to of_amba_device_create() so the user knows
when (and why) some device tree nodes fail to initialize.

[ The issue was spotted on Universal C210 board (using revision 0 of
  ARM Exynos4210 SoC) on which initialization was silently failing
  for PL330 MDMA1 device tree node (it was using the wrong addres
  resulting in amba_device_add() returning -ENODEV). ]

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
v2:
* don't change the return value
* don't change the user of of_amba_device_create()

 drivers/of/platform.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

Index: b/drivers/of/platform.c
===================================================================
--- a/drivers/of/platform.c	2013-08-29 17:04:38.227921054 +0200
+++ b/drivers/of/platform.c	2013-08-30 13:13:31.202813954 +0200
@@ -268,8 +268,11 @@ static struct amba_device *of_amba_devic
 		return NULL;
 
 	dev = amba_device_alloc(NULL, 0, 0);
-	if (!dev)
+	if (!dev) {
+		pr_err("%s(): amba_device_alloc() failed for %s\n",
+		       __func__, node->full_name);
 		return NULL;
+	}
 
 	/* setup generic device info */
 	dev->dev.coherent_dma_mask = ~0;
@@ -294,12 +297,18 @@ static struct amba_device *of_amba_devic
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
 
@@ -378,6 +387,10 @@ static int of_platform_bus_create(struct
 	}
 
 	if (of_device_is_compatible(bus, "arm,primecell")) {
+		/*
+		 * Don't return an error here to keep compatibility with older
+		 * device tree files.
+		 */
 		of_amba_device_create(bus, bus_id, platform_data, parent);
 		return 0;
 	}

