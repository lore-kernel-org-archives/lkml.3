Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3BANXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:23:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:44952 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab3BANLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:11:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Robert Shade <robert.shade@gmail.com>, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 41/89] ath9k: disable the tasklet before taking the PCU lock
Date: Fri,  1 Feb 2013 14:07:56 +0100
Message-Id: <20130201130210.458915965@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 4668cce527acb3bd048c5e6c99b157a14b214671 upstream.

Fixes a reported CPU soft lockup where the tasklet tries to acquire the
lock and blocks while ath_prepare_reset (holding the lock) waits for it
to complete.

Reported-by: Robert Shade <robert.shade@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/main.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -195,16 +195,12 @@ static bool ath_prepare_reset(struct ath
 	ath9k_debug_samp_bb_mac(sc);
 	ath9k_hw_disable_interrupts(ah);
 
-	tasklet_disable(&sc->intr_tq);
-
 	if (!ath_stoprecv(sc))
 		ret = false;
 
 	if (!ath_drain_all_txq(sc, retry_tx))
 		ret = false;
 
-	tasklet_enable(&sc->intr_tq);
-
 	return ret;
 }
 
@@ -261,6 +257,7 @@ static int ath_reset_internal(struct ath
 
 	__ath_cancel_work(sc);
 
+	tasklet_disable(&sc->intr_tq);
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	if (!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)) {
@@ -291,6 +288,8 @@ static int ath_reset_internal(struct ath
 
 out:
 	spin_unlock_bh(&sc->sc_pcu_lock);
+	tasklet_enable(&sc->intr_tq);
+
 	return r;
 }
 


