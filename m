Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3KHC00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:26:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34910 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695Ab3KHCV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:59 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 48/91] mac80211: correctly close cancelled scans
Date: Thu,  7 Nov 2013 18:15:03 -0800
Message-Id: <1383876946-2396-49-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit a754055a1296fcbe6f32de3a5eaca6efb2fd1865 upstream.

__ieee80211_scan_completed is called from a worker. This
means that the following flow is possible.

 * driver calls ieee80211_scan_completed
 * mac80211 cancels the scan (that is already complete)
 * __ieee80211_scan_completed runs

When scan_work will finally run, it will see that the scan
hasn't been aborted and might even trigger another scan on
another band. This leads to a situation where cfg80211's
scan is not done and no further scan can be issued.

Fix this by setting a new flag when a HW scan is being
cancelled so that no other scan will be triggered.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/scan.c        | 19 +++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 55d8f89..abe9359 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -861,6 +861,8 @@ struct tpt_led_trigger {
  *	that the scan completed.
  * @SCAN_ABORTED: Set for our scan work function when the driver reported
  *	a scan complete for an aborted scan.
+ * @SCAN_HW_CANCELLED: Set for our scan work function when the scan is being
+ *	cancelled.
  */
 enum {
 	SCAN_SW_SCANNING,
@@ -868,6 +870,7 @@ enum {
 	SCAN_ONCHANNEL_SCANNING,
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
+	SCAN_HW_CANCELLED,
 };
 
 /**
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index bf82e69..8d6ba43 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -215,6 +215,9 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	enum ieee80211_band band;
 	int i, ielen, n_chans;
 
+	if (test_bit(SCAN_HW_CANCELLED, &local->scanning))
+		return false;
+
 	do {
 		if (local->hw_scan_band == IEEE80211_NUM_BANDS)
 			return false;
@@ -903,7 +906,23 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	if (!local->scan_req)
 		goto out;
 
+	/*
+	 * We have a scan running and the driver already reported completion,
+	 * but the worker hasn't run yet or is stuck on the mutex - mark it as
+	 * cancelled.
+	 */
+	if (test_bit(SCAN_HW_SCANNING, &local->scanning) &&
+	    test_bit(SCAN_COMPLETED, &local->scanning)) {
+		set_bit(SCAN_HW_CANCELLED, &local->scanning);
+		goto out;
+	}
+
 	if (test_bit(SCAN_HW_SCANNING, &local->scanning)) {
+		/*
+		 * Make sure that __ieee80211_scan_completed doesn't trigger a
+		 * scan on another band.
+		 */
+		set_bit(SCAN_HW_CANCELLED, &local->scanning);
 		if (local->ops->cancel_hw_scan)
 			drv_cancel_hw_scan(local,
 				rcu_dereference_protected(local->scan_sdata,
-- 
1.8.1.2

