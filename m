Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998AbaBUNhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:37:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369AbaBUMun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eliad Peller <eliad@wizery.com>, Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 069/121] mac80211: move roc cookie assignment earlier
Date: Fri, 21 Feb 2014 12:48:13 +0000
Message-Id: <1392986945-9693-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/cfg.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 98871d7..2116285 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2494,6 +2494,24 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
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
 	if (!list_empty(&local->roc_list) ||
 	    local->scanning || local->radar_detect_enabled)
@@ -2628,24 +2646,6 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
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
1.9.0

