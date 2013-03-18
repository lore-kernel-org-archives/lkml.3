Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab3CREbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33572 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914Ab3CREak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:40 -0400
Message-Id: <20130318042148.612442979@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:29 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alan Stern <stern@rowland.harvard.edu>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 45/82] USB: EHCI: dont check DMA values in QH overlays
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit feca7746d5d9e84b105a613b7f3b6ad00d327372 upstream.

This patch (as1661) fixes a rather obscure bug in ehci-hcd.  In a
couple of places, the driver compares the DMA address stored in a QH's
overlay region with the address of a particular qTD, in order to see
whether that qTD is the one currently being processed by the hardware.
(If it is then the status in the QH's overlay region is more
up-to-date than the status in the qTD, and if it isn't then the
overlay's value needs to be adjusted when the QH is added back to the
active schedule.)

However, DMA address in the overlay region isn't always valid.  It
sometimes will contain a stale value, which may happen by coincidence
to be equal to a qTD's DMA address.  Instead of checking the DMA
address, we should check whether the overlay region is active and
valid.  The patch tests the ACTIVE bit in the overlay, and clears this
bit when the overlay becomes invalid (which happens when the
currently-executing URB is unlinked).

This is the second part of a fix for the regression reported at:

	https://bugs.launchpad.net/bugs/1088733

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Reported-and-tested-by: Stephen Thirlwall <sdt@dr.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-q.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -135,7 +135,7 @@ qh_refresh (struct ehci_hcd *ehci, struc
 		 * qtd is updated in qh_completions(). Update the QH
 		 * overlay here.
 		 */
-		if (cpu_to_hc32(ehci, qtd->qtd_dma) == qh->hw->hw_current) {
+		if (qh->hw->hw_token & ACTIVE_BIT(ehci)) {
 			qh->hw->hw_qtd_next = qtd->hw_next;
 			qtd = NULL;
 		}
@@ -444,11 +444,19 @@ qh_completions (struct ehci_hcd *ehci, s
 			else if (last_status == -EINPROGRESS && !urb->unlinked)
 				continue;
 
-			/* qh unlinked; token in overlay may be most current */
-			if (state == QH_STATE_IDLE
-					&& cpu_to_hc32(ehci, qtd->qtd_dma)
-						== hw->hw_current) {
+			/*
+			 * If this was the active qtd when the qh was unlinked
+			 * and the overlay's token is active, then the overlay
+			 * hasn't been written back to the qtd yet so use its
+			 * token instead of the qtd's.  After the qtd is
+			 * processed and removed, the overlay won't be valid
+			 * any more.
+			 */
+			if (state == QH_STATE_IDLE &&
+					qh->qtd_list.next == &qtd->qtd_list &&
+					(hw->hw_token & ACTIVE_BIT(ehci))) {
 				token = hc32_to_cpu(ehci, hw->hw_token);
+				hw->hw_token &= ~ACTIVE_BIT(ehci);
 
 				/* An unlink may leave an incomplete
 				 * async transaction in the TT buffer.


