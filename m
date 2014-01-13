Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaAMOuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:50:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51367 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaAMO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 44/96] ath9k: Fix interrupt handling for the AR9002 family
Date: Mon, 13 Jan 2014 14:24:07 +0000
Message-Id: <1389623099-18783-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 73f0b56a1ff64e7fb6c3a62088804bab93bcedc2 upstream.

This patch adds a driver workaround for a HW issue.

A race condition in the HW results in missing interrupts,
which can be avoided by a read/write with the ISR register.
All chips in the AR9002 series are affected by this bug - AR9003
and above do not have this problem.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c | 52 ++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 8d78253..a366d6b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -76,9 +76,16 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 				mask2 |= ATH9K_INT_CST;
 			if (isr2 & AR_ISR_S2_TSFOOR)
 				mask2 |= ATH9K_INT_TSFOOR;
+
+			if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+				REG_WRITE(ah, AR_ISR_S2, isr2);
+				isr &= ~AR_ISR_BCNMISC;
+			}
 		}
 
-		isr = REG_READ(ah, AR_ISR_RAC);
+		if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)
+			isr = REG_READ(ah, AR_ISR_RAC);
+
 		if (isr == 0xffffffff) {
 			*masked = 0;
 			return false;
@@ -97,11 +104,23 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 
 			*masked |= ATH9K_INT_TX;
 
-			s0_s = REG_READ(ah, AR_ISR_S0_S);
+			if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED) {
+				s0_s = REG_READ(ah, AR_ISR_S0_S);
+				s1_s = REG_READ(ah, AR_ISR_S1_S);
+			} else {
+				s0_s = REG_READ(ah, AR_ISR_S0);
+				REG_WRITE(ah, AR_ISR_S0, s0_s);
+				s1_s = REG_READ(ah, AR_ISR_S1);
+				REG_WRITE(ah, AR_ISR_S1, s1_s);
+
+				isr &= ~(AR_ISR_TXOK |
+					 AR_ISR_TXDESC |
+					 AR_ISR_TXERR |
+					 AR_ISR_TXEOL);
+			}
+
 			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
 			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
-
-			s1_s = REG_READ(ah, AR_ISR_S1_S);
 			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
 			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
 		}
@@ -114,13 +133,15 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		*masked |= mask2;
 	}
 
-	if (AR_SREV_9100(ah))
-		return true;
-
-	if (isr & AR_ISR_GENTMR) {
+	if (!AR_SREV_9100(ah) && (isr & AR_ISR_GENTMR)) {
 		u32 s5_s;
 
-		s5_s = REG_READ(ah, AR_ISR_S5_S);
+		if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED) {
+			s5_s = REG_READ(ah, AR_ISR_S5_S);
+		} else {
+			s5_s = REG_READ(ah, AR_ISR_S5);
+		}
+
 		ah->intr_gen_timer_trigger =
 				MS(s5_s, AR_ISR_S5_GENTIMER_TRIG);
 
@@ -133,8 +154,21 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 		if ((s5_s & AR_ISR_S5_TIM_TIMER) &&
 		    !(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 			*masked |= ATH9K_INT_TIM_TIMER;
+
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+			REG_WRITE(ah, AR_ISR_S5, s5_s);
+			isr &= ~AR_ISR_GENTMR;
+		}
 	}
 
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
+		REG_WRITE(ah, AR_ISR, isr);
+		REG_READ(ah, AR_ISR);
+	}
+
+	if (AR_SREV_9100(ah))
+		return true;
+
 	if (sync_cause) {
 		ath9k_debug_sync_cause(common, sync_cause);
 		fatal_int =
-- 
1.8.3.2

