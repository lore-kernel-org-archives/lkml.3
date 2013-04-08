Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965102Ab3DHK0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:26:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42608 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935397Ab3DHJvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 004/102] ath9k_hw: revert chainmask to user configuration after calibration
Date: Mon,  8 Apr 2013 10:49:19 +0100
Message-Id: <1365414657-29191-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 74632d11a133b5baf6b9d622dd19d2f944d93d94 upstream.

The commit 'ath9k_hw: fix calibration issues on chainmask that don't
include chain 0' changed the hardware chainmask to the chip chainmask
for the duration of the calibration, but the revert to user
configuration in the reset path runs too early.

That causes some issues with limiting the number of antennas (including
spurious failure in hardware-generated packets).

Fix this by reverting the chainmask after the essential parts of the
calibration that need the workaround, and before NF calibration is run.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Tested-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 53aeca7..601213d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -910,6 +910,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 					  AR_PHY_CL_TAB_1,
 					  AR_PHY_CL_TAB_2 };
 
+	/* Use chip chainmask only for calibration */
 	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
 
 	if (rtt) {
@@ -1057,6 +1058,9 @@ skip_tx_iqcal:
 		ar9003_hw_rtt_disable(ah);
 	}
 
+	/* Revert chainmask to runtime parameters */
+	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
+
 	/* Initialize list pointers */
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 	ah->supp_cals = IQ_MISMATCH_CAL;
-- 
1.8.1.2

