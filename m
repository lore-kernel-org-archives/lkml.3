Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3JUJBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:01:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39823 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410Ab3JUIw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Julius Werner" <jwerner@chromium.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.991940657@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 123/149] usb: core: don't try to reset_device() a port
 that got just disconnected
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Werner <jwerner@chromium.org>

commit 481f2d4f89f87a0baa26147f323380e31cfa7c44 upstream.

The USB hub driver's event handler contains a check to catch SuperSpeed
devices that transitioned into the SS.Inactive state and tries to fix
them with a reset. It decides whether to do a plain hub port reset or
call the usb_reset_device() function based on whether there was a device
attached to the port.

However, there are device/hub combinations (found with a JetFlash
Transcend mass storage stick (8564:1000) on the root hub of an Intel
LynxPoint PCH) which can transition to the SS.Inactive state on
disconnect (and stay there long enough for the host to notice). In this
case, above-mentioned reset check will call usb_reset_device() on the
stale device data structure. The kernel will send pointless LPM control
messages to the no longer connected device address and can even cause
several 5 second khubd stalls on some (buggy?) host controllers, before
finally accepting the device's fate amongst a flurry of error messages.

This patch makes the choice of reset dependent on the port status that
has just been read from the hub in addition to the existence of an
in-kernel data structure for the device, and only proceeds with the more
extensive reset if both are valid.

Signed-off-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3749,7 +3749,8 @@ static void hub_events(void)
 					hub->hdev->children[i - 1];
 
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				if (!udev) {
+				if (!udev || !(portstatus &
+						USB_PORT_STAT_CONNECTION)) {
 					status = hub_port_reset(hub, i,
 							NULL, HUB_BH_RESET_TIME,
 							true);
@@ -3759,8 +3760,8 @@ static void hub_events(void)
 					usb_lock_device(udev);
 					status = usb_reset_device(udev);
 					usb_unlock_device(udev);
+					connect_change = 0;
 				}
-				connect_change = 0;
 			}
 
 			if (connect_change)

