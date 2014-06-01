Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbaFAHYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 03:24:47 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:52778 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbaFAHYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 03:24:46 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: vitaly.osipov@gmail.com, ztugcesirin@gmail.com, josh@joshtriplett.org,
        himangi774@gmail.com, superna9999@gmail.com,
        paul.gortmaker@windriver.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/wlan-ng: use ether_addr_equal_unaligned
Date: Sun,  1 Jun 2014 09:22:05 +0200
Message-Id: <1401607325-32733-1-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch get rid of all memcmp() on ethernet addresses in wlan-ng.
Replaced with ether_addr_equal_unaligned().

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/p80211conv.c |  6 +++---
 drivers/staging/wlan-ng/prism2sta.c  | 16 +++++++++-------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index 913676e..fb8a628 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -241,7 +241,7 @@ static void orinoco_spy_gather(wlandevice_t *wlandev, char *mac,
 
 	for (i = 0; i < wlandev->spy_number; i++) {
 
-		if (!memcmp(wlandev->spy_address[i], mac, ETH_ALEN)) {
+		if (ether_addr_equal_unaligned(wlandev->spy_address[i], mac)) {
 			memcpy(wlandev->spy_address[i], mac, ETH_ALEN);
 			wlandev->spy_stat[i].level = rxmeta->signal;
 			wlandev->spy_stat[i].noise = rxmeta->noise;
@@ -359,8 +359,8 @@ int skb_p80211_to_ether(wlandevice_t *wlandev, u32 ethconv,
 	/* Test for the various encodings */
 	if ((payload_length >= sizeof(struct wlan_ethhdr)) &&
 	    (e_llc->dsap != 0xaa || e_llc->ssap != 0xaa) &&
-	    ((memcmp(daddr, e_hdr->daddr, WLAN_ETHADDR_LEN) == 0) ||
-	     (memcmp(saddr, e_hdr->saddr, WLAN_ETHADDR_LEN) == 0))) {
+	    (ether_addr_equal_unaligned(daddr, e_hdr->daddr) ||
+	     ether_addr_equal_unaligned(saddr, e_hdr->saddr))) {
 		pr_debug("802.3 ENCAP len: %d\n", payload_length);
 		/* 802.3 Encapsulated */
 		/* Test for an overlength frame */
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 278b6a1..d2e492c 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -56,6 +56,7 @@
 #include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/etherdevice.h>
 #include <linux/wireless.h>
 #include <linux/netdevice.h>
 #include <linux/workqueue.h>
@@ -1505,7 +1506,8 @@ static void prism2sta_inf_assocstatus(wlandevice_t *wlandev,
 	 */
 
 	for (i = 0; i < hw->authlist.cnt; i++)
-		if (memcmp(rec.sta_addr, hw->authlist.addr[i], ETH_ALEN) == 0)
+		if (ether_addr_equal_unaligned(rec.sta_addr,
+					       hw->authlist.addr[i]))
 			break;
 
 	if (i >= hw->authlist.cnt) {
@@ -1587,8 +1589,8 @@ static void prism2sta_inf_authreq_defer(wlandevice_t *wlandev,
 		 */
 
 		for (i = 0; i < hw->authlist.cnt; i++)
-			if (memcmp(rec.address, hw->authlist.addr[i],
-				   ETH_ALEN) == 0) {
+			if (ether_addr_equal_unaligned(rec.address,
+						       hw->authlist.addr[i])) {
 				rec.status = P80211ENUM_status_successful;
 				break;
 			}
@@ -1625,7 +1627,7 @@ static void prism2sta_inf_authreq_defer(wlandevice_t *wlandev,
 		}
 
 		for (i = 0; i < cnt; i++, addr += ETH_ALEN)
-			if (memcmp(rec.address, addr, ETH_ALEN) == 0) {
+			if (ether_addr_equal_unaligned(rec.address, addr)) {
 				rec.status = P80211ENUM_status_successful;
 				break;
 			}
@@ -1655,7 +1657,7 @@ static void prism2sta_inf_authreq_defer(wlandevice_t *wlandev,
 		rec.status = P80211ENUM_status_successful;
 
 		for (i = 0; i < cnt; i++, addr += ETH_ALEN)
-			if (memcmp(rec.address, addr, ETH_ALEN) == 0) {
+			if (ether_addr_equal_unaligned(rec.address, addr)) {
 				rec.status = P80211ENUM_status_unspec_failure;
 				break;
 			}
@@ -1676,8 +1678,8 @@ static void prism2sta_inf_authreq_defer(wlandevice_t *wlandev,
 
 	if (rec.status == P80211ENUM_status_successful) {
 		for (i = 0; i < hw->authlist.cnt; i++)
-			if (memcmp(rec.address, hw->authlist.addr[i], ETH_ALEN)
-			    == 0)
+			if (ether_addr_equal_unaligned(rec.address,
+						       hw->authlist.addr[i]))
 				break;
 
 		if (i >= hw->authlist.cnt) {
-- 
1.9.0

