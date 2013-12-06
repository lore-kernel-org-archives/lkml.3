Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161935Ab3LFNE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:04:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44526 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161860Ab3LFNEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
        Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 203/272] ath5k: fix regression in tx status processing
Date: Fri,  6 Dec 2013 12:58:12 +0000
Message-Id: <1386334761-25517-204-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 7ede612fd615abcda0cc30e5bef2a70f4cf4f75c upstream.

The regression was introduced in the following commit:

0967e01e8e713ed2982fb4eba8ba13794e9a6e89
"ath5k: make use of the new rate control API"

ath5k_tx_frame_completed saves the intended per-rate retry counts before
they are cleared by ieee80211_tx_info_clear_status, however at this
point the information in info->status.rates is incomplete.

This causes significant throughput degradation and excessive packet loss
on links where high bit rates don't work properly.

Move the copy from bf->rates a few lines up to ensure that the saved
retry counts are updated, and that they are really cleared in
info->status.rates after the call to ieee80211_tx_info_clear_status.

Cc: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
Reported-by: Ben West <ben@gowasabi.net>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath5k/base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ce67ab7..644f40a 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1628,15 +1628,15 @@ ath5k_tx_frame_completed(struct ath5k_hw *ah, struct sk_buff *skb,
 	ah->stats.tx_bytes_count += skb->len;
 	info = IEEE80211_SKB_CB(skb);
 
+	size = min_t(int, sizeof(info->status.rates), sizeof(bf->rates));
+	memcpy(info->status.rates, bf->rates, size);
+
 	tries[0] = info->status.rates[0].count;
 	tries[1] = info->status.rates[1].count;
 	tries[2] = info->status.rates[2].count;
 
 	ieee80211_tx_info_clear_status(info);
 
-	size = min_t(int, sizeof(info->status.rates), sizeof(bf->rates));
-	memcpy(info->status.rates, bf->rates, size);
-
 	for (i = 0; i < ts->ts_final_idx; i++) {
 		struct ieee80211_tx_rate *r =
 			&info->status.rates[i];
-- 
1.8.3.2

