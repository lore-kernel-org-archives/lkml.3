Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab3G3RI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 13:08:56 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33027 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab3G3RIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 13:08:54 -0400
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andiry Xu <andiry.xu@amd.com>, Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: core: don't try to reset_device() a port that got just disconnected
Date: Tue, 30 Jul 2013 10:08:10 -0700
Message-Id: <1375204090-27465-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB hub driver's event handler contains a check to catch SuperSpeed
devices that transitioned into the SS.Inactive state and tries to fix
them with a reset. It decides whether to do a plain hub port reset or
call the usb_reset_device() method based on whether there was a device
attached to the port.

However, there are device/hub combinations (found with a JetFlash
Transcend mass storage stick (8564:1000) on the root hub of an Intel
LynxPoint PCH) which can transition to the SS.Inactive state on
disconnect (and stay there long enough for the host to notice). In this
case, above-mentioned reset check will call usb_reset_device() on the
now disconnected device. This leads to a futile attempt of asking a
bunch of floating wires to disable device-initiated U1 and U2, each
stalling khubd for a 5 second timeout before finally accepting the
device's fate amongst a flurry of error messages.

This patch makes the choice of reset dependent on the port status that
has just been read from the hub, as opposed to any previous in-kernel
state, thus working around this problem.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/core/hub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 4a8a1d6..ace0c52 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4798,7 +4798,7 @@ static void hub_events(void)
 					hub->ports[i - 1]->child;
 
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				if (!udev) {
+				if (!(portstatus & USB_PORT_STAT_CONNECTION)) {
 					status = hub_port_reset(hub, i,
 							NULL, HUB_BH_RESET_TIME,
 							true);
@@ -4808,8 +4808,8 @@ static void hub_events(void)
 					usb_lock_device(udev);
 					status = usb_reset_device(udev);
 					usb_unlock_device(udev);
+					connect_change = 0;
 				}
-				connect_change = 0;
 			}
 
 			if (connect_change)
-- 
1.7.12.4

