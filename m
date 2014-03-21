Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbaCUBKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:10:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965139AbaCUAEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 3.13 068/149] Revert "xhci 1.0: Limit arbitrarily-aligned scatter gather."
Date: Thu, 20 Mar 2014 17:03:51 -0700
Message-Id: <20140321000439.316701395@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit e2ed511400d41e0d136089d5a55ceab57c6a2426 upstream.

This reverts commit 247bf557273dd775505fb9240d2d152f4f20d304.

This commit, together with commit 3804fad45411b48233b48003e33a78f290d227c8
"USBNET: ax88179_178a: enable tso if usb host supports sg dma" were
origially added to get xHCI 1.0 hosts and usb ethernet ax88179_178a devices
working together with scatter gather. xHCI 1.0 hosts pose some requirement on how transfer
buffers are aligned, setting this requirement for 1.0 hosts caused USB 3.0 mass
storage devices to fail more frequently.

USB 3.0 mass storage devices used to work before 3.14-rc1.  Theoretically,
the TD fragment rules could have caused an occasional disk glitch.
Now the devices *will* fail, instead of theoretically failing.
>From a user perspective, this looks like a regression; the USB device obviously
fails on 3.14-rc1, and may sometimes silently fail on prior kernels.

The proper soluition is to implement the TD fragment rules required, but for now
this patch needs to be reverted to get USB 3.0 mass storage devices working at the
level they used to.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4719,6 +4719,9 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 	/* Accept arbitrarily long scatter-gather lists */
 	hcd->self.sg_tablesize = ~0;
 
+	/* support to build packet from discontinuous buffers */
+	hcd->self.no_sg_constraint = 1;
+
 	/* XHCI controllers don't stop the ep queue on short packets :| */
 	hcd->self.no_stop_on_short = 1;
 
@@ -4743,14 +4746,6 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 		/* xHCI private pointer was set in xhci_pci_probe for the second
 		 * registered roothub.
 		 */
-		xhci = hcd_to_xhci(hcd);
-		/*
-		 * Support arbitrarily aligned sg-list entries on hosts without
-		 * TD fragment rules (which are currently unsupported).
-		 */
-		if (xhci->hci_version < 0x100)
-			hcd->self.no_sg_constraint = 1;
-
 		return 0;
 	}
 
@@ -4777,9 +4772,6 @@ int xhci_gen_setup(struct usb_hcd *hcd,
 	if (xhci->hci_version > 0x96)
 		xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 
-	if (xhci->hci_version < 0x100)
-		hcd->self.no_sg_constraint = 1;
-
 	/* Make sure the HC is halted. */
 	retval = xhci_halt(xhci);
 	if (retval)


