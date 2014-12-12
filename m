Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965324AbaLLGm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:42:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51767 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758775AbaLLGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:55 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mathias Nyman" <mathias.nyman@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Felipe Balbi" <balbi@ti.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.423409425@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 146/164] USB: xhci: don't start a halted endpoint
 before its new dequeue is set
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1164,9 +1164,8 @@ static void handle_reset_ep_completion(s
 				false);
 		xhci_ring_cmd_db(xhci);
 	} else {
-		/* Clear our internal halted state and restart the ring(s) */
+		/* Clear our internal halted state */
 		xhci->devs[slot_id]->eps[ep_index].ep_state &= ~EP_HALTED;
-		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 	}
 }
 

