Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab3ITUMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:12:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab3ITUM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:12:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Willy Tarreau <w@1wt.eu>,
        Jochen De Smet <jochen.armkernel@leahnim.org>,
        Peter Sanford <psanford@nearbuy.io>,
        Ethan Tuttle <ethan@ethantuttle.com>,
        =?UTF-8?q?Ch=C3=A9ny=20Yves-Gael?= <yves@cheny.fr>,
        Ryan Press <ryan@presslab.us>,
        Simon Guinot <simon.guinot@sequanux.org>, vdonnefort@lacie.com,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 79/93] net: mvneta: properly disable HW PHY polling and ensure adjust_link() works
Date: Fri, 20 Sep 2013 13:09:14 -0700
Message-Id: <1379707768-1804-80-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 714086029116b6b0a34e67ba1dd2f0d1cf26770c upstream.

This commit fixes a long-standing bug that has been reported by many
users: on some Armada 370 platforms, only the network interface that
has been used in U-Boot to tftp the kernel works properly in
Linux. The other network interfaces can see a 'link up', but are
unable to transmit data. The reports were generally made on the Armada
370-based Mirabox, but have also been given on the Armada 370-RD
board.

The network MAC in the Armada 370/XP (supported by the mvneta driver
in Linux) has a functionality that allows it to continuously poll the
PHY and directly update the MAC configuration accordingly (speed,
duplex, etc.). The very first versions of the driver submitted for
review were using this hardware mechanism, but due to this, the driver
was not integrated with the kernel phylib. Following reviews, the
driver was changed to use the phylib, and therefore a software based
polling. In software based polling, Linux regularly talks to the PHY
over the MDIO bus, and sees if the link status has changed. If it's
the case then the adjust_link() callback of the driver is called to
update the MAC configuration accordingly.

However, it turns out that the adjust_link() callback was not
configuring the hardware in a completely correct way: while it was
setting the speed and duplex bits correctly, it wasn't telling the
hardware to actually take into account those bits rather than what the
hardware-based PHY polling mechanism has concluded. So, in fact the
adjust_link() callback was basically a no-op.

However, the network happened to be working because on the network
interfaces used by U-Boot for tftp on Armada 370 platforms because the
hardware PHY polling was enabled by the bootloader, and left enabled
by Linux. However, the second network interface not used for tftp (or
both network interfaces if the kernel is loaded from USB, NAND or SD
card) didn't had the hardware PHY polling enabled.

This patch fixes this situation by:

 (1) Making sure that the hardware PHY polling is disabled by clearing
     the MVNETA_PHY_POLLING_ENABLE bit in the MVNETA_UNIT_CONTROL
     register in the driver ->probe() function.

 (2) Making sure that the duplex and speed selections made by the
     adjust_link() callback are taken into account by clearing the
     MVNETA_GMAC_AN_SPEED_EN and MVNETA_GMAC_AN_DUPLEX_EN bits in the
     MVNETA_GMAC_AUTONEG_CONFIG register.

This patch has been tested on Armada 370 Mirabox, and now both network
interfaces are usable after boot.

[ Problem introduced by commit c5aff18 ("net: mvneta: driver for
  Marvell Armada 370/XP network unit") ]

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Jochen De Smet <jochen.armkernel@leahnim.org>
Cc: Peter Sanford <psanford@nearbuy.io>
Cc: Ethan Tuttle <ethan@ethantuttle.com>
Cc: Chény Yves-Gael <yves@cheny.fr>
Cc: Ryan Press <ryan@presslab.us>
Cc: Simon Guinot <simon.guinot@sequanux.org>
Cc: vdonnefort@lacie.com
Acked-by: Jason Cooper <jason@lakedaemon.net>
Tested-by: Vincent Donnefort <vdonnefort@gmail.com>
Tested-by: Yves-Gael Cheny <yves@cheny.fr>
Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 84b312ea..81d57e9 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -137,7 +137,9 @@
 #define      MVNETA_GMAC_FORCE_LINK_PASS         BIT(1)
 #define      MVNETA_GMAC_CONFIG_MII_SPEED        BIT(5)
 #define      MVNETA_GMAC_CONFIG_GMII_SPEED       BIT(6)
+#define      MVNETA_GMAC_AN_SPEED_EN             BIT(7)
 #define      MVNETA_GMAC_CONFIG_FULL_DUPLEX      BIT(12)
+#define      MVNETA_GMAC_AN_DUPLEX_EN            BIT(13)
 #define MVNETA_MIB_COUNTERS_BASE                 0x3080
 #define      MVNETA_MIB_LATE_COLLISION           0x7c
 #define MVNETA_DA_FILT_SPEC_MCAST                0x3400
@@ -912,6 +914,13 @@ static void mvneta_defaults_set(struct mvneta_port *pp)
 	/* Assign port SDMA configuration */
 	mvreg_write(pp, MVNETA_SDMA_CONFIG, val);
 
+	/* Disable PHY polling in hardware, since we're using the
+	 * kernel phylib to do this.
+	 */
+	val = mvreg_read(pp, MVNETA_UNIT_CONTROL);
+	val &= ~MVNETA_PHY_POLLING_ENABLE;
+	mvreg_write(pp, MVNETA_UNIT_CONTROL, val);
+
 	mvneta_set_ucast_table(pp, -1);
 	mvneta_set_special_mcast_table(pp, -1);
 	mvneta_set_other_mcast_table(pp, -1);
@@ -2299,7 +2308,9 @@ static void mvneta_adjust_link(struct net_device *ndev)
 			val = mvreg_read(pp, MVNETA_GMAC_AUTONEG_CONFIG);
 			val &= ~(MVNETA_GMAC_CONFIG_MII_SPEED |
 				 MVNETA_GMAC_CONFIG_GMII_SPEED |
-				 MVNETA_GMAC_CONFIG_FULL_DUPLEX);
+				 MVNETA_GMAC_CONFIG_FULL_DUPLEX |
+				 MVNETA_GMAC_AN_SPEED_EN |
+				 MVNETA_GMAC_AN_DUPLEX_EN);
 
 			if (phydev->duplex)
 				val |= MVNETA_GMAC_CONFIG_FULL_DUPLEX;
-- 
1.8.1.2

