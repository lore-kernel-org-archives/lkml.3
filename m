Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaKQK4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:56:35 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:58531 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaKQK4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:56:30 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <b67c8ece8bba217028c6387bb7faa8a3>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Andy yan <andy.yan@rock-chips.com>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v12 04/11] staging: imx-drm: imx-hdmi: move imx-hdmi to bridge/dw_hdmi
Date: Mon, 17 Nov 2014 18:56:16 +0800
Message-Id: <1416221776-12985-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com>
References: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the original imx hdmi driver is under staging/imx-drm,
which depends on imx-drm, so move the imx hdmi driver out
to drm/bridge and rename imx-hdmi to dw_hdmi

handle encoder in dw_hdmi-imx.c, as most of the encoder
operation are platform specific such as crtc select and
panel format set

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v12: None
Changes in v11: None
Changes in v10: None
Changes in v9: None
Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2:
- use git format -M to generate these patch

 drivers/gpu/drm/bridge/Kconfig                     |   5 +
 drivers/gpu/drm/bridge/Makefile                    |   1 +
 .../imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c}        | 544 +++++----------------
 .../imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h}        |   4 +-
 drivers/staging/imx-drm/Kconfig                    |   1 +
 drivers/staging/imx-drm/Makefile                   |   2 +-
 drivers/staging/imx-drm/dw_hdmi-imx.c              | 274 +++++++++++
 include/drm/bridge/dw_hdmi.h                       |  57 +++
 8 files changed, 470 insertions(+), 418 deletions(-)
 rename drivers/{staging/imx-drm/imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c} (73%)
 rename drivers/{staging/imx-drm/imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h} (99%)
 create mode 100644 drivers/staging/imx-drm/dw_hdmi-imx.c
 create mode 100644 include/drm/bridge/dw_hdmi.h

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 884923f..26162ef 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -3,3 +3,8 @@ config DRM_PTN3460
 	depends on DRM
 	select DRM_KMS_HELPER
 	---help---
+
+config DRM_DW_HDMI
+	bool "Synopsys DesignWare High-Definition Multimedia Interface"
+	depends on DRM
+	select DRM_KMS_HELPER
diff --git a/drivers/gpu/drm/bridge/Makefile b/drivers/gpu/drm/bridge/Makefile
index b4733e1..d8a8cfd 100644
--- a/drivers/gpu/drm/bridge/Makefile
+++ b/drivers/gpu/drm/bridge/Makefile
@@ -1,3 +1,4 @@
 ccflags-y := -Iinclude/drm
 
 obj-$(CONFIG_DRM_PTN3460) += ptn3460.o
+obj-$(CONFIG_DRM_DW_HDMI) += dw_hdmi.o
diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
similarity index 73%
rename from drivers/staging/imx-drm/imx-hdmi.c
rename to drivers/gpu/drm/bridge/dw_hdmi.c
index c42da29..f904bb4 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/gpu/drm/bridge/dw_hdmi.c
@@ -6,21 +6,15 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
- * SH-Mobile High-Definition Multimedia Interface (HDMI) driver
- * for SLISHDMI13T and SLIPHDMIT IP cores
+ * Designware High-Definition Multimedia Interface (HDMI) driver
  *
  * Copyright (C) 2010, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
  */
-
-#include <linux/component.h>
+#include <linux/module.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
 #include <linux/err.h>
-#include <linux/clk.h>
 #include <linux/hdmi.h>
-#include <linux/regmap.h>
-#include <linux/mfd/syscon.h>
-#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
 #include <linux/of_device.h>
 
 #include <drm/drm_of.h>
@@ -28,10 +22,9 @@
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_edid.h>
 #include <drm/drm_encoder_slave.h>
-#include <video/imx-ipu-v3.h>
+#include <drm/bridge/dw_hdmi.h>
 
-#include "imx-hdmi.h"
-#include "imx-drm.h"
+#include "dw_hdmi.h"
 
 #define HDMI_EDID_LEN		512
 
@@ -55,11 +48,6 @@ enum hdmi_datamap {
 	YCbCr422_12B = 0x12,
 };
 
-enum imx_hdmi_devtype {
-	IMX6Q_HDMI,
-	IMX6DL_HDMI,
-};
-
 static const u16 csc_coeff_default[3][4] = {
 	{ 0x2000, 0x0000, 0x0000, 0x0000 },
 	{ 0x0000, 0x2000, 0x0000, 0x0000 },
@@ -112,23 +100,16 @@ struct hdmi_data_info {
 	struct hdmi_vmode video_mode;
 };
 
-struct imx_hdmi_plat_data {
-	const struct mpll_config *mpll_cfg;
-	const struct curr_ctrl *cur_ctr;
-	const struct sym_term *sym_term;
-	enum imx_hdmi_devtype dev_type;
-};
-
-struct imx_hdmi {
+struct dw_hdmi {
 	struct drm_connector connector;
 	struct drm_encoder *encoder;
 	struct drm_bridge *bridge;
 
-	enum imx_hdmi_devtype dev_type;
+	enum dw_hdmi_devtype dev_type;
 	struct device *dev;
 
 	struct hdmi_data_info hdmi_data;
-	const struct imx_hdmi_plat_data *plat_data;
+	const struct dw_hdmi_plat_data *plat_data;
 	void *priv;
 	int vic;
 
@@ -146,25 +127,17 @@ struct imx_hdmi {
 	int ratio;
 };
 
-struct imx_hdmi_priv {
-	struct device *dev;
-	struct clk *isfr_clk;
-	struct clk *iahb_clk;
-	struct regmap *regmap;
-	struct drm_encoder encoder;
-};
-
-static inline void hdmi_writeb(struct imx_hdmi *hdmi, u8 val, int offset)
+static inline void hdmi_writeb(struct dw_hdmi *hdmi, u8 val, int offset)
 {
 	writeb(val, hdmi->regs + offset);
 }
 
-static inline u8 hdmi_readb(struct imx_hdmi *hdmi, int offset)
+static inline u8 hdmi_readb(struct dw_hdmi *hdmi, int offset)
 {
 	return readb(hdmi->regs + offset);
 }
 
-static void hdmi_modb(struct imx_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
+static void hdmi_modb(struct dw_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
 {
 	u8 val = hdmi_readb(hdmi, reg) & ~mask;
 
@@ -172,13 +145,13 @@ static void hdmi_modb(struct imx_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
 	hdmi_writeb(hdmi, val, reg);
 }
 
-static void hdmi_mask_writeb(struct imx_hdmi *hdmi, u8 data, unsigned int reg,
+static void hdmi_mask_writeb(struct dw_hdmi *hdmi, u8 data, unsigned int reg,
 			     u8 shift, u8 mask)
 {
 	hdmi_modb(hdmi, data << shift, mask, reg);
 }
 
-static void hdmi_set_clock_regenerator_n(struct imx_hdmi *hdmi,
+static void hdmi_set_clock_regenerator_n(struct dw_hdmi *hdmi,
 					 unsigned int value)
 {
 	hdmi_writeb(hdmi, value & 0xff, HDMI_AUD_N1);
@@ -189,7 +162,7 @@ static void hdmi_set_clock_regenerator_n(struct imx_hdmi *hdmi,
 	hdmi_modb(hdmi, 0, HDMI_AUD_CTS3_N_SHIFT_MASK, HDMI_AUD_CTS3);
 }
 
-static void hdmi_regenerate_cts(struct imx_hdmi *hdmi, unsigned int cts)
+static void hdmi_regenerate_cts(struct dw_hdmi *hdmi, unsigned int cts)
 {
 	/* Must be set/cleared first */
 	hdmi_modb(hdmi, 0, HDMI_AUD_CTS3_CTS_MANUAL, HDMI_AUD_CTS3);
@@ -336,7 +309,7 @@ static unsigned int hdmi_compute_cts(unsigned int freq, unsigned long pixel_clk,
 	return (cts * ratio) / 100;
 }
 
-static void hdmi_set_clk_regenerator(struct imx_hdmi *hdmi,
+static void hdmi_set_clk_regenerator(struct dw_hdmi *hdmi,
 				     unsigned long pixel_clk)
 {
 	unsigned int clk_n, clk_cts;
@@ -360,12 +333,12 @@ static void hdmi_set_clk_regenerator(struct imx_hdmi *hdmi,
 	hdmi_regenerate_cts(hdmi, clk_cts);
 }
 
-static void hdmi_init_clk_regenerator(struct imx_hdmi *hdmi)
+static void hdmi_init_clk_regenerator(struct dw_hdmi *hdmi)
 {
 	hdmi_set_clk_regenerator(hdmi, 74250000);
 }
 
-static void hdmi_clk_regenerator_update_pixel_clock(struct imx_hdmi *hdmi)
+static void hdmi_clk_regenerator_update_pixel_clock(struct dw_hdmi *hdmi)
 {
 	hdmi_set_clk_regenerator(hdmi, hdmi->hdmi_data.video_mode.mpixelclock);
 }
@@ -377,7 +350,7 @@ static void hdmi_clk_regenerator_update_pixel_clock(struct imx_hdmi *hdmi)
  *			pin{31~24} <==> G[7:0]
  *			pin{15~8}  <==> B[7:0]
  */
-static void hdmi_video_sample(struct imx_hdmi *hdmi)
+static void hdmi_video_sample(struct dw_hdmi *hdmi)
 {
 	int color_format = 0;
 	u8 val;
@@ -433,12 +406,12 @@ static void hdmi_video_sample(struct imx_hdmi *hdmi)
 	hdmi_writeb(hdmi, 0x0, HDMI_TX_BCBDATA1);
 }
 
-static int is_color_space_conversion(struct imx_hdmi *hdmi)
+static int is_color_space_conversion(struct dw_hdmi *hdmi)
 {
 	return hdmi->hdmi_data.enc_in_format != hdmi->hdmi_data.enc_out_format;
 }
 
-static int is_color_space_decimation(struct imx_hdmi *hdmi)
+static int is_color_space_decimation(struct dw_hdmi *hdmi)
 {
 	if (hdmi->hdmi_data.enc_out_format != YCBCR422_8BITS)
 		return 0;
@@ -448,7 +421,7 @@ static int is_color_space_decimation(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static int is_color_space_interpolation(struct imx_hdmi *hdmi)
+static int is_color_space_interpolation(struct dw_hdmi *hdmi)
 {
 	if (hdmi->hdmi_data.enc_in_format != YCBCR422_8BITS)
 		return 0;
@@ -458,7 +431,7 @@ static int is_color_space_interpolation(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static void imx_hdmi_update_csc_coeffs(struct imx_hdmi *hdmi)
+static void dw_hdmi_update_csc_coeffs(struct dw_hdmi *hdmi)
 {
 	const u16 (*csc_coeff)[3][4] = &csc_coeff_default;
 	unsigned i;
@@ -499,7 +472,7 @@ static void imx_hdmi_update_csc_coeffs(struct imx_hdmi *hdmi)
 		  HDMI_CSC_SCALE);
 }
 
-static void hdmi_video_csc(struct imx_hdmi *hdmi)
+static void hdmi_video_csc(struct dw_hdmi *hdmi)
 {
 	int color_depth = 0;
 	int interpolation = HDMI_CSC_CFG_INTMODE_DISABLE;
@@ -527,7 +500,7 @@ static void hdmi_video_csc(struct imx_hdmi *hdmi)
 	hdmi_modb(hdmi, color_depth, HDMI_CSC_SCALE_CSC_COLORDE_PTH_MASK,
 		  HDMI_CSC_SCALE);
 
-	imx_hdmi_update_csc_coeffs(hdmi);
+	dw_hdmi_update_csc_coeffs(hdmi);
 }
 
 /*
@@ -535,7 +508,7 @@ static void hdmi_video_csc(struct imx_hdmi *hdmi)
  * for example, if input is YCC422 mode or repeater is used,
  * data should be repacked this module can be bypassed.
  */
-static void hdmi_video_packetize(struct imx_hdmi *hdmi)
+static void hdmi_video_packetize(struct dw_hdmi *hdmi)
 {
 	unsigned int color_depth = 0;
 	unsigned int remap_size = HDMI_VP_REMAP_YCC422_16bit;
@@ -632,40 +605,40 @@ static void hdmi_video_packetize(struct imx_hdmi *hdmi)
 		  HDMI_VP_CONF);
 }
 
-static inline void hdmi_phy_test_clear(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_clear(struct dw_hdmi *hdmi,
 				       unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTCLR_OFFSET,
 		  HDMI_PHY_TST0_TSTCLR_MASK, HDMI_PHY_TST0);
 }
 
-static inline void hdmi_phy_test_enable(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_enable(struct dw_hdmi *hdmi,
 					unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTEN_OFFSET,
 		  HDMI_PHY_TST0_TSTEN_MASK, HDMI_PHY_TST0);
 }
 
-static inline void hdmi_phy_test_clock(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_clock(struct dw_hdmi *hdmi,
 				       unsigned char bit)
 {
 	hdmi_modb(hdmi, bit << HDMI_PHY_TST0_TSTCLK_OFFSET,
 		  HDMI_PHY_TST0_TSTCLK_MASK, HDMI_PHY_TST0);
 }
 
-static inline void hdmi_phy_test_din(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_din(struct dw_hdmi *hdmi,
 				     unsigned char bit)
 {
 	hdmi_writeb(hdmi, bit, HDMI_PHY_TST1);
 }
 
-static inline void hdmi_phy_test_dout(struct imx_hdmi *hdmi,
+static inline void hdmi_phy_test_dout(struct dw_hdmi *hdmi,
 				      unsigned char bit)
 {
 	hdmi_writeb(hdmi, bit, HDMI_PHY_TST2);
 }
 
-static bool hdmi_phy_wait_i2c_done(struct imx_hdmi *hdmi, int msec)
+static bool hdmi_phy_wait_i2c_done(struct dw_hdmi *hdmi, int msec)
 {
 	while ((hdmi_readb(hdmi, HDMI_IH_I2CMPHY_STAT0) & 0x3) == 0) {
 		if (msec-- == 0)
@@ -675,7 +648,7 @@ static bool hdmi_phy_wait_i2c_done(struct imx_hdmi *hdmi, int msec)
 	return true;
 }
 
-static void __hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
+static void __hdmi_phy_i2c_write(struct dw_hdmi *hdmi, unsigned short data,
 				 unsigned char addr)
 {
 	hdmi_writeb(hdmi, 0xFF, HDMI_IH_I2CMPHY_STAT0);
@@ -689,133 +662,56 @@ static void __hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
 	hdmi_phy_wait_i2c_done(hdmi, 1000);
 }
 
-static int hdmi_phy_i2c_write(struct imx_hdmi *hdmi, unsigned short data,
+static int hdmi_phy_i2c_write(struct dw_hdmi *hdmi, unsigned short data,
 			      unsigned char addr)
 {
 	__hdmi_phy_i2c_write(hdmi, data, addr);
 	return 0;
 }
 
-static void imx_hdmi_phy_enable_power(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_enable_power(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_PDZ_OFFSET,
 			 HDMI_PHY_CONF0_PDZ_MASK);
 }
 
-static void imx_hdmi_phy_enable_tmds(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_enable_tmds(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_ENTMDS_OFFSET,
 			 HDMI_PHY_CONF0_ENTMDS_MASK);
 }
 
-static void imx_hdmi_phy_gen2_pddq(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_gen2_pddq(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_GEN2_PDDQ_OFFSET,
 			 HDMI_PHY_CONF0_GEN2_PDDQ_MASK);
 }
 
-static void imx_hdmi_phy_gen2_txpwron(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_gen2_txpwron(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_GEN2_TXPWRON_OFFSET,
 			 HDMI_PHY_CONF0_GEN2_TXPWRON_MASK);
 }
 
-static void imx_hdmi_phy_sel_data_en_pol(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_sel_data_en_pol(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_SELDATAENPOL_OFFSET,
 			 HDMI_PHY_CONF0_SELDATAENPOL_MASK);
 }
 
-static void imx_hdmi_phy_sel_interface_control(struct imx_hdmi *hdmi, u8 enable)
+static void dw_hdmi_phy_sel_interface_control(struct dw_hdmi *hdmi, u8 enable)
 {
 	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
 			 HDMI_PHY_CONF0_SELDIPIF_OFFSET,
 			 HDMI_PHY_CONF0_SELDIPIF_MASK);
 }
 
-enum {
-	RES_8,
-	RES_10,
-	RES_12,
-	RES_MAX,
-};
-
-struct mpll_config {
-	unsigned long mpixelclock;
-	struct {
-		u16 cpce;
-		u16 gmp;
-	} res[RES_MAX];
-};
-
-static const struct mpll_config imx_mpll_cfg[] = {
-	{
-		45250000, {
-			{ 0x01e0, 0x0000 },
-			{ 0x21e1, 0x0000 },
-			{ 0x41e2, 0x0000 }
-		},
-	}, {
-		92500000, {
-			{ 0x0140, 0x0005 },
-			{ 0x2141, 0x0005 },
-			{ 0x4142, 0x0005 },
-		},
-	}, {
-		148500000, {
-			{ 0x00a0, 0x000a },
-			{ 0x20a1, 0x000a },
-			{ 0x40a2, 0x000a },
-		},
-	}, {
-		~0UL, {
-			{ 0x00a0, 0x000a },
-			{ 0x2001, 0x000f },
-			{ 0x4002, 0x000f },
-		},
-	}
-};
-
-struct curr_ctrl {
-	unsigned long mpixelclock;
-	u16 curr[RES_MAX];
-};
-
-static const struct curr_ctrl imx_cur_ctr[] = {
-	/*	pixelclk     bpp8    bpp10   bpp12 */
-	{
-		 54000000, { 0x091c, 0x091c, 0x06dc },
-	}, {
-		 58400000, { 0x091c, 0x06dc, 0x06dc },
-	}, {
-		 72000000, { 0x06dc, 0x06dc, 0x091c },
-	}, {
-		 74250000, { 0x06dc, 0x0b5c, 0x091c },
-	}, {
-		118800000, { 0x091c, 0x091c, 0x06dc },
-	}, {
-		216000000, { 0x06dc, 0x0b5c, 0x091c },
-	}
-};
-
-struct sym_term {
-	unsigned long mpixelclock;
-	u16 sym_ctr;    /*clock symbol and transmitter control*/
-	u16 term;       /*transmission termination value*/
-};
-
-static const struct sym_term imx_sym_term[] = {
-	/*pixelclk   symbol   term*/
-	{ 148500000, 0x800d, 0x0005 },
-	{ ~0UL,      0x0000, 0x0000 }
-};
-
-static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
+static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
 			      unsigned char res, int cscon)
 {
 	unsigned res_idx, i;
@@ -851,10 +747,10 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	hdmi_writeb(hdmi, val, HDMI_MC_FLOWCTRL);
 
 	/* gen2 tx power off */
-	imx_hdmi_phy_gen2_txpwron(hdmi, 0);
+	dw_hdmi_phy_gen2_txpwron(hdmi, 0);
 
 	/* gen2 pddq */
-	imx_hdmi_phy_gen2_pddq(hdmi, 1);
+	dw_hdmi_phy_gen2_pddq(hdmi, 1);
 
 	/* PHY reset */
 	hdmi_writeb(hdmi, HDMI_MC_PHYRSTZ_DEASSERT, HDMI_MC_PHYRSTZ);
@@ -908,15 +804,15 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	/* REMOVE CLK TERM */
 	hdmi_phy_i2c_write(hdmi, 0x8000, 0x05);  /* CKCALCTRL */
 
-	imx_hdmi_phy_enable_power(hdmi, 1);
+	dw_hdmi_phy_enable_power(hdmi, 1);
 
 	/* toggle TMDS enable */
-	imx_hdmi_phy_enable_tmds(hdmi, 0);
-	imx_hdmi_phy_enable_tmds(hdmi, 1);
+	dw_hdmi_phy_enable_tmds(hdmi, 0);
+	dw_hdmi_phy_enable_tmds(hdmi, 1);
 
 	/* gen2 tx power on */
-	imx_hdmi_phy_gen2_txpwron(hdmi, 1);
-	imx_hdmi_phy_gen2_pddq(hdmi, 0);
+	dw_hdmi_phy_gen2_txpwron(hdmi, 1);
+	dw_hdmi_phy_gen2_pddq(hdmi, 0);
 
 	/*Wait for PHY PLL lock */
 	msec = 5;
@@ -937,7 +833,7 @@ static int hdmi_phy_configure(struct imx_hdmi *hdmi, unsigned char prep,
 	return 0;
 }
 
-static int imx_hdmi_phy_init(struct imx_hdmi *hdmi)
+static int dw_hdmi_phy_init(struct dw_hdmi *hdmi)
 {
 	int i, ret;
 	bool cscon = false;
@@ -948,10 +844,10 @@ static int imx_hdmi_phy_init(struct imx_hdmi *hdmi)
 
 	/* HDMI Phy spec says to do the phy initialization sequence twice */
 	for (i = 0; i < 2; i++) {
-		imx_hdmi_phy_sel_data_en_pol(hdmi, 1);
-		imx_hdmi_phy_sel_interface_control(hdmi, 0);
-		imx_hdmi_phy_enable_tmds(hdmi, 0);
-		imx_hdmi_phy_enable_power(hdmi, 0);
+		dw_hdmi_phy_sel_data_en_pol(hdmi, 1);
+		dw_hdmi_phy_sel_interface_control(hdmi, 0);
+		dw_hdmi_phy_enable_tmds(hdmi, 0);
+		dw_hdmi_phy_enable_power(hdmi, 0);
 
 		/* Enable CSC */
 		ret = hdmi_phy_configure(hdmi, 0, 8, cscon);
@@ -963,7 +859,7 @@ static int imx_hdmi_phy_init(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static void hdmi_tx_hdcp_config(struct imx_hdmi *hdmi)
+static void hdmi_tx_hdcp_config(struct dw_hdmi *hdmi)
 {
 	u8 de;
 
@@ -982,7 +878,7 @@ static void hdmi_tx_hdcp_config(struct imx_hdmi *hdmi)
 		  HDMI_A_HDCPCFG1_ENCRYPTIONDISABLE_MASK, HDMI_A_HDCPCFG1);
 }
 
-static void hdmi_config_AVI(struct imx_hdmi *hdmi)
+static void hdmi_config_AVI(struct dw_hdmi *hdmi)
 {
 	u8 val, pix_fmt, under_scan;
 	u8 act_ratio, coded_ratio, colorimetry, ext_colorimetry;
@@ -1076,7 +972,7 @@ static void hdmi_config_AVI(struct imx_hdmi *hdmi)
 	hdmi_writeb(hdmi, 0, HDMI_FC_AVISRB1);
 }
 
-static void hdmi_av_composer(struct imx_hdmi *hdmi,
+static void hdmi_av_composer(struct dw_hdmi *hdmi,
 			     const struct drm_display_mode *mode)
 {
 	u8 inv_val;
@@ -1160,19 +1056,19 @@ static void hdmi_av_composer(struct imx_hdmi *hdmi,
 	hdmi_writeb(hdmi, vsync_len, HDMI_FC_VSYNCINWIDTH);
 }
 
-static void imx_hdmi_phy_disable(struct imx_hdmi *hdmi)
+static void dw_hdmi_phy_disable(struct dw_hdmi *hdmi)
 {
 	if (!hdmi->phy_enabled)
 		return;
 
-	imx_hdmi_phy_enable_tmds(hdmi, 0);
-	imx_hdmi_phy_enable_power(hdmi, 0);
+	dw_hdmi_phy_enable_tmds(hdmi, 0);
+	dw_hdmi_phy_enable_power(hdmi, 0);
 
 	hdmi->phy_enabled = false;
 }
 
 /* HDMI Initialization Step B.4 */
-static void imx_hdmi_enable_video_path(struct imx_hdmi *hdmi)
+static void dw_hdmi_enable_video_path(struct dw_hdmi *hdmi)
 {
 	u8 clkdis;
 
@@ -1201,13 +1097,13 @@ static void imx_hdmi_enable_video_path(struct imx_hdmi *hdmi)
 	}
 }
 
-static void hdmi_enable_audio_clk(struct imx_hdmi *hdmi)
+static void hdmi_enable_audio_clk(struct dw_hdmi *hdmi)
 {
 	hdmi_modb(hdmi, 0, HDMI_MC_CLKDIS_AUDCLK_DISABLE, HDMI_MC_CLKDIS);
 }
 
 /* Workaround to clear the overflow condition */
-static void imx_hdmi_clear_overflow(struct imx_hdmi *hdmi)
+static void dw_hdmi_clear_overflow(struct dw_hdmi *hdmi)
 {
 	int count;
 	u8 val;
@@ -1225,19 +1121,19 @@ static void imx_hdmi_clear_overflow(struct imx_hdmi *hdmi)
 		hdmi_writeb(hdmi, val, HDMI_FC_INVIDCONF);
 }
 
-static void hdmi_enable_overflow_interrupts(struct imx_hdmi *hdmi)
+static void hdmi_enable_overflow_interrupts(struct dw_hdmi *hdmi)
 {
 	hdmi_writeb(hdmi, 0, HDMI_FC_MASK2);
 	hdmi_writeb(hdmi, 0, HDMI_IH_MUTE_FC_STAT2);
 }
 
-static void hdmi_disable_overflow_interrupts(struct imx_hdmi *hdmi)
+static void hdmi_disable_overflow_interrupts(struct dw_hdmi *hdmi)
 {
 	hdmi_writeb(hdmi, HDMI_IH_MUTE_FC_STAT2_OVERFLOW_MASK,
 		    HDMI_IH_MUTE_FC_STAT2);
 }
 
-static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
+static int dw_hdmi_setup(struct dw_hdmi *hdmi, struct drm_display_mode *mode)
 {
 	int ret;
 
@@ -1289,12 +1185,12 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 	hdmi_av_composer(hdmi, mode);
 
 	/* HDMI Initializateion Step B.2 */
-	ret = imx_hdmi_phy_init(hdmi);
+	ret = dw_hdmi_phy_init(hdmi);
 	if (ret)
 		return ret;
 
 	/* HDMI Initialization Step B.3 */
-	imx_hdmi_enable_video_path(hdmi);
+	dw_hdmi_enable_video_path(hdmi);
 
 	/* not for DVI mode */
 	if (hdmi->hdmi_data.video_mode.mdvi) {
@@ -1315,7 +1211,7 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 	hdmi_video_sample(hdmi);
 	hdmi_tx_hdcp_config(hdmi);
 
-	imx_hdmi_clear_overflow(hdmi);
+	dw_hdmi_clear_overflow(hdmi);
 	if (hdmi->cable_plugin && !hdmi->hdmi_data.video_mode.mdvi)
 		hdmi_enable_overflow_interrupts(hdmi);
 
@@ -1323,7 +1219,7 @@ static int imx_hdmi_setup(struct imx_hdmi *hdmi, struct drm_display_mode *mode)
 }
 
 /* Wait until we are registered to enable interrupts */
-static int imx_hdmi_fb_registered(struct imx_hdmi *hdmi)
+static int dw_hdmi_fb_registered(struct dw_hdmi *hdmi)
 {
 	hdmi_writeb(hdmi, HDMI_PHY_I2CM_INT_ADDR_DONE_POL,
 		    HDMI_PHY_I2CM_INT_ADDR);
@@ -1341,7 +1237,7 @@ static int imx_hdmi_fb_registered(struct imx_hdmi *hdmi)
 	return 0;
 }
 
-static void initialize_hdmi_ih_mutes(struct imx_hdmi *hdmi)
+static void initialize_hdmi_ih_mutes(struct dw_hdmi *hdmi)
 {
 	u8 ih_mute;
 
@@ -1393,73 +1289,73 @@ static void initialize_hdmi_ih_mutes(struct imx_hdmi *hdmi)
 	hdmi_writeb(hdmi, ih_mute, HDMI_IH_MUTE);
 }
 
-static void imx_hdmi_poweron(struct imx_hdmi *hdmi)
+static void dw_hdmi_poweron(struct dw_hdmi *hdmi)
 {
-	imx_hdmi_setup(hdmi, &hdmi->previous_mode);
+	dw_hdmi_setup(hdmi, &hdmi->previous_mode);
 }
 
-static void imx_hdmi_poweroff(struct imx_hdmi *hdmi)
+static void dw_hdmi_poweroff(struct dw_hdmi *hdmi)
 {
-	imx_hdmi_phy_disable(hdmi);
+	dw_hdmi_phy_disable(hdmi);
 }
 
-static void imx_hdmi_bridge_mode_set(struct drm_bridge *bridge,
+static void dw_hdmi_bridge_mode_set(struct drm_bridge *bridge,
 				    struct drm_display_mode *mode,
 				    struct drm_display_mode *adjusted_mode)
 {
-	struct imx_hdmi *hdmi = bridge->driver_private;
+	struct dw_hdmi *hdmi = bridge->driver_private;
 
-	imx_hdmi_setup(hdmi, mode);
+	dw_hdmi_setup(hdmi, mode);
 
 	/* Store the display mode for plugin/DKMS poweron events */
 	memcpy(&hdmi->previous_mode, mode, sizeof(hdmi->previous_mode));
 }
 
-static bool imx_hdmi_bridge_mode_fixup(struct drm_bridge *bridge,
+static bool dw_hdmi_bridge_mode_fixup(struct drm_bridge *bridge,
 				      const struct drm_display_mode *mode,
 				      struct drm_display_mode *adjusted_mode)
 {
 	return true;
 }
 
-static void imx_hdmi_bridge_disable(struct drm_bridge *bridge)
+static void dw_hdmi_bridge_disable(struct drm_bridge *bridge)
 {
-	struct imx_hdmi *hdmi = bridge->driver_private;
+	struct dw_hdmi *hdmi = bridge->driver_private;
 
-	imx_hdmi_poweroff(hdmi);
+	dw_hdmi_poweroff(hdmi);
 }
 
-static void imx_hdmi_bridge_enable(struct drm_bridge *bridge)
+static void dw_hdmi_bridge_enable(struct drm_bridge *bridge)
 {
-	struct imx_hdmi *hdmi = bridge->driver_private;
+	struct dw_hdmi *hdmi = bridge->driver_private;
 
-	imx_hdmi_poweron(hdmi);
+	dw_hdmi_poweron(hdmi);
 }
 
-static void imx_hdmi_bridge_destroy(struct drm_bridge *bridge)
+static void dw_hdmi_bridge_destroy(struct drm_bridge *bridge)
 {
 	drm_bridge_cleanup(bridge);
 	kfree(bridge);
 }
 
-static void imx_hdmi_bridge_nope(struct drm_bridge *bridge)
+static void dw_hdmi_bridge_nope(struct drm_bridge *bridge)
 {
 	/* do nothing */
 }
 
-static enum drm_connector_status imx_hdmi_connector_detect(struct drm_connector
-							*connector, bool force)
+static enum drm_connector_status
+dw_hdmi_connector_detect(struct drm_connector *connector, bool force)
 {
-	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
+	struct dw_hdmi *hdmi = container_of(connector, struct dw_hdmi,
 					     connector);
 
 	return hdmi_readb(hdmi, HDMI_PHY_STAT0) & HDMI_PHY_HPD ?
 		connector_status_connected : connector_status_disconnected;
 }
 
-static int imx_hdmi_connector_get_modes(struct drm_connector *connector)
+static int dw_hdmi_connector_get_modes(struct drm_connector *connector)
 {
-	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
+	struct dw_hdmi *hdmi = container_of(connector, struct dw_hdmi,
 					     connector);
 	struct edid *edid;
 	int ret;
@@ -1482,46 +1378,46 @@ static int imx_hdmi_connector_get_modes(struct drm_connector *connector)
 	return 0;
 }
 
-static struct drm_encoder *imx_hdmi_connector_best_encoder(struct drm_connector
+static struct drm_encoder *dw_hdmi_connector_best_encoder(struct drm_connector
 							   *connector)
 {
-	struct imx_hdmi *hdmi = container_of(connector, struct imx_hdmi,
+	struct dw_hdmi *hdmi = container_of(connector, struct dw_hdmi,
 					     connector);
 
 	return hdmi->encoder;
 }
 
-static void imx_hdmi_connector_destroy(struct drm_connector *connector)
+static void dw_hdmi_connector_destroy(struct drm_connector *connector)
 {
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
 }
 
-static struct drm_connector_funcs imx_hdmi_connector_funcs = {
+static struct drm_connector_funcs dw_hdmi_connector_funcs = {
 	.dpms = drm_helper_connector_dpms,
 	.fill_modes = drm_helper_probe_single_connector_modes,
-	.detect = imx_hdmi_connector_detect,
-	.destroy = imx_hdmi_connector_destroy,
+	.detect = dw_hdmi_connector_detect,
+	.destroy = dw_hdmi_connector_destroy,
 };
 
-static struct drm_connector_helper_funcs imx_hdmi_connector_helper_funcs = {
-	.get_modes = imx_hdmi_connector_get_modes,
-	.best_encoder = imx_hdmi_connector_best_encoder,
+static struct drm_connector_helper_funcs dw_hdmi_connector_helper_funcs = {
+	.get_modes = dw_hdmi_connector_get_modes,
+	.best_encoder = dw_hdmi_connector_best_encoder,
 };
 
-struct drm_bridge_funcs imx_hdmi_bridge_funcs = {
-	.enable = imx_hdmi_bridge_enable,
-	.disable = imx_hdmi_bridge_disable,
-	.pre_enable = imx_hdmi_bridge_nope,
-	.post_disable = imx_hdmi_bridge_nope,
-	.mode_set = imx_hdmi_bridge_mode_set,
-	.mode_fixup = imx_hdmi_bridge_mode_fixup,
-	.destroy = imx_hdmi_bridge_destroy,
+struct drm_bridge_funcs dw_hdmi_bridge_funcs = {
+	.enable = dw_hdmi_bridge_enable,
+	.disable = dw_hdmi_bridge_disable,
+	.pre_enable = dw_hdmi_bridge_nope,
+	.post_disable = dw_hdmi_bridge_nope,
+	.mode_set = dw_hdmi_bridge_mode_set,
+	.mode_fixup = dw_hdmi_bridge_mode_fixup,
+	.destroy = dw_hdmi_bridge_destroy,
 };
 
-static irqreturn_t imx_hdmi_hardirq(int irq, void *dev_id)
+static irqreturn_t dw_hdmi_hardirq(int irq, void *dev_id)
 {
-	struct imx_hdmi *hdmi = dev_id;
+	struct dw_hdmi *hdmi = dev_id;
 	u8 intr_stat;
 
 	intr_stat = hdmi_readb(hdmi, HDMI_IH_PHY_STAT0);
@@ -1531,9 +1427,9 @@ static irqreturn_t imx_hdmi_hardirq(int irq, void *dev_id)
 	return intr_stat ? IRQ_WAKE_THREAD : IRQ_NONE;
 }
 
-static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
+static irqreturn_t dw_hdmi_irq(int irq, void *dev_id)
 {
-	struct imx_hdmi *hdmi = dev_id;
+	struct dw_hdmi *hdmi = dev_id;
 	u8 intr_stat;
 	u8 phy_int_pol;
 
@@ -1547,14 +1443,14 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 
 			hdmi_modb(hdmi, 0, HDMI_PHY_HPD, HDMI_PHY_POL0);
 
-			imx_hdmi_poweron(hdmi);
+			dw_hdmi_poweron(hdmi);
 		} else {
 			dev_dbg(hdmi->dev, "EVENT=plugout\n");
 
 			hdmi_modb(hdmi, HDMI_PHY_HPD, HDMI_PHY_HPD,
 				  HDMI_PHY_POL0);
 
-			imx_hdmi_poweroff(hdmi);
+			dw_hdmi_poweroff(hdmi);
 		}
 		drm_helper_hpd_irq_event(hdmi->connector.dev);
 	}
@@ -1565,7 +1461,7 @@ static irqreturn_t imx_hdmi_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
+static int dw_hdmi_register(struct drm_device *drm, struct dw_hdmi *hdmi)
 {
 	struct drm_encoder *encoder = hdmi->encoder;
 	struct drm_bridge *bridge;
@@ -1580,7 +1476,7 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 	hdmi->bridge = bridge;
 	bridge->driver_private = hdmi;
 
-	ret = drm_bridge_init(drm, bridge, &imx_hdmi_bridge_funcs);
+	ret = drm_bridge_init(drm, bridge, &dw_hdmi_bridge_funcs);
 	if (ret) {
 		DRM_ERROR("Failed to initialize bridge with drm\n");
 		return -EINVAL;
@@ -1590,8 +1486,8 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 	hdmi->connector.polled = DRM_CONNECTOR_POLL_HPD;
 
 	drm_connector_helper_add(&hdmi->connector,
-				 &imx_hdmi_connector_helper_funcs);
-	drm_connector_init(drm, &hdmi->connector, &imx_hdmi_connector_funcs,
+				 &dw_hdmi_connector_helper_funcs);
+	drm_connector_init(drm, &hdmi->connector, &dw_hdmi_connector_funcs,
 			   DRM_MODE_CONNECTOR_HDMIA);
 
 	hdmi->connector.encoder = encoder;
@@ -1601,16 +1497,16 @@ static int imx_hdmi_register(struct drm_device *drm, struct imx_hdmi *hdmi)
 	return 0;
 }
 
-int _imx_hdmi_bind(struct device *dev, struct device *master,
+int dw_hdmi_bind(struct device *dev, struct device *master,
 		 void *data, struct drm_encoder *encoder,
-		 const struct imx_hdmi_plat_data *plat_data)
+		 const struct dw_hdmi_plat_data *plat_data)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct drm_device *drm = data;
 	struct device_node *np = dev->of_node;
 	struct device_node *ddc_node;
 	struct resource *iores;
-	struct imx_hdmi *hdmi;
+	struct dw_hdmi *hdmi;
 	int ret, irq;
 
 	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
@@ -1641,8 +1537,8 @@ int _imx_hdmi_bind(struct device *dev, struct device *master,
 	if (irq < 0)
 		return irq;
 
-	ret = devm_request_threaded_irq(dev, irq, imx_hdmi_hardirq,
-					imx_hdmi_irq, IRQF_SHARED,
+	ret = devm_request_threaded_irq(dev, irq, dw_hdmi_hardirq,
+					dw_hdmi_irq, IRQF_SHARED,
 					dev_name(dev), hdmi);
 	if (ret)
 		return ret;
@@ -1677,11 +1573,11 @@ int _imx_hdmi_bind(struct device *dev, struct device *master,
 	/* Clear Hotplug interrupts */
 	hdmi_writeb(hdmi, HDMI_IH_PHY_STAT0_HPD, HDMI_IH_PHY_STAT0);
 
-	ret = imx_hdmi_fb_registered(hdmi);
+	ret = dw_hdmi_fb_registered(hdmi);
 	if (ret)
 		return ret;
 
-	ret = imx_hdmi_register(drm, hdmi);
+	ret = dw_hdmi_register(drm, hdmi);
 	if (ret)
 		return ret;
 
@@ -1692,11 +1588,11 @@ int _imx_hdmi_bind(struct device *dev, struct device *master,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(_imx_hdmi_bind);
+EXPORT_SYMBOL_GPL(dw_hdmi_bind);
 
-void _imx_hdmi_unbind(struct device *dev, struct device *master, void *data)
+void dw_hdmi_unbind(struct device *dev, struct device *master, void *data)
 {
-	struct imx_hdmi *hdmi = dev_get_drvdata(dev);
+	struct dw_hdmi *hdmi = dev_get_drvdata(dev);
 
 	/* Disable all interrupts */
 	hdmi_writeb(hdmi, ~0, HDMI_IH_MUTE_PHY_STAT0);
@@ -1706,193 +1602,11 @@ void _imx_hdmi_unbind(struct device *dev, struct device *master, void *data)
 
 	i2c_put_adapter(hdmi->ddc);
 }
-EXPORT_SYMBOL_GPL(_imx_hdmi_unbind);
-
-static int imx_hdmi_parse_dt(struct imx_hdmi_priv *hdmi)
-{
-	struct device_node *np = hdmi->dev->of_node;
-
-	hdmi->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
-	if (IS_ERR(hdmi->regmap)) {
-		dev_err(hdmi->dev, "Unable to get gpr\n");
-		return PTR_ERR(hdmi->regmap);
-	}
-
-	hdmi->isfr_clk = devm_clk_get(hdmi->dev, "isfr");
-	if (IS_ERR(hdmi->isfr_clk)) {
-		dev_err(hdmi->dev, "Unable to get HDMI isfr clk\n");
-		return PTR_ERR(hdmi->isfr_clk);
-	}
-
-	hdmi->iahb_clk = devm_clk_get(hdmi->dev, "iahb");
-	if (IS_ERR(hdmi->iahb_clk)) {
-		dev_err(hdmi->dev, "Unable to get HDMI iahb clk\n");
-		return PTR_ERR(hdmi->iahb_clk);
-	}
-
-	return 0;
-}
-
-static void imx_hdmi_disable(struct drm_encoder *encoder)
-{
-
-}
-
-static bool imx_hdmi_mode_fixup(struct drm_encoder *encoder,
-				const struct drm_display_mode *mode,
-				struct drm_display_mode *adjusted_mode)
-{
-	return true;
-}
-
-static void imx_hdmi_mode_set(struct drm_encoder *encoder,
-			      struct drm_display_mode *mode,
-			      struct drm_display_mode *adjusted_mode)
-{
-
-}
-
-static void imx_hdmi_commit(struct drm_encoder *encoder)
-{
-	struct imx_hdmi_priv *hdmi = container_of(encoder,
-						  struct imx_hdmi_priv,
-						  encoder);
-	int mux = imx_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
-
-	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
-			   IMX6Q_GPR3_HDMI_MUX_CTL_MASK,
-			   mux << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
-}
-
-static void imx_hdmi_prepare(struct drm_encoder *encoder)
-{
-	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
-}
-
-static struct drm_encoder_helper_funcs imx_hdmi_encoder_helper_funcs = {
-	.mode_fixup = imx_hdmi_mode_fixup,
-	.mode_set = imx_hdmi_mode_set,
-	.prepare = imx_hdmi_prepare,
-	.commit = imx_hdmi_commit,
-	.disable = imx_hdmi_disable,
-};
-
-static struct drm_encoder_funcs imx_hdmi_encoder_funcs = {
-	.destroy = drm_encoder_cleanup,
-};
-
-static struct imx_hdmi_plat_data imx6q_hdmi_drv_data = {
-	.mpll_cfg               = imx_mpll_cfg,
-	.cur_ctr                = imx_cur_ctr,
-	.sym_term               = imx_sym_term,
-	.dev_type               = IMX6Q_HDMI,
-};
-
-static struct imx_hdmi_plat_data imx6dl_hdmi_drv_data = {
-	.mpll_cfg               = imx_mpll_cfg,
-	.cur_ctr                = imx_cur_ctr,
-	.sym_term               = imx_sym_term,
-	.dev_type               = IMX6DL_HDMI,
-};
-
-static const struct of_device_id imx_hdmi_dt_ids[] = {
-{ .compatible = "fsl,imx6q-hdmi", .data = &imx6q_hdmi_drv_data},
-{ .compatible = "fsl,imx6dl-hdmi", .data = &imx6dl_hdmi_drv_data, },
-{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, imx_hdmi_dt_ids);
-
-static int imx_hdmi_bind(struct device *dev, struct device *master,
-			 void *data)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct imx_hdmi_plat_data *plat_data;
-	const struct of_device_id *match;
-	struct drm_device *drm = data;
-	struct drm_encoder *encoder;
-	struct imx_hdmi_priv *hdmi;
-	int ret;
-
-	if (!pdev->dev.of_node)
-		return -ENODEV;
-
-	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
-	if (!hdmi)
-		return -ENOMEM;
-
-	match = of_match_node(imx_hdmi_dt_ids, pdev->dev.of_node);
-	plat_data = match->data;
-	hdmi->dev = &pdev->dev;
-	encoder = &hdmi->encoder;
-	platform_set_drvdata(pdev, hdmi);
-
-	ret = imx_hdmi_parse_dt(hdmi);
-	if (ret < 0)
-		return ret;
-	ret = clk_prepare_enable(hdmi->isfr_clk);
-	if (ret) {
-		dev_err(dev, "Cannot enable HDMI isfr clock: %d\n", ret);
-		return ret;
-	}
-
-	ret = clk_prepare_enable(hdmi->iahb_clk);
-	if (ret) {
-		dev_err(dev, "Cannot enable HDMI iahb clock: %d\n", ret);
-		return ret;
-	}
-
-	encoder->possible_crtcs = drm_of_find_possible_crtcs(drm, dev->of_node);
-
-	drm_encoder_helper_add(encoder, &imx_hdmi_encoder_helper_funcs);
-	drm_encoder_init(drm, encoder, &imx_hdmi_encoder_funcs,
-			 DRM_MODE_ENCODER_TMDS);
-
-	return _imx_hdmi_bind(dev, master, data, encoder, plat_data);
-}
-
-static void imx_hdmi_unbind(struct device *dev, struct device *master,
-			    void *data)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-	struct imx_hdmi_priv *hdmi = platform_get_drvdata(pdev);
-
-	clk_disable_unprepare(hdmi->isfr_clk);
-	clk_disable_unprepare(hdmi->iahb_clk);
-
-	return _imx_hdmi_unbind(dev, master, data);
-}
-
-static const struct component_ops imx_hdmi_ops = {
-	.bind   = imx_hdmi_bind,
-	.unbind = imx_hdmi_unbind,
-};
-
-static int imx_hdmi_probe(struct platform_device *pdev)
-{
-	return component_add(&pdev->dev, &imx_hdmi_ops);
-}
-
-static int imx_hdmi_remove(struct platform_device *pdev)
-{
-	component_del(&pdev->dev, &imx_hdmi_ops);
-
-	return 0;
-}
-
-static struct platform_driver imx_hdmi_platform_driver = {
-	.probe  = imx_hdmi_probe,
-	.remove = imx_hdmi_remove,
-	.driver = {
-		.name = "imx-hdmi",
-		.owner = THIS_MODULE,
-		.of_match_table = imx_hdmi_dt_ids,
-	},
-};
-module_platform_driver(imx_hdmi_platform_driver);
+EXPORT_SYMBOL_GPL(dw_hdmi_unbind);
 
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
 MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
 MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
-MODULE_DESCRIPTION("i.MX6 HDMI transmitter driver");
+MODULE_DESCRIPTION("DW HDMI transmitter driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:imx-hdmi");
+MODULE_ALIAS("platform:dw-hdmi");
diff --git a/drivers/staging/imx-drm/imx-hdmi.h b/drivers/gpu/drm/bridge/dw_hdmi.h
similarity index 99%
rename from drivers/staging/imx-drm/imx-hdmi.h
rename to drivers/gpu/drm/bridge/dw_hdmi.h
index 39b6776..04d8ebe 100644
--- a/drivers/staging/imx-drm/imx-hdmi.h
+++ b/drivers/gpu/drm/bridge/dw_hdmi.h
@@ -7,8 +7,8 @@
  * (at your option) any later version.
  */
 
-#ifndef __IMX_HDMI_H__
-#define __IMX_HDMI_H__
+#ifndef __DW_HDMI_H__
+#define __DW_HDMI_H__
 
 /* Identification Registers */
 #define HDMI_DESIGN_ID                          0x0000
diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
index ab31848..560e1d3 100644
--- a/drivers/staging/imx-drm/Kconfig
+++ b/drivers/staging/imx-drm/Kconfig
@@ -50,5 +50,6 @@ config DRM_IMX_IPUV3
 config DRM_IMX_HDMI
 	tristate "Freescale i.MX DRM HDMI"
 	depends on DRM_IMX
+	select DRM_DW_HDMI
 	help
 	  Choose this if you want to use HDMI on i.MX6.
diff --git a/drivers/staging/imx-drm/Makefile b/drivers/staging/imx-drm/Makefile
index 582c438..f3ecd89 100644
--- a/drivers/staging/imx-drm/Makefile
+++ b/drivers/staging/imx-drm/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
 
 imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
 obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
-obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o
+obj-$(CONFIG_DRM_IMX_HDMI) += dw_hdmi-imx.o
diff --git a/drivers/staging/imx-drm/dw_hdmi-imx.c b/drivers/staging/imx-drm/dw_hdmi-imx.c
new file mode 100644
index 0000000..d975d18
--- /dev/null
+++ b/drivers/staging/imx-drm/dw_hdmi-imx.c
@@ -0,0 +1,274 @@
+/* Copyright (C) 2011-2013 Freescale Semiconductor, Inc.
+ *
+ * derived from imx-hdmi.c(renamed to bridge/dw_hdmi.c now)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/component.h>
+#include <linux/mfd/syscon.h>
+#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
+#include <drm/bridge/dw_hdmi.h>
+#include <video/imx-ipu-v3.h>
+#include <linux/regmap.h>
+#include <linux/clk.h>
+#include <drm/drm_of.h>
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_edid.h>
+#include <drm/drm_encoder_slave.h>
+#include <drm/bridge/dw_hdmi.h>
+
+#include "imx-drm.h"
+
+struct imx_hdmi {
+	struct device *dev;
+	struct clk *isfr_clk;
+	struct clk *iahb_clk;
+	struct regmap *regmap;
+	struct drm_encoder encoder;
+};
+
+static const struct mpll_config imx_mpll_cfg[] = {
+	{
+		45250000, {
+			{ 0x01e0, 0x0000 },
+			{ 0x21e1, 0x0000 },
+			{ 0x41e2, 0x0000 }
+		},
+	}, {
+		92500000, {
+			{ 0x0140, 0x0005 },
+			{ 0x2141, 0x0005 },
+			{ 0x4142, 0x0005 },
+	},
+	}, {
+		148500000, {
+			{ 0x00a0, 0x000a },
+			{ 0x20a1, 0x000a },
+			{ 0x40a2, 0x000a },
+		},
+	}, {
+		~0UL, {
+			{ 0x00a0, 0x000a },
+			{ 0x2001, 0x000f },
+			{ 0x4002, 0x000f },
+		},
+	}
+};
+
+static const struct curr_ctrl imx_cur_ctr[] = {
+	/*      pixelclk     bpp8    bpp10   bpp12 */
+	{
+		54000000, { 0x091c, 0x091c, 0x06dc },
+	}, {
+		58400000, { 0x091c, 0x06dc, 0x06dc },
+	}, {
+		72000000, { 0x06dc, 0x06dc, 0x091c },
+	}, {
+		74250000, { 0x06dc, 0x0b5c, 0x091c },
+	}, {
+		118800000, { 0x091c, 0x091c, 0x06dc },
+	}, {
+		216000000, { 0x06dc, 0x0b5c, 0x091c },
+	}
+};
+
+static const struct sym_term imx_sym_term[] = {
+	/*pixelclk   symbol   term*/
+	{ 148500000, 0x800d, 0x0005 },
+	{ ~0UL,      0x0000, 0x0000 }
+};
+
+static int dw_hdmi_imx_parse_dt(struct imx_hdmi *hdmi)
+{
+	struct device_node *np = hdmi->dev->of_node;
+
+	hdmi->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
+	if (IS_ERR(hdmi->regmap)) {
+		dev_err(hdmi->dev, "Unable to get gpr\n");
+		return PTR_ERR(hdmi->regmap);
+	}
+
+	hdmi->isfr_clk = devm_clk_get(hdmi->dev, "isfr");
+	if (IS_ERR(hdmi->isfr_clk)) {
+		dev_err(hdmi->dev, "Unable to get HDMI isfr clk\n");
+		return PTR_ERR(hdmi->isfr_clk);
+	}
+
+	hdmi->iahb_clk = devm_clk_get(hdmi->dev, "iahb");
+	if (IS_ERR(hdmi->iahb_clk)) {
+		dev_err(hdmi->dev, "Unable to get HDMI iahb clk\n");
+		return PTR_ERR(hdmi->iahb_clk);
+	}
+
+	return 0;
+}
+
+static void dw_hdmi_imx_disable(struct drm_encoder *encoder)
+{
+}
+
+static bool dw_hdmi_imx_mode_fixup(struct drm_encoder *encoder,
+				   const struct drm_display_mode *mode,
+				   struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static void dw_hdmi_imx_mode_set(struct drm_encoder *encoder,
+				 struct drm_display_mode *mode,
+				 struct drm_display_mode *adjusted_mode)
+{
+}
+
+static void dw_hdmi_imx_commit(struct drm_encoder *encoder)
+{
+	struct imx_hdmi *hdmi = container_of(encoder, struct imx_hdmi, encoder);
+	int mux = imx_drm_encoder_get_mux_id(hdmi->dev->of_node, encoder);
+
+	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
+			   IMX6Q_GPR3_HDMI_MUX_CTL_MASK,
+			   mux << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
+}
+
+static void dw_hdmi_imx_prepare(struct drm_encoder *encoder)
+{
+	imx_drm_panel_format(encoder, V4L2_PIX_FMT_RGB24);
+}
+
+static struct drm_encoder_helper_funcs imx_hdmi_encoder_helper_funcs = {
+	.mode_fixup = dw_hdmi_imx_mode_fixup,
+	.mode_set = dw_hdmi_imx_mode_set,
+	.prepare = dw_hdmi_imx_prepare,
+	.commit = dw_hdmi_imx_commit,
+	.disable = dw_hdmi_imx_disable,
+};
+
+static struct drm_encoder_funcs imx_hdmi_encoder_funcs = {
+	.destroy = drm_encoder_cleanup,
+};
+
+static struct dw_hdmi_plat_data imx6q_hdmi_drv_data = {
+	.mpll_cfg		= imx_mpll_cfg,
+	.cur_ctr		= imx_cur_ctr,
+	.sym_term		= imx_sym_term,
+	.dev_type		= IMX6Q_HDMI,
+};
+
+static struct dw_hdmi_plat_data imx6dl_hdmi_drv_data = {
+	.mpll_cfg		= imx_mpll_cfg,
+	.cur_ctr		= imx_cur_ctr,
+	.sym_term		= imx_sym_term,
+	.dev_type		= IMX6DL_HDMI,
+};
+
+static const struct of_device_id dw_hdmi_imx_dt_ids[] = {
+	{ .compatible = "fsl,imx6q-hdmi",
+	  .data = &imx6q_hdmi_drv_data
+	}, {
+	  .compatible = "fsl,imx6dl-hdmi",
+	  .data = &imx6dl_hdmi_drv_data
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, dw_hdmi_imx_dt_ids);
+
+static int dw_hdmi_imx_bind(struct device *dev, struct device *master,
+			    void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct dw_hdmi_plat_data *plat_data;
+	const struct of_device_id *match;
+	struct drm_device *drm = data;
+	struct drm_encoder *encoder;
+	struct imx_hdmi *hdmi;
+	int ret;
+
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
+	if (!hdmi)
+		return -ENOMEM;
+
+	match = of_match_node(dw_hdmi_imx_dt_ids, pdev->dev.of_node);
+	plat_data = match->data;
+	hdmi->dev = &pdev->dev;
+	encoder = &hdmi->encoder;
+	platform_set_drvdata(pdev, hdmi);
+
+	ret = dw_hdmi_imx_parse_dt(hdmi);
+	if (ret < 0)
+		return ret;
+
+	ret = clk_prepare_enable(hdmi->isfr_clk);
+	if (ret) {
+		dev_err(dev, "Cannot enable HDMI isfr clock: %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(hdmi->iahb_clk);
+	if (ret) {
+		dev_err(dev, "Cannot enable HDMI iahb clock: %d\n", ret);
+		return ret;
+	}
+
+	encoder->possible_crtcs = drm_of_find_possible_crtcs(drm, dev->of_node);
+
+	drm_encoder_helper_add(encoder, &imx_hdmi_encoder_helper_funcs);
+	drm_encoder_init(drm, encoder, &imx_hdmi_encoder_funcs,
+			 DRM_MODE_ENCODER_TMDS);
+
+	return dw_hdmi_bind(dev, master, data, encoder, plat_data);
+}
+
+static void dw_hdmi_imx_unbind(struct device *dev, struct device *master,
+			       void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct imx_hdmi *hdmi = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(hdmi->isfr_clk);
+	clk_disable_unprepare(hdmi->iahb_clk);
+
+	return dw_hdmi_unbind(dev, master, data);
+}
+
+static const struct component_ops dw_hdmi_imx_ops = {
+	.bind	= dw_hdmi_imx_bind,
+	.unbind	= dw_hdmi_imx_unbind,
+};
+
+static int dw_hdmi_imx_probe(struct platform_device *pdev)
+{
+	return component_add(&pdev->dev, &dw_hdmi_imx_ops);
+}
+
+static int dw_hdmi_imx_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &dw_hdmi_imx_ops);
+
+	return 0;
+}
+
+static struct platform_driver dw_hdmi_imx_platform_driver = {
+	.probe  = dw_hdmi_imx_probe,
+	.remove = dw_hdmi_imx_remove,
+	.driver = {
+		.name = "dwhdmi-imx",
+		.owner = THIS_MODULE,
+		.of_match_table = dw_hdmi_imx_dt_ids,
+	},
+};
+
+module_platform_driver(dw_hdmi_imx_platform_driver);
+
+MODULE_AUTHOR("Andy Yan <andy.yan@rock-chips.com>");
+MODULE_AUTHOR("Yakir Yang <ykk@rock-chips.com>");
+MODULE_DESCRIPTION("IMX6 Specific DW-HDMI Driver Extension");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:dwhdmi-imx");
diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
new file mode 100644
index 0000000..1001470
--- /dev/null
+++ b/include/drm/bridge/dw_hdmi.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright (C) 2011 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __DW_HDMI__
+#define __DW_HDMI__
+
+#include <drm/drmP.h>
+
+enum {
+	RES_8,
+	RES_10,
+	RES_12,
+	RES_MAX,
+};
+
+enum dw_hdmi_devtype {
+	IMX6Q_HDMI,
+	IMX6DL_HDMI,
+};
+
+struct mpll_config {
+	unsigned long mpixelclock;
+	struct {
+		u16 cpce;
+		u16 gmp;
+	} res[RES_MAX];
+};
+
+struct curr_ctrl {
+	unsigned long mpixelclock;
+	u16 curr[RES_MAX];
+};
+
+struct sym_term {
+	unsigned long mpixelclock;
+	u16 sym_ctr;    /*clock symbol and transmitter control*/
+	u16 term;       /*transmission termination value*/
+};
+
+struct dw_hdmi_plat_data {
+	const struct mpll_config *mpll_cfg;
+	const struct curr_ctrl *cur_ctr;
+	const struct sym_term *sym_term;
+	enum dw_hdmi_devtype dev_type;
+};
+
+void dw_hdmi_unbind(struct device *dev, struct device *master, void *data);
+int dw_hdmi_bind(struct device *dev, struct device *master,
+		 void *data, struct drm_encoder *encoder,
+		 const struct dw_hdmi_plat_data *plat_data);
+#endif /* __IMX_HDMI_H__ */
-- 
1.9.1


