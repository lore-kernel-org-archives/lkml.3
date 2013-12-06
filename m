Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422993Ab3LFXU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:20:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48929 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3LFXUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 089/152] rt2x00: fix HT TX descriptor settings regression
Date: Fri,  6 Dec 2013 15:10:13 -0800
Message-Id: <1386371476-2477-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 3d8bfe141be8e5c21261fc63da8e7964d44f2645 upstream.

Since:

commit 36323f817af0376c78612cfdab714b0feb05fea5
Author: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Date:   Mon Jul 23 21:33:42 2012 +0200

    mac80211: move TX station pointer and restructure TX

we do not pass sta pointer to rt2x00queue_create_tx_descriptor_ht(),
hence we do not correctly set station WCID and AMPDU density parameters.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2x00lib.h   | 2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c   | 4 ++--
 drivers/net/wireless/rt2x00/rt2x00queue.c | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index a093598..7f40ab8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -146,7 +146,7 @@ void rt2x00queue_remove_l2pad(struct sk_buff *skb, unsigned int header_length);
  * @local: frame is not from mac80211
  */
 int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
-			       bool local);
+			       struct ieee80211_sta *sta, bool local);
 
 /**
  * rt2x00queue_update_beacon - Send new beacon from mac80211
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 509c3f1..9b00fcb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -90,7 +90,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 				  frag_skb->data, data_length, tx_info,
 				  (struct ieee80211_rts *)(skb->data));
 
-	retval = rt2x00queue_write_tx_frame(queue, skb, true);
+	retval = rt2x00queue_write_tx_frame(queue, skb, NULL, true);
 	if (retval) {
 		dev_kfree_skb_any(skb);
 		WARNING(rt2x00dev, "Failed to send RTS/CTS frame.\n");
@@ -151,7 +151,7 @@ void rt2x00mac_tx(struct ieee80211_hw *hw,
 			goto exit_fail;
 	}
 
-	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, false)))
+	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, control->sta, false)))
 		goto exit_fail;
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index a57032e..bc1216f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -583,7 +583,7 @@ static void rt2x00queue_kick_tx_queue(struct data_queue *queue,
 }
 
 int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
-			       bool local)
+			       struct ieee80211_sta *sta, bool local)
 {
 	struct ieee80211_tx_info *tx_info;
 	struct queue_entry *entry;
@@ -597,7 +597,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	 * after that we are free to use the skb->cb array
 	 * for our information.
 	 */
-	rt2x00queue_create_tx_descriptor(queue->rt2x00dev, skb, &txdesc, NULL);
+	rt2x00queue_create_tx_descriptor(queue->rt2x00dev, skb, &txdesc, sta);
 
 	/*
 	 * All information is retrieved from the skb->cb array,
-- 
1.8.3.2

