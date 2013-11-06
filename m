Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3KFU1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:27:39 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48277 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3KFU1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:27:37 -0500
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED
Date: Wed,  6 Nov 2013 12:27:21 -0800
Message-Id: <1383769641-22910-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a check for USB_STATE_NOTATTACHED to the
hub_port_warm_reset_required() workaround for ports that end up in
Compliance Mode in hub_events() when trying to decide which reset
function to use. Trying to call usb_reset_device() with a NOTATTACHED
device will just fail and leave the port broken.

Also bumped the messages about this kind of reset failure from dev_dbg()
to dev_warn() to make it easier to notice, since calling that function
with a NOTATTACHED device would almost always be a bug

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/core/hub.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index e6b682c..0188056 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4799,8 +4799,9 @@ static void hub_events(void)
 					hub->ports[i - 1]->child;
 
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				if (!udev || !(portstatus &
-						USB_PORT_STAT_CONNECTION)) {
+				if (!udev ||
+				    !(portstatus & USB_PORT_STAT_CONNECTION) ||
+				    udev->state == USB_STATE_NOTATTACHED) {
 					status = hub_port_reset(hub, i,
 							NULL, HUB_BH_RESET_TIME,
 							true);
@@ -5074,7 +5075,7 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
 
 	if (udev->state == USB_STATE_NOTATTACHED ||
 			udev->state == USB_STATE_SUSPENDED) {
-		dev_dbg(&udev->dev, "device reset not allowed in state %d\n",
+		dev_warn(&udev->dev, "device reset not allowed in state %d\n",
 				udev->state);
 		return -EINVAL;
 	}
@@ -5237,7 +5238,7 @@ int usb_reset_device(struct usb_device *udev)
 
 	if (udev->state == USB_STATE_NOTATTACHED ||
 			udev->state == USB_STATE_SUSPENDED) {
-		dev_dbg(&udev->dev, "device reset not allowed in state %d\n",
+		dev_warn(&udev->dev, "device reset not allowed in state %d\n",
 				udev->state);
 		return -EINVAL;
 	}
-- 
1.8.4.1

