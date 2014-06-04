Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaFDXUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:20:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaFDXUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:20:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eliad Peller <eliadx.peller@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 032/228] cfg80211: free sme on connection failures
Date: Wed,  4 Jun 2014 16:21:01 -0700
Message-Id: <20140604232349.105242528@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/sme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -235,7 +235,6 @@ void cfg80211_conn_work(struct work_stru
 					NULL, 0, NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE,
 					false, NULL);
-			cfg80211_sme_free(wdev);
 		}
 		wdev_unlock(wdev);
 	}
@@ -649,6 +648,7 @@ void __cfg80211_connect_result(struct ne
 			cfg80211_unhold_bss(bss_from_pub(bss));
 			cfg80211_put_bss(wdev->wiphy, bss);
 		}
+		cfg80211_sme_free(wdev);
 		return;
 	}
 


