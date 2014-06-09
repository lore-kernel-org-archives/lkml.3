Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053AbaFIJRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:17:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58393 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 006/146] mac80211: fix on-channel remain-on-channel
Date: Mon,  9 Jun 2014 10:49:01 +0200
Message-Id: <97da00224a0f38adec8a020ad5d1135881510999.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b4b177a5556a686909e643f1e9b6434c10de079f upstream.

Jouni reported that if a remain-on-channel was active on the
same channel as the current operating channel, then the ROC
would start, but any frames transmitted using mgmt-tx on the
same channel would get delayed until after the ROC.

The reason for this is that the ROC starts, but doesn't have
any handling for "remain on the same channel", so it stops
the interface queues. The later mgmt-tx then puts the frame
on the interface queues (since it's on the current operating
channel) and thus they get delayed until after the ROC.

To fix this, add some logic to handle remaining on the same
channel specially and not stop the queues etc. in this case.
This not only fixes the bug but also improves behaviour in
this case as data frames etc. can continue to flow.

Cc: stable@vger.kernel.org
Reported-by: Jouni Malinen <j@w1.fi>
Tested-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/offchannel.c  | 27 ++++++++++++++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ab0fbb458c11..23c13165ce83 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -311,6 +311,7 @@ struct ieee80211_roc_work {
 
 	bool started, abort, hw_begun, notified;
 	bool to_be_freed;
+	bool on_channel;
 
 	unsigned long hw_start_time;
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 6fb38558a5e6..7a17decd27f9 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -333,7 +333,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 		container_of(work, struct ieee80211_roc_work, work.work);
 	struct ieee80211_sub_if_data *sdata = roc->sdata;
 	struct ieee80211_local *local = sdata->local;
-	bool started;
+	bool started, on_channel;
 
 	mutex_lock(&local->mtx);
 
@@ -354,14 +354,26 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 	if (!roc->started) {
 		struct ieee80211_roc_work *dep;
 
-		/* start this ROC */
-		ieee80211_offchannel_stop_vifs(local);
+		WARN_ON(local->use_chanctx);
+
+		/* If actually operating on the desired channel (with at least
+		 * 20 MHz channel width) don't stop all the operations but still
+		 * treat it as though the ROC operation started properly, so
+		 * other ROC operations won't interfere with this one.
+		 */
+		roc->on_channel = roc->chan == local->_oper_chandef.chan &&
+				  local->_oper_chandef.width != NL80211_CHAN_WIDTH_5 &&
+				  local->_oper_chandef.width != NL80211_CHAN_WIDTH_10;
 
-		/* switch channel etc */
+		/* start this ROC */
 		ieee80211_recalc_idle(local);
 
-		local->tmp_channel = roc->chan;
-		ieee80211_hw_config(local, 0);
+		if (!roc->on_channel) {
+			ieee80211_offchannel_stop_vifs(local);
+
+			local->tmp_channel = roc->chan;
+			ieee80211_hw_config(local, 0);
+		}
 
 		/* tell userspace or send frame */
 		ieee80211_handle_roc_started(roc);
@@ -380,9 +392,10 @@ void ieee80211_sw_roc_work(struct work_struct *work)
  finish:
 		list_del(&roc->list);
 		started = roc->started;
+		on_channel = roc->on_channel;
 		ieee80211_roc_notify_destroy(roc, !roc->abort);
 
-		if (started) {
+		if (started && !on_channel) {
 			ieee80211_flush_queues(local, NULL);
 
 			local->tmp_channel = NULL;
-- 
1.9.3

