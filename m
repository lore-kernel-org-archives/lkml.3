Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaAQNZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:25:11 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34729 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaAQNY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:24:59 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: netdev@vger.kernel.org
Cc: Chen-Yu Tsai <wens@csie.org>, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH net-next v3 0/8] net: stmmac: Add Allwinner A20 GMAC ethernet
Date: Fri, 17 Jan 2014 21:24:39 +0800
Message-Id: <1389965087-21971-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v3 of the  Allwinner A20 GMAC glue layer for stmmac.
I have split the series into stmmac driver changes for net-next,
and clock and DT patches for their respective trees.


The Allwinner A20 SoC integrates an early version of dwmac
IP from Synopsys. On top of that is a hardware glue layer.
This layer needs to be configured before the dwmac can be
used.

Part of the glue layer is a clock mux, which controls the
source and direction of the TX clock used by GMAC.

The glue layer is implemented with existing feature flags 
and callbacks found in stmmac driver core. A new stmmac_of_data
structure, which is a subset of the original platform data,
has been added to tie these values with compatible strings.
The purpose of this is to avoid future glue layers assuming
they can pass other data or directly modify values used by
the driver core. This is found in patch #7.

The callbacks have also been extended to pass board specific
data. This is found in patch #3.

This version of dwmac IP requires store and forward DMA mode.
The relevant device tree property was documented, but not
implemented. Patch #6 adds this to stmmac platform driver.

Changes since v2:

  * Dropped non CONFIG_RESET_CONTROLLER routines, make stmmac
    select CONFIG_RESET_CONTROLLER
  * Split out "Deprecate snps,phy-addr and auto-detect PHY address"
    from "Use driver data and callbacks tied with compatible strings"
  * Added comments on how sunxi glue layer uses GMAC clock
  * Rebased onto net-next
  * Corrected typo in blackfin commit message

Changes since v1:

  * Added optional reset control to stmmac driver core
  * Added non CONFIG_RESET_CONROLLER routines for the above change
  * Extended callback API, as discussed with Srinivas
  * Used new stmmac_of_data to pass features and callbacks,
    instead of platform data, as discussed
  * Seperated clock module glue layer into clock driver


Cheers,
ChenYu


Chen-Yu Tsai (8):
  net: stmmac: Enable stmmac main clock when probing hardware
  net: stmmac: Add support for optional reset control
  net: stmmac: Allocate and pass soc/board specific data to callbacks
  blackfin: Update stmmac callback signatures
  net: stmmac: Honor DT parameter to force DMA store and forward mode
  net: stmmac: Deprecate snps,phy-addr and auto-detect PHY address
  net: stmmac: Use driver data and callbacks tied with compatible
    strings
  net: stmmac: sunxi platform extensions for GMAC in Allwinner A20 SoC's

 .../bindings/net/allwinner,sun7i-a20-gmac.txt      |  27 ++++
 Documentation/devicetree/bindings/net/stmmac.txt   |   4 +-
 Documentation/networking/stmmac.txt                |  12 +-
 arch/blackfin/mach-bf609/boards/ezkit.c            |   2 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |  12 ++
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  | 141 +++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  45 +++++--
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  80 +++++++++---
 include/linux/stmmac.h                             |  24 +++-
 12 files changed, 316 insertions(+), 41 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c

-- 
1.8.5.2

