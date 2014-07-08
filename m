Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbaGHTsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:48:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54041 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755653AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Will Deacon" <will.deacon@arm.com>,
        "Alan Stern" <stern@rowland.harvard.edu>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.900782906@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 013/125] USB: Avoid runtime suspend loops for HCDs
 that can't handle suspend/resume
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: runtime PM is also not supported for USB 3.0
 non-root hubs]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1686,10 +1686,13 @@ int usb_runtime_suspend(struct device *d
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
@@ -1370,14 +1370,24 @@ static int hub_probe(struct usb_interfac
 	desc = intf->cur_altsetting;
 	hdev = interface_to_usbdev(intf);
 
-	/* Hubs have proper suspend/resume support.  USB 3.0 device suspend is
+	/*
+	 * Hubs have proper suspend/resume support, except for root hubs
+	 * where the controller driver doesn't have bus_suspend and
+	 * bus_resume methods.  Also, USB 3.0 device suspend is
 	 * different from USB 2.0/1.1 device suspend, and unfortunately we
 	 * don't support it yet.  So leave autosuspend disabled for USB 3.0
 	 * external hubs for now.  Enable autosuspend for USB 3.0 roothubs,
 	 * since that isn't a "real" hub.
 	 */
-	if (!hub_is_superspeed(hdev) || !hdev->parent)
-		usb_enable_autosuspend(hdev);
+	if (hdev->parent) {		/* normal device */
+		if (!hub_is_superspeed(hdev))
+			usb_enable_autosuspend(hdev);
+	} else {			/* root hub */
+		const struct hc_driver *drv = bus_to_hcd(hdev->bus)->driver;
+
+		if (drv->bus_suspend && drv->bus_resume)
+			usb_enable_autosuspend(hdev);
+	}
 
 	if (hdev->level == MAX_TOPO_LEVEL) {
 		dev_err(&intf->dev,

