Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaFEEUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:20:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaFEEUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.4 056/214] rt2x00: fix beaconing on USB
Date: Wed,  4 Jun 2014 21:16:59 -0700
Message-Id: <20140605041646.992998926@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 8834d3608cc516f13e2e510f4057c263f3d2ce42 upstream.

When disable beaconing we clear register with beacon and newer set it
back, what make we stop send beacons infinitely.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2x00mac.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -651,20 +651,18 @@ void rt2x00mac_bss_info_changed(struct i
 				      bss_conf->bssid);
 
 	/*
-	 * Update the beacon. This is only required on USB devices. PCI
-	 * devices fetch beacons periodically.
-	 */
-	if (changes & BSS_CHANGED_BEACON && rt2x00_is_usb(rt2x00dev))
-		rt2x00queue_update_beacon(rt2x00dev, vif);
-
-	/*
 	 * Start/stop beaconing.
 	 */
 	if (changes & BSS_CHANGED_BEACON_ENABLED) {
 		if (!bss_conf->enable_beacon && intf->enable_beacon) {
-			rt2x00queue_clear_beacon(rt2x00dev, vif);
 			rt2x00dev->intf_beaconing--;
 			intf->enable_beacon = false;
+			/*
+			 * Clear beacon in the H/W for this vif. This is needed
+			 * to disable beaconing on this particular interface
+			 * and keep it running on other interfaces.
+			 */
+			rt2x00queue_clear_beacon(rt2x00dev, vif);
 
 			if (rt2x00dev->intf_beaconing == 0) {
 				/*
@@ -675,11 +673,15 @@ void rt2x00mac_bss_info_changed(struct i
 				rt2x00queue_stop_queue(rt2x00dev->bcn);
 				mutex_unlock(&intf->beacon_skb_mutex);
 			}
-
-
 		} else if (bss_conf->enable_beacon && !intf->enable_beacon) {
 			rt2x00dev->intf_beaconing++;
 			intf->enable_beacon = true;
+			/*
+			 * Upload beacon to the H/W. This is only required on
+			 * USB devices. PCI devices fetch beacons periodically.
+			 */
+			if (rt2x00_is_usb(rt2x00dev))
+				rt2x00queue_update_beacon(rt2x00dev, vif);
 
 			if (rt2x00dev->intf_beaconing == 1) {
 				/*


