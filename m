Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682AbaKSUyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:54:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910AbaKSUyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sujith Manoharan <sujith@msujith.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.17 058/141] mac80211: properly flush delayed scan work on interface removal
Date: Wed, 19 Nov 2014 12:51:21 -0800
Message-Id: <20141119205152.581779027@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/iface.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -765,10 +765,12 @@ static void ieee80211_do_stop(struct iee
 	int i, flushed;
 	struct ps_data *ps;
 	struct cfg80211_chan_def chandef;
+	bool cancel_scan;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
-	if (rcu_access_pointer(local->scan_sdata) == sdata)
+	cancel_scan = rcu_access_pointer(local->scan_sdata) == sdata;
+	if (cancel_scan)
 		ieee80211_scan_cancel(local);
 
 	/*
@@ -990,6 +992,9 @@ static void ieee80211_do_stop(struct iee
 
 	ieee80211_recalc_ps(local, -1);
 
+	if (cancel_scan)
+		flush_delayed_work(&local->scan_work);
+
 	if (local->open_count == 0) {
 		ieee80211_stop_device(local);
 


