Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3LRViP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:38:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36367 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab3LRVN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 049/118] ath9k: Fix QuickDrop usage
Date: Wed, 18 Dec 2013 13:11:26 -0800
Message-Id: <20131218211220.859351714@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 93c1cfbe598f72cfa7be49e4a7d2a1d482e15119 upstream.

Bit 5 in the miscConfiguration field of the base EEPROM
header denotes whether QuickDrop is enabled or not. Fix
the incorrect usage of BIT(1) and also make sure that
this is done only for the required chips.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3966,18 +3966,20 @@ static void ar9003_hw_quick_drop_apply(s
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


