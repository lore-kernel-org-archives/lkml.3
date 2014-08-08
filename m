Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbaHHUwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:52:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41171 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716AbaHHUwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:52:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 185/259] ath9k: fix aggregation session lockup
Date: Fri,  8 Aug 2014 13:40:08 -0700
Message-Id: <1407530482-4483-186-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit c01fac1c77a00227f706a1654317023e3f4ac7f0 upstream.

If an aggregation session fails, frames still end up in the driver queue
with IEEE80211_TX_CTL_AMPDU set.
This causes tx for the affected station/tid to stall, since
ath_tx_get_tid_subframe returning packets to send.

Fix this by clearing IEEE80211_TX_CTL_AMPDU as long as no aggregation
session is running.

Reported-by: Antonio Quartulli <antonio@open-mesh.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 6fa2d35..62744cb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -904,6 +904,15 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 
 		tx_info = IEEE80211_SKB_CB(skb);
 		tx_info->flags &= ~IEEE80211_TX_CTL_CLEAR_PS_FILT;
+
+		/*
+		 * No aggregation session is running, but there may be frames
+		 * from a previous session or a failed attempt in the queue.
+		 * Send them out as normal data frames
+		 */
+		if (!tid->active)
+			tx_info->flags &= ~IEEE80211_TX_CTL_AMPDU;
+
 		if (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) {
 			bf->bf_state.bf_type = 0;
 			return bf;
-- 
1.9.1

