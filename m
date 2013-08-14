Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab3HNKkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:40:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34731 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab3HNKie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julius Werner <jwerner@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 72/75] usb: core: don't try to reset_device() a port that got just disconnected
Date: Wed, 14 Aug 2013 11:37:01 +0100
Message-Id: <1376476624-10011-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hub.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index d5515c0..8deaeb5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4552,7 +4552,8 @@ static void hub_events(void)
 					hub->hdev->children[i - 1];
 
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				if (!udev) {
+				if (!udev || !(portstatus &
+						USB_PORT_STAT_CONNECTION)) {
 					status = hub_port_reset(hub, i,
 							NULL, HUB_BH_RESET_TIME,
 							true);
@@ -4562,8 +4563,8 @@ static void hub_events(void)
 					usb_lock_device(udev);
 					status = usb_reset_device(udev);
 					usb_unlock_device(udev);
+					connect_change = 0;
 				}
-				connect_change = 0;
 			}
 
 			if (connect_change)
-- 
1.8.3.2

