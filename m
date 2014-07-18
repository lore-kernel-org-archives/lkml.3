Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761706AbaGRMaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:30:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40730 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755391AbaGRMaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:30:11 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10 0/8] ARM: berlin: add AHCI support
Date: Fri, 18 Jul 2014 14:29:59 +0200
Message-Id: <1405686607-8126-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun, Kishon, Sebastian,

I looked into the AHCI framework to see how to map PHYs and ports
information. I see two ways of doing this:
  - We can attach the ahci_port_priv to the ahci_host_priv structure,
    but that would require quite a lot of changes since the
    ahci_port_priv is initialized at the very end (in port_start()) and
    because ahci_port_priv is currently retrieved from the ata_port
    structure in libahci functions. We do want to parse the dt ports
    early in the AHCI initialization to be able to generate the right
    port_map mask. Tests would be needed to ensure nothing is broken.
  - We can move the PHY handling to where the ports are handled, moving
    PHYs from ahci_host_priv to ahci_port_priv. This also would require
    to perform some tests as PHY operations would be moved from
    libahci_platform to libahci.

In both cases we do not have time to do this for the next release, as
the request popped up quite late.

So as of now:
  - Either the series is merged as is and changes to the AHCI framework
    can be made for 3.18, as it's not particularly linked to this
    series.
  - Or you really do not want it. Then that would be great if patches
    1-2 and 7-8 could be merged so that we do not end up with this big
    series going for yet another cycle... I think Kishon already took
    patches 1-2.

I've done the required modifications so that port_map is not used
anymore as a mask during the initialization (patch 3).

Thanks,

Antoine


Changes since v9:
        - moved port_map parameters into the AHCI structure

Changes since v8:
        - stopped reset the controller from the PHY driver
        - removed fixed array sizes
        - got rid of the custom to_berlin_sata_phy_priv() macro
        - added dependency to HAS_IOMEM

Changes since v7:
        - got back to the each PHY as a sub-node representation
        - renamed the power bit in the PHY driver

Changes since v6:
        - added the 'clocks' property and support in the PHY driver
        - updated the PHY compatible

Changes since v5:
        - rebased on top of v3.16-rc1
        - added the 'clocks' property in the sata node

Changes since v4:
        - updated PHY driver as tristate
        - handled the case were no SATA port is enabled
        - updated the compatible to a generic one
        - cosmetic fixups

Changes since v3:
        - moved all PHY operations to the PHY driver
        - removed PHY sub-nodes
        - removed the custom Berlin AHCI driver and switched to
          ahci_platform
        - added multiple PHYs support to the libahci_platform

Changes since v2:
        - modeled each PHY as a sub-node
        - cosmetic fixups

Changes since v1:
        - added a PHY driver, allowing to enable each port
          individually and removed the 'force-port-map' property
        - made the drivers a bit less magic :)
        - wrote a function to select and configure registers in the
          AHCI driver
        - removed BG2 / BG2CD nodes

Antoine Ténart (8):
  phy: add a driver for the Berlin SATA PHY
  Documentation: bindings: add the Berlin SATA PHY
  ata: libahci_platform: move port_map parameters into the AHCI
    structure
  ata: libahci: allow to use multiple PHYs
  ata: ahci_platform: add a generic AHCI compatible
  Documentation: bindings: document the sub-nodes AHCI bindings
  ARM: berlin: add the AHCI node for the BG2Q
  ARM: berlin: enable the eSATA interface on the BG2Q DMP

 .../devicetree/bindings/ata/ahci-platform.txt      |  37 +++
 .../devicetree/bindings/phy/berlin-sata-phy.txt    |  34 +++
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |   8 +
 arch/arm/boot/dts/berlin2q.dtsi                    |  39 +++
 drivers/ata/ahci.h                                 |   9 +-
 drivers/ata/ahci_da850.c                           |   3 +-
 drivers/ata/ahci_imx.c                             |   3 +-
 drivers/ata/ahci_mvebu.c                           |   3 +-
 drivers/ata/ahci_platform.c                        |   5 +-
 drivers/ata/ahci_st.c                              |   2 +-
 drivers/ata/ahci_sunxi.c                           |   2 +-
 drivers/ata/ahci_xgene.c                           |   2 +-
 drivers/ata/libahci.c                              |  17 +-
 drivers/ata/libahci_platform.c                     | 187 ++++++++++----
 drivers/phy/Kconfig                                |   7 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-berlin-sata.c                      | 284 +++++++++++++++++++++
 include/linux/ahci_platform.h                      |   4 +-
 18 files changed, 574 insertions(+), 73 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
 create mode 100644 drivers/phy/phy-berlin-sata.c

-- 
1.9.1

