Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaCWTV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:21:27 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33445 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaCWTVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:21:22 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mac80211: Use RCU_INIT_POINTER(x, NULL) in scan.c
Date: Mon, 24 Mar 2014 00:50:22 +0530
Message-Id: <1395602422-14534-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 net/mac80211/scan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 836f500..f9f078b 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -309,7 +309,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	if (local->scan_req != local->int_scan_req)
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
-	rcu_assign_pointer(local->scan_sdata, NULL);
+	RCU_INIT_POINTER(local->scan_sdata, NULL);
 
 	local->scanning = 0;
 	local->scan_chandef.chan = NULL;
@@ -559,7 +559,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		ieee80211_recalc_idle(local);
 
 		local->scan_req = NULL;
-		rcu_assign_pointer(local->scan_sdata, NULL);
+		RCU_INIT_POINTER(local->scan_sdata, NULL);
 	}
 
 	return rc;
@@ -773,7 +773,7 @@ void ieee80211_scan_work(struct work_struct *work)
 		int rc;
 
 		local->scan_req = NULL;
-		rcu_assign_pointer(local->scan_sdata, NULL);
+		RCU_INIT_POINTER(local->scan_sdata, NULL);
 
 		rc = __ieee80211_start_scan(sdata, req);
 		if (rc) {
@@ -1014,7 +1014,7 @@ out_free:
 
 	if (ret) {
 		/* Clean in case of failure after HW restart or upon resume. */
-		rcu_assign_pointer(local->sched_scan_sdata, NULL);
+		RCU_INIT_POINTER(local->sched_scan_sdata, NULL);
 		local->sched_scan_req = NULL;
 	}
 
@@ -1087,7 +1087,7 @@ void ieee80211_sched_scan_stopped_work(struct work_struct *work)
 		return;
 	}
 
-	rcu_assign_pointer(local->sched_scan_sdata, NULL);
+	RCU_INIT_POINTER(local->sched_scan_sdata, NULL);
 
 	/* If sched scan was aborted by the driver. */
 	local->sched_scan_req = NULL;
-- 
1.7.9.5

