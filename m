Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab3BCPIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:08:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34421 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601Ab3BCO5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:01 -0500
Message-Id: <20130203144650.893892587@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alan Stern <stern@rowland.harvard.edu>,
        Don Zickus <dzickus@redhat.com>,
        "Huang, Adrian (ISS Linux TW)" <adrian.huang@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 077/128] USB: UHCI: fix IRQ race during initialization
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 0f815a0a700bc10547449bde6c106051a035a1b9 upstream.

This patch (as1644) fixes a race that occurs during startup in
uhci-hcd.  If the IRQ line is shared with other devices, it's possible
for the handler routine to be called before the data structures are
fully initialized.

The problem is fixed by adding a check to the IRQ handler routine.  If
the initialization hasn't finished yet, the routine will return
immediately.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Don Zickus <dzickus@redhat.com>
Tested-by: "Huang, Adrian (ISS Linux TW)" <adrian.huang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/uhci-hcd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 4b9e9ab..4f64d24 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -447,6 +447,10 @@ static irqreturn_t uhci_irq(struct usb_hcd *hcd)
 		return IRQ_NONE;
 	uhci_writew(uhci, status, USBSTS);		/* Clear it */
 
+	spin_lock(&uhci->lock);
+	if (unlikely(!uhci->is_initialized))	/* not yet configured */
+		goto done;
+
 	if (status & ~(USBSTS_USBINT | USBSTS_ERROR | USBSTS_RD)) {
 		if (status & USBSTS_HSE)
 			dev_err(uhci_dev(uhci), "host system error, "
@@ -455,7 +459,6 @@ static irqreturn_t uhci_irq(struct usb_hcd *hcd)
 			dev_err(uhci_dev(uhci), "host controller process "
 					"error, something bad happened!\n");
 		if (status & USBSTS_HCH) {
-			spin_lock(&uhci->lock);
 			if (uhci->rh_state >= UHCI_RH_RUNNING) {
 				dev_err(uhci_dev(uhci),
 					"host controller halted, "
@@ -473,15 +476,15 @@ static irqreturn_t uhci_irq(struct usb_hcd *hcd)
 				 * pending unlinks */
 				mod_timer(&hcd->rh_timer, jiffies);
 			}
-			spin_unlock(&uhci->lock);
 		}
 	}
 
-	if (status & USBSTS_RD)
+	if (status & USBSTS_RD) {
+		spin_unlock(&uhci->lock);
 		usb_hcd_poll_rh_status(hcd);
-	else {
-		spin_lock(&uhci->lock);
+	} else {
 		uhci_scan_schedule(uhci);
+ done:
 		spin_unlock(&uhci->lock);
 	}
 
@@ -662,9 +665,9 @@ static int uhci_start(struct usb_hcd *hcd)
 	 */
 	mb();
 
+	spin_lock_irq(&uhci->lock);
 	configure_hc(uhci);
 	uhci->is_initialized = 1;
-	spin_lock_irq(&uhci->lock);
 	start_rh(uhci);
 	spin_unlock_irq(&uhci->lock);
 	return 0;


