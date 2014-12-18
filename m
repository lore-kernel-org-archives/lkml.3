Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaLRHIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 02:08:17 -0500
Received: from mail-bn1bon0144.outbound.protection.outlook.com ([157.56.111.144]:11872
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752156AbaLRHIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 02:08:11 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 08/14] drm: imx: Add MIPI DSI host controller driver
Date: Thu, 18 Dec 2014 15:11:30 +0800
Message-ID: <1418886696-11636-9-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
References: <1418886696-11636-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(479174004)(199003)(189002)(19580395003)(50226001)(89996001)(68736005)(50986999)(6806004)(87936001)(31966008)(575784001)(84676001)(2950100001)(120916001)(85426001)(86362001)(76176999)(106466001)(97736003)(104016003)(105606002)(64706001)(62966003)(110136001)(50466002)(4396001)(99396003)(46102003)(77096005)(229853001)(36756003)(48376002)(21056001)(107046002)(2351001)(92566001)(20776003)(19580405001)(47776003)(77156002)(2004002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0627;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0627;
X-Forefront-PRVS: 042957ACD7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds i.MX MIPI DSI host controller driver support.
Currently, the driver supports the burst with sync pulses mode only.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
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

 .../devicetree/bindings/drm/imx/mipi_dsi.txt       |   78 ++
 drivers/gpu/drm/imx/Kconfig                        |    6 +
 drivers/gpu/drm/imx/Makefile                       |    1 +
 drivers/gpu/drm/imx/imx-mipi-dsi.c                 | 1056 ++++++++++++++++++++
 4 files changed, 1141 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
 create mode 100644 drivers/gpu/drm/imx/imx-mipi-dsi.c

diff --git a/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt b/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
new file mode 100644
index 0000000..892ed62
--- /dev/null
+++ b/Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
@@ -0,0 +1,78 @@
+Device-Tree bindings for MIPI DSI host controller
+
+MIPI DSI host controller
+========================
+
+The MIPI DSI host controller is a Synopsys DesignWare IP.
+It is a digital core that implements all protocol functions defined
+in the MIPI DSI specification, providing an interface between the
+system and the MIPI DPHY, and allowing communication with a MIPI DSI
+compliant display.
+
+Required properties:
+ - #address-cells: Should be <1>.
+ - #size-cells: Should be <0>.
+ - compatible: Should be "fsl,imx6q-mipi-dsi" for i.MX6q/sdl SoCs.
+ - reg: Physical base address of the controller and length of memory
+         mapped region.
+ - interrupts: The controller's interrupt number to the CPU(s).
+ - gpr: Should be <&gpr>.
+         The phandle points to the iomuxc-gpr region containing the
+         multiplexer control register for the controller.
+ - clocks, clock-names: Phandles to the controller pllref, pllref_gate
+           and core_cfg clocks, as described in [1] and [2].
+
+Required sub-nodes:
+ - ports: This node may contain up to four port nodes with endpoint
+   definitions as defined in [3], corresponding to the four inputs to
+   the controller multiplexer.
+ - A node to represent a DSI peripheral as described in [4].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+[2] Documentation/devicetree/bindings/clock/imx6q-clock.txt
+[3] Documentation/devicetree/bindings/media/video-interfaces.txt
+[4] Documentation/devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt
+
+example:
+	gpr: iomuxc-gpr@020e0000 {
+		/* ... */
+	};
+
+	mipi_dsi: mipi@021e0000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,imx6q-mipi-dsi";
+		reg = <0x021e0000 0x4000>;
+		interrupts = <0 102 IRQ_TYPE_LEVEL_HIGH>;
+		gpr = <&gpr>;
+		clocks = <&clks IMX6QDL_CLK_VIDEO_27M>,
+			 <&clks IMX6QDL_CLK_HSI_TX>,
+			 <&clks IMX6QDL_CLK_HSI_TX>;
+		clock-names = "pllref", "pllref_gate", "core_cfg";
+
+		ports {
+			port@0 {
+				reg = <0>;
+				input-port;
+
+				mipi_mux_0: endpoint {
+					remote-endpoint = <&ipu1_di0_mipi>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+				input-port;
+
+				mipi_mux_1: endpoint {
+					remote-endpoint = <&ipu1_di1_mipi>;
+				};
+			};
+		};
+
+		panel {
+			compatible = "truly,tft480800-16-e-dsi";
+			reg = <0>;
+			/* ... */
+		};
+	};
diff --git a/drivers/gpu/drm/imx/Kconfig b/drivers/gpu/drm/imx/Kconfig
index 82fb758..03f04fb 100644
--- a/drivers/gpu/drm/imx/Kconfig
+++ b/drivers/gpu/drm/imx/Kconfig
@@ -51,3 +51,9 @@ config DRM_IMX_HDMI
 	depends on DRM_IMX
 	help
 	  Choose this if you want to use HDMI on i.MX6.
+
+config DRM_IMX_MIPI_DSI
+	tristate "Freescale i.MX DRM MIPI DSI"
+	depends on DRM_IMX && MFD_SYSCON
+	help
+	  Choose this if you want to use MIPI DSI on i.MX6.
diff --git a/drivers/gpu/drm/imx/Makefile b/drivers/gpu/drm/imx/Makefile
index 582c438..4571d52 100644
--- a/drivers/gpu/drm/imx/Makefile
+++ b/drivers/gpu/drm/imx/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
 imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
 obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
 obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o
+obj-$(CONFIG_DRM_IMX_MIPI_DSI) += imx-mipi-dsi.o
diff --git a/drivers/gpu/drm/imx/imx-mipi-dsi.c b/drivers/gpu/drm/imx/imx-mipi-dsi.c
new file mode 100644
index 0000000..1cb4328
--- /dev/null
+++ b/drivers/gpu/drm/imx/imx-mipi-dsi.c
@@ -0,0 +1,1056 @@
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
+#include <linux/clk.h>
+#include <linux/component.h>
+#include <linux/math64.h>
+#include <linux/mfd/syscon.h>
+#include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/regmap.h>
+#include <linux/videodev2.h>
+#include <drm/drmP.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_mipi_dsi.h>
+#include <drm/drm_panel.h>
+#include <video/mipi_display.h>
+#include <video/of_videomode.h>
+#include <video/videomode.h>
+
+#include "imx-drm.h"
+
+#define DRIVER_NAME 			"imx-mipi-dsi"
+
+#define DSI_VERSION			0x00
+
+#define DSI_PWR_UP			0x04
+#define RESET				0
+#define POWERUP				BIT(0)
+
+#define DSI_CLKMGR_CFG			0x08
+#define TO_CLK_DIVIDSION(div)		(((div) & 0xff) << 8)
+#define TX_ESC_CLK_DIVIDSION(div)	(((div) & 0xff) << 0)
+
+#define DSI_DPI_CFG			0x0c
+#define EN18_LOOSELY			BIT(10)
+#define COLORM_ACTIVE_LOW		BIT(9)
+#define SHUTD_ACTIVE_LOW		BIT(8)
+#define HSYNC_ACTIVE_LOW		BIT(7)
+#define VSYNC_ACTIVE_LOW		BIT(6)
+#define DATAEN_ACTIVE_LOW		BIT(5)
+#define DPI_COLOR_CODING_16BIT_1	(0x0 << 2)
+#define DPI_COLOR_CODING_16BIT_2	(0x1 << 2)
+#define DPI_COLOR_CODING_16BIT_3	(0x2 << 2)
+#define DPI_COLOR_CODING_18BIT_1	(0x3 << 2)
+#define DPI_COLOR_CODING_18BIT_2	(0x4 << 2)
+#define DPI_COLOR_CODING_24BIT		(0x5 << 2)
+#define DPI_VID(vid)			(((vid) & 0x3) << 0)
+
+#define DSI_DBI_CFG			0x10
+#define DSI_DBIS_CMDSIZE		0x14
+
+#define DSI_PCKHDL_CFG			0x18
+#define GEN_VID_RX(vid)			(((vid) & 0x3) << 5)
+#define EN_CRC_RX			BIT(4)
+#define EN_ECC_RX			BIT(3)
+#define EN_BTA				BIT(2)
+#define EN_EOTN_RX			BIT(1)
+#define EN_EOTP_TX			BIT(0)
+
+#define DSI_VID_MODE_CFG		0x1c
+#define FRAME_BTA_ACK			BIT(11)
+#define EN_NULL_PKT			BIT(10)
+#define EN_NULL_PKT_MASK		BIT(10)
+#define EN_MULTI_PKT			BIT(9)
+#define ENABLE_LOW_POWER		(0x3f << 3)
+#define ENABLE_LOW_POWER_MASK		(0x3f << 3)
+#define VID_MODE_TYPE_NONBURST_SYNC_PULSES	(0x0 << 1)
+#define VID_MODE_TYPE_NONBURST_SYNC_EVENTS	(0x1 << 1)
+#define VID_MODE_TYPE_BURST_SYNC_PULSES		(0x3 << 1)
+#define VID_MODE_TYPE_MASK			(0x3 << 1)
+#define ENABLE_VIDEO_MODE			BIT(0)
+#define DISABLE_VIDEO_MODE			0
+#define ENABLE_VIDEO_MODE_MASK			BIT(0)
+
+#define DSI_VID_PKT_CFG			0x20
+#define NULL_PKT_SIZE(b)		(((b) & 0x3f) << 21)
+#define NUM_CHUNKS(n)			(((n) & 0x3f) << 11)
+#define VID_PKT_SIZE(p)			(((p) & 0x7ff) << 0)
+#define VID_PKT_MAX_SIZE		0x7ff
+
+#define DSI_CMD_MODE_CFG		0x24
+#define EN_TEAR_FX			BIT(14)
+#define EN_ACK_RQST			BIT(13)
+#define DCS_LW_TX_LP			BIT(12)
+#define GEN_LW_TX_LP			BIT(11)
+#define MAX_RD_PKT_SIZE_LP		BIT(10)
+#define DCS_SW_2P_TX_LP			BIT(9)
+#define DCS_SW_1P_TX_LP			BIT(8)
+#define DCS_SW_0P_TX_LP			BIT(7)
+#define GEN_SR_2P_TX_LP			BIT(6)
+#define GEN_SR_1P_TX_LP			BIT(5)
+#define GEN_SR_0P_TX_LP			BIT(4)
+#define GEN_SW_2P_TX_LP			BIT(3)
+#define GEN_SW_1P_TX_LP			BIT(2)
+#define GEN_SW_0P_TX_LP			BIT(1)
+#define ENABLE_CMD_MODE			BIT(0)
+#define DISABLE_CMD_MODE		0
+#define ENABLE_CMD_MODE_MASK		BIT(0)
+#define CMD_MODE_ALL_LP			(DCS_LW_TX_LP | \
+					 GEN_LW_TX_LP | \
+					 MAX_RD_PKT_SIZE_LP | \
+					 DCS_SW_2P_TX_LP | \
+					 DCS_SW_1P_TX_LP | \
+					 DCS_SW_0P_TX_LP | \
+					 GEN_SR_2P_TX_LP | \
+					 GEN_SR_1P_TX_LP | \
+					 GEN_SR_0P_TX_LP | \
+					 GEN_SW_2P_TX_LP | \
+					 GEN_SW_1P_TX_LP | \
+					 GEN_SW_0P_TX_LP)
+
+#define DSI_TMR_LINE_CFG		0x28
+#define HLINE_TIME(lbcc)		(((lbcc) & 0x3fff) << 18)
+#define HBP_TIME(lbcc)			(((lbcc) & 0x1ff) << 9)
+#define HSA_TIME(lbcc)			(((lbcc) & 0x1ff) << 0)
+
+#define DSI_VTIMING_CFG			0x2c
+#define V_ACTIVE_LINES(line)		(((line) & 0x7ff) << 16)
+#define VFP_LINES(line)			(((line) & 0x3f) << 10)
+#define VBP_LINES(line)			(((line) & 0x3f) << 4)
+#define VSA_LINES(line)			(((line) & 0xf) << 0)
+
+#define DSI_PHY_TMR_CFG			0x30
+#define PHY_HS2LP_TIME(lbcc)		(((lbcc) & 0xff) << 20)
+#define PHY_LP2HS_TIME(lbcc)		(((lbcc) & 0xff) << 12)
+#define BTA_TIME(lbcc)			(((lbcc) & 0xfff) << 0)
+
+#define DSI_GEN_HDR			0x34
+#define GEN_HDATA(data)			(((data) & 0xffff) << 8)
+#define GEN_HDATA_MASK			(0xffff << 8)
+#define GEN_HTYPE(type)			(((type) & 0xff) << 0)
+#define GEN_HTYPE_MASK			0xff
+
+#define DSI_GEN_PLD_DATA		0x38
+
+#define DSI_CMD_PKT_STATUS		0x3c
+#define GEN_CMD_EMPTY			BIT(0)
+#define GEN_CMD_FULL			BIT(1)
+#define GEN_PLD_W_EMPTY			BIT(2)
+#define GEN_PLD_W_FULL			BIT(3)
+#define GEN_PLD_R_EMPTY			BIT(4)
+#define GEN_RD_CMD_BUSY			BIT(6)
+
+#define DSI_TO_CNT_CFG			0x40
+#define DSI_ERROR_ST0			0x44
+#define DSI_ERROR_ST1			0x48
+#define DSI_ERROR_MSK0			0x4c
+#define DSI_ERROR_MSK1			0x50
+
+#define DSI_PHY_RSTZ			0x54
+#define PHY_DISABLECLK			0
+#define PHY_ENABLECLK			BIT(2)
+#define PHY_RSTZ			0
+#define PHY_UNRSTZ			BIT(1)
+#define PHY_SHUTDOWNZ			0
+#define PHY_UNSHUTDOWNZ			BIT(0)
+
+#define DSI_PHY_IF_CFG			0x58
+#define N_LANES(n)			((((n) - 1) & 0x3) << 0)
+#define PHY_STOP_WAIT_TIME(cycle)	(((cycle) & 0x3ff) << 2)
+
+#define DSI_PHY_IF_CTRL			0x5c
+#define PHY_IF_CTRL_RESET		0x0
+#define TX_REQ_CLK_HS			BIT(0)
+
+#define DSI_PHY_STATUS			0x60
+#define LOCK				BIT(0)
+#define STOP_STATE_CLK_LANE		BIT(2)
+
+#define DSI_PHY_TST_CTRL0		0x64
+#define PHY_TESTCLK			BIT(1)
+#define PHY_UNTESTCLK			0
+#define PHY_TESTCLR			BIT(0)
+#define PHY_UNTESTCLR			0
+
+#define DSI_PHY_TST_CTRL1		0x68
+#define PHY_TESTEN			BIT(16)
+#define PHY_UNTESTEN			0
+#define PHY_TESTDOUT(n)			(((n) & 0xff) << 8)
+#define PHY_TESTDIN(n)			(((n) & 0xff) << 0)
+
+#define IMX_MIPI_DSI_MAX_DATA_LANES	2
+
+#define PHY_STATUS_TIMEOUT		10
+#define CMD_PKT_STATUS_TIMEOUT		20
+
+struct imx_mipi_dsi {
+	struct mipi_dsi_host dsi_host;
+	struct drm_connector connector;
+	struct drm_encoder encoder;
+	struct drm_panel *panel;
+	struct device *dev;
+
+	struct regmap *regmap;
+	void __iomem *base;
+
+	struct clk *pllref_clk;
+	struct clk *pllref_gate_clk;
+	struct clk *cfg_clk;
+
+	unsigned int lane_mbps; /* per lane */
+	u32 channel;
+	u32 lanes;
+	u32 format;
+	struct drm_display_mode *mode;
+};
+
+enum {
+	STATUS_TO_CLEAR,
+	STATUS_TO_SET,
+};
+
+enum imx_mipi_dsi_mode {
+	IMX_MIPI_DSI_CMD_MODE,
+	IMX_MIPI_DSI_VID_MODE,
+};
+
+struct dphy_pll_testdin_map {
+	unsigned int max_mbps;
+	u8 testdin;
+};
+
+/* The table is based on 27MHz DPHY pll reference clock. */
+static const struct dphy_pll_testdin_map dptdin_map[] = {
+	{160, 0x04}, {180, 0x24}, {200, 0x44}, {210, 0x06},
+	{240, 0x26}, {250, 0x46}, {270, 0x08}, {300, 0x28},
+	{330, 0x48}, {360, 0x2a}, {400, 0x4a}, {450, 0x0c},
+	{500, 0x2c}, {550, 0x0e}, {600, 0x2e}, {650, 0x10},
+	{700, 0x30}, {750, 0x12}, {800, 0x32}, {850, 0x14},
+	{900, 0x34}, {950, 0x54}, {1000, 0x74}
+};
+
+static inline struct imx_mipi_dsi *host_to_dsi(struct mipi_dsi_host *host)
+{
+	return container_of(host, struct imx_mipi_dsi, dsi_host);
+}
+
+static inline struct imx_mipi_dsi *con_to_dsi(struct drm_connector *con)
+{
+	return container_of(con, struct imx_mipi_dsi, connector);
+}
+
+static inline struct imx_mipi_dsi *enc_to_dsi(struct drm_encoder *enc)
+{
+	return container_of(enc, struct imx_mipi_dsi, encoder);
+}
+
+static int max_mbps_to_testdin(unsigned int max_mbps)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dptdin_map); i++)
+		if (dptdin_map[i].max_mbps == max_mbps)
+			return dptdin_map[i].testdin;
+
+	return -EINVAL;
+}
+
+static void imx_mipi_dsi_set_ipu_di_mux(struct imx_mipi_dsi *dsi, int ipu_di)
+{
+	regmap_update_bits(dsi->regmap, IOMUXC_GPR3,
+			   IMX6Q_GPR3_MIPI_MUX_CTL_MASK,
+			   ipu_di << IMX6Q_GPR3_MIPI_MUX_CTL_SHIFT);
+}
+
+static inline void dsi_write(struct imx_mipi_dsi *dsi, u32 reg, u32 val)
+{
+	writel(val, dsi->base + reg);
+}
+
+static inline u32 dsi_read(struct imx_mipi_dsi *dsi, u32 reg)
+{
+	return readl(dsi->base + reg);
+}
+
+static inline void dsi_modify(struct imx_mipi_dsi *dsi, u32 reg,
+				       u32 mask, u32 val)
+{
+	u32 v = readl(dsi->base + reg);
+	v &= ~mask;
+	v |= val;
+	writel(v, dsi->base + reg);
+}
+
+static int check_status(struct imx_mipi_dsi *dsi, u32 reg, u32 status,
+			unsigned int timeout, bool to_set)
+{
+	unsigned long expire;
+	bool out;
+	u32 val;
+
+	expire = jiffies + msecs_to_jiffies(timeout);
+	for (;;) {
+		val = dsi_read(dsi, reg);
+		out = to_set ? ((val & status) == status) : !(val & status);
+		if (out)
+			break;
+
+		if (time_after(jiffies, expire))
+			return -ETIMEDOUT;
+
+		cpu_relax();
+	}
+
+	return 0;
+}
+
+/*
+ * The controller should generate 2 frames before
+ * preparing the peripheral.
+ */
+static void imx_mipi_dsi_wait_for_two_frames(struct imx_mipi_dsi *dsi)
+{
+	unsigned long expire;
+	int refresh, two_frames;
+
+	refresh = drm_mode_vrefresh(dsi->mode);
+	two_frames = DIV_ROUND_UP(MSEC_PER_SEC, refresh) * 2;
+
+	expire = jiffies + msecs_to_jiffies(two_frames);
+	while (time_before(jiffies, expire))
+		cpu_relax();
+}
+
+static int imx_mipi_dsi_config_testdin(struct imx_mipi_dsi *dsi)
+{
+	int ret = 0;
+	int testdin;
+
+	testdin = max_mbps_to_testdin(dsi->lane_mbps);
+	if (testdin < 0) {
+		dev_err(dsi->dev, "failed to get testdin for %dmbps "
+			"lane clock\n", dsi->lane_mbps);
+		return testdin;
+	}
+
+	dsi_write(dsi, DSI_PHY_IF_CTRL, PHY_IF_CTRL_RESET);
+	dsi_write(dsi, DSI_PWR_UP, POWERUP);
+
+	dsi_write(dsi, DSI_PHY_TST_CTRL0, PHY_UNTESTCLK | PHY_UNTESTCLR);
+	dsi_write(dsi, DSI_PHY_TST_CTRL1, PHY_TESTEN | PHY_TESTDOUT(0) |
+					  PHY_TESTDIN(0x44));
+	dsi_write(dsi, DSI_PHY_TST_CTRL0, PHY_TESTCLK | PHY_UNTESTCLR);
+	dsi_write(dsi, DSI_PHY_TST_CTRL0, PHY_UNTESTCLK | PHY_UNTESTCLR);
+	dsi_write(dsi, DSI_PHY_TST_CTRL1, PHY_UNTESTEN | PHY_TESTDOUT(0) |
+					  PHY_TESTDIN(testdin));
+	dsi_write(dsi, DSI_PHY_TST_CTRL0, PHY_TESTCLK | PHY_UNTESTCLR);
+	dsi_write(dsi, DSI_PHY_TST_CTRL0, PHY_UNTESTCLK | PHY_UNTESTCLR);
+	dsi_write(dsi, DSI_PHY_RSTZ,      PHY_ENABLECLK | PHY_UNRSTZ |
+					  PHY_UNSHUTDOWNZ);
+	ret = check_status(dsi, DSI_PHY_STATUS, LOCK,
+			   PHY_STATUS_TIMEOUT, STATUS_TO_SET);
+	if (ret < 0) {
+		dev_err(dsi->dev, "failed to wait for phy lock state\n");
+		return ret;
+	}
+	ret = check_status(dsi, DSI_PHY_STATUS, STOP_STATE_CLK_LANE,
+			   PHY_STATUS_TIMEOUT, STATUS_TO_SET);
+	if (ret < 0) {
+		dev_err(dsi->dev, "failed to wait for phy clk lane stop state\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static int imx_mipi_dsi_get_lane_bps(struct imx_mipi_dsi *dsi,
+				      unsigned int *final_mbps)
+{
+	int bpp, i;
+	unsigned int target_mbps, mpclk;
+	unsigned long pllref;
+
+	bpp = mipi_dsi_pixel_format_to_bpp(dsi->format);
+	if (bpp < 0) {
+		dev_err(dsi->dev, "failed to get bpp for pixel format %d\n",
+			dsi->format);
+		return bpp;
+	}
+
+	pllref = clk_get_rate(dsi->pllref_clk);
+	if (pllref != 27000000)
+		dev_warn(dsi->dev, "expect 27MHz DPHY pll reference clock\n");
+
+	mpclk = DIV_ROUND_UP(dsi->mode->clock, MSEC_PER_SEC);
+	if (mpclk) {
+		/* take 1/0.7 blanking overhead into consideration */
+		target_mbps = (mpclk * (bpp / dsi->lanes) * 10) / 7;
+	} else {
+		dev_dbg(dsi->dev, "use default 1Gbps DPHY pll clock\n");
+		target_mbps = 1000;
+	}
+
+	dev_dbg(dsi->dev, "target DPHY pll clock frequency is %uMbps\n",
+		target_mbps);
+
+	for (i = 0; i < ARRAY_SIZE(dptdin_map); i++) {
+		if (target_mbps < dptdin_map[i].max_mbps) {
+			*final_mbps = dptdin_map[i].max_mbps;
+			dev_info(dsi->dev, "real DPHY pll clock frequency "
+				 "is %uMbps\n", *final_mbps);
+			return 0;
+		}
+	}
+
+	dev_err(dsi->dev, "DPHY clock frequency %uMbps is out of range\n",
+						target_mbps);
+
+	return -EINVAL;
+}
+
+static int imx_mipi_dsi_host_attach(struct mipi_dsi_host *host,
+				    struct mipi_dsi_device *device)
+{
+	struct imx_mipi_dsi *dsi = host_to_dsi(host);
+
+	if (device->lanes > IMX_MIPI_DSI_MAX_DATA_LANES) {
+		dev_err(dsi->dev, "the number of data lanes(%d) is too many\n",
+				device->lanes);
+		return -EINVAL;
+	}
+
+	if (!(device->mode_flags & MIPI_DSI_MODE_VIDEO_BURST) ||
+	    !(device->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)) {
+		dev_err(dsi->dev, "device mode is unsupported\n");
+		return -EINVAL;
+	}
+
+	if (device->format != MIPI_DSI_FMT_RGB888 &&
+	    device->format != MIPI_DSI_FMT_RGB565) {
+		dev_err(dsi->dev, "device pixel format is unsupported\n");
+		return -EINVAL;
+	}
+
+	dsi->lanes = device->lanes;
+	dsi->channel = device->channel;
+	dsi->format = device->format;
+	dsi->panel = of_drm_find_panel(device->dev.of_node);
+	drm_panel_attach(dsi->panel, &dsi->connector);
+
+	return 0;
+}
+
+static int imx_mipi_dsi_host_detach(struct mipi_dsi_host *host,
+				    struct mipi_dsi_device *device)
+{
+	struct imx_mipi_dsi *dsi = host_to_dsi(host);
+
+	drm_panel_detach(dsi->panel);
+	dsi->panel = NULL;
+
+	return 0;
+}
+
+static int imx_mipi_dsi_gen_pkt_hdr_write(struct imx_mipi_dsi *dsi, u32 val)
+{
+	int ret;
+
+	ret = check_status(dsi, DSI_CMD_PKT_STATUS, GEN_CMD_FULL,
+			   CMD_PKT_STATUS_TIMEOUT, STATUS_TO_CLEAR);
+	if (ret < 0) {
+		dev_err(dsi->dev, "failed to get avaliable command FIFO\n");
+		return ret;
+	}
+
+	dsi_write(dsi, DSI_GEN_HDR, val);
+
+	ret = check_status(dsi, DSI_CMD_PKT_STATUS,
+			   GEN_CMD_EMPTY | GEN_PLD_W_EMPTY,
+			   CMD_PKT_STATUS_TIMEOUT, STATUS_TO_SET);
+	if (ret < 0) {
+		dev_err(dsi->dev, "failed to write command FIFO\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int imx_mipi_dsi_dcs_short_write(struct imx_mipi_dsi *dsi,
+					const struct mipi_dsi_msg *msg)
+{
+	const u16 *tx_buf = msg->tx_buf;
+	u32 val = GEN_HDATA(*tx_buf) | GEN_HTYPE(msg->type);
+
+	if (msg->tx_len > 2) {
+		dev_err(dsi->dev, "too long tx buf length %d for short write\n",
+			msg->tx_len);
+		return -EINVAL;
+	}
+
+	return imx_mipi_dsi_gen_pkt_hdr_write(dsi, val);
+}
+
+static int imx_mipi_dsi_dcs_long_write(struct imx_mipi_dsi *dsi,
+				       const struct mipi_dsi_msg *msg)
+{
+	const u32 *tx_buf = msg->tx_buf;
+	int len = msg->tx_len, pld_data_bytes = sizeof(*tx_buf), ret;
+	u32 val = GEN_HDATA(msg->tx_len) | GEN_HTYPE(msg->type);
+	u32 remainder = 0;
+
+	if (msg->tx_len < 3) {
+		dev_err(dsi->dev, "wrong tx buf length %d for long write\n",
+			msg->tx_len);
+		return -EINVAL;
+	}
+
+	while (DIV_ROUND_UP(len, pld_data_bytes)) {
+		if (len < pld_data_bytes) {
+			memcpy(&remainder, tx_buf, len);
+			dsi_write(dsi, DSI_GEN_PLD_DATA, remainder);
+			len = 0;
+		} else {
+			dsi_write(dsi, DSI_GEN_PLD_DATA, *tx_buf);
+			tx_buf++;
+			len -= pld_data_bytes;
+		}
+		ret = check_status(dsi, DSI_CMD_PKT_STATUS, GEN_PLD_W_FULL,
+				   CMD_PKT_STATUS_TIMEOUT, STATUS_TO_CLEAR);
+		if (ret < 0) {
+			dev_err(dsi->dev, "failed to get avaliable "
+					"write payload FIFO\n");
+			return ret;
+		}
+	}
+
+	return imx_mipi_dsi_gen_pkt_hdr_write(dsi, val);
+}
+
+static ssize_t imx_mipi_dsi_host_transfer(struct mipi_dsi_host *host,
+					  const struct mipi_dsi_msg *msg)
+{
+	struct imx_mipi_dsi *dsi = host_to_dsi(host);
+	int ret;
+
+	switch (msg->type) {
+	case MIPI_DSI_DCS_SHORT_WRITE:
+	case MIPI_DSI_DCS_SHORT_WRITE_PARAM:
+	case MIPI_DSI_SET_MAXIMUM_RETURN_PACKET_SIZE:
+		ret = imx_mipi_dsi_dcs_short_write(dsi, msg);
+		break;
+	case MIPI_DSI_DCS_LONG_WRITE:
+		ret = imx_mipi_dsi_dcs_long_write(dsi, msg);
+		break;
+	default:
+		dev_err(dsi->dev, "unsupported message type\n");
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct mipi_dsi_host_ops imx_mipi_dsi_host_ops = {
+	.attach = imx_mipi_dsi_host_attach,
+	.detach = imx_mipi_dsi_host_detach,
+	.transfer = imx_mipi_dsi_host_transfer,
+};
+
+static enum drm_connector_status
+imx_mipi_dsi_detect(struct drm_connector *connector, bool force)
+{
+	return connector_status_connected;
+}
+
+static struct drm_connector_funcs imx_mipi_dsi_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.detect = imx_mipi_dsi_detect,
+	.destroy = imx_drm_connector_destroy,
+};
+
+static int imx_mipi_dsi_connector_get_modes(struct drm_connector *connector)
+{
+	struct imx_mipi_dsi *dsi = con_to_dsi(connector);
+
+	return drm_panel_get_modes(dsi->panel);
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
+static struct drm_encoder *imx_mipi_dsi_connector_best_encoder(
+					struct drm_connector *connector)
+{
+	struct imx_mipi_dsi *dsi = con_to_dsi(connector);
+
+	return &dsi->encoder;
+}
+
+static struct drm_connector_helper_funcs imx_mipi_dsi_connector_helper_funcs = {
+	.get_modes = imx_mipi_dsi_connector_get_modes,
+	.mode_valid = imx_mipi_dsi_mode_valid,
+	.best_encoder = imx_mipi_dsi_connector_best_encoder,
+};
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
+	struct imx_mipi_dsi *dsi = enc_to_dsi(encoder);
+	u32 interface_pix_fmt;
+
+	switch (dsi->format) {
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
+static void imx_mipi_dsi_init(struct imx_mipi_dsi *dsi)
+{
+	dsi_write(dsi, DSI_PWR_UP, RESET);
+	dsi_write(dsi, DSI_PHY_RSTZ, PHY_DISABLECLK | PHY_RSTZ | PHY_SHUTDOWNZ);
+	dsi_write(dsi, DSI_CLKMGR_CFG, TO_CLK_DIVIDSION(1) | TX_ESC_CLK_DIVIDSION(7));
+}
+
+static void imx_mipi_dsi_dpi_config(struct imx_mipi_dsi *dsi,
+				    struct drm_display_mode *mode)
+{
+	u32 val = 0;
+
+	if (!(mode->flags & DRM_MODE_FLAG_PVSYNC))
+		val |= VSYNC_ACTIVE_LOW;
+	if (!(mode->flags & DRM_MODE_FLAG_PHSYNC))
+		val |= HSYNC_ACTIVE_LOW;
+
+	switch (dsi->format) {
+	case MIPI_DSI_FMT_RGB888:
+		val |= DPI_COLOR_CODING_24BIT;
+		break;
+	case MIPI_DSI_FMT_RGB666:
+		val |= DPI_COLOR_CODING_18BIT_2;
+		val |= EN18_LOOSELY;
+		break;
+	case MIPI_DSI_FMT_RGB666_PACKED:
+		val |= DPI_COLOR_CODING_18BIT_1;
+		break;
+	case MIPI_DSI_FMT_RGB565:
+		val |= DPI_COLOR_CODING_16BIT_1;
+		break;
+	}
+
+	val |= DPI_VID(dsi->channel);
+
+	dsi_write(dsi, DSI_DPI_CFG, val);
+}
+
+static void imx_mipi_dsi_packet_handler_config(struct imx_mipi_dsi *dsi)
+{
+	dsi_write(dsi, DSI_PCKHDL_CFG, EN_CRC_RX | EN_ECC_RX | EN_BTA);
+}
+
+static void imx_mipi_dsi_video_mode_config(struct imx_mipi_dsi *dsi)
+{
+	u32 val;
+
+	val = VID_MODE_TYPE_BURST_SYNC_PULSES | ENABLE_LOW_POWER;
+
+	dsi_write(dsi, DSI_VID_MODE_CFG, val);
+}
+
+static void imx_mipi_dsi_video_packet_config(struct imx_mipi_dsi *dsi,
+					     struct drm_display_mode *mode)
+{
+	dsi_write(dsi, DSI_VID_PKT_CFG, VID_PKT_SIZE(mode->hdisplay));
+}
+
+static void imx_mipi_dsi_command_mode_config(struct imx_mipi_dsi *dsi)
+{
+	dsi_write(dsi, DSI_CMD_MODE_CFG, CMD_MODE_ALL_LP | ENABLE_CMD_MODE);
+}
+
+/* Get lane byte clock cycles. */
+static u64 imx_mipi_dsi_get_hcomponent_lbcc(struct imx_mipi_dsi *dsi,
+						u64 hcomponent)
+{
+	u64 frac, lbcc;
+
+	lbcc = hcomponent * dsi->lane_mbps * USEC_PER_SEC / 8;
+	frac = do_div(lbcc, dsi->mode->clock * MSEC_PER_SEC);
+	if (frac)
+		lbcc++;
+
+	return lbcc;
+}
+
+static void imx_mipi_dsi_line_timer_config(struct imx_mipi_dsi *dsi)
+{
+	u32 val = 0, htotal, hsa, hbp, lbcc;
+	struct drm_display_mode *mode = dsi->mode;
+
+	htotal = mode->htotal;
+	hsa = mode->hsync_end - mode->hsync_start;
+	hbp = mode->htotal - mode->hsync_end;
+
+	lbcc = imx_mipi_dsi_get_hcomponent_lbcc(dsi, htotal);
+	val |= HLINE_TIME(lbcc);
+
+	lbcc = imx_mipi_dsi_get_hcomponent_lbcc(dsi, hsa);
+	val |= HSA_TIME(lbcc);
+
+	lbcc = imx_mipi_dsi_get_hcomponent_lbcc(dsi, hbp);
+	val |= HBP_TIME(lbcc);
+
+	dsi_write(dsi, DSI_TMR_LINE_CFG, val);
+}
+
+static void imx_mipi_dsi_vertical_timing_config(struct imx_mipi_dsi *dsi)
+{
+	u32 val, vactive, vsa, vfp, vbp;
+	struct drm_display_mode *mode = dsi->mode;
+
+	vactive = mode->vdisplay;
+	vsa = mode->vsync_end - mode->vsync_start;
+	vfp = mode->vsync_start - mode->vdisplay;
+	vbp = mode->vtotal - mode->vsync_end;
+
+	val = V_ACTIVE_LINES(vactive) | VSA_LINES(vsa) |
+	      VFP_LINES(vfp) | VBP_LINES(vbp);
+
+	dsi_write(dsi, DSI_VTIMING_CFG, val);
+}
+
+static void imx_mipi_dsi_dphy_timing_config(struct imx_mipi_dsi *dsi)
+{
+	u32 val;
+
+	val = PHY_HS2LP_TIME(0x40) | PHY_LP2HS_TIME(0x40) |
+	      BTA_TIME(0xd00);
+
+	dsi_write(dsi, DSI_PHY_TMR_CFG, val);
+}
+
+static void imx_mipi_dsi_dphy_interface_config(struct imx_mipi_dsi *dsi)
+{
+	dsi_write(dsi, DSI_PHY_IF_CFG, PHY_STOP_WAIT_TIME(0x20) |
+						N_LANES(dsi->lanes));
+}
+
+static void imx_mipi_dsi_clear_err(struct imx_mipi_dsi *dsi)
+{
+	dsi_read(dsi, DSI_ERROR_ST0);
+	dsi_read(dsi, DSI_ERROR_ST1);
+	dsi_write(dsi, DSI_ERROR_MSK0, 0);
+	dsi_write(dsi, DSI_ERROR_MSK1, 0);
+}
+
+static void imx_mipi_dsi_encoder_mode_set(struct drm_encoder *encoder,
+					  struct drm_display_mode *mode,
+					  struct drm_display_mode *adjusted_mode)
+{
+	struct imx_mipi_dsi *dsi = enc_to_dsi(encoder);
+	int ret;
+
+	dsi->mode = mode;
+
+	ret = imx_mipi_dsi_get_lane_bps(dsi, &dsi->lane_mbps);
+	if (ret < 0)
+		return;
+
+	clk_prepare_enable(dsi->cfg_clk);
+	imx_mipi_dsi_init(dsi);
+	imx_mipi_dsi_dpi_config(dsi, mode);
+	imx_mipi_dsi_packet_handler_config(dsi);
+	imx_mipi_dsi_video_mode_config(dsi);
+	imx_mipi_dsi_video_packet_config(dsi, mode);
+	imx_mipi_dsi_command_mode_config(dsi);
+	imx_mipi_dsi_line_timer_config(dsi);
+	imx_mipi_dsi_vertical_timing_config(dsi);
+	imx_mipi_dsi_dphy_timing_config(dsi);
+	imx_mipi_dsi_dphy_interface_config(dsi);
+	imx_mipi_dsi_clear_err(dsi);
+	imx_mipi_dsi_config_testdin(dsi);
+	imx_mipi_dsi_wait_for_two_frames(dsi);
+	drm_panel_prepare(dsi->panel);
+	clk_disable_unprepare(dsi->cfg_clk);
+}
+
+static void imx_mipi_dsi_set_mode(struct imx_mipi_dsi *dsi,
+				  enum imx_mipi_dsi_mode mode)
+{
+	if (mode == IMX_MIPI_DSI_CMD_MODE) {
+		dsi_write(dsi, DSI_PWR_UP, RESET);
+		dsi_modify(dsi, DSI_CMD_MODE_CFG,
+			   ENABLE_CMD_MODE_MASK, ENABLE_CMD_MODE);
+		dsi_modify(dsi, DSI_VID_MODE_CFG,
+			   ENABLE_VIDEO_MODE_MASK, DISABLE_VIDEO_MODE);
+		dsi_write(dsi, DSI_PWR_UP, POWERUP);
+	} else {
+		dsi_write(dsi, DSI_PWR_UP, RESET);
+		dsi_modify(dsi, DSI_CMD_MODE_CFG,
+			   ENABLE_CMD_MODE_MASK, DISABLE_CMD_MODE);
+
+		imx_mipi_dsi_video_mode_config(dsi);
+
+		dsi_modify(dsi, DSI_VID_MODE_CFG,
+			   ENABLE_VIDEO_MODE_MASK, ENABLE_VIDEO_MODE);
+		dsi_write(dsi, DSI_PWR_UP, POWERUP);
+		dsi_write(dsi, DSI_PHY_IF_CTRL, TX_REQ_CLK_HS);
+	}
+}
+
+static void imx_mipi_dsi_encoder_commit(struct drm_encoder *encoder)
+{
+	struct imx_mipi_dsi *dsi = enc_to_dsi(encoder);
+	int mux = imx_drm_encoder_get_mux_id(dsi->dev->of_node, encoder);
+
+	imx_mipi_dsi_set_ipu_di_mux(dsi, mux);
+
+	clk_prepare_enable(dsi->cfg_clk);
+	imx_mipi_dsi_set_mode(dsi, IMX_MIPI_DSI_VID_MODE);
+	clk_disable_unprepare(dsi->cfg_clk);
+
+	drm_panel_enable(dsi->panel);
+}
+
+static void imx_mipi_dsi_disable(struct imx_mipi_dsi *dsi)
+{
+	dsi_write(dsi, DSI_PHY_IF_CTRL, PHY_IF_CTRL_RESET);
+	dsi_write(dsi, DSI_PWR_UP, RESET);
+	dsi_write(dsi, DSI_PHY_RSTZ, PHY_RSTZ);
+}
+
+static void imx_mipi_dsi_encoder_disable(struct drm_encoder *encoder)
+{
+}
+
+static void imx_mipi_dsi_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct imx_mipi_dsi *dsi = enc_to_dsi(encoder);
+	unsigned long expire;
+
+	if (mode) {
+		drm_panel_disable(dsi->panel);
+
+		clk_prepare_enable(dsi->cfg_clk);
+		imx_mipi_dsi_set_mode(dsi, IMX_MIPI_DSI_CMD_MODE);
+		drm_panel_unprepare(dsi->panel);
+		imx_mipi_dsi_set_mode(dsi, IMX_MIPI_DSI_VID_MODE);
+
+		/*
+		 * This is necessary to make sure the peripheral
+		 * will be driven normally when the display is
+		 * enabled again later.
+		 */
+		expire = jiffies + msecs_to_jiffies(120);
+		while (time_before(jiffies, expire))
+			cpu_relax();
+
+		imx_mipi_dsi_set_mode(dsi, IMX_MIPI_DSI_CMD_MODE);
+		imx_mipi_dsi_disable(dsi);
+		clk_disable_unprepare(dsi->cfg_clk);
+	} else {
+		clk_prepare_enable(dsi->cfg_clk);
+		imx_mipi_dsi_config_testdin(dsi);
+		imx_mipi_dsi_set_mode(dsi, IMX_MIPI_DSI_VID_MODE);
+		imx_mipi_dsi_wait_for_two_frames(dsi);
+		imx_mipi_dsi_set_mode(dsi, IMX_MIPI_DSI_CMD_MODE);
+		drm_panel_prepare(dsi->panel);
+		imx_mipi_dsi_set_mode(dsi, IMX_MIPI_DSI_VID_MODE);
+		clk_disable_unprepare(dsi->cfg_clk);
+
+		drm_panel_enable(dsi->panel);
+	}
+}
+
+static struct drm_encoder_helper_funcs imx_mipi_dsi_encoder_helper_funcs = {
+	.dpms = imx_mipi_dsi_encoder_dpms,
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
+
+	drm_connector_helper_add(&dsi->connector,
+			&imx_mipi_dsi_connector_helper_funcs);
+	drm_connector_init(drm, &dsi->connector, &imx_mipi_dsi_connector_funcs,
+			   DRM_MODE_CONNECTOR_DSI);
+
+	drm_mode_connector_attach_encoder(&dsi->connector, &dsi->encoder);
+	return 0;
+}
+
+static int imx_mipi_dsi_bind(struct device *dev, struct device *master, void *data)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct drm_device *drm = data;
+	struct device_node *np = dev->of_node;
+	struct imx_mipi_dsi *dsi;
+	struct resource *res;
+	u32 val;
+	int ret;
+
+	dsi = devm_kzalloc(dev, sizeof(*dsi), GFP_KERNEL);
+	if (!dsi)
+		return -ENOMEM;
+
+	dsi->dev = dev;
+	dsi->dsi_host.ops = &imx_mipi_dsi_host_ops;
+	dsi->dsi_host.dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	dsi->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(dsi->base))
+		return PTR_ERR(dsi->base);
+
+	dsi->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
+	if (IS_ERR(dsi->regmap))
+		return PTR_ERR(dsi->regmap);
+
+	dsi->pllref_clk = devm_clk_get(dev, "pllref");
+	if (IS_ERR(dsi->pllref_clk)) {
+		ret = PTR_ERR(dsi->pllref_clk);
+		dev_err(dev, "Unable to get pll reference clock: %d\n", ret);
+		return ret;
+	}
+	clk_prepare_enable(dsi->pllref_clk);
+
+	dsi->pllref_gate_clk = devm_clk_get(dev, "pllref_gate");
+	if (IS_ERR(dsi->pllref_gate_clk)) {
+		ret = PTR_ERR(dsi->pllref_gate_clk);
+		dev_err(dev, "Unable to get pll reference gate clock: %d\n", ret);
+		return ret;
+	}
+	clk_prepare_enable(dsi->pllref_gate_clk);
+
+	dsi->cfg_clk = devm_clk_get(dev, "core_cfg");
+	if (IS_ERR(dsi->cfg_clk)) {
+		ret = PTR_ERR(dsi->cfg_clk);
+		dev_err(dev, "Unable to get configuration clock: %d\n", ret);
+		return ret;
+	}
+
+	clk_prepare_enable(dsi->cfg_clk);
+	val = dsi_read(dsi, DSI_VERSION);
+	clk_disable_unprepare(dsi->cfg_clk);
+
+	dev_info(dev, "version number is 0x%08x\n", val);
+
+	ret = imx_mipi_dsi_register(drm, dsi);
+	if (ret)
+		return ret;
+
+	dev_set_drvdata(dev, dsi);
+
+	return mipi_dsi_host_register(&dsi->dsi_host);
+}
+
+static void imx_mipi_dsi_unbind(struct device *dev, struct device *master,
+	void *data)
+{
+	struct imx_mipi_dsi *dsi = dev_get_drvdata(dev);
+
+	mipi_dsi_host_unregister(&dsi->dsi_host);
+	clk_disable_unprepare(dsi->pllref_gate_clk);
+	clk_disable_unprepare(dsi->pllref_clk);
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
+static const struct of_device_id imx_mipi_dsi_dt_ids[] = {
+	{ .compatible = "fsl,imx6q-mipi-dsi", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, imx_mipi_dsi_dt_ids);
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
+MODULE_DESCRIPTION("i.MX MIPI DSI driver");
+MODULE_AUTHOR("Liu Ying <Ying.Liu@freescale.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRIVER_NAME);
-- 
2.1.0

