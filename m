Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3KHCWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:22:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab3KHCWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:22:01 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 52/91] mac80211: fix crash if bitrate calculation goes wrong
Date: Thu,  7 Nov 2013 18:15:07 -0800
Message-Id: <1383876946-2396-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit d86aa4f8ca58898ec6a94c0635da20b948171ed7 upstream.

If a frame's timestamp is calculated, and the bitrate
calculation goes wrong and returns zero, the system
will attempt to divide by zero and crash. Catch this
case and print the rate information that the driver
reported when this happens.

Reported-by: Thomas Lindroth <thomas.lindroth@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f11e8c5..e0ad72d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2105,6 +2105,10 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 	}
 
 	rate = cfg80211_calculate_bitrate(&ri);
+	if (WARN_ONCE(!rate,
+		      "Invalid bitrate: flags=0x%x, idx=%d, vht_nss=%d\n",
+		      status->flag, status->rate_idx, status->vht_nss))
+		return 0;
 
 	/* rewind from end of MPDU */
 	if (status->flag & RX_FLAG_MACTIME_END)
-- 
1.8.1.2

