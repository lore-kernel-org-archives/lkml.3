Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784AbaIEGOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:14:45 -0400
Received: from mail-by2on0141.outbound.protection.outlook.com ([207.46.100.141]:21697
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750736AbaIEGOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:14:42 -0400
X-Greylist: delayed 2072 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 02:14:42 EDT
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <plagnioj@jcrosoft.com>, <tomi.valkeinen@ti.com>,
        <grant.likely@linaro.org>, <arnd@arndb.de>, <peter.griffin@linaro.org>,
        <jg1.han@samsung.com>, <daniel.vetter@ffwll.ch>,
        <laurent.pinchart@ideasonboard.com>, <robdclark@gmail.com>,
        <linux-fbdev@vger.kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] fbdev: fsl-sii902x: HDMI support for Freescale SoCs
Date: Fri, 5 Sep 2014 12:48:37 +0800
Message-ID: <1409892517-29816-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019016)(6009001)(6029001)(199003)(189002)(89996001)(77982001)(92566001)(93916002)(575784001)(86362001)(79102001)(62966002)(83072002)(6806004)(2201001)(4396001)(92726001)(50226001)(85852003)(106466001)(19580395003)(88136002)(76482001)(87936001)(21056001)(90102001)(50466002)(31966008)(85306004)(77156001)(74502001)(50986999)(95666004)(46102001)(81542001)(105606002)(104166001)(26826002)(64706001)(47776003)(81342001)(229853001)(48376002)(107046002)(83322001)(97736001)(84676001)(36756003)(19580405001)(44976005)(99396002)(74662001)(80022001)(87286001)(68736004)(104016003)(102836001)(20776003)(1121002)(921003)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0622;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0325F6C77B
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Freescale SoCs, there has an DVI/HDMI controller and a PHY,
attached to one of their display controller unit's LCDC interfaces.
This patch adds a preliminary static support for such controllers.

This will support for many modes and a dynamic switching between
them.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 .../devicetree/bindings/video/fsl-sii902x.txt      |  17 +
 drivers/video/fbdev/Kconfig                        |   7 +
 drivers/video/fbdev/Makefile                       |   1 +
 drivers/video/fbdev/fsl-sii902x.c                  | 526 +++++++++++++++++++++
 4 files changed, 551 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/fsl-sii902x.txt
 create mode 100644 drivers/video/fbdev/fsl-sii902x.c

diff --git a/Documentation/devicetree/bindings/video/fsl-sii902x.txt b/Documentation/devicetree/bindings/video/fsl-sii902x.txt
new file mode 100644
index 0000000..55c63ad6
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/fsl-sii902x.txt
@@ -0,0 +1,17 @@
+Device-Tree binding for SII902X HDMI driver
+
+Required properties:
+- compatible:		Must contain "fsl,sii902x".
+- reg:			I2C address of the SII902X HDMI device.
+- interrupts:		One interrupt of the fb dev.
+
+Example:
+&i2c1 {
+        status = "okay";
+
+        hdmi: sii9022a@39 {
+              compatible = "fsl,sii902x";
+              reg = <0x39>;
+              interrupts = <GIC_SPI 167 IRQ_TYPE_EDGE_RISING>;
+        };
+};
diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index ccbe2ae..946eb5c 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -1976,6 +1976,13 @@ config FB_FSL_DIU
 	---help---
 	  Framebuffer driver for the Freescale SoC DIU
 
+config FB_FSL_SII902X
+        tristate "Si Image SII902X DVI/HDMI Interface Chip"
+	depends on FB && FSL_SOC
+	select FB_MODE_HELPERS
+	---help---
+	  Driver for the Freescale SoC's DVI/HDMI controller.
+
 config FB_W100
 	tristate "W100 frame buffer support"
 	depends on FB && ARCH_PXA
diff --git a/drivers/video/fbdev/Makefile b/drivers/video/fbdev/Makefile
index 1979aff..9aeb441 100644
--- a/drivers/video/fbdev/Makefile
+++ b/drivers/video/fbdev/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_FB_IMX)              += imxfb.o
 obj-$(CONFIG_FB_S3C)		  += s3c-fb.o
 obj-$(CONFIG_FB_S3C2410)	  += s3c2410fb.o
 obj-$(CONFIG_FB_FSL_DIU)	  += fsl-diu-fb.o
+obj-$(CONFIG_FB_FSL_SII902X)      += fsl-sii902x.o
 obj-$(CONFIG_FB_COBALT)           += cobalt_lcdfb.o
 obj-$(CONFIG_FB_IBM_GXT4500)	  += gxt4500.o
 obj-$(CONFIG_FB_PS3)		  += ps3fb.o
diff --git a/drivers/video/fbdev/fsl-sii902x.c b/drivers/video/fbdev/fsl-sii902x.c
new file mode 100644
index 0000000..e0fb3dd
--- /dev/null
+++ b/drivers/video/fbdev/fsl-sii902x.c
@@ -0,0 +1,526 @@
+/*
+ * Copyright (C) 2010-2014 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/console.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/fb.h>
+#include <linux/fsl_devices.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include "edid.h"
+
+static bool g_enable_hdmi;
+
+struct sii902x_data {
+	struct i2c_client *client;
+	struct delayed_work det_work;
+	struct fb_info *fbi;
+	struct regmap *regmap;
+	unsigned int irq;
+	u8 cable_plugin;
+} *sii902x;
+
+static struct i2c_client *sii902x_to_i2c(struct sii902x_data *sii902x)
+{
+	return sii902x->client;
+}
+
+static s32 sii902x_write(const struct i2c_client *client,
+			u8 command, u8 value)
+{
+	return i2c_smbus_write_byte_data(client, command, value);
+}
+
+static s32 sii902x_read(const struct i2c_client *client, u8 command)
+{
+	int val;
+
+	val = i2c_smbus_read_word_data(client, command);
+
+	return val & 0xff;
+}
+
+static ssize_t sii902x_show_name(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	strcpy(buf, sii902x->fbi->fix.id);
+	sprintf(buf+strlen(buf), "\n");
+
+	return strlen(buf);
+}
+
+static DEVICE_ATTR(fb_name, S_IRUGO, sii902x_show_name, NULL);
+
+static ssize_t sii902x_show_state(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	if (sii902x->cable_plugin == 0)
+		strcpy(buf, "plugout\n");
+	else
+		strcpy(buf, "plugin\n");
+
+	return strlen(buf);
+}
+
+static DEVICE_ATTR(cable_state, S_IRUGO, sii902x_show_state, NULL);
+
+static void sii902x_power_up_tx(struct sii902x_data *sii902x)
+{
+	struct i2c_client *client = sii902x_to_i2c(sii902x);
+	int val;
+
+	val = sii902x_read(client, 0x1E);
+	val &= ~0x3;
+	sii902x_write(client, 0x1E, val);
+}
+
+static void sii902x_setup(struct fb_info *fbi)
+{
+	u16 data[4];
+	u32 refresh;
+	u8 *tmp;
+	int i;
+
+	/* Power up */
+	sii902x_power_up_tx(sii902x);
+
+	/* set TPI video mode */
+	data[0] = PICOS2KHZ(fbi->var.pixclock) / 10;
+	data[2] = fbi->var.hsync_len + fbi->var.left_margin +
+		  fbi->var.xres + fbi->var.right_margin;
+	data[3] = fbi->var.vsync_len + fbi->var.upper_margin +
+		  fbi->var.yres + fbi->var.lower_margin;
+	refresh = data[2] * data[3];
+	refresh = (PICOS2KHZ(fbi->var.pixclock) * 1000) / refresh;
+	data[1] = refresh * 100;
+	tmp = (u8 *)data;
+	for (i = 0; i < 8; i++)
+		sii902x_write(sii902x->client, i, tmp[i]);
+
+	/* input bus/pixel: full pixel wide (24bit), rising edge */
+	sii902x_write(sii902x->client, 0x08, 0x70);
+	/* Set input format to RGB */
+	sii902x_write(sii902x->client, 0x09, 0x00);
+	/* set output format to RGB */
+	sii902x_write(sii902x->client, 0x0A, 0x00);
+	/* audio setup */
+	sii902x_write(sii902x->client, 0x25, 0x00);
+	sii902x_write(sii902x->client, 0x26, 0x40);
+	sii902x_write(sii902x->client, 0x27, 0x00);
+}
+
+static int __sii902x_read_edid(struct i2c_adapter *adp,
+			unsigned char *edid, u8 *buf)
+{
+	unsigned short addr = 0x50;
+	int ret;
+
+	struct i2c_msg msg[2] = {
+		{
+		.addr	= addr,
+		.flags	= 0,
+		.len	= 1,
+		.buf	= buf,
+		}, {
+		.addr	= addr,
+		.flags	= I2C_M_RD,
+		.len	= EDID_LENGTH,
+		.buf	= edid,
+		},
+	};
+
+	if (adp == NULL)
+		return -EINVAL;
+
+	memset(edid, 0, EDID_LENGTH);
+
+	ret = i2c_transfer(adp, msg, 2);
+	if (ret < 0)
+		return ret;
+
+	/* If 0x50 fails, try 0x37. */
+	if (edid[1] == 0x00) {
+		msg[0].addr = msg[1].addr = 0x37;
+		ret = i2c_transfer(adp, msg, 2);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (edid[1] == 0x00)
+		return -ENOENT;
+
+	return 0;
+}
+/* make sure edid has 256 bytes*/
+static int __sii902x_get_edid(struct i2c_adapter *adp,
+			      struct fb_info *fbi)
+{
+	u8 *edid;
+	u8 buf[2] = {0, 0};
+	int num, ret;
+
+	edid = kzalloc(EDID_LENGTH, GFP_KERNEL);
+	if (!edid)
+		return -ENOMEM;
+
+	ret = __sii902x_read_edid(adp, edid, buf);
+	if (ret)
+		return ret;
+
+	/* edid first block parsing */
+	memset(&fbi->monspecs, 0, sizeof(fbi->monspecs));
+	fb_edid_to_monspecs(edid, &fbi->monspecs);
+
+	/* need read ext block? Only support one more blk now */
+	num = edid[0x7E];
+	if (num) {
+		buf[0] = 0x80;
+		ret = __sii902x_read_edid(adp, edid, buf);
+		if (ret)
+			return ret;
+
+		fb_edid_add_monspecs(edid, &fbi->monspecs);
+	}
+
+	kfree(edid);
+	return 0;
+}
+static int sii902x_get_edid(struct fb_info *fbi)
+{
+	int old, dat, ret, cnt = 100;
+
+	old = sii902x_read(sii902x->client, 0x1A);
+
+	sii902x_write(sii902x->client, 0x1A, old | 0x4);
+	do {
+		cnt--;
+		msleep(20);
+		dat = sii902x_read(sii902x->client, 0x1A);
+	} while ((!(dat & 0x2)) && cnt);
+
+	if (!cnt) {
+		ret = -1;
+		goto done;
+	}
+
+	sii902x_write(sii902x->client, 0x1A, old | 0x06);
+
+	/* edid reading */
+	ret = __sii902x_get_edid(sii902x->client->adapter, fbi);
+
+	cnt = 100;
+	do {
+		cnt--;
+		sii902x_write(sii902x->client, 0x1A, old & ~0x6);
+		msleep(20);
+		dat = sii902x_read(sii902x->client, 0x1A);
+	} while ((dat & 0x6) && cnt);
+
+	if (!cnt)
+		ret = -1;
+
+done:
+	sii902x_write(sii902x->client, 0x1A, old);
+	return ret;
+}
+
+static void det_worker(struct work_struct *work)
+{
+	struct fb_info *fbi = sii902x->fbi;
+	struct fb_monspecs *monspecs = &fbi->monspecs;
+	int val, ret;
+	char event_string[16];
+	char *envp[] = { event_string, NULL };
+
+	val = sii902x_read(sii902x->client, 0x3D);
+	if (!(val & 0x1) && !g_enable_hdmi)
+		goto err;
+
+	/* cable connection changes */
+	if (val & 0x4 || g_enable_hdmi) {
+		sii902x->cable_plugin = 1;
+		sprintf(event_string, "EVENT=plugin");
+
+		ret = sii902x_get_edid(fbi);
+		if (ret < 0) {
+			dev_err(&sii902x->client->dev, "read edid fail\n");
+			goto err;
+		}
+
+		/* make sure fb is powerdown */
+		console_lock();
+		fb_blank(fbi, FB_BLANK_POWERDOWN);
+		console_unlock();
+
+		if (monspecs->modedb_len > 0) {
+			int i;
+			const struct fb_videomode *mode;
+			struct fb_videomode m;
+
+			fb_destroy_modelist(&fbi->modelist);
+
+			for (i = 0; i < monspecs->modedb_len; i++) {
+				/* We do not support interlaced mode for now */
+				if (!(monspecs->modedb[i].vmode &
+					FB_VMODE_INTERLACED))
+					fb_add_videomode(&monspecs->modedb[i],
+							&fbi->modelist);
+			}
+
+			fb_var_to_videomode(&m, &fbi->var);
+			mode = fb_find_nearest_mode(&m,
+					&fbi->modelist);
+
+			fb_videomode_to_var(&fbi->var, mode);
+
+			fbi->var.activate |= FB_ACTIVATE_FORCE;
+			console_lock();
+			fbi->flags |= FBINFO_MISC_USEREVENT;
+			fb_set_var(fbi, &fbi->var);
+			fbi->flags &= ~FBINFO_MISC_USEREVENT;
+			console_unlock();
+		}
+
+		console_lock();
+		fb_blank(fbi, FB_BLANK_UNBLANK);
+		console_unlock();
+	} else {
+		sii902x->cable_plugin = 0;
+		sprintf(event_string, "EVENT=plugout");
+		console_lock();
+		fb_blank(fbi, FB_BLANK_POWERDOWN);
+		console_unlock();
+	}
+	kobject_uevent_env(&sii902x->client->dev.kobj,
+			KOBJ_CHANGE, envp);
+
+err:
+	sii902x_write(sii902x->client, 0x3D, val);
+}
+
+static irqreturn_t sii902x_detect_handler(int irq, void *data)
+{
+	if (g_enable_hdmi)
+		g_enable_hdmi = false;
+
+	if (sii902x->fbi)
+		schedule_delayed_work(&(sii902x->det_work),
+				msecs_to_jiffies(20));
+	return IRQ_HANDLED;
+}
+
+static void sii902x_poweron(void)
+{
+	/* Turn on DVI or HDMI */
+	sii902x_write(sii902x->client, 0x1A, 0x00);
+}
+
+static void sii902x_poweroff(void)
+{
+	/* disable tmds before changing resolution */
+	sii902x_write(sii902x->client, 0x1A, 0x10);
+}
+
+static int sii902x_fb_event(struct notifier_block *nb,
+			    unsigned long val, void *v)
+{
+	struct fb_event *event = v;
+	struct fb_info *fbi = event->info;
+
+	switch (val) {
+	case FB_EVENT_FB_REGISTERED:
+		if (sii902x->fbi != NULL)
+			break;
+		sii902x->fbi = fbi;
+		if (g_enable_hdmi && sii902x->fbi) {
+			schedule_delayed_work(&(sii902x->det_work),
+					msecs_to_jiffies(20));
+		}
+		break;
+	case FB_EVENT_MODE_CHANGE:
+		sii902x_setup(fbi);
+		break;
+	case FB_EVENT_BLANK:
+		if (*((int *)event->data) == FB_BLANK_UNBLANK)
+			sii902x_poweron();
+		else
+			sii902x_poweroff();
+		break;
+	}
+
+	return 0;
+}
+
+static void sii902x_chip_id(struct sii902x_data *sii902x)
+{
+	struct i2c_client *client = sii902x_to_i2c(sii902x);
+	int val;
+
+	/* read device ID */
+	val = sii902x_read(client, 0x1B);
+	printk(KERN_INFO "Sii902x: read id = 0x%02X", val);
+	val = sii902x_read(client, 0x1C);
+	printk(KERN_INFO "-0x%02X", val);
+	val = sii902x_read(client, 0x1D);
+	printk(KERN_INFO "-0x%02X", val);
+	val = sii902x_read(client, 0x30);
+	printk(KERN_INFO "-0x%02X\n", val);
+}
+
+static int sii902x_initialize(struct sii902x_data *sii902x)
+{
+	struct i2c_client *client = sii902x_to_i2c(sii902x);
+	int ret, cnt;
+
+	for (cnt = 0; cnt < 5; cnt++) {
+		/* Set 902x in hardware TPI mode on and jump out of D3 state */
+		ret = sii902x_write(client, 0xC7, 0x00);
+		if (ret < 0)
+			break;
+	}
+	if (0 != ret)
+		dev_err(&client->dev, "cound not find device\n");
+
+	return ret;
+}
+
+static void sii902x_enable_source(struct sii902x_data *sii902x)
+{
+	struct i2c_client *client = sii902x_to_i2c(sii902x);
+	int val;
+
+	sii902x_write(client, 0xBC, 0x01);
+	sii902x_write(client, 0xBD, 0x82);
+	val = sii902x_read(client, 0xBE);
+	val |= 0x1;
+	sii902x_write(client, 0xBE, val);
+}
+
+static struct notifier_block nb = {
+	.notifier_call = sii902x_fb_event,
+};
+
+static int sii902x_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adap = to_i2c_adapter(client->dev.parent);
+	int ret, err;
+	struct fb_info edid_fbi;
+
+	if (!g_enable_hdmi)
+		return -EPERM;
+
+	if (!i2c_check_functionality(adap, I2C_FUNC_SMBUS_BYTE)) {
+		dev_err(&client->dev, "i2c_check_functionality error\n");
+		return -ENODEV;
+	}
+
+	sii902x = devm_kzalloc(&client->dev, sizeof(*sii902x), GFP_KERNEL);
+	if (!sii902x)
+		return -ENOMEM;
+
+	sii902x->client = client;
+	i2c_set_clientdata(client, sii902x);
+
+	err = sii902x_initialize(sii902x);
+	if (err)
+		return err;
+
+	sii902x_chip_id(sii902x);
+	sii902x_power_up_tx(sii902x);
+	sii902x_enable_source(sii902x);
+
+	/* try to read edid */
+	if (sii902x_get_edid(&edid_fbi) < 0)
+		dev_warn(&client->dev, "Can not read edid\n");
+
+	if (client->irq) {
+		ret = devm_request_irq(&client->dev, client->irq,
+				sii902x_detect_handler, 0,
+				"SII902x_det", sii902x);
+		if (ret < 0)
+			dev_warn(&client->dev,
+				"cound not request det irq %d\n",
+				client->irq);
+		else {
+			INIT_DELAYED_WORK(&(sii902x->det_work), det_worker);
+			/*enable cable hot plug irq*/
+			sii902x_write(client, 0x3C, 0x01);
+		}
+		ret = device_create_file(&client->dev, &dev_attr_fb_name);
+		if (ret < 0)
+			dev_warn(&client->dev,
+				"cound not create sys node for fb name\n");
+		ret = device_create_file(&client->dev, &dev_attr_cable_state);
+		if (ret < 0)
+			dev_warn(&client->dev,
+				"cound not create sys node for cable state\n");
+	}
+
+	fb_register_client(&nb);
+
+	return 0;
+}
+
+static int sii902x_remove(struct i2c_client *client)
+{
+	fb_unregister_client(&nb);
+	sii902x_poweroff();
+	return 0;
+}
+
+static const struct i2c_device_id sii902x_id[] = {
+	{ "sii902x", 0 },
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, sii902x_id);
+
+static const struct of_device_id sii902x_dt_ids[] = {
+	{ .compatible = "fsl,sii902x", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, sii902x_dt_ids);
+
+static struct i2c_driver sii902x_i2c_driver = {
+	.driver = {
+		.name = "sii902x",
+		.owner = THIS_MODULE,
+		.of_match_table = sii902x_dt_ids,
+	},
+	.probe = sii902x_probe,
+	.remove = sii902x_remove,
+	.id_table = sii902x_id,
+};
+module_i2c_driver(sii902x_i2c_driver);
+
+static int __init enable_hdmi_setup(char *str)
+{
+	g_enable_hdmi = true;
+
+	return 1;
+}
+__setup("hdmi", enable_hdmi_setup);
+
+MODULE_AUTHOR("Freescale Semiconductor, Inc.");
+MODULE_DESCRIPTION("SII902x DVI/HDMI driver");
+MODULE_LICENSE("GPL");
-- 
2.1.0.27.g96db324

