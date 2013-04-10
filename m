Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937584Ab3DJXFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:05:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937373Ab3DJWro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 59/64] r8169: fix auto speed down issue
Date: Wed, 10 Apr 2013 15:46:56 -0700
Message-Id: <20130410224347.270181379@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/ethernet/realtek/r8169.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3819,6 +3819,30 @@ static void rtl_init_mdio_ops(struct rtl
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
@@ -3849,9 +3873,7 @@ static bool rtl_wol_pll_power_down(struc
 	if (!(__rtl8169_get_wol(tp) & WAKE_ANY))
 		return false;
 
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_writephy(tp, MII_BMCR, 0x0000);
-
+	rtl_speed_down(tp);
 	rtl_wol_suspend_quirk(tp);
 
 	return true;


