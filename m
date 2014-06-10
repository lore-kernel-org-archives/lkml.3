Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014AbaFJArG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:47:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880AbaFJAV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:21:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.4 16/88] USB: Avoid runtime suspend loops for HCDs that cant handle suspend/resume
Date: Mon,  9 Jun 2014 17:24:26 -0700
Message-Id: <20140610002425.068184009@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 8ef42ddd9a53b73e6fc3934278710c27f80f324f upstream.

Not all host controller drivers have bus-suspend and bus-resume
methods.  When one doesn't, it will cause problems if runtime PM is
enabled in the kernel.  The PM core will attempt to suspend the
controller's root hub, the suspend will fail because there is no
bus-suspend routine, and a -EBUSY error code will be returned to the
PM core.  This will cause the suspend attempt to be repeated shortly
thereafter, in a never-ending loop.

Part of the problem is that the original error code -ENOENT gets
changed to -EBUSY in usb_runtime_suspend(), on the grounds that the PM
core will interpret -ENOENT as meaning that the root hub has gotten
into a runtime-PM error state.  While this change is appropriate for
real USB devices, it's not such a good idea for a root hub.  In fact,
considering the root hub to be in a runtime-PM error state would not
be far from the truth.  Therefore this patch updates
usb_runtime_suspend() so that it adjusts error codes only for
non-root-hub devices.

Furthermore, the patch attempts to prevent the problem from occurring
in the first place by not enabling runtime PM by default for root hubs
whose host controller driver doesn't have bus_suspend and bus_resume
methods.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Will Deacon <will.deacon@arm.com>
Tested-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/driver.c |    9 ++++++---
 drivers/usb/core/hub.c    |   15 +++++++++++++--
 2 files changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1708,10 +1708,13 @@ int usb_runtime_suspend(struct device *d
 	if (status == -EAGAIN || status == -EBUSY)
 		usb_mark_last_busy(udev);
 
-	/* The PM core reacts badly unless the return code is 0,
-	 * -EAGAIN, or -EBUSY, so always return -EBUSY on an error.
+	/*
+	 * The PM core reacts badly unless the return code is 0,
+	 * -EAGAIN, or -EBUSY, so always return -EBUSY on an error
+	 * (except for root hubs, because they don't suspend through
+	 * an upstream port like other USB devices).
 	 */
-	if (status != 0)
+	if (status != 0 && udev->parent)
 		return -EBUSY;
 	return status;
 }
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1401,8 +1401,19 @@ static int hub_probe(struct usb_interfac
 	desc = intf->cur_altsetting;
 	hdev = interface_to_usbdev(intf);
 
-	/* Hubs have proper suspend/resume support. */
-	usb_enable_autosuspend(hdev);
+	/*
+	 * Hubs have proper suspend/resume support, except for root hubs
+	 * where the controller driver doesn't have bus_suspend and
+	 * bus_resume methods.
+	 */
+	if (hdev->parent) {		/* normal device */
+		usb_enable_autosuspend(hdev);
+	} else {			/* root hub */
+		const struct hc_driver *drv = bus_to_hcd(hdev->bus)->driver;
+
+		if (drv->bus_suspend && drv->bus_resume)
+			usb_enable_autosuspend(hdev);
+	}
 
 	if (hdev->level == MAX_TOPO_LEVEL) {
 		dev_err(&intf->dev,


