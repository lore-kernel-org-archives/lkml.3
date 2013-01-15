Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3AOSyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:54:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:34225 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab3AOSxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:53:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 024/221] mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
Date: Tue, 15 Jan 2013 10:49:11 -0800
Message-Id: <20130115184959.790185424@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/mac80211.h |    5 +++++
 net/mac80211/status.c  |    6 +++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1253,6 +1253,10 @@ struct ieee80211_tx_control {
  * @IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF: Use the P2P Device address for any
  *	P2P Interface. This will be honoured even if more than one interface
  *	is supported.
+ *
+ * @IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL: On this hardware TX BA session
+ *	should be tear down once BAR frame will not be acked.
+ *
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1281,6 +1285,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
 	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
 	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
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
 


