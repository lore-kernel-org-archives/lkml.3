Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3JQOOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:14:46 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64911 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3JQOOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:14:44 -0400
From: Marek Belisko <marek@goldelico.com>
To: tomi.valkeinen@ti.com
Cc: plagnioj@jcrosoft.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Marek Belisko <marek@goldelico.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH v2] omapdss: Add new panel driver for Topolly td028ttec1 LCD.
Date: Thu, 17 Oct 2013 16:14:18 +0200
Message-Id: <1382019258-21000-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---

changes from v1:
- reworked to be spi driver instead platform with custom spi bitbang
  this configuration was tested with spi_gpio bitbang driver on gta04 board
  and works fine (thanks Tomi and Lars-Peter for comments)
- address previous comments

 drivers/video/omap2/displays-new/Kconfig           |   6 +
 drivers/video/omap2/displays-new/Makefile          |   1 +
 .../omap2/displays-new/panel-tpo-td028ttec1.c      | 486 +++++++++++++++++++++
 include/video/omap-panel-data.h                    |  13 +
 4 files changed, 506 insertions(+)
 create mode 100644 drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c

diff --git a/drivers/video/omap2/displays-new/Kconfig b/drivers/video/omap2/displays-new/Kconfig
index 6c90885..1054249 100644
--- a/drivers/video/omap2/displays-new/Kconfig
+++ b/drivers/video/omap2/displays-new/Kconfig
@@ -56,6 +56,12 @@ config DISPLAY_PANEL_SHARP_LS037V7DW01
         help
           LCD Panel used in TI's SDP3430 and EVM boards
 
+config DISPLAY_PANEL_TPO_TD028TTEC1
+        tristate "TPO TD028TTEC1 LCD Panel"
+        depends on SPI
+        help
+          LCD panel used in Openmoko.
+
 config DISPLAY_PANEL_TPO_TD043MTEA1
         tristate "TPO TD043MTEA1 LCD Panel"
         depends on SPI
diff --git a/drivers/video/omap2/displays-new/Makefile b/drivers/video/omap2/displays-new/Makefile
index 5aeb11b..0323a8a 100644
--- a/drivers/video/omap2/displays-new/Makefile
+++ b/drivers/video/omap2/displays-new/Makefile
@@ -8,5 +8,6 @@ obj-$(CONFIG_DISPLAY_PANEL_DSI_CM) += panel-dsi-cm.o
 obj-$(CONFIG_DISPLAY_PANEL_SONY_ACX565AKM) += panel-sony-acx565akm.o
 obj-$(CONFIG_DISPLAY_PANEL_LGPHILIPS_LB035Q02) += panel-lgphilips-lb035q02.o
 obj-$(CONFIG_DISPLAY_PANEL_SHARP_LS037V7DW01) += panel-sharp-ls037v7dw01.o
+obj-$(CONFIG_DISPLAY_PANEL_TPO_TD028TTEC1) += panel-tpo-td028ttec1.o
 obj-$(CONFIG_DISPLAY_PANEL_TPO_TD043MTEA1) += panel-tpo-td043mtea1.o
 obj-$(CONFIG_DISPLAY_PANEL_NEC_NL8048HL11) += panel-nec-nl8048hl11.o
diff --git a/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c b/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
new file mode 100644
index 0000000..5a44d30
--- /dev/null
+++ b/drivers/video/omap2/displays-new/panel-tpo-td028ttec1.c
@@ -0,0 +1,486 @@
+/*
+ * Toppoly TD028TTEC1 panel support
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ * Author: Tomi Valkeinen <tomi.valkeinen@nokia.com>
+ *
+ * Neo 1973 code (jbt6k74.c):
+ * Copyright (C) 2006-2007 by OpenMoko, Inc.
+ * Author: Harald Welte <laforge@openmoko.org>
+ *
+ * Ported and adapted from Neo 1973 U-Boot by:
+ * H. Nikolaus Schaller <hns@goldelico.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/spi/spi.h>
+#include <linux/gpio.h>
+#include <video/omapdss.h>
+#include <video/omap-panel-data.h>
+
+struct panel_drv_data {
+	struct omap_dss_device dssdev;
+	struct omap_dss_device *in;
+
+	int data_lines;
+
+	struct omap_video_timings videomode;
+
+	struct spi_device *spi_dev;
+
+	u16 tx_buf[4];
+};
+
+static struct omap_video_timings td028ttec1_panel_timings = {
+	.x_res		= 480,
+	.y_res		= 640,
+	.pixel_clock	= 22153,
+	.hfp		= 24,
+	.hsw		= 8,
+	.hbp		= 8,
+	.vfp		= 4,
+	.vsw		= 2,
+	.vbp		= 2,
+
+	.vsync_level	= OMAPDSS_SIG_ACTIVE_LOW,
+	.hsync_level	= OMAPDSS_SIG_ACTIVE_LOW,
+
+	.data_pclk_edge	= OMAPDSS_DRIVE_SIG_FALLING_EDGE,
+	.de_level	= OMAPDSS_SIG_ACTIVE_HIGH,
+	.sync_pclk_edge	= OMAPDSS_DRIVE_SIG_OPPOSITE_EDGES,
+};
+
+#define JBT_COMMAND	0x000
+#define JBT_DATA	0x100
+
+int jbt_reg_write_nodata(struct panel_drv_data *ddata, u8 reg)
+{
+	int rc;
+
+	ddata->tx_buf[0] = JBT_COMMAND | reg;
+	rc = spi_write(ddata->spi_dev, (u8 *)ddata->tx_buf,
+			1*sizeof(u16));
+	if (rc != 0)
+		dev_err(&ddata->spi_dev->dev,
+			"jbt_reg_write_nodata spi_write ret %d\n", rc);
+
+	return rc;
+}
+
+int jbt_reg_write(struct panel_drv_data *ddata, u8 reg, u8 data)
+{
+	int rc;
+
+	ddata->tx_buf[0] = JBT_COMMAND | reg;
+	ddata->tx_buf[1] = JBT_DATA | data;
+	rc = spi_write(ddata->spi_dev, (u8 *)ddata->tx_buf,
+			2*sizeof(u16));
+	if (rc != 0)
+		dev_err(&ddata->spi_dev->dev,
+			"jbt_reg_write spi_write ret %d\n", rc);
+
+	return rc;
+}
+
+int jbt_reg_write16(struct panel_drv_data *ddata, u8 reg, u16 data)
+{
+	int rc;
+
+	ddata->tx_buf[0] = JBT_COMMAND | reg;
+	ddata->tx_buf[1] = JBT_DATA | (data >> 8);
+	ddata->tx_buf[2] = JBT_DATA | (data & 0xff);
+
+	rc = spi_write(ddata->spi_dev, (u8 *)ddata->tx_buf,
+			3*sizeof(u16));
+
+	if (rc != 0)
+		dev_err(&ddata->spi_dev->dev,
+			"jbt_reg_write16 spi_write ret %d\n", rc);
+
+	return rc;
+}
+
+enum jbt_register {
+	JBT_REG_SLEEP_IN		= 0x10,
+	JBT_REG_SLEEP_OUT		= 0x11,
+
+	JBT_REG_DISPLAY_OFF		= 0x28,
+	JBT_REG_DISPLAY_ON		= 0x29,
+
+	JBT_REG_RGB_FORMAT		= 0x3a,
+	JBT_REG_QUAD_RATE		= 0x3b,
+
+	JBT_REG_POWER_ON_OFF		= 0xb0,
+	JBT_REG_BOOSTER_OP		= 0xb1,
+	JBT_REG_BOOSTER_MODE		= 0xb2,
+	JBT_REG_BOOSTER_FREQ		= 0xb3,
+	JBT_REG_OPAMP_SYSCLK		= 0xb4,
+	JBT_REG_VSC_VOLTAGE		= 0xb5,
+	JBT_REG_VCOM_VOLTAGE		= 0xb6,
+	JBT_REG_EXT_DISPL		= 0xb7,
+	JBT_REG_OUTPUT_CONTROL		= 0xb8,
+	JBT_REG_DCCLK_DCEV		= 0xb9,
+	JBT_REG_DISPLAY_MODE1		= 0xba,
+	JBT_REG_DISPLAY_MODE2		= 0xbb,
+	JBT_REG_DISPLAY_MODE		= 0xbc,
+	JBT_REG_ASW_SLEW		= 0xbd,
+	JBT_REG_DUMMY_DISPLAY		= 0xbe,
+	JBT_REG_DRIVE_SYSTEM		= 0xbf,
+
+	JBT_REG_SLEEP_OUT_FR_A		= 0xc0,
+	JBT_REG_SLEEP_OUT_FR_B		= 0xc1,
+	JBT_REG_SLEEP_OUT_FR_C		= 0xc2,
+	JBT_REG_SLEEP_IN_LCCNT_D	= 0xc3,
+	JBT_REG_SLEEP_IN_LCCNT_E	= 0xc4,
+	JBT_REG_SLEEP_IN_LCCNT_F	= 0xc5,
+	JBT_REG_SLEEP_IN_LCCNT_G	= 0xc6,
+
+	JBT_REG_GAMMA1_FINE_1		= 0xc7,
+	JBT_REG_GAMMA1_FINE_2		= 0xc8,
+	JBT_REG_GAMMA1_INCLINATION	= 0xc9,
+	JBT_REG_GAMMA1_BLUE_OFFSET	= 0xca,
+
+	JBT_REG_BLANK_CONTROL		= 0xcf,
+	JBT_REG_BLANK_TH_TV		= 0xd0,
+	JBT_REG_CKV_ON_OFF		= 0xd1,
+	JBT_REG_CKV_1_2			= 0xd2,
+	JBT_REG_OEV_TIMING		= 0xd3,
+	JBT_REG_ASW_TIMING_1		= 0xd4,
+	JBT_REG_ASW_TIMING_2		= 0xd5,
+
+	JBT_REG_HCLOCK_VGA		= 0xec,
+	JBT_REG_HCLOCK_QVGA		= 0xed,
+};
+
+#define to_panel_data(p) container_of(p, struct panel_drv_data, dssdev)
+
+static int td028ttec1_panel_connect(struct omap_dss_device *dssdev)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+	int r;
+
+	if (omapdss_device_is_connected(dssdev))
+		return 0;
+
+	r = in->ops.dpi->connect(in, dssdev);
+	if (r)
+		return r;
+
+	return 0;
+}
+
+static void td028ttec1_panel_disconnect(struct omap_dss_device *dssdev)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+
+	if (!omapdss_device_is_connected(dssdev))
+		return;
+
+	in->ops.dpi->disconnect(in, dssdev);
+}
+
+static int td028ttec1_panel_enable(struct omap_dss_device *dssdev)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+	int r;
+
+	if (!omapdss_device_is_connected(dssdev))
+		return -ENODEV;
+
+	if (omapdss_device_is_enabled(dssdev))
+		return 0;
+
+	in->ops.dpi->set_data_lines(in, ddata->data_lines);
+	in->ops.dpi->set_timings(in, &ddata->videomode);
+
+	r = in->ops.dpi->enable(in);
+	if (r)
+		return r;
+
+	dev_dbg(dssdev->dev, "td028ttec1_panel_enable() - state %d\n",
+		dssdev->state);
+
+	/*
+	 * according to data sheet: wait 50ms (Tpos of LCM). However, 50ms
+	 * seems unreliable with later LCM batches, increasing to 90ms
+	 */
+	msleep(90);
+
+	/* three times command zero */
+	r |= jbt_reg_write_nodata(ddata, 0x00);
+	msleep(1000);
+	r |= jbt_reg_write_nodata(ddata, 0x00);
+	msleep(1000);
+	r |= jbt_reg_write_nodata(ddata, 0x00);
+	msleep(1000);
+
+	if (r) {
+		dev_warn(dssdev->dev, "transfer error\n");
+		goto transfer_err;
+	}
+
+	/* deep standby out */
+	r |= jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x17);
+
+	/* RGB I/F on, RAM write off, QVGA through, SIGCON enable */
+	r |= jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE, 0x80);
+
+	/* Quad mode off */
+	r |= jbt_reg_write(ddata, JBT_REG_QUAD_RATE, 0x00);
+
+	/* AVDD on, XVDD on */
+	r |= jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x16);
+
+	/* Output control */
+	r |= jbt_reg_write16(ddata, JBT_REG_OUTPUT_CONTROL, 0xfff9);
+
+	/* Sleep mode off */
+	r |= jbt_reg_write_nodata(ddata, JBT_REG_SLEEP_OUT);
+
+	/* at this point we have like 50% grey */
+
+	/* initialize register set */
+	r |= jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE1, 0x01);
+	r |= jbt_reg_write(ddata, JBT_REG_DISPLAY_MODE2, 0x00);
+	r |= jbt_reg_write(ddata, JBT_REG_RGB_FORMAT, 0x60);
+	r |= jbt_reg_write(ddata, JBT_REG_DRIVE_SYSTEM, 0x10);
+	r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_OP, 0x56);
+	r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_MODE, 0x33);
+	r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_FREQ, 0x11);
+	r |= jbt_reg_write(ddata, JBT_REG_BOOSTER_FREQ, 0x11);
+	r |= jbt_reg_write(ddata, JBT_REG_OPAMP_SYSCLK, 0x02);
+	r |= jbt_reg_write(ddata, JBT_REG_VSC_VOLTAGE, 0x2b);
+	r |= jbt_reg_write(ddata, JBT_REG_VCOM_VOLTAGE, 0x40);
+	r |= jbt_reg_write(ddata, JBT_REG_EXT_DISPL, 0x03);
+	r |= jbt_reg_write(ddata, JBT_REG_DCCLK_DCEV, 0x04);
+	/*
+	 * default of 0x02 in JBT_REG_ASW_SLEW responsible for 72Hz requirement
+	 * to avoid red / blue flicker
+	 */
+	r |= jbt_reg_write(ddata, JBT_REG_ASW_SLEW, 0x04);
+	r |= jbt_reg_write(ddata, JBT_REG_DUMMY_DISPLAY, 0x00);
+
+	r |= jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_A, 0x11);
+	r |= jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_B, 0x11);
+	r |= jbt_reg_write(ddata, JBT_REG_SLEEP_OUT_FR_C, 0x11);
+	r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_D, 0x2040);
+	r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_E, 0x60c0);
+	r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_F, 0x1020);
+	r |= jbt_reg_write16(ddata, JBT_REG_SLEEP_IN_LCCNT_G, 0x60c0);
+
+	r |= jbt_reg_write16(ddata, JBT_REG_GAMMA1_FINE_1, 0x5533);
+	r |= jbt_reg_write(ddata, JBT_REG_GAMMA1_FINE_2, 0x00);
+	r |= jbt_reg_write(ddata, JBT_REG_GAMMA1_INCLINATION, 0x00);
+	r |= jbt_reg_write(ddata, JBT_REG_GAMMA1_BLUE_OFFSET, 0x00);
+
+	r |= jbt_reg_write16(ddata, JBT_REG_HCLOCK_VGA, 0x1f0);
+	r |= jbt_reg_write(ddata, JBT_REG_BLANK_CONTROL, 0x02);
+	r |= jbt_reg_write16(ddata, JBT_REG_BLANK_TH_TV, 0x0804);
+
+	r |= jbt_reg_write(ddata, JBT_REG_CKV_ON_OFF, 0x01);
+	r |= jbt_reg_write16(ddata, JBT_REG_CKV_1_2, 0x0000);
+
+	r |= jbt_reg_write16(ddata, JBT_REG_OEV_TIMING, 0x0d0e);
+	r |= jbt_reg_write16(ddata, JBT_REG_ASW_TIMING_1, 0x11a4);
+	r |= jbt_reg_write(ddata, JBT_REG_ASW_TIMING_2, 0x0e);
+
+	r |= jbt_reg_write_nodata(ddata, JBT_REG_DISPLAY_ON);
+
+	dssdev->state = OMAP_DSS_DISPLAY_ACTIVE;
+
+transfer_err:
+
+	return r ? -EIO : 0;
+}
+
+static void td028ttec1_panel_disable(struct omap_dss_device *dssdev)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+
+	if (!omapdss_device_is_enabled(dssdev))
+		return;
+
+	dev_dbg(dssdev->dev, "td028ttec1_panel_disable()\n");
+
+	in->ops.dpi->disable(in);
+
+	jbt_reg_write_nodata(ddata, JBT_REG_DISPLAY_OFF);
+	jbt_reg_write16(ddata, JBT_REG_OUTPUT_CONTROL, 0x8002);
+	jbt_reg_write_nodata(ddata, JBT_REG_SLEEP_IN);
+	jbt_reg_write(ddata, JBT_REG_POWER_ON_OFF, 0x00);
+
+	dssdev->state = OMAP_DSS_DISPLAY_DISABLED;
+}
+
+static void td028ttec1_panel_set_timings(struct omap_dss_device *dssdev,
+		struct omap_video_timings *timings)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+
+	ddata->videomode = *timings;
+	dssdev->panel.timings = *timings;
+
+	in->ops.dpi->set_timings(in, timings);
+}
+
+static void td028ttec1_panel_get_timings(struct omap_dss_device *dssdev,
+		struct omap_video_timings *timings)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+
+	*timings = ddata->videomode;
+}
+
+static int td028ttec1_panel_check_timings(struct omap_dss_device *dssdev,
+		struct omap_video_timings *timings)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+
+	return in->ops.dpi->check_timings(in, timings);
+}
+
+static struct omap_dss_driver td028ttec1_ops = {
+	.connect	= td028ttec1_panel_connect,
+	.disconnect	= td028ttec1_panel_disconnect,
+
+	.enable		= td028ttec1_panel_enable,
+	.disable	= td028ttec1_panel_disable,
+
+	.set_timings	= td028ttec1_panel_set_timings,
+	.get_timings	= td028ttec1_panel_get_timings,
+	.check_timings	= td028ttec1_panel_check_timings,
+};
+
+static int td028ttec1_panel_probe_pdata(struct spi_device *spi)
+{
+	const struct panel_tpo_td028ttec1_platform_data *pdata;
+	struct panel_drv_data *ddata = dev_get_drvdata(&spi->dev);
+	struct omap_dss_device *dssdev, *in;
+
+	pdata = dev_get_platdata(&spi->dev);
+
+	in = omap_dss_find_output(pdata->source);
+	if (in == NULL) {
+		dev_err(&spi->dev, "failed to find video source '%s'\n",
+				pdata->source);
+		return -EPROBE_DEFER;
+	}
+
+	ddata->in = in;
+
+	ddata->data_lines = pdata->data_lines;
+
+	dssdev = &ddata->dssdev;
+	dssdev->name = pdata->name;
+
+	return 0;
+}
+
+static int td028ttec1_panel_probe(struct spi_device *spi)
+{
+	struct panel_drv_data *ddata;
+	struct omap_dss_device *dssdev;
+	int r;
+
+	dev_dbg(&spi->dev, "%s\n", __func__);
+
+	spi->bits_per_word = 9;
+	spi->mode = SPI_MODE_3;
+
+	r = spi_setup(spi);
+	if (r < 0) {
+		dev_err(&spi->dev, "spi_setup failed: %d\n", r);
+		return r;
+	}
+
+	ddata = devm_kzalloc(&spi->dev, sizeof(*ddata), GFP_KERNEL);
+	if (ddata == NULL)
+		return -ENOMEM;
+
+	dev_set_drvdata(&spi->dev, ddata);
+
+	ddata->spi_dev = spi;
+
+	if (dev_get_platdata(&spi->dev)) {
+		r = td028ttec1_panel_probe_pdata(spi);
+		if (r)
+			return r;
+	} else {
+		return -ENODEV;
+	}
+
+	ddata->videomode = td028ttec1_panel_timings;
+
+	dssdev = &ddata->dssdev;
+	dssdev->dev = &spi->dev;
+	dssdev->driver = &td028ttec1_ops;
+	dssdev->type = OMAP_DISPLAY_TYPE_DPI;
+	dssdev->owner = THIS_MODULE;
+	dssdev->panel.timings = ddata->videomode;
+	dssdev->phy.dpi.data_lines = ddata->data_lines;
+
+	r = omapdss_register_display(dssdev);
+	if (r) {
+		dev_err(&spi->dev, "Failed to register panel\n");
+		goto err_reg;
+	}
+
+	return 0;
+
+err_reg:
+	omap_dss_put_device(ddata->in);
+	return r;
+}
+
+static int td028ttec1_panel_remove(struct spi_device *spi)
+{
+	struct panel_drv_data *ddata = dev_get_drvdata(&spi->dev);
+	struct omap_dss_device *dssdev = &ddata->dssdev;
+	struct omap_dss_device *in = ddata->in;
+
+	dev_dbg(&ddata->spi_dev->dev, "%s\n", __func__);
+
+	omapdss_unregister_display(dssdev);
+
+	td028ttec1_panel_disable(dssdev);
+	td028ttec1_panel_disconnect(dssdev);
+
+	omap_dss_put_device(in);
+
+	return 0;
+}
+
+static struct spi_driver td028ttec1_spi_driver = {
+	.probe		= td028ttec1_panel_probe,
+	.remove		= td028ttec1_panel_remove,
+
+	.driver         = {
+		.name   = "panel-tpo-td028ttec1",
+		.owner  = THIS_MODULE,
+	},
+};
+
+module_spi_driver(td028ttec1_spi_driver);
+
+MODULE_AUTHOR("H. Nikolaus Schaller <hns@goldelico.com>");
+MODULE_DESCRIPTION("Toppoly TD028TTEC1 panel driver");
+MODULE_LICENSE("GPL");
diff --git a/include/video/omap-panel-data.h b/include/video/omap-panel-data.h
index f7ac8d9..69279c0 100644
--- a/include/video/omap-panel-data.h
+++ b/include/video/omap-panel-data.h
@@ -238,4 +238,17 @@ struct panel_nec_nl8048hl11_platform_data {
 	int qvga_gpio;
 };
 
+/**
+ * panel-tpo-td028ttec1 platform data
+ * @name: name for display entity
+ * @source: name of the display entity used as a video source
+ * @data_lines: number of DPI datalines
+ */
+struct panel_tpo_td028ttec1_platform_data {
+	const char *name;
+	const char *source;
+
+	int data_lines;
+};
+
 #endif /* __OMAP_PANEL_DATA_H */
-- 
1.8.1.2

