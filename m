Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487Ab3EGEGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:06:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29703 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757868Ab3EGD6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:51 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9XYrJOTyYRUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=0pLUw8OX09sA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=3-sIqWLlaJP0uh_QgJ0A:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rDgxpS7TndiJK-L7:21 a=5CxKyv2cpHXfPhS6:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035844.410715169@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes.berg@intel.com>
Subject: [021/126] mac80211: fix remain-on-channel cancel crash
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0021-mac80211-fix-remain-on-channel-cancel-crash.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 3fbd45ca8d1c98f3c2582ef8bc70ade42f70947b ]

If a ROC item is canceled just as it expires, the work
struct may be scheduled while it is running (and waiting
for the mutex). This results in it being run after being
freed, which obviously crashes.

To fix this don't free it when aborting is requested but
instead mark it as "to be freed", which makes the work a
no-op and allows freeing it outside.

Cc: stable@vger.kernel.org [3.6+]
Reported-by: Jouni Malinen <j@w1.fi>
Tested-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/mac80211/cfg.c         |    6 ++++--
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/offchannel.c  |   23 +++++++++++++++++------
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a58c0b6..bb8d96b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2337,7 +2337,7 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 			list_del(&dep->list);
 			mutex_unlock(&local->mtx);
 
-			ieee80211_roc_notify_destroy(dep);
+			ieee80211_roc_notify_destroy(dep, true);
 			return 0;
 		}
 
@@ -2377,7 +2377,7 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 			ieee80211_start_next_roc(local);
 		mutex_unlock(&local->mtx);
 
-		ieee80211_roc_notify_destroy(found);
+		ieee80211_roc_notify_destroy(found, true);
 	} else {
 		/* work may be pending so use it all the time */
 		found->abort = true;
@@ -2387,6 +2387,8 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 
 		/* work will clean up etc */
 		flush_delayed_work(&found->work);
+		WARN_ON(!found->to_be_freed);
+		kfree(found);
 	}
 
 	return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 642a2a3..bf08e3c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -339,6 +339,7 @@ struct ieee80211_roc_work {
 	enum nl80211_channel_type chan_type;
 
 	bool started, abort, hw_begun, notified;
+	bool to_be_freed;
 
 	unsigned long hw_start_time;
 
@@ -1274,7 +1275,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 void ieee80211_roc_setup(struct ieee80211_local *local);
 void ieee80211_start_next_roc(struct ieee80211_local *local);
 void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata);
-void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc);
+void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free);
 void ieee80211_sw_roc_work(struct work_struct *work);
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 2138dc3..2fe484c 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -293,10 +293,13 @@ void ieee80211_start_next_roc(struct ieee80211_local *local)
 	}
 }
 
-void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
+void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free)
 {
 	struct ieee80211_roc_work *dep, *tmp;
 
+	if (WARN_ON(roc->to_be_freed))
+		return;
+
 	/* was never transmitted */
 	if (roc->frame) {
 		cfg80211_mgmt_tx_status(&roc->sdata->wdev,
@@ -313,9 +316,12 @@ void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
 						   GFP_KERNEL);
 
 	list_for_each_entry_safe(dep, tmp, &roc->dependents, list)
-		ieee80211_roc_notify_destroy(dep);
+		ieee80211_roc_notify_destroy(dep, true);
 
-	kfree(roc);
+	if (free)
+		kfree(roc);
+	else
+		roc->to_be_freed = true;
 }
 
 void ieee80211_sw_roc_work(struct work_struct *work)
@@ -328,6 +334,9 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 
 	mutex_lock(&local->mtx);
 
+	if (roc->to_be_freed)
+		goto out_unlock;
+
 	if (roc->abort)
 		goto finish;
 
@@ -368,7 +377,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
  finish:
 		list_del(&roc->list);
 		started = roc->started;
-		ieee80211_roc_notify_destroy(roc);
+		ieee80211_roc_notify_destroy(roc, !roc->abort);
 
 		if (started) {
 			drv_flush(local, false);
@@ -408,7 +417,7 @@ static void ieee80211_hw_roc_done(struct work_struct *work)
 
 	list_del(&roc->list);
 
-	ieee80211_roc_notify_destroy(roc);
+	ieee80211_roc_notify_destroy(roc, true);
 
 	/* if there's another roc, start it now */
 	ieee80211_start_next_roc(local);
@@ -458,12 +467,14 @@ void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata)
 	list_for_each_entry_safe(roc, tmp, &tmp_list, list) {
 		if (local->ops->remain_on_channel) {
 			list_del(&roc->list);
-			ieee80211_roc_notify_destroy(roc);
+			ieee80211_roc_notify_destroy(roc, true);
 		} else {
 			ieee80211_queue_delayed_work(&local->hw, &roc->work, 0);
 
 			/* work will clean up etc */
 			flush_delayed_work(&roc->work);
+			WARN_ON(!roc->to_be_freed);
+			kfree(roc);
 		}
 	}
 
-- 
1.7.10.4


