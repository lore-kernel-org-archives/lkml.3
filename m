Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab3BQXMN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:12:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45574 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753533Ab3BQWyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:54:53 -0500
Message-Id: <20130217225001.937141555@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:03 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 02/66] xhci: Fix isoc TD encoding.
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 760973d2a74b93eb1697981f7448f0e62767cfc4 upstream.

An isochronous TD is comprised of one isochronous TRB chained to zero or
more normal TRBs.  Only the isoc TRB has the TBC and TLBPC fields.  The
normal TRBs must set those fields to zeroes.  The code was setting the
TBC and TLBPC fields for both isoc and normal TRBs.  Fix this.

This should be backported to stable kernels as old as 3.0, that contain
the commit b61d378f2da41c748aba6ca19d77e1e1c02bcea5 " xhci 1.0: Set
transfer burst last packet count field."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 59fb5c6..d1ff133 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3664,9 +3664,11 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 		td = urb_priv->td[i];
 		for (j = 0; j < trbs_per_td; j++) {
 			u32 remainder = 0;
-			field = TRB_TBC(burst_count) | TRB_TLBPC(residue);
+			field = 0;
 
 			if (first_trb) {
+				field = TRB_TBC(burst_count) |
+					TRB_TLBPC(residue);
 				/* Queue the isoc TRB */
 				field |= TRB_TYPE(TRB_ISOC);
 				/* Assume URB_ISO_ASAP is set */


