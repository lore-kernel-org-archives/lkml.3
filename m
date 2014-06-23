Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaFWIwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:52:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55526 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 054/111] USB: Avoid runtime suspend loops for HCDs that can't handle suspend/resume
Date: Mon, 23 Jun 2014 10:31:29 +0200
Message-Id: <7db4c4d2e0e04ea112a1900aea2fa3a746ebe633.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/core/driver.c |  9 ++++++---
 drivers/usb/core/hub.c    | 15 +++++++++++++--
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 2ddc586457c8..bfddeb3bc97e 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1770,10 +1770,13 @@ int usb_runtime_suspend(struct device *dev)
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
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 5064fc8ba14f..60a1f13db296 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1688,8 +1688,19 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	 */
 	pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
 
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
-- 
2.0.0

