Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab3BGOlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:41:16 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38524 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208Ab3BGOlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:41:11 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: tomi.valkeinen@ti.com, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 1/1] OMAP4: DSS: Add panel for Blaze Tablet boards
Date: Thu,  7 Feb 2013 16:40:50 +0200
Message-Id: <1360248051-16541-2-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360248051-16541-1-git-send-email-ruslan.bilovol@ti.com>
References: <1360248051-16541-1-git-send-email-ruslan.bilovol@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

TC358765 is DSI-to-LVDS transmitter from Toshiba, used in
OMAP44XX Blaze Tablet and Blaze Tablet2 boards.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Sergiy Kibrik <sergiy.kibrik@globallogic.com>
Signed-off-by: Volodymyr Riazantsev <v.riazantsev@ti.com>
Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 drivers/video/omap2/displays/Kconfig          |   15 +
 drivers/video/omap2/displays/Makefile         |    1 +
 drivers/video/omap2/displays/panel-tc358765.c | 1001 +++++++++++++++++++++++++
 drivers/video/omap2/displays/panel-tc358765.h |  170 +++++
 include/video/omap-panel-tc358765.h           |   53 ++
 5 files changed, 1240 insertions(+)
 create mode 100644 drivers/video/omap2/displays/panel-tc358765.c
 create mode 100644 drivers/video/omap2/displays/panel-tc358765.h
 create mode 100644 include/video/omap-panel-tc358765.h

diff --git a/drivers/video/omap2/displays/Kconfig b/drivers/video/omap2/displays/Kconfig
index c3853c9..c6ab261 100644
--- a/drivers/video/omap2/displays/Kconfig
+++ b/drivers/video/omap2/displays/Kconfig
@@ -72,4 +72,19 @@ config PANEL_N8X0
 	depends on BACKLIGHT_CLASS_DEVICE
 	help
 	  This is the LCD panel used on Nokia N8x0
+
+config PANEL_TC358765
+	tristate "Toshiba TC358765 DSI-2-LVDS bridge"
+	depends on OMAP2_DSS_DSI && I2C
+	select BACKLIGHT_CLASS_DEVICE
+	help
+		Toshiba TC358765 DSI-2-LVDS chip with 1024x768 panel,
+		which can be found in OMAP4-based Blaze Tablet boards
+		and some other boards.
+
+config TC358765_DEBUG
+	bool "Toshiba TC358765 DSI-2-LVDS chip debug"
+	depends on PANEL_TC358765 && DEBUG_FS
+	help
+	  Support of TC358765 DSI-2-LVDS chip register access via debugfs
 endmenu
diff --git a/drivers/video/omap2/displays/Makefile b/drivers/video/omap2/displays/Makefile
index 58a5176..b9f2ab6 100644
--- a/drivers/video/omap2/displays/Makefile
+++ b/drivers/video/omap2/displays/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_PANEL_PICODLP) +=  panel-picodlp.o
 obj-$(CONFIG_PANEL_TPO_TD043MTEA1) += panel-tpo-td043mtea1.o
 obj-$(CONFIG_PANEL_ACX565AKM) += panel-acx565akm.o
 obj-$(CONFIG_PANEL_N8X0) += panel-n8x0.o
+obj-$(CONFIG_PANEL_TC358765) += panel-tc358765.o
diff --git a/drivers/video/omap2/displays/panel-tc358765.c b/drivers/video/omap2/displays/panel-tc358765.c
new file mode 100644
index 0000000..e9d7e96
--- /dev/null
+++ b/drivers/video/omap2/displays/panel-tc358765.c
@@ -0,0 +1,1001 @@
+/*
+ * Toshiba TC358765 DSI-to-LVDS chip driver
+ *
+ * Copyright (C) Texas Instruments
+ * Author: Tomi Valkeinen <tomi.valkeinen@ti.com> (3.0)
+ * Author: Sergii Kibrik <sergiikibrik@ti.com> (3.4)
+ * Author: Ruslan Bilovol <ruslan.bilovol@ti.com> (3.8+)
+ *
+ * Based on original version from Jerry Alexander <x0135174@ti.com>
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
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/mutex.h>
+#include <linux/i2c.h>
+#include <linux/pm_runtime.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+
+#include <video/omapdss.h>
+#include <video/omap-panel-tc358765.h>
+
+#include "panel-tc358765.h"
+
+#define A_RO 0x1
+#define A_WO 0x2
+#define A_RW (A_RO|A_WO)
+
+#define FLD_MASK(start, end)	(((1 << ((start) - (end) + 1)) - 1) << (end))
+#define FLD_VAL(val, start, end) (((val) << (end)) & FLD_MASK(start, end))
+#define FLD_GET(val, start, end) (((val) & FLD_MASK(start, end)) >> (end))
+#define FLD_MOD(orig, val, start, end) \
+	(((orig) & ~FLD_MASK(start, end)) | FLD_VAL(val, start, end))
+
+static struct omap_video_timings tc358765_timings;
+static struct tc358765_board_data *get_board_data(struct omap_dss_device
+					*dssdev) __attribute__ ((unused));
+
+/* device private data structure */
+struct tc358765_data {
+	struct mutex lock;
+
+	struct omap_dss_device *dssdev;
+
+	int channel0;
+	int channel1;
+
+	struct omap_dsi_pin_config pin_config;
+};
+
+static struct {
+	struct i2c_client *client;
+	struct mutex xfer_lock;
+} *tc358765_i2c;
+
+
+#ifdef CONFIG_TC358765_DEBUG
+
+struct {
+	struct device *dev;
+	struct dentry *dir;
+} tc358765_debug;
+
+struct tc358765_reg {
+	const char *name;
+	u16 reg;
+	u8 perm:2;
+} tc358765_regs[] = {
+	/* DSI D-PHY Layer Registers */
+	{ "D0W_DPHYCONTTX", D0W_DPHYCONTTX, A_RW },
+	{ "CLW_DPHYCONTRX", CLW_DPHYCONTRX, A_RW },
+	{ "D0W_DPHYCONTRX", D0W_DPHYCONTRX, A_RW },
+	{ "D1W_DPHYCONTRX", D1W_DPHYCONTRX, A_RW },
+	{ "D2W_DPHYCONTRX", D2W_DPHYCONTRX, A_RW },
+	{ "D3W_DPHYCONTRX", D3W_DPHYCONTRX, A_RW },
+	{ "COM_DPHYCONTRX", COM_DPHYCONTRX, A_RW },
+	{ "CLW_CNTRL", CLW_CNTRL, A_RW },
+	{ "D0W_CNTRL", D0W_CNTRL, A_RW },
+	{ "D1W_CNTRL", D1W_CNTRL, A_RW },
+	{ "D2W_CNTRL", D2W_CNTRL, A_RW },
+	{ "D3W_CNTRL", D3W_CNTRL, A_RW },
+	{ "DFTMODE_CNTRL", DFTMODE_CNTRL, A_RW },
+	/* DSI PPI Layer Registers */
+	{ "PPI_STARTPPI", PPI_STARTPPI, A_RW },
+	{ "PPI_BUSYPPI", PPI_BUSYPPI, A_RO },
+	{ "PPI_LINEINITCNT", PPI_LINEINITCNT, A_RW },
+	{ "PPI_LPTXTIMECNT", PPI_LPTXTIMECNT, A_RW },
+	{ "PPI_LANEENABLE", PPI_LANEENABLE, A_RW },
+	{ "PPI_TX_RX_TA", PPI_TX_RX_TA, A_RW },
+	{ "PPI_CLS_ATMR", PPI_CLS_ATMR, A_RW },
+	{ "PPI_D0S_ATMR", PPI_D0S_ATMR, A_RW },
+	{ "PPI_D1S_ATMR", PPI_D1S_ATMR, A_RW },
+	{ "PPI_D2S_ATMR", PPI_D2S_ATMR, A_RW },
+	{ "PPI_D3S_ATMR", PPI_D3S_ATMR, A_RW },
+	{ "PPI_D0S_CLRSIPOCOUNT", PPI_D0S_CLRSIPOCOUNT, A_RW },
+	{ "PPI_D1S_CLRSIPOCOUNT", PPI_D1S_CLRSIPOCOUNT, A_RW },
+	{ "PPI_D2S_CLRSIPOCOUNT", PPI_D2S_CLRSIPOCOUNT, A_RW },
+	{ "PPI_D3S_CLRSIPOCOUNT", PPI_D3S_CLRSIPOCOUNT, A_RW },
+	{ "CLS_PRE", CLS_PRE, A_RW },
+	{ "D0S_PRE", D0S_PRE, A_RW },
+	{ "D1S_PRE", D1S_PRE, A_RW },
+	{ "D2S_PRE", D2S_PRE, A_RW },
+	{ "D3S_PRE", D3S_PRE, A_RW },
+	{ "CLS_PREP", CLS_PREP, A_RW },
+	{ "D0S_PREP", D0S_PREP, A_RW },
+	{ "D1S_PREP", D1S_PREP, A_RW },
+	{ "D2S_PREP", D2S_PREP, A_RW },
+	{ "D3S_PREP", D3S_PREP, A_RW },
+	{ "CLS_ZERO", CLS_ZERO, A_RW },
+	{ "D0S_ZERO", D0S_ZERO, A_RW },
+	{ "D1S_ZERO", D1S_ZERO, A_RW },
+	{ "D2S_ZERO", D2S_ZERO, A_RW  },
+	{ "D3S_ZERO", D3S_ZERO, A_RW },
+	{ "PPI_CLRFLG", PPI_CLRFLG, A_RW },
+	{ "PPI_CLRSIPO", PPI_CLRSIPO, A_RW },
+	{ "PPI_HSTimeout", PPI_HSTimeout, A_RW },
+	{ "PPI_HSTimeoutEnable", PPI_HSTimeoutEnable, A_RW },
+	/* DSI Protocol Layer Registers */
+	{ "DSI_STARTDSI", DSI_STARTDSI, A_WO },
+	{ "DSI_BUSYDSI", DSI_BUSYDSI, A_RO },
+	{ "DSI_LANEENABLE", DSI_LANEENABLE, A_RW },
+	{ "DSI_LANESTATUS0", DSI_LANESTATUS0, A_RO },
+	{ "DSI_LANESTATUS1", DSI_LANESTATUS1, A_RO },
+	{ "DSI_INTSTATUS", DSI_INTSTATUS, A_RO },
+	{ "DSI_INTMASK", DSI_INTMASK, A_RW },
+	{ "DSI_INTCLR", DSI_INTCLR, A_WO },
+	{ "DSI_LPTXTO", DSI_LPTXTO, A_RW },
+	/* DSI General Registers */
+	{ "DSIERRCNT", DSIERRCNT, A_RW },
+	/* DSI Application Layer Registers */
+	{ "APLCTRL", APLCTRL, A_RW },
+	{ "RDPKTLN", RDPKTLN, A_RW },
+	/* Video Path Registers */
+	{ "VPCTRL", VPCTRL, A_RW },
+	{ "HTIM1", HTIM1, A_RW },
+	{ "HTIM2",  HTIM2, A_RW },
+	{ "VTIM1", VTIM1, A_RW },
+	{ "VTIM2", VTIM2, A_RW },
+	{ "VFUEN", VFUEN, A_RW },
+	/* LVDS Registers */
+	{ "LVMX0003", LVMX0003, A_RW },
+	{ "LVMX0407", LVMX0407, A_RW },
+	{ "LVMX0811", LVMX0811, A_RW },
+	{ "LVMX1215", LVMX1215, A_RW },
+	{ "LVMX1619", LVMX1619, A_RW },
+	{ "LVMX2023", LVMX2023, A_RW },
+	{ "LVMX2427", LVMX2427, A_RW },
+	{ "LVCFG", LVCFG, A_RW },
+	{ "LVPHY0", LVPHY0, A_RW },
+	{ "LVPHY1", LVPHY1, A_RW },
+	/* System Registers */
+	{ "SYSSTAT", SYSSTAT, A_RO },
+	{ "SYSRST", SYSRST, A_WO },
+	/* GPIO Registers */
+	{ "GPIOC", GPIOC, A_RW },
+	{ "GPIOO", GPIOO, A_RW },
+	{ "GPIOI", GPIOI, A_RO },
+	/* I2C Registers */
+	{ "I2CTIMCTRL", I2CTIMCTRL, A_RW },
+	{ "I2CMADDR", I2CMADDR, A_RW },
+	{ "WDATAQ", WDATAQ, A_WO },
+	{ "RDATAQ", RDATAQ, A_WO },
+	/* Chip/Rev Registers */
+	{ "IDREG", IDREG, A_RO },
+	/* Debug Registers */
+	{ "DEBUG00", DEBUG00, A_RW },
+	{ "DEBUG01", DEBUG01, A_RW },
+};
+#endif
+
+static int tc358765_read_block(u16 reg, u8 *data, int len)
+{
+	unsigned char wb[2];
+	struct i2c_msg msg[2];
+	int r;
+	mutex_lock(&tc358765_i2c->xfer_lock);
+	wb[0] = (reg & 0xff00) >> 8;
+	wb[1] = reg & 0xff;
+	msg[0].addr = tc358765_i2c->client->addr;
+	msg[0].len = 2;
+	msg[0].flags = 0;
+	msg[0].buf = wb;
+	msg[1].addr = tc358765_i2c->client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = len;
+	msg[1].buf = data;
+
+	r = i2c_transfer(tc358765_i2c->client->adapter, msg, ARRAY_SIZE(msg));
+	mutex_unlock(&tc358765_i2c->xfer_lock);
+
+	if (r == ARRAY_SIZE(msg))
+		return len;
+
+	return r;
+}
+
+static int tc358765_i2c_read(u16 reg, u32 *val)
+{
+	int r;
+	u8 data[4];
+	data[0] = data[1] = data[2] = data[3] = 0;
+
+	r = tc358765_read_block(reg, data, ARRAY_SIZE(data));
+	if (r != ARRAY_SIZE(data))
+		return r;
+
+	*val = ((int)data[3] << 24) | ((int)(data[2]) << 16) |
+	    ((int)(data[1]) << 8) | ((int)(data[0]));
+	return 0;
+}
+
+static int tc358765_dsi_read(struct omap_dss_device *dssdev, u16 reg, u32 *val)
+{
+	struct tc358765_data *d2d = dev_get_drvdata(&dssdev->dev);
+	u8 buf[4];
+	int r;
+
+	r = dsi_vc_generic_read_2(dssdev, d2d->channel1, ((u8 *)&reg)[0],
+				((u8 *)&reg)[1], buf, 4);
+	if (r < 0) {
+		dev_err(&dssdev->dev, "0x%x read failed with status %d\n",
+								reg, r);
+		return r;
+	}
+
+	*val = buf[0] | (buf[1] << 8) | (buf[2] << 16) | (buf[3] << 24);
+	return 0;
+}
+
+static int tc358765_read_register(struct omap_dss_device *dssdev,
+					u16 reg, u32 *val)
+{
+	int ret = 0;
+	pm_runtime_get_sync(&dssdev->dev);
+	/* I2C is preferred way of reading, but fall back to DSI
+	 * if I2C didn't got initialized
+	*/
+	if (tc358765_i2c)
+		ret = tc358765_i2c_read(reg, val);
+	else
+		ret = tc358765_dsi_read(dssdev, reg, val);
+	pm_runtime_put_sync(&dssdev->dev);
+
+	return ret;
+}
+
+static int tc358765_write_register(struct omap_dss_device *dssdev, u16 reg,
+		u32 value)
+{
+	struct tc358765_data *d2d = dev_get_drvdata(&dssdev->dev);
+	u8 buf[6];
+	int r;
+
+	buf[0] = (reg >> 0) & 0xff;
+	buf[1] = (reg >> 8) & 0xff;
+	buf[2] = (value >> 0) & 0xff;
+	buf[3] = (value >> 8) & 0xff;
+	buf[4] = (value >> 16) & 0xff;
+	buf[5] = (value >> 24) & 0xff;
+
+	r = dsi_vc_generic_write_nosync(dssdev, d2d->channel1, buf, 6);
+	if (r)
+		dev_err(&dssdev->dev, "reg write reg(%x) val(%x) failed: %d\n",
+			       reg, value, r);
+	return r;
+}
+
+/****************************
+********* DEBUG *************
+****************************/
+#ifdef CONFIG_TC358765_DEBUG
+static int tc358765_write_register_i2c(u16 reg, u32 val)
+{
+	int ret = -ENODEV;
+	unsigned char buf[6];
+	struct i2c_msg msg;
+
+	if (!tc358765_i2c) {
+		dev_err(tc358765_debug.dev, "%s: I2C not initilized\n",
+							__func__);
+		return ret;
+	}
+
+	buf[0] = (reg >> 8) & 0xff;
+	buf[1] = (reg >> 0) & 0xff;
+	buf[2] = (val >> 0) & 0xff;
+	buf[3] = (val >> 8) & 0xff;
+	buf[4] = (val >> 16) & 0xff;
+	buf[5] = (val >> 24) & 0xff;
+	msg.addr = tc358765_i2c->client->addr;
+	msg.len = sizeof(buf);
+	msg.flags = 0;
+	msg.buf = buf;
+
+	mutex_lock(&tc358765_i2c->xfer_lock);
+	ret = i2c_transfer(tc358765_i2c->client->adapter, &msg, 1);
+	mutex_unlock(&tc358765_i2c->xfer_lock);
+
+	if (ret != 1)
+		return ret;
+	return 0;
+}
+
+
+static int tc358765_registers_show(struct seq_file *seq, void *pos)
+{
+	struct device *dev = tc358765_debug.dev;
+	unsigned i, reg_count;
+	uint value;
+
+	if (!tc358765_i2c) {
+		dev_warn(dev,
+			"failed to read register: I2C not initialized\n");
+		return -ENODEV;
+	}
+
+	reg_count = sizeof(tc358765_regs) / sizeof(tc358765_regs[0]);
+	pm_runtime_get_sync(dev);
+	for (i = 0; i < reg_count; i++) {
+		if (tc358765_regs[i].perm & A_RO) {
+			tc358765_i2c_read(tc358765_regs[i].reg, &value);
+			seq_printf(seq, "%-20s = 0x%02X\n",
+					tc358765_regs[i].name, value);
+		}
+	}
+
+	pm_runtime_put_sync(dev);
+	return 0;
+}
+static ssize_t tc358765_seq_write(struct file *filp, const char __user *ubuf,
+						size_t size, loff_t *ppos)
+{
+	struct device *dev = tc358765_debug.dev;
+	unsigned i, reg_count;
+	u32 value = 0;
+	int error = 0;
+	/* kids, don't use register names that long */
+	char name[30];
+	char buf[50];
+
+	if (size >= sizeof(buf))
+		size = sizeof(buf);
+
+	if (copy_from_user(&buf, ubuf, size))
+		return -EFAULT;
+
+	buf[size-1] = '\0';
+	if (sscanf(buf, "%s %x", name, &value) != 2) {
+		dev_err(dev, "%s: unable to parse input\n", __func__);
+		return -1;
+	}
+
+	if (!tc358765_i2c) {
+		dev_warn(dev,
+			"failed to write register: I2C not initialized\n");
+		return -ENODEV;
+	}
+
+	reg_count = sizeof(tc358765_regs) / sizeof(tc358765_regs[0]);
+	for (i = 0; i < reg_count; i++) {
+		if (!strcmp(name, tc358765_regs[i].name)) {
+			if (!(tc358765_regs[i].perm & A_WO)) {
+				dev_err(dev, "%s is write-protected\n", name);
+				return -EACCES;
+			}
+
+			error = tc358765_write_register_i2c(
+				tc358765_regs[i].reg, value);
+			if (error) {
+				dev_err(dev, "%s: failed to write %s\n",
+					__func__, name);
+				return -1;
+			}
+
+			return size;
+		}
+	}
+
+	dev_err(dev, "%s: no such register %s\n", __func__, name);
+
+	return size;
+}
+
+static ssize_t tc358765_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, tc358765_registers_show, inode->i_private);
+}
+
+static const struct file_operations tc358765_debug_fops = {
+	.open		= tc358765_seq_open,
+	.read		= seq_read,
+	.write		= tc358765_seq_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int tc358765_initialize_debugfs(struct omap_dss_device *dssdev)
+{
+	tc358765_debug.dir = debugfs_create_dir("tc358765", NULL);
+	if (IS_ERR(tc358765_debug.dir)) {
+		int ret = PTR_ERR(tc358765_debug.dir);
+		tc358765_debug.dir = NULL;
+		return ret;
+	}
+
+	tc358765_debug.dev = &dssdev->dev;
+	debugfs_create_file("registers", S_IRWXU, tc358765_debug.dir,
+			dssdev, &tc358765_debug_fops);
+	return 0;
+}
+
+static void tc358765_uninitialize_debugfs(void)
+{
+	if (tc358765_debug.dir)
+		debugfs_remove_recursive(tc358765_debug.dir);
+	tc358765_debug.dir = NULL;
+	tc358765_debug.dev = NULL;
+}
+
+#else
+static int tc358765_initialize_debugfs(struct omap_dss_device *dssdev)
+{
+	return 0;
+}
+
+static void tc358765_uninitialize_debugfs(void)
+{
+}
+#endif
+
+static struct tc358765_board_data *get_board_data(struct omap_dss_device
+								*dssdev)
+{
+	return (struct tc358765_board_data *)dssdev->data;
+}
+
+static void tc358765_get_timings(struct omap_dss_device *dssdev,
+		struct omap_video_timings *timings)
+{
+	*timings = dssdev->panel.timings;
+}
+
+static void tc358765_set_timings(struct omap_dss_device *dssdev,
+		struct omap_video_timings *timings)
+{
+	dev_info(&dssdev->dev, "set_timings() not implemented\n");
+}
+
+static int tc358765_check_timings(struct omap_dss_device *dssdev,
+		struct omap_video_timings *timings)
+{
+	if (unlikely(!timings)) {
+		WARN(true, "%s: timings NULL pointer was passed\n", __func__);
+		return -EINVAL;
+	}
+
+	if (tc358765_timings.x_res != timings->x_res ||
+			tc358765_timings.y_res != timings->y_res ||
+			tc358765_timings.pixel_clock != timings->pixel_clock ||
+			tc358765_timings.hsw != timings->hsw ||
+			tc358765_timings.hfp != timings->hfp ||
+			tc358765_timings.hbp != timings->hbp ||
+			tc358765_timings.vsw != timings->vsw ||
+			tc358765_timings.vfp != timings->vfp ||
+			tc358765_timings.vbp != timings->vbp)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void tc358765_get_resolution(struct omap_dss_device *dssdev,
+		u16 *xres, u16 *yres)
+{
+	*xres = tc358765_timings.x_res;
+	*yres = tc358765_timings.y_res;
+}
+
+static int tc358765_hw_reset(struct omap_dss_device *dssdev)
+{
+
+	if (dssdev == NULL || dssdev->reset_gpio == -1)
+		return 0;
+
+	gpio_set_value(dssdev->reset_gpio, 1);
+	udelay(200);
+	/* reset the panel */
+	gpio_set_value(dssdev->reset_gpio, 0);
+	/* assert reset */
+	udelay(200);
+	gpio_set_value(dssdev->reset_gpio, 1);
+	/* wait after releasing reset */
+	msleep(200);
+
+	return 0;
+}
+
+static void tc358765_probe_pdata(struct tc358765_data *d2d,
+		const struct tc358765_board_data *pdata)
+{
+	d2d->pin_config = pdata->pin_config;
+}
+
+static int tc358765_probe(struct omap_dss_device *dssdev)
+{
+	struct tc358765_data *d2d;
+	int r = 0;
+
+	dev_dbg(&dssdev->dev, "tc358765_probe\n");
+
+	dssdev->panel.dsi_pix_fmt = OMAP_DSS_DSI_FMT_RGB888;
+	tc358765_timings = dssdev->panel.timings;
+
+	d2d = kzalloc(sizeof(*d2d), GFP_KERNEL);
+	if (!d2d) {
+		r = -ENOMEM;
+		goto err;
+	}
+
+	d2d->dssdev = dssdev;
+
+	mutex_init(&d2d->lock);
+
+	dev_set_drvdata(&dssdev->dev, d2d);
+
+	if (dssdev->data) {
+		const struct tc358765_board_data *pdata = dssdev->data;
+
+		tc358765_probe_pdata(d2d, pdata);
+	} else {
+		return -ENODEV;
+	}
+
+	/* channel0 used for video packets */
+	r = omap_dsi_request_vc(dssdev, &d2d->channel0);
+	if (r) {
+		dev_err(&dssdev->dev, "failed to get virtual channel0\n");
+		goto err;
+	}
+
+	r = omap_dsi_set_vc_id(dssdev, d2d->channel0, 0);
+	if (r) {
+		dev_err(&dssdev->dev, "failed to set VC_ID0\n");
+		goto err_ch0;
+	}
+
+	/* channel1 used for registers access in LP mode */
+	r = omap_dsi_request_vc(dssdev, &d2d->channel1);
+	if (r) {
+		dev_err(&dssdev->dev, "failed to get virtual channel1\n");
+		goto err_ch0;
+	}
+
+	r = omap_dsi_set_vc_id(dssdev, d2d->channel1, 0);
+	if (r) {
+		dev_err(&dssdev->dev, "failed to set VC_ID1\n");
+		goto err_ch1;
+	}
+	r = tc358765_initialize_debugfs(dssdev);
+	if (r)
+		dev_warn(&dssdev->dev, "failed to create sysfs files\n");
+
+	dev_dbg(&dssdev->dev, "tc358765_probe done\n");
+	return 0;
+
+err_ch1:
+	omap_dsi_release_vc(dssdev, d2d->channel1);
+err_ch0:
+	omap_dsi_release_vc(dssdev, d2d->channel0);
+err:
+	mutex_destroy(&d2d->lock);
+	kfree(d2d);
+	return r;
+}
+
+static void tc358765_remove(struct omap_dss_device *dssdev)
+{
+	struct tc358765_data *d2d = dev_get_drvdata(&dssdev->dev);
+
+	tc358765_uninitialize_debugfs();
+
+	omap_dsi_release_vc(dssdev, d2d->channel0);
+	omap_dsi_release_vc(dssdev, d2d->channel1);
+	mutex_destroy(&d2d->lock);
+
+	kfree(d2d);
+}
+
+static int tc358765_init_ppi(struct omap_dss_device *dssdev)
+{
+	u32 go_cnt, sure_cnt, val = 0;
+	u8 lanes = 0;
+	int ret = 0;
+	struct tc358765_board_data *board_data = get_board_data(dssdev);
+	const int *pins = board_data->pin_config.pins;
+
+	/*
+	 * This register setting is required only if host wishes to
+	 * perform DSI read transactions
+	 */
+	go_cnt = (board_data->lp_time * 5 - 3) / 4;
+	sure_cnt = DIV_ROUND_UP(board_data->lp_time * 3, 2);
+	val = FLD_MOD(val, go_cnt, 26, 16);
+	val = FLD_MOD(val, sure_cnt, 10, 0);
+	ret |= tc358765_write_register(dssdev, PPI_TX_RX_TA, val);
+
+	/* SYSLPTX Timing Generation Counter */
+	ret |= tc358765_write_register(dssdev, PPI_LPTXTIMECNT,
+					board_data->lp_time);
+
+	/* D*S_CLRSIPOCOUNT = [(THS-SETTLE + THS-ZERO) /
+					HS_byte_clock_period ] */
+
+	if ((pins[0] & 1) || (pins[1] & 1))
+		lanes |= (1 << 0);
+
+	if ((pins[2] & 1) || (pins[3] & 1)) {
+		lanes |= (1 << 1);
+		ret |= tc358765_write_register(dssdev, PPI_D0S_CLRSIPOCOUNT,
+							board_data->clrsipo);
+	}
+	if ((pins[4] & 1) || (pins[5] & 1)) {
+		lanes |= (1 << 2);
+		ret |= tc358765_write_register(dssdev, PPI_D1S_CLRSIPOCOUNT,
+							board_data->clrsipo);
+	}
+	if ((pins[6] & 1) || (pins[7] & 1)) {
+		lanes |= (1 << 3);
+		ret |= tc358765_write_register(dssdev, PPI_D2S_CLRSIPOCOUNT,
+							board_data->clrsipo);
+	}
+	if ((pins[8] & 1) || (pins[9] & 1)) {
+		lanes |= (1 << 4);
+		ret |= tc358765_write_register(dssdev, PPI_D3S_CLRSIPOCOUNT,
+							board_data->clrsipo);
+	}
+
+	ret |= tc358765_write_register(dssdev, PPI_LANEENABLE, lanes);
+	ret |= tc358765_write_register(dssdev, DSI_LANEENABLE, lanes);
+
+	return ret;
+}
+
+static int tc358765_init_video_timings(struct omap_dss_device *dssdev)
+{
+	u32 val;
+	struct tc358765_board_data *board_data = get_board_data(dssdev);
+	int ret;
+	ret = tc358765_read_register(dssdev, VPCTRL, &val);
+	if (ret < 0) {
+		dev_warn(&dssdev->dev,
+			"couldn't access VPCTRL, going on with reset value\n");
+		val = 0;
+	}
+
+	if (dssdev->ctrl.pixel_size == 18) {
+		/* Magic Square FRC available for RGB666 only */
+		val = FLD_MOD(val, board_data->msf, 0, 0);
+		val = FLD_MOD(val, 0, 8, 8);
+	} else {
+		val = FLD_MOD(val, 1, 8, 8);
+	}
+
+	val = FLD_MOD(val, board_data->vtgen, 4, 4);
+	val = FLD_MOD(val, board_data->evtmode, 5, 5);
+	val = FLD_MOD(val, board_data->vsdelay, 31, 20);
+
+	ret = tc358765_write_register(dssdev, VPCTRL, val);
+
+	ret |= tc358765_write_register(dssdev, HTIM1,
+		(tc358765_timings.hbp << 16) | tc358765_timings.hsw);
+	ret |= tc358765_write_register(dssdev, HTIM2,
+		((tc358765_timings.hfp << 16) | tc358765_timings.x_res));
+	ret |= tc358765_write_register(dssdev, VTIM1,
+		((tc358765_timings.vbp << 16) |	tc358765_timings.vsw));
+	ret |= tc358765_write_register(dssdev, VTIM2,
+		((tc358765_timings.vfp << 16) |	tc358765_timings.y_res));
+	return ret;
+}
+
+static int tc358765_write_init_config(struct omap_dss_device *dssdev)
+{
+	struct tc358765_board_data *board_data = get_board_data(dssdev);
+	u32 val;
+	int r;
+
+	/* HACK: dummy read: if we read via DSI, first reads always fail */
+	tc358765_read_register(dssdev, DSI_INTSTATUS, &val);
+
+	r = tc358765_init_ppi(dssdev);
+	if (r) {
+		dev_err(&dssdev->dev, "failed to initialize PPI layer\n");
+		return r;
+	}
+
+	r = tc358765_write_register(dssdev, PPI_STARTPPI, 0x1);
+	if (r) {
+		dev_err(&dssdev->dev, "failed to start PPI-TX\n");
+		return r;
+	}
+
+	r = tc358765_write_register(dssdev, DSI_STARTDSI, 0x1);
+	if (r) {
+		dev_err(&dssdev->dev, "failed to start DSI-RX\n");
+		return r;
+	}
+
+	/* reset LVDS-PHY */
+	tc358765_write_register(dssdev, LVPHY0, (1 << 22));
+	mdelay(2);
+
+	r = tc358765_read_register(dssdev, LVPHY0, &val);
+	if (r < 0) {
+		dev_warn(&dssdev->dev, "couldn't access LVPHY0, going on with reset value\n");
+		val = 0;
+	}
+	val = FLD_MOD(val, 0, LV_RST_E, LV_RST_B);
+	val = FLD_MOD(val, board_data->lv_is, LV_IS_E, LV_IS_B);
+	val = FLD_MOD(val, board_data->lv_nd, LV_ND_E, LV_ND_B);
+	r = tc358765_write_register(dssdev, LVPHY0, val);
+
+	if (r) {
+		dev_err(&dssdev->dev, "failed to initialize LVDS-PHY\n");
+		return r;
+	}
+
+	r = tc358765_init_video_timings(dssdev);
+
+	if (r) {
+		dev_err(&dssdev->dev, "failed to initialize video path layer\n");
+		return r;
+	}
+
+	r = tc358765_read_register(dssdev, LVCFG, &val);
+	if (r < 0) {
+		dev_warn(&dssdev->dev,
+			"couldn't access LVCFG, going on with reset value\n");
+		val = 0;
+	}
+
+	val = FLD_MOD(val, board_data->pclkdiv, 9, 8);
+	val = FLD_MOD(val, board_data->pclksel, 11, 10);
+	val = FLD_MOD(val, board_data->lvdlink, 1, 1);
+	/* enable LVDS transmitter */
+	val = FLD_MOD(val, 1, 0, 0);
+	r = tc358765_write_register(dssdev, LVCFG, val);
+	if (r) {
+		dev_err(&dssdev->dev, "failed to start LVDS transmitter\n");
+		return r;
+	}
+
+	/* Issue a soft reset to LCD Controller for a clean start */
+	r = tc358765_write_register(dssdev, SYSRST, (1 << 2));
+	/* commit video configuration */
+	r |= tc358765_write_register(dssdev, VFUEN, 0x1);
+	if (r)
+		dev_err(&dssdev->dev, "failed to latch video timings\n");
+	return r;
+}
+
+static int tc358765_power_on(struct omap_dss_device *dssdev)
+{
+	struct tc358765_data *d2d = dev_get_drvdata(&dssdev->dev);
+	int r;
+
+	/* At power on the first vsync has not been received yet */
+
+	dev_dbg(&dssdev->dev, "power_on\n");
+
+	if (dssdev->platform_enable)
+		dssdev->platform_enable(dssdev);
+
+	r = omapdss_dsi_configure_pins(dssdev, &d2d->pin_config);
+	if (r) {
+		dev_err(&dssdev->dev, "failed to configure DSI pins\n");
+		goto err_disp_enable;
+	};
+
+	omapdss_dsi_set_size(dssdev, dssdev->panel.timings.x_res,
+					dssdev->panel.timings.y_res);
+	omapdss_dsi_set_pixel_format(dssdev, dssdev->panel.dsi_pix_fmt);
+	omapdss_dsi_set_operation_mode(dssdev, dssdev->panel.dsi_mode);
+	omapdss_dsi_set_timings(dssdev, &dssdev->panel.timings);
+	omapdss_dsi_set_videomode_timings(dssdev,
+					&dssdev->panel.dsi_vm_timings);
+
+	r = omapdss_dsi_set_clocks(dssdev, 187200000, 10000000);
+	if (r) {
+		dev_err(&dssdev->dev, "failed to set HS and LP clocks\n");
+		goto err_disp_enable;
+	}
+
+	r = omapdss_dsi_display_enable(dssdev);
+	if (r) {
+		dev_err(&dssdev->dev, "failed to enable DSI\n");
+		goto err_disp_enable;
+	}
+
+	/* reset tc358765 bridge */
+	tc358765_hw_reset(dssdev);
+
+	/*turn on HS clock to bring up bridge i2c slave */
+	omapdss_dsi_vc_enable_hs(dssdev, d2d->channel0, true);
+
+	/* configure D2L chip DSI-RX configuration registers */
+
+	r = tc358765_write_init_config(dssdev);
+	if (r)
+		goto err_write_init;
+
+	r = dsi_enable_video_output(dssdev, d2d->channel0);
+
+	dev_dbg(&dssdev->dev, "power_on done\n");
+
+	return r;
+
+err_write_init:
+	omapdss_dsi_display_disable(dssdev, false, false);
+err_disp_enable:
+	if (dssdev->platform_disable)
+		dssdev->platform_disable(dssdev);
+
+	return r;
+}
+
+static void tc358765_power_off(struct omap_dss_device *dssdev)
+{
+	struct tc358765_data *d2d = dev_get_drvdata(&dssdev->dev);
+
+	dsi_disable_video_output(dssdev, d2d->channel0);
+	dsi_disable_video_output(dssdev, d2d->channel1);
+
+	omapdss_dsi_display_disable(dssdev, false, false);
+
+	if (dssdev->platform_disable)
+		dssdev->platform_disable(dssdev);
+}
+
+static void tc358765_disable(struct omap_dss_device *dssdev)
+{
+	struct tc358765_data *d2d = dev_get_drvdata(&dssdev->dev);
+
+	dev_dbg(&dssdev->dev, "disable\n");
+
+	if (dssdev->state == OMAP_DSS_DISPLAY_ACTIVE) {
+		mutex_lock(&d2d->lock);
+		dsi_bus_lock(dssdev);
+
+		tc358765_power_off(dssdev);
+
+		dsi_bus_unlock(dssdev);
+		mutex_unlock(&d2d->lock);
+	}
+	dssdev->state = OMAP_DSS_DISPLAY_DISABLED;
+}
+
+static int tc358765_enable(struct omap_dss_device *dssdev)
+{
+	struct tc358765_data *d2d = dev_get_drvdata(&dssdev->dev);
+	int r = 0;
+
+	dev_dbg(&dssdev->dev, "enable\n");
+
+	if (dssdev->state != OMAP_DSS_DISPLAY_DISABLED)
+		return -EINVAL;
+
+	mutex_lock(&d2d->lock);
+	dsi_bus_lock(dssdev);
+
+	r = tc358765_power_on(dssdev);
+
+	dsi_bus_unlock(dssdev);
+
+	if (r) {
+		dev_dbg(&dssdev->dev, "enable failed\n");
+		dssdev->state = OMAP_DSS_DISPLAY_DISABLED;
+	} else {
+		dssdev->state = OMAP_DSS_DISPLAY_ACTIVE;
+	}
+
+	mutex_unlock(&d2d->lock);
+
+	return r;
+}
+
+static struct omap_dss_driver tc358765_driver = {
+	.probe		= tc358765_probe,
+	.remove		= tc358765_remove,
+
+	.enable		= tc358765_enable,
+	.disable	= tc358765_disable,
+
+	.get_resolution	= tc358765_get_resolution,
+	.get_recommended_bpp = omapdss_default_get_recommended_bpp,
+
+	.get_timings	= tc358765_get_timings,
+	.set_timings	= tc358765_set_timings,
+	.check_timings	= tc358765_check_timings,
+
+	.driver         = {
+		.name   = "tc358765",
+		.owner  = THIS_MODULE,
+	},
+};
+
+static int tc358765_i2c_probe(struct i2c_client *client,
+				   const struct i2c_device_id *id)
+{
+	tc358765_i2c = kzalloc(sizeof(*tc358765_i2c), GFP_KERNEL);
+	if (tc358765_i2c == NULL)
+		return -ENOMEM;
+
+	/* store i2c_client pointer on private data structure */
+	tc358765_i2c->client = client;
+
+	/* store private data structure pointer on i2c_client structure */
+	i2c_set_clientdata(client, tc358765_i2c);
+
+	/* init mutex */
+	mutex_init(&tc358765_i2c->xfer_lock);
+	dev_err(&client->dev, "D2L i2c initialized\n");
+
+	return 0;
+}
+
+/* driver remove function */
+static int __exit tc358765_i2c_remove(struct i2c_client *client)
+{
+	/* remove client data */
+	i2c_set_clientdata(client, NULL);
+
+	/* destroy mutex */
+	mutex_destroy(&tc358765_i2c->xfer_lock);
+
+	/* free private data memory */
+	kfree(tc358765_i2c);
+
+	return 0;
+}
+
+static const struct i2c_device_id tc358765_i2c_idtable[] = {
+	{"tc358765_i2c_driver", 0},
+	{},
+};
+
+static struct i2c_driver tc358765_i2c_driver = {
+	.probe = tc358765_i2c_probe,
+	.remove = __exit_p(tc358765_i2c_remove),
+	.id_table = tc358765_i2c_idtable,
+	.driver = {
+		   .name  = "d2l",
+		   .owner = THIS_MODULE,
+	},
+};
+
+
+static int __init tc358765_init(void)
+{
+	int r;
+	tc358765_i2c = NULL;
+	r = i2c_add_driver(&tc358765_i2c_driver);
+	if (r < 0) {
+		printk(KERN_WARNING "d2l i2c driver registration failed\n");
+		return r;
+	}
+
+	omap_dss_register_driver(&tc358765_driver);
+	return 0;
+}
+
+static void __exit tc358765_exit(void)
+{
+	omap_dss_unregister_driver(&tc358765_driver);
+	i2c_del_driver(&tc358765_i2c_driver);
+}
+
+module_init(tc358765_init);
+module_exit(tc358765_exit);
+
+MODULE_AUTHOR("Tomi Valkeinen <tomi.valkeinen@ti.com>");
+MODULE_DESCRIPTION("TC358765 DSI-2-LVDS Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/video/omap2/displays/panel-tc358765.h b/drivers/video/omap2/displays/panel-tc358765.h
new file mode 100644
index 0000000..ffc105d
--- /dev/null
+++ b/drivers/video/omap2/displays/panel-tc358765.h
@@ -0,0 +1,170 @@
+/*
+ * Header for DSI-to-LVDS bridge driver
+ *
+ * Copyright (C) 2012 Texas Instruments Inc
+ * Author: Tomi Valkeinen <tomi.valkeinen@ti.com>
+ * Author: Sergii Kibrik <sergiikibrik@ti.com>
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
+#ifndef __PANEL_TC358765_H__
+#define __PANEL_TC358765_H__
+
+/* DSI D-PHY Layer Registers */
+#define	D0W_DPHYCONTTX		0x0004		/* Data Lane 0 DPHY TX */
+#define	CLW_DPHYCONTRX		0x0020		/* Clock Lane DPHY RX */
+#define	D0W_DPHYCONTRX		0x0024		/* Data Land 0 DPHY Rx */
+#define	D1W_DPHYCONTRX		0x0028		/* Data Lane 1 DPHY Rx */
+#define	D2W_DPHYCONTRX		0x002c		/* Data Lane 2 DPHY Rx */
+#define	D3W_DPHYCONTRX		0x0030		/* Data Lane 3 DPHY Rx */
+#define	COM_DPHYCONTRX		0x0038		/* DPHY Rx Common */
+#define	CLW_CNTRL		0x0040		/* Clock Lane */
+#define	D0W_CNTRL		0x0044		/* Data Lane 0 */
+#define	D1W_CNTRL		0x0048		/* Data Lane 1 */
+#define	D2W_CNTRL		0x004c		/* Data Lane 2 */
+#define	D3W_CNTRL		0x0050		/* Data Lane 3 */
+#define	DFTMODE_CNTRL		0x0054		/* DFT Mode */
+
+/* DSI PPI Layer Registers */
+#define	PPI_STARTPPI		0x0104		/* Start control bit */
+#define	PPI_BUSYPPI		0x0108			/* Busy bit */
+#define	PPI_LINEINITCNT		0x0110		/* Line In initialization */
+#define	PPI_LPTXTIMECNT		0x0114		/* LPTX timing signal */
+#define	PPI_LANEENABLE		0x0134		/* Lane Enable */
+#define	PPI_TX_RX_TA		0x013c		/* BTA timing param */
+#define	PPI_CLS_ATMR		0x0140		/* Analog timer fcn */
+#define	PPI_D0S_ATMR		0x0144		/* Analog timer fcn Lane 0 */
+#define	PPI_D1S_ATMR		0x0148		/* Analog timer fcn Lane 1 */
+#define	PPI_D2S_ATMR		0x014c		/* Analog timer fcn Lane 2 */
+#define	PPI_D3S_ATMR		0x0150		/* Analog timer fcn Lane 3 */
+#define	PPI_D0S_CLRSIPOCOUNT	0x0164		/* Assertion timer Lane 0 */
+#define	PPI_D1S_CLRSIPOCOUNT	0x0168		/* Assertion timer Lane 1 */
+#define	PPI_D2S_CLRSIPOCOUNT	0x016c		/* Assertion timer Lane 1 */
+#define	PPI_D3S_CLRSIPOCOUNT	0x0170		/* Assertion timer Lane 1 */
+#define CLS_PRE			0x0180		/* PHY IO cntr */
+#define D0S_PRE			0x0184		/* PHY IO cntr */
+#define D1S_PRE			0x0188		/* PHY IO cntr */
+#define D2S_PRE			0x018c		/* PHY IO cntr */
+#define D3S_PRE			0x0190		/* PHY IO cntr */
+#define CLS_PREP		0x01a0		/* PHY IO cntr */
+#define D0S_PREP		0x01a4		/* PHY IO cntr */
+#define D1S_PREP		0x01a8		/* PHY IO cntr */
+#define D2S_PREP		0x01ac		/* PHY IO cntr */
+#define D3S_PREP		0x01b0		/* PHY IO cntr */
+#define CLS_ZERO		0x01c0		/* PHY IO cntr */
+#define	D0S_ZERO		0x01c4		/* PHY IO cntr */
+#define	D1S_ZERO		0x01c8		/* PHY IO cntr */
+#define	D2S_ZERO		0x01cc		/* PHY IO cntr */
+#define	D3S_ZERO		0x01d0		/* PHY IO cntr */
+#define PPI_CLRFLG		0x01e0		/* PRE cntrs */
+#define PPI_CLRSIPO		0x01e4		/* Clear SIPO */
+#define PPI_HSTimeout		0x01f0		/* HS RX timeout */
+#define PPI_HSTimeoutEnable	0x01f4		/* Enable HS Rx Timeout */
+
+/* DSI Protocol Layer Registers */
+#define DSI_STARTDSI		0x0204		/* DSI TX start bit */
+#define DSI_BUSYDSI		0x0208		/* DSI busy bit */
+#define DSI_LANEENABLE		0x0210		/* Lane enable */
+#define DSI_LANESTATUS0		0x0214		/* HS Rx mode */
+#define DSI_LANESTATUS1		0x0218		/* ULPS or STOP state */
+#define DSI_INTSTATUS		0x0220		/* Interrupt status */
+#define DSI_INTMASK		0x0224		/* Interrupt mask */
+#define DSI_INTCLR		0x0228		/* Interrupt clear */
+#define DSI_LPTXTO		0x0230		/* LP Tx Cntr */
+
+/* DSI General Registers */
+#define	DSIERRCNT		0x0300		/* DSI Error Count */
+
+/* DSI Application Layer Registers */
+#define APLCTRL			0x0400		/* Application Layer Cntrl */
+#define RDPKTLN			0x0404		/* Packet length */
+
+/* Video Path Registers */
+#define	VPCTRL			0x0450		/* Video Path */
+#define HTIM1			0x0454		/* Horizontal Timing */
+#define HTIM2			0x0458		/* Horizontal Timing */
+#define VTIM1			0x045c		/* Vertical Timing */
+#define VTIM2			0x0460		/* Vertical Timing */
+#define VFUEN			0x0464		/* Video Frame Timing */
+
+
+/* LVDS Registers - LVDS Mux Input */
+#define LVMX0003		0x0480		/* Bit 0 to 3*/
+#define LVMX0407		0x0484		/* Bit 4 to 7 */
+#define LVMX0811		0x0488		/* Bit 8 to 11 */
+#define LVMX1215		0x048c		/* Bit 12 to 15 */
+#define LVMX1619		0x0490		/* Bit 16 to 19 */
+#define LVMX2023		0x0494		/* Bit 20 to 23 */
+#define LVMX2427		0x0498		/* Bit 24 to 27 */
+
+#define LVCFG			0x049c		/* LVDS Config */
+#define	LVPHY0			0x04a0		/* LVDS PHY Reg 0 */
+#define	LVPHY1			0x04a1		/* LVDS PHY Reg 1 */
+
+/* LVDS PHY Register 0 (LVPHY0) entries */
+#define LV_RST_B		22		/* LV PHY reset */
+#define LV_RST_E		22
+#define LV_IS_B			14		/* Charge pump current control */
+#define LV_IS_E			15		/* pin for PLL portion */
+#define LV_ND_B			0		/* Frequency Range Select */
+#define LV_ND_E			4
+
+/* System Registers */
+#define SYSSTAT			0x0500		/* System Status */
+#define SYSRST			0x0504		/* System Reset */
+
+/* GPIO Registers */
+#define GPIOC			0x0520		/* GPIO Control */
+#define GPIOO			0x0520		/* GPIO Output */
+#define GPIOI			0x0520		/* GPIO Input */
+
+/* I2C Registers */
+#define I2CTIMCTRL		0x0540
+#define I2CMADDR		0x0544
+#define WDATAQ			0x0548
+#define RDATAQ			0x054C
+
+/* Chip Revision Registers */
+#define IDREG			0x0580		/* Chip and Revision ID */
+
+/* Debug Register */
+#define DEBUG00			0x05a0		/* Debug */
+#define DEBUG01			0x05a4		/* LVDS Data */
+
+/*DSI DCS commands */
+#define DCS_READ_NUM_ERRORS     0x05
+#define DCS_READ_POWER_MODE     0x0a
+#define DCS_READ_MADCTL         0x0b
+#define DCS_READ_PIXEL_FORMAT   0x0c
+#define DCS_RDDSDR              0x0f
+#define DCS_SLEEP_IN            0x10
+#define DCS_SLEEP_OUT           0x11
+#define DCS_DISPLAY_OFF         0x28
+#define DCS_DISPLAY_ON          0x29
+#define DCS_COLUMN_ADDR         0x2a
+#define DCS_PAGE_ADDR           0x2b
+#define DCS_MEMORY_WRITE        0x2c
+#define DCS_TEAR_OFF            0x34
+#define DCS_TEAR_ON             0x35
+#define DCS_MEM_ACC_CTRL        0x36
+#define DCS_PIXEL_FORMAT        0x3a
+#define DCS_BRIGHTNESS          0x51
+#define DCS_CTRL_DISPLAY        0x53
+#define DCS_WRITE_CABC          0x55
+#define DCS_READ_CABC           0x56
+#define DCS_GET_ID1             0xda
+#define DCS_GET_ID2             0xdb
+#define DCS_GET_ID3             0xdc
+
+#endif
diff --git a/include/video/omap-panel-tc358765.h b/include/video/omap-panel-tc358765.h
new file mode 100644
index 0000000..c58e081
--- /dev/null
+++ b/include/video/omap-panel-tc358765.h
@@ -0,0 +1,53 @@
+/*
+ * Header for DSI-to-LVDS bridge driver
+ *
+ * Copyright (C) 2012 Texas Instruments Inc
+ * Author: Sergii Kibrik <sergiikibrik@ti.com>
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
+#ifndef __VIDEO_TC358765_BOARD_DATA_H__
+#define __VIDEO_TC358765_BOARD_DATA_H__
+
+/**
+ * struct tc358765_board_data - represent DSI-to-LVDS bridge configuration
+ * @lp_time: Timing Generation Counter
+ * @clrsipo: CLRSIPO counter (one value for all lanes)
+ * @lv_is: charge pump control pin
+ * @lv_nd: Feed Back Divider Ratio
+ * @pclkdiv: PCLK Divide Option
+ * @pclksel: PCLK Selection: HSRCK/HbyteHSClkx2/ByteHsClk
+ * @vsdelay: VSYNC Delay
+ * @lvdlink: is single or dual link
+ * @vtgen: drive video timing signals by the on-chip Video Timing Gen module
+ * @msf: enable/disable Magic Square
+ * @evtmode: event/pulse mode of video timing information transmission
+ * @pin_config: DSI pin configuration
+*/
+struct tc358765_board_data {
+	u16	lp_time;
+	u8	clrsipo;
+	u8	lv_is;
+	u8	lv_nd;
+	u8	pclkdiv;
+	u8	pclksel;
+	u16	vsdelay;
+	bool	lvdlink;
+	bool	vtgen;
+	bool	msf;
+	bool	evtmode;
+	struct omap_dsi_pin_config pin_config;
+};
+
+#endif
-- 
1.7.9.5

