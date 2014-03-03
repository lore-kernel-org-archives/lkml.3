Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaCCS7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:59:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56105 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaCCS7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:59:00 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 41/67] mac80211: Fix IBSS disconnect
Date: Mon,  3 Mar 2014 10:55:29 -0800
Message-Id: <1393872955-28810-42-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit d4c80d9df6d1e4473b1409e4d220ca3d1612125c upstream.

Currently, when a station leaves an IBSS network, the
corresponding BSS is not dropped from cfg80211 if there are
other active stations in the network. But, the small
window that is present when trying to determine a station's
status based on IEEE80211_IBSS_MERGE_INTERVAL introduces
a race.

Instead of trying to keep the BSS, always remove it when
leaving an IBSS network. There is not much benefit to retain
the BSS entry since it will be added with a subsequent join
operation.

This fixes an issue where a dangling BSS entry causes ath9k
to wait for a beacon indefinitely.

Reported-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ kamal: backport to 3.8 (applied to ieee80211_ibss_leave) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/ibss.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 34741ee..217064a 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -1153,14 +1153,11 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 	struct cfg80211_bss *cbss;
 	u16 capability;
-	int active_ibss;
 	struct sta_info *sta;
 
 	mutex_lock(&sdata->u.ibss.mtx);
 
-	active_ibss = ieee80211_sta_active_ibss(sdata);
-
-	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
+	if (!is_zero_ether_addr(ifibss->bssid)) {
 		capability = WLAN_CAPABILITY_IBSS;
 
 		if (ifibss->privacy)
-- 
1.8.3.2

