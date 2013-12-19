Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3LSMYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:24:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45093 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3LSL6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 138/208] ath9k: Fix QuickDrop usage
Date: Thu, 19 Dec 2013 11:53:56 +0000
Message-Id: <1387454106-19326-139-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 93c1cfbe598f72cfa7be49e4a7d2a1d482e15119 upstream.

Bit 5 in the miscConfiguration field of the base EEPROM
header denotes whether QuickDrop is enabled or not. Fix
the incorrect usage of BIT(1) and also make sure that
this is done only for the required chips.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d105e43..d3ca712 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3949,18 +3949,20 @@ static void ar9003_hw_quick_drop_apply(struct ath_hw *ah, u16 freq)
 	int quick_drop;
 	s32 t[3], f[3] = {5180, 5500, 5785};
 
-	if (!(pBase->miscConfiguration & BIT(1)))
+	if (!(pBase->miscConfiguration & BIT(4)))
 		return;
 
-	if (freq < 4000)
-		quick_drop = eep->modalHeader2G.quick_drop;
-	else {
-		t[0] = eep->base_ext1.quick_drop_low;
-		t[1] = eep->modalHeader5G.quick_drop;
-		t[2] = eep->base_ext1.quick_drop_high;
-		quick_drop = ar9003_hw_power_interpolate(freq, f, t, 3);
+	if (AR_SREV_9300(ah) || AR_SREV_9580(ah) || AR_SREV_9340(ah)) {
+		if (freq < 4000) {
+			quick_drop = eep->modalHeader2G.quick_drop;
+		} else {
+			t[0] = eep->base_ext1.quick_drop_low;
+			t[1] = eep->modalHeader5G.quick_drop;
+			t[2] = eep->base_ext1.quick_drop_high;
+			quick_drop = ar9003_hw_power_interpolate(freq, f, t, 3);
+		}
+		REG_RMW_FIELD(ah, AR_PHY_AGC, AR_PHY_AGC_QUICK_DROP, quick_drop);
 	}
-	REG_RMW_FIELD(ah, AR_PHY_AGC, AR_PHY_AGC_QUICK_DROP, quick_drop);
 }
 
 static void ar9003_hw_txend_to_xpa_off_apply(struct ath_hw *ah, bool is2ghz)
-- 
1.8.3.2

