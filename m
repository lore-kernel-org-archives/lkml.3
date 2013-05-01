Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3EAJvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 05:51:19 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:36636 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3EAJvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 05:51:16 -0400
Date: Wed, 1 May 2013 10:51:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 1/5] dmaengine: ste_dma40: Allow memcpy channels to be
 configured from DT
Message-ID: <20130501095111.GC25256@gmail.com>
References: <1367336497-10650-1-git-send-email-lee.jones@linaro.org>
 <201304302242.24002.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304302242.24002.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this moment in time the memcpy channels which can be used by the D40
are fixed, as each supported platform in Mainline uses the same ones.
However, platforms do exist which don't follow this convention, so
these will need to be tailored. Fortunately, these platforms will be DT
only, so this change has very little impact on platform data.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/Documentation/devicetree/bindings/dma/ste-dma40.txt b/Documentation/devicetree/bindings/dma/ste-dma40.txt
index 2679a87..aa272d8 100644
--- a/Documentation/devicetree/bindings/dma/ste-dma40.txt
+++ b/Documentation/devicetree/bindings/dma/ste-dma40.txt
@@ -6,6 +6,7 @@ Required properties:
 - reg-names: Names of the above areas to use during resource look-up
 - interrupt: Should contain the DMAC interrupt number
 - #dma-cells: must be <3>
+- memcpy-channels: Channels to be used for memcpy
 
 Optional properties:
 - dma-channels: Number of channels supported by hardware - if not present
@@ -21,6 +22,7 @@ Example:
 		interrupts = <0 25 0x4>;
 
 		#dma-cells = <2>;
+		memcpy-channels  = <56 57 58 59 60>;
 		dma-channels = <8>;
 	};
 
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index d5c39e4..0077184 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -58,8 +58,10 @@
 #define D40_ALLOC_PHY		BIT(30)
 #define D40_ALLOC_LOG_FREE	0
 
+#define D40_MEMCPY_MAX_CHANS	8
+
 /* Reserved event lines for memcpy only. */
-static int dma40_memcpy_channels[] = { 56, 57, 58, 59, 60 };
+static int dma40_memcpy_channels[D40_MEMCPY_MAX_CHANS] = { 56, 57, 58, 59, 60 };
 
 /* Default configuration for physcial memcpy */
 struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
@@ -508,6 +510,8 @@ struct d40_gen_dmac {
  * @phy_start: Physical memory start of the DMA registers.
  * @phy_size: Size of the DMA register map.
  * @irq: The IRQ number.
+ * @num_memcpy_chans: The number of channels used for memcpy (mem-to-mem
+ * transfers).
  * @num_phy_chans: The number of physical channels. Read from HW. This
  * is the number of available channels for this driver, not counting "Secure
  * mode" allocated physical channels.
@@ -551,6 +555,7 @@ struct d40_base {
 	phys_addr_t			  phy_start;
 	resource_size_t			  phy_size;
 	int				  irq;
+	int				  num_memcpy_chans;
 	int				  num_phy_chans;
 	int				  num_log_chans;
 	struct device_dma_parameters	  dma_parms;
@@ -2920,7 +2925,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	}
 
 	d40_chan_init(base, &base->dma_memcpy, base->log_chans,
-		      base->num_log_chans, ARRAY_SIZE(dma40_memcpy_channels));
+		      base->num_log_chans, base->num_memcpy_chans);
 
 	dma_cap_zero(base->dma_memcpy.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_memcpy.cap_mask);
@@ -3121,6 +3126,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	struct d40_base *base = NULL;
 	int num_log_chans = 0;
 	int num_phy_chans;
+	int num_memcpy_chans;
 	int clk_ret = -EINVAL;
 	int i;
 	u32 pid;
@@ -3191,6 +3197,12 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	else
 		num_phy_chans = 4 * (readl(virtbase + D40_DREG_ICFG) & 0x7) + 4;
 
+	/* The number of channels used for memcpy */
+	if (plat_data->num_of_memcpy_chans)
+		num_memcpy_chans = plat_data->num_of_memcpy_chans;
+	else
+		num_memcpy_chans = ARRAY_SIZE(dma40_memcpy_channels);
+
 	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
 
 	dev_info(&pdev->dev,
@@ -3198,7 +3210,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		 rev, res->start, num_phy_chans, num_log_chans);
 
 	base = kzalloc(ALIGN(sizeof(struct d40_base), 4) +
-		       (num_phy_chans + num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) *
+		       (num_phy_chans + num_log_chans + num_memcpy_chans) *
 		       sizeof(struct d40_chan), GFP_KERNEL);
 
 	if (base == NULL) {
@@ -3208,6 +3220,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 
 	base->rev = rev;
 	base->clk = clk;
+	base->num_memcpy_chans = num_memcpy_chans;
 	base->num_phy_chans = num_phy_chans;
 	base->num_log_chans = num_log_chans;
 	base->phy_start = res->start;
@@ -3451,12 +3464,8 @@ static int __init d40_of_probe(struct platform_device *pdev,
 			       struct device_node *np)
 {
 	struct stedma40_platform_data *pdata;
- 
-	/*
-	 * FIXME: Fill in this routine as more support is added.
-	 * First platform enabled (u8500) doens't need any extra
-	 * properties to run, so this is fairly sparce currently.
-	 */
+	int num_memcpy = 0;
+	const const __be32 *list;
 
 	pdata = devm_kzalloc(&pdev->dev,
 			     sizeof(struct stedma40_platform_data),
@@ -3464,6 +3473,21 @@ static int __init d40_of_probe(struct platform_device *pdev,
 	if (!pdata)
 		return -ENOMEM;
 
+	list = of_get_property(np, "memcpy-channels", &num_memcpy);
+	num_memcpy /= sizeof(*list);
+
+	if (num_memcpy > D40_MEMCPY_MAX_CHANS || num_memcpy <= 0) {
+		d40_err(&pdev->dev,
+			"Invalid number of memcpy channels specified (%d)\n",
+			num_memcpy);
+		return -EINVAL;
+	}
+	pdata->num_of_memcpy_chans = num_memcpy;
+
+	of_property_read_u32_array(np, "memcpy-channels",
+				   dma40_memcpy_channels,
+				   num_memcpy);
+
 	pdev->dev.platform_data = pdata;
 
 	return 0;
diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index ceba6dc..1bb9b18 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -132,6 +132,7 @@ struct stedma40_chan_cfg {
  * @num_of_soft_lli_chans: The number of channels that needs to be configured
  * to use SoftLLI.
  * @use_esram_lcla: flag for mapping the lcla into esram region
+ * @num_of_memcpy_chans: The number of channels reserved for memcpy.
  * @num_of_phy_chans: The number of physical channels implemented in HW.
  * 0 means reading the number of channels from DMA HW but this is only valid
  * for 'multiple of 4' channels, like 8.
@@ -141,6 +142,7 @@ struct stedma40_platform_data {
 	int				*soft_lli_chans;
 	int				 num_of_soft_lli_chans;
 	bool				 use_esram_lcla;
+	int				 num_of_memcpy_chans;
 	int				 num_of_phy_chans;
 };
