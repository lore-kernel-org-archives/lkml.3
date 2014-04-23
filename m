Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbaDWUPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:15:53 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:43053 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbaDWUPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:15:45 -0400
From: Marek Belisko <marek@goldelico.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, bcousson@baylibre.com, tony@atomide.com,
        linux@arm.linux.org.uk, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        grant.likely@linaro.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fbdev@vger.kernel.org, hns@goldelico.com,
        Marek Belisko <marek@goldelico.com>
Subject: [PATCH v2 1/3] omapdss: panel-tpo-td028ec1: Add DT support.
Date: Wed, 23 Apr 2014 22:15:18 +0200
Message-Id: <1398284120-4986-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398284120-4986-1-git-send-email-marek@goldelico.com>
References: <1398284120-4986-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 .../bindings/video/toppoly,td028ttec1.txt          | 30 ++++++++++++++++++++
 arch/arm/mach-omap2/display.c                      |  1 +
 .../omap2/displays-new/panel-tpo-td028ttec1.c      | 32 +++++++++++++++++++++-
 3 files changed, 62 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/video/toppoly,td028ttec1.txt

diff --git a/Documentation/devicetree/bindings/video/toppoly,td028ttec1.txt b/Documentation/devicetree/bindings/video/toppoly,td028ttec1.txt
new file mode 100644
index 0000000..7175dc3
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/toppoly,td028ttec1.txt
@@ -0,0 +1,30 @@
+Toppoly TD028TTEC1 Panel
+========================
+
+Required properties:
+- compatible: "toppoly,td028ttec1"
+
+Optional properties:
+- label: a symbolic name for the panel
+
+Required nodes:
+- Video port for DPI input
+
+Example
+-------
+
+lcd-panel: td028ttec1@0 {
+	compatible = "toppoly,td028ttec1";
+	reg = <0>;
+	spi-max-frequency = <100000>;
+	spi-cpol;
+	spi-cpha;
+
+	label = "lcd";
+	port {
+		lcd_in: endpoint {
+			remote-endpoint = <&dpi_out>;
+		};
+	};
+};
+
diff --git a/arch/arm/mach-omap2/display.c b/arch/arm/mach-omap2/display.c
index 16d33d8..66a2ee0 100644
--- a/arch/arm/mach-omap2/display.c
+++ b/arch/arm/mach-omap2/display.c
@@ -566,6 +566,7 @@ static const char * const dss_compat_conv_list[] __initconst = {
 	"svideo-connector",
 	"ti,tfp410",
 	"ti,tpd12s015",
+	"toppoly,td028ttec1",
 };
 
 /* prepend compatible string with "omapdss," */
diff --git a/drivers/video/fbdev/omap2/displays-new/panel-tpo-td028ttec1.c b/drivers/video/fbdev/omap2/displays-new/panel-tpo-td028ttec1.c
index fae6adc..5b3466e 100644
--- a/drivers/video/fbdev/omap2/displays-new/panel-tpo-td028ttec1.c
+++ b/drivers/video/fbdev/omap2/displays-new/panel-tpo-td028ttec1.c
@@ -206,7 +206,8 @@ static int td028ttec1_panel_enable(struct omap_dss_device *dssdev)
 	if (omapdss_device_is_enabled(dssdev))
 		return 0;
 
-	in->ops.dpi->set_data_lines(in, ddata->data_lines);
+	if (ddata->data_lines)
+		in->ops.dpi->set_data_lines(in, ddata->data_lines);
 	in->ops.dpi->set_timings(in, &ddata->videomode);
 
 	r = in->ops.dpi->enable(in);
@@ -389,6 +390,23 @@ static int td028ttec1_panel_probe_pdata(struct spi_device *spi)
 	return 0;
 }
 
+static int td028ttec1_probe_of(struct spi_device *spi)
+{
+	struct device_node *node = spi->dev.of_node;
+	struct panel_drv_data *ddata = dev_get_drvdata(&spi->dev);
+	struct omap_dss_device *in;
+
+	in = omapdss_of_find_source_for_first_ep(node);
+	if (IS_ERR(in)) {
+		dev_err(&spi->dev, "failed to find video source\n");
+		return PTR_ERR(in);
+	}
+
+	ddata->in = in;
+
+	return 0;
+}
+
 static int td028ttec1_panel_probe(struct spi_device *spi)
 {
 	struct panel_drv_data *ddata;
@@ -418,6 +436,10 @@ static int td028ttec1_panel_probe(struct spi_device *spi)
 		r = td028ttec1_panel_probe_pdata(spi);
 		if (r)
 			return r;
+	} else if (spi->dev.of_node) {
+		r = td028ttec1_probe_of(spi);
+		if (r)
+			return r;
 	} else {
 		return -ENODEV;
 	}
@@ -463,6 +485,13 @@ static int td028ttec1_panel_remove(struct spi_device *spi)
 	return 0;
 }
 
+static const struct of_device_id td028ttec1_of_match[] = {
+	{ .compatible = "omapdss,toppoly,td028ttec1", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, td028ttec1_of_match);
+
 static struct spi_driver td028ttec1_spi_driver = {
 	.probe		= td028ttec1_panel_probe,
 	.remove		= td028ttec1_panel_remove,
@@ -470,6 +499,7 @@ static struct spi_driver td028ttec1_spi_driver = {
 	.driver         = {
 		.name   = "panel-tpo-td028ttec1",
 		.owner  = THIS_MODULE,
+		.of_match_table = td028ttec1_of_match,
 	},
 };
 
-- 
1.8.3.2

