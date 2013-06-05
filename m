Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126Ab3FEVnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:43:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088Ab3FEVgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 106/127] mac80211: fix direct probe auth
Date: Wed,  5 Jun 2013 14:34:33 -0700
Message-Id: <20130605213230.075322541@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 6211dd12da609bc6893b9c3182630b494737ec4b upstream.

We send direct probe to broadcast address, as some APs do not respond to
unicast PROBE frames when unassociated. Broadcast frames are not acked,
so we can not use that for trigger MLME state machine, but we need to
use old timeout mechanism.

This fixes authentication timed out like below:

[ 1024.671974] wlan6: authenticate with 54:e6:fc:98:63:fe
[ 1024.694125] wlan6: direct probe to 54:e6:fc:98:63:fe (try 1/3)
[ 1024.695450] wlan6: direct probe to 54:e6:fc:98:63:fe (try 2/3)
[ 1024.700586] wlan6: send auth to 54:e6:fc:98:63:fe (try 3/3)
[ 1024.701441] wlan6: authentication with 54:e6:fc:98:63:fe timed out

With fix, we have:

[ 4524.198978] wlan6: authenticate with 54:e6:fc:98:63:fe
[ 4524.220692] wlan6: direct probe to 54:e6:fc:98:63:fe (try 1/3)
[ 4524.421784] wlan6: send auth to 54:e6:fc:98:63:fe (try 2/3)
[ 4524.423272] wlan6: authenticated
[ 4524.423811] wlan6: associate with 54:e6:fc:98:63:fe (try 1/3)
[ 4524.427492] wlan6: RX AssocResp from 54:e6:fc:98:63:fe (capab=0x431 status=0 aid=1)

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3182,10 +3182,6 @@ static int ieee80211_probe_auth(struct i
 	if (WARN_ON_ONCE(!auth_data))
 		return -EINVAL;
 
-	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
-		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
-			   IEEE80211_TX_INTFL_MLME_CONN_TX;
-
 	auth_data->tries++;
 
 	if (auth_data->tries > IEEE80211_AUTH_MAX_TRIES) {
@@ -3219,6 +3215,10 @@ static int ieee80211_probe_auth(struct i
 			auth_data->expected_transaction = trans;
 		}
 
+		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+			tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
+				   IEEE80211_TX_INTFL_MLME_CONN_TX;
+
 		ieee80211_send_auth(sdata, trans, auth_data->algorithm, status,
 				    auth_data->data, auth_data->data_len,
 				    auth_data->bss->bssid,
@@ -3242,12 +3242,12 @@ static int ieee80211_probe_auth(struct i
 		 * will not answer to direct packet in unassociated state.
 		 */
 		ieee80211_send_probe_req(sdata, NULL, ssidie + 2, ssidie[1],
-					 NULL, 0, (u32) -1, true, tx_flags,
+					 NULL, 0, (u32) -1, true, 0,
 					 auth_data->bss->channel, false);
 		rcu_read_unlock();
 	}
 
-	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
+	if (tx_flags == 0) {
 		auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
 		ifmgd->auth_data->timeout_started = true;
 		run_again(ifmgd, auth_data->timeout);


