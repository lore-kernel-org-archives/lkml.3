Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab3BQWzG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45580 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754267Ab3BQWyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:54:55 -0500
Message-Id: <20130217225002.151342563@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:05 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 04/66] USB: XHCI: fix memory leak of URB-private data
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 48c3375c5f69b1c2ef3d1051a0009cb9bce0ce24 upstream.

This patch (as1640) fixes a memory leak in xhci-hcd.  The urb_priv
data structure isn't always deallocated in the handle_tx_event()
routine for non-control transfers.  The patch adds a kfree() call so
that all paths end up freeing the memory properly.

This patch should be backported to kernels as old as 2.6.36, that
contain the commit 8e51adccd4c4b9ffcd509d7f2afce0a906139f75 "USB: xHCI:
Introduce urb_priv structure"

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-and-tested-by: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-ring.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 1512046..7f76a49 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2589,6 +2589,8 @@ cleanup:
 				(trb_comp_code != COMP_STALL &&
 					trb_comp_code != COMP_BABBLE))
 				xhci_urb_free_priv(xhci, urb_priv);
+			else
+				kfree(urb_priv);
 
 			usb_hcd_unlink_urb_from_ep(bus_to_hcd(urb->dev->bus), urb);
 			if ((urb->actual_length != urb->transfer_buffer_length &&


