Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaEWKb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:31:59 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54217 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaEWKb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:31:57 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 16/71] clocksource: sh_cmt: Add support for multiple channels per device
Date: Fri, 23 May 2014 12:30:56 +0200
Message-Id: <1400841111-6683-16-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

CMT hardware devices can support multiple channels, with global
registers and per-channel registers. The sh_cmt driver currently models
the hardware with one Linux device per channel. This model makes it
difficult to handle global registers in a clean way.

Add support for a new model that uses one Linux device per timer with
multiple channels per device. This requires changes to platform data,
add new channel configuration fields.

Support for the legacy model is kept and will be removed after all
platforms switch to the new model.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c |  304 ++++++++++++++++++++++++++++++++----------
 include/linux/sh_timer.h     |    1 +
 2 files changed, 237 insertions(+), 68 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index c753efc..1efe7d6 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -53,7 +53,16 @@ struct sh_cmt_device;
  * channel registers block. All other versions have a shared start/stop register
  * located in the global space.
  *
- * Note that CMT0 on r8a73a4, r8a7790 and r8a7791, while implementing 32-bit
+ * Channels are indexed from 0 to N-1 in the documentation. The channel index
+ * infers the start/stop bit position in the control register and the channel
+ * registers block address. Some CMT instances have a subset of channels
+ * available, in which case the index in the documentation doesn't match the
+ * "real" index as implemented in hardware. This is for instance the case with
+ * CMT0 on r8a7740, which is a 32-bit variant with a single channel numbered 0
+ * in the documentation but using start/stop bit 5 and having its registers
+ * block at 0x60.
+ *
+ * Similarly CMT0 on r8a73a4, r8a7790 and r8a7791, while implementing 32-bit
  * channels only, is a 48-bit gen2 CMT with the 48-bit channels unavailable.
  */
 
@@ -85,10 +94,14 @@ struct sh_cmt_info {
 
 struct sh_cmt_channel {
 	struct sh_cmt_device *cmt;
-	unsigned int index;
 
-	void __iomem *base;
+	unsigned int index;	/* Index in the documentation */
+	unsigned int hwidx;	/* Real hardware index */
+
+	void __iomem *iostart;
+	void __iomem *ioctrl;
 
+	unsigned int timer_bit;
 	unsigned long flags;
 	unsigned long match_value;
 	unsigned long next_match_value;
@@ -105,6 +118,7 @@ struct sh_cmt_device {
 	struct platform_device *pdev;
 
 	const struct sh_cmt_info *info;
+	bool legacy;
 
 	void __iomem *mapbase_ch;
 	void __iomem *mapbase;
@@ -112,6 +126,9 @@ struct sh_cmt_device {
 
 	struct sh_cmt_channel *channels;
 	unsigned int num_channels;
+
+	bool has_clockevent;
+	bool has_clocksource;
 };
 
 #define SH_CMT16_CMCSR_CMF		(1 << 7)
@@ -223,41 +240,47 @@ static const struct sh_cmt_info sh_cmt_info[] = {
 
 static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_channel *ch)
 {
-	return ch->cmt->info->read_control(ch->cmt->mapbase, 0);
+	if (ch->iostart)
+		return ch->cmt->info->read_control(ch->iostart, 0);
+	else
+		return ch->cmt->info->read_control(ch->cmt->mapbase, 0);
 }
 
-static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_channel *ch)
+static inline void sh_cmt_write_cmstr(struct sh_cmt_channel *ch,
+				      unsigned long value)
 {
-	return ch->cmt->info->read_control(ch->base, CMCSR);
+	if (ch->iostart)
+		ch->cmt->info->write_control(ch->iostart, 0, value);
+	else
+		ch->cmt->info->write_control(ch->cmt->mapbase, 0, value);
 }
 
-static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_channel *ch)
+static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_channel *ch)
 {
-	return ch->cmt->info->read_count(ch->base, CMCNT);
+	return ch->cmt->info->read_control(ch->ioctrl, CMCSR);
 }
 
-static inline void sh_cmt_write_cmstr(struct sh_cmt_channel *ch,
+static inline void sh_cmt_write_cmcsr(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->info->write_control(ch->cmt->mapbase, 0, value);
+	ch->cmt->info->write_control(ch->ioctrl, CMCSR, value);
 }
 
-static inline void sh_cmt_write_cmcsr(struct sh_cmt_channel *ch,
-				      unsigned long value)
+static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_channel *ch)
 {
-	ch->cmt->info->write_control(ch->base, CMCSR, value);
+	return ch->cmt->info->read_count(ch->ioctrl, CMCNT);
 }
 
 static inline void sh_cmt_write_cmcnt(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->info->write_count(ch->base, CMCNT, value);
+	ch->cmt->info->write_count(ch->ioctrl, CMCNT, value);
 }
 
 static inline void sh_cmt_write_cmcor(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->info->write_count(ch->base, CMCOR, value);
+	ch->cmt->info->write_count(ch->ioctrl, CMCOR, value);
 }
 
 static unsigned long sh_cmt_get_counter(struct sh_cmt_channel *ch,
@@ -286,7 +309,6 @@ static DEFINE_RAW_SPINLOCK(sh_cmt_lock);
 
 static void sh_cmt_start_stop_ch(struct sh_cmt_channel *ch, int start)
 {
-	struct sh_timer_config *cfg = ch->cmt->pdev->dev.platform_data;
 	unsigned long flags, value;
 
 	/* start stop register shared by multiple timer channels */
@@ -294,9 +316,9 @@ static void sh_cmt_start_stop_ch(struct sh_cmt_channel *ch, int start)
 	value = sh_cmt_read_cmstr(ch);
 
 	if (start)
-		value |= 1 << cfg->timer_bit;
+		value |= 1 << ch->timer_bit;
 	else
-		value &= ~(1 << cfg->timer_bit);
+		value &= ~(1 << ch->timer_bit);
 
 	sh_cmt_write_cmstr(ch, value);
 	raw_spin_unlock_irqrestore(&sh_cmt_lock, flags);
@@ -790,27 +812,72 @@ static void sh_cmt_register_clockevent(struct sh_cmt_channel *ch,
 static int sh_cmt_register(struct sh_cmt_channel *ch, const char *name,
 			   bool clockevent, bool clocksource)
 {
-	if (clockevent)
+	if (clockevent) {
+		ch->cmt->has_clockevent = true;
 		sh_cmt_register_clockevent(ch, name);
+	}
 
-	if (clocksource)
+	if (clocksource) {
+		ch->cmt->has_clocksource = true;
 		sh_cmt_register_clocksource(ch, name);
+	}
 
 	return 0;
 }
 
 static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
-				struct sh_cmt_device *cmt)
+				unsigned int hwidx, bool clockevent,
+				bool clocksource, struct sh_cmt_device *cmt)
 {
-	struct sh_timer_config *cfg = cmt->pdev->dev.platform_data;
 	int irq;
 	int ret;
 
+	/* Skip unused channels. */
+	if (!clockevent && !clocksource)
+		return 0;
+
 	ch->cmt = cmt;
-	ch->base = cmt->mapbase_ch;
 	ch->index = index;
+	ch->hwidx = hwidx;
+
+	/*
+	 * Compute the address of the channel control register block. For the
+	 * timers with a per-channel start/stop register, compute its address
+	 * as well.
+	 *
+	 * For legacy configuration the address has been mapped explicitly.
+	 */
+	if (cmt->legacy) {
+		ch->ioctrl = cmt->mapbase_ch;
+	} else {
+		switch (cmt->info->model) {
+		case SH_CMT_16BIT:
+			ch->ioctrl = cmt->mapbase + 2 + ch->hwidx * 6;
+			break;
+		case SH_CMT_32BIT:
+		case SH_CMT_48BIT:
+			ch->ioctrl = cmt->mapbase + 0x10 + ch->hwidx * 0x10;
+			break;
+		case SH_CMT_32BIT_FAST:
+			/*
+			 * The 32-bit "fast" timer has a single channel at hwidx
+			 * 5 but is located at offset 0x40 instead of 0x60 for
+			 * some reason.
+			 */
+			ch->ioctrl = cmt->mapbase + 0x40;
+			break;
+		case SH_CMT_48BIT_GEN2:
+			ch->iostart = cmt->mapbase + ch->hwidx * 0x100;
+			ch->ioctrl = ch->iostart + 0x10;
+			break;
+		}
+	}
+
+	if (cmt->legacy)
+		irq = platform_get_irq(cmt->pdev, 0);
+	else
+		irq = platform_get_irq(cmt->pdev, ch->index);
 
-	irq = platform_get_irq(cmt->pdev, 0);
 	if (irq < 0) {
 		dev_err(&cmt->pdev->dev, "ch%u: failed to get irq\n",
 			ch->index);
@@ -825,9 +892,15 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 	ch->match_value = ch->max_match_value;
 	raw_spin_lock_init(&ch->lock);
 
+	if (cmt->legacy) {
+		ch->timer_bit = ch->hwidx;
+	} else {
+		ch->timer_bit = cmt->info->model == SH_CMT_48BIT_GEN2
+			      ? 0 : ch->hwidx;
+	}
+
 	ret = sh_cmt_register(ch, dev_name(&cmt->pdev->dev),
-			      cfg->clockevent_rating != 0,
-			      cfg->clocksource_rating != 0);
+			      clockevent, clocksource);
 	if (ret) {
 		dev_err(&cmt->pdev->dev, "ch%u: registration failed\n",
 			ch->index);
@@ -847,97 +920,180 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 	return 0;
 }
 
-static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
+static int sh_cmt_map_memory(struct sh_cmt_device *cmt)
 {
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
-	struct resource *res, *res2;
-	int ret;
-	ret = -ENXIO;
+	struct resource *mem;
 
-	cmt->pdev = pdev;
+	mem = platform_get_resource(cmt->pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&cmt->pdev->dev, "failed to get I/O memory\n");
+		return -ENXIO;
+	}
 
-	if (!cfg) {
-		dev_err(&cmt->pdev->dev, "missing platform data\n");
-		goto err0;
+	cmt->mapbase = ioremap_nocache(mem->start, resource_size(mem));
+	if (cmt->mapbase == NULL) {
+		dev_err(&cmt->pdev->dev, "failed to remap I/O memory\n");
+		return -ENXIO;
 	}
 
+	return 0;
+}
+
+static int sh_cmt_map_memory_legacy(struct sh_cmt_device *cmt)
+{
+	struct sh_timer_config *cfg = cmt->pdev->dev.platform_data;
+	struct resource *res, *res2;
+
+	/* map memory, let mapbase_ch point to our channel */
 	res = platform_get_resource(cmt->pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&cmt->pdev->dev, "failed to get I/O memory\n");
-		goto err0;
+		return -ENXIO;
 	}
 
-	/* optional resource for the shared timer start/stop register */
-	res2 = platform_get_resource(cmt->pdev, IORESOURCE_MEM, 1);
-
-	/* map memory, let mapbase_ch point to our channel */
 	cmt->mapbase_ch = ioremap_nocache(res->start, resource_size(res));
 	if (cmt->mapbase_ch == NULL) {
 		dev_err(&cmt->pdev->dev, "failed to remap I/O memory\n");
-		goto err0;
+		return -ENXIO;
 	}
 
+	/* optional resource for the shared timer start/stop register */
+	res2 = platform_get_resource(cmt->pdev, IORESOURCE_MEM, 1);
+
 	/* map second resource for CMSTR */
 	cmt->mapbase = ioremap_nocache(res2 ? res2->start :
 				       res->start - cfg->channel_offset,
 				       res2 ? resource_size(res2) : 2);
 	if (cmt->mapbase == NULL) {
 		dev_err(&cmt->pdev->dev, "failed to remap I/O second memory\n");
-		goto err1;
+		iounmap(cmt->mapbase_ch);
+		return -ENXIO;
 	}
 
-	/* get hold of clock */
+	/* identify the model based on the resources */
+	if (resource_size(res) == 6)
+		cmt->info = &sh_cmt_info[SH_CMT_16BIT];
+	else if (res2 && (resource_size(res2) == 4))
+		cmt->info = &sh_cmt_info[SH_CMT_48BIT_GEN2];
+	else
+		cmt->info = &sh_cmt_info[SH_CMT_32BIT];
+
+	return 0;
+}
+
+static void sh_cmt_unmap_memory(struct sh_cmt_device *cmt)
+{
+	iounmap(cmt->mapbase);
+	if (cmt->mapbase_ch)
+		iounmap(cmt->mapbase_ch);
+}
+
+static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
+{
+	struct sh_timer_config *cfg = pdev->dev.platform_data;
+	const struct platform_device_id *id = pdev->id_entry;
+	unsigned int hw_channels;
+	int ret;
+
+	memset(cmt, 0, sizeof(*cmt));
+	cmt->pdev = pdev;
+
+	if (!cfg) {
+		dev_err(&cmt->pdev->dev, "missing platform data\n");
+		return -ENXIO;
+	}
+
+	cmt->info = (const struct sh_cmt_info *)id->driver_data;
+	cmt->legacy = cmt->info ? false : true;
+
+	/* Get hold of clock. */
 	cmt->clk = clk_get(&cmt->pdev->dev, "cmt_fck");
 	if (IS_ERR(cmt->clk)) {
 		dev_err(&cmt->pdev->dev, "cannot get clock\n");
-		ret = PTR_ERR(cmt->clk);
-		goto err2;
+		return PTR_ERR(cmt->clk);
 	}
 
 	ret = clk_prepare(cmt->clk);
 	if (ret < 0)
-		goto err3;
+		goto err_clk_put;
 
-	/* identify the model based on the resources */
-	if (resource_size(res) == 6)
-		cmt->info = &sh_cmt_info[SH_CMT_16BIT];
-	else if (res2 && (resource_size(res2) == 4))
-		cmt->info = &sh_cmt_info[SH_CMT_48BIT_GEN2];
+	/*
+	 * Map the memory resource(s). We need to support both the legacy
+	 * platform device configuration (with one device per channel) and the
+	 * new version (with multiple channels per device).
+	 */
+	if (cmt->legacy)
+		ret = sh_cmt_map_memory_legacy(cmt);
 	else
-		cmt->info = &sh_cmt_info[SH_CMT_32BIT];
+		ret = sh_cmt_map_memory(cmt);
 
-	cmt->channels = kzalloc(sizeof(*cmt->channels), GFP_KERNEL);
+	if (ret < 0)
+		goto err_clk_unprepare;
+
+	/* Allocate and setup the channels. */
+	if (cmt->legacy) {
+		cmt->num_channels = 1;
+		hw_channels = 0;
+	} else {
+		cmt->num_channels = hweight8(cfg->channels_mask);
+		hw_channels = cfg->channels_mask;
+	}
+
+	cmt->channels = kzalloc(cmt->num_channels * sizeof(*cmt->channels),
+				GFP_KERNEL);
 	if (cmt->channels == NULL) {
 		ret = -ENOMEM;
-		goto err4;
+		goto err_unmap;
 	}
 
-	cmt->num_channels = 1;
+	if (cmt->legacy) {
+		ret = sh_cmt_setup_channel(&cmt->channels[0],
+					   cfg->timer_bit, cfg->timer_bit,
+					   cfg->clockevent_rating != 0,
+					   cfg->clocksource_rating != 0, cmt);
+		if (ret < 0)
+			goto err_unmap;
+	} else {
+		unsigned int mask = hw_channels;
+		unsigned int i;
 
-	ret = sh_cmt_setup_channel(&cmt->channels[0], cfg->timer_bit, cmt);
-	if (ret < 0)
-		goto err4;
+		/*
+		 * Use the first channel as a clock event device and the second
+		 * channel as a clock source. If only one channel is available
+		 * use it for both.
+		 */
+		for (i = 0; i < cmt->num_channels; ++i) {
+			unsigned int hwidx = ffs(mask) - 1;
+			bool clocksource = i == 1 || cmt->num_channels == 1;
+			bool clockevent = i == 0;
+
+			ret = sh_cmt_setup_channel(&cmt->channels[i], i, hwidx,
+						   clockevent, clocksource,
+						   cmt);
+			if (ret < 0)
+				goto err_unmap;
+
+			mask &= ~(1 << hwidx);
+		}
+	}
 
 	platform_set_drvdata(pdev, cmt);
 
 	return 0;
-err4:
+
+err_unmap:
 	kfree(cmt->channels);
+	sh_cmt_unmap_memory(cmt);
+err_clk_unprepare:
 	clk_unprepare(cmt->clk);
-err3:
+err_clk_put:
 	clk_put(cmt->clk);
-err2:
-	iounmap(cmt->mapbase);
-err1:
-	iounmap(cmt->mapbase_ch);
-err0:
 	return ret;
 }
 
 static int sh_cmt_probe(struct platform_device *pdev)
 {
 	struct sh_cmt_device *cmt = platform_get_drvdata(pdev);
-	struct sh_timer_config *cfg = pdev->dev.platform_data;
 	int ret;
 
 	if (!is_early_platform_device(pdev)) {
@@ -966,7 +1122,7 @@ static int sh_cmt_probe(struct platform_device *pdev)
 		return 0;
 
  out:
-	if (cfg->clockevent_rating || cfg->clocksource_rating)
+	if (cmt->has_clockevent || cmt->has_clocksource)
 		pm_runtime_irq_safe(&pdev->dev);
 	else
 		pm_runtime_idle(&pdev->dev);
@@ -979,12 +1135,24 @@ static int sh_cmt_remove(struct platform_device *pdev)
 	return -EBUSY; /* cannot unregister clockevent and clocksource */
 }
 
+static const struct platform_device_id sh_cmt_id_table[] = {
+	{ "sh_cmt", 0 },
+	{ "sh-cmt-16", (kernel_ulong_t)&sh_cmt_info[SH_CMT_16BIT] },
+	{ "sh-cmt-32", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT] },
+	{ "sh-cmt-32-fast", (kernel_ulong_t)&sh_cmt_info[SH_CMT_32BIT_FAST] },
+	{ "sh-cmt-48", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT] },
+	{ "sh-cmt-48-gen2", (kernel_ulong_t)&sh_cmt_info[SH_CMT_48BIT_GEN2] },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, sh_cmt_id_table);
+
 static struct platform_driver sh_cmt_device_driver = {
 	.probe		= sh_cmt_probe,
 	.remove		= sh_cmt_remove,
 	.driver		= {
 		.name	= "sh_cmt",
-	}
+	},
+	.id_table	= sh_cmt_id_table,
 };
 
 static int __init sh_cmt_init(void)
diff --git a/include/linux/sh_timer.h b/include/linux/sh_timer.h
index 4d9dcd1..8e1e036 100644
--- a/include/linux/sh_timer.h
+++ b/include/linux/sh_timer.h
@@ -7,6 +7,7 @@ struct sh_timer_config {
 	int timer_bit;
 	unsigned long clockevent_rating;
 	unsigned long clocksource_rating;
+	unsigned int channels_mask;
 };
 
 #endif /* __SH_TIMER_H__ */
-- 
1.7.9.5

