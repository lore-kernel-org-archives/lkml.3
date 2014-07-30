Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaG3MPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:15:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36624 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732AbaG3MPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gavin Guo <gavin.guo@canonical.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 11/94] usb: Check if port status is equal to RxDetect
Date: Wed, 30 Jul 2014 14:14:00 +0200
Message-Id: <3f37d94004366c229b0a24e702d15d19d0c1c93c.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gavin Guo <gavin.guo@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/core/hub.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 60a1f13db296..9c63a76cfedd 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -891,6 +891,25 @@ static int hub_usb3_port_disable(struct usb_hub *hub, int port1)
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
2.0.1

