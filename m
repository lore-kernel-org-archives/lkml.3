Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaFWNi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:38:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36643 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaFWNDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:03:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eliad Peller <eliadx.peller@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 01/93] cfg80211: free sme on connection failures
Date: Mon, 23 Jun 2014 14:01:40 +0100
Message-Id: <1403528592-2163-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit c1fbb258846dfc425507a093922d2d001e54c3ea upstream.

cfg80211 is notified about connection failures by
__cfg80211_connect_result() call. However, this
function currently does not free cfg80211 sme.

This results in hanging connection attempts in some cases

e.g. when mac80211 authentication attempt is denied,
we have this function call:
ieee80211_rx_mgmt_auth() -> cfg80211_rx_mlme_mgmt() ->
cfg80211_process_auth() -> cfg80211_sme_rx_auth() ->
__cfg80211_connect_result()

but cfg80211_sme_free() is never get called.

Fixes: ceca7b712 ("cfg80211: separate internal SME implementation")
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/wireless/sme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 20e86a95dc4e..2f844eec9c6d 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -242,7 +242,6 @@ void cfg80211_conn_work(struct work_struct *work)
 					NULL, 0, NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE,
 					false, NULL);
-			cfg80211_sme_free(wdev);
 		}
 		wdev_unlock(wdev);
 	}
@@ -646,6 +645,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			cfg80211_unhold_bss(bss_from_pub(bss));
 			cfg80211_put_bss(wdev->wiphy, bss);
 		}
+		cfg80211_sme_free(wdev);
 		return;
 	}
 
-- 
1.9.1

