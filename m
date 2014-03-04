Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaCDUEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:04:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbaCDUEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.13 124/172] usb: ehci: fix deadlock when threadirqs option is used
Date: Tue,  4 Mar 2014 12:03:28 -0800
Message-Id: <20140304200303.690103511@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ehci-hcd.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -686,8 +686,15 @@ static irqreturn_t ehci_irq (struct usb_
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
 
@@ -705,7 +712,7 @@ static irqreturn_t ehci_irq (struct usb_
 
 	/* Shared IRQ? */
 	if (!masked_status || unlikely(ehci->rh_state == EHCI_RH_HALTED)) {
-		spin_unlock(&ehci->lock);
+		spin_unlock_irqrestore(&ehci->lock, flags);
 		return IRQ_NONE;
 	}
 
@@ -823,7 +830,7 @@ dead:
 
 	if (bh)
 		ehci_work (ehci);
-	spin_unlock (&ehci->lock);
+	spin_unlock_irqrestore(&ehci->lock, flags);
 	if (pcd_status)
 		usb_hcd_poll_rh_status(hcd);
 	return IRQ_HANDLED;


