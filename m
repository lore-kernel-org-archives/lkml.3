Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853Ab3CLWoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:44:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3CLWoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 15/40] ath9k_hw: improve reset reliability after errors
Date: Tue, 12 Mar 2013 15:43:36 -0700
Message-Id: <20130312223213.119025034@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223211.492954675@linuxfoundation.org>
References: <20130312223211.492954675@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/hw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1404,7 +1404,9 @@ static bool ath9k_hw_chip_reset(struct a
 			reset_type = ATH9K_RESET_POWER_ON;
 		else
 			reset_type = ATH9K_RESET_COLD;
-	}
+	} else if (ah->chip_fullsleep || REG_READ(ah, AR_Q_TXE) ||
+		   (REG_READ(ah, AR_CR) & AR_CR_RXE))
+		reset_type = ATH9K_RESET_COLD;
 
 	if (!ath9k_hw_set_reset_reg(ah, reset_type))
 		return false;


