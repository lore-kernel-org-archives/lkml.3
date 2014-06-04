Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaFEApw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:45:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaFDXVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 036/228] mac80211: fix on-channel remain-on-channel
Date: Wed,  4 Jun 2014 16:21:05 -0700
Message-Id: <20140604232349.230788857@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/offchannel.c  |   27 ++++++++++++++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -317,6 +317,7 @@ struct ieee80211_roc_work {
 
 	bool started, abort, hw_begun, notified;
 	bool to_be_freed;
+	bool on_channel;
 
 	unsigned long hw_start_time;
 
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -333,7 +333,7 @@ void ieee80211_sw_roc_work(struct work_s
 		container_of(work, struct ieee80211_roc_work, work.work);
 	struct ieee80211_sub_if_data *sdata = roc->sdata;
 	struct ieee80211_local *local = sdata->local;
-	bool started;
+	bool started, on_channel;
 
 	mutex_lock(&local->mtx);
 
@@ -354,14 +354,26 @@ void ieee80211_sw_roc_work(struct work_s
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
@@ -380,9 +392,10 @@ void ieee80211_sw_roc_work(struct work_s
  finish:
 		list_del(&roc->list);
 		started = roc->started;
+		on_channel = roc->on_channel;
 		ieee80211_roc_notify_destroy(roc, !roc->abort);
 
-		if (started) {
+		if (started && !on_channel) {
 			ieee80211_flush_queues(local, NULL);
 
 			local->tmp_channel = NULL;


