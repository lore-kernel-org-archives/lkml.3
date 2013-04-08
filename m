Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149Ab3DHK0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:26:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42607 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935394Ab3DHJvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 005/102] ath9k: limit tx path hang check to normal data queues
Date: Mon,  8 Apr 2013 10:49:20 +0100
Message-Id: <1365414657-29191-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 01d4ab96d2e7fceaad204e5a8710ce34e229b8c5 upstream.

The beacon and multicast-buffer queues are managed by the beacon
tasklet, and the generic tx path hang check does not help in any way
here. Running it on those queues anyway can introduce some race
conditions leading to unnecessary chip resets.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ luis: backported to 3.5:
  - file rename link.c -> xmit.c
  - adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 12a42f2..894ed0e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2258,21 +2258,21 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 	sc->tx_complete_poll_work_seen++;
 #endif
 
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
-		if (ATH_TXQ_SETUP(sc, i)) {
-			txq = &sc->tx.txq[i];
-			ath_txq_lock(sc, txq);
-			if (txq->axq_depth) {
-				if (txq->axq_tx_inprogress) {
-					needreset = true;
-					ath_txq_unlock(sc, txq);
-					break;
-				} else {
-					txq->axq_tx_inprogress = true;
-				}
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		txq = sc->tx.txq_map[i];
+
+		ath_txq_lock(sc, txq);
+		if (txq->axq_depth) {
+			if (txq->axq_tx_inprogress) {
+				needreset = true;
+				ath_txq_unlock(sc, txq);
+				break;
+			} else {
+				txq->axq_tx_inprogress = true;
 			}
-			ath_txq_unlock_complete(sc, txq);
 		}
+		ath_txq_unlock_complete(sc, txq);
+	}
 
 	if (needreset) {
 		ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
-- 
1.8.1.2

