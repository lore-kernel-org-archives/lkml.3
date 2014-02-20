Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaBUAWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:22:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaBTXxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:53:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.13 12/99] mac80211: Fix IBSS disconnect
Date: Thu, 20 Feb 2014 15:52:07 -0800
Message-Id: <20140220235118.568266632@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/ibss.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -687,12 +687,9 @@ static void ieee80211_ibss_disconnect(st
 	struct cfg80211_bss *cbss;
 	struct beacon_data *presp;
 	struct sta_info *sta;
-	int active_ibss;
 	u16 capability;
 
-	active_ibss = ieee80211_sta_active_ibss(sdata);
-
-	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
+	if (!is_zero_ether_addr(ifibss->bssid)) {
 		capability = WLAN_CAPABILITY_IBSS;
 
 		if (ifibss->privacy)


