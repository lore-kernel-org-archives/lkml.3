Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaHDREX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:04:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56542 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Gavin Guo" <gavin.guo@canonical.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.984799135@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 54/94] usb: Check if port status is equal to RxDetect
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: use hub device as context for dev_dbg(),
 as hub ports are not devices in their own right]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -655,6 +655,26 @@ static int hub_usb3_port_disable(struct
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
+		dev_dbg(hub->intfdev,
+			"Not disabling port %d; link state is RxDetect\n",
+			port1);
+		return ret;
+	}
+
 	ret = hub_set_port_link_state(hub, port1, USB_SS_PORT_LS_SS_DISABLED);
 	if (ret) {
 		dev_err(hub->intfdev, "cannot disable port %d (err = %d)\n",

