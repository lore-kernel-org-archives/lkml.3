Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab3GCXYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:24:47 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:54226 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933287Ab3GCXYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:24:42 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: jonarne@jonarne.no, linux-kernel@vger.kernel.org, mchehab@redhat.com,
        hans.verkuil@cisco.com, prabhakar.csengg@gmail.com,
        laurent.pinchart@ideasonboard.com, andriy.shevchenko@linux.intel.com
Subject: [RFC v3 3/3] saa7115: Implement i2c_board_info.platform_data
Date: Thu,  4 Jul 2013 01:27:20 +0200
Message-Id: <1372894040-23922-4-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372894040-23922-1-git-send-email-jonarne@jonarne.no>
References: <1372894040-23922-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement i2c_board_info.platform_data handling in the driver so we can
make device specific changes to the chips we support.

I'm adding a new init table for the gm7113c chip because the old saa7113
init table has a illegal and wrong defaults according to the datasheet.

I'm also adding an option to the platform_data struct to choose the gm7113c_init
table even if you are writing a driver for the saa7113 chip.

This implementation is only adding overrides for the SAA7113 and GM7113C chips.

Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
---
 drivers/media/i2c/saa7115.c      | 144 ++++++++++++++++++++++++++++++++++++---
 drivers/media/i2c/saa711x_regs.h |  15 ++++
 include/media/saa7115.h          |  65 ++++++++++++++++++
 3 files changed, 215 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 17a464d..dd51e16 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -225,19 +225,55 @@ static const unsigned char saa7111_init[] = {
 	0x00, 0x00
 };
 
-/* SAA7113/GM7113C init codes
- * It's important that R_14... R_17 == 0x00
- * for the gm7113c chip to deliver stable video
- */
+/* This table has one illegal value, and some values that are not
+   correct according to the datasheet initialization table.
+
+   If you need a table with legal/default values tell the driver in
+   i2c_board_info.platform_data, and you will get the gm7113c_init
+   table instead. */
+
+/* SAA7113 Init codes */
 static const unsigned char saa7113_init[] = {
 	R_01_INC_DELAY, 0x08,
 	R_02_INPUT_CNTL_1, 0xc2,
 	R_03_INPUT_CNTL_2, 0x30,
 	R_04_INPUT_CNTL_3, 0x00,
 	R_05_INPUT_CNTL_4, 0x00,
-	R_06_H_SYNC_START, 0x89,
+	R_06_H_SYNC_START, 0x89,	/* Illegal value - min. value = 0x94 */
+	R_07_H_SYNC_STOP, 0x0d,
+	R_08_SYNC_CNTL, 0x88,		/* OBS. HTC = VTR Mode - Not default */
+	R_09_LUMA_CNTL, 0x01,
+	R_0A_LUMA_BRIGHT_CNTL, 0x80,
+	R_0B_LUMA_CONTRAST_CNTL, 0x47,
+	R_0C_CHROMA_SAT_CNTL, 0x40,
+	R_0D_CHROMA_HUE_CNTL, 0x00,
+	R_0E_CHROMA_CNTL_1, 0x01,
+	R_0F_CHROMA_GAIN_CNTL, 0x2a,
+	R_10_CHROMA_CNTL_2, 0x08,	/* Not datasheet default */
+	R_11_MODE_DELAY_CNTL, 0x0c,
+	R_12_RT_SIGNAL_CNTL, 0x07,	/* Not datasheet default */
+	R_13_RT_X_PORT_OUT_CNTL, 0x00,
+	R_14_ANAL_ADC_COMPAT_CNTL, 0x00,
+	R_15_VGATE_START_FID_CHG, 0x00,
+	R_16_VGATE_STOP, 0x00,
+	R_17_MISC_VGATE_CONF_AND_MSB, 0x00,
+
+	0x00, 0x00
+};
+
+/* GM7113C is a clone of the SAA7113 chip
+   This init table is copied out of the saa7113 datasheet.
+   In R_08 we enable "Automatic Field Detection" [AUFD],
+   this is disabled when saa711x_set_v4lstd is called. */
+static const unsigned char gm7113c_init[] = {
+	R_01_INC_DELAY, 0x08,
+	R_02_INPUT_CNTL_1, 0xc0,
+	R_03_INPUT_CNTL_2, 0x33,
+	R_04_INPUT_CNTL_3, 0x00,
+	R_05_INPUT_CNTL_4, 0x00,
+	R_06_H_SYNC_START, 0xe9,
 	R_07_H_SYNC_STOP, 0x0d,
-	R_08_SYNC_CNTL, 0x88,
+	R_08_SYNC_CNTL, 0x98,			/* AUFD - BIT7 Enabled */
 	R_09_LUMA_CNTL, 0x01,
 	R_0A_LUMA_BRIGHT_CNTL, 0x80,
 	R_0B_LUMA_CONTRAST_CNTL, 0x47,
@@ -245,9 +281,9 @@ static const unsigned char saa7113_init[] = {
 	R_0D_CHROMA_HUE_CNTL, 0x00,
 	R_0E_CHROMA_CNTL_1, 0x01,
 	R_0F_CHROMA_GAIN_CNTL, 0x2a,
-	R_10_CHROMA_CNTL_2, 0x08,
+	R_10_CHROMA_CNTL_2, 0x00,
 	R_11_MODE_DELAY_CNTL, 0x0c,
-	R_12_RT_SIGNAL_CNTL, 0x07,
+	R_12_RT_SIGNAL_CNTL, 0x01,
 	R_13_RT_X_PORT_OUT_CNTL, 0x00,
 	R_14_ANAL_ADC_COMPAT_CNTL, 0x00,
 	R_15_VGATE_START_FID_CHG, 0x00,
@@ -1585,6 +1621,85 @@ static const struct v4l2_subdev_ops saa711x_ops = {
 
 /* ----------------------------------------------------------------------- */
 
+static void saa711x_write_platform_data(struct saa711x_state *state,
+					struct saa7115_platform_data *data)
+{
+	struct v4l2_subdev *sd = &state->sd;
+	u8 work;
+
+	if (state->ident != GM7113C &&
+	    state->ident != SAA7113)
+		return;
+
+	if (data->saa7113_r08_htc) {
+		work = saa711x_read(sd, R_08_SYNC_CNTL);
+		work &= ~SAA7113_R_08_HTC_MASK;
+		work |= ((*data->saa7113_r08_htc) << SAA7113_R_08_HTC_OFFSET);
+		if (*data->saa7113_r08_htc != SAA7113_HTC_RESERVED) {
+			v4l2_dbg(1, debug, sd,
+				"set R_08 HTC [Mask 0x%02x] [Value 0x%02x]\n",
+				SAA7113_R_08_HTC_MASK, *data->saa7113_r08_htc);
+			saa711x_write(sd, R_08_SYNC_CNTL, work);
+		}
+	}
+
+	if (data->saa7113_r10_vrln) {
+		work = saa711x_read(sd, R_10_CHROMA_CNTL_2);
+		work &= ~SAA7113_R_10_VRLN_MASK;
+		if (*data->saa7113_r10_vrln)
+			work |= (1 << SAA7113_R_10_VRLN_OFFSET);
+
+		v4l2_dbg(1, debug, sd,
+			 "set R_10 VRLN [Mask 0x%02x] [Value 0x%02x]\n",
+			 SAA7113_R_10_VRLN_MASK, *data->saa7113_r10_vrln);
+		saa711x_write(sd, R_10_CHROMA_CNTL_2, work);
+	}
+
+	if (data->saa7113_r10_ofts) {
+		work = saa711x_read(sd, R_10_CHROMA_CNTL_2);
+		work &= ~SAA7113_R_10_OFTS_MASK;
+		work |= (*data->saa7113_r10_ofts << SAA7113_R_10_OFTS_OFFSET);
+		v4l2_dbg(1, debug, sd,
+			"set R_10 OFTS [Mask 0x%02x] [Value 0x%02x]\n",
+			SAA7113_R_10_OFTS_MASK, *data->saa7113_r10_ofts);
+		saa711x_write(sd, R_10_CHROMA_CNTL_2, work);
+	}
+
+	if (data->saa7113_r12_rts0) {
+		work = saa711x_read(sd, R_12_RT_SIGNAL_CNTL);
+		work &= ~SAA7113_R_12_RTS0_MASK;
+		work |= (*data->saa7113_r12_rts0 << SAA7113_R_12_RTS0_OFFSET);
+		if (*data->saa7113_r12_rts0 != SAA7113_RTS_DOT_IN) {
+			v4l2_dbg(1, debug, sd,
+				"set R_12 RTS0 [Mask 0x%02x] [Value 0x%02x]\n",
+				SAA7113_R_12_RTS0_MASK,
+				*data->saa7113_r12_rts0);
+			saa711x_write(sd, R_12_RT_SIGNAL_CNTL, work);
+		}
+	}
+
+	if (data->saa7113_r12_rts1) {
+		work = saa711x_read(sd, R_12_RT_SIGNAL_CNTL);
+		work &= ~SAA7113_R_12_RTS1_MASK;
+		work |= (*data->saa7113_r12_rts1 << SAA7113_R_12_RTS1_OFFSET);
+		v4l2_dbg(1, debug, sd,
+			"set R_12 RTS1 [Mask 0x%02x] [Value 0x%02x]\n",
+			SAA7113_R_12_RTS1_MASK, *data->saa7113_r12_rts1);
+		saa711x_write(sd, R_12_RT_SIGNAL_CNTL, work);
+	}
+
+	if (data->saa7113_r13_adlsb) {
+		work = saa711x_read(sd, R_13_RT_X_PORT_OUT_CNTL);
+		work &= ~SAA7113_R_13_ADLSB_MASK;
+		if (*data->saa7113_r13_adlsb)
+			work |= (1 << SAA7113_R_13_ADLSB_OFFSET);
+		v4l2_dbg(1, debug, sd,
+			"set R_13 ADLSB [Mask 0x%02x] [Value 0x%02x]\n",
+			SAA7113_R_13_ADLSB_MASK, *data->saa7113_r13_adlsb);
+		saa711x_write(sd, R_13_RT_X_PORT_OUT_CNTL, work);
+	}
+}
+
 /**
  * saa711x_detect_chip - Detects the saa711x (or clone) variant
  * @client:		I2C client structure.
@@ -1693,6 +1808,7 @@ static int saa711x_probe(struct i2c_client *client,
 	struct saa711x_state *state;
 	struct v4l2_subdev *sd;
 	struct v4l2_ctrl_handler *hdl;
+	struct saa7115_platform_data *pdata;
 	int ident;
 	char name[CHIP_VER_SIZE + 1];
 
@@ -1756,14 +1872,20 @@ static int saa711x_probe(struct i2c_client *client,
 
 	/* init to 60hz/48khz */
 	state->crystal_freq = SAA7115_FREQ_24_576_MHZ;
+	pdata = client->dev.platform_data;
 	switch (state->ident) {
 	case SAA7111:
 	case SAA7111A:
 		saa711x_writeregs(sd, saa7111_init);
 		break;
 	case GM7113C:
+		saa711x_writeregs(sd, gm7113c_init);
+		break;
 	case SAA7113:
-		saa711x_writeregs(sd, saa7113_init);
+		if (pdata && pdata->saa7113_force_gm7113c_init)
+			saa711x_writeregs(sd, gm7113c_init);
+		else
+			saa711x_writeregs(sd, saa7113_init);
 		break;
 	default:
 		state->crystal_freq = SAA7115_FREQ_32_11_MHZ;
@@ -1771,6 +1893,10 @@ static int saa711x_probe(struct i2c_client *client,
 	}
 	if (state->ident > SAA7111A && state->ident != GM7113C)
 		saa711x_writeregs(sd, saa7115_init_misc);
+
+	if (pdata)
+		saa711x_write_platform_data(state, pdata);
+
 	saa711x_set_v4lstd(sd, V4L2_STD_NTSC);
 	v4l2_ctrl_handler_setup(hdl);
 
diff --git a/drivers/media/i2c/saa711x_regs.h b/drivers/media/i2c/saa711x_regs.h
index 70c56d1..730ca90 100644
--- a/drivers/media/i2c/saa711x_regs.h
+++ b/drivers/media/i2c/saa711x_regs.h
@@ -202,9 +202,24 @@
 #define R_FF_S_PLL_MAX_PHASE_ERR_THRESH_NUM_LINES     0xff
 
 /* SAA7113 bit-masks */
+#define SAA7113_R_08_HTC_OFFSET 3
+#define SAA7113_R_08_HTC_MASK (0x3 << SAA7113_R_08_HTC_OFFSET)
 #define SAA7113_R_08_FSEL 0x40
 #define SAA7113_R_08_AUFD 0x80
 
+#define SAA7113_R_10_VRLN_OFFSET 3
+#define SAA7113_R_10_VRLN_MASK (0x1 << SAA7113_R_10_VRLN_OFFSET)
+#define SAA7113_R_10_OFTS_OFFSET 6
+#define SAA7113_R_10_OFTS_MASK (0x3 << SAA7113_R_10_OFTS_OFFSET)
+
+#define SAA7113_R_12_RTS0_OFFSET 0
+#define SAA7113_R_12_RTS0_MASK (0xf << SAA7113_R_12_RTS0_OFFSET)
+#define SAA7113_R_12_RTS1_OFFSET 4
+#define SAA7113_R_12_RTS1_MASK (0xf << SAA7113_R_12_RTS1_OFFSET)
+
+#define SAA7113_R_13_ADLSB_OFFSET 7
+#define SAA7113_R_13_ADLSB_MASK (0x1 << SAA7113_R_13_ADLSB_OFFSET)
+
 #if 0
 /* Those structs will be used in the future for debug purposes */
 struct saa711x_reg_descr {
diff --git a/include/media/saa7115.h b/include/media/saa7115.h
index 4079186..d2e5a37 100644
--- a/include/media/saa7115.h
+++ b/include/media/saa7115.h
@@ -64,5 +64,70 @@
 #define SAA7115_FREQ_FL_APLL         (1 << 2) /* SA 3A[3], APLL, SAA7114/5 only */
 #define SAA7115_FREQ_FL_DOUBLE_ASCLK (1 << 3) /* SA 39, LRDIV, SAA7114/5 only */
 
+/* ===== SAA7113 Config enums ===== */
+
+/* Register 0x08 "Horizontal time constant" [Bit 3..4]:
+ * Should be set to "Fast Locking Mode" according to the datasheet,
+ * and that is the default setting in the gm7113c_init table.
+ * saa7113_init sets this value to "VTR Mode". */
+enum saa7113_r08_htc {
+	SAA7113_HTC_TV_MODE = 0x00,
+	SAA7113_HTC_VTR_MODE,		/* Default for saa7113_init */
+	SAA7113_HTC_RESERVED,		/* DO NOT USE */
+	SAA7113_HTC_FAST_LOCKING_MODE	/* Default for gm7113c_init */
+};
+
+/* Register 0x10 "Output format selection" [Bit 6..7]:
+ * Defaults to ITU_656 as specified in datasheet. */
+enum saa7113_r10_ofts {
+	SAA7113_OFTS_ITU_656 = 0x0,	/* Default */
+	SAA7113_OFTS_VFLAG_BY_VREF,
+	SAA7113_OFTS_VFLAG_BY_DATA_TYPE
+};
+
+/* Register 0x12 "Output control" [Bit 0..3 Or Bit 4..7]:
+ * This is used to select what data is output on the RTS0 and RTS1 pins.
+ * RTS1 [Bit 4..7] Defaults to DOT_IN. (This value can not be set for RTS0)
+ * RTS0 [Bit 0..3] Defaults to VIPB in gm7113c_init as specified
+ * in the datasheet, but is set to HREF_HS in the saa7113_init table. */
+enum saa7113_r12_rts {
+	SAA7113_RTS_DOT_IN = 0,		/* OBS: Only for RTS1 (Default RTS1) */
+	SAA7113_RTS_VIPB,		/* Default RTS0 For gm7113c_init */
+	SAA7113_RTS_GPSW,
+	SAA7115_RTS_HL,
+	SAA7113_RTS_VL,
+	SAA7113_RTS_DL,
+	SAA7113_RTS_PLIN,
+	SAA7113_RTS_HREF_HS,		/* Default RTS0 For saa7113_init */
+	SAA7113_RTS_HS,
+	SAA7113_RTS_HQ,
+	SAA7113_RTS_ODD,
+	SAA7113_RTS_VS,
+	SAA7113_RTS_V123,
+	SAA7113_RTS_VGATE,
+	SAA7113_RTS_VREF,
+	SAA7113_RTS_FID
+};
+
+struct saa7115_platform_data {
+	/* saa7113 only: Force the use of the gm7113c_init table,
+	 * instead of the old saa7113_init table. */
+	bool saa7113_force_gm7113c_init;
+
+	/* SAA7113/GM7113C Specific configurations */
+	enum saa7113_r08_htc *saa7113_r08_htc;	/* [R_08 - Bit 3..4] */
+
+	bool *saa7113_r10_vrln;			/* [R_10 - Bit 3]
+						   Disabled for gm7113c_init
+						   Enabled for saa7113c_init */
+	enum saa7113_r10_ofts *saa7113_r10_ofts;	/* [R_10 - Bit 6..7] */
+
+	enum saa7113_r12_rts *saa7113_r12_rts0;		/* [R_12 - Bit 0..3] */
+	enum saa7113_r12_rts *saa7113_r12_rts1;		/* [R_12 - Bit 4..7] */
+
+	bool *saa7113_r13_adlsb;			/* [R_13 - Bit 7]
+							   Default disabled */
+};
+
 #endif
 
-- 
1.8.3.1

