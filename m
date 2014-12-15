Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaLOTne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:43:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaLOTax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:30:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 49/96] USB: xhci: don't start a halted endpoint before its new dequeue is set
Date: Mon, 15 Dec 2014 11:26:09 -0800
Message-Id: <1418671616-25482-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit c3492dbfa1050debf23a5b5cd2bc7514c5b37896 upstream.

A halted endpoint ring must first be reset, then move the ring
dequeue pointer past the problematic TRB. If we start the ring too
early after reset, but before moving the dequeue pointer we
will end up executing the same problematic TRB again.

As we always issue a set transfer dequeue command after a reset
endpoint command we can skip starting endpoint rings at reset endpoint
command completion.

Without this fix we end up trying to handle the same faulty TD for
contol endpoints. causing timeout, and failing testusb ctrl_out write
tests.

Fixes: e9df17e (USB: xhci: Correct assumptions about number of rings per endpoint.)
Tested-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-ring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 58c2eac..1d84081 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1197,9 +1197,8 @@ static void xhci_handle_cmd_reset_ep(struct xhci_hcd *xhci, int slot_id,
 				false);
 		xhci_ring_cmd_db(xhci);
 	} else {
-		/* Clear our internal halted state and restart the ring(s) */
+		/* Clear our internal halted state */
 		xhci->devs[slot_id]->eps[ep_index].ep_state &= ~EP_HALTED;
-		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 	}
 }
 
-- 
1.9.1

