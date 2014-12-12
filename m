Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475AbaLLG2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:28:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52024 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759365AbaLLGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johannes Berg" <johannes.berg@intel.com>,
        "Sujith Manoharan" <sujith@msujith.org>,
        "Johannes Berg" <johannes@sipsolutions.net>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.148466917@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 096/164] mac80211: properly flush delayed scan work on
 interface removal
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - No rcu_access_pointer() needed
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/iface.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -382,10 +382,12 @@ static void ieee80211_do_stop(struct iee
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
@@ -543,6 +545,9 @@ static void ieee80211_do_stop(struct iee
 
 	ieee80211_recalc_ps(local, -1);
 
+	if (cancel_scan)
+		flush_delayed_work(&local->scan_work);
+
 	if (local->open_count == 0) {
 		if (local->ops->napi_poll)
 			napi_disable(&local->napi);

