Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbbAYSzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:55:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbbAYSJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.18 055/183] xhci: Check if slot is already in default state before moving it there
Date: Sun, 25 Jan 2015 10:06:17 -0800
Message-Id: <20150125180812.556069498@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3803,6 +3803,15 @@ static int xhci_setup_device(struct usb_
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


