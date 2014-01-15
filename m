Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbaAOWka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:40:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40711 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaAOVxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:24 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 014/166] ath9k: Fix QuickDrop usage
Date: Wed, 15 Jan 2014 13:50:28 -0800
Message-Id: <1389822780-4729-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 93c1cfbe598f72cfa7be49e4a7d2a1d482e15119 upstream.

Bit 5 in the miscConfiguration field of the base EEPROM
header denotes whether QuickDrop is enabled or not. Fix
the incorrect usage of BIT(1) and also make sure that
this is done only for the required chips.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 92e761a..5fcc943e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3920,18 +3920,20 @@ static void ar9003_hw_quick_drop_apply(struct ath_hw *ah, u16 freq)
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

