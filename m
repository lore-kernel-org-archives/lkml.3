Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab3EOJx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:53:28 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50787 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab3EOJxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:53:22 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 39/39] dmaengine: ste_dma40: Fetch disabled channels from DT
Date: Wed, 15 May 2013 10:52:02 +0100
Message-Id: <1368611522-9984-40-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms have channels which are not available for normal use.
This information is currently passed though platform data in internal
BSP kernels. Once those platforms land, they'll need to configure them
appropriately, so we may as well add the infrastructure.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/dma/ste-dma40.txt |    2 ++
 drivers/dma/ste_dma40.c                             |   17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/ste-dma40.txt b/Documentation/devicetree/bindings/dma/ste-dma40.txt
index aa272d8..bea5b73 100644
--- a/Documentation/devicetree/bindings/dma/ste-dma40.txt
+++ b/Documentation/devicetree/bindings/dma/ste-dma40.txt
@@ -11,6 +11,7 @@ Required properties:
 Optional properties:
 - dma-channels: Number of channels supported by hardware - if not present
 		the driver will attempt to obtain the information from H/W
+- disabled-channels: Channels which can not be used
 
 Example:
 
@@ -23,6 +24,7 @@ Example:
 
 		#dma-cells = <2>;
 		memcpy-channels  = <56 57 58 59 60>;
+		disabled-channels  = <12>;
 		dma-channels = <8>;
 	};
 
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 4e528dd..ffac822 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3482,7 +3482,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 			       struct device_node *np)
 {
 	struct stedma40_platform_data *pdata;
-	int num_phy = 0, num_memcpy = 0;
+	int num_phy = 0, num_memcpy = 0, num_disabled = 0;
 	const const __be32 *list;
 
 	pdata = devm_kzalloc(&pdev->dev,
@@ -3511,6 +3511,21 @@ static int __init d40_of_probe(struct platform_device *pdev,
 				   dma40_memcpy_channels,
 				   num_memcpy);
 
+	list = of_get_property(np, "disabled-channels", &num_disabled);
+	num_disabled /= sizeof(*list);
+
+	if (num_disabled > STEDMA40_MAX_PHYS || num_disabled < 0) {
+		d40_err(&pdev->dev,
+			"Invalid number of disabled channels specified (%d)\n",
+			num_disabled);
+		return -EINVAL;
+	}
+
+	of_property_read_u32_array(np, "disabled-channels",
+				   pdata->disabled_channels,
+				   num_disabled);
+	pdata->disabled_channels[num_disabled] = -1;
+
 	pdev->dev.platform_data = pdata;
 
 	return 0;
-- 
1.7.10.4

