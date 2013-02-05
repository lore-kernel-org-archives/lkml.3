Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3BEWKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:10:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48049 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab3BEWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:30 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 46/93] ath9k_hw: fix chain swap setting when setting rx chainmask to 5
Date: Tue,  5 Feb 2013 20:06:35 -0200
Message-Id: <1360102042-10732-47-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 24171dd92096fc370b195f3f6bdc0798855dc3f9 upstream.

Chain swapping should only be enabled when the EEPROM chainmask is set to 5,
regardless of what the runtime chainmask is.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ herton: keep AR_SREV_9462(ah) conditional assignment (tx = 3),
  present on 3.5 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   31 +++++++--------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index b490b16..ac2aa7a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -534,33 +534,18 @@ static void ar9003_hw_init_bb(struct ath_hw *ah,
 
 void ar9003_hw_set_chain_masks(struct ath_hw *ah, u8 rx, u8 tx)
 {
-	switch (rx) {
-	case 0x5:
+	if (ah->caps.tx_chainmask == 5 || ah->caps.rx_chainmask == 5)
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
-	case 0x3:
-	case 0x1:
-	case 0x2:
-	case 0x7:
-		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx);
-		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx);
-		break;
-	default:
-		break;
-	}
 
-	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
-	else if (AR_SREV_9462(ah))
-		/* xxx only when MCI support is enabled */
-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
-	else
-		REG_WRITE(ah, AR_SELFGEN_MASK, tx);
+	REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx);
+	REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx);
 
-	if (tx == 0x5) {
-		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
-			    AR_PHY_SWAP_ALT_CHAIN);
-	}
+	if (((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7)) ||
+	    AR_SREV_9462(ah))
+		tx = 3;
+
+	REG_WRITE(ah, AR_SELFGEN_MASK, tx);
 }
 
 /*
-- 
1.7.9.5

