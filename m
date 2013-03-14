Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3CNKh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51981 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3CNKhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 56/88] ath9k_hw: improve reset reliability after errors
Date: Thu, 14 Mar 2013 10:35:49 +0000
Message-Id: <1363257381-15900-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 3412f2f086ea7531378fabe756bd4a1109994ae6 upstream.

On many different chips, important aspects of the MAC state are not
fully cleared by a warm reset. This can show up as tx/rx hangs, those
annoying "DMA failed to stop in 10 ms..." messages or other quirks.

On AR933x, the chip can occasionally get stuck in a way that only a
driver unload/reload or a reboot would bring it back to life.

With this patch, a full reset is issued when bringing the chip out of
FULL-SLEEP state (after idle), or if either Rx or Tx was not shut down
properly. This makes the DMA related error messages disappear completely
in my tests on AR933x, and the chip does not get stuck anymore.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 988b1f3..6333166 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1472,7 +1472,9 @@ static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 			reset_type = ATH9K_RESET_POWER_ON;
 		else
 			reset_type = ATH9K_RESET_COLD;
-	}
+	} else if (ah->chip_fullsleep || REG_READ(ah, AR_Q_TXE) ||
+		   (REG_READ(ah, AR_CR) & AR_CR_RXE))
+		reset_type = ATH9K_RESET_COLD;
 
 	if (!ath9k_hw_set_reset_reg(ah, reset_type))
 		return false;
-- 
1.8.1.2

