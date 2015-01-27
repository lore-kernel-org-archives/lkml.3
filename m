Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbbA0M22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:28:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35353 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbbA0MTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 097/126] xhci: Check if slot is already in default state before moving it there
Date: Tue, 27 Jan 2015 12:16:42 +0000
Message-Id: <1422361031-19364-98-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit f161ead70fa6a62e432dff6e9dab8e3cfbeabea6 upstream.

Solves xhci error cases with debug messages:
xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for slot 1.
usb 1-6: hub failed to enable device, error -22

xhci will give a context state error if we try to set a slot in default
state to the same default state with a special address device command.

Turns out this happends in several cases:
- retry reading the device rescriptor in hub_port_init()
- usb_reset_device() is called for a slot in default state
- in resume path, usb_port_resume() calls hub_port_init()

The default state is usually reached from most states with a reset device
command without any context state errors, but using the address device
command with BSA bit set (block set address) only works from the enabled
state and will otherwise cause context error.

solve this by checking if we are already in the default state before issuing
a address device BSA=1 command.

Fixes: 48fc7dbd52c0 ("usb: xhci: change enumeration scheme to 'new scheme'")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5e5f0c1b6613..b61913116fe2 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3812,6 +3812,15 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
 		return -EINVAL;
 	}
 
+	if (setup == SETUP_CONTEXT_ONLY) {
+		slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->out_ctx);
+		if (GET_SLOT_STATE(le32_to_cpu(slot_ctx->dev_state)) ==
+		    SLOT_STATE_DEFAULT) {
+			xhci_dbg(xhci, "Slot already in default state\n");
+			return 0;
+		}
+	}
+
 	command = xhci_alloc_command(xhci, false, false, GFP_KERNEL);
 	if (!command)
 		return -ENOMEM;
-- 
2.1.4

