Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaCCTAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:00:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56209 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaCCTAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:00:50 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eliad Peller <eliad@wizery.com>, Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 39/67] mac80211: move roc cookie assignment earlier
Date: Mon,  3 Mar 2014 10:55:27 -0800
Message-Id: <1393872955-28810-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit 2f617435c3a6fe3f39efb9ae2baa77de2d6c97b8 upstream.

ieee80211_start_roc_work() might add a new roc
to existing roc, and tell cfg80211 it has already
started.

However, this might happen before the roc cookie
was set, resulting in REMAIN_ON_CHANNEL (started)
event with null cookie. Consequently, it can make
wpa_supplicant go out of sync.

Fix it by setting the roc cookie earlier.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/cfg.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a1df92b..795aea6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2315,6 +2315,24 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	INIT_DELAYED_WORK(&roc->work, ieee80211_sw_roc_work);
 	INIT_LIST_HEAD(&roc->dependents);
 
+	/*
+	 * cookie is either the roc cookie (for normal roc)
+	 * or the SKB (for mgmt TX)
+	 */
+	if (!txskb) {
+		/* local->mtx protects this */
+		local->roc_cookie_counter++;
+		roc->cookie = local->roc_cookie_counter;
+		/* wow, you wrapped 64 bits ... more likely a bug */
+		if (WARN_ON(roc->cookie == 0)) {
+			roc->cookie = 1;
+			local->roc_cookie_counter++;
+		}
+		*cookie = roc->cookie;
+	} else {
+		*cookie = (unsigned long)txskb;
+	}
+
 	/* if there's one pending or we're scanning, queue this one */
 	if (!list_empty(&local->roc_list) || local->scanning)
 		goto out_check_combine;
@@ -2443,24 +2461,6 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	if (!queued)
 		list_add_tail(&roc->list, &local->roc_list);
 
-	/*
-	 * cookie is either the roc cookie (for normal roc)
-	 * or the SKB (for mgmt TX)
-	 */
-	if (!txskb) {
-		/* local->mtx protects this */
-		local->roc_cookie_counter++;
-		roc->cookie = local->roc_cookie_counter;
-		/* wow, you wrapped 64 bits ... more likely a bug */
-		if (WARN_ON(roc->cookie == 0)) {
-			roc->cookie = 1;
-			local->roc_cookie_counter++;
-		}
-		*cookie = roc->cookie;
-	} else {
-		*cookie = (unsigned long)txskb;
-	}
-
 	return 0;
 }
 
-- 
1.8.3.2

