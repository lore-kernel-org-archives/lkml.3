Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaFKI63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:58:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33082 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbaFKI6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:22 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 18/36] ARM: OMAP2+: gpmc-onenand: Move Synchronous setting code to drivers/
Date: Wed, 11 Jun 2014 11:56:23 +0300
Message-ID: <1402477001-31132-19-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code that puts the onenand in synchronous mode
into the appropriate place i.e. drivers/mtd/onenand/omap2.c.

Make use of omap_gpmc_get_clk_period() and omap_gpmc_retime()
to calculate the necessary timings and configure the GPMC
parent's timings.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc-onenand.c              | 262 +----------------------
 drivers/mtd/onenand/omap2.c                     | 264 +++++++++++++++++++++++-
 include/linux/platform_data/mtd-onenand-omap2.h |   2 +-
 3 files changed, 258 insertions(+), 270 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc-onenand.c b/arch/arm/mach-omap2/gpmc-onenand.c
index bed8efe..d09c342 100644
--- a/arch/arm/mach-omap2/gpmc-onenand.c
+++ b/arch/arm/mach-omap2/gpmc-onenand.c
@@ -26,16 +26,6 @@
 
 #define	ONENAND_IO_SIZE	SZ_128K
 
-#define	ONENAND_FLAG_SYNCREAD	(1 << 0)
-#define	ONENAND_FLAG_SYNCWRITE	(1 << 1)
-#define	ONENAND_FLAG_HF		(1 << 2)
-#define	ONENAND_FLAG_VHF	(1 << 3)
-
-static unsigned onenand_flags;
-static unsigned latency;
-
-static struct omap_onenand_platform_data *gpmc_onenand_data;
-
 static struct resource gpmc_onenand_resource = {
 	.flags		= IORESOURCE_MEM,
 };
@@ -52,15 +42,6 @@ static struct gpmc_settings onenand_async = {
 	.mux_add_data	= GPMC_MUX_AD,
 };
 
-static struct gpmc_settings onenand_sync = {
-	.burst_read	= true,
-	.burst_wrap	= true,
-	.burst_len	= GPMC_BURST_16,
-	.device_width	= GPMC_DEVWIDTH_16BIT,
-	.mux_add_data	= GPMC_MUX_AD,
-	.wait_pin	= 0,
-};
-
 static void omap2_onenand_get_async_timings(struct gpmc_device_timings *dev_t)
 {
 	const int t_cer = 15;
@@ -87,184 +68,8 @@ static void omap2_onenand_get_async_timings(struct gpmc_device_timings *dev_t)
 	dev_t->t_wph = t_wph * 1000;
 }
 
-static void omap2_onenand_set_async_mode(void __iomem *onenand_base)
-{
-	u32 reg;
-
-	/* Ensure sync read and sync write are disabled */
-	reg = readw(onenand_base + ONENAND_REG_SYS_CFG1);
-	reg &= ~ONENAND_SYS_CFG1_SYNC_READ & ~ONENAND_SYS_CFG1_SYNC_WRITE;
-	writew(reg, onenand_base + ONENAND_REG_SYS_CFG1);
-}
-
-static void set_onenand_cfg(void __iomem *onenand_base)
-{
-	u32 reg;
-
-	reg = readw(onenand_base + ONENAND_REG_SYS_CFG1);
-	reg &= ~((0x7 << ONENAND_SYS_CFG1_BRL_SHIFT) | (0x7 << 9));
-	reg |=	(latency << ONENAND_SYS_CFG1_BRL_SHIFT) |
-		ONENAND_SYS_CFG1_BL_16;
-	if (onenand_flags & ONENAND_FLAG_SYNCREAD)
-		reg |= ONENAND_SYS_CFG1_SYNC_READ;
-	else
-		reg &= ~ONENAND_SYS_CFG1_SYNC_READ;
-	if (onenand_flags & ONENAND_FLAG_SYNCWRITE)
-		reg |= ONENAND_SYS_CFG1_SYNC_WRITE;
-	else
-		reg &= ~ONENAND_SYS_CFG1_SYNC_WRITE;
-	if (onenand_flags & ONENAND_FLAG_HF)
-		reg |= ONENAND_SYS_CFG1_HF;
-	else
-		reg &= ~ONENAND_SYS_CFG1_HF;
-	if (onenand_flags & ONENAND_FLAG_VHF)
-		reg |= ONENAND_SYS_CFG1_VHF;
-	else
-		reg &= ~ONENAND_SYS_CFG1_VHF;
-	writew(reg, onenand_base + ONENAND_REG_SYS_CFG1);
-}
-
-static int omap2_onenand_get_freq(struct omap_onenand_platform_data *cfg,
-				  void __iomem *onenand_base)
-{
-	u16 ver = readw(onenand_base + ONENAND_REG_VERSION_ID);
-	int freq;
-
-	switch ((ver >> 4) & 0xf) {
-	case 0:
-		freq = 40;
-		break;
-	case 1:
-		freq = 54;
-		break;
-	case 2:
-		freq = 66;
-		break;
-	case 3:
-		freq = 83;
-		break;
-	case 4:
-		freq = 104;
-		break;
-	default:
-		freq = 54;
-		break;
-	}
-
-	return freq;
-}
-
-static void omap2_onenand_calc_sync_timings(struct gpmc_timings *t,
-					    unsigned int flags,
-					    int freq)
-{
-	struct gpmc_device_timings dev_t;
-	const int t_cer  = 15;
-	const int t_avdp = 12;
-	const int t_cez  = 20; /* max of t_cez, t_oez */
-	const int t_wpl  = 40;
-	const int t_wph  = 30;
-	int min_gpmc_clk_period, t_ces, t_avds, t_avdh, t_ach, t_aavdh, t_rdyo;
-	int div, gpmc_clk_ns;
-
-	if (flags & ONENAND_SYNC_READ)
-		onenand_flags = ONENAND_FLAG_SYNCREAD;
-	else if (flags & ONENAND_SYNC_READWRITE)
-		onenand_flags = ONENAND_FLAG_SYNCREAD | ONENAND_FLAG_SYNCWRITE;
-
-	switch (freq) {
-	case 104:
-		min_gpmc_clk_period = 9600; /* 104 MHz */
-		t_ces   = 3;
-		t_avds  = 4;
-		t_avdh  = 2;
-		t_ach   = 3;
-		t_aavdh = 6;
-		t_rdyo  = 6;
-		break;
-	case 83:
-		min_gpmc_clk_period = 12000; /* 83 MHz */
-		t_ces   = 5;
-		t_avds  = 4;
-		t_avdh  = 2;
-		t_ach   = 6;
-		t_aavdh = 6;
-		t_rdyo  = 9;
-		break;
-	case 66:
-		min_gpmc_clk_period = 15000; /* 66 MHz */
-		t_ces   = 6;
-		t_avds  = 5;
-		t_avdh  = 2;
-		t_ach   = 6;
-		t_aavdh = 6;
-		t_rdyo  = 11;
-		break;
-	default:
-		min_gpmc_clk_period = 18500; /* 54 MHz */
-		t_ces   = 7;
-		t_avds  = 7;
-		t_avdh  = 7;
-		t_ach   = 9;
-		t_aavdh = 7;
-		t_rdyo  = 15;
-		onenand_flags &= ~ONENAND_FLAG_SYNCWRITE;
-		break;
-	}
-
-	div = gpmc_calc_divider(min_gpmc_clk_period);
-	gpmc_clk_ns = gpmc_ticks_to_ns(div);
-	if (gpmc_clk_ns < 15) /* >66Mhz */
-		onenand_flags |= ONENAND_FLAG_HF;
-	else
-		onenand_flags &= ~ONENAND_FLAG_HF;
-	if (gpmc_clk_ns < 12) /* >83Mhz */
-		onenand_flags |= ONENAND_FLAG_VHF;
-	else
-		onenand_flags &= ~ONENAND_FLAG_VHF;
-	if (onenand_flags & ONENAND_FLAG_VHF)
-		latency = 8;
-	else if (onenand_flags & ONENAND_FLAG_HF)
-		latency = 6;
-	else if (gpmc_clk_ns >= 25) /* 40 MHz*/
-		latency = 3;
-	else
-		latency = 4;
-
-	/* Set synchronous read timings */
-	memset(&dev_t, 0, sizeof(dev_t));
-
-	if (onenand_flags & ONENAND_FLAG_SYNCREAD)
-		onenand_sync.sync_read = true;
-	if (onenand_flags & ONENAND_FLAG_SYNCWRITE) {
-		onenand_sync.sync_write = true;
-		onenand_sync.burst_write = true;
-	} else {
-		dev_t.t_avdp_w = max(t_avdp, t_cer) * 1000;
-		dev_t.t_wpl = t_wpl * 1000;
-		dev_t.t_wph = t_wph * 1000;
-		dev_t.t_aavdh = t_aavdh * 1000;
-	}
-	dev_t.ce_xdelay = true;
-	dev_t.avd_xdelay = true;
-	dev_t.oe_xdelay = true;
-	dev_t.we_xdelay = true;
-	dev_t.clk = min_gpmc_clk_period;
-	dev_t.t_bacc = dev_t.clk;
-	dev_t.t_ces = t_ces * 1000;
-	dev_t.t_avds = t_avds * 1000;
-	dev_t.t_avdh = t_avdh * 1000;
-	dev_t.t_ach = t_ach * 1000;
-	dev_t.cyc_iaa = (latency + 1);
-	dev_t.t_cez_r = t_cez * 1000;
-	dev_t.t_cez_w = dev_t.t_cez_r;
-	dev_t.cyc_aavdh_oe = 1;
-	dev_t.t_rdyo = t_rdyo * 1000 + min_gpmc_clk_period;
-
-	gpmc_calc_timings(t, &onenand_sync, &dev_t);
-}
-
-static int omap2_onenand_setup_async(void)
+static int omap2_onenand_setup_async(struct omap_onenand_platform_data
+				     *gpmc_onenand_data)
 {
 	struct gpmc_timings gpmc_t;
 	struct gpmc_device_timings dev_t;
@@ -296,70 +101,11 @@ static int omap2_onenand_setup_async(void)
 	return 0;
 }
 
-static int omap2_onenand_setup_sync(void __iomem *onenand_base, int *freq_ptr)
-{
-	int ret, freq = *freq_ptr;
-	struct gpmc_timings t;
-
-	if (!freq) {
-		/* Very first call freq is not known */
-		freq = omap2_onenand_get_freq(gpmc_onenand_data, onenand_base);
-		set_onenand_cfg(onenand_base);
-	}
-
-	if (gpmc_onenand_data->of_node) {
-		gpmc_read_settings_dt(gpmc_onenand_data->of_node,
-				      &onenand_sync);
-	} else {
-		/*
-		 * FIXME: Appears to be legacy code from initial ONENAND commit.
-		 * Unclear what boards this is for and if this can be removed.
-		 */
-		if (!cpu_is_omap34xx())
-			onenand_sync.wait_on_read = true;
-	}
-
-	omap2_onenand_calc_sync_timings(&t, gpmc_onenand_data->flags, freq);
-
-	ret = gpmc_cs_program_settings(gpmc_onenand_data->cs, &onenand_sync);
-	if (ret < 0)
-		return ret;
-
-	ret = gpmc_cs_set_timings(gpmc_onenand_data->cs, &t);
-	if (ret < 0)
-		return ret;
-
-	set_onenand_cfg(onenand_base);
-
-	*freq_ptr = freq;
-
-	return 0;
-}
-
-static int gpmc_onenand_setup(void __iomem *onenand_base, int *freq_ptr)
-{
-	struct device *dev = &gpmc_onenand_device.dev;
-	unsigned l = ONENAND_SYNC_READ | ONENAND_SYNC_READWRITE;
-	int ret;
-
-	omap2_onenand_set_async_mode(onenand_base);
-
-	if (!(gpmc_onenand_data->flags & l))
-		return 0;
-
-	ret = omap2_onenand_setup_sync(onenand_base, freq_ptr);
-	if (ret)
-		dev_err(dev, "unable to set to sync mode\n");
-	return ret;
-}
-
-void gpmc_onenand_init(struct omap_onenand_platform_data *_onenand_data)
+void gpmc_onenand_init(struct omap_onenand_platform_data *gpmc_onenand_data)
 {
 	int err;
 	struct device *dev = &gpmc_onenand_device.dev;
 
-	gpmc_onenand_data = _onenand_data;
-	gpmc_onenand_data->onenand_setup = gpmc_onenand_setup;
 	gpmc_onenand_device.dev.platform_data = gpmc_onenand_data;
 
 	if (cpu_is_omap24xx() &&
@@ -385,7 +131,7 @@ void gpmc_onenand_init(struct omap_onenand_platform_data *_onenand_data)
 	gpmc_onenand_resource.end = gpmc_onenand_resource.start +
 							ONENAND_IO_SIZE - 1;
 
-	if (omap2_onenand_setup_async()) {
+	if (omap2_onenand_setup_async(gpmc_onenand_data)) {
 		pr_err("%s: Failed to setup ASYNC timings\n", __func__);
 		goto fail;
 	}
diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index a5f5ad8..238dd7a 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -37,6 +37,7 @@
 
 #include <asm/mach/flash.h>
 #include <linux/platform_data/mtd-onenand-omap2.h>
+#include <linux/platform_data/gpmc-omap.h>
 #include <asm/gpio.h>
 
 #include <linux/omap-dma.h>
@@ -45,6 +46,12 @@
 
 #define ONENAND_BUFRAM_SIZE	(1024 * 5)
 
+/* Private flags */
+#define	ONENAND_FLAG_SYNCREAD	(1 << 0)
+#define	ONENAND_FLAG_SYNCWRITE	(1 << 1)
+#define	ONENAND_FLAG_HF		(1 << 2)
+#define	ONENAND_FLAG_VHF	(1 << 3)
+
 struct omap2_onenand {
 	struct platform_device *pdev;
 	int gpmc_cs;
@@ -57,8 +64,10 @@ struct omap2_onenand {
 	struct completion dma_done;
 	int dma_channel;
 	int freq;
-	int (*setup)(void __iomem *base, int *freq_ptr);
-	u8 flags;
+	u8 flags;		/* as per platform_data/mtd-onenand-omap2.h */
+	u8 priv_flags;		/* our internal flags */
+	unsigned latency;	/* latency settings for onenand SYS_CFG1 */
+	struct gpmc_settings sync_settings;	/* Synchronous GPMC settings */
 };
 
 static void omap2_onenand_dma_cb(int lch, u16 ch_status, void *data)
@@ -568,6 +577,243 @@ static int omap2_onenand_write_bufferram(struct mtd_info *mtd, int area,
 
 #endif
 
+static void set_onenand_cfg(struct omap2_onenand *c)
+{
+	u32 reg;
+
+	reg = read_reg(c, ONENAND_REG_SYS_CFG1);
+	reg &= ~((0x7 << ONENAND_SYS_CFG1_BRL_SHIFT) | (0x7 << 9));
+	reg |=	(c->latency << ONENAND_SYS_CFG1_BRL_SHIFT) |
+		ONENAND_SYS_CFG1_BL_16;
+	if (c->priv_flags & ONENAND_FLAG_SYNCREAD)
+		reg |= ONENAND_SYS_CFG1_SYNC_READ;
+	else
+		reg &= ~ONENAND_SYS_CFG1_SYNC_READ;
+
+	if (c->priv_flags & ONENAND_FLAG_SYNCWRITE)
+		reg |= ONENAND_SYS_CFG1_SYNC_WRITE;
+	else
+		reg &= ~ONENAND_SYS_CFG1_SYNC_WRITE;
+
+	if (c->priv_flags & ONENAND_FLAG_HF)
+		reg |= ONENAND_SYS_CFG1_HF;
+	else
+		reg &= ~ONENAND_SYS_CFG1_HF;
+
+	if (c->priv_flags & ONENAND_FLAG_VHF)
+		reg |= ONENAND_SYS_CFG1_VHF;
+	else
+		reg &= ~ONENAND_SYS_CFG1_VHF;
+
+	write_reg(c, reg, ONENAND_REG_SYS_CFG1);
+}
+
+static int omap2_onenand_get_freq(struct omap2_onenand *c)
+{
+	u16 ver = read_reg(c, ONENAND_REG_VERSION_ID);
+	int freq;
+
+	switch ((ver >> 4) & 0xf) {
+	case 0:
+		freq = 40;
+		break;
+	case 1:
+		freq = 54;
+		break;
+	case 2:
+		freq = 66;
+		break;
+	case 3:
+		freq = 83;
+		break;
+	case 4:
+		freq = 104;
+		break;
+	default:
+		freq = 54;
+		break;
+	}
+
+	return freq;
+}
+
+static void omap2_onenand_get_sync_timings(struct omap2_onenand *c,
+					   struct gpmc_device_timings *dev_t)
+{
+	const int t_cer  = 15;
+	const int t_avdp = 12;
+	const int t_cez  = 20; /* max of t_cez, t_oez */
+	const int t_wpl  = 40;
+	const int t_wph  = 30;
+	int min_gpmc_clk_period, t_ces, t_avds, t_avdh, t_ach, t_aavdh, t_rdyo;
+	int gpmc_clk_ns;
+
+	/*
+	 * Synchronous settings can't be read from platform data or DT as
+	 * they provide Asynchronous settings for maximum compatibility.
+	 * If required to be different, e.g. wait pin, then we need to add
+	 * that setting in platform data or DT for omap2-onenand device.
+	 */
+	c->sync_settings.burst_read = true;
+	c->sync_settings.burst_wrap = true;
+	c->sync_settings.burst_len = GPMC_BURST_16;
+	c->sync_settings.device_width = GPMC_DEVWIDTH_16BIT;
+	c->sync_settings.mux_add_data = GPMC_MUX_AD;
+	/*
+	 * FIXME: wait pin must come from platform_data or DT.
+	 * Till then, no wait pin monitoring
+	 */
+	c->sync_settings.wait_on_read = false;
+	c->sync_settings.wait_on_write = false;
+
+	if (!c->freq) {
+		/* Initially, freq is not known */
+		c->freq = omap2_onenand_get_freq(c);
+	}
+
+	if (c->flags & ONENAND_SYNC_READ)
+		c->priv_flags = ONENAND_FLAG_SYNCREAD;
+	else if (c->flags & ONENAND_SYNC_READWRITE)
+		c->priv_flags = ONENAND_FLAG_SYNCREAD | ONENAND_FLAG_SYNCWRITE;
+
+	switch (c->freq) {
+	case 104:
+		min_gpmc_clk_period = 9600; /* 104 MHz */
+		t_ces   = 3;
+		t_avds  = 4;
+		t_avdh  = 2;
+		t_ach   = 3;
+		t_aavdh = 6;
+		t_rdyo  = 6;
+		break;
+	case 83:
+		min_gpmc_clk_period = 12000; /* 83 MHz */
+		t_ces   = 5;
+		t_avds  = 4;
+		t_avdh  = 2;
+		t_ach   = 6;
+		t_aavdh = 6;
+		t_rdyo  = 9;
+		break;
+	case 66:
+		min_gpmc_clk_period = 15000; /* 66 MHz */
+		t_ces   = 6;
+		t_avds  = 5;
+		t_avdh  = 2;
+		t_ach   = 6;
+		t_aavdh = 6;
+		t_rdyo  = 11;
+		break;
+	default:
+		min_gpmc_clk_period = 18500; /* 54 MHz */
+		t_ces   = 7;
+		t_avds  = 7;
+		t_avdh  = 7;
+		t_ach   = 9;
+		t_aavdh = 7;
+		t_rdyo  = 15;
+		c->priv_flags &= ~ONENAND_FLAG_SYNCWRITE;
+		break;
+	}
+
+	gpmc_clk_ns = omap_gpmc_get_clk_period(c->gpmc_cs,
+					       min_gpmc_clk_period);
+	gpmc_clk_ns /= 1000; /* ps to ns */
+
+	if (gpmc_clk_ns < 15) /* >66Mhz */
+		c->priv_flags |= ONENAND_FLAG_HF;
+	else
+		c->priv_flags &= ~ONENAND_FLAG_HF;
+
+	if (gpmc_clk_ns < 12) /* >83Mhz */
+		c->priv_flags |= ONENAND_FLAG_VHF;
+	else
+		c->priv_flags &= ~ONENAND_FLAG_VHF;
+
+	if (c->priv_flags & ONENAND_FLAG_VHF)
+		c->latency = 8;
+	else if (c->priv_flags & ONENAND_FLAG_HF)
+		c->latency = 6;
+	else if (gpmc_clk_ns >= 25) /* 40 MHz*/
+		c->latency = 3;
+	else
+		c->latency = 4;
+
+	/* Set synchronous read timings */
+	memset(dev_t, 0, sizeof(*dev_t));
+
+	if (c->priv_flags & ONENAND_FLAG_SYNCREAD)
+		c->sync_settings.sync_read = true;
+	if (c->priv_flags & ONENAND_FLAG_SYNCWRITE) {
+		c->sync_settings.sync_write = true;
+		c->sync_settings.burst_write = true;
+	} else {
+		dev_t->t_avdp_w = max(t_avdp, t_cer) * 1000;
+		dev_t->t_wpl = t_wpl * 1000;
+		dev_t->t_wph = t_wph * 1000;
+		dev_t->t_aavdh = t_aavdh * 1000;
+	}
+	dev_t->ce_xdelay = true;
+	dev_t->avd_xdelay = true;
+	dev_t->oe_xdelay = true;
+	dev_t->we_xdelay = true;
+	dev_t->clk = min_gpmc_clk_period;
+	dev_t->t_bacc = dev_t->clk;
+	dev_t->t_ces = t_ces * 1000;
+	dev_t->t_avds = t_avds * 1000;
+	dev_t->t_avdh = t_avdh * 1000;
+	dev_t->t_ach = t_ach * 1000;
+	dev_t->cyc_iaa = (c->latency + 1);
+	dev_t->t_cez_r = t_cez * 1000;
+	dev_t->t_cez_w = dev_t->t_cez_r;
+	dev_t->cyc_aavdh_oe = 1;
+	dev_t->t_rdyo = t_rdyo * 1000 + min_gpmc_clk_period;
+}
+
+static int omap2_onenand_setup_sync(struct omap2_onenand *c)
+{
+	int ret;
+	struct gpmc_device_timings dev_t;
+
+	omap2_onenand_get_sync_timings(c, &dev_t);
+
+	ret = omap_gpmc_retime(c->gpmc_cs, &c->sync_settings, &dev_t);
+	if (ret < 0)
+		return ret;
+
+	set_onenand_cfg(c);
+
+	return 0;
+}
+
+static void omap2_onenand_set_async_mode(struct omap2_onenand *c)
+{
+	u32 reg;
+
+	/* Ensure sync read and sync write are disabled */
+	reg = read_reg(c, ONENAND_REG_SYS_CFG1);
+	reg &= ~ONENAND_SYS_CFG1_SYNC_READ & ~ONENAND_SYS_CFG1_SYNC_WRITE;
+	write_reg(c, reg, ONENAND_REG_SYS_CFG1);
+}
+
+static int omap2_onenand_setup(struct omap2_onenand *c)
+{
+	struct device *dev = &c->pdev->dev;
+	unsigned l = ONENAND_SYNC_READ | ONENAND_SYNC_READWRITE;
+	int ret;
+
+	omap2_onenand_set_async_mode(c);
+
+	if (!(c->flags & l))
+		return 0;
+
+	ret = omap2_onenand_setup_sync(c);
+	if (ret)
+		dev_err(dev, "unable to switch to Synchronous mode\n");
+
+	return ret;
+}
+
 static struct platform_driver omap2_onenand_driver;
 
 static void omap2_onenand_shutdown(struct platform_device *pdev)
@@ -602,6 +848,7 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 
 	init_completion(&c->irq_done);
 	init_completion(&c->dma_done);
+	c->pdev = pdev;
 	c->flags = pdata->flags;
 	c->gpmc_cs = pdata->cs;
 	c->gpio_irq = pdata->gpio_irq;
@@ -634,14 +881,10 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 		goto err_release_mem_region;
 	}
 
-	if (pdata->onenand_setup != NULL) {
-		r = pdata->onenand_setup(c->onenand.base, &c->freq);
-		if (r < 0) {
-			dev_err(&pdev->dev, "Onenand platform setup failed: "
-				"%d\n", r);
-			goto err_iounmap;
-		}
-		c->setup = pdata->onenand_setup;
+	r = omap2_onenand_setup(c);
+	if (r < 0) {
+		dev_err(&pdev->dev, "setup failed:%d\n", r);
+		goto err_iounmap;
 	}
 
 	if (c->gpio_irq) {
@@ -683,7 +926,6 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 		 "base %p, freq %d MHz\n", c->gpmc_cs, c->phys_base,
 		 c->onenand.base, c->freq);
 
-	c->pdev = pdev;
 	c->mtd.name = dev_name(&pdev->dev);
 	c->mtd.priv = &c->onenand;
 	c->mtd.owner = THIS_MODULE;
diff --git a/include/linux/platform_data/mtd-onenand-omap2.h b/include/linux/platform_data/mtd-onenand-omap2.h
index 445b41e..ac1e6f3 100644
--- a/include/linux/platform_data/mtd-onenand-omap2.h
+++ b/include/linux/platform_data/mtd-onenand-omap2.h
@@ -22,7 +22,6 @@ struct omap_onenand_platform_data {
 	int			gpio_irq;
 	struct mtd_partition	*parts;
 	int			nr_parts;
-	int			(*onenand_setup)(void __iomem *, int *freq_ptr);
 	int			dma_channel;
 	u8			flags;
 	u8			skip_initial_unlocking;
@@ -31,5 +30,6 @@ struct omap_onenand_platform_data {
 	struct device_node	*of_node;
 
 	u8			regulator_can_sleep;	/* deprecated */
+	int (*onenand_setup)(void __iomem *, int *freq_ptr);	/* deprecated */
 };
 #endif
-- 
1.8.3.2

