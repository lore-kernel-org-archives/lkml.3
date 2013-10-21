Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab3JUI4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:56:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39901 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754627Ab3JUIxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Florian Wolter" <wolly84@web.de>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.689153462@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 143/149] xhci: Fix race between ep halt and URB
 cancellation
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -879,8 +879,12 @@ remove_finished_td:
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

