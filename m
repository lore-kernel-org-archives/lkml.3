Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371Ab3EAJyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 05:54:19 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:64934 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3EAJyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 05:54:11 -0400
Date: Wed, 1 May 2013 10:54:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 5/5 v2] dmaengine: ste_dma40: Fetch disabled channels from DT
Message-ID: <20130501095406.GE25256@gmail.com>
References: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
 <1367336497-10650-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367336497-10650-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
index b14de16..658b53b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3464,7 +3464,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 			       struct device_node *np)
 {
 	struct stedma40_platform_data *pdata;
-	int num_phy = 0, num_memcpy = 0;
+	int num_phy = 0, num_memcpy = 0, num_disabled = 0;
 	const const __be32 *list;
 
 	pdata = devm_kzalloc(&pdev->dev,
@@ -3493,6 +3493,21 @@ static int __init d40_of_probe(struct platform_device *pdev,
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
