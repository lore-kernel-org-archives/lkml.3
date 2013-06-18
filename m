Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab3FRPiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:38:20 -0400
Received: from nm13-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.160]:22688
	"EHLO nm13-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932405Ab3FRPiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:38:19 -0400
X-Yahoo-Newman-Id: 410962.72451.bm@smtp108.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MxtfaTAVM1m2mikobNbUCA2IQh.XIPBmNNZQmZCDhp7aeyJ
 Y_c3X3S0pAftcj_T4L7j7wJbgOOiNOa3pxMmxqJ2d.3jO.6kjEtSw2EOvS1p
 NNWZqoNS8OPsc0ZSquzy72TYTFauixBmJJAenAjgnD70pe7IGLLqoJ_0URyd
 m9DQjpM8Kf6HrAmXy9go_qz0Lo4fjXqUiuLnfX8oDKUZrhOKrW.NfiQblBOY
 EWJddh0yw9F7I_8NwULHawk4pvNtm7XVBc9jnVGrPfw._w.MyB5GW4MP1FwI
 7TLt_g9TR2juP5HnZZO5X6v.JiksRlIwMOJcExyjbFVE31O.obyCJtsYrW8v
 foTJ2LWllgyF9gtAQekSEYO7wak8rv.mFt6Ar6rljskIxd9ABJRyARr50Gdq
 ZKKQ9jU_2KXbcUJTw2oly339EyeyZDJihvKisACSU.a.MTbEoqkmEhsFkmxY
 j9ot8koRPMWBXKzC2CH06Hu49gEXWASlBvROFOK0wYdcS9Lkw6M4fxB6JEB5
 czDeI3CXhGUpI7BsUEVdU5KoE
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp108.sbc.mail.gq1.yahoo.com with SMTP; 18 Jun 2013 08:38:18 -0700 PDT
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Frank Li <Frank.Li@freescale.com>,
        Jim Baxter <jim_baxter@mentor.com>
Subject: [PATCH v2] net: fec: Fix build for MCF5272
Date: Tue, 18 Jun 2013 08:38:05 -0700
Message-Id: <1371569885-9054-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commits 4c09eed9 (net: fec: Enable imx6 enet checksum acceleration) and
baa70a5c (net: fec: enable pause frame to improve rx prefomance for 1G
network) introduced functionality into the FEC driver which is not
supported on MCF5272. The registers used to implement this functionality
do not exist on MCF5272. Since register defines for MCF5272 are separate
from register defines for other chips, building images for MCF5272 fails,
complaining about several undefined symbols.

Adding the missing register defines is not an option, since the registers
do not exist on MCF5272. Disable the added functionality for MCF5272 builds.

Cc: Frank Li <Frank.Li@freescale.com>
Cc: Jim Baxter <jim_baxter@mentor.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Improved explanation to clarify that the build fails due to missing register
    defines which can not be added since the registers don't exist on MCF5272. 

This problem exists in 3.9 as well, though only due to commit baa70a5c. The
patch does therefore not cleanly apply to 3.9. Options I can see are to ignore
the build error in 3.9, to back-port the patch manually, or to split it into
two separate patches. David, let me know which approach you prefer. 

 drivers/net/ethernet/freescale/fec_main.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a667015..d48099f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -516,6 +516,7 @@ fec_restart(struct net_device *ndev, int duplex)
 	/* Set MII speed */
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
+#if !defined(CONFIG_M5272)
 	/* set RX checksum */
 	val = readl(fep->hwp + FEC_RACC);
 	if (fep->csum_flags & FLAG_RX_CSUM_ENABLED)
@@ -523,6 +524,7 @@ fec_restart(struct net_device *ndev, int duplex)
 	else
 		val &= ~FEC_RACC_OPTIONS;
 	writel(val, fep->hwp + FEC_RACC);
+#endif
 
 	/*
 	 * The phy interface and speed need to get configured
@@ -575,6 +577,7 @@ fec_restart(struct net_device *ndev, int duplex)
 #endif
 	}
 
+#if !defined(CONFIG_M5272)
 	/* enable pause frame*/
 	if ((fep->pause_flag & FEC_PAUSE_FLAG_ENABLE) ||
 	    ((fep->pause_flag & FEC_PAUSE_FLAG_AUTONEG) &&
@@ -592,6 +595,7 @@ fec_restart(struct net_device *ndev, int duplex)
 	} else {
 		rcntl &= ~FEC_ENET_FCE;
 	}
+#endif /* !defined(CONFIG_M5272) */
 
 	writel(rcntl, fep->hwp + FEC_R_CNTRL);
 
@@ -1205,7 +1209,9 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	/* mask with MAC supported features */
 	if (id_entry->driver_data & FEC_QUIRK_HAS_GBIT) {
 		phy_dev->supported &= PHY_GBIT_FEATURES;
+#if !defined(CONFIG_M5272)
 		phy_dev->supported |= SUPPORTED_Pause;
+#endif
 	}
 	else
 		phy_dev->supported &= PHY_BASIC_FEATURES;
@@ -1390,6 +1396,8 @@ static int fec_enet_get_ts_info(struct net_device *ndev,
 	}
 }
 
+#if !defined(CONFIG_M5272)
+
 static void fec_enet_get_pauseparam(struct net_device *ndev,
 				    struct ethtool_pauseparam *pause)
 {
@@ -1436,9 +1444,13 @@ static int fec_enet_set_pauseparam(struct net_device *ndev,
 	return 0;
 }
 
+#endif /* !defined(CONFIG_M5272) */
+
 static const struct ethtool_ops fec_enet_ethtool_ops = {
+#if !defined(CONFIG_M5272)
 	.get_pauseparam		= fec_enet_get_pauseparam,
 	.set_pauseparam		= fec_enet_set_pauseparam,
+#endif
 	.get_settings		= fec_enet_get_settings,
 	.set_settings		= fec_enet_set_settings,
 	.get_drvinfo		= fec_enet_get_drvinfo,
@@ -1874,10 +1886,12 @@ fec_probe(struct platform_device *pdev)
 	/* setup board info structure */
 	fep = netdev_priv(ndev);
 
+#if !defined(CONFIG_M5272)
 	/* default enable pause frame auto negotiation */
 	if (pdev->id_entry &&
 	    (pdev->id_entry->driver_data & FEC_QUIRK_HAS_GBIT))
 		fep->pause_flag |= FEC_PAUSE_FLAG_AUTONEG;
+#endif
 
 	fep->hwp = devm_request_and_ioremap(&pdev->dev, r);
 	fep->pdev = pdev;
-- 
1.7.9.7

