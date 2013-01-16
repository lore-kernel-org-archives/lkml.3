Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab3APQCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:02:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36025 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab3APQCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:31 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 079/222] Revert: "rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails"
Date: Wed, 16 Jan 2013 13:54:39 -0200
Message-Id: <1358351822-7675-80-git-send-email-herton.krzesinski@canonical.com>
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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 ++-
 drivers/net/wireless/rt2x00/rt2x00dev.c |    7 +++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a15bf1c..346af52 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4524,7 +4524,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK |
 	    IEEE80211_HW_AMPDU_AGGREGATION |
-	    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
+	    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+	    IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL;
 
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 8ac4482..0cf05c3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -391,10 +391,9 @@ void rt2x00lib_txdone(struct queue_entry *entry,
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
-- 
1.7.9.5

