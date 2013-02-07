Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab3BGNov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:44:51 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58421 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab3BGNou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:44:50 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH] NET: ath5k, check ath5k_eeprom_mode_from_channel retval
Date: Thu,  7 Feb 2013 14:44:40 +0100
Message-Id: <1360244680-10370-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It can, if invalid argument given, return a negative value. In that
case we would access arrays out-of-bounds and such. Check the value
and yell loudly if that happened as it would be a bug in the
implementation. (Instead of silently corrupting memory.)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath5k/phy.c   | 4 ++++
 drivers/net/wireless/ath/ath5k/reset.c | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index ab363f3..a78afa9 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1613,6 +1613,10 @@ ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 	ah->ah_cal_mask |= AR5K_CALIBRATION_NF;
 
 	ee_mode = ath5k_eeprom_mode_from_channel(ah->ah_current_channel);
+	if (WARN_ON(ee_mode < 0)) {
+		ah->ah_cal_mask &= ~AR5K_CALIBRATION_NF;
+		return;
+	}
 
 	/* completed NF calibration, test threshold */
 	nf = ath5k_hw_read_measured_noise_floor(ah);
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 4084b10..e2d8b2c 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -985,6 +985,8 @@ ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 		return;
 
 	ee_mode = ath5k_eeprom_mode_from_channel(channel);
+	if (WARN_ON(ee_mode < 0))
+		return;
 
 	/* Adjust power delta for channel 14 */
 	if (channel->center_freq == 2484)
-- 
1.8.1.1


