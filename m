Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaGPVFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:05:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:59895 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaGPVFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:05:15 -0400
Message-Id: <20140716205056.789668065@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:05:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [patch V2 54/64] wireless: ath9k: Get rid of timespec conversions
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=wireless-ath9-use-proper-interfaces.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have interfaces. Remove the open coded cruft. Reduces text size
along with the code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: tip/drivers/net/wireless/ath/ath9k/hw.c
===================================================================
--- tip.orig/drivers/net/wireless/ath/ath9k/hw.c
+++ tip/drivers/net/wireless/ath/ath9k/hw.c
@@ -1734,7 +1734,6 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 		   struct ath9k_hw_cal_data *caldata, bool fastcc)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct timespec ts;
 	u32 saveLedState;
 	u32 saveDefAntenna;
 	u32 macStaId1;
@@ -1784,8 +1783,7 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 
 	/* Save TSF before chip reset, a cold reset clears it */
 	tsf = ath9k_hw_gettsf64(ah);
-	getrawmonotonic(&ts);
-	usec = ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000;
+	usec = ktime_to_us(ktime_get_raw());
 
 	saveLedState = REG_READ(ah, AR_CFG_LED) &
 		(AR_CFG_LED_ASSOC_CTL | AR_CFG_LED_MODE_SEL |
@@ -1818,8 +1816,7 @@ int ath9k_hw_reset(struct ath_hw *ah, st
 	}
 
 	/* Restore TSF */
-	getrawmonotonic(&ts);
-	usec = ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000 - usec;
+	usec = ktime_to_us(ktime_get_raw()) - usec;
 	ath9k_hw_settsf64(ah, tsf + usec);
 
 	if (AR_SREV_9280_20_OR_LATER(ah))


