Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab3AOWqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:46:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:45053 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab3AOWqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:46:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 014/171] ath9k_hw: Fix signal strength / channel noise reporting
Date: Tue, 15 Jan 2013 14:42:59 -0800
Message-Id: <20130115224314.434336086@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit b7c0c238898d200e80487516e2b67aba2a522cc0 upstream.

While AR_PHY_CCA_NOM_VAL_* does contain the expected internal noise floor
for a chip measured in clean air, it refers to the lowest expected reading.

Depending on the frequency, this measurement can vary by about 6db, thus
causing a higher reported channel noise and signal strength.

Factor in the 6db offset when converting internal noisefloor to channel noise.

This patch makes the reported values more accurate for all chips without
affecting NF calibration behavior.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/calib.c |    1 +
 drivers/net/wireless/ath/ath9k/calib.h |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -69,6 +69,7 @@ s16 ath9k_hw_getchan_noise(struct ath_hw
 
 	if (chan && chan->noisefloor) {
 		s8 delta = chan->noisefloor -
+			   ATH9K_NF_CAL_NOISE_THRESH -
 			   ath9k_hw_get_default_nf(ah, chan);
 		if (delta > 0)
 			noise += delta;
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -21,6 +21,9 @@
 
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
 
+/* Internal noise floor can vary by about 6db depending on the frequency */
+#define ATH9K_NF_CAL_NOISE_THRESH		6
+
 #define NUM_NF_READINGS       6
 #define ATH9K_NF_CAL_HIST_MAX 5
 


