Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab3KIHDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:03:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab3KIGwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.11 20/94] ath9k: fix tx queue scheduling after channel changes
Date: Fri,  8 Nov 2013 22:51:26 -0800
Message-Id: <20131109065205.668659943@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit ec30326ea773900da210c495e14cfeb532550ba2 upstream.

Otherwise, if queues are full during a scan, tx scheduling does not
resume after switching back to the home channel.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/main.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -208,6 +208,7 @@ static bool ath_complete_reset(struct at
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	unsigned long flags;
+	int i;
 
 	if (ath_startrecv(sc) != 0) {
 		ath_err(common, "Unable to restart recv logic\n");
@@ -235,6 +236,15 @@ static bool ath_complete_reset(struct at
 		}
 	work:
 		ath_restart_work(sc);
+
+		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+			if (!ATH_TXQ_SETUP(sc, i))
+				continue;
+
+			spin_lock_bh(&sc->tx.txq[i].axq_lock);
+			ath_txq_schedule(sc, &sc->tx.txq[i]);
+			spin_unlock_bh(&sc->tx.txq[i].axq_lock);
+		}
 	}
 
 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) && sc->ant_rx != 3)
@@ -542,21 +552,10 @@ chip_reset:
 
 static int ath_reset(struct ath_softc *sc)
 {
-	int i, r;
+	int r;
 
 	ath9k_ps_wakeup(sc);
-
 	r = ath_reset_internal(sc, NULL);
-
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (!ATH_TXQ_SETUP(sc, i))
-			continue;
-
-		spin_lock_bh(&sc->tx.txq[i].axq_lock);
-		ath_txq_schedule(sc, &sc->tx.txq[i]);
-		spin_unlock_bh(&sc->tx.txq[i].axq_lock);
-	}
-
 	ath9k_ps_restore(sc);
 
 	return r;


