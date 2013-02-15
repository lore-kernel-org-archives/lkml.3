Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161981Ab3BONE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:04:29 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65490 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161750Ab3BOM5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:44 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/35] mfd: ab8500-core: Add Interrupt support for ab8540
Date: Fri, 15 Feb 2013 12:56:42 +0000
Message-Id: <1360933026-30325-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ITSource/ITLatch 7, 8, 9 and 10 don't exist on AB8540. This patch
replaces them with '-1' in the interrupt list, and handles the '-1'
in the code accordingly.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c         |   50 ++++++++++--
 include/linux/mfd/abx500/ab8500.h |  153 +++++++++++++++++++++++++++----------
 2 files changed, 154 insertions(+), 49 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 8af002c..e82cf73 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -102,8 +102,10 @@
 #define AB8500_IT_LATCHHIER1_REG	0x60
 #define AB8500_IT_LATCHHIER2_REG	0x61
 #define AB8500_IT_LATCHHIER3_REG	0x62
+#define AB8540_IT_LATCHHIER4_REG	0x63
 
 #define AB8500_IT_LATCHHIER_NUM		3
+#define AB8540_IT_LATCHHIER_NUM		4
 
 #define AB8500_REV_REG			0x80
 #define AB8500_IC_NAME_REG		0x82
@@ -135,6 +137,12 @@ static const int ab9540_irq_regoffset[AB9540_NUM_IRQ_REGS] = {
 	0, 1, 2, 3, 4, 6, 7, 8, 9, 11, 18, 19, 20, 21, 12, 13, 24, 5, 22, 23
 };
 
+/* AB8540 support */
+static const int ab8540_irq_regoffset[AB8540_NUM_IRQ_REGS] = {
+	0, 1, 2, 3, 4, -1, -1, -1, -1, 11, 18, 19, 20, 21, 12, 13, 24, 5, 22, 23,
+	25, 26, 27, 28, 29, 30, 31,
+};
+
 static const char ab8500_version_str[][7] = {
 	[AB8500_VERSION_AB8500] = "AB8500",
 	[AB8500_VERSION_AB8505] = "AB8505",
@@ -352,6 +360,9 @@ static void ab8500_irq_sync_unlock(struct irq_data *data)
 			is_ab8500_1p1_or_earlier(ab8500))
 			continue;
 
+		if (ab8500->irq_reg_offset[i] < 0)
+			continue;
+
 		ab8500->oldmask[i] = new;
 
 		reg = AB8500_IT_MASK1_REG + ab8500->irq_reg_offset[i];
@@ -390,6 +401,18 @@ static struct irq_chip ab8500_irq_chip = {
 	.irq_unmask		= ab8500_irq_unmask,
 };
 
+static void update_latch_offset(u8 *offset, int i)
+{
+	/* Fix inconsistent ITFromLatch25 bit mapping... */
+	if (unlikely(*offset == 17))
+			*offset = 24;
+	/* Fix inconsistent ab8540 bit mapping... */
+	if (unlikely(*offset == 16))
+			*offset = 25;
+	if ((i==3) && (*offset >= 24))
+			*offset += 2;
+}
+
 static int ab8500_handle_hierarchical_line(struct ab8500 *ab8500,
 					int latch_offset, u8 latch_val)
 {
@@ -428,9 +451,7 @@ static int ab8500_handle_hierarchical_latch(struct ab8500 *ab8500,
 		latch_bit = __ffs(hier_val);
 		latch_offset = (hier_offset << 3) + latch_bit;
 
-		/* Fix inconsistent ITFromLatch25 bit mapping... */
-		if (unlikely(latch_offset == 17))
-			latch_offset = 24;
+		update_latch_offset(&latch_offset, hier_offset);
 
 		status = get_register_interruptible(ab8500,
 				AB8500_INTERRUPT,
@@ -458,7 +479,7 @@ static irqreturn_t ab8500_hierarchical_irq(int irq, void *dev)
 	dev_vdbg(ab8500->dev, "interrupt\n");
 
 	/*  Hierarchical interrupt version */
-	for (i = 0; i < AB8500_IT_LATCHHIER_NUM; i++) {
+	for (i = 0; i < (ab8500->it_latchhier_num); i++) {
 		int status;
 		u8 hier_val;
 
@@ -511,6 +532,9 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 		if (regoffset == 11 && is_ab8500_1p1_or_earlier(ab8500))
 			continue;
 
+		if (regoffset < 0)
+			continue;
+
 		status = get_register_interruptible(ab8500, AB8500_INTERRUPT,
 			AB8500_IT_LATCH1_REG + regoffset, &value);
 		if (status < 0 || value == 0)
@@ -561,7 +585,9 @@ static int ab8500_irq_init(struct ab8500 *ab8500, struct device_node *np)
 {
 	int num_irqs;
 
-	if (is_ab9540(ab8500))
+	if (is_ab8540(ab8500))
+		num_irqs = AB8540_NR_IRQS;
+	else if (is_ab9540(ab8500))
 		num_irqs = AB9540_NR_IRQS;
 	else if (is_ab8505(ab8500))
 		num_irqs = AB8505_NR_IRQS;
@@ -1482,13 +1508,20 @@ static int ab8500_probe(struct platform_device *pdev)
 			ab8500->chip_id >> 4,
 			ab8500->chip_id & 0x0F);
 
-	/* Configure AB8500 or AB9540 IRQ */
-	if (is_ab9540(ab8500) || is_ab8505(ab8500)) {
+	/* Configure AB8540 */
+	if (is_ab8540(ab8500)) {
+		ab8500->mask_size = AB8540_NUM_IRQ_REGS;
+		ab8500->irq_reg_offset = ab8540_irq_regoffset;
+		ab8500->it_latchhier_num = AB8540_IT_LATCHHIER_NUM;
+	}/* Configure AB8500 or AB9540 IRQ */
+	else if (is_ab9540(ab8500) || is_ab8505(ab8500)) {
 		ab8500->mask_size = AB9540_NUM_IRQ_REGS;
 		ab8500->irq_reg_offset = ab9540_irq_regoffset;
+		ab8500->it_latchhier_num = AB8500_IT_LATCHHIER_NUM;
 	} else {
 		ab8500->mask_size = AB8500_NUM_IRQ_REGS;
 		ab8500->irq_reg_offset = ab8500_irq_regoffset;
+		ab8500->it_latchhier_num = AB8500_IT_LATCHHIER_NUM;
 	}
 	ab8500->mask = devm_kzalloc(&pdev->dev, ab8500->mask_size, GFP_KERNEL);
 	if (!ab8500->mask)
@@ -1541,6 +1574,9 @@ static int ab8500_probe(struct platform_device *pdev)
 				is_ab8500_1p1_or_earlier(ab8500))
 			continue;
 
+		if (ab8500->irq_reg_offset[i] < 0)
+			continue;
+
 		get_register_interruptible(ab8500, AB8500_INTERRUPT,
 			AB8500_IT_LATCH1_REG + ab8500->irq_reg_offset[i],
 			&value);
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index f24df87..f432cef 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -65,11 +65,11 @@ enum ab8500_version {
  * Values used to index into array ab8500_irq_regoffset[] defined in
  * drivers/mdf/ab8500-core.c
  */
-/* Definitions for AB8500 and AB9540 */
+/* Definitions for AB8500, AB9540 and AB8540 */
 /* ab8500_irq_regoffset[0] -> IT[Source|Latch|Mask]1 */
 #define AB8500_INT_MAIN_EXT_CH_NOT_OK	0 /* not 8505/9540 */
-#define AB8500_INT_UN_PLUG_TV_DET	1 /* not 8505/9540 */
-#define AB8500_INT_PLUG_TV_DET		2 /* not 8505/9540 */
+#define AB8500_INT_UN_PLUG_TV_DET	1 /* not 8505/9540/8540 */
+#define AB8500_INT_PLUG_TV_DET		2 /* not 8505/9540/8540 */
 #define AB8500_INT_TEMP_WARM		3
 #define AB8500_INT_PON_KEY2DB_F		4
 #define AB8500_INT_PON_KEY2DB_R		5
@@ -77,18 +77,19 @@ enum ab8500_version {
 #define AB8500_INT_PON_KEY1DB_R		7
 /* ab8500_irq_regoffset[1] -> IT[Source|Latch|Mask]2 */
 #define AB8500_INT_BATT_OVV		8
-#define AB8500_INT_MAIN_CH_UNPLUG_DET	10 /* not 8505 */
-#define AB8500_INT_MAIN_CH_PLUG_DET	11 /* not 8505 */
+#define AB8500_INT_MAIN_CH_UNPLUG_DET	10 /* not 8505/8540 */
+#define AB8500_INT_MAIN_CH_PLUG_DET	11 /* not 8505/8540 */
 #define AB8500_INT_VBUS_DET_F		14
 #define AB8500_INT_VBUS_DET_R		15
 /* ab8500_irq_regoffset[2] -> IT[Source|Latch|Mask]3 */
 #define AB8500_INT_VBUS_CH_DROP_END	16
 #define AB8500_INT_RTC_60S		17
 #define AB8500_INT_RTC_ALARM		18
+#define AB8540_INT_BIF_INT		19
 #define AB8500_INT_BAT_CTRL_INDB	20
 #define AB8500_INT_CH_WD_EXP		21
 #define AB8500_INT_VBUS_OVV		22
-#define AB8500_INT_MAIN_CH_DROP_END	23 /* not 8505/9540 */
+#define AB8500_INT_MAIN_CH_DROP_END	23 /* not 8505/9540/8540 */
 /* ab8500_irq_regoffset[3] -> IT[Source|Latch|Mask]4 */
 #define AB8500_INT_CCN_CONV_ACC		24
 #define AB8500_INT_INT_AUD		25
@@ -99,7 +100,7 @@ enum ab8500_version {
 #define AB8500_INT_BUP_CHG_NOT_OK	30
 #define AB8500_INT_BUP_CHG_OK		31
 /* ab8500_irq_regoffset[4] -> IT[Source|Latch|Mask]5 */
-#define AB8500_INT_GP_HW_ADC_CONV_END	32 /* not 8505 */
+#define AB8500_INT_GP_HW_ADC_CONV_END	32 /* not 8505/8540 */
 #define AB8500_INT_ACC_DETECT_1DB_F	33
 #define AB8500_INT_ACC_DETECT_1DB_R	34
 #define AB8500_INT_ACC_DETECT_22DB_F	35
@@ -108,23 +109,23 @@ enum ab8500_version {
 #define AB8500_INT_ACC_DETECT_21DB_R	38
 #define AB8500_INT_GP_SW_ADC_CONV_END	39
 /* ab8500_irq_regoffset[5] -> IT[Source|Latch|Mask]7 */
-#define AB8500_INT_GPIO6R		40 /* not 8505/9540 */
-#define AB8500_INT_GPIO7R		41 /* not 8505/9540 */
-#define AB8500_INT_GPIO8R		42 /* not 8505/9540 */
-#define AB8500_INT_GPIO9R		43 /* not 8505/9540 */
-#define AB8500_INT_GPIO10R		44
-#define AB8500_INT_GPIO11R		45
-#define AB8500_INT_GPIO12R		46 /* not 8505 */
-#define AB8500_INT_GPIO13R		47
+#define AB8500_INT_GPIO6R		40 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO7R		41 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO8R		42 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO9R		43 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO10R		44 /* not 8540 */
+#define AB8500_INT_GPIO11R		45 /* not 8540 */
+#define AB8500_INT_GPIO12R		46 /* not 8505/8540 */
+#define AB8500_INT_GPIO13R		47 /* not 8540 */
 /* ab8500_irq_regoffset[6] -> IT[Source|Latch|Mask]8 */
-#define AB8500_INT_GPIO24R		48 /* not 8505 */
-#define AB8500_INT_GPIO25R		49 /* not 8505 */
-#define AB8500_INT_GPIO36R		50 /* not 8505/9540 */
-#define AB8500_INT_GPIO37R		51 /* not 8505/9540 */
-#define AB8500_INT_GPIO38R		52 /* not 8505/9540 */
-#define AB8500_INT_GPIO39R		53 /* not 8505/9540 */
-#define AB8500_INT_GPIO40R		54
-#define AB8500_INT_GPIO41R		55
+#define AB8500_INT_GPIO24R		48 /* not 8505/8540 */
+#define AB8500_INT_GPIO25R		49 /* not 8505/8540 */
+#define AB8500_INT_GPIO36R		50 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO37R		51 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO38R		52 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO39R		53 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO40R		54 /* not 8540 */
+#define AB8500_INT_GPIO41R		55 /* not 8540 */
 /* ab8500_irq_regoffset[7] -> IT[Source|Latch|Mask]9 */
 #define AB8500_INT_GPIO6F		56 /* not 8505/9540 */
 #define AB8500_INT_GPIO7F		57 /* not 8505/9540 */
@@ -135,14 +136,14 @@ enum ab8500_version {
 #define AB8500_INT_GPIO12F		62 /* not 8505 */
 #define AB8500_INT_GPIO13F		63
 /* ab8500_irq_regoffset[8] -> IT[Source|Latch|Mask]10 */
-#define AB8500_INT_GPIO24F		64 /* not 8505 */
-#define AB8500_INT_GPIO25F		65 /* not 8505 */
-#define AB8500_INT_GPIO36F		66 /* not 8505/9540 */
-#define AB8500_INT_GPIO37F		67 /* not 8505/9540 */
-#define AB8500_INT_GPIO38F		68 /* not 8505/9540 */
-#define AB8500_INT_GPIO39F		69 /* not 8505/9540 */
-#define AB8500_INT_GPIO40F		70
-#define AB8500_INT_GPIO41F		71
+#define AB8500_INT_GPIO24F		64 /* not 8505/8540 */
+#define AB8500_INT_GPIO25F		65 /* not 8505/8540 */
+#define AB8500_INT_GPIO36F		66 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO37F		67 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO38F		68 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO39F		69 /* not 8505/9540/8540 */
+#define AB8500_INT_GPIO40F		70 /* not 8540 */
+#define AB8500_INT_GPIO41F		71 /* not 8540 */
 /* ab8500_irq_regoffset[9] -> IT[Source|Latch|Mask]12 */
 #define AB8500_INT_ADP_SOURCE_ERROR	72
 #define AB8500_INT_ADP_SINK_ERROR	73
@@ -183,19 +184,19 @@ enum ab8500_version {
 
 /* Definitions for AB9540 / AB8505 */
 /* ab8500_irq_regoffset[14] -> IT[Source|Latch|Mask]13 */
-#define AB9540_INT_GPIO50R		113
-#define AB9540_INT_GPIO51R		114 /* not 8505 */
-#define AB9540_INT_GPIO52R		115
-#define AB9540_INT_GPIO53R		116
-#define AB9540_INT_GPIO54R		117 /* not 8505 */
+#define AB9540_INT_GPIO50R		113 /* not 8540 */
+#define AB9540_INT_GPIO51R		114 /* not 8505/8540 */
+#define AB9540_INT_GPIO52R		115 /* not 8540 */
+#define AB9540_INT_GPIO53R		116 /* not 8540 */
+#define AB9540_INT_GPIO54R		117 /* not 8505/8540 */
 #define AB9540_INT_IEXT_CH_RF_BFN_R	118
 #define AB9540_INT_IEXT_CH_RF_BFN_F	119
 /* ab8500_irq_regoffset[15] -> IT[Source|Latch|Mask]14 */
-#define AB9540_INT_GPIO50F		121
-#define AB9540_INT_GPIO51F		122 /* not 8505 */
-#define AB9540_INT_GPIO52F		123
-#define AB9540_INT_GPIO53F		124
-#define AB9540_INT_GPIO54F		125 /* not 8505 */
+#define AB9540_INT_GPIO50F		121 /* not 8540 */
+#define AB9540_INT_GPIO51F		122 /* not 8505/8540 */
+#define AB9540_INT_GPIO52F		123 /* not 8540 */
+#define AB9540_INT_GPIO53F		124 /* not 8540 */
+#define AB9540_INT_GPIO54F		125 /* not 8505/8540 */
 /* ab8500_irq_regoffset[16] -> IT[Source|Latch|Mask]25 */
 #define AB8505_INT_KEYSTUCK		128
 #define AB8505_INT_IKR			129
@@ -223,6 +224,71 @@ enum ab8500_version {
 /* ab8500_irq_regoffset[19] -> IT[Source|Latch|Mask]24 */
 #define AB8505_INT_NOPINT		152
 
+#define AB8505_INT_NOPINT		152
+/* ab8540_irq_regoffset[20] -> IT[Source|Latch|Mask]26 */
+#define AB8540_INT_IDPLUGDETCOMPF	160
+#define AB8540_INT_IDPLUGDETCOMPR	161
+#define AB8540_INT_FMDETCOMPLOF		162
+#define AB8540_INT_FMDETCOMPLOR		163
+#define AB8540_INT_FMDETCOMPHIF		164
+#define AB8540_INT_FMDETCOMPHIR		165
+#define AB8540_INT_ID5VDETCOMPF		166
+#define AB8540_INT_ID5VDETCOMPR		167
+/* ab8540_irq_regoffset[21] -> IT[Source|Latch|Mask]27 */
+#define AB8540_INT_GPIO43F		168
+#define AB8540_INT_GPIO43R		169
+#define AB8540_INT_GPIO44F		170
+#define AB8540_INT_GPIO44R		171
+#define AB8540_INT_KEYPOSDETCOMPF	172
+#define AB8540_INT_KEYPOSDETCOMPR	173
+#define AB8540_INT_KEYNEGDETCOMPF	174
+#define AB8540_INT_KEYNEGDETCOMPR	175
+/* ab8540_irq_regoffset[22] -> IT[Source|Latch|Mask]28 */
+#define AB8540_INT_GPIO1VBATF		176
+#define AB8540_INT_GPIO1VBATR		177
+#define AB8540_INT_GPIO2VBATF		178
+#define AB8540_INT_GPIO2VBATR		179
+#define AB8540_INT_GPIO3VBATF		180
+#define AB8540_INT_GPIO3VBATR		181
+#define AB8540_INT_GPIO4VBATF		182
+#define AB8540_INT_GPIO4VBATR		183
+/* ab8540_irq_regoffset[23] -> IT[Source|Latch|Mask]29 */
+#define AB8540_INT_SYSCLKREQ2F		184
+#define AB8540_INT_SYSCLKREQ2R		185
+#define AB8540_INT_SYSCLKREQ3F		186
+#define AB8540_INT_SYSCLKREQ3R		187
+#define AB8540_INT_SYSCLKREQ4F		188
+#define AB8540_INT_SYSCLKREQ4R		189
+#define AB8540_INT_SYSCLKREQ5F		190
+#define AB8540_INT_SYSCLKREQ5R		191
+/* ab8540_irq_regoffset[24] -> IT[Source|Latch|Mask]30 */
+#define AB8540_INT_PWMOUT1F		192
+#define AB8540_INT_PWMOUT1R		193
+#define AB8540_INT_PWMCTRL0F		194
+#define AB8540_INT_PWMCTRL0R		195
+#define AB8540_INT_PWMCTRL1F		196
+#define AB8540_INT_PWMCTRL1R		197
+#define AB8540_INT_SYSCLKREQ6F		198
+#define AB8540_INT_SYSCLKREQ6R		199
+/* ab8540_irq_regoffset[25] -> IT[Source|Latch|Mask]31 */
+#define AB8540_INT_PWMEXTVIBRA1F	200
+#define AB8540_INT_PWMEXTVIBRA1R	201
+#define AB8540_INT_PWMEXTVIBRA2F	202
+#define AB8540_INT_PWMEXTVIBRA2R	203
+#define AB8540_INT_PWMOUT2F		204
+#define AB8540_INT_PWMOUT2R		205
+#define AB8540_INT_PWMOUT3F		206
+#define AB8540_INT_PWMOUT3R		207
+/* ab8540_irq_regoffset[26] -> IT[Source|Latch|Mask]32 */
+#define AB8540_INT_ADDATA2F		208
+#define AB8540_INT_ADDATA2R		209
+#define AB8540_INT_DADATA2F		210
+#define AB8540_INT_DADATA2R		211
+#define AB8540_INT_FSYNC2F		212
+#define AB8540_INT_FSYNC2R		213
+#define AB8540_INT_BITCLK2F		214
+#define AB8540_INT_BITCLK2R		215
+
 /*
  * AB8500_AB9540_NR_IRQS is used when configuring the IRQ numbers for the
  * entire platform. This is a "compile time" constant so this must be set to
@@ -233,11 +299,13 @@ enum ab8500_version {
 #define AB8500_NR_IRQS			112
 #define AB8505_NR_IRQS			153
 #define AB9540_NR_IRQS			153
+#define AB8540_NR_IRQS			216
 /* This is set to the roof of any AB8500 chip variant IRQ counts */
-#define AB8500_MAX_NR_IRQS		AB9540_NR_IRQS
+#define AB8500_MAX_NR_IRQS		AB8540_NR_IRQS
 
 #define AB8500_NUM_IRQ_REGS		14
 #define AB9540_NUM_IRQ_REGS		20
+#define AB8540_NUM_IRQ_REGS		27
 
 /**
  * struct ab8500 - ab8500 internal structure
@@ -282,6 +350,7 @@ struct ab8500 {
 	u8 *oldmask;
 	int mask_size;
 	const int *irq_reg_offset;
+	int it_latchhier_num;
 };
 
 struct regulator_reg_init;
-- 
1.7.10.4

