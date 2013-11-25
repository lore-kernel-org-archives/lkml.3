Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab3KYOLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:11:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59026 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab3KYNxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:45 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johannes Berg" <johannes.berg@intel.com>,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.783497232@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 50/87] mac80211: correctly close cancelled scans
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/scan.c        | 19 +++++++++++++++++++
 2 files changed, 22 insertions(+)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -708,6 +708,8 @@ struct tpt_led_trigger {
  *	that the scan completed.
  * @SCAN_ABORTED: Set for our scan work function when the driver reported
  *	a scan complete for an aborted scan.
+ * @SCAN_HW_CANCELLED: Set for our scan work function when the scan is being
+ *	cancelled.
  */
 enum {
 	SCAN_SW_SCANNING,
@@ -715,6 +717,7 @@ enum {
 	SCAN_OFF_CHANNEL,
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
+	SCAN_HW_CANCELLED,
 };
 
 /**
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -224,6 +224,9 @@ static bool ieee80211_prep_hw_scan(struc
 	enum ieee80211_band band;
 	int i, ielen, n_chans;
 
+	if (test_bit(SCAN_HW_CANCELLED, &local->scanning))
+		return false;
+
 	do {
 		if (local->hw_scan_band == IEEE80211_NUM_BANDS)
 			return false;
@@ -815,7 +818,23 @@ void ieee80211_scan_cancel(struct ieee80
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

