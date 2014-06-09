Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933926AbaFIJPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:15:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58413 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        Eliad Peller <eliadx.peller@intel.com>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 027/146] cfg80211: free sme on connection failures
Date: Mon,  9 Jun 2014 10:49:22 +0200
Message-Id: <7f506377f05d1d087806e42949db49ef52aa397b.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliad Peller <eliad@wizery.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
1.9.3

