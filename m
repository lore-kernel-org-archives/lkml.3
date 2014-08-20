Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaHTMJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:09:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58893 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 004/104] ath9k: fix aggregation session lockup
Date: Wed, 20 Aug 2014 13:42:27 +0200
Message-Id: <f97dcfbb2d1d5664b4c523470f3fe587c7c8a439.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 7514b1ad9abd..d92c6ff461dc 100644
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
2.0.4

