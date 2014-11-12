Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaKLWLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:11:14 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41975 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbaKLWLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:11:08 -0500
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bcousson@baylibre.com, tony@atomide.com, linux@arm.linux.org.uk,
        tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, hns@goldelico.com,
        gta04-owner@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 1/5] video: omapdss: Add opa362 driver
Date: Wed, 12 Nov 2014 23:10:43 +0100
Message-Id: <1415830247-31633-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415830247-31633-1-git-send-email-marek@goldelico.com>
References: <1415830247-31633-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

opa362 is amplifier for video and can be connected to the tvout pads
of the OMAP3. It has one gpio control for enable/disable of the output
(high impedance).

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/video/fbdev/omap2/displays-new/Kconfig     |   6 +
 drivers/video/fbdev/omap2/displays-new/Makefile    |   1 +
 .../fbdev/omap2/displays-new/amplifier-opa362.c    | 343 +++++++++++++++++++++
 include/video/omap-panel-data.h                    |  12 +
 4 files changed, 362 insertions(+)
 create mode 100644 drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c

diff --git a/drivers/video/fbdev/omap2/displays-new/Kconfig b/drivers/video/fbdev/omap2/displays-new/Kconfig
index e6cfc38..211b3ec 100644
--- a/drivers/video/fbdev/omap2/displays-new/Kconfig
+++ b/drivers/video/fbdev/omap2/displays-new/Kconfig
@@ -1,6 +1,12 @@
 menu "OMAP Display Device Drivers (new device model)"
         depends on OMAP2_DSS
 
+config DISPLAY_AMPLIFIER_OPA362
+        tristate "external analog amplifier with output disable/high-Z (e.g. OPA362)"
+	help
+	  Driver to enable an external analog TV amplifier (e.g. OPA362)
+	  through a GPIO.
+
 config DISPLAY_ENCODER_TFP410
         tristate "TFP410 DPI to DVI Encoder"
 	help
diff --git a/drivers/video/fbdev/omap2/displays-new/Makefile b/drivers/video/fbdev/omap2/displays-new/Makefile
index 0323a8a..b311542 100644
--- a/drivers/video/fbdev/omap2/displays-new/Makefile
+++ b/drivers/video/fbdev/omap2/displays-new/Makefile
@@ -1,3 +1,4 @@
+obj-$(CONFIG_DISPLAY_AMPLIFIER_OPA362) += amplifier-opa362.o
 obj-$(CONFIG_DISPLAY_ENCODER_TFP410) += encoder-tfp410.o
 obj-$(CONFIG_DISPLAY_ENCODER_TPD12S015) += encoder-tpd12s015.o
 obj-$(CONFIG_DISPLAY_CONNECTOR_DVI) += connector-dvi.o
diff --git a/drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c b/drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c
new file mode 100644
index 0000000..8065a28
--- /dev/null
+++ b/drivers/video/fbdev/omap2/displays-new/amplifier-opa362.c
@@ -0,0 +1,343 @@
+/*
+ * OPA362 analog video amplifier with output/power control
+ *
+ * Copyright (C) 2014 Golden Delicious Computers
+ * Author: H. Nikolaus Schaller <hns@goldelico.com>
+ *
+ * based on encoder-tfp410
+ *
+ * Copyright (C) 2013 Texas Instruments
+ * Author: Tomi Valkeinen <tomi.valkeinen@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/gpio.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/of_gpio.h>
+
+#include <video/omapdss.h>
+#include <video/omap-panel-data.h>
+
+struct panel_drv_data {
+	struct omap_dss_device dssdev;
+	struct omap_dss_device *in;
+
+	int enable_gpio;
+
+	struct omap_video_timings timings;
+};
+
+#define to_panel_data(x) container_of(x, struct panel_drv_data, dssdev)
+
+static int opa362_connect(struct omap_dss_device *dssdev,
+		struct omap_dss_device *dst)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+	int r;
+
+	dev_dbg(dssdev->dev, "connect\n");
+
+	if (omapdss_device_is_connected(dssdev))
+		return -EBUSY;
+
+	r = in->ops.atv->connect(in, dssdev);
+	if (r)
+		return r;
+
+	dst->src = dssdev;
+	dssdev->dst = dst;
+
+	return 0;
+}
+
+static void opa362_disconnect(struct omap_dss_device *dssdev,
+		struct omap_dss_device *dst)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+
+	dev_dbg(dssdev->dev, "disconnect\n");
+
+	WARN_ON(!omapdss_device_is_connected(dssdev));
+	if (!omapdss_device_is_connected(dssdev))
+		return;
+
+	WARN_ON(dst != dssdev->dst);
+	if (dst != dssdev->dst)
+		return;
+
+	dst->src = NULL;
+	dssdev->dst = NULL;
+
+	in->ops.atv->disconnect(in, &ddata->dssdev);
+}
+
+static int opa362_enable(struct omap_dss_device *dssdev)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+	int r;
+
+	dev_dbg(dssdev->dev, "enable\n");
+
+	if (!omapdss_device_is_connected(dssdev))
+		return -ENODEV;
+
+	if (omapdss_device_is_enabled(dssdev))
+		return 0;
+
+	in->ops.atv->set_timings(in, &ddata->timings);
+	/* fixme: should we receive the invert from our consumer, i.e. the connector? */
+	in->ops.atv->invert_vid_out_polarity(in, true);
+
+	r = in->ops.atv->enable(in);
+	if (r)
+		return r;
+
+	if (gpio_is_valid(ddata->enable_gpio))
+		gpio_set_value_cansleep(ddata->enable_gpio, 1);
+
+	dssdev->state = OMAP_DSS_DISPLAY_ACTIVE;
+
+	return 0;
+}
+
+static void opa362_disable(struct omap_dss_device *dssdev)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+
+	dev_dbg(dssdev->dev, "disable\n");
+
+	if (!omapdss_device_is_enabled(dssdev))
+		return;
+
+	if (gpio_is_valid(ddata->enable_gpio))
+		gpio_set_value_cansleep(ddata->enable_gpio, 0);
+
+	in->ops.atv->disable(in);
+
+	dssdev->state = OMAP_DSS_DISPLAY_DISABLED;
+}
+
+static void opa362_set_timings(struct omap_dss_device *dssdev,
+		struct omap_video_timings *timings)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+
+	dev_dbg(dssdev->dev, "set_timings\n");
+
+	ddata->timings = *timings;
+	dssdev->panel.timings = *timings;
+
+	in->ops.atv->set_timings(in, timings);
+}
+
+static void opa362_get_timings(struct omap_dss_device *dssdev,
+		struct omap_video_timings *timings)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+
+	dev_dbg(dssdev->dev, "get_timings\n");
+
+	*timings = ddata->timings;
+}
+
+static int opa362_check_timings(struct omap_dss_device *dssdev,
+		struct omap_video_timings *timings)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+
+	dev_dbg(dssdev->dev, "check_timings\n");
+
+	return in->ops.atv->check_timings(in, timings);
+}
+
+static void opa362_set_type(struct omap_dss_device *dssdev,
+		enum omap_dss_venc_type type)
+{
+	/* we can only drive a COMPOSITE output */
+	WARN_ON(type != OMAP_DSS_VENC_TYPE_COMPOSITE);
+
+}
+
+static void opa362_invert_vid_out_polarity(struct omap_dss_device *dssdev,
+		bool invert_polarity)
+{
+	struct panel_drv_data *ddata = to_panel_data(dssdev);
+	struct omap_dss_device *in = ddata->in;
+
+	/* OPA362 inverts the polarity */
+	in->ops.atv->invert_vid_out_polarity(in, !invert_polarity);
+}
+
+static const struct omapdss_atv_ops opa362_atv_ops = {
+	.connect	= opa362_connect,
+	.disconnect	= opa362_disconnect,
+
+	.enable		= opa362_enable,
+	.disable	= opa362_disable,
+
+	.check_timings	= opa362_check_timings,
+	.set_timings	= opa362_set_timings,
+	.get_timings	= opa362_get_timings,
+
+	.set_type	= opa362_set_type,
+	.invert_vid_out_polarity	= opa362_invert_vid_out_polarity,
+};
+
+static int opa362_probe_pdata(struct platform_device *pdev)
+{
+	struct panel_drv_data *ddata = platform_get_drvdata(pdev);
+	struct amplifier_opa362_platform_data *pdata;
+	struct omap_dss_device *dssdev, *in;
+
+	pdata = dev_get_platdata(&pdev->dev);
+
+	ddata->enable_gpio = pdata->enable_gpio;
+
+	in = omap_dss_find_output(pdata->source);
+	if (in == NULL) {
+		dev_err(&pdev->dev, "Failed to find video source\n");
+		return -ENODEV;
+	}
+
+	ddata->in = in;
+
+	dssdev = &ddata->dssdev;
+	dssdev->name = pdata->name;
+
+	return 0;
+}
+
+static int opa362_probe_of(struct platform_device *pdev)
+{
+	struct panel_drv_data *ddata = platform_get_drvdata(pdev);
+	struct device_node *node = pdev->dev.of_node;
+	struct omap_dss_device *in;
+	int gpio;
+
+	gpio = of_get_gpio(node, 0);
+
+	if (gpio_is_valid(gpio) || gpio == -ENOENT) {
+		ddata->enable_gpio = gpio;
+	} else {
+		dev_err(&pdev->dev, "failed to parse enable gpio\n");
+		return gpio;
+	}
+
+	in = omapdss_of_find_source_for_first_ep(node);
+	if (IS_ERR(in)) {
+		dev_err(&pdev->dev, "failed to find video source\n");
+		return PTR_ERR(in);
+	}
+
+	ddata->in = in;
+
+	return 0;
+}
+
+static int opa362_probe(struct platform_device *pdev)
+{
+	struct panel_drv_data *ddata;
+	struct omap_dss_device *dssdev;
+	int r;
+
+	dev_dbg(&pdev->dev, "probe\n");
+
+	ddata = devm_kzalloc(&pdev->dev, sizeof(*ddata), GFP_KERNEL);
+	if (!ddata)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, ddata);
+
+	if (dev_get_platdata(&pdev->dev)) {
+		r = opa362_probe_pdata(pdev);
+		if (r)
+			return r;
+	} else {
+		r = opa362_probe_of(pdev);
+		if (r)
+			return r;
+	}
+
+	if (gpio_is_valid(ddata->enable_gpio)) {
+		r = devm_gpio_request_one(&pdev->dev, ddata->enable_gpio,
+				GPIOF_OUT_INIT_LOW, "opa362 enable");
+		if (r) {
+			dev_err(&pdev->dev, "Failed to request enable GPIO %d\n",
+					ddata->enable_gpio);
+			goto err_gpio;
+		}
+	}
+
+	dssdev = &ddata->dssdev;
+	dssdev->ops.atv = &opa362_atv_ops;
+	dssdev->dev = &pdev->dev;
+	dssdev->type = OMAP_DISPLAY_TYPE_VENC;
+	dssdev->output_type = OMAP_DISPLAY_TYPE_VENC;
+	dssdev->owner = THIS_MODULE;
+
+	r = omapdss_register_output(dssdev);
+	if (r) {
+		dev_err(&pdev->dev, "Failed to register output\n");
+		goto err_reg;
+	}
+
+	return 0;
+err_reg:
+err_gpio:
+	omap_dss_put_device(ddata->in);
+	return r;
+}
+
+static int __exit opa362_remove(struct platform_device *pdev)
+{
+	struct panel_drv_data *ddata = platform_get_drvdata(pdev);
+	struct omap_dss_device *dssdev = &ddata->dssdev;
+	struct omap_dss_device *in = ddata->in;
+
+	omapdss_unregister_output(&ddata->dssdev);
+
+	WARN_ON(omapdss_device_is_enabled(dssdev));
+	if (omapdss_device_is_enabled(dssdev))
+		opa362_disable(dssdev);
+
+	WARN_ON(omapdss_device_is_connected(dssdev));
+	if (omapdss_device_is_connected(dssdev))
+		opa362_disconnect(dssdev, dssdev->dst);
+
+	omap_dss_put_device(in);
+
+	return 0;
+}
+
+static const struct of_device_id opa362_of_match[] = {
+	{ .compatible = "omapdss,ti,opa362", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, opa362_of_match);
+
+static struct platform_driver opa362_driver = {
+	.probe	= opa362_probe,
+	.remove	= __exit_p(opa362_remove),
+	.driver	= {
+		.name	= "amplifier-opa362",
+		.owner	= THIS_MODULE,
+		.of_match_table = opa362_of_match,
+	},
+};
+
+module_platform_driver(opa362_driver);
+
+MODULE_AUTHOR("H. Nikolaus Schaller <hns@goldelico.com>");
+MODULE_DESCRIPTION("OPA362 analog video amplifier with output/power control");
+MODULE_LICENSE("GPL");
diff --git a/include/video/omap-panel-data.h b/include/video/omap-panel-data.h
index 69279c0..5c3076c 100644
--- a/include/video/omap-panel-data.h
+++ b/include/video/omap-panel-data.h
@@ -251,4 +251,16 @@ struct panel_tpo_td028ttec1_platform_data {
 	int data_lines;
 };
 
+/**
+ * amplifier_opa362_platform_data platform data
+ * @name: name for this display entity
+ * @source: name of the display entity used as a video source
+ * @enable_gpio: gpio number for enable pi
+ */
+struct amplifier_opa362_platform_data {
+	const char *name;
+	const char *source;
+	int enable_gpio;
+};
+
 #endif /* __OMAP_PANEL_DATA_H */
-- 
1.9.1

