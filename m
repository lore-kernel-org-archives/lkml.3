Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157Ab3DBXTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:19:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746Ab3DBWMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 012/124] ath9k_hw: revert chainmask to user configuration after calibration
Date: Tue,  2 Apr 2013 15:09:54 -0700
Message-Id: <20130402221105.625026191@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -976,6 +976,7 @@ static bool ar9003_hw_init_cal(struct at
 					  AR_PHY_CL_TAB_1,
 					  AR_PHY_CL_TAB_2 };
 
+	/* Use chip chainmask only for calibration */
 	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
 
 	if (rtt) {
@@ -1131,6 +1132,9 @@ skip_tx_iqcal:
 		ar9003_hw_rtt_disable(ah);
 	}
 
+	/* Revert chainmask to runtime parameters */
+	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
+
 	/* Initialize list pointers */
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 	ah->supp_cals = IQ_MISMATCH_CAL;


