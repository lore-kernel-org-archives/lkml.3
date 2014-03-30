Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaC3XvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:51:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754732AbaC3Xno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:44 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Stanislaw Gruszka" <sgruszka@redhat.com>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.728409301@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 145/200] usb: ehci: fix deadlock when threadirqs
 option is used
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit a1227f3c1030e96ebc51d677d2f636268845c5fb upstream.

ehci_irq() and ehci_hrtimer_func() can deadlock on ehci->lock when
threadirqs option is used. To prevent the deadlock use
spin_lock_irqsave() in ehci_irq().

This change can be reverted when hrtimer callbacks become threaded.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-hcd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -807,8 +807,15 @@ static irqreturn_t ehci_irq (struct usb_
 	struct ehci_hcd		*ehci = hcd_to_ehci (hcd);
 	u32			status, masked_status, pcd_status = 0, cmd;
 	int			bh;
+	unsigned long		flags;
 
-	spin_lock (&ehci->lock);
+	/*
+	 * For threadirqs option we use spin_lock_irqsave() variant to prevent
+	 * deadlock with ehci hrtimer callback, because hrtimer callbacks run
+	 * in interrupt context even when threadirqs is specified. We can go
+	 * back to spin_lock() variant when hrtimer callbacks become threaded.
+	 */
+	spin_lock_irqsave(&ehci->lock, flags);
 
 	status = ehci_readl(ehci, &ehci->regs->status);
 
@@ -826,7 +833,7 @@ static irqreturn_t ehci_irq (struct usb_
 
 	/* Shared IRQ? */
 	if (!masked_status || unlikely(ehci->rh_state == EHCI_RH_HALTED)) {
-		spin_unlock(&ehci->lock);
+		spin_unlock_irqrestore(&ehci->lock, flags);
 		return IRQ_NONE;
 	}
 
@@ -929,7 +936,7 @@ dead:
 
 	if (bh)
 		ehci_work (ehci);
-	spin_unlock (&ehci->lock);
+	spin_unlock_irqrestore(&ehci->lock, flags);
 	if (pcd_status)
 		usb_hcd_poll_rh_status(hcd);
 	return IRQ_HANDLED;

