Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab3BCOzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:55:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34232 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462Ab3BCOzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:45 -0500
Message-Id: <20130203144647.701647858@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Oliver Neukum <oliver@neukum.org>,
        Oliver Neukum <oneukum@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 041/128] USB: hub: handle claim of enabled remote wakeup after reset
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 07e72b95f5038cc82304b9a4a2eb7f9fc391ea68 upstream.

Some touchscreens have buggy firmware which claims
remote wakeup to be enabled after a reset. They nevertheless
crash if the feature is cleared by the host.
Add a check for reset resume before checking for
an enabled remote wakeup feature. On compliant
devices the feature must be cleared after a reset anyway.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 9641e9c..957ed2c 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3000,7 +3000,7 @@ int usb_port_suspend(struct usb_device *udev, pm_message_t msg)
 static int finish_port_resume(struct usb_device *udev)
 {
 	int	status = 0;
-	u16	devstatus;
+	u16	devstatus = 0;
 
 	/* caller owns the udev device lock */
 	dev_dbg(&udev->dev, "%s\n",
@@ -3045,7 +3045,13 @@ static int finish_port_resume(struct usb_device *udev)
 	if (status) {
 		dev_dbg(&udev->dev, "gone after usb resume? status %d\n",
 				status);
-	} else if (udev->actconfig) {
+	/*
+	 * There are a few quirky devices which violate the standard
+	 * by claiming to have remote wakeup enabled after a reset,
+	 * which crash if the feature is cleared, hence check for
+	 * udev->reset_resume
+	 */
+	} else if (udev->actconfig && !udev->reset_resume) {
 		le16_to_cpus(&devstatus);
 		if (devstatus & (1 << USB_DEVICE_REMOTE_WAKEUP)) {
 			status = usb_control_msg(udev,


