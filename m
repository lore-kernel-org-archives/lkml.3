Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaJVS3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:29:30 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:47143 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbaJVS1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:27:05 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] Marvell PXA168 libphy handling and Berlin Ethernet
Date: Wed, 22 Oct 2014 20:26:43 +0200
Message-Id: <1414002412-13615-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series deals with a removing a IP feature that can be found
on all currently supported Marvell Ethernet IP (pxa168_eth, mv643xx_eth,
mvneta). The MAC IP allows to automatically perform PHY auto-negotiation
without software interaction.

However, this feature (a) fundamentally clashes with the way libphy works
and (b) is unable to deal with quirky PHYs that require special treatment.
In this series, pxa168_eth driver is rewritten to completely disable that
feature and properly deal with libphy provided PHYs.

As usual, a branch on top of v3.18-rc1 can be found at

git://git.infradead.org/users/hesselba/linux-berlin.git devel/bg2-bg2cd-eth-v2

Patches 1-5 should go through David's net tree, I'll pick up the DT patches
6-9.

There have been some changes,
compared to the RFT
- added phy-connection-type property to BG2Q PHY DT node
- bail out from pxa168_eth_adjust_link when there is no change in
  PHY parameters. Also, add a call to phy_print_status.
compared to v1
- move phy-connection-type to ethernet node instead of PHY node

Patch 1 adds support for Marvell 88E3016 FastEthernet PHY that is also
integrated in Marvell Berlin BG2/BG2CD SoCs.

Patch 2 allows to pass phy_interface_t on pxa168_eth platform_data that
is only used by mach-mmp/gplug. From the board setup, I guessed gplug's
PHY is connected via RMII. The patch still isn't even compile tested.

Patches 3-5 prepare proper libphy handling and finally remove all in-driver
PHY mangling related to the feature explained above.

Patches 6-9 add corresponding ethernet DT nodes to BG2, BG2CD, add a
phy-connection-type property to BG2Q and enable ethernet on BG2-based Sony
NSZ-GS7. I have tested all this on GS7 successfully with ip=dhcp on 100M FD.

Antoine Ténart (1):
  ARM: berlin: Add phy-connection-type to BG2Q Ethernet

Sebastian Hesselbarth (8):
  phy: marvell: Add support for 88E3016 FastEthernet PHY
  net: pxa168_eth: Provide phy_interface mode on platform_data
  net: pxa168_eth: Prepare proper libphy handling
  net: pxa168_eth: Remove HW auto-negotiaion
  net: pxa168_eth: Remove in-driver PHY mangling
  ARM: berlin: Add BG2 ethernet DT nodes
  ARM: berlin: Add BG2CD ethernet DT nodes
  ARM: berlin: Enable ethernet on Sony NSZ-GS7

 arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts |   2 +
 arch/arm/boot/dts/berlin2.dtsi             |  36 +++++
 arch/arm/boot/dts/berlin2cd.dtsi           |  36 +++++
 arch/arm/boot/dts/berlin2q.dtsi            |   1 +
 arch/arm/mach-mmp/gplugd.c                 |   2 +
 drivers/net/ethernet/marvell/pxa168_eth.c  | 248 ++++++++++++-----------------
 drivers/net/phy/marvell.c                  |  46 ++++++
 include/linux/marvell_phy.h                |   1 +
 include/linux/pxa168_eth.h                 |   1 +
 9 files changed, 225 insertions(+), 148 deletions(-)

---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: netdev@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
-- 
2.1.1

