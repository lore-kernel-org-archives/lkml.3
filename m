Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3BEWKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:10:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48010 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab3BEWKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:05 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 39/93] ath9k: disable the tasklet before taking the PCU lock
Date: Tue,  5 Feb 2013 20:06:28 -0200
Message-Id: <1360102042-10732-40-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 4668cce527acb3bd048c5e6c99b157a14b214671 upstream.

Fixes a reported CPU soft lockup where the tasklet tries to acquire the
lock and blocks while ath_prepare_reset (holding the lock) waits for it
to complete.

Reported-by: Robert Shade <robert.shade@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e5c9575..68dd853 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -250,16 +250,12 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
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
 
@@ -321,6 +317,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 
 	__ath_cancel_work(sc);
 
+	tasklet_disable(&sc->intr_tq);
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	if (!(sc->sc_flags & SC_OP_OFFCHANNEL)) {
@@ -351,6 +348,8 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 
 out:
 	spin_unlock_bh(&sc->sc_pcu_lock);
+	tasklet_enable(&sc->intr_tq);
+
 	return r;
 }
 
-- 
1.7.9.5

