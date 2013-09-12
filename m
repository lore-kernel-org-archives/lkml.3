Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3ILSCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:02:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57146 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab3ILR70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 38/46] tg3: Dont turn off led on 5719 serdes port 0
Date: Thu, 12 Sep 2013 10:58:49 -0700
Message-Id: <20130912175725.110808054@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

[ Upstream commit 989038e217e94161862a959e82f9a1ecf8dda152 ]

Turning off led on port 0 of the 5719 serdes causes all other ports to
lose power and stop functioning. Add tg3_phy_led_bug() function to check
for this condition. We use a switch() in tg3_phy_led_bug() for
consistency with the tg3_phy_power_bug() function.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -3003,6 +3003,19 @@ static bool tg3_phy_power_bug(struct tg3
 	return false;
 }
 
+static bool tg3_phy_led_bug(struct tg3 *tp)
+{
+	switch (tg3_asic_rev(tp)) {
+	case ASIC_REV_5719:
+		if ((tp->phy_flags & TG3_PHYFLG_MII_SERDES) &&
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
@@ -3050,8 +3063,9 @@ static void tg3_power_down_phy(struct tg
 		}
 		return;
 	} else if (do_low_power) {
-		tg3_writephy(tp, MII_TG3_EXT_CTRL,
-			     MII_TG3_EXT_CTRL_FORCE_LED_OFF);
+		if (!tg3_phy_led_bug(tp))
+			tg3_writephy(tp, MII_TG3_EXT_CTRL,
+				     MII_TG3_EXT_CTRL_FORCE_LED_OFF);
 
 		val = MII_TG3_AUXCTL_PCTL_100TX_LPWR |
 		      MII_TG3_AUXCTL_PCTL_SPR_ISOLATE |


