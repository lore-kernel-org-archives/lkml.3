Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab3LBUin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:38:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3LBTOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 139/173] cfg80211: fix scheduled scan pointer access
Date: Mon,  2 Dec 2013 11:12:02 -0800
Message-Id: <20131202191159.366614250@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 79845c662eeb95c9a180b9bd0d3ad848ee65b94c upstream.

Since rdev->sched_scan_req is dereferenced outside the
lock protecting it, this might be done at the wrong
time, causing crashes. Move the dereference to where
it should be - inside the RTNL locked section.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 net/wireless/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -253,10 +253,10 @@ void __cfg80211_sched_scan_results(struc
 	rdev = container_of(wk, struct cfg80211_registered_device,
 			    sched_scan_results_wk);
 
-	request = rdev->sched_scan_req;
-
 	mutex_lock(&rdev->sched_scan_mtx);
 
+	request = rdev->sched_scan_req;
+
 	/* we don't have sched_scan_req anymore if the scan is stopping */
 	if (request) {
 		if (request->flags & NL80211_SCAN_FLAG_FLUSH) {


