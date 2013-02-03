Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3BCO5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:57:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34449 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294Ab3BCO50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:26 -0500
Message-Id: <20130203144651.705733776@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 086/128] ath9k_hw: fix chain swap setting when setting rx chainmask to 5
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 24171dd92096fc370b195f3f6bdc0798855dc3f9 upstream.

Chain swapping should only be enabled when the EEPROM chainmask is set to 5,
regardless of what the runtime chainmask is.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: keep the special case for AR_SREV_9462 here]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -543,33 +543,20 @@ static void ar9003_hw_init_bb(struct ath
 
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
+
+	REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx);
+	REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx);
 
 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && (tx == 0x7))
-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
+		tx = 3;
 	else if (AR_SREV_9462(ah))
 		/* xxx only when MCI support is enabled */
-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x3);
-	else
-		REG_WRITE(ah, AR_SELFGEN_MASK, tx);
+		tx = 3;
 
-	if (tx == 0x5) {
-		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
-			    AR_PHY_SWAP_ALT_CHAIN);
-	}
+	REG_WRITE(ah, AR_SELFGEN_MASK, tx);
 }
 
 /*


