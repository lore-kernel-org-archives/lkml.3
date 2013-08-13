Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab3HMGd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:33:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320Ab3HMGdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julius Werner <jwerner@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 51/60] usb: core: dont try to reset_device() a port that got just disconnected
Date: Mon, 12 Aug 2013 23:34:18 -0700
Message-Id: <20130813063338.441075612@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4796,7 +4796,8 @@ static void hub_events(void)
 					hub->ports[i - 1]->child;
 
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				if (!udev) {
+				if (!udev || !(portstatus &
+						USB_PORT_STAT_CONNECTION)) {
 					status = hub_port_reset(hub, i,
 							NULL, HUB_BH_RESET_TIME,
 							true);
@@ -4806,8 +4807,8 @@ static void hub_events(void)
 					usb_lock_device(udev);
 					status = usb_reset_device(udev);
 					usb_unlock_device(udev);
+					connect_change = 0;
 				}
-				connect_change = 0;
 			}
 
 			if (connect_change)


