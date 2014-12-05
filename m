Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaLEX0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:26:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaLEW4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miaoqing Pan <miaoqing@qca.qualcomm.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.14 28/73] ath9k: Fix RTC_DERIVED_CLK usage
Date: Fri,  5 Dec 2014 14:44:34 -0800
Message-Id: <20141205224434.788414246@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

commit 4e6ce4dc7ce71d0886908d55129d5d6482a27ff9 upstream.

Based on the reference clock, which could be 25MHz or 40MHz,
AR_RTC_DERIVED_CLK is programmed differently for AR9340 and AR9550.
But, when a chip reset is done, processing the initvals
sets the register back to the default value.

Fix this by moving the code in ath9k_hw_init_pll() to
ar9003_hw_override_ini(). Also, do this override for AR9531.

Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   13 +++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |   13 -------------
 2 files changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -647,6 +647,19 @@ static void ar9003_hw_override_ini(struc
 		ah->enabled_cals |= TX_CL_CAL;
 	else
 		ah->enabled_cals &= ~TX_CL_CAL;
+
+	if (AR_SREV_9340(ah) || AR_SREV_9531(ah) || AR_SREV_9550(ah)) {
+		if (ah->is_clk_25mhz) {
+			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x17c << 1);
+			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f3d7);
+			REG_WRITE(ah, AR_SLP32_INC, 0x0001e7ae);
+		} else {
+			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x261 << 1);
+			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f400);
+			REG_WRITE(ah, AR_SLP32_INC, 0x0001e800);
+		}
+		udelay(100);
+	}
 }
 
 static void ar9003_hw_prog_ini(struct ath_hw *ah,
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -858,19 +858,6 @@ static void ath9k_hw_init_pll(struct ath
 	udelay(RTC_PLL_SETTLE_DELAY);
 
 	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
-
-	if (AR_SREV_9340(ah) || AR_SREV_9550(ah)) {
-		if (ah->is_clk_25mhz) {
-			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x17c << 1);
-			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f3d7);
-			REG_WRITE(ah,  AR_SLP32_INC, 0x0001e7ae);
-		} else {
-			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x261 << 1);
-			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f400);
-			REG_WRITE(ah,  AR_SLP32_INC, 0x0001e800);
-		}
-		udelay(100);
-	}
 }
 
 static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,


