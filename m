Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab3EGEGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:06:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5656 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760142Ab3EGD6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:52 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mj5qnEUBdnkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=fMM5xZ4ndQIA:10 a=n9Sqmae0AAAA:8 a=zhf81SHlAAAA:8 a=J1Y8HTJGAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=z0jh1eRXt18A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=hC5ZD2UgtrxmxLA_:21 a=THf3UCVI8RSW80ry:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035847.260484626@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hayes Wang <hayeswang@realtek.com>, Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [038/126] r8169: fix auto speed down issue
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0038-r8169-fix-auto-speed-down-issue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: hayeswang <hayeswang@realtek.com>

[ Upstream commit e2409d83434d77874b461b78af6a19cd6e6a1280 ]

It would cause no link after suspending or shutdowning when the
nic changes the speed to 10M and connects to a link partner which
forces the speed to 100M.

Check the link partner ability to determine which speed to set.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/realtek/r8169.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 6c1c396..886b52f 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -3827,6 +3827,30 @@ static void __devinit rtl_init_mdio_ops(struct rtl8169_private *tp)
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
@@ -3857,9 +3881,7 @@ static bool rtl_wol_pll_power_down(struct rtl8169_private *tp)
 	if (!(__rtl8169_get_wol(tp) & WAKE_ANY))
 		return false;
 
-	rtl_writephy(tp, 0x1f, 0x0000);
-	rtl_writephy(tp, MII_BMCR, 0x0000);
-
+	rtl_speed_down(tp);
 	rtl_wol_suspend_quirk(tp);
 
 	return true;
-- 
1.7.10.4


