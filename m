Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422730Ab3DKU6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:58:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4488 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab3DKUt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:26 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=pytiCdr0SAoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=rH7wUZFSSFUA:10 a=jdP34snFAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=9mtjllxcxZAA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=bfIiM119Wfjz2aJ3:21 a=L5Hi_1EweutmN2L3:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202559.630653550@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 082/171 ] ath9k: limit tx path hang check to normal data queues
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0082-ath9k-limit-tx-path-hang-check-to-normal-data-queues.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

[ Upstream commit 01d4ab96d2e7fceaad204e5a8710ce34e229b8c5 ]

The beacon and multicast-buffer queues are managed by the beacon
tasklet, and the generic tx path hang check does not help in any way
here. Running it on those queues anyway can introduce some race
conditions leading to unnecessary chip resets.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/ath9k/link.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 7b88b9c..62b58ba 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -31,21 +31,21 @@ void ath_tx_complete_poll_work(struct work_struct *work)
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
1.7.10.4


