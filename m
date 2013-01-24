Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3AXDg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:36:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44365 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3AXDax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:30:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 52/74] USB: hub: handle claim of enabled remote wakeup after reset
Date: Thu, 24 Jan 2013 01:27:04 -0200
Message-Id: <1358998046-613-53-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/hub.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 2532bdc..92c0229 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2840,7 +2840,7 @@ int usb_port_suspend(struct usb_device *udev, pm_message_t msg)
 static int finish_port_resume(struct usb_device *udev)
 {
 	int	status = 0;
-	u16	devstatus;
+	u16	devstatus = 0;
 
 	/* caller owns the udev device lock */
 	dev_dbg(&udev->dev, "%s\n",
@@ -2885,7 +2885,13 @@ static int finish_port_resume(struct usb_device *udev)
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
-- 
1.7.9.5

