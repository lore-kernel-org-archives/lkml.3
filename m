Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab3I3KiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:38:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab3I3KLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 013/104] USB: handle LPM errors during device suspend correctly
Date: Mon, 30 Sep 2013 11:09:50 +0100
Message-Id: <1380535881-9239-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit aa5ceae24bf8dff1d6fe87c6c4b08e69c6d33550 upstream.

The hub driver's usb_port_suspend() routine doesn't handle errors
related to Link Power Management properly.  It always returns failure,
it doesn't try to clean up the wakeup setting, (in the case of system
sleep) it doesn't try to go ahead with the port suspend regardless,
and it doesn't try to apply the new power-off mechanism.

This patch fixes these problems.

Note: Sarah fixed this patch to apply against 3.11, since the original
commit (4fae6f0fa86f92e6bc7429371b1e177ad0aaac66 "USB: handle LPM errors
during device suspend correctly") called usb_disable_remote_wakeup,
which won't be added until 3.12.

This patch should be backported to kernels as old as 3.5, that
contain the commit 8306095fd2c1100e8244c09bf560f97aca5a311d "USB:
Disable USB 3.0 LPM in critical sections.".  There will be merge
conflicts, since LTM wasn't added until 3.6.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
[ luis: backported to 3.5:
  - dropped LTM-related code
  - dropped code related with PM QoS ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hub.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8deaeb5..7be4e11 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2798,7 +2798,7 @@ int usb_port_suspend(struct usb_device *udev, pm_message_t msg)
 					status);
 			/* bail if autosuspend is requested */
 			if (PMSG_IS_AUTO(msg))
-				return status;
+				goto err_wakeup;
 		}
 	}
 
@@ -2807,9 +2807,10 @@ int usb_port_suspend(struct usb_device *udev, pm_message_t msg)
 		usb_set_usb2_hardware_lpm(udev, 0);
 
 	if (usb_unlocked_disable_lpm(udev)) {
-		dev_err(&udev->dev, "%s Failed to disable LPM before suspend\n.",
-				__func__);
-		return -ENOMEM;
+		dev_err(&udev->dev, "Failed to disable LPM before suspend\n.");
+		status = -ENOMEM;
+		if (PMSG_IS_AUTO(msg))
+			goto err_lpm3;
 	}
 
 	/* see 7.1.7.6 */
@@ -2823,27 +2824,29 @@ int usb_port_suspend(struct usb_device *udev, pm_message_t msg)
 	if (status) {
 		dev_dbg(hub->intfdev, "can't suspend port %d, status %d\n",
 				port1, status);
-		/* paranoia:  "should not happen" */
-		if (udev->do_remote_wakeup) {
-			if (!hub_is_superspeed(hub->hdev)) {
-				(void) usb_control_msg(udev,
-						usb_sndctrlpipe(udev, 0),
-						USB_REQ_CLEAR_FEATURE,
-						USB_RECIP_DEVICE,
-						USB_DEVICE_REMOTE_WAKEUP, 0,
-						NULL, 0,
-						USB_CTRL_SET_TIMEOUT);
-			} else
-				(void) usb_disable_function_remotewakeup(udev);
-
-		}
 
+		/* Try to enable USB3 LPM and LTM again */
+		usb_unlocked_enable_lpm(udev);
+ err_lpm3:
 		/* Try to enable USB2 hardware LPM again */
 		if (udev->usb2_hw_lpm_capable == 1)
 			usb_set_usb2_hardware_lpm(udev, 1);
 
-		/* Try to enable USB3 LPM again */
-		usb_unlocked_enable_lpm(udev);
+		if (udev->do_remote_wakeup) {
+			if (udev->speed < USB_SPEED_SUPER)
+				usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+						USB_REQ_CLEAR_FEATURE,
+						USB_RECIP_DEVICE,
+						USB_DEVICE_REMOTE_WAKEUP, 0,
+						NULL, 0, USB_CTRL_SET_TIMEOUT);
+			else
+				usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+						USB_REQ_CLEAR_FEATURE,
+						USB_RECIP_INTERFACE,
+						USB_INTRF_FUNC_SUSPEND, 0,
+						NULL, 0, USB_CTRL_SET_TIMEOUT);
+		}
+ err_wakeup:
 
 		/* System sleep transitions should never fail */
 		if (!PMSG_IS_AUTO(msg))
-- 
1.8.3.2

