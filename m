Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab3DVOs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:48:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51439 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532Ab3DVO3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "hayeswang" <hayeswang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Francois Romieu" <romieu@fr.zoreil.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.648364723@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [67/75] r8169: fix auto speed down issue
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: hayeswang <hayeswang@realtek.com>

commit e2409d83434d77874b461b78af6a19cd6e6a1280 upstream.

It would cause no link after suspending or shutdowning when the
nic changes the speed to 10M and connects to a link partner which
forces the speed to 100M.

Check the link partner ability to determine which speed to set.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3516,6 +3516,30 @@ static void __devinit rtl_init_mdio_ops(
 	}
 }
 
+static void rtl_speed_down(struct rtl8169_private *tp)
+{
+	u32 adv;
+	int lpa;
+
+	rtl_writephy(tp, 0x1f, 0x0000);
+	lpa = rtl_readphy(tp, MII_LPA);
+
+	if (lpa & (LPA_10HALF | LPA_10FULL))
+		adv = ADVERTISED_10baseT_Half | ADVERTISED_10baseT_Full;
+	else if (lpa & (LPA_100HALF | LPA_100FULL))
+		adv = ADVERTISED_10baseT_Half | ADVERTISED_10baseT_Full |
+		      ADVERTISED_100baseT_Half | ADVERTISED_100baseT_Full;
+	else
+		adv = ADVERTISED_10baseT_Half | ADVERTISED_10baseT_Full |
+		      ADVERTISED_100baseT_Half | ADVERTISED_100baseT_Full |
+		      (tp->mii.supports_gmii ?
+		       ADVERTISED_1000baseT_Half |
+		       ADVERTISED_1000baseT_Full : 0);
+
+	rtl8169_set_speed(tp->dev, AUTONEG_ENABLE, SPEED_1000, DUPLEX_FULL,
+			  adv);
+}
+
 static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 {
 	void __iomem *ioaddr = tp->mmio_addr;
@@ -3541,9 +3565,7 @@ static bool rtl_wol_pll_power_down(struc
 	if (!(__rtl8169_get_wol(tp) & WAKE_ANY))
 		return false;
 
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_writephy(tp, MII_BMCR, 0x0000);
-
+	rtl_speed_down(tp);
 	rtl_wol_suspend_quirk(tp);
 
 	return true;

