Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3K2ElN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 23:41:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43679 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab3K2ElL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 23:41:11 -0500
Message-ID: <52981A4B.70703@ti.com>
Date: Fri, 29 Nov 2013 10:08:35 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
CC: <rob@landley.net>, <linux@arm.linux.org.uk>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <pawel.moll@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <galak@kernel.crashing.org>,
        <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <computersforpeace@gmail.com>,
        <dwmw2@infradead.org>
Subject: Re: [PATCH v2] ARM: davinci: aemif: get rid of davinci-nand driver
 dependency on aemif
References: <1385562694-24618-1-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1385562694-24618-1-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 November 2013 08:01 PM, Ivan Khoronzhuk wrote:
> The problem that the set timings code contains the call of Davinci
> platform function davinci_aemif_setup_timing() which is not
> accessible if kernel is built for another platform like Keystone.
> 
> The Keysone platform is going to use TI AEMIF driver.
> If TI AEMIF is used we don't need to set timings and bus width.
> It is done by AEMIF driver.
> 
> To get rid of davinci-nand driver dependency on aemif platform code
> we moved aemif code to davinci platform.
> 
> The platform AEMIF code (aemif.c) has to be removed once Davinci
> will be converted to DT and use ti-aemif.c driver.
> 
> The long device name "davinci_ntosd2_nandflash_device" was renamed
> to "ntosd2_nandflash" as requested by Sekhar Nori, because after
> adding changes the line is so broken that its almost unreadable.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>

This patch can be simplified in some places.

> ---
> v2..v1:
> - enabled AEMIF clock
> - removed EXPORT_SYMBOL(davinci_aemif_setup)
> - renamed ugly name davinci_ntosd2_nandflash_device
> 
> CC:
> Sekhar Nori <nsekhar@ti.com>
> 
>  arch/arm/mach-davinci/aemif.c                   |   89 ++++++++++++++++++++++-
>  arch/arm/mach-davinci/board-da830-evm.c         |    3 +
>  arch/arm/mach-davinci/board-da850-evm.c         |    3 +
>  arch/arm/mach-davinci/board-dm355-evm.c         |    5 ++
>  arch/arm/mach-davinci/board-dm355-leopard.c     |    5 ++
>  arch/arm/mach-davinci/board-dm365-evm.c         |    4 +
>  arch/arm/mach-davinci/board-dm644x-evm.c        |    5 ++
>  arch/arm/mach-davinci/board-dm646x-evm.c        |    3 +
>  arch/arm/mach-davinci/board-mityomapl138.c      |    3 +
>  arch/arm/mach-davinci/board-neuros-osd2.c       |   13 +++-
>  arch/arm/mach-davinci/devices-tnetv107x.c       |    3 +
>  drivers/mtd/nand/davinci_nand.c                 |   23 ------
>  include/linux/platform_data/mtd-davinci-aemif.h |    5 +-

Most of these boards dont really have a timing structure defined.
Instead of blindly calling AEMIF setup on all boards, it can be
done only on boards that actually need it.

>  /*
>   * aemif_calc_rate - calculate timing data.
>   * @wanted: The cycle time needed in nanoseconds.
> @@ -86,7 +98,7 @@ static int aemif_calc_rate(int wanted, unsigned long clk, int max)
>   *
>   * Returns 0 on success, else negative errno.
>   */
> -int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
> +static int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,

passing the clkrate to this function helps avoid a repeated clk_get().
I made these changes locally and here is the updated patch:

---8<---
>From cdea7d6f753db09447fe2232959864ab999fe565 Mon Sep 17 00:00:00 2001
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Date: Wed, 27 Nov 2013 16:31:34 +0200
Subject: [PATCH 1/1] ARM: davinci: aemif: get rid of davinci-nand driver
 dependency on aemif

The problem that the set timings code contains the call of Davinci
platform function davinci_aemif_setup_timing() which is not
accessible if kernel is built for another platform like Keystone.

The Keysone platform is going to use TI AEMIF driver.
If TI AEMIF is used we don't need to set timings and bus width.
It is done by AEMIF driver. The TI AEMIF driver cannot
be used on all current DaVinci platforms since it is DT-only.

To get rid of davinci-nand driver dependency on aemif platform code
we moved aemif code to davinci platform.

The platform AEMIF code (aemif.c) has to be removed once Davinci
will be converted to DT and use ti-aemif.c driver.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-davinci/aemif.c                   |  106 ++++++++++++++++++++---
 arch/arm/mach-davinci/board-da830-evm.c         |    3 +
 arch/arm/mach-davinci/board-da850-evm.c         |    3 +
 arch/arm/mach-davinci/board-dm644x-evm.c        |    5 ++
 arch/arm/mach-davinci/board-dm646x-evm.c        |    3 +
 drivers/mtd/nand/davinci_nand.c                 |   23 -----
 include/linux/platform_data/mtd-davinci-aemif.h |    5 +-
 7 files changed, 112 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-davinci/aemif.c b/arch/arm/mach-davinci/aemif.c
index f091a90..e6dfc58 100644
--- a/arch/arm/mach-davinci/aemif.c
+++ b/arch/arm/mach-davinci/aemif.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 
+#include <linux/platform_data/mtd-davinci.h>
 #include <linux/platform_data/mtd-davinci-aemif.h>
 
 /* Timing value configuration */
@@ -43,6 +44,17 @@
 				WSTROBE(WSTROBE_MAX) | \
 				WSETUP(WSETUP_MAX))
 
+static inline unsigned int davinci_aemif_readl(void __iomem *base, int offset)
+{
+	return readl_relaxed(base + offset);
+}
+
+static inline void davinci_aemif_writel(void __iomem *base,
+					int offset, unsigned long value)
+{
+	writel_relaxed(value, base + offset);
+}
+
 /*
  * aemif_calc_rate - calculate timing data.
  * @wanted: The cycle time needed in nanoseconds.
@@ -76,6 +88,7 @@ static int aemif_calc_rate(int wanted, unsigned long clk, int max)
  * @t: timing values to be progammed
  * @base: The virtual base address of the AEMIF interface
  * @cs: chip-select to program the timing values for
+ * @clkrate: the AEMIF clkrate
  *
  * This function programs the given timing values (in real clock) into the
  * AEMIF registers taking the AEMIF clock into account.
@@ -86,24 +99,17 @@ static int aemif_calc_rate(int wanted, unsigned long clk, int max)
  *
  * Returns 0 on success, else negative errno.
  */
-int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
-					void __iomem *base, unsigned cs)
+static int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
+				      void __iomem *base, unsigned cs,
+				      unsigned long clkrate)
 {
 	unsigned set, val;
 	int ta, rhold, rstrobe, rsetup, whold, wstrobe, wsetup;
 	unsigned offset = A1CR_OFFSET + cs * 4;
-	struct clk *aemif_clk;
-	unsigned long clkrate;
 
 	if (!t)
 		return 0;	/* Nothing to do */
 
-	aemif_clk = clk_get(NULL, "aemif");
-	if (IS_ERR(aemif_clk))
-		return PTR_ERR(aemif_clk);
-
-	clkrate = clk_get_rate(aemif_clk);
-
 	clkrate /= 1000;	/* turn clock into kHz for ease of use */
 
 	ta	= aemif_calc_rate(t->ta, clkrate, TA_MAX);
@@ -130,4 +136,82 @@ int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
 
 	return 0;
 }
-EXPORT_SYMBOL(davinci_aemif_setup_timing);
+
+/**
+ * davinci_aemif_setup - setup AEMIF interface by davinci_nand_pdata
+ * @pdev - link to platform device to setup settings for
+ *
+ * This function does not use any locking while programming the AEMIF
+ * because it is expected that there is only one user of a given
+ * chip-select.
+ *
+ * Returns 0 on success, else negative errno.
+ */
+int davinci_aemif_setup(struct platform_device *pdev)
+{
+	struct davinci_nand_pdata *pdata = dev_get_platdata(&pdev->dev);
+	uint32_t val;
+	unsigned long clkrate;
+	struct resource	*res;
+	void __iomem *base;
+	struct clk *clk;
+	int ret = 0;
+
+	clk = clk_get(&pdev->dev, "aemif");
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		dev_dbg(&pdev->dev, "unable to get AEMIF clock, err %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(clk);
+	if (ret < 0) {
+		dev_dbg(&pdev->dev, "unable to enable AEMIF clock, err %d\n",
+			ret);
+		return ret;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res) {
+		dev_err(&pdev->dev, "cannot get IORESOURCE_MEM\n");
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	base = ioremap(res->start, resource_size(res));
+	if (!base) {
+		dev_err(&pdev->dev, "ioremap failed for resource %pR\n", res);
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/*
+	 * Setup Async configuration register in case we did not boot
+	 * from NAND and so bootloader did not bother to set it up.
+	 */
+	val = davinci_aemif_readl(base, A1CR_OFFSET + pdev->id * 4);
+	/*
+	 * Extended Wait is not valid and Select Strobe mode is not
+	 * used
+	 */
+	val &= ~(ACR_ASIZE_MASK | ACR_EW_MASK | ACR_SS_MASK);
+	if (pdata->options & NAND_BUSWIDTH_16)
+		val |= 0x1;
+
+	davinci_aemif_writel(base, A1CR_OFFSET + pdev->id * 4, val);
+
+	clkrate = clk_get_rate(clk);
+
+	if (pdata->timing)
+		ret = davinci_aemif_setup_timing(pdata->timing, base, pdev->id,
+						 clkrate);
+
+	if (ret < 0)
+		dev_dbg(&pdev->dev, "NAND timing values setup fail\n");
+
+	iounmap(base);
+err:
+	clk_disable_unprepare(clk);
+	clk_put(clk);
+	return ret;
+}
diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
index d1f45af..5623131 100644
--- a/arch/arm/mach-davinci/board-da830-evm.c
+++ b/arch/arm/mach-davinci/board-da830-evm.c
@@ -419,6 +419,9 @@ static inline void da830_evm_init_nand(int mux_mode)
 	if (ret)
 		pr_warning("da830_evm_init: NAND device not registered.\n");
 
+	if (davinci_aemif_setup(&da830_evm_nand_device))
+		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
+
 	gpio_direction_output(mux_mode, 1);
 }
 #else
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index e0af0ec..234c5bb 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -358,6 +358,9 @@ static inline void da850_evm_setup_nor_nand(void)
 
 		platform_add_devices(da850_evm_devices,
 					ARRAY_SIZE(da850_evm_devices));
+
+		if (davinci_aemif_setup(&da850_evm_nandflash_device))
+			pr_warn("%s: Cannot configure AEMIF.\n", __func__);
 	}
 }
 
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 987605b7..5602957 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -778,6 +778,11 @@ static __init void davinci_evm_init(void)
 		/* only one device will be jumpered and detected */
 		if (HAS_NAND) {
 			platform_device_register(&davinci_evm_nandflash_device);
+
+			if (davinci_aemif_setup(&davinci_evm_nandflash_device))
+				pr_warn("%s: Cannot configure AEMIF.\n",
+					__func__);
+
 			evm_leds[7].default_trigger = "nand-disk";
 			if (HAS_NOR)
 				pr_warning("WARNING: both NAND and NOR flash "
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 13d0801..ae129bc 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -805,6 +805,9 @@ static __init void evm_init(void)
 
 	platform_device_register(&davinci_nand_device);
 
+	if (davinci_aemif_setup(&davinci_nand_device))
+		pr_warn("%s: Cannot configure AEMIF.\n", __func__);
+
 	dm646x_init_edma(dm646x_edma_rsv);
 
 	if (HAS_ATA)
diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index b77a01e..6cc506c 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -734,28 +734,6 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
 		goto err_clk_enable;
 	}
 
-	/*
-	 * Setup Async configuration register in case we did not boot from
-	 * NAND and so bootloader did not bother to set it up.
-	 */
-	val = davinci_nand_readl(info, A1CR_OFFSET + info->core_chipsel * 4);
-
-	/* Extended Wait is not valid and Select Strobe mode is not used */
-	val &= ~(ACR_ASIZE_MASK | ACR_EW_MASK | ACR_SS_MASK);
-	if (info->chip.options & NAND_BUSWIDTH_16)
-		val |= 0x1;
-
-	davinci_nand_writel(info, A1CR_OFFSET + info->core_chipsel * 4, val);
-
-	ret = 0;
-	if (info->timing)
-		ret = davinci_aemif_setup_timing(info->timing, info->base,
-							info->core_chipsel);
-	if (ret < 0) {
-		dev_dbg(&pdev->dev, "NAND timing values setup fail\n");
-		goto err_timing;
-	}
-
 	spin_lock_irq(&davinci_nand_lock);
 
 	/* put CSxNAND into NAND mode */
@@ -844,7 +822,6 @@ syndrome_done:
 	return 0;
 
 err_scan:
-err_timing:
 	clk_disable_unprepare(info->clk);
 
 err_clk_enable:
diff --git a/include/linux/platform_data/mtd-davinci-aemif.h b/include/linux/platform_data/mtd-davinci-aemif.h
index 05b2934..97948ac 100644
--- a/include/linux/platform_data/mtd-davinci-aemif.h
+++ b/include/linux/platform_data/mtd-davinci-aemif.h
@@ -10,6 +10,8 @@
 #ifndef _MACH_DAVINCI_AEMIF_H
 #define _MACH_DAVINCI_AEMIF_H
 
+#include <linux/platform_device.h>
+
 #define NRCSR_OFFSET		0x00
 #define AWCCR_OFFSET		0x04
 #define A1CR_OFFSET		0x10
@@ -31,6 +33,5 @@ struct davinci_aemif_timing {
 	u8	ta;
 };
 
-int davinci_aemif_setup_timing(struct davinci_aemif_timing *t,
-					void __iomem *base, unsigned cs);
+int davinci_aemif_setup(struct platform_device *pdev);
 #endif
-- 
1.7.10.1






