Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943Ab3D3PmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:42:08 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:37161 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3D3Pl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:41:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 5/5] dmaengine: ste_dma40: Fetch disabled channels from DT
Date: Tue, 30 Apr 2013 16:41:37 +0100
Message-Id: <1367336497-10650-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
References: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
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
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/dma/ste-dma40.txt |    4 ++++
 drivers/dma/ste_dma40.c                             |   16 +++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/ste-dma40.txt b/Documentation/devicetree/bindings/dma/ste-dma40.txt
index 02e87e7..f234c75 100644
--- a/Documentation/devicetree/bindings/dma/ste-dma40.txt
+++ b/Documentation/devicetree/bindings/dma/ste-dma40.txt
@@ -12,6 +12,8 @@ Required properties:
 Optional properties:
 - dma-channels: Number of channels supported by hardware - if not present
 		the driver will attempt to obtain the information from H/W
+- disabled-channels: Channels which can not be used
+- disabled-num-chans: Number of channels which can not be used
 
 Example:
 
@@ -25,6 +27,8 @@ Example:
 		#dma-cells = <2>;
 		memcpy-channels  = <56, 57, 58, 59, 60>;
 		memcpy-num-chans = <5>;
+		disabled-channels  = <12>;
+		disabled-num-chans = <1>;
 		dma-channels = <8>;
 	};
 
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index dbdd67b..b045eb2 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3464,7 +3464,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 			       struct device_node *np)
 {
 	struct stedma40_platform_data *pdata;
-	int num_phy = 0, num_memcpy = 0;
+	int num_phy = 0, num_memcpy = 0, num_disabled = 0;
 
 	pdata = devm_kzalloc(&pdev->dev,
 			     sizeof(struct stedma40_platform_data),
@@ -3493,6 +3493,20 @@ static int __init d40_of_probe(struct platform_device *pdev,
 
 	pdev->dev.platform_data = pdata;
 
+	of_property_read_u32(np, "disabled-num-chans", &num_disabled);
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
 	return 0;
 }
 
-- 
1.7.10.4

