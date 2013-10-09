Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab3JIBNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:13:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:47761 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab3JIBNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:13:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1059,1371106800"; 
   d="scan'208";a="390307084"
Subject: [PATCH] xhci: correct the usage of USB_CTRL_SET_TIMEOUT
From: Xiao Jin <jin.xiao@intel.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com, sboyd@codeaurora.org,
        jslaby@suse.cz
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Oct 2013 09:25:19 +0800
Message-ID: <1381281919.9531.12.camel@xiaojin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiao jin <jin.xiao@intel.com>
Date: Wed, 9 Oct 2013 09:09:46 +0800
Subject: [PATCH] xhci: correct the usage of USB_CTRL_SET_TIMEOUT

The usage of USB_CTRL_SET_TIMEOUT is incorrect. The
definition of USB_CTRL_SET_TIMEOUT is 5000ms. The
input timeout to wait_for_completion_interruptible_timeout
is jiffies. That makes the timeout be longer than what
we want, such as 50s in some platform.

The patch is to convert USB_CTRL_SET_TIMEOUT to jiffies as
command completion event timeout.

Signed-off-by: xiao jin <jin.xiao@intel.com>
---
 drivers/usb/host/xhci-hub.c |    2 +-
 drivers/usb/host/xhci.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-hub.c b/drivers/usb/host/xhci-hub.c
index 1d35459..78cf294 100644
--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -295,7 +295,7 @@ static int xhci_stop_device(struct xhci_hcd *xhci, int slot_id, int suspend)
 	/* Wait for last stop endpoint command to finish */
 	timeleft = wait_for_completion_interruptible_timeout(
 			cmd->completion,
-			USB_CTRL_SET_TIMEOUT);
+			msecs_to_jiffies(USB_CTRL_SET_TIMEOUT));
 	if (timeleft <= 0) {
 		xhci_warn(xhci, "%s while waiting for stop endpoint command\n",
 				timeleft == 0 ? "Timeout" : "Signal");
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 9478caa..f9ebc72 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3486,7 +3486,7 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 	/* Wait for the Reset Device command to finish */
 	timeleft = wait_for_completion_interruptible_timeout(
 			reset_device_cmd->completion,
-			USB_CTRL_SET_TIMEOUT);
+			msecs_to_jiffies(USB_CTRL_SET_TIMEOUT));
 	if (timeleft <= 0) {
 		xhci_warn(xhci, "%s while waiting for reset device command\n",
 				timeleft == 0 ? "Timeout" : "Signal");
-- 
1.7.1



