Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaCEOcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:32:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41313 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745AbaCEO1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:27:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 121/131] usb: ehci: fix deadlock when threadirqs option is used
Date: Wed,  5 Mar 2014 14:24:05 +0000
Message-Id: <1394029455-23128-122-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/ehci-hcd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 7abf1ce..9a91bb6 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -689,8 +689,15 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
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
 
@@ -708,7 +715,7 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 
 	/* Shared IRQ? */
 	if (!masked_status || unlikely(ehci->rh_state == EHCI_RH_HALTED)) {
-		spin_unlock(&ehci->lock);
+		spin_unlock_irqrestore(&ehci->lock, flags);
 		return IRQ_NONE;
 	}
 
@@ -826,7 +833,7 @@ dead:
 
 	if (bh)
 		ehci_work (ehci);
-	spin_unlock (&ehci->lock);
+	spin_unlock_irqrestore(&ehci->lock, flags);
 	if (pcd_status)
 		usb_hcd_poll_rh_status(hcd);
 	return IRQ_HANDLED;
-- 
1.9.0

