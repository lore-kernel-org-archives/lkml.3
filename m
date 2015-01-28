Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565AbbA1EZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:25:24 -0500
Received: from mail.kernel.org ([198.145.29.136]:41041 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934553AbbA1EZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:19 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Johannes Berg <johannes.berg@intel.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 148/177] mac80211: properly flush delayed scan work on interface removal
Date: Wed, 28 Jan 2015 12:10:06 +0800
Message-Id: <1422418236-12852-239-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: rcu_access_pointer() isn't used]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 net/mac80211/iface.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 95a04f0..9f32756 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -395,10 +395,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	u32 hw_reconf_flags = 0;
 	int i;
 	enum nl80211_channel_type orig_ct;
+	bool cancel_scan;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
-	if (local->scan_sdata == sdata)
+	cancel_scan = local->scan_sdata == sdata;
+	if (cancel_scan)
 		ieee80211_scan_cancel(local);
 
 	/*
@@ -562,6 +564,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_recalc_ps(local, -1);
 
+	if (cancel_scan)
+		flush_delayed_work(&local->scan_work);
+
 	if (local->open_count == 0) {
 		if (local->ops->napi_poll)
 			napi_disable(&local->napi);
-- 
1.9.1

