Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011AbaLBTwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:52:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46594 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551AbaLBTWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:22:05 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 053/121] mac80211: properly flush delayed scan work on interface removal
Date: Tue,  2 Dec 2014 11:18:52 -0800
Message-Id: <1417548000-1794-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit 46238845bd609a5c0fbe076e1b82b4c5b33360b2 upstream.

When an interface is deleted, an ongoing hardware scan is canceled and
the driver must abort the scan, at the very least reporting completion
while the interface is removed.

However, if it scheduled the work that might only run after everything
is said and done, which leads to cfg80211 warning that the scan isn't
reported as finished yet; this is no fault of the driver, it already
did, but mac80211 hasn't processed it.

To fix this situation, flush the delayed work when the interface being
removed is the one that was executing the scan.

Reported-by: Sujith Manoharan <sujith@msujith.org>
Tested-by: Sujith Manoharan <sujith@msujith.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/iface.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 822d508..e6d592d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -749,10 +749,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	u32 hw_reconf_flags = 0;
 	int i, flushed;
 	struct ps_data *ps;
+	bool cancel_scan;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
-	if (rcu_access_pointer(local->scan_sdata) == sdata)
+	cancel_scan = rcu_access_pointer(local->scan_sdata) == sdata;
+	if (cancel_scan)
 		ieee80211_scan_cancel(local);
 
 	/*
@@ -963,6 +965,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_recalc_ps(local, -1);
 
+	if (cancel_scan)
+		flush_delayed_work(&local->scan_work);
+
 	if (local->open_count == 0) {
 		ieee80211_stop_device(local);
 
-- 
1.9.1

