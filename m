Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbaFEAss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:48:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaFDXUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:20:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eliad Peller <eliadx.peller@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 033/228] cfg80211: add cfg80211_sched_scan_stopped_rtnl
Date: Wed,  4 Jun 2014 16:21:02 -0700
Message-Id: <20140604232349.140130252@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit 792e6aa7a15ea0fb16f8687e93caede1ea9118c7 upstream.

Add locked-version for cfg80211_sched_scan_stopped.
This is used for some users that might want to
call it when rtnl is already locked.

Fixes: d43c6b6 ("mac80211: reschedule sched scan after HW restart")
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/cfg80211.h |   12 ++++++++++++
 net/wireless/scan.c    |   12 ++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3637,6 +3637,18 @@ void cfg80211_sched_scan_results(struct
 void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
 
 /**
+ * cfg80211_sched_scan_stopped_rtnl - notify that the scheduled scan has stopped
+ *
+ * @wiphy: the wiphy on which the scheduled scan stopped
+ *
+ * The driver can call this function to inform cfg80211 that the
+ * scheduled scan had to be stopped, for whatever reason.  The driver
+ * is then called back via the sched_scan_stop operation when done.
+ * This function should be called with rtnl locked.
+ */
+void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy);
+
+/**
  * cfg80211_inform_bss_width_frame - inform cfg80211 of a received BSS frame
  *
  * @wiphy: the wiphy reporting the BSS
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -284,14 +284,22 @@ void cfg80211_sched_scan_results(struct
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_results);
 
-void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
+void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	ASSERT_RTNL();
+
 	trace_cfg80211_sched_scan_stopped(wiphy);
 
-	rtnl_lock();
 	__cfg80211_stop_sched_scan(rdev, true);
+}
+EXPORT_SYMBOL(cfg80211_sched_scan_stopped_rtnl);
+
+void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
+{
+	rtnl_lock();
+	cfg80211_sched_scan_stopped_rtnl(wiphy);
 	rtnl_unlock();
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped);


