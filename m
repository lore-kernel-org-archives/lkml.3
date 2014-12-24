Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaLXIjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 03:39:42 -0500
Received: from mail-by2on0134.outbound.protection.outlook.com ([207.46.100.134]:23459
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752042AbaLXIgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:36:48 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v5 14/21] drm: imx: Support Synopsys DesignWare MIPI DSI host controller
Date: Wed, 24 Dec 2014 16:39:36 +0800
Message-ID: <1419410383-6359-15-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419410383-6359-1-git-send-email-Ying.Liu@freescale.com>
References: <1419410383-6359-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(2950100001)(2351001)(87936001)(229853001)(110136001)(575784001)(92566001)(86362001)(105606002)(68736005)(106466001)(36756003)(107046002)(77096005)(97736003)(104016003)(89996001)(19580395003)(6806004)(19580405001)(120916001)(85426001)(50986999)(76176999)(62966003)(77156002)(31966008)(4396001)(84676001)(50466002)(48376002)(64706001)(50226001)(21056001)(99396003)(46102003)(47776003)(20776003)(2004002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0633;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0633;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB0633;
X-Forefront-PRVS: 04359FAD81
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0633;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2014 08:36:45.7354
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB0633
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Synopsys DesignWare MIPI DSI host controller
which is embedded in the i.MX6q/sdl SoCs.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v4->v5:
 * None.

v3->v4:
 * Move the relevant dt-bindings to a separate patch to address Stefan
   Wahren's comment.

v2->v3:
 * To address Andy Yan's comments, move the common Synopsys DesignWare MIPI DSI
   host controller logic into it's drm/bridge driver and leave the i.MX specific
   logic only.

v1->v2:
 * Address almost all comments from Thierry Reding and Russell.
 * Update the DT documentation to remove the display-timings node in the panel node.
 * Update the DT documentation to state that the nodes which represent the possible
   DRM CRTCs the controller may connect with should be placed in the node "ports".
 * Remove the flag 'enabled' from the struct imx_mipi_dsi.
 * Move the format_to_bpp() function in v1 to the common DRM MIPI DSI driver.
 * Improve the way we wait for check status for DPHY and command packet transfer.
 * Improve the DPMS support for the encoder.
 * Split the functions of ->host_attach() and ->mode_valid() clearly as suggested by
   Thierry Reding.
 * Improve the logics in imx_mipi_dsi_dcs_long_write().
 * Enable/disable the pllref_clk and pllref_gate_clk at the component binding/unbinding
   stages to help remove the flag 'enabled'.
 * Update the module license to be "GPL".
 * Other minor changes, such as coding style issues and macro naming issues.

 drivers/gpu/drm/imx/Kconfig           |   7 ++
 drivers/gpu/drm/imx/Makefile          |   1 +
 drivers/gpu/drm/imx/dw_mipi_dsi-imx.c | 226 ++++++++++++++++++++++++++++++++++
 3 files changed, 234 insertions(+)
 create mode 100644 drivers/gpu/drm/imx/dw_mipi_dsi-imx.c

diff --git a/drivers/gpu/drm/imx/Kconfig b/drivers/gpu/drm/imx/Kconfig
index 82fb758..c576f6b 100644
--- a/drivers/gpu/drm/imx/Kconfig
+++ b/drivers/gpu/drm/imx/Kconfig
@@ -51,3 +51,10 @@ config DRM_IMX_HDMI
 	depends on DRM_IMX
 	help
 	  Choose this if you want to use HDMI on i.MX6.
+
+config DRM_IMX_MIPI_DSI
+	tristate "Freescale i.MX DRM MIPI DSI"
+	select DRM_DW_MIPI_DSI
+	depends on DRM_IMX
+	help
+	  Choose this if you want to use MIPI DSI on i.MX6.
diff --git a/drivers/gpu/drm/imx/Makefile b/drivers/gpu/drm/imx/Makefile
index 582c438..f0dc278 100644
--- a/drivers/gpu/drm/imx/Makefile
+++ b/drivers/gpu/drm/imx/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
 imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
 obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
 obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o
+obj-$(CONFIG_DRM_IMX_MIPI_DSI) += dw_mipi_dsi-imx.o
diff --git a/drivers/gpu/drm/imx/dw_mipi_dsi-imx.c b/drivers/gpu/drm/imx/dw_mipi_dsi-imx.c
new file mode 100644
index 0000000..5f5196b
--- /dev/null
+++ b/drivers/gpu/drm/imx/dw_mipi_dsi-imx.c
@@ -0,0 +1,226 @@
+/*
+ * i.MX drm driver - MIPI DSI Host Controller
+ *
+ * Copyright (C) 2011-2014 Freescale Semiconductor, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ * MA 02110-1301, USA.
+ */
+
+#include <linux/component.h>
+#include <linux/mfd/syscon.h>
+#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/regmap.h>
+#include <linux/videodev2.h>
+#include <drm/bridge/dw_mipi_dsi.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_mipi_dsi.h>
+
+#include "imx-drm.h"
+
+#define DRIVER_NAME 			"imx-mipi-dsi"
+
+struct imx_mipi_dsi {
+	struct drm_encoder encoder;
+	struct device *dev;
+	struct regmap *regmap;
+};
+
+static inline struct imx_mipi_dsi *enc_to_dsi(struct drm_encoder *enc)
+{
+	return container_of(enc, struct imx_mipi_dsi, encoder);
+}
+
+static void imx_mipi_dsi_set_ipu_di_mux(struct imx_mipi_dsi *dsi, int ipu_di)
+{
+	regmap_update_bits(dsi->regmap, IOMUXC_GPR3,
+			   IMX6Q_GPR3_MIPI_MUX_CTL_MASK,
+			   ipu_di << IMX6Q_GPR3_MIPI_MUX_CTL_SHIFT);
+}
+
+static struct drm_encoder_funcs imx_mipi_dsi_encoder_funcs = {
+	.destroy = imx_drm_encoder_destroy,
+};
+
+static bool imx_mipi_dsi_encoder_mode_fixup(struct drm_encoder *encoder,
+					    const struct drm_display_mode *mode,
+					    struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+static void imx_mipi_dsi_encoder_prepare(struct drm_encoder *encoder)
+{
+	u32 encoder_pix_fmt, interface_pix_fmt;
+
+	encoder_pix_fmt = dw_mipi_dsi_get_encoder_pixel_format(encoder);
+
+	switch (encoder_pix_fmt) {
+	case MIPI_DSI_FMT_RGB888:
+		interface_pix_fmt = V4L2_PIX_FMT_RGB24;
+		break;
+	case MIPI_DSI_FMT_RGB565:
+		interface_pix_fmt = V4L2_PIX_FMT_RGB565;
+		break;
+	default:
+		BUG();
+		return;
+	}
+
+	imx_drm_panel_format(encoder, interface_pix_fmt);
+}
+
+static void imx_mipi_dsi_encoder_mode_set(struct drm_encoder *encoder,
+					  struct drm_display_mode *mode,
+					  struct drm_display_mode *adjusted_mode)
+{
+}
+
+static void imx_mipi_dsi_encoder_commit(struct drm_encoder *encoder)
+{
+	struct imx_mipi_dsi *dsi = enc_to_dsi(encoder);
+	int mux = imx_drm_encoder_get_mux_id(dsi->dev->of_node, encoder);
+
+	imx_mipi_dsi_set_ipu_di_mux(dsi, mux);
+}
+
+static void imx_mipi_dsi_encoder_disable(struct drm_encoder *encoder)
+{
+}
+
+static struct drm_encoder_helper_funcs imx_mipi_dsi_encoder_helper_funcs = {
+	.mode_fixup = imx_mipi_dsi_encoder_mode_fixup,
+	.prepare = imx_mipi_dsi_encoder_prepare,
+	.mode_set = imx_mipi_dsi_encoder_mode_set,
+	.commit = imx_mipi_dsi_encoder_commit,
+	.disable = imx_mipi_dsi_encoder_disable,
+};
+
+static int imx_mipi_dsi_register(struct drm_device *drm, struct imx_mipi_dsi *dsi)
+{
+	int ret;
+
+	ret = imx_drm_encoder_parse_of(drm, &dsi->encoder, dsi->dev->of_node);
+	if (ret)
+		return ret;
+
+	drm_encoder_helper_add(&dsi->encoder, &imx_mipi_dsi_encoder_helper_funcs);
+	drm_encoder_init(drm, &dsi->encoder, &imx_mipi_dsi_encoder_funcs,
+			 DRM_MODE_ENCODER_DSI);
+	return 0;
+}
+
+static enum drm_mode_status imx_mipi_dsi_mode_valid(
+					struct drm_connector *connector,
+					struct drm_display_mode *mode)
+{
+	/* The VID_PKT_SIZE field in the DSI_VID_PKT_CFG register is 11-bit. */
+	if (mode->hdisplay > 0x7ff)
+		return MODE_BAD_HVALUE;
+
+	/* The V_ACTIVE_LINES field in the DSI_VTIMING_CFG register is 11-bit. */
+	if (mode->vdisplay > 0x7ff)
+		return MODE_BAD_VVALUE;
+
+	return MODE_OK;
+}
+
+static struct dw_mipi_dsi_plat_data imx6q_mipi_dsi_drv_data = {
+	.max_data_lanes = 2,
+	.mode_valid = imx_mipi_dsi_mode_valid,
+};
+
+static const struct of_device_id imx_mipi_dsi_dt_ids[] = {
+	{
+	 .compatible = "fsl,imx6q-mipi-dsi",
+	 .data = &imx6q_mipi_dsi_drv_data,
+	},
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, imx_mipi_dsi_dt_ids);
+
+static int imx_mipi_dsi_bind(struct device *dev, struct device *master, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	const struct of_device_id *of_id =
+			of_match_device(imx_mipi_dsi_dt_ids, dev);
+	const struct dw_mipi_dsi_plat_data *pdata = of_id->data;
+	struct drm_device *drm = data;
+	struct device_node *np = dev->of_node;
+	struct imx_mipi_dsi *dsi;
+	struct resource *res;
+	int ret;
+
+	dsi = devm_kzalloc(dev, sizeof(*dsi), GFP_KERNEL);
+	if (!dsi)
+		return -ENOMEM;
+
+	dsi->dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	dsi->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
+	if (IS_ERR(dsi->regmap))
+		return PTR_ERR(dsi->regmap);
+
+	ret = imx_mipi_dsi_register(drm, dsi);
+	if (ret)
+		return ret;
+
+	dev_set_drvdata(dev, dsi);
+
+	return dw_mipi_dsi_bind(dev, master, data, &dsi->encoder, res, pdata);
+}
+
+static void imx_mipi_dsi_unbind(struct device *dev, struct device *master,
+	void *data)
+{
+	return dw_mipi_dsi_unbind(dev, master, data);
+}
+
+static const struct component_ops imx_mipi_dsi_ops = {
+	.bind	= imx_mipi_dsi_bind,
+	.unbind	= imx_mipi_dsi_unbind,
+};
+
+static int imx_mipi_dsi_probe(struct platform_device *pdev)
+{
+	return component_add(&pdev->dev, &imx_mipi_dsi_ops);
+}
+
+static int imx_mipi_dsi_remove(struct platform_device *pdev)
+{
+	component_del(&pdev->dev, &imx_mipi_dsi_ops);
+	return 0;
+}
+
+static struct platform_driver imx_mipi_dsi_driver = {
+	.probe		= imx_mipi_dsi_probe,
+	.remove		= imx_mipi_dsi_remove,
+	.driver		= {
+		.of_match_table = imx_mipi_dsi_dt_ids,
+		.name	= DRIVER_NAME,
+	},
+};
+module_platform_driver(imx_mipi_dsi_driver);
+
+MODULE_DESCRIPTION("i.MX MIPI DSI host controller driver");
+MODULE_AUTHOR("Liu Ying <Ying.Liu@freescale.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
2.1.0

