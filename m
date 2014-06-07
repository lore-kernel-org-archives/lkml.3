Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaFGB1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:27:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36154 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752695AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Stanislaw Gruszka" <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.531118585@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 28/92] rt2x00: fix beaconing on USB
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 8834d3608cc516f13e2e510f4057c263f3d2ce42 upstream.

When disable beaconing we clear register with beacon and newer set it
back, what make we stop send beacons infinitely.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c | 22 ++++++++++++----------
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

