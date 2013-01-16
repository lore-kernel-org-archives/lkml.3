Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab3APQD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:03:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36094 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab3APQDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 093/222] ath9k_hw: Fix signal strength / channel noise reporting
Date: Wed, 16 Jan 2013 13:54:53 -0200
Message-Id: <1358351822-7675-94-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    1 +
 drivers/net/wireless/ath/ath9k/calib.h |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index e5cceb0..bbd249d 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -69,6 +69,7 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	if (chan && chan->noisefloor) {
 		s8 delta = chan->noisefloor -
+			   ATH9K_NF_CAL_NOISE_THRESH -
 			   ath9k_hw_get_default_nf(ah, chan);
 		if (delta > 0)
 			noise += delta;
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 3b33996d..1f2e01a 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -21,6 +21,9 @@
 
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
 
+/* Internal noise floor can vary by about 6db depending on the frequency */
+#define ATH9K_NF_CAL_NOISE_THRESH		6
+
 #define NUM_NF_READINGS       6
 #define ATH9K_NF_CAL_HIST_MAX 5
 
-- 
1.7.9.5

