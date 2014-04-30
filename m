Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbaD3M4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:56:54 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64223 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836AbaD3M4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:56:52 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/15] Kirkwood DT fix and cleanup round 1
Date: Wed, 30 Apr 2014 14:56:27 +0200
Message-Id: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch set starting Kirkwood DT cleanup since over time some
cleanup potential piled up on it. Also, now that Barebox is going to
reuse the same DT code basis, we need some lowlevel property
improvements, that we ignore(d) on Linux up to now.

The patches are based on recent mvebu/dt to ease integration by Jason
since there are some Kirkwood dts related patches already queued up
for v3.16.

The first patch is a real fix and should be treated accordingly. We
moved pcie-controller nodes to mbus node a while ago. Somehow, we missed
two boards that should have broken pcie since then. A formal Tested-by
would be nice by someone who has one of the affected boards.

Basically, cleanup patches 2-13 up to now comprise:
- Patch 2 adds node labels for all common and SoC-specific nodes to ease
  further cleanup series I have in mind:
  MVEBU maintainers will know, current ocp@f1000000 isn't really correct
  but should be moved to mbus/internal-regs instead. Unfortunately, there
  are some 40+ boards replaying ocp bus node. 
  I _plan_ to convert boards ocp nodes to node label references in
  subsequent patch sets to finally move the ocp bus nodes to
  mbus/internal-regs more easily.
- Patch 3 adds stdout-path to all boards with ttyS0 bootargs:
  Linux currently doesn't really care about stdout-path property set, but
  Barebox does. ePAPR explicitly names it, so set it now and ease Barebox
  progress at least.
- Patch 4 removes clock-frequency from UART nodes:
  Back when we didn't have DT clock providers for Kirkwood, TCLK was
  spread over UART nodes in board files. Just remove the now unnecessary
  clock-frequency property, as we reference TCLK in the SoCs UART nodes.
- Patches 5-7 consolidate common pinctrl settings:
  First, rename the pinctrl node to a more appropriate name as recommended
  by ePAPR, then add a minimal stub to the toplevel SoC DT include. That
  stub then gets filled with common pinctrl settings that are currently
  spead over SoC-specific includes or even board files. Again, this also
  eases Barebox progress, as pinctrl for a bootloader is a really
  important property.
- Patches 8-13 set default pinctrl properties for some nodes:
  With pinctrl settings in common SoC DT, we can now reference them in the
  device nodes also located there. If there are other possible pinctrl
  settings, put a note in front of the corresponding pinctrl node and
  overwrite the pinctrl setting in the board file.
- Patches 14 and 15 set some lowlevel properties for Guruplug ethernet:
  While working with Barebox, I noticed missing phy-connection-type
  and non-standard PHY's compatible on Guruplug. This also applies to
  most of the other boards, but Guruplug is the only board I use Barebox
  on and have the required information.

Overall commit stats aren't as bad as I initially thought:
218 insertions and 300 deletions still is ~25% less LOC :)

Sebastian

Sebastian Hesselbarth (15):
  ARM: dts: kirkwood: fix mislocated pcie-controller nodes
  ARM: dts: kirkwood: add node labels
  ARM: dts: kirkwood: add stdout-path property to all boards
  ARM: dts: kirkwood: remove clock-frequency properties from UART nodes
  ARM: dts: kirkwood: rename pin-controller nodes
  ARM: dts: kirkwood: add pinctrl node to common SoC include
  ARM: dts: kirkwood: consolidate common pinctrl settings
  ARM: dts: kirkwood: set default pinctrl for GBE1
  ARM: dts: kirkwood: set default pinctrl for UART0/1
  ARM: dts: kirkwood: set default pinctrl for SPI0
  ARM: dts: kirkwood: set default pinctrl for NAND
  ARM: dts: kirkwood: set default pinctrl for I2C0
  ARM: dts: kirkwood: set default pinctrl for I2C1 on 6282
  ARM: dts: kirkwood: set Guruplug ethernet PHY compatible
  ARM: dts: kirkwood: set Guruplug phy-connection-type to rgmii-id

 arch/arm/boot/dts/kirkwood-6192.dtsi               | 35 ++--------
 arch/arm/boot/dts/kirkwood-6281.dtsi               | 35 ++--------
 arch/arm/boot/dts/kirkwood-6282.dtsi               | 48 +++++---------
 arch/arm/boot/dts/kirkwood-98dx4122.dtsi           | 25 +-------
 arch/arm/boot/dts/kirkwood-b3.dts                  |  7 +-
 arch/arm/boot/dts/kirkwood-cloudbox.dts            |  8 +--
 arch/arm/boot/dts/kirkwood-db.dtsi                 | 10 +--
 arch/arm/boot/dts/kirkwood-dns320.dts              |  3 +-
 arch/arm/boot/dts/kirkwood-dns325.dts              |  1 +
 arch/arm/boot/dts/kirkwood-dnskw.dtsi              |  4 +-
 arch/arm/boot/dts/kirkwood-dockstar.dts            |  3 +-
 arch/arm/boot/dts/kirkwood-dreamplug.dts           |  5 +-
 arch/arm/boot/dts/kirkwood-ds109.dts               |  1 +
 arch/arm/boot/dts/kirkwood-ds110jv10.dts           |  1 +
 arch/arm/boot/dts/kirkwood-ds111.dts               |  1 +
 arch/arm/boot/dts/kirkwood-ds112.dts               |  1 +
 arch/arm/boot/dts/kirkwood-ds209.dts               |  1 +
 arch/arm/boot/dts/kirkwood-ds210.dts               |  1 +
 arch/arm/boot/dts/kirkwood-ds212.dts               |  1 +
 arch/arm/boot/dts/kirkwood-ds212j.dts              |  1 +
 arch/arm/boot/dts/kirkwood-ds409.dts               |  1 +
 arch/arm/boot/dts/kirkwood-ds409slim.dts           |  1 +
 arch/arm/boot/dts/kirkwood-ds411.dts               |  1 +
 arch/arm/boot/dts/kirkwood-ds411j.dts              |  1 +
 arch/arm/boot/dts/kirkwood-ds411slim.dts           |  1 +
 arch/arm/boot/dts/kirkwood-goflexnet.dts           |  3 +-
 .../arm/boot/dts/kirkwood-guruplug-server-plus.dts | 14 ++--
 arch/arm/boot/dts/kirkwood-ib62x0.dts              |  5 +-
 arch/arm/boot/dts/kirkwood-iconnect.dts            |  3 +-
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts      |  3 +-
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts         |  7 +-
 arch/arm/boot/dts/kirkwood-laplug.dts              |  8 +--
 arch/arm/boot/dts/kirkwood-lsxl.dtsi               |  3 +-
 arch/arm/boot/dts/kirkwood-mplcec4.dts             | 19 +++---
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts     | 28 ++++----
 .../boot/dts/kirkwood-netgear_readynas_duo_v2.dts  |  5 +-
 .../boot/dts/kirkwood-netgear_readynas_nv+_v2.dts  |  5 +-
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi         |  9 +--
 arch/arm/boot/dts/kirkwood-nsa310.dts              |  3 +-
 arch/arm/boot/dts/kirkwood-nsa310a.dts             |  3 +-
 arch/arm/boot/dts/kirkwood-nsa320.dts              |  3 +-
 arch/arm/boot/dts/kirkwood-nsa3x0-common.dtsi      | 20 +++---
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts       | 15 ++---
 arch/arm/boot/dts/kirkwood-openblocks_a7.dts       | 24 ++-----
 arch/arm/boot/dts/kirkwood-rd88f6192.dts           |  5 +-
 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi          |  3 +-
 arch/arm/boot/dts/kirkwood-rs212.dts               |  1 +
 arch/arm/boot/dts/kirkwood-rs409.dts               |  1 +
 arch/arm/boot/dts/kirkwood-rs411.dts               |  1 +
 arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi  |  7 +-
 arch/arm/boot/dts/kirkwood-synology.dtsi           | 10 +--
 arch/arm/boot/dts/kirkwood-t5325.dts               |  9 +--
 arch/arm/boot/dts/kirkwood-topkick.dts             | 13 ++--
 arch/arm/boot/dts/kirkwood-ts219-6281.dts          |  2 +-
 arch/arm/boot/dts/kirkwood-ts219-6282.dts          |  2 +-
 arch/arm/boot/dts/kirkwood-ts219.dtsi              | 11 +---
 arch/arm/boot/dts/kirkwood-ts419.dtsi              |  2 +-
 arch/arm/boot/dts/kirkwood.dtsi                    | 74 +++++++++++++++++++---
 58 files changed, 218 insertions(+), 300 deletions(-)

---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
1.9.1

