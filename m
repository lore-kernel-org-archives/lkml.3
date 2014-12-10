Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaLJItl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:49:41 -0500
Received: from mail-bl2on0137.outbound.protection.outlook.com ([65.55.169.137]:65478
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752378AbaLJItg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:49:36 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <p.zabel@pengutronix.de>,
        <thierry.reding@gmail.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: [PATCH RFC 10/15] drm: panel: Add support for Himax HX8369A MIPI DSI panel
Date: Wed, 10 Dec 2014 16:37:23 +0800
Message-ID: <1418200648-32656-11-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
References: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(6806004)(19580405001)(85426001)(19580395003)(89996001)(46102003)(2351001)(229853001)(107046002)(87936001)(97736003)(106466001)(99396003)(105606002)(84676001)(68736005)(50466002)(48376002)(77096005)(50986999)(76176999)(64706001)(104016003)(575784001)(86362001)(20776003)(47776003)(110136001)(36756003)(120916001)(31966008)(62966003)(92566001)(21056001)(4396001)(77156002)(50226001)(2004002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0632;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0632;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:BY2PR0301MB0632;
X-Forefront-PRVS: 0421BF7135
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0632;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Himax HX8369A MIPI DSI panel.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 .../devicetree/bindings/panel/himax,hx8369a.txt    |  86 +++
 drivers/gpu/drm/panel/Kconfig                      |   6 +
 drivers/gpu/drm/panel/Makefile                     |   1 +
 drivers/gpu/drm/panel/panel-hx8369a.c              | 627 +++++++++++++++++++++
 4 files changed, 720 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/panel/himax,hx8369a.txt
 create mode 100644 drivers/gpu/drm/panel/panel-hx8369a.c

diff --git a/Documentation/devicetree/bindings/panel/himax,hx8369a.txt b/Documentation/devicetree/bindings/panel/himax,hx8369a.txt
new file mode 100644
index 0000000..6fe251e
--- /dev/null
+++ b/Documentation/devicetree/bindings/panel/himax,hx8369a.txt
@@ -0,0 +1,86 @@
+Himax HX8369A WVGA 16.7M color TFT single chip driver with internal GRAM
+
+Himax HX8369A is a WVGA resolution driving controller.
+It is designed to provide a single chip solution that combines a source
+driver and power supply circuits to drive a TFT dot matrix LCD with
+480RGBx864 dots at the maximum.
+
+The HX8369A supports several interface modes, including MPU MIPI DBI Type
+A/B mode, MIPI DPI/DBI Type C mode, MIPI DSI video mode, MIPI DSI command
+mode and MDDI mode. The interface mode is selected by the external hardware
+pins BS[3:0].
+
+Currently, only the MIPI DSI video mode is supported.
+
+Required properties:
+  - compatible: "himax,hx8369a-dsi"
+  - reg: the virtual channel number of a DSI peripheral
+  - reset-gpios: a GPIO spec for the reset pin
+  - data-lanes: the data lane number of a DSI peripheral
+  - display-timings: timings for the connected panel as described by [1]
+  - bs: the interface mode number described by the following table
+        --------------------------
+       | DBI_TYPE_A_8BIT     |  0 |
+       | DBI_TYPE_A_9BIT     |  1 |
+       | DBI_TYPE_A_16BIT    |  2 |
+       | DBI_TYPE_A_18BIT    |  3 |
+       | DBI_TYPE_B_8BIT     |  4 |
+       | DBI_TYPE_B_9BIT     |  5 |
+       | DBI_TYPE_B_16BIT    |  6 |
+       | DBI_TYPE_B_18BIT    |  7 |
+       | DSI_CMD_MODE        |  8 |
+       | DBI_TYPE_B_24BIT    |  9 |
+       | DSI_VIDEO_MODE      | 10 |
+       | MDDI                | 11 |
+       | DPI_DBI_TYPE_C_OPT1 | 12 |
+       | DPI_DBI_TYPE_C_OPT2 | 13 |
+       | DPI_DBI_TYPE_C_OPT3 | 14 |
+        --------------------------
+
+Optional properties:
+  - power-on-delay: delay after turning regulators on [ms]
+  - reset-delay: delay after reset sequence [ms]
+  - vdd1-supply: I/O and interface power supply
+  - vdd2-supply: analog power supply
+  - vdd3-supply: logic power supply
+  - dsi-vcc-supply: DSI and MDDI power supply
+  - vpp-supply: OTP programming voltage
+  - bs0-gpios: a GPIO spec for the pin BS0
+  - bs1-gpios: a GPIO spec for the pin BS1
+  - bs2-gpios: a GPIO spec for the pin BS2
+  - bs3-gpios: a GPIO spec for the pin BS3
+  - panel-width-mm: physical panel width [mm]
+  - panel-height-mm: physical panel height [mm]
+
+[1]: Documentation/devicetree/bindings/video/display-timing.txt
+
+Example:
+	panel@0 {
+		compatible = "himax,hx8369a-dsi";
+		reg = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_mipi_panel>;
+		reset-gpios = <&gpio6 11 GPIO_ACTIVE_LOW>;
+		reset-delay = <120>;
+		bs2-gpios = <&gpio6 14 GPIO_ACTIVE_HIGH>;
+		data-lanes = <2>;
+		panel-width-mm = <45>;
+		panel-height-mm = <76>;
+		bs = <10>;
+		status = "okay";
+
+		display-timings {
+			native-mode = <&timing1>;
+			timing1: truly-tft480800-16-e {
+			clock-frequency = <26400000>;
+			hactive = <480>;
+			vactive = <800>;
+			hfront-porch = <8>;
+			hback-porch = <8>;
+			hsync-len = <8>;
+			vfront-porch = <6>;
+			vback-porch = <6>;
+			vsync-len = <6>;
+		};
+	};
+};
diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 024e98e..f1a5b58 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -40,4 +40,10 @@ config DRM_PANEL_SHARP_LQ101R1SX01
 	  To compile this driver as a module, choose M here: the module
 	  will be called panel-sharp-lq101r1sx01.
 
+config DRM_PANEL_HX8369A
+	tristate "HX8369A panel"
+	depends on OF
+	select DRM_MIPI_DSI
+	select VIDEOMODE_HELPERS
+
 endmenu
diff --git a/drivers/gpu/drm/panel/Makefile b/drivers/gpu/drm/panel/Makefile
index 4b2a043..d6768ca 100644
--- a/drivers/gpu/drm/panel/Makefile
+++ b/drivers/gpu/drm/panel/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_DRM_PANEL_SIMPLE) += panel-simple.o
 obj-$(CONFIG_DRM_PANEL_LD9040) += panel-ld9040.o
 obj-$(CONFIG_DRM_PANEL_S6E8AA0) += panel-s6e8aa0.o
 obj-$(CONFIG_DRM_PANEL_SHARP_LQ101R1SX01) += panel-sharp-lq101r1sx01.o
+obj-$(CONFIG_DRM_PANEL_HX8369A) += panel-hx8369a.o
diff --git a/drivers/gpu/drm/panel/panel-hx8369a.c b/drivers/gpu/drm/panel/panel-hx8369a.c
new file mode 100644
index 0000000..a8cdaea
--- /dev/null
+++ b/drivers/gpu/drm/panel/panel-hx8369a.c
@@ -0,0 +1,627 @@
+/*
+ * Himax HX8369A panel driver.
+ *
+ * Copyright (C) 2011-2014 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This driver is based on Samsung s6e8aa0 panel driver.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm_mipi_dsi.h>
+#include <drm/drm_panel.h>
+
+#include <linux/gpio/consumer.h>
+#include <linux/regulator/consumer.h>
+
+#include <video/mipi_display.h>
+#include <video/of_videomode.h>
+#include <video/videomode.h>
+
+#define SETCLUMN_ADDR	0x2a
+#define SETPAGE_ADDR 	0x2b
+#define SETPIXEL_FMT 	0x3a
+#define WRDISBV	     	0x51
+#define WRCTRLD	     	0x53
+#define WRCABC	     	0x55
+#define SETPOWER     	0xb1
+#define SETDISP	     	0xb2
+#define SETCYC	     	0xb4
+#define SETVCOM	     	0xb6
+#define SETEXTC	     	0xb9
+#define SETMIPI	     	0xba
+#define SETPANEL     	0xcc
+#define SETGIP	     	0xd5
+#define SETGAMMA     	0xe0
+
+enum hx8369a_mpu_interface {
+	HX8369A_DBI_TYPE_A_8BIT,
+	HX8369A_DBI_TYPE_A_9BIT,
+	HX8369A_DBI_TYPE_A_16BIT,
+	HX8369A_DBI_TYPE_A_18BIT,
+	HX8369A_DBI_TYPE_B_8BIT,
+	HX8369A_DBI_TYPE_B_9BIT,
+	HX8369A_DBI_TYPE_B_16BIT,
+	HX8369A_DBI_TYPE_B_18BIT,
+	HX8369A_DSI_CMD_MODE,
+	HX8369A_DBI_TYPE_B_24BIT,
+	HX8369A_DSI_VIDEO_MODE,
+	HX8369A_MDDI,
+	HX8369A_DPI_DBI_TYPE_C_OPT1,
+	HX8369A_DPI_DBI_TYPE_C_OPT2,
+	HX8369A_DPI_DBI_TYPE_C_OPT3
+};
+
+enum hx8369a_resolution {
+	HX8369A_RES_480_864,
+	HX8369A_RES_480_854,
+	HX8369A_RES_480_800,
+	HX8369A_RES_480_640,
+	HX8369A_RES_360_640,
+	HX8369A_RES_480_720,
+	HX8369A_RES_DISABLE
+};
+
+struct hx8369a {
+	struct device *dev;
+	struct drm_panel panel;
+
+	struct regulator_bulk_data supplies[5];
+	struct gpio_desc *reset_gpio;
+	u32 power_on_delay;
+	u32 reset_delay;
+	struct gpio_desc *bs_gpio[4];
+	u32 data_lanes;
+	u32 mpu_interface;
+	struct videomode vm;
+	u32 width_mm;
+	u32 height_mm;
+	u8 res_sel;
+};
+
+static inline struct hx8369a *panel_to_hx8369a(struct drm_panel *panel)
+{
+	return container_of(panel, struct hx8369a, panel);
+}
+
+static bool hx8369a_is_dsi_interface(struct hx8369a *ctx) {
+	if (ctx->mpu_interface == HX8369A_DSI_VIDEO_MODE ||
+	    ctx->mpu_interface == HX8369A_DSI_CMD_MODE)
+		return true;
+
+	return false;
+}
+
+static void hx8369a_dcs_write(struct hx8369a *ctx, const void *data, size_t len)
+{
+	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
+	ssize_t ret;
+
+	ret = mipi_dsi_dcs_write_buffer(dsi, data, len);
+	if (ret < 0)
+		dev_err(ctx->dev, "error %zd writing dcs seq: %*ph\n", ret, len,
+			data);
+}
+
+#define hx8369a_dcs_write_seq(ctx, seq...) \
+({\
+	const u8 d[] = { seq };\
+	BUILD_BUG_ON_MSG(ARRAY_SIZE(d) > 64, "DCS sequence too big for stack");\
+	hx8369a_dcs_write(ctx, d, ARRAY_SIZE(d));\
+})
+
+#define hx8369a_dcs_write_seq_static(ctx, seq...) \
+({\
+	static const u8 d[] = { seq };\
+	hx8369a_dcs_write(ctx, d, ARRAY_SIZE(d));\
+})
+
+static void hx8369a_dsi_set_display_related_register(struct hx8369a *ctx)
+{
+	u8 sec_p = (ctx->res_sel << 4) | 0x03;
+
+	hx8369a_dcs_write_seq(ctx, SETDISP, 0x00, sec_p, 0x03,
+		0x03, 0x70, 0x00, 0xff, 0x00, 0x00, 0x00, 0x00,
+		0x03, 0x03, 0x00, 0x01);
+}
+
+static void hx8369a_dsi_set_display_waveform_cycle(struct hx8369a *ctx)
+{
+	hx8369a_dcs_write_seq_static(ctx, SETCYC, 0x00, 0x1d, 0x5f, 0x0e, 0x06);
+}
+
+static void hx8369a_dsi_set_gip(struct hx8369a *ctx)
+{
+	hx8369a_dcs_write_seq_static(ctx, SETGIP, 0x00, 0x04, 0x03, 0x00, 0x01,
+				0x05, 0x1c, 0x70, 0x01, 0x03, 0x00, 0x00, 0x40,
+				0x06, 0x51, 0x07, 0x00, 0x00, 0x41, 0x06, 0x50,
+				0x07, 0x07, 0x0f, 0x04);
+}
+
+static void hx8369a_dsi_set_power(struct hx8369a *ctx)
+{
+	hx8369a_dcs_write_seq_static(ctx, SETPOWER, 0x01, 0x00, 0x34, 0x06, 0x00,
+				0x0f, 0x0f, 0x2a, 0x32, 0x3f, 0x3f, 0x07, 0x3a,
+				0x01, 0xe6, 0xe6, 0xe6, 0xe6, 0xe6);
+}
+
+static void hx8369a_dsi_set_vcom_voltage(struct hx8369a *ctx)
+{
+	hx8369a_dcs_write_seq_static(ctx, SETVCOM, 0x56, 0x56);
+}
+
+static void hx8369a_dsi_set_panel(struct hx8369a *ctx)
+{
+	hx8369a_dcs_write_seq_static(ctx, SETPANEL, 0x02);
+}
+
+static void hx8369a_dsi_set_gamma_curve(struct hx8369a *ctx)
+{
+	hx8369a_dcs_write_seq_static(ctx, SETGAMMA, 0x00, 0x1d, 0x22, 0x38, 0x3d,
+				0x3f, 0x2e, 0x4a, 0x06, 0x0d, 0x0f, 0x13, 0x15,
+				0x13, 0x16, 0x10, 0x19, 0x00, 0x1d, 0x22, 0x38,
+				0x3d, 0x3f, 0x2e, 0x4a, 0x06, 0x0d, 0x0f, 0x13,
+				0x15, 0x13, 0x16, 0x10, 0x19);
+}
+
+static void hx8369a_dsi_set_mipi(struct hx8369a *ctx)
+{
+	u8 eleventh_p = ctx->data_lanes == 2 ? 0x11 : 0x10;
+
+	hx8369a_dcs_write_seq(ctx, SETMIPI, 0x00, 0xa0, 0xc6, 0x00, 0x0a, 0x00,
+			0x10, 0x30, 0x6f, 0x02, eleventh_p, 0x18, 0x40);
+}
+
+static void hx8369a_dsi_set_interface_pixel_fomat(struct hx8369a *ctx)
+{
+	struct mipi_dsi_device * dsi = to_mipi_dsi_device(ctx->dev);
+	u8 bpp;
+
+	if (dsi->format == MIPI_DSI_FMT_RGB888)
+		bpp = 0x77;
+	else if (dsi->format == MIPI_DSI_FMT_RGB565)
+		bpp = 0x55;
+	else
+		bpp = 0x66;
+
+	hx8369a_dcs_write_seq(ctx, SETPIXEL_FMT, bpp);
+}
+
+static void hx8369a_dsi_set_column_address(struct hx8369a *ctx)
+{
+	u8 ecl = 0;
+
+	switch (ctx->res_sel) {
+	case HX8369A_RES_480_864:
+	case HX8369A_RES_480_854:
+	case HX8369A_RES_480_800:
+	case HX8369A_RES_480_640:
+	case HX8369A_RES_480_720:
+		ecl = 0xdf;
+		break;
+	case HX8369A_RES_360_640:
+		ecl = 0x67;
+		break;
+	}
+
+	hx8369a_dcs_write_seq(ctx, SETCLUMN_ADDR, 0x00, 0x00, 0x01, ecl);
+}
+
+static void hx8369a_dsi_set_page_address(struct hx8369a *ctx)
+{
+	u8 epl = 0, eph = 0;
+
+	switch (ctx->res_sel) {
+	case HX8369A_RES_480_864:
+		epl = 0x5f;
+		eph = 0x03;
+		break;
+	case HX8369A_RES_480_854:
+		epl = 0x55;
+		eph = 0x03;
+		break;
+	case HX8369A_RES_480_800:
+		epl = 0x1f;
+		eph = 0x03;
+		break;
+	case HX8369A_RES_480_640:
+	case HX8369A_RES_360_640:
+		epl = 0x7f;
+		eph = 0x02;
+		break;
+	case HX8369A_RES_480_720:
+		epl = 0xcf;
+		eph = 0x02;
+		break;
+	}
+
+	hx8369a_dcs_write_seq(ctx, SETPAGE_ADDR, 0x00, 0x00, eph, epl);
+}
+
+static void hx8369a_dsi_write_display_brightness(struct hx8369a *ctx)
+{
+	hx8369a_dcs_write_seq_static(ctx, WRDISBV, 0xff);
+}
+
+static void hx8369a_dsi_write_cabc(struct hx8369a *ctx)
+{
+	hx8369a_dcs_write_seq_static(ctx, WRCABC, 0x01);
+}
+
+static void hx8369a_dsi_write_control_display(struct hx8369a *ctx)
+{
+	hx8369a_dcs_write_seq_static(ctx, WRCTRLD, 0x24);
+}
+
+static void hx8369a_dsi_panel_init(struct hx8369a *ctx)
+{
+	hx8369a_dsi_set_display_related_register(ctx);
+	hx8369a_dsi_set_display_waveform_cycle(ctx);
+	hx8369a_dsi_set_gip(ctx);
+	hx8369a_dsi_set_power(ctx);
+	hx8369a_dsi_set_vcom_voltage(ctx);
+	hx8369a_dsi_set_panel(ctx);
+	hx8369a_dsi_set_gamma_curve(ctx);
+	hx8369a_dsi_set_mipi(ctx);
+	hx8369a_dsi_set_interface_pixel_fomat(ctx);
+	hx8369a_dsi_set_column_address(ctx);
+	hx8369a_dsi_set_page_address(ctx);
+	hx8369a_dsi_write_display_brightness(ctx);
+	hx8369a_dsi_write_cabc(ctx);
+	hx8369a_dsi_write_control_display(ctx);
+}
+
+static void hx8369a_dsi_set_extension_command(struct hx8369a *ctx)
+{
+	hx8369a_dcs_write_seq_static(ctx, SETEXTC, 0xff, 0x83, 0x69);
+}
+
+static void hx8369a_dsi_set_maximum_return_packet_size(struct hx8369a *ctx,
+						       u16 size)
+{
+	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
+	int ret;
+
+	ret = mipi_dsi_set_maximum_return_packet_size(dsi, size);
+	if (ret < 0)
+		dev_err(ctx->dev,
+			"error %d setting maximum return packet size to %d\n",
+			ret, size);
+}
+
+static int hx8369a_dsi_set_sequence(struct hx8369a *ctx)
+{
+	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
+	int ret;
+
+	hx8369a_dsi_set_extension_command(ctx);
+	hx8369a_dsi_set_maximum_return_packet_size(ctx, 4);
+	hx8369a_dsi_panel_init(ctx);
+
+	ret = mipi_dsi_dcs_exit_sleep_mode(dsi);
+	if (ret < 0) {
+		dev_err(ctx->dev, "failed to exit sleep mode: %d\n", ret);
+		return ret;
+	}
+
+	ret = mipi_dsi_dcs_set_display_on(dsi);
+	if (ret < 0) {
+		dev_err(ctx->dev, "failed to set display on: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int hx8369a_power_on(struct hx8369a *ctx)
+{
+	int ret;
+
+	ret = regulator_bulk_enable(ARRAY_SIZE(ctx->supplies), ctx->supplies);
+	if (ret < 0)
+		return ret;
+
+	msleep(ctx->power_on_delay);
+
+	gpiod_set_value(ctx->reset_gpio, 1);
+	usleep_range(50, 60);
+	gpiod_set_value(ctx->reset_gpio, 0);
+
+	msleep(ctx->reset_delay);
+
+	return 0;
+}
+
+static int hx8369a_power_off(struct hx8369a *ctx)
+{
+	return regulator_bulk_disable(ARRAY_SIZE(ctx->supplies), ctx->supplies);;
+}
+
+static int hx8369a_dsi_disable(struct drm_panel *panel)
+{
+	return 0;
+}
+
+static int hx8369a_dsi_unprepare(struct drm_panel *panel)
+{
+	struct hx8369a *ctx = panel_to_hx8369a(panel);
+	struct mipi_dsi_device *dsi = to_mipi_dsi_device(ctx->dev);
+	int ret;
+
+	ret = mipi_dsi_dcs_enter_sleep_mode(dsi);
+	if (ret < 0) {
+		dev_err(ctx->dev, "failed to enter sleep mode: %d\n", ret);
+		return ret;
+	}
+
+	ret = mipi_dsi_dcs_set_display_off(dsi);
+	if (ret < 0) {
+		dev_err(ctx->dev, "failed to set display off: %d\n", ret);
+		return ret;
+	}
+
+	msleep(40);
+
+	return hx8369a_power_off(ctx);
+}
+
+static int hx8369a_dsi_prepare(struct drm_panel *panel)
+{
+	struct hx8369a *ctx = panel_to_hx8369a(panel);
+	int ret;
+
+	ret = hx8369a_power_on(ctx);
+	if (ret < 0)
+		return ret;
+
+	ret = hx8369a_dsi_set_sequence(ctx);
+
+	return ret;
+}
+
+static int hx8369a_dsi_enable(struct drm_panel *panel)
+{
+	return 0;
+}
+
+static int hx8369a_get_modes(struct drm_panel *panel)
+{
+	struct drm_connector *connector = panel->connector;
+	struct hx8369a *ctx = panel_to_hx8369a(panel);
+	struct drm_display_mode *mode;
+
+	mode = drm_mode_create(connector->dev);
+	if (!mode) {
+		DRM_ERROR("failed to create a new display mode\n");
+		return 0;
+	}
+
+	drm_display_mode_from_videomode(&ctx->vm, mode);
+	mode->width_mm = ctx->width_mm;
+	mode->height_mm = ctx->height_mm;
+	connector->display_info.width_mm = mode->width_mm;
+	connector->display_info.height_mm = mode->height_mm;
+
+	mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
+	drm_mode_probed_add(connector, mode);
+
+	return 1;
+}
+
+static const struct drm_panel_funcs hx8369a_dsi_drm_funcs = {
+	.disable = hx8369a_dsi_disable,
+	.unprepare = hx8369a_dsi_unprepare,
+	.prepare = hx8369a_dsi_prepare,
+	.enable = hx8369a_dsi_enable,
+	.get_modes = hx8369a_get_modes,
+};
+
+static int hx8369a_parse_dt(struct hx8369a *ctx)
+{
+	struct device *dev = ctx->dev;
+	struct device_node *np = dev->of_node;
+	int ret;
+
+	ret = of_get_videomode(np, &ctx->vm, 0);
+	if (ret < 0)
+		return ret;
+
+	of_property_read_u32(np, "bs", &ctx->mpu_interface);
+	if (ctx->mpu_interface != HX8369A_DSI_VIDEO_MODE &&
+	    ctx->mpu_interface != HX8369A_DSI_CMD_MODE) {
+		dev_err(dev, "unsupported MPU interface 0x%01x\n",
+			ctx->mpu_interface);
+		return -EINVAL;
+	}
+
+	if (hx8369a_is_dsi_interface(ctx)) {
+		ret = of_property_read_u32(np, "data-lanes", &ctx->data_lanes);
+		if (ret || ctx->data_lanes == 0 || ctx->data_lanes > 2) {
+			dev_err(dev, "cannot get correct data lanes\n");
+			return -EINVAL;
+		}
+	}
+
+	of_property_read_u32(np, "power-on-delay", &ctx->power_on_delay);
+	of_property_read_u32(np, "reset-delay", &ctx->reset_delay);
+	of_property_read_u32(np, "panel-width-mm", &ctx->width_mm);
+	of_property_read_u32(np, "panel-height-mm", &ctx->height_mm);
+
+	return 0;
+}
+
+static int hx8369a_vm_to_res_sel(struct hx8369a *ctx)
+{
+	switch (ctx->vm.hactive) {
+	case 480:
+		switch (ctx->vm.vactive) {
+		case 864:
+			ctx->res_sel = HX8369A_RES_480_864;
+			break;
+		case 854:
+			ctx->res_sel = HX8369A_RES_480_854;
+			break;
+		case 800:
+			ctx->res_sel = HX8369A_RES_480_800;
+			break;
+		case 640:
+			ctx->res_sel = HX8369A_RES_480_640;
+			break;
+		case 720:
+			ctx->res_sel = HX8369A_RES_480_720;
+			break;
+		default:
+			ctx->res_sel = HX8369A_RES_DISABLE;
+			break;
+		}
+		break;
+	case 360:
+		if (ctx->vm.vactive == 640)
+			ctx->res_sel = HX8369A_RES_360_640;
+		else
+			ctx->res_sel = HX8369A_RES_DISABLE;
+		break;
+	default:
+		ctx->res_sel = HX8369A_RES_DISABLE;
+		break;
+	}
+
+	if (ctx->res_sel == HX8369A_RES_DISABLE) {
+		dev_err(ctx->dev, "unsupported resolution %dx%d\n",
+			ctx->vm.hactive, ctx->vm.vactive);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int hx8369a_dsi_probe(struct mipi_dsi_device *dsi)
+{
+	struct device *dev = &dsi->dev;
+	struct hx8369a *ctx;
+	int ret, i;
+	char bs[4];
+
+	ctx = devm_kzalloc(dev, sizeof(struct hx8369a), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	ctx->dev = dev;
+
+	ret = hx8369a_parse_dt(ctx);
+	if (ret < 0)
+		return ret;
+
+	ret = hx8369a_vm_to_res_sel(ctx);
+	if (ret < 0)
+		return ret;
+
+	ctx->supplies[0].supply = "vdd1";
+	ctx->supplies[1].supply = "vdd2";
+	ctx->supplies[2].supply = "vdd3";
+	ctx->supplies[3].supply = "dsi-vcc";
+	ctx->supplies[4].supply = "vpp";
+	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(ctx->supplies),
+				      ctx->supplies);
+	if (ret < 0) {
+		dev_err(dev, "failed to get regulators: %d\n", ret);
+		return ret;
+	}
+
+	ctx->reset_gpio = devm_gpiod_get(dev, "reset");
+	if (IS_ERR(ctx->reset_gpio)) {
+		dev_err(dev, "cannot get reset-gpios %ld\n",
+			PTR_ERR(ctx->reset_gpio));
+		return PTR_ERR(ctx->reset_gpio);
+	}
+	ret = gpiod_direction_output(ctx->reset_gpio, 0);
+	if (ret < 0) {
+		dev_err(dev, "cannot configure reset-gpios %d\n", ret);
+		return ret;
+	}
+
+	for (i = 0; i < 4; i++) {
+		snprintf(bs, sizeof(bs), "bs%d", i);
+		ctx->bs_gpio[i] = devm_gpiod_get(dev, bs);
+		if (IS_ERR(ctx->bs_gpio[i]))
+			continue;
+
+		ret = gpiod_direction_output(ctx->bs_gpio[i], 1);
+		if (ret < 0) {
+			dev_err(dev, "cannot configure bs%d-gpio %d\n", i, ret);
+			return ret;
+		}
+		dev_dbg(dev, "bs%d-gpio is configured\n", i);
+	}
+
+	drm_panel_init(&ctx->panel);
+	ctx->panel.dev = dev;
+	ctx->panel.funcs = &hx8369a_dsi_drm_funcs;
+
+	ret = drm_panel_add(&ctx->panel);
+	if (ret < 0)
+		return ret;
+
+	mipi_dsi_set_drvdata(dsi, ctx);
+
+	dsi->channel = 0;
+	dsi->lanes = ctx->data_lanes;
+	dsi->format = MIPI_DSI_FMT_RGB888;
+	dsi->mode_flags = MIPI_DSI_MODE_VIDEO |
+			  MIPI_DSI_MODE_VIDEO_BURST |
+			  MIPI_DSI_MODE_VIDEO_SYNC_PULSE;
+	ret = mipi_dsi_attach(dsi);
+	if (ret < 0)
+		drm_panel_remove(&ctx->panel);
+
+	return ret;
+}
+
+static int hx8369a_dsi_remove(struct mipi_dsi_device *dsi)
+{
+	struct hx8369a *ctx = mipi_dsi_get_drvdata(dsi);
+
+	mipi_dsi_detach(dsi);
+	drm_panel_remove(&ctx->panel);
+
+	return 0;
+}
+
+static const struct of_device_id hx8369a_dsi_of_match[] = {
+	{ .compatible = "himax,hx8369a-dsi" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, hx8369a_dsi_of_match);
+
+static struct mipi_dsi_driver hx8369a_dsi_driver = {
+	.probe = hx8369a_dsi_probe,
+	.remove = hx8369a_dsi_remove,
+	.driver = {
+		.name = "panel-hx8369a-dsi",
+		.of_match_table = hx8369a_dsi_of_match,
+	},
+};
+
+static int __init hx8369a_init(void)
+{
+	int err;
+
+	err = mipi_dsi_driver_register(&hx8369a_dsi_driver);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+module_init(hx8369a_init);
+
+static void __exit hx8369a_exit(void)
+{
+	mipi_dsi_driver_unregister(&hx8369a_dsi_driver);
+}
+module_exit(hx8369a_exit);
+
+MODULE_DESCRIPTION("Himax HX8369A panel driver");
+MODULE_LICENSE("GPL v2");
-- 
2.1.0

