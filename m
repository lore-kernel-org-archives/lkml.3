Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab3LFXza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:55:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48336 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759008Ab3LFXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 018/152] cfg80211: fix scheduled scan pointer access
Date: Fri,  6 Dec 2013 15:09:02 -0800
Message-Id: <1386371476-2477-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 79845c662eeb95c9a180b9bd0d3ad848ee65b94c upstream.

Since rdev->sched_scan_req is dereferenced outside the
lock protecting it, this might be done at the wrong
time, causing crashes. Move the dereference to where
it should be - inside the RTNL locked section.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/wireless/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 45f1618..c6390e7 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -166,10 +166,10 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
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
-- 
1.8.3.2

