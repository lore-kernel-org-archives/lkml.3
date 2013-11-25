Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab3KYN2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:28:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56975 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab3KYNHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 08/78] mac80211: correctly close cancelled scans
Date: Mon, 25 Nov 2013 13:05:55 +0000
Message-Id: <1385384825-21681-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/scan.c        | 19 +++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 38ba70e..73d195e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -808,6 +808,8 @@ struct tpt_led_trigger {
  *	that the scan completed.
  * @SCAN_ABORTED: Set for our scan work function when the driver reported
  *	a scan complete for an aborted scan.
+ * @SCAN_HW_CANCELLED: Set for our scan work function when the scan is being
+ *	cancelled.
  */
 enum {
 	SCAN_SW_SCANNING,
@@ -815,6 +817,7 @@ enum {
 	SCAN_ONCHANNEL_SCANNING,
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
+	SCAN_HW_CANCELLED,
 };
 
 /**
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index b73ce0a..27b796f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -233,6 +233,9 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	enum ieee80211_band band;
 	int i, ielen, n_chans;
 
+	if (test_bit(SCAN_HW_CANCELLED, &local->scanning))
+		return false;
+
 	do {
 		if (local->hw_scan_band == IEEE80211_NUM_BANDS)
 			return false;
@@ -888,7 +891,23 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
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
 			drv_cancel_hw_scan(local, local->scan_sdata);
 		goto out;
-- 
1.8.3.2

