Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3JKAp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:45:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:50454 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab3JKAp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:45:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1075,1371106800"; 
   d="scan'208";a="417487704"
From: xiao jin <jin.xiao@intel.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: xiao jin <jin.xiao@intel.com>
Subject: [PATCH v2] xhci: correct the usage of USB_CTRL_SET_TIMEOUT
Date: Fri, 11 Oct 2013 08:57:03 +0800
Message-Id: <1381453023-32727-1-git-send-email-jin.xiao@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of USB_CTRL_SET_TIMEOUT in xhci is incorrect.
The definition of USB_CTRL_SET_TIMEOUT is 5000ms. The
input timeout to wait_for_completion_interruptible_timeout
is jiffies. That makes the timeout be longer than what
we want, such as 50s in some platform.

The patch is to use XHCI_CMD_DEFAULT_TIMEOUT instead of
USB_CTRL_SET_TIMEOUT as command completion event timeout.

Signed-off-by: xiao jin <jin.xiao@intel.com>
---
 drivers/usb/host/xhci-hub.c |    2 +-
 drivers/usb/host/xhci.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 1d35459..8dbaa81 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -295,7 +295,7 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 	/* Wait for last stop endpoint command to finish */
 	timeleft = wait_for_completion_interruptible_timeout(
 			cmd->completion,
-			USB_CTRL_SET_TIMEOUT);
+			XHCI_CMD_DEFAULT_TIMEOUT);
 	if (timeleft <= 0) {
 		xhci_warn(xhci, "%s while waiting for stop endpoint command\n",
 				timeleft == 0 ? "Timeout" : "Signal");
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 9478caa..5dc6903 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3486,7 +3486,7 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 	/* Wait for the Reset Device command to finish */
 	timeleft = wait_for_completion_interruptible_timeout(
 			reset_device_cmd->completion,
-			USB_CTRL_SET_TIMEOUT);
+			XHCI_CMD_DEFAULT_TIMEOUT);
 	if (timeleft <= 0) {
 		xhci_warn(xhci, "%s while waiting for reset device command\n",
 				timeleft == 0 ? "Timeout" : "Signal");
-- 
1.7.0.4

