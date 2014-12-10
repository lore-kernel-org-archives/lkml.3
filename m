Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaLJIsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:48:12 -0500
Received: from mail-bn1bbn0109.outbound.protection.outlook.com ([157.56.111.109]:62720
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753004AbaLJIsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:48:08 -0500
X-Greylist: delayed 847 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Dec 2014 03:48:07 EST
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <p.zabel@pengutronix.de>,
        <thierry.reding@gmail.com>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <mturquette@linaro.org>, <airlied@linux.ie>
Subject: [PATCH RFC 00/15] Add support for i.MX MIPI DSI DRM driver
Date: Wed, 10 Dec 2014 16:37:13 +0800
Message-ID: <1418200648-32656-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(243025005)(199003)(120916001)(48376002)(21056001)(99396003)(50986999)(50466002)(77156002)(62966003)(46102003)(68736005)(77096005)(97736003)(15975445007)(36756003)(31966008)(6806004)(2351001)(107046002)(229853001)(19580395003)(87936001)(106466001)(105606002)(104016003)(110136001)(64706001)(84676001)(89996001)(47776003)(20776003)(86362001)(92566001)(50226001)(4396001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0637;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0637;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:DM2PR0301MB0637;
X-Forefront-PRVS: 0421BF7135
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0637;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds support for i.MX MIPI DSI DRM driver.
Currently, the MIPI DSI driver only supports the burst with sync pulse mode.

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

Patch 01/15 is needed to get a precise pixel clock rate(26.4MHz) from the PLL5 video
clock.  If we don't have this patch, the pixel clock rate is about 20MHz, which
causes a horitonal shift on the display image.

This series can be applied on the drm-next branch.

[1] http://www.allshore.com/pdf/Himax_HX8369-A.pdf

Liu Ying (15):
  clk: divider: Correct parent clk round rate if no bestdiv is normally
    found
  of: Add vendor prefix for Himax Technologies Inc.
  of: Add vendor prefix for Truly Semiconductors Limited
  drm/dsi: Do not add DSI devices for the child nodes with input-port
    property
  ARM: dts: imx6qdl: Add input-port property to MIPI DSI node's CTRC
    child nodes
  ARM: dts: imx6q: Add MIPI DSI remote end points for IPU2 DI0/1 end
    points
  ARM: imx6q: Add GPR3 MIPI muxing control register field shift bits
    definition
  ARM: imx6q: clk: Add the video_27m clock
  drm: imx: Add MIPI DSI host controller driver
  drm: panel: Add support for Himax HX8369A MIPI DSI panel
  ARM: dtsi: imx6qdl: Add support for MIPI DSI host controller
  ARM: dts: imx6qdl-sabresd: Add support for TRULY TFT480800-16-E MIPI
    DSI panel
  ARM: imx_v6_v7_defconfig: Cleanup for imx drm being moved out of
    staging
  ARM: imx_v6_v7_defconfig: Add support for MIPI DSI host controller
  ARM: imx_v6_v7_defconfig: Add support for Himax HX8369A panel

 .../devicetree/bindings/drm/imx/mipi_dsi.txt       |   81 ++
 .../devicetree/bindings/mipi/dsi/mipi-dsi-bus.txt  |    4 +
 .../devicetree/bindings/panel/himax,hx8369a.txt    |   86 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    2 +
 arch/arm/boot/dts/imx6q.dtsi                       |    4 +
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |   41 +
 arch/arm/boot/dts/imx6qdl.dtsi                     |    9 +
 arch/arm/configs/imx_v6_v7_defconfig               |   17 +-
 arch/arm/mach-imx/clk-imx6q.c                      |    1 +
 drivers/clk/clk-divider.c                          |    3 +-
 drivers/gpu/drm/drm_mipi_dsi.c                     |    5 +-
 drivers/gpu/drm/imx/Kconfig                        |    6 +
 drivers/gpu/drm/imx/Makefile                       |    1 +
 drivers/gpu/drm/imx/imx-mipi-dsi.c                 | 1017 ++++++++++++++++++++
 drivers/gpu/drm/panel/Kconfig                      |    6 +
 drivers/gpu/drm/panel/Makefile                     |    1 +
 drivers/gpu/drm/panel/panel-hx8369a.c              |  627 ++++++++++++
 include/dt-bindings/clock/imx6qdl-clock.h          |    3 +-
 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h        |    1 +
 19 files changed, 1903 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/imx/mipi_dsi.txt
 create mode 100644 Documentation/devicetree/bindings/panel/himax,hx8369a.txt
 create mode 100644 drivers/gpu/drm/imx/imx-mipi-dsi.c
 create mode 100644 drivers/gpu/drm/panel/panel-hx8369a.c

-- 
2.1.0

