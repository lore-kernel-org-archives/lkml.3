Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbaCYRSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:18:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55685 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbaCYRSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:18:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 71/81] usb: ehci: fix deadlock when threadirqs option is used
Date: Tue, 25 Mar 2014 10:16:24 -0700
Message-Id: <1395767794-5012-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ehci-hcd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 83b5a172..5b2a76b 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -683,8 +683,15 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
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
 
@@ -702,7 +709,7 @@ static irqreturn_t ehci_irq (struct usb_hcd *hcd)
 
 	/* Shared IRQ? */
 	if (!masked_status || unlikely(ehci->rh_state == EHCI_RH_HALTED)) {
-		spin_unlock(&ehci->lock);
+		spin_unlock_irqrestore(&ehci->lock, flags);
 		return IRQ_NONE;
 	}
 
@@ -820,7 +827,7 @@ dead:
 
 	if (bh)
 		ehci_work (ehci);
-	spin_unlock (&ehci->lock);
+	spin_unlock_irqrestore(&ehci->lock, flags);
 	if (pcd_status)
 		usb_hcd_poll_rh_status(hcd);
 	return IRQ_HANDLED;
-- 
1.8.3.2

