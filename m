Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab3DOCSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:18:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933512Ab3DOCSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:18:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 11/11] r8169: fix auto speed down issue
Date: Sun, 14 Apr 2013 19:17:43 -0700
Message-Id: <20130415020614.910439053@linuxfoundation.org>
X-Mailer: git-send-email 1.8.2.1.368.g99c2266
In-Reply-To: <20130415020614.067692418@linuxfoundation.org>
References: <20130415020614.067692418@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hayes Wang <hayeswang@realtek.com>

commit e2409d83434d77874b461b78af6a19cd6e6a1280 upstream.

It would cause no link after suspending or shutdowning when the
nic changes the speed to 10M and connects to a link partner which
forces the speed to 100M.

Check the link partner ability to determine which speed to set.

The link speed down code path is not factored in this kernel version.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3105,11 +3105,34 @@ static void r810x_phy_power_up(struct rt
 	rtl_writephy(tp, MII_BMCR, BMCR_ANENABLE);
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
 static void r810x_pll_power_down(struct rtl8169_private *tp)
 {
 	if (__rtl8169_get_wol(tp) & WAKE_ANY) {
-		rtl_writephy(tp, 0x1f, 0x0000);
-		rtl_writephy(tp, MII_BMCR, 0x0000);
+		rtl_speed_down(tp);
 		return;
 	}
 
@@ -3201,8 +3224,7 @@ static void r8168_pll_power_down(struct
 		rtl_ephy_write(ioaddr, 0x19, 0xff64);
 
 	if (__rtl8169_get_wol(tp) & WAKE_ANY) {
-		rtl_writephy(tp, 0x1f, 0x0000);
-		rtl_writephy(tp, MII_BMCR, 0x0000);
+		rtl_speed_down(tp);
 
 		if (tp->mac_version == RTL_GIGA_MAC_VER_32 ||
 		    tp->mac_version == RTL_GIGA_MAC_VER_33)


