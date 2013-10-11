Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab3JKKmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:42:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58451 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785Ab3JKKmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 026/100] tg3: Don't turn off led on 5719 serdes port 0
Date: Fri, 11 Oct 2013 11:40:56 +0100
Message-Id: <1381488130-30235-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

commit 989038e217e94161862a959e82f9a1ecf8dda152 upstream.

Turning off led on port 0 of the 5719 serdes causes all other ports to
lose power and stop functioning. Add tg3_phy_led_bug() function to check
for this condition. We use a switch() in tg3_phy_led_bug() for
consistency with the tg3_phy_power_bug() function.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5:
  - use GET_ASIC_REV() macro instead of tg3_asic_rev() ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 504b4f0..5e01182 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -2783,6 +2783,19 @@ static bool tg3_phy_power_bug(struct tg3 *tp)
 	return false;
 }
 
+static bool tg3_phy_led_bug(struct tg3 *tp)
+{
+	switch (GET_ASIC_REV(tp->pci_chip_rev_id)) {
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
@@ -2827,8 +2840,9 @@ static void tg3_power_down_phy(struct tg3 *tp, bool do_low_power)
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
-- 
1.8.3.2

