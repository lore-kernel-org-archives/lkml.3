Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3EYBlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 21:41:15 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46609 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3EYBlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 21:41:13 -0400
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Frank=20L=C3=B6mker?= <Frank.Loemker@isa.de.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: xhci: Use non-interruptible sleep for XHCI commands
Date: Fri, 24 May 2013 18:39:37 -0700
Message-Id: <1369445977-31404-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The XHCI stack usually uses wait_for_completion_interruptible_timeout()
to wait for the completion of an XHCI command, and treats both timeouts
and interruptions as errors. This is a bad idea, since these commands
are often essential for the correct operation of the USB stack, and
their failure can leave devices in a misconfigured and/or unusable
state. While a timeout probably means a real problem that needs to be
dealt with, a random signal to the controlling user-space process should
not cause such harsh consequences.

This patch changes that behavior to use uninterruptible waits instead.
It fixes an easy to reproduce bug that occurs when you kill -9 a
process that reads from a UVC camera. The UVC driver's release code
tries to set the camera's alternate setting back to 0, but the lingering
SIGKILL instantly aborts any Stop Endpoint or Configure Endpoint command
sent to the xHC. The code dies halfway through the bandwidth allocation
process, leaving the device in an active configuration and preventing
future access to it due to the now out-of-sync bandwidth calculation.

This patch should be backported to kernels as far 2.6.31 that contain
the commit 3ffbba9511b4148cbe1f6b6238686adaeaca8feb "USB: xhci: Allocate
and address USB devices".

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/host/xhci-hub.c |  7 +++----
 drivers/usb/host/xhci.c     | 26 +++++++++++---------------
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 187a3ec..c1bcfa8 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -293,12 +293,11 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	/* Wait for last stop endpoint command to finish */
-	timeleft = wait_for_completion_interruptible_timeout(
+	timeleft = wait_for_completion_timeout(
 			cmd->completion,
-			USB_CTRL_SET_TIMEOUT);
+			XHCI_CMD_DEFAULT_TIMEOUT);
 	if (timeleft <= 0) {
-		xhci_warn(xhci, "%s while waiting for stop endpoint command\n",
-				timeleft == 0 ? "Timeout" : "Signal");
+		xhci_warn(xhci, "Timeout while waiting for Stop Endpoint\n");
 		spin_lock_irqsave(&xhci->lock, flags);
 		/* The timeout might have raced with the event ring handler, so
 		 * only delete from the list if the item isn't poisoned.
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index b4aa79d..302f992 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2613,15 +2613,14 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	/* Wait for the configure endpoint command to complete */
-	timeleft = wait_for_completion_interruptible_timeout(
+	timeleft = wait_for_completion_timeout(
 			cmd_completion,
 			XHCI_CMD_DEFAULT_TIMEOUT);
 	if (timeleft <= 0) {
-		xhci_warn(xhci, "%s while waiting for %s command\n",
-				timeleft == 0 ? "Timeout" : "Signal",
+		xhci_warn(xhci, "Timeout while waiting for %s\n",
 				ctx_change == 0 ?
-					"configure endpoint" :
-					"evaluate context");
+					"Configure Endpoint" :
+					"Evaluate Context");
 		/* cancel the configure endpoint command */
 		ret = xhci_cancel_cmd(xhci, command, cmd_trb);
 		if (ret < 0)
@@ -3399,12 +3398,11 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	/* Wait for the Reset Device command to finish */
-	timeleft = wait_for_completion_interruptible_timeout(
+	timeleft = wait_for_completion_timeout(
 			reset_device_cmd->completion,
-			USB_CTRL_SET_TIMEOUT);
+			XHCI_CMD_DEFAULT_TIMEOUT);
 	if (timeleft <= 0) {
-		xhci_warn(xhci, "%s while waiting for reset device command\n",
-				timeleft == 0 ? "Timeout" : "Signal");
+		xhci_warn(xhci, "Timeout while waiting for Reset Device\n");
 		spin_lock_irqsave(&xhci->lock, flags);
 		/* The timeout might have raced with the event ring handler, so
 		 * only delete from the list if the item isn't poisoned.
@@ -3588,11 +3586,10 @@ int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev)
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	/* XXX: how much time for xHC slot assignment? */
-	timeleft = wait_for_completion_interruptible_timeout(&xhci->addr_dev,
+	timeleft = wait_for_completion_timeout(&xhci->addr_dev,
 			XHCI_CMD_DEFAULT_TIMEOUT);
 	if (timeleft <= 0) {
-		xhci_warn(xhci, "%s while waiting for a slot\n",
-				timeleft == 0 ? "Timeout" : "Signal");
+		xhci_warn(xhci, "Timeout while waiting for a slot\n");
 		/* cancel the enable slot request */
 		return xhci_cancel_cmd(xhci, NULL, cmd_trb);
 	}
@@ -3706,15 +3703,14 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
 	/* ctrl tx can take up to 5 sec; XXX: need more time for xHC? */
-	timeleft = wait_for_completion_interruptible_timeout(&xhci->addr_dev,
+	timeleft = wait_for_completion_timeout(&xhci->addr_dev,
 			XHCI_CMD_DEFAULT_TIMEOUT);
 	/* FIXME: From section 4.3.4: "Software shall be responsible for timing
 	 * the SetAddress() "recovery interval" required by USB and aborting the
 	 * command on a timeout.
 	 */
 	if (timeleft <= 0) {
-		xhci_warn(xhci, "%s while waiting for address device command\n",
-				timeleft == 0 ? "Timeout" : "Signal");
+		xhci_warn(xhci, "Timeout while waiting for Address Device\n");
 		/* cancel the address device command */
 		ret = xhci_cancel_cmd(xhci, NULL, cmd_trb);
 		if (ret < 0)
-- 
1.7.12.4

