Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab3GCS5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:57:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195Ab3GCSkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:53 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ChK0g7mSOJ0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4Rn1qNAdJHgA:10 a=Q-fNiiVtAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=pQFG53Joc4AfjvbZiugA:9 a=lcTMV_K9oDIA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184047.628899435@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Chan <mchan@broadcom.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [018/141] tg3: Skip powering down function 0 on certain serdes devices
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0018-tg3-Skip-powering-down-function-0-on-certain-serdes-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

[ Upstream commit 44f3b503c16425c8e9db4bbaa2fc9cd0c9d0ba91 ]

On the 5718, 5719 and 5720 serdes devices, powering down function 0
results in all the other ports being powered down. Add code to skip
function 0 power down.

v2:
 - Modify tg3_phy_power_bug() function to use a switch instead of a
   complicated if statement. Suggested by Joe Perches.

Cc: <stable@vger.kernel.org>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/broadcom/tg3.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index fbc21a9..f0f26b0 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -2847,6 +2847,31 @@ static int tg3_5700_link_polarity(struct tg3 *tp, u32 speed)
 	return 0;
 }
 
+static bool tg3_phy_power_bug(struct tg3 *tp)
+{
+	switch (GET_ASIC_REV(tp->pci_chip_rev_id)) {
+	case ASIC_REV_5700:
+	case ASIC_REV_5704:
+		return true;
+	case ASIC_REV_5780:
+		if (tp->phy_flags & TG3_PHYFLG_MII_SERDES)
+			return true;
+		return false;
+	case ASIC_REV_5717:
+		if (!tp->pci_fn)
+			return true;
+		return false;
+	case ASIC_REV_5719:
+	case ASIC_REV_5720:
+		if ((tp->phy_flags & TG3_PHYFLG_PHY_SERDES) &&
+		    !tp->pci_fn)
+			return true;
+		return false;
+	}
+
+	return false;
+}
+
 static void tg3_power_down_phy(struct tg3 *tp, bool do_low_power)
 {
 	u32 val;
@@ -2903,12 +2928,7 @@ static void tg3_power_down_phy(struct tg3 *tp, bool do_low_power)
 	/* The PHY should not be powered down on some chips because
 	 * of bugs.
 	 */
-	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5700 ||
-	    GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5704 ||
-	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5780 &&
-	     (tp->phy_flags & TG3_PHYFLG_MII_SERDES)) ||
-	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5717 &&
-	     !tp->pci_fn))
+	if (tg3_phy_power_bug(tp))
 		return;
 
 	if (GET_CHIP_REV(tp->pci_chip_rev_id) == CHIPREV_5784_AX ||
-- 
1.7.10.4


