Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbaBUAhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:37:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbaBTXwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eliad Peller <eliad@wizery.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12 09/82] mac80211: move roc cookie assignment earlier
Date: Thu, 20 Feb 2014 15:51:52 -0800
Message-Id: <20140220235019.760065812@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/cfg.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2506,6 +2506,24 @@ static int ieee80211_start_roc_work(stru
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
@@ -2640,24 +2658,6 @@ static int ieee80211_start_roc_work(stru
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
 


