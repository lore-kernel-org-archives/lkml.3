Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593Ab3K0Bx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:53:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab3K0A53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 28/80] rt2x00: fix HT TX descriptor settings regression
Date: Tue, 26 Nov 2013 16:56:57 -0800
Message-Id: <20131127005642.887654683@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2x00lib.h   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00queue.c |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -146,7 +146,7 @@ void rt2x00queue_remove_l2pad(struct sk_
  * @local: frame is not from mac80211
  */
 int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
-			       bool local);
+			       struct ieee80211_sta *sta, bool local);
 
 /**
  * rt2x00queue_update_beacon - Send new beacon from mac80211
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -90,7 +90,7 @@ static int rt2x00mac_tx_rts_cts(struct r
 				  frag_skb->data, data_length, tx_info,
 				  (struct ieee80211_rts *)(skb->data));
 
-	retval = rt2x00queue_write_tx_frame(queue, skb, true);
+	retval = rt2x00queue_write_tx_frame(queue, skb, NULL, true);
 	if (retval) {
 		dev_kfree_skb_any(skb);
 		rt2x00_warn(rt2x00dev, "Failed to send RTS/CTS frame\n");
@@ -151,7 +151,7 @@ void rt2x00mac_tx(struct ieee80211_hw *h
 			goto exit_fail;
 	}
 
-	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, false)))
+	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, control->sta, false)))
 		goto exit_fail;
 
 	/*
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -635,7 +635,7 @@ static void rt2x00queue_bar_check(struct
 }
 
 int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
-			       bool local)
+			       struct ieee80211_sta *sta, bool local)
 {
 	struct ieee80211_tx_info *tx_info;
 	struct queue_entry *entry;
@@ -649,7 +649,7 @@ int rt2x00queue_write_tx_frame(struct da
 	 * after that we are free to use the skb->cb array
 	 * for our information.
 	 */
-	rt2x00queue_create_tx_descriptor(queue->rt2x00dev, skb, &txdesc, NULL);
+	rt2x00queue_create_tx_descriptor(queue->rt2x00dev, skb, &txdesc, sta);
 
 	/*
 	 * All information is retrieved from the skb->cb array,


