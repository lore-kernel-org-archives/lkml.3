Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbaHES17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:27:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbaHESOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antonio Quartulli <antonio@open-mesh.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.14 06/39] ath9k: fix aggregation session lockup
Date: Tue,  5 Aug 2014 11:13:43 -0700
Message-Id: <20140805181336.218014399@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -890,6 +890,15 @@ ath_tx_get_tid_subframe(struct ath_softc
 
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


