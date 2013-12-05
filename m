Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3LERum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:50:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38288 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933408Ab3LERhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 43/90] rtlwifi: Fix endian error in extracting packet type
Date: Thu,  5 Dec 2013 17:35:25 +0000
Message-Id: <1386264972-5399-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>

commit 0c5d63f0ab6728f05ddefa25aff55e31297f95e6 upstream.

All of the rtlwifi drivers have an error in the routine that tests if
the data is "special". If it is, the subsequant transmission will be
at the lowest rate to enhance reliability. The 16-bit quantity is
big-endian, but was being extracted in native CPU mode. One of the
effects of this bug is to inhibit association under some conditions
as the TX rate is too high.

Based on suggestions by Joe Perches, the entire routine is rewritten.

One of the local headers contained duplicates of some of the ETH_P_XXX
definitions. These are deleted.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ luis: backported to 3.5: since commit a269913 has not been backported:
  - dropped changes to rtl_priv->enter_ps field
  - replaced lps_change_work by lps_leave_work  ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rtlwifi/base.c | 89 +++++++++++++++++--------------------
 drivers/net/wireless/rtlwifi/wifi.h |  6 +--
 2 files changed, 41 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 4110a6d..c78fb9a 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -37,6 +37,7 @@
 
 #include <linux/ip.h>
 #include <linux/module.h>
+#include <linux/udp.h>
 
 /*
  *NOTICE!!!: This file will be very big, we should
@@ -957,61 +958,51 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 	if (!ieee80211_is_data(fc))
 		return false;
 
+	ip = (const struct iphdr *)(skb->data + mac_hdr_len +
+				    SNAP_SIZE + PROTOC_TYPE_SIZE);
+	ether_type = be16_to_cpup((__be16 *)
+				  (skb->data + mac_hdr_len + SNAP_SIZE));
 
-	ip = (struct iphdr *)((u8 *) skb->data + mac_hdr_len +
-			      SNAP_SIZE + PROTOC_TYPE_SIZE);
-	ether_type = *(u16 *) ((u8 *) skb->data + mac_hdr_len + SNAP_SIZE);
-	/*	ether_type = ntohs(ether_type); */
-
-	if (ETH_P_IP == ether_type) {
-		if (IPPROTO_UDP == ip->protocol) {
-			struct udphdr *udp = (struct udphdr *)((u8 *) ip +
-							       (ip->ihl << 2));
-			if (((((u8 *) udp)[1] == 68) &&
-			     (((u8 *) udp)[3] == 67)) ||
-			    ((((u8 *) udp)[1] == 67) &&
-			     (((u8 *) udp)[3] == 68))) {
-				/*
-				 * 68 : UDP BOOTP client
-				 * 67 : UDP BOOTP server
-				 */
-				RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV),
-					 DBG_DMESG, "dhcp %s !!\n",
-					 is_tx ? "Tx" : "Rx");
-
-				if (is_tx) {
-					schedule_work(&rtlpriv->
-						      works.lps_leave_work);
-					ppsc->last_delaylps_stamp_jiffies =
-					    jiffies;
-				}
+	switch (ether_type) {
+	case ETH_P_IP: {
+		struct udphdr *udp;
+		u16 src;
+		u16 dst;
 
-				return true;
-			}
-		}
-	} else if (ETH_P_ARP == ether_type) {
-		if (is_tx) {
-			schedule_work(&rtlpriv->works.lps_leave_work);
-			ppsc->last_delaylps_stamp_jiffies = jiffies;
-		}
+		if (ip->protocol != IPPROTO_UDP)
+			return false;
+		udp = (struct udphdr *)((u8 *)ip + (ip->ihl << 2));
+		src = be16_to_cpu(udp->source);
+		dst = be16_to_cpu(udp->dest);
 
-		return true;
-	} else if (ETH_P_PAE == ether_type) {
+		/* If this case involves port 68 (UDP BOOTP client) connecting
+		 * with port 67 (UDP BOOTP server), then return true so that
+		 * the lowest speed is used.
+		 */
+		if (!((src == 68 && dst == 67) || (src == 67 && dst == 68)))
+			return false;
+
+		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
+			 "dhcp %s !!\n", is_tx ? "Tx" : "Rx");
+		break;
+	}
+	case ETH_P_ARP:
+		break;
+	case ETH_P_PAE:
 		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
 			 "802.1X %s EAPOL pkt!!\n", is_tx ? "Tx" : "Rx");
-
-		if (is_tx) {
-			schedule_work(&rtlpriv->works.lps_leave_work);
-			ppsc->last_delaylps_stamp_jiffies = jiffies;
-		}
-
-		return true;
-	} else if (ETH_P_IPV6 == ether_type) {
-		/* IPv6 */
-		return true;
+		break;
+	case ETH_P_IPV6:
+		/* TODO: Is this right? */
+		return false;
+	default:
+		return false;
 	}
-
-	return false;
+	if (is_tx) {
+		schedule_work(&rtlpriv->works.lps_leave_work);
+		ppsc->last_delaylps_stamp_jiffies = jiffies;
+	}
+	return true;
 }
 
 /*********************************************************
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index dec7c55..fa02202 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -77,11 +77,7 @@
 #define RTL_SLOT_TIME_9				9
 #define RTL_SLOT_TIME_20			20
 
-/*related with tcp/ip. */
-/*if_ehther.h*/
-#define ETH_P_PAE		0x888E	/*Port Access Entity (IEEE 802.1X) */
-#define ETH_P_IP		0x0800	/*Internet Protocol packet */
-#define ETH_P_ARP		0x0806	/*Address Resolution packet */
+/*related to tcp/ip. */
 #define SNAP_SIZE		6
 #define PROTOC_TYPE_SIZE	2
 
-- 
1.8.3.2

