Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab3JJPti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:49:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52967 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3JJPtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 025/104] tg3: Don't turn off led on 5719 serdes port 0
Date: Thu, 10 Oct 2013 08:41:13 -0700
Message-Id: <1381419752-29733-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 929a092..0ffe6c0 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -2921,6 +2921,19 @@ static bool tg3_phy_power_bug(struct tg3 *tp)
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
@@ -2965,8 +2978,9 @@ static void tg3_power_down_phy(struct tg3 *tp, bool do_low_power)
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
1.8.1.2

