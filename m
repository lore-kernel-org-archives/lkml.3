Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaHRKDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:03:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42541 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbaHRJeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gavin Guo <gavin.guo@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 029/137] usb: Check if port status is equal to RxDetect
Date: Mon, 18 Aug 2014 10:31:30 +0100
Message-Id: <1408354398-10226-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Guo <gavin.guo@canonical.com>

commit bb86cf569bbd7ad4dce581a37c7fbd748057e9dc upstream.

When using USB 3.0 pen drive with the [AMD] FCH USB XHCI Controller
[1022:7814], the second hotplugging will experience the USB 3.0 pen
drive is recognized as high-speed device. After bisecting the kernel,
I found the commit number 41e7e056cdc662f704fa9262e5c6e213b4ab45dd
(USB: Allow USB 3.0 ports to be disabled.) causes the bug. After doing
some experiments, the bug can be fixed by avoiding executing the function
hub_usb3_port_disable(). Because the port status with [AMD] FCH USB
XHCI Controlleris [1022:7814] is already in RxDetect
(I tried printing out the port status before setting to Disabled state),
it's reasonable to check the port status before really executing
hub_usb3_port_disable().

Fixes: 41e7e056cdc6 (USB: Allow USB 3.0 ports to be disabled.)
Signed-off-by: Gavin Guo <gavin.guo@canonical.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hub.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 5e0925a01475..9361f2338be4 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -887,6 +887,25 @@ static int hub_usb3_port_disable(struct usb_hub *hub, int port1)
 	if (!hub_is_superspeed(hub->hdev))
 		return -EINVAL;
 
+	ret = hub_port_status(hub, port1, &portstatus, &portchange);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * USB controller Advanced Micro Devices, Inc. [AMD] FCH USB XHCI
+	 * Controller [1022:7814] will have spurious result making the following
+	 * usb 3.0 device hotplugging route to the 2.0 root hub and recognized
+	 * as high-speed device if we set the usb 3.0 port link state to
+	 * Disabled. Since it's already in USB_SS_PORT_LS_RX_DETECT state, we
+	 * check the state here to avoid the bug.
+	 */
+	if ((portstatus & USB_PORT_STAT_LINK_STATE) ==
+				USB_SS_PORT_LS_RX_DETECT) {
+		dev_dbg(&hub->ports[port1 - 1]->dev,
+			 "Not disabling port; link state is RxDetect\n");
+		return ret;
+	}
+
 	ret = hub_set_port_link_state(hub, port1, USB_SS_PORT_LS_SS_DISABLED);
 	if (ret)
 		return ret;
-- 
1.9.1

