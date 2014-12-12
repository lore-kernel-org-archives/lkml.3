Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031024AbaLLR6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:58:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:60984 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935169AbaLLR6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:58:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="652982486"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] xhci: Check if slot is already in default state before moving it there
Date: Fri, 12 Dec 2014 19:58:19 +0200
Message-Id: <1418407099-15347-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <548B29CA.5060707@intel.com>
References: <548B29CA.5060707@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: <stable@vger.kernel.org> # v3.14+
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/host/xhci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 5be1bff..7245163 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3803,6 +3803,15 @@ static int xhci_setup_device(struct usb_hcd *hcd, struct usb_device *udev,
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
1.8.3.2

