Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab3APABL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:01:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:43559 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932683Ab3AOWf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 186/221] Revert: "rt2x00: Dont let mac80211 send a BAR when an AMPDU subframe fails"
Date: Tue, 15 Jan 2013 10:51:53 -0800
Message-Id: <20130115185011.450421993@linuxfoundation.org>
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

commit ab9d6e4ffe192427ce9e93d4f927b0faaa8a941e upstream.

This revert:

commit be03d4a45c09ee5100d3aaaedd087f19bc20d01f
Author: Andreas Hartmann <andihartmann@01019freenet.de>
Date:   Tue Apr 17 00:25:28 2012 +0200

    rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails

To fix problem workaround by above commit use
IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL flag (see change log for
"mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL" patch).

Resolve: https://bugzilla.kernel.org/show_bug.cgi?id=42828
Bisected-by: Francisco Pina Martins <f.pinamartins@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00dev.c |    7 +++----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5036,7 +5036,8 @@ static int rt2800_probe_hw_mode(struct r
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK |
 	    IEEE80211_HW_AMPDU_AGGREGATION |
-	    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
+	    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+	    IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL;
 
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -391,10 +391,9 @@ void rt2x00lib_txdone(struct queue_entry
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
 		tx_info->status.ampdu_len = 1;
 		tx_info->status.ampdu_ack_len = success ? 1 : 0;
-		/*
-		 * TODO: Need to tear down BA session here
-		 * if not successful.
-		 */
+
+		if (!success)
+			tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 	}
 
 	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {


