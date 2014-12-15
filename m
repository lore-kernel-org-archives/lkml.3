Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaLOPP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:15:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38276 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbaLOO1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miaoqing Pan <miaoqing@qca.qualcomm.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 023/168] ath9k: Fix RTC_DERIVED_CLK usage
Date: Mon, 15 Dec 2014 14:24:37 +0000
Message-Id: <1418653622-21105-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 13 +++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         | 13 -------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 8927fc34d84c..b81f885aa68c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -647,6 +647,19 @@ static void ar9003_hw_override_ini(struct ath_hw *ah)
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
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2a8ed8375ec0..e1e2bf3b0051 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -858,19 +858,6 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
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
-- 
2.1.3

