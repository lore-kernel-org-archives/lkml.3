Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3LBUFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:05:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3LBTRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
        Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>,
        Ben West <ben@gowasabi.net>, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 079/212] ath5k: fix regression in tx status processing
Date: Mon,  2 Dec 2013 11:14:30 -0800
Message-Id: <20131202191256.584735994@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath5k/base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1663,15 +1663,15 @@ ath5k_tx_frame_completed(struct ath5k_hw
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


