Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaKKF4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:56:14 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:2292 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaKKF4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:56:11 -0500
X-IronPort-AV: E=Sophos;i="5.07,359,1413270000"; 
   d="scan'208";a="50207934"
From: "Gautam (Gautam Kumar) Shukla" <gautams@broadcom.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jithu Jance <jithu@broadcom.com>, Sreenath S <sreenats@broadcom.com>
Subject: [PATCH 1/1] linux-wireless: Added psk in struct
 cfg80211_connect_params needed for offloading 4way handshake to driver
Thread-Topic: [PATCH 1/1] linux-wireless: Added psk in struct
 cfg80211_connect_params needed for offloading 4way handshake to driver
Thread-Index: Ac/9dB5NQ/C7C5zZRjSxY4lVQnUv+g==
Date: Tue, 11 Nov 2014 05:56:11 +0000
Message-ID: <DF163EE1A432BF4BBE6B2088220663A67437BD@SJEXCHMB06.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For offloading 4 way handshake to driver, currently we don't have any member  of struct cfg80211_connect_params to pass PSK from supplicant to driver. I have added psk for the same and added rest of the code needed in nl80211.h and nl80211.c to parse and make it available to driver.
>From supplicant, we already have psk member field in assoc_params to use .

Tested on x86 linux.

Signed-off-by: Gautam kumar shukla <gautams@broadcom.com>
---
include/net/cfg80211.h       | 2 ++
 include/uapi/linux/nl80211.h | 8 +++++++-
 net/wireless/nl80211.c       | 4 ++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h index a2ddcf2..6f744e0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1758,6 +1758,7 @@ struct cfg80211_ibss_params {
  *    allowed to ignore this @bssid_hint if it has knowledge of a better BSS
  *    to use.
  * @ssid: SSID
+ * @psk:preshared key for WPA2-PSK connection or %NULL if not specified
  * @ssid_len: Length of ssid in octets
  * @auth_type: Authentication type (algorithm)
  * @ie: IEs for association request
@@ -1783,6 +1784,7 @@ struct cfg80211_connect_params {
     const u8 *bssid;
     const u8 *bssid_hint;
     const u8 *ssid;
+    const u8 *psk;
     size_t ssid_len;
     enum nl80211_auth_type auth_type;
     const u8 *ie;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h index 4b28dc0..b01d5dd 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -421,7 +421,7 @@
  *    %NL80211_ATTR_MAC, %NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
  *    %NL80211_ATTR_CONTROL_PORT_ETHERTYPE,
  *    %NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT, %NL80211_ATTR_MAC_HINT, and
- *    %NL80211_ATTR_WIPHY_FREQ_HINT.
+ *    %NL80211_ATTR_WIPHY_FREQ_HINT, and %NL80211_ATTR_PSK.
  *    If included, %NL80211_ATTR_MAC and %NL80211_ATTR_WIPHY_FREQ are
  *    restrictions on BSS selection, i.e., they effectively prevent roaming
  *    within the ESS. %NL80211_ATTR_MAC_HINT and %NL80211_ATTR_WIPHY_FREQ_HINT @@ -1638,6 +1638,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_SMPS_MODE: SMPS mode to use (ap mode). see
  *    &enum nl80211_smps_mode.
  *
+ *    @NL80211_ATTR_PSK: a PSK value (u8 attribute).This is 32-octet 
+ (256-bit)
+ *    PSK.
+ *
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1990,6 +1994,8 @@ enum nl80211_attrs {
 
     NL80211_ATTR_SMPS_MODE,
 
+    NL80211_ATTR_PSK,
+
     /* add attributes here, update the policy in nl80211.c */
 
     __NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c index 5839c85..91c24b1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -395,6 +395,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
     [NL80211_ATTR_USER_PRIO] = { .type = NLA_U8 },
     [NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
     [NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
+    [NL80211_ATTR_PSK] = { .type = NLA_BINARY, .len = 32 },
 };
 
 /* policy for the key attributes */
@@ -7310,6 +7311,9 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
         connect.flags |= ASSOC_REQ_USE_RRM;
     }
 
+    if (info->attrs[NL80211_ATTR_PSK])
+        connect.psk = nla_data(info->attrs[NL80211_ATTR_PSK]);
+
     wdev_lock(dev->ieee80211_ptr);
     err = cfg80211_connect(rdev, dev, &connect, connkeys, NULL);
     wdev_unlock(dev->ieee80211_ptr);
--
1.9.1

