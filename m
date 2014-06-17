Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967253AbaFQVxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:53:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967242AbaFQVxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:53:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 146/212] mac80211: fix on-channel remain-on-channel
Date: Tue, 17 Jun 2014 14:44:00 -0700
Message-Id: <1403041506-13646-147-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

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

Reported-by: Jouni Malinen <j@w1.fi>
Tested-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/offchannel.c  | 27 ++++++++++++++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1fc9190..980d863 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -315,6 +315,7 @@ struct ieee80211_roc_work {
 
 	bool started, abort, hw_begun, notified;
 	bool to_be_freed;
+	bool on_channel;
 
 	unsigned long hw_start_time;
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 6fb3855..7a17dec 100644
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
1.9.1

