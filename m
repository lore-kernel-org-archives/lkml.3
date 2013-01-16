Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab3APQC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:02:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36019 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab3APQC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:26 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 078/222] mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
Date: Wed, 16 Jan 2013 13:54:38 -0200
Message-Id: <1358351822-7675-79-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/status.c  |    6 +++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 95e39b6..82942da 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1197,6 +1197,10 @@ enum sta_notify_cmd {
  *	queue mapping in order to use different queues (not just one per AC)
  *	for different virtual interfaces. See the doc section on HW queue
  *	control for more details.
+ *
+ * @IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL: On this hardware TX BA session
+ *	should be tear down once BAR frame will not be acked.
+ *
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1224,6 +1228,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
 	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
+	IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL		= 1<<26,
 };
 
 /**
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 1c697ef..f98b326 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -435,7 +435,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
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
 
-- 
1.7.9.5

