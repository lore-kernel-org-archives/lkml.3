Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaLEXGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:06:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbaLEXGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:06:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.10 29/45] USB: xhci: dont start a halted endpoint before its new dequeue is set
Date: Fri,  5 Dec 2014 14:45:12 -0800
Message-Id: <20141205223321.348372036@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223316.738290875@linuxfoundation.org>
References: <20141205223316.738290875@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/xhci-ring.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1178,9 +1178,8 @@ static void handle_reset_ep_completion(s
 				false);
 		xhci_ring_cmd_db(xhci);
 	} else {
-		/* Clear our internal halted state and restart the ring(s) */
+		/* Clear our internal halted state */
 		xhci->devs[slot_id]->eps[ep_index].ep_state &= ~EP_HALTED;
-		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 	}
 }
 


