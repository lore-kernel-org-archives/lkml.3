Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbaLBTiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:38:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46931 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933672AbaLBT0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miaoqing Pan <miaoqing@qca.qualcomm.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 101/121] ath9k: Fix RTC_DERIVED_CLK usage
Date: Tue,  2 Dec 2014 11:19:40 -0800
Message-Id: <1417548000-1794-102-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 13 +++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         | 13 -------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index d39b79f..ea3054c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -646,6 +646,19 @@ static void ar9003_hw_override_ini(struct ath_hw *ah)
 		else
 			ah->enabled_cals &= ~TX_CL_CAL;
 	}
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
index e79a2cf..5e2063f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -923,19 +923,6 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
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
1.9.1

