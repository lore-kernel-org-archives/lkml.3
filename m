Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbaJIMjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:39:24 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59081 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaJIMjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:39:18 -0400
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
Subject: [PATCH RFT 0/8] Marvell PXA168 libphy handling and Berlin Ethernet
Date: Thu,  9 Oct 2014 14:38:58 +0200
Message-Id: <1412858346-11334-1-git-send-email-sebastian.hesselbarth@gmail.com>
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
feature and properly deal with libphy provided PHYs. The other two drivers
are suspect to future patch sets, also removing the code related with it.

Currently, the patches are based on next-20141009 and will be resent once
v3.18-rc1 drops. This is a Request-For-Test on both BG2Q and MMP/gplug as
these are the current users of pxa168_eth. A branch with this patches on
top of next-20141009 can be found at

git://git.infradead.org/users/hesselba/linux-berlin.git devel/bg2-bg2cd-eth-v1

It would be great to get a Tested-byfrom MMP guys on gplug - if they
have that board somewhere. Also, BG2Q (Antoine) needs a phy-connection-type
property. My guess is that, if it is using internal PHY, it is "mii", too.

Patch 1 adds support for Marvell 88E3016 FastEthernet PHY that is also
integrated in Marvell Berlin BG2/BG2CD SoCs.

Patch 2 allows to pass phy_interface_t on pxa168_eth platform_data that
is only used by mach-mmp/gplug. From the board setup, I guessed gplug's
PHY is connected via RMII. The patch isn't even compile tested, so here
I need a Tested-by from MMP guys.

Patches 3-5 prepare proper libphy handling and finally remove all in-driver
PHY mangling related to the feature explained above.

Patches 6-8 add corresponding ethernet DT nodes to BG2, BG2CD, and
BG2-based Sony NSZ-GS7. I have tested all this on GS7 successfully with
ip=dhcp on 100M FD.

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
 arch/arm/mach-mmp/gplugd.c                 |   2 +
 drivers/net/ethernet/marvell/pxa168_eth.c  | 242 +++++++++++------------------
 drivers/net/phy/marvell.c                  |  46 ++++++
 include/linux/marvell_phy.h                |   1 +
 include/linux/pxa168_eth.h                 |   1 +
 8 files changed, 218 insertions(+), 148 deletions(-)

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

