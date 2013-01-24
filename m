Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945975Ab3AXV0C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:26:02 -0500
Received: from mail.kernel.org ([198.145.19.201]:40735 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab3AXVQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:16:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        Don Zickus <dzickus@redhat.com>,
        "Huang, Adrian (ISS Linux TW)" <adrian.huang@hp.com>
Subject: [ 12/22] USB: UHCI: fix IRQ race during initialization
Date: Thu, 24 Jan 2013 13:15:33 -0800
Message-Id: <20130124211508.798898001@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211504.701368763@linuxfoundation.org>
References: <20130124211504.701368763@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/uhci-hcd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -447,6 +447,10 @@ static irqreturn_t uhci_irq(struct usb_h
 		return IRQ_NONE;
 	uhci_writew(uhci, status, USBSTS);		/* Clear it */
 
+	spin_lock(&uhci->lock);
+	if (unlikely(!uhci->is_initialized))	/* not yet configured */
+		goto done;
+
 	if (status & ~(USBSTS_USBINT | USBSTS_ERROR | USBSTS_RD)) {
 		if (status & USBSTS_HSE)
 			dev_err(uhci_dev(uhci), "host system error, "
@@ -455,7 +459,6 @@ static irqreturn_t uhci_irq(struct usb_h
 			dev_err(uhci_dev(uhci), "host controller process "
 					"error, something bad happened!\n");
 		if (status & USBSTS_HCH) {
-			spin_lock(&uhci->lock);
 			if (uhci->rh_state >= UHCI_RH_RUNNING) {
 				dev_err(uhci_dev(uhci),
 					"host controller halted, "
@@ -473,15 +476,15 @@ static irqreturn_t uhci_irq(struct usb_h
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
 
@@ -662,9 +665,9 @@ static int uhci_start(struct usb_hcd *hc
 	 */
 	mb();
 
+	spin_lock_irq(&uhci->lock);
 	configure_hc(uhci);
 	uhci->is_initialized = 1;
-	spin_lock_irq(&uhci->lock);
 	start_rh(uhci);
 	spin_unlock_irq(&uhci->lock);
 	return 0;


