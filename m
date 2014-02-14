Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaBNA75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:59:57 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37461 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaBNA7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:59:11 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-sh@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 09/27] clocksource: sh_cmt: Split static information from sh_cmt_device
Date: Fri, 14 Feb 2014 01:59:47 +0100
Message-Id: <1392339605-20691-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new sh_cmt_info structure to hold static information about the
device model and reference that structure from the sh_cmt_device
structure.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_cmt.c | 192 +++++++++++++++++++++++++++----------------
 1 file changed, 122 insertions(+), 70 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 7a65d64..3946c14 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -37,6 +37,52 @@
 
 struct sh_cmt_device;
 
+/*
+ * The CMT comes in 5 different identified flavours, depending not only on the
+ * SoC but also on the particular instance. The following table lists the main
+ * characteristics of those flavours.
+ *
+ *			16B	32B	32B-F	48B	48B-2
+ * -----------------------------------------------------------------------------
+ * Channels		2	1/4	1	6	2/8
+ * Control Width	16	16	16	16	32
+ * Counter Width	16	32	32	32/48	32/48
+ * Shared Start/Stop	Y	Y	Y	Y	N
+ *
+ * The 48-bit gen2 version has a per-channel start/stop register located in the
+ * channel registers block. All other versions have a shared start/stop register
+ * located in the global space.
+ *
+ * Note that CMT0 on r8a73a4, r8a7790 and r8a7791, while implementing 32-bit
+ * channels only, is a 48-bit gen2 CMT with the 48-bit channels unavailable.
+ */
+
+enum sh_cmt_model {
+	SH_CMT_16BIT,
+	SH_CMT_32BIT,
+	SH_CMT_32BIT_FAST,
+	SH_CMT_48BIT,
+	SH_CMT_48BIT_GEN2,
+};
+
+struct sh_cmt_info {
+	enum sh_cmt_model model;
+
+	unsigned long width; /* 16 or 32 bit version of hardware block */
+	unsigned long overflow_bit;
+	unsigned long clear_bits;
+
+	/* callbacks for CMSTR and CMCSR access */
+	unsigned long (*read_control)(void __iomem *base, unsigned long offs);
+	void (*write_control)(void __iomem *base, unsigned long offs,
+			      unsigned long value);
+
+	/* callbacks for CMCNT and CMCOR access */
+	unsigned long (*read_count)(void __iomem *base, unsigned long offs);
+	void (*write_count)(void __iomem *base, unsigned long offs,
+			    unsigned long value);
+};
+
 struct sh_cmt_channel {
 	struct sh_cmt_device *cmt;
 	unsigned int index;
@@ -59,49 +105,16 @@ struct sh_cmt_channel {
 struct sh_cmt_device {
 	struct platform_device *pdev;
 
+	const struct sh_cmt_info *info;
+
 	void __iomem *mapbase_ch;
 	void __iomem *mapbase;
 	struct clk *clk;
 
 	struct sh_cmt_channel *channels;
 	unsigned int num_channels;
-
-	unsigned long width; /* 16 or 32 bit version of hardware block */
-	unsigned long overflow_bit;
-	unsigned long clear_bits;
-
-	/* callbacks for CMSTR and CMCSR access */
-	unsigned long (*read_control)(void __iomem *base, unsigned long offs);
-	void (*write_control)(void __iomem *base, unsigned long offs,
-			      unsigned long value);
-
-	/* callbacks for CMCNT and CMCOR access */
-	unsigned long (*read_count)(void __iomem *base, unsigned long offs);
-	void (*write_count)(void __iomem *base, unsigned long offs,
-			    unsigned long value);
 };
 
-/* Examples of supported CMT timer register layouts and I/O access widths:
- *
- * "16-bit counter and 16-bit control" as found on sh7263:
- * CMSTR 0xfffec000 16-bit
- * CMCSR 0xfffec002 16-bit
- * CMCNT 0xfffec004 16-bit
- * CMCOR 0xfffec006 16-bit
- *
- * "32-bit counter and 16-bit control" as found on sh7372, sh73a0, r8a7740:
- * CMSTR 0xffca0000 16-bit
- * CMCSR 0xffca0060 16-bit
- * CMCNT 0xffca0064 32-bit
- * CMCOR 0xffca0068 32-bit
- *
- * "32-bit counter and 32-bit control" as found on r8a73a4 and r8a7790:
- * CMSTR 0xffca0500 32-bit
- * CMCSR 0xffca0510 32-bit
- * CMCNT 0xffca0514 32-bit
- * CMCOR 0xffca0518 32-bit
- */
-
 static unsigned long sh_cmt_read16(void __iomem *base, unsigned long offs)
 {
 	return ioread16(base + (offs << 1));
@@ -124,47 +137,100 @@ static void sh_cmt_write32(void __iomem *base, unsigned long offs,
 	iowrite32(value, base + (offs << 2));
 }
 
+static const struct sh_cmt_info sh_cmt_info[] = {
+	[SH_CMT_16BIT] = {
+		.model = SH_CMT_16BIT,
+		.width = 16,
+		.overflow_bit = 0x80,
+		.clear_bits = ~0x80,
+		.read_control = sh_cmt_read16,
+		.write_control = sh_cmt_write16,
+		.read_count = sh_cmt_read16,
+		.write_count = sh_cmt_write16,
+	},
+	[SH_CMT_32BIT] = {
+		.model = SH_CMT_32BIT,
+		.width = 32,
+		.overflow_bit = 0x8000,
+		.clear_bits = ~0xc000,
+		.read_control = sh_cmt_read16,
+		.write_control = sh_cmt_write16,
+		.read_count = sh_cmt_read32,
+		.write_count = sh_cmt_write32,
+	},
+	[SH_CMT_32BIT_FAST] = {
+		.model = SH_CMT_32BIT_FAST,
+		.width = 32,
+		.overflow_bit = 0x8000,
+		.clear_bits = ~0xc000,
+		.read_control = sh_cmt_read16,
+		.write_control = sh_cmt_write16,
+		.read_count = sh_cmt_read32,
+		.write_count = sh_cmt_write32,
+	},
+	[SH_CMT_48BIT] = {
+		.model = SH_CMT_48BIT,
+		.width = 32,
+		.overflow_bit = 0x8000,
+		.clear_bits = ~0xc000,
+		.read_control = sh_cmt_read32,
+		.write_control = sh_cmt_write32,
+		.read_count = sh_cmt_read32,
+		.write_count = sh_cmt_write32,
+	},
+	[SH_CMT_48BIT_GEN2] = {
+		.model = SH_CMT_48BIT_GEN2,
+		.width = 32,
+		.overflow_bit = 0x8000,
+		.clear_bits = ~0xc000,
+		.read_control = sh_cmt_read32,
+		.write_control = sh_cmt_write32,
+		.read_count = sh_cmt_read32,
+		.write_count = sh_cmt_write32,
+	},
+};
+
 #define CMCSR 0 /* channel register */
 #define CMCNT 1 /* channel register */
 #define CMCOR 2 /* channel register */
 
 static inline unsigned long sh_cmt_read_cmstr(struct sh_cmt_channel *ch)
 {
-	return ch->cmt->read_control(ch->cmt->mapbase, 0);
+	return ch->cmt->info->read_control(ch->cmt->mapbase, 0);
 }
 
 static inline unsigned long sh_cmt_read_cmcsr(struct sh_cmt_channel *ch)
 {
-	return ch->cmt->read_control(ch->base, CMCSR);
+	return ch->cmt->info->read_control(ch->base, CMCSR);
 }
 
 static inline unsigned long sh_cmt_read_cmcnt(struct sh_cmt_channel *ch)
 {
-	return ch->cmt->read_count(ch->base, CMCNT);
+	return ch->cmt->info->read_count(ch->base, CMCNT);
 }
 
 static inline void sh_cmt_write_cmstr(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->write_control(ch->cmt->mapbase, 0, value);
+	ch->cmt->info->write_control(ch->cmt->mapbase, 0, value);
 }
 
 static inline void sh_cmt_write_cmcsr(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->write_control(ch->base, CMCSR, value);
+	ch->cmt->info->write_control(ch->base, CMCSR, value);
 }
 
 static inline void sh_cmt_write_cmcnt(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->write_count(ch->base, CMCNT, value);
+	ch->cmt->info->write_count(ch->base, CMCNT, value);
 }
 
 static inline void sh_cmt_write_cmcor(struct sh_cmt_channel *ch,
 				      unsigned long value)
 {
-	ch->cmt->write_count(ch->base, CMCOR, value);
+	ch->cmt->info->write_count(ch->base, CMCOR, value);
 }
 
 static unsigned long sh_cmt_get_counter(struct sh_cmt_channel *ch,
@@ -173,7 +239,7 @@ static unsigned long sh_cmt_get_counter(struct sh_cmt_channel *ch,
 	unsigned long v1, v2, v3;
 	int o1, o2;
 
-	o1 = sh_cmt_read_cmcsr(ch) & ch->cmt->overflow_bit;
+	o1 = sh_cmt_read_cmcsr(ch) & ch->cmt->info->overflow_bit;
 
 	/* Make sure the timer value is stable. Stolen from acpi_pm.c */
 	do {
@@ -181,7 +247,7 @@ static unsigned long sh_cmt_get_counter(struct sh_cmt_channel *ch,
 		v1 = sh_cmt_read_cmcnt(ch);
 		v2 = sh_cmt_read_cmcnt(ch);
 		v3 = sh_cmt_read_cmcnt(ch);
-		o1 = sh_cmt_read_cmcsr(ch) & ch->cmt->overflow_bit;
+		o1 = sh_cmt_read_cmcsr(ch) & ch->cmt->info->overflow_bit;
 	} while (unlikely((o1 != o2) || (v1 > v2 && v1 < v3)
 			  || (v2 > v3 && v2 < v1) || (v3 > v1 && v3 < v2)));
 
@@ -228,7 +294,7 @@ static int sh_cmt_enable(struct sh_cmt_channel *ch, unsigned long *rate)
 	sh_cmt_start_stop_ch(ch, 0);
 
 	/* configure channel, periodic mode and maximum timeout */
-	if (ch->cmt->width == 16) {
+	if (ch->cmt->info->width == 16) {
 		*rate = clk_get_rate(ch->cmt->clk) / 512;
 		sh_cmt_write_cmcsr(ch, 0x43);
 	} else {
@@ -406,7 +472,8 @@ static irqreturn_t sh_cmt_interrupt(int irq, void *dev_id)
 	struct sh_cmt_channel *ch = dev_id;
 
 	/* clear flags */
-	sh_cmt_write_cmcsr(ch, sh_cmt_read_cmcsr(ch) & ch->cmt->clear_bits);
+	sh_cmt_write_cmcsr(ch, sh_cmt_read_cmcsr(ch) &
+			   ch->cmt->info->clear_bits);
 
 	/* update clock source counter to begin with if enabled
 	 * the wrap flag should be cleared by the timer specific
@@ -725,10 +792,10 @@ static int sh_cmt_setup_channel(struct sh_cmt_channel *ch, unsigned int index,
 	ch->irqaction.dev_id = ch;
 	ch->irqaction.flags = IRQF_TIMER | IRQF_IRQPOLL | IRQF_NOBALANCING;
 
-	if (cmt->width == (sizeof(ch->max_match_value) * 8))
+	if (cmt->info->width == (sizeof(ch->max_match_value) * 8))
 		ch->max_match_value = ~0;
 	else
-		ch->max_match_value = (1 << cmt->width) - 1;
+		ch->max_match_value = (1 << cmt->info->width) - 1;
 
 	ch->match_value = ch->max_match_value;
 	raw_spin_lock_init(&ch->lock);
@@ -802,28 +869,13 @@ static int sh_cmt_setup(struct sh_cmt_device *cmt, struct platform_device *pdev)
 	if (ret < 0)
 		goto err3;
 
-	if (res2 && (resource_size(res2) == 4)) {
-		/* assume both CMSTR and CMCSR to be 32-bit */
-		cmt->read_control = sh_cmt_read32;
-		cmt->write_control = sh_cmt_write32;
-	} else {
-		cmt->read_control = sh_cmt_read16;
-		cmt->write_control = sh_cmt_write16;
-	}
-
-	if (resource_size(res) == 6) {
-		cmt->width = 16;
-		cmt->read_count = sh_cmt_read16;
-		cmt->write_count = sh_cmt_write16;
-		cmt->overflow_bit = 0x80;
-		cmt->clear_bits = ~0x80;
-	} else {
-		cmt->width = 32;
-		cmt->read_count = sh_cmt_read32;
-		cmt->write_count = sh_cmt_write32;
-		cmt->overflow_bit = 0x8000;
-		cmt->clear_bits = ~0xc000;
-	}
+	/* identify the model based on the resources */
+	if (resource_size(res) == 6)
+		cmt->info = &sh_cmt_info[SH_CMT_16BIT];
+	else if (res2 && (resource_size(res2) == 4))
+		cmt->info = &sh_cmt_info[SH_CMT_48BIT_GEN2];
+	else
+		cmt->info = &sh_cmt_info[SH_CMT_32BIT];
 
 	cmt->channels = kzalloc(sizeof(*cmt->channels), GFP_KERNEL);
 	if (cmt->channels == NULL) {
-- 
1.8.3.2

