Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3BCBYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:24:14 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50243 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab3BCBXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:23:12 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 59/62] mac80211: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:21:00 -0800
Message-Id: <1359854463-2538-60-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 net/mac80211/main.c |  2 --
 net/mac80211/tx.c   | 18 ++++--------------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1b087ff..7b5bbea 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -687,8 +687,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	spin_lock_init(&local->ack_status_lock);
 	idr_init(&local->ack_status_frames);
-	/* preallocate at least one entry */
-	idr_pre_get(&local->ack_status_frames, GFP_KERNEL);
 
 	sta_info_init(local);
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9eadc4..73eb6c1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1996,24 +1996,14 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		skb = skb_clone(skb, GFP_ATOMIC);
 		if (skb) {
 			unsigned long flags;
-			int id, r;
+			int id;
 
 			spin_lock_irqsave(&local->ack_status_lock, flags);
-			r = idr_get_new_above(&local->ack_status_frames,
-					      orig_skb, 1, &id);
-			if (r == -EAGAIN) {
-				idr_pre_get(&local->ack_status_frames,
-					    GFP_ATOMIC);
-				r = idr_get_new_above(&local->ack_status_frames,
-						      orig_skb, 1, &id);
-			}
-			if (WARN_ON(!id) || id > 0xffff) {
-				idr_remove(&local->ack_status_frames, id);
-				r = -ERANGE;
-			}
+			id = idr_alloc(&local->ack_status_frames, orig_skb,
+				       1, 0x10000, GFP_ATOMIC);
 			spin_unlock_irqrestore(&local->ack_status_lock, flags);
 
-			if (!r) {
+			if (id >= 0) {
 				info_id = id;
 				info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 			} else if (skb_shared(skb)) {
-- 
1.8.1

