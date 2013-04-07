Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516Ab3DGXZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:25:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46544 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934498Ab3DGXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:25:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Felix Fietkau" <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Wojciech Dubowik" <Wojciech.Dubowik@neratec.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.922289451@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [17/74] ath9k_hw: revert chainmask to user configuration after
 calibration
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -946,6 +946,7 @@ static bool ar9003_hw_init_cal(struct at
 					  AR_PHY_CL_TAB_1,
 					  AR_PHY_CL_TAB_2 };
 
+	/* Use chip chainmask only for calibration */
 	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
 
 	if (rtt) {
@@ -1087,6 +1088,9 @@ skip_tx_iqcal:
 		ar9003_hw_rtt_disable(ah);
 	}
 
+	/* Revert chainmask to runtime parameters */
+	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
+
 	/* Initialize list pointers */
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 	ah->supp_cals = IQ_MISMATCH_CAL;

