Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3H0BHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59451 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3H0BHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luciano Coelho <luciano.coelho@intel.com>
Subject: [ 02/74] mac80211: dont wait for TX status forever
Date: Mon, 26 Aug 2013 18:08:00 -0700
Message-Id: <20130827010425.237521617@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit cb236d2d713cff83d024a82b836757d9e2b50715 upstream.

TX status notification can get lost, or the frames could
get stuck on the queue, so don't wait for the callback
from the driver forever and instead time out after half
a second.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 net/mac80211/mlme.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -31,10 +31,12 @@
 #include "led.h"
 
 #define IEEE80211_AUTH_TIMEOUT		(HZ / 5)
+#define IEEE80211_AUTH_TIMEOUT_LONG	(HZ / 2)
 #define IEEE80211_AUTH_TIMEOUT_SHORT	(HZ / 10)
 #define IEEE80211_AUTH_MAX_TRIES	3
 #define IEEE80211_AUTH_WAIT_ASSOC	(HZ * 5)
 #define IEEE80211_ASSOC_TIMEOUT		(HZ / 5)
+#define IEEE80211_ASSOC_TIMEOUT_LONG	(HZ / 2)
 #define IEEE80211_ASSOC_TIMEOUT_SHORT	(HZ / 10)
 #define IEEE80211_ASSOC_MAX_TRIES	3
 
@@ -3470,10 +3472,13 @@ static int ieee80211_probe_auth(struct i
 
 	if (tx_flags == 0) {
 		auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
-		ifmgd->auth_data->timeout_started = true;
+		auth_data->timeout_started = true;
 		run_again(ifmgd, auth_data->timeout);
 	} else {
-		auth_data->timeout_started = false;
+		auth_data->timeout =
+			round_jiffies_up(jiffies + IEEE80211_AUTH_TIMEOUT_LONG);
+		auth_data->timeout_started = true;
+		run_again(ifmgd, auth_data->timeout);
 	}
 
 	return 0;
@@ -3510,7 +3515,11 @@ static int ieee80211_do_assoc(struct iee
 		assoc_data->timeout_started = true;
 		run_again(&sdata->u.mgd, assoc_data->timeout);
 	} else {
-		assoc_data->timeout_started = false;
+		assoc_data->timeout =
+			round_jiffies_up(jiffies +
+					 IEEE80211_ASSOC_TIMEOUT_LONG);
+		assoc_data->timeout_started = true;
+		run_again(&sdata->u.mgd, assoc_data->timeout);
 	}
 
 	return 0;


