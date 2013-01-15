Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab3APAC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:02:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:43376 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632Ab3AOWfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Oliver Neukum <oneukum@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 178/221] USB: hub: handle claim of enabled remote wakeup after reset
Date: Tue, 15 Jan 2013 10:51:45 -0800
Message-Id: <20130115185010.880210531@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/core/hub.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2960,7 +2960,7 @@ int usb_port_suspend(struct usb_device *
 static int finish_port_resume(struct usb_device *udev)
 {
 	int	status = 0;
-	u16	devstatus;
+	u16	devstatus = 0;
 
 	/* caller owns the udev device lock */
 	dev_dbg(&udev->dev, "%s\n",
@@ -3005,7 +3005,13 @@ static int finish_port_resume(struct usb
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


