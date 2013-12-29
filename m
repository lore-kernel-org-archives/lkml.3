Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab3L2CWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:22:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55590 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550Ab3L2CLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:11 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Mark Cave-Ayland" <mark.cave-ayland@ilande.co.uk>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.484809881@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 046/185] rtlwifi: Fix endian error in extracting
 packet type
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context; use rtl_lps_leave()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -31,6 +31,7 @@
 
 #include <linux/ip.h>
 #include <linux/module.h>
+#include <linux/udp.h>
 #include "wifi.h"
 #include "rc.h"
 #include "base.h"
@@ -956,60 +957,51 @@ u8 rtl_is_special_data(struct ieee80211_
 	if (!ieee80211_is_data(fc))
 		return false;
 
+	ip = (const struct iphdr *)(skb->data + mac_hdr_len +
+				    SNAP_SIZE + PROTOC_TYPE_SIZE);
+	ether_type = be16_to_cpup((__be16 *)
+				  (skb->data + mac_hdr_len + SNAP_SIZE));
+
+	switch (ether_type) {
+	case ETH_P_IP: {
+		struct udphdr *udp;
+		u16 src;
+		u16 dst;
+
+		if (ip->protocol != IPPROTO_UDP)
+			return false;
+		udp = (struct udphdr *)((u8 *)ip + (ip->ihl << 2));
+		src = be16_to_cpu(udp->source);
+		dst = be16_to_cpu(udp->dest);
+
+		/* If this case involves port 68 (UDP BOOTP client) connecting
+		 * with port 67 (UDP BOOTP server), then return true so that
+		 * the lowest speed is used.
+		 */
+		if (!((src == 68 && dst == 67) || (src == 67 && dst == 68)))
+			return false;
 
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
-					 DBG_DMESG, ("dhcp %s !!\n",
-						     (is_tx) ? "Tx" : "Rx"));
-
-				if (is_tx) {
-					rtl_lps_leave(hw);
-					ppsc->last_delaylps_stamp_jiffies =
-					    jiffies;
-				}
-
-				return true;
-			}
-		}
-	} else if (ETH_P_ARP == ether_type) {
-		if (is_tx) {
-			rtl_lps_leave(hw);
-			ppsc->last_delaylps_stamp_jiffies = jiffies;
-		}
-
-		return true;
-	} else if (ETH_P_PAE == ether_type) {
 		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
-			 ("802.1X %s EAPOL pkt!!\n", (is_tx) ? "Tx" : "Rx"));
-
-		if (is_tx) {
-			rtl_lps_leave(hw);
-			ppsc->last_delaylps_stamp_jiffies = jiffies;
-		}
-
-		return true;
-	} else if (ETH_P_IPV6 == ether_type) {
-		/* IPv6 */
-		return true;
+			 ("dhcp %s !!\n", is_tx ? "Tx" : "Rx"));
+		break;
 	}
-
-	return false;
+	case ETH_P_ARP:
+		break;
+	case ETH_P_PAE:
+		RT_TRACE(rtlpriv, (COMP_SEND | COMP_RECV), DBG_DMESG,
+			 ("802.1X %s EAPOL pkt!!\n", is_tx ? "Tx" : "Rx"));
+		break;
+	case ETH_P_IPV6:
+		/* TODO: Is this right? */
+		return false;
+	default:
+		return false;
+	}
+	if (is_tx) {
+		rtl_lps_leave(hw);
+		ppsc->last_delaylps_stamp_jiffies = jiffies;
+	}
+	return true;
 }
 
 /*********************************************************
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -73,11 +73,7 @@
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
 

