Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab3IYAdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:33:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3IYAUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 064/117] mac80211: ignore (E)CSA in probe response frames
Date: Tue, 24 Sep 2013 17:18:50 -0700
Message-Id: <20130925001747.849356789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit d70b7616d9080ec9f868fbd31db5fd4341435d61 upstream.

Seth reports that some APs, notably the Netgear WNDAP360, send
invalid ECSA IEs in probe response frames with the operating
class and channel number both set to zero, even when no channel
switch is being done. As a result, any scan while connected to
such an AP results in the connection being dropped.

Fix this by ignoring any channel switch announcment in probe
response frames entirely, since we're connected to the AP we
will be receiving a beacon (and maybe even an action frame) if
a channel switch is done, which is sufficient.

Reported-by: Seth Forshee <seth.forshee@canonical.com>
Tested-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2851,14 +2851,6 @@ static void ieee80211_rx_bss_info(struct
 		ieee80211_rx_bss_put(local, bss);
 		sdata->vif.bss_conf.beacon_rate = bss->beacon_rate;
 	}
-
-	if (!sdata->u.mgd.associated ||
-	    !ether_addr_equal(mgmt->bssid, sdata->u.mgd.associated->bssid))
-		return;
-
-	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime,
-					 elems, true);
-
 }
 
 
@@ -3147,6 +3139,9 @@ static void ieee80211_rx_mgmt_beacon(str
 
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 
+	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime,
+					 &elems, true);
+
 	if (ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
 				     elems.wmm_param_len))
 		changed |= BSS_CHANGED_QOS;


