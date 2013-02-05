Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab3BEWJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:09:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47945 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab3BEWJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 27/93] USB: UHCI: fix IRQ race during initialization
Date: Tue,  5 Feb 2013 20:06:16 -0200
Message-Id: <1360102042-10732-28-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/host/uhci-hcd.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index e4db350..3fe069f 100644
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
-- 
1.7.9.5

