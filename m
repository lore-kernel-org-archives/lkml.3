Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaLaIT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 03:19:27 -0500
Received: from mail-bn1bn0103.outbound.protection.outlook.com ([157.56.110.103]:23552
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751454AbaLaITZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 03:19:25 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v8 00/21] Add support for i.MX MIPI DSI DRM driver
Date: Wed, 31 Dec 2014 16:23:18 +0800
Message-ID: <1420014219-915-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(243025005)(107046002)(50466002)(36756003)(89996001)(69596002)(99396003)(21056001)(81156004)(4396001)(31966008)(15975445007)(110136001)(2351001)(85426001)(6806004)(19580395003)(120916001)(50226001)(104016003)(77156002)(50986999)(97736003)(84676001)(46102003)(68736005)(229853001)(20776003)(87936001)(86362001)(47776003)(48376002)(64706001)(92566001)(77096005)(62966003)(106466001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0627;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0627;
X-Forefront-PRVS: 0442E569BC
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0627;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2014 08:19:21.9221
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0627
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This version mainly fixes the Kconfig for the Synopsys DesignWare MIPI DSI
host controller bridge driver so that we may pass the allmodconfig for ARM.
Also, this version contains a minor change for the Himax HX8369A panel
driver to remove several unnecessary headers included.

The i.MX MIPI DSI is a Synopsys DesignWare MIPI DSI host controller IP.
This series adds support for a Synopsys DesignWare MIPI DSI host controller
DRM bridge driver and a i.MX MIPI DSI specific DRM driver.
Currently, the MIPI DSI drivers only support the burst with sync pulse mode.

This series also includes a DRM panel driver for the Truly TFT480800-16-E panel
which is driven by the Himax HX8369A driver IC.  The driver IC data sheet could
be found at [1].  As mentioned by the data sheet, the driver IC supports several
interface modes.  Currently, the DRM panel driver only supports the MIPI DSI video
mode.  New interface modes could be added later(perhaps, just like the way the DRM
simple panel driver supports both MIPI DSI interface panels and simple(parallel)
interface panels).

The MIPI DSI feature is tested on i.MX6Q SabreSD board and i.MX6DL SabreSD board.
The MIPI DSI display could be enabled directly on i.MX6Q SabreSD board after
applying this series, because the 26.4MHz pixel clock the panel requires could be
derived from the IPU HSP clock(264MHz) with an integer divider.
On i.MX6DL SabreSD board, we need to manually disable the LVDS and HDMI displays in
the device tree blob, since the i.MX6DL IPU HSP clock is 198MHz at present, which
makes the pixel clock share the PLL5 video clock source with the LVDS and HDMI,
thus, the panel cannot get the pixel clock rate it wants.

Patch 01/21 is needed to get a precise pixel clock rate(26.4MHz) from the PLL5 video
clock.  If we don't have this patch, the pixel clock rate is about 20MHz, which
causes a horitonal shift on the display image.

This series can be applied on the drm-next branch.

[1] http://www.allshore.com/pdf/Himax_HX8369-A.pdf

Liu Ying (21):
  clk: divider: Correct parent clk round rate if no bestdiv is normally
    found
  of: Add vendor prefix for Himax Technologies Inc.
  of: Add vendor prefix for Truly Semiconductors Limited
  ARM: imx6q: Add GPR3 MIPI muxing control register field shift bits
    definition
  ARM: imx6q: clk: Add the video_27m clock
  ARM: imx6q: clk: Change hdmi_isfr clock's parent to be video_27m clock
  ARM: imx6q: clk: Change hsi_tx clock to be a shared clock gate
  ARM: imx6q: clk: Add support for mipi_core_cfg clock as a shared clock
    gate
  ARM: dts: imx6qdl: Move existing MIPI DSI ports into a new 'ports'
    node
  drm/dsi: Add a helper to get bits per pixel of MIPI DSI pixel format
  Documentation: dt-bindings: Add bindings for Synopsys DW MIPI DSI DRM
    bridge driver
  drm/bridge: Add Synopsys DesignWare MIPI DSI host controller driver
  Documentation: dt-bindings: Add bindings for i.MX specific Synopsys DW
    MIPI DSI driver
  drm: imx: Support Synopsys DesignWare MIPI DSI host controller
  Documentation: dt-bindings: Add bindings for Himax HX8369A DRM panel
    driver
  drm: panel: Add support for Himax HX8369A MIPI DSI panel
  ARM: dtsi: imx6qdl: Add support for MIPI DSI host controller
  ARM: dts: imx6qdl-sabresd: Add support for TRULY TFT480800-16-E MIPI
    DSI panel
  ARM: imx_v6_v7_defconfig: Cleanup for imx drm being moved out of
    staging
  ARM: imx_v6_v7_defconfig: Add support for MIPI DSI host controller
  ARM: imx_v6_v7_defconfig: Add support for Himax HX8369A panel

 .../devicetree/bindings/drm/bridge/dw_mipi_dsi.txt |  73 ++
 .../devicetree/bindings/drm/imx/mipi_dsi.txt       |  78 ++
 .../devicetree/bindings/panel/himax,hx8369a.txt    |  39 +
 .../devicetree/bindings/vendor-prefixes.txt        |   2 +
 arch/arm/boot/dts/imx6q.dtsi                       |  20 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  20 +
 arch/arm/boot/dts/imx6qdl.dtsi                     |  29 +-
 arch/arm/configs/imx_v6_v7_defconfig               |  17 +-
 arch/arm/mach-imx/clk-imx6q.c                      |   7 +-
 drivers/clk/clk-divider.c                          |   3 +-
 drivers/gpu/drm/bridge/Kconfig                     |  10 +
 drivers/gpu/drm/bridge/Makefile                    |   1 +
 drivers/gpu/drm/bridge/dw_mipi_dsi.c               | 996 +++++++++++++++++++++
 drivers/gpu/drm/imx/Kconfig                        |   7 +
 drivers/gpu/drm/imx/Makefile                       |   1 +
 drivers/gpu/drm/imx/dw_mipi_dsi-imx.c              | 230 +++++
 drivers/gpu/drm/panel/Kconfig                      |   5 +
 drivers/gpu/drm/panel/Makefile                     |   1 +
 drivers/gpu/drm/panel/panel-himax-hx8369a.c        | 610 +++++++++++++
 include/drm/bridge/dw_mipi_dsi.h                   |  27 +
 include/drm/drm_mipi_dsi.h                         |  14 +
 include/dt-bindings/clock/imx6qdl-clock.h          |   4 +-
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h        |   1 +
 23 files changed, 2165 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/bridge/dw_mipi_dsi.txt
 create mode 100644 Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
 create mode 100644 Documentation/devicetree/bindings/panel/himax,hx8369a.txt
 create mode 100644 drivers/gpu/drm/bridge/dw_mipi_dsi.c
 create mode 100644 drivers/gpu/drm/imx/dw_mipi_dsi-imx.c
 create mode 100644 drivers/gpu/drm/panel/panel-himax-hx8369a.c
 create mode 100644 include/drm/bridge/dw_mipi_dsi.h

-- 
2.1.0

