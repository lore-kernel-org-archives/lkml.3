Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab3KSQFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:05:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49238 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947Ab3KSQEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:04:52 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lee.jones@linaro.org
Cc: lgirdwood@gmail.com, sameo@linux.intel.com,
        patches@opensource.wolfsonmico.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] ASoC: wm5110: Expose input high pass filter controls
Date: Tue, 19 Nov 2013 16:03:35 +0000
Message-Id: <1384877015-5596-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1384877015-5596-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1384877015-5596-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm5110-tables.c           |    4 +++
 include/linux/mfd/arizona/registers.h |   37 +++++++++++++++++++++++++++++++++
 sound/soc/codecs/arizona.c            |   10 +++++++++
 sound/soc/codecs/arizona.h            |    1 +
 sound/soc/codecs/wm5110.c             |   19 +++++++++++++++++
 5 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
index 4430404..3b079f6 100644
--- a/drivers/mfd/wm5110-tables.c
+++ b/drivers/mfd/wm5110-tables.c
@@ -518,6 +518,7 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x00000300, 0x0000 },    /* R768   - Input Enables */
 	{ 0x00000308, 0x0000 },    /* R776   - Input Rate */
 	{ 0x00000309, 0x0022 },    /* R777   - Input Volume Ramp */
+	{ 0x0000030C, 0x0002 },    /* R780   - HPF Control */
 	{ 0x00000310, 0x2080 },    /* R784   - IN1L Control */
 	{ 0x00000311, 0x0180 },    /* R785   - ADC Digital Volume 1L */
 	{ 0x00000312, 0x0000 },    /* R786   - DMIC1L Control */
@@ -539,6 +540,7 @@ static const struct reg_default wm5110_reg_default[] = {
 	{ 0x00000328, 0x2000 },    /* R808   - IN4L Control */
 	{ 0x00000329, 0x0180 },    /* R809   - ADC Digital Volume 4L */
 	{ 0x0000032A, 0x0000 },    /* R810   - DMIC4L Control */
+	{ 0x0000032C, 0x0000 },    /* R812   - IN4R Control */
 	{ 0x0000032D, 0x0180 },    /* R813   - ADC Digital Volume 4R */
 	{ 0x0000032E, 0x0000 },    /* R814   - DMIC4R Control */
 	{ 0x00000400, 0x0000 },    /* R1024  - Output Enables 1 */
@@ -1512,6 +1514,7 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_INPUT_ENABLES_STATUS:
 	case ARIZONA_INPUT_RATE:
 	case ARIZONA_INPUT_VOLUME_RAMP:
+	case ARIZONA_HPF_CONTROL:
 	case ARIZONA_IN1L_CONTROL:
 	case ARIZONA_ADC_DIGITAL_VOLUME_1L:
 	case ARIZONA_DMIC1L_CONTROL:
@@ -1533,6 +1536,7 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
 	case ARIZONA_IN4L_CONTROL:
 	case ARIZONA_ADC_DIGITAL_VOLUME_4L:
 	case ARIZONA_DMIC4L_CONTROL:
+	case ARIZONA_IN4R_CONTROL:
 	case ARIZONA_ADC_DIGITAL_VOLUME_4R:
 	case ARIZONA_DMIC4R_CONTROL:
 	case ARIZONA_OUTPUT_ENABLES_1:
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 4706d3d..cdf1f5ac 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -139,6 +139,7 @@
 #define ARIZONA_INPUT_ENABLES_STATUS             0x301
 #define ARIZONA_INPUT_RATE                       0x308
 #define ARIZONA_INPUT_VOLUME_RAMP                0x309
+#define ARIZONA_HPF_CONTROL                      0x30C
 #define ARIZONA_IN1L_CONTROL                     0x310
 #define ARIZONA_ADC_DIGITAL_VOLUME_1L            0x311
 #define ARIZONA_DMIC1L_CONTROL                   0x312
@@ -160,6 +161,7 @@
 #define ARIZONA_IN4L_CONTROL                     0x328
 #define ARIZONA_ADC_DIGITAL_VOLUME_4L            0x329
 #define ARIZONA_DMIC4L_CONTROL                   0x32A
+#define ARIZONA_IN4R_CONTROL                     0x32C
 #define ARIZONA_ADC_DIGITAL_VOLUME_4R            0x32D
 #define ARIZONA_DMIC4R_CONTROL                   0x32E
 #define ARIZONA_OUTPUT_ENABLES_1                 0x400
@@ -2293,8 +2295,18 @@
 #define ARIZONA_IN_VI_RAMP_WIDTH                      3  /* IN_VI_RAMP - [2:0] */
 
 /*
+ * R780 (0x30C) - HPF Control
+ */
+#define ARIZONA_IN_HPF_CUT_MASK                  0x0007  /* IN_HPF_CUT [2:0] */
+#define ARIZONA_IN_HPF_CUT_SHIFT                      0  /* IN_HPF_CUT [2:0] */
+#define ARIZONA_IN_HPF_CUT_WIDTH                      3  /* IN_HPF_CUT [2:0] */
+
+/*
  * R784 (0x310) - IN1L Control
  */
+#define ARIZONA_IN1L_HPF_MASK                    0x8000  /* IN1L_HPF - [15] */
+#define ARIZONA_IN1L_HPF_SHIFT                       15  /* IN1L_HPF - [15] */
+#define ARIZONA_IN1L_HPF_WIDTH                        1  /* IN1L_HPF - [15] */
 #define ARIZONA_IN1_OSR_MASK                     0x6000  /* IN1_OSR - [14:13] */
 #define ARIZONA_IN1_OSR_SHIFT                        13  /* IN1_OSR - [14:13] */
 #define ARIZONA_IN1_OSR_WIDTH                         2  /* IN1_OSR - [14:13] */
@@ -2333,6 +2345,9 @@
 /*
  * R788 (0x314) - IN1R Control
  */
+#define ARIZONA_IN1R_HPF_MASK                    0x8000  /* IN1R_HPF - [15] */
+#define ARIZONA_IN1R_HPF_SHIFT                       15  /* IN1R_HPF - [15] */
+#define ARIZONA_IN1R_HPF_WIDTH                        1  /* IN1R_HPF - [15] */
 #define ARIZONA_IN1R_PGA_VOL_MASK                0x00FE  /* IN1R_PGA_VOL - [7:1] */
 #define ARIZONA_IN1R_PGA_VOL_SHIFT                    1  /* IN1R_PGA_VOL - [7:1] */
 #define ARIZONA_IN1R_PGA_VOL_WIDTH                    7  /* IN1R_PGA_VOL - [7:1] */
@@ -2362,6 +2377,9 @@
 /*
  * R792 (0x318) - IN2L Control
  */
+#define ARIZONA_IN2L_HPF_MASK                    0x8000  /* IN2L_HPF - [15] */
+#define ARIZONA_IN2L_HPF_SHIFT                       15  /* IN2L_HPF - [15] */
+#define ARIZONA_IN2L_HPF_WIDTH                        1  /* IN2L_HPF - [15] */
 #define ARIZONA_IN2_OSR_MASK                     0x6000  /* IN2_OSR - [14:13] */
 #define ARIZONA_IN2_OSR_SHIFT                        13  /* IN2_OSR - [14:13] */
 #define ARIZONA_IN2_OSR_WIDTH                         2  /* IN2_OSR - [14:13] */
@@ -2400,6 +2418,9 @@
 /*
  * R796 (0x31C) - IN2R Control
  */
+#define ARIZONA_IN2R_HPF_MASK                    0x8000  /* IN2R_HPF - [15] */
+#define ARIZONA_IN2R_HPF_SHIFT                       15  /* IN2R_HPF - [15] */
+#define ARIZONA_IN2R_HPF_WIDTH                        1  /* IN2R_HPF - [15] */
 #define ARIZONA_IN2R_PGA_VOL_MASK                0x00FE  /* IN2R_PGA_VOL - [7:1] */
 #define ARIZONA_IN2R_PGA_VOL_SHIFT                    1  /* IN2R_PGA_VOL - [7:1] */
 #define ARIZONA_IN2R_PGA_VOL_WIDTH                    7  /* IN2R_PGA_VOL - [7:1] */
@@ -2429,6 +2450,9 @@
 /*
  * R800 (0x320) - IN3L Control
  */
+#define ARIZONA_IN3L_HPF_MASK                    0x8000  /* IN3L_HPF - [15] */
+#define ARIZONA_IN3L_HPF_SHIFT                       15  /* IN3L_HPF - [15] */
+#define ARIZONA_IN3L_HPF_WIDTH                        1  /* IN3L_HPF - [15] */
 #define ARIZONA_IN3_OSR_MASK                     0x6000  /* IN3_OSR - [14:13] */
 #define ARIZONA_IN3_OSR_SHIFT                        13  /* IN3_OSR - [14:13] */
 #define ARIZONA_IN3_OSR_WIDTH                         2  /* IN3_OSR - [14:13] */
@@ -2467,6 +2491,9 @@
 /*
  * R804 (0x324) - IN3R Control
  */
+#define ARIZONA_IN3R_HPF_MASK                    0x8000  /* IN3R_HPF - [15] */
+#define ARIZONA_IN3R_HPF_SHIFT                       15  /* IN3R_HPF - [15] */
+#define ARIZONA_IN3R_HPF_WIDTH                        1  /* IN3R_HPF - [15] */
 #define ARIZONA_IN3R_PGA_VOL_MASK                0x00FE  /* IN3R_PGA_VOL - [7:1] */
 #define ARIZONA_IN3R_PGA_VOL_SHIFT                    1  /* IN3R_PGA_VOL - [7:1] */
 #define ARIZONA_IN3R_PGA_VOL_WIDTH                    7  /* IN3R_PGA_VOL - [7:1] */
@@ -2496,6 +2523,9 @@
 /*
  * R808 (0x328) - IN4 Control
  */
+#define ARIZONA_IN4L_HPF_MASK                    0x8000  /* IN4L_HPF - [15] */
+#define ARIZONA_IN4L_HPF_SHIFT                       15  /* IN4L_HPF - [15] */
+#define ARIZONA_IN4L_HPF_WIDTH                        1  /* IN4L_HPF - [15] */
 #define ARIZONA_IN4_OSR_MASK                     0x6000  /* IN4_OSR - [14:13] */
 #define ARIZONA_IN4_OSR_SHIFT                        13  /* IN4_OSR - [14:13] */
 #define ARIZONA_IN4_OSR_WIDTH                         2  /* IN4_OSR - [14:13] */
@@ -2526,6 +2556,13 @@
 #define ARIZONA_IN4L_DMIC_DLY_WIDTH                   6  /* IN4L_DMIC_DLY - [5:0] */
 
 /*
+ * R812 (0x32C) - IN4R Control
+ */
+#define ARIZONA_IN4R_HPF_MASK                    0x8000  /* IN4R_HPF - [15] */
+#define ARIZONA_IN4R_HPF_SHIFT                       15  /* IN4R_HPF - [15] */
+#define ARIZONA_IN4R_HPF_WIDTH                        1  /* IN4R_HPF - [15] */
+
+/*
  * R813 (0x32D) - ADC Digital Volume 4R
  */
 #define ARIZONA_IN_VU                            0x0200  /* IN_VU */
diff --git a/sound/soc/codecs/arizona.c b/sound/soc/codecs/arizona.c
index 6f05b17..f30cf88 100644
--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -560,6 +560,16 @@ const struct soc_enum arizona_ng_hold =
 			4, arizona_ng_hold_text);
 EXPORT_SYMBOL_GPL(arizona_ng_hold);
 
+static const char * const arizona_in_hpf_cut_text[] = {
+	"2.5Hz", "5Hz", "10Hz", "20Hz", "40Hz"
+};
+
+const struct soc_enum arizona_in_hpf_cut_enum =
+	SOC_ENUM_SINGLE(ARIZONA_HPF_CONTROL, ARIZONA_IN_HPF_CUT_SHIFT,
+			ARRAY_SIZE(arizona_in_hpf_cut_text),
+			arizona_in_hpf_cut_text);
+EXPORT_SYMBOL_GPL(arizona_in_hpf_cut_enum);
+
 static const char * const arizona_in_dmic_osr_text[] = {
 	"1.536MHz", "3.072MHz", "6.144MHz",
 };
diff --git a/sound/soc/codecs/arizona.h b/sound/soc/codecs/arizona.h
index 9e81b63..f8e6386 100644
--- a/sound/soc/codecs/arizona.h
+++ b/sound/soc/codecs/arizona.h
@@ -199,6 +199,7 @@ extern const struct soc_enum arizona_lhpf3_mode;
 extern const struct soc_enum arizona_lhpf4_mode;
 
 extern const struct soc_enum arizona_ng_hold;
+extern const struct soc_enum arizona_in_hpf_cut_enum;
 extern const struct soc_enum arizona_in_dmic_osr[];
 
 extern int arizona_in_ev(struct snd_soc_dapm_widget *w,
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index c4da1bd..13c490b 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -155,6 +155,25 @@ SOC_SINGLE_RANGE_TLV("IN3L Volume", ARIZONA_IN3L_CONTROL,
 SOC_SINGLE_RANGE_TLV("IN3R Volume", ARIZONA_IN3R_CONTROL,
 		     ARIZONA_IN3R_PGA_VOL_SHIFT, 0x40, 0x5f, 0, ana_tlv),
 
+SOC_ENUM("IN HPF Cutoff Frequency", arizona_in_hpf_cut_enum),
+
+SOC_SINGLE("IN1L HPF Switch", ARIZONA_IN1L_CONTROL,
+	   ARIZONA_IN1L_HPF_SHIFT, 1, 0),
+SOC_SINGLE("IN1R HPF Switch", ARIZONA_IN1R_CONTROL,
+	   ARIZONA_IN1R_HPF_SHIFT, 1, 0),
+SOC_SINGLE("IN2L HPF Switch", ARIZONA_IN2L_CONTROL,
+	   ARIZONA_IN2L_HPF_SHIFT, 1, 0),
+SOC_SINGLE("IN2R HPF Switch", ARIZONA_IN2R_CONTROL,
+	   ARIZONA_IN2R_HPF_SHIFT, 1, 0),
+SOC_SINGLE("IN3L HPF Switch", ARIZONA_IN3L_CONTROL,
+	   ARIZONA_IN3L_HPF_SHIFT, 1, 0),
+SOC_SINGLE("IN3R HPF Switch", ARIZONA_IN3R_CONTROL,
+	   ARIZONA_IN3R_HPF_SHIFT, 1, 0),
+SOC_SINGLE("IN4L HPF Switch", ARIZONA_IN4L_CONTROL,
+	   ARIZONA_IN4L_HPF_SHIFT, 1, 0),
+SOC_SINGLE("IN4R HPF Switch", ARIZONA_IN4R_CONTROL,
+	   ARIZONA_IN4R_HPF_SHIFT, 1, 0),
+
 SOC_SINGLE_TLV("IN1L Digital Volume", ARIZONA_ADC_DIGITAL_VOLUME_1L,
 	       ARIZONA_IN1L_DIG_VOL_SHIFT, 0xbf, 0, digital_tlv),
 SOC_SINGLE_TLV("IN1R Digital Volume", ARIZONA_ADC_DIGITAL_VOLUME_1R,
-- 
1.7.2.5

