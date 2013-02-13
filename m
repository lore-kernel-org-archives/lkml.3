Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929Ab3BMDBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 22:01:22 -0500
Received: from mout.gmx.net ([212.227.17.21]:57814 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759766Ab3BMDBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 22:01:17 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18f2MdjVuIfTFtENJ01NkPw4l8DpecWBvav2P12Dq
	pfN6AY4tTgCbIR
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Huewe <peterhuewe@gmx.de>, Andrew Miller <amiller@amilx.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] staging/rtl8187se: Remove duplicated code by using an offset
Date: Wed, 13 Feb 2013 04:05:25 +0100
Message-Id: <1360724726-2997-8-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360724302-2794-4-git-send-email-peterhuewe@gmx.de>
References: <1360724302-2794-4-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In SetAntennaConfig87SE both branches of if (bAntDiversity) do exactly
the same, except that there is an offset of 0x80 for the register values
if bAntDiversity is true.

-> Consolidate both branches and assign the offset if necessary.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/rtl8187se/r8185b_init.c |   76 +++++++++++--------------------
 1 files changed, 26 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 005fb0b..2ca857d 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -284,62 +284,38 @@ bool SetAntennaConfig87SE(struct net_device *dev,
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	bool   bAntennaSwitched = true;
+	u8	ant_diversity_offset = 0x00; /* 0x00 = disabled, 0x80 = enabled */
 
 	/* printk("SetAntennaConfig87SE(): DefaultAnt(%d), bAntDiversity(%d)\n", DefaultAnt, bAntDiversity); */
 
 	/* Threshold for antenna diversity. */
 	write_phy_cck(dev, 0x0c, 0x09); /* Reg0c : 09 */
 
-	if (bAntDiversity) {	/*	Enable Antenna Diversity. */
-		if (DefaultAnt == 1) {	/* aux antenna */
-
-			/* Mac register, aux antenna */
-			write_nic_byte(dev, ANTSEL, 0x00);
-
-			/* Config CCK RX antenna. */
-			write_phy_cck(dev, 0x11, 0xbb); /* Reg11 : bb */
-			write_phy_cck(dev, 0x01, 0xc7); /* Reg01 : c7 */
-
-			/* Config OFDM RX antenna. */
-			write_phy_ofdm(dev, 0x0D, 0x54);	/* Reg0d : 54 */
-			write_phy_ofdm(dev, 0x18, 0xb2);	/* Reg18 : b2 */
-		} else { /*  use main antenna */
-			/* Mac register, main antenna */
-			write_nic_byte(dev, ANTSEL, 0x03);
-			/* base band */
-			/*  Config CCK RX antenna. */
-			write_phy_cck(dev, 0x11, 0x9b); /* Reg11 : 9b */
-			write_phy_cck(dev, 0x01, 0xc7); /* Reg01 : c7 */
-
-			/* Config OFDM RX antenna. */
-			write_phy_ofdm(dev, 0x0d, 0x5c);  /* Reg0d : 5c	*/
-			write_phy_ofdm(dev, 0x18, 0xb2);  /* Reg18 : b2	*/
-		}
-	} else {
-		/* Disable Antenna Diversity. */
-		if (DefaultAnt == 1) { /* aux Antenna */
-			/* Mac register, aux antenna */
-			write_nic_byte(dev, ANTSEL, 0x00);
-
-			/* Config CCK RX antenna. */
-			write_phy_cck(dev, 0x11, 0xbb); /* Reg11 : bb */
-			write_phy_cck(dev, 0x01, 0x47); /* Reg01 : 47 */
-
-			/* Config OFDM RX antenna. */
-			write_phy_ofdm(dev, 0x0D, 0x54);	/* Reg0d : 54 */
-			write_phy_ofdm(dev, 0x18, 0x32);	/* Reg18 : 32 */
-		} else { /* main Antenna */
-			/* Mac register, main antenna */
-			write_nic_byte(dev, ANTSEL, 0x03);
-
-			/* Config CCK RX antenna.	*/
-			write_phy_cck(dev, 0x11, 0x9b); /* Reg11 : 9b */
-			write_phy_cck(dev, 0x01, 0x47); /* Reg01 : 47 */
-
-			/* Config OFDM RX antenna. */
-			write_phy_ofdm(dev, 0x0D, 0x5c); /* Reg0d : 5c */
-			write_phy_ofdm(dev, 0x18, 0x32); /*Reg18 : 32 */
-		}
+	if (bAntDiversity)	/*	Enable Antenna Diversity. */
+		ant_diversity_offset = 0x80;
+
+	if (DefaultAnt == 1) { /* aux Antenna */
+		/* Mac register, aux antenna */
+		write_nic_byte(dev, ANTSEL, 0x00);
+
+		/* Config CCK RX antenna. */
+		write_phy_cck(dev, 0x11, 0xbb); /* Reg11 : bb */
+		write_phy_cck(dev, 0x01, 0x47|ant_diversity_offset); /* Reg01 : 47 | ant_diversity_offset */
+
+		/* Config OFDM RX antenna. */
+		write_phy_ofdm(dev, 0x0D, 0x54);	/* Reg0d : 54 */
+		write_phy_ofdm(dev, 0x18, 0x32|ant_diversity_offset);	/* Reg18 : 32 */
+	} else { /* main Antenna */
+		/* Mac register, main antenna */
+		write_nic_byte(dev, ANTSEL, 0x03);
+
+		/* Config CCK RX antenna.	*/
+		write_phy_cck(dev, 0x11, 0x9b); /* Reg11 : 9b */
+		write_phy_cck(dev, 0x01, 0x47|ant_diversity_offset); /* Reg01 : 47 */
+
+		/* Config OFDM RX antenna. */
+		write_phy_ofdm(dev, 0x0D, 0x5c); /* Reg0d : 5c */
+		write_phy_ofdm(dev, 0x18, 0x32|ant_diversity_offset); /*Reg18 : 32 */
 	}
 	priv->CurrAntennaIndex = DefaultAnt; /* Update default settings. */
 	return	bAntennaSwitched;
-- 
1.7.8.6

