Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3JCEJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:09:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3JCEJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:09:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Wolter <wolly84@web.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 06/16] xhci: Fix race between ep halt and URB cancellation
Date: Wed,  2 Oct 2013 21:05:30 -0700
Message-Id: <20131003040445.976216077@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040445.523176877@linuxfoundation.org>
References: <20131003040445.523176877@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Wolter <wolly84@web.de>

commit 526867c3ca0caa2e3e846cb993b0f961c33c2abb upstream.

The halted state of a endpoint cannot be cleared over CLEAR_HALT from a
user process, because the stopped_td variable was overwritten in the
handle_stopped_endpoint() function. So the xhci_endpoint_reset() function will
refuse the reset and communication with device can not run over this endpoint.
https://bugzilla.kernel.org/show_bug.cgi?id=60699

Signed-off-by: Florian Wolter <wolly84@web.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -857,8 +857,12 @@ remove_finished_td:
 		/* Otherwise ring the doorbell(s) to restart queued transfers */
 		ring_doorbell_for_active_rings(xhci, slot_id, ep_index);
 	}
-	ep->stopped_td = NULL;
-	ep->stopped_trb = NULL;
+
+	/* Clear stopped_td and stopped_trb if endpoint is not halted */
+	if (!(ep->ep_state & EP_HALTED)) {
+		ep->stopped_td = NULL;
+		ep->stopped_trb = NULL;
+	}
 
 	/*
 	 * Drop the lock and complete the URBs in the cancelled TD list.


