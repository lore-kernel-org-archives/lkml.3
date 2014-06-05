Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaFEEVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaFEEVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 119/214] mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
Date: Wed,  4 Jun 2014 21:18:02 -0700
Message-Id: <20140605041655.672517601@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 5b632fe85ec82e5c43740b52e74c66df50a37db3 upstream.

Commit f0425beda4d404a6e751439b562100b902ba9c98 "mac80211: retry sending
failed BAR frames later instead of tearing down aggr" caused regression
on rt2x00 hardware (connection hangs). This regression was fixed by
commit be03d4a45c09ee5100d3aaaedd087f19bc20d01 "rt2x00: Don't let
mac80211 send a BAR when an AMPDU subframe fails". But the latter
commit caused yet another problem reported in
https://bugzilla.kernel.org/show_bug.cgi?id=42828#c22

After long discussion in this thread:
http://mid.gmane.org/20121018075615.GA18212@redhat.com
and testing various alternative solutions, which failed on one or other
setup, we have no other good fix for the issues like just revert both
mentioned earlier commits.

To do not affect other hardware which benefit from commit
f0425beda4d404a6e751439b562100b902ba9c98, instead of reverting it,
introduce flag that when used will restore mac80211 behaviour before
the commit.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
[replaced link with mid.gmane.org that has message-id]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[hq: Backported to 3.4: adjust context]
Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/status.c  |    6 +++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1174,6 +1174,10 @@ enum sta_notify_cmd {
  * @IEEE80211_HW_SCAN_WHILE_IDLE: The device can do hw scan while
  *	being idle (i.e. mac80211 doesn't have to go idle-off during the
  *	the scan).
+ *
+ * @IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL: On this hardware TX BA session
+ *	should be tear down once BAR frame will not be acked.
+ *
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1201,6 +1205,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
 	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
+	IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL		= 1<<26,
 };
 
 /**
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -432,7 +432,11 @@ void ieee80211_tx_status(struct ieee8021
 				       IEEE80211_BAR_CTRL_TID_INFO_MASK) >>
 				      IEEE80211_BAR_CTRL_TID_INFO_SHIFT;
 
-				ieee80211_set_bar_pending(sta, tid, ssn);
+				if (local->hw.flags &
+				    IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL)
+					ieee80211_stop_tx_ba_session(&sta->sta, tid);
+				else
+					ieee80211_set_bar_pending(sta, tid, ssn);
 			}
 		}
 


