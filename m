Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbaICWSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:18:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240AbaICWQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.16 028/125] xhci: Blacklist using streams on the Etron EJ168 controller
Date: Wed,  3 Sep 2014 15:06:25 -0700
Message-Id: <20140903220624.507986079@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 8f873c1ff4ca034626093d03b254e7cb8bb782dd upstream.

Streams on the EJ168 do not work as they should. I've spend 2 days trying
to get them to work, but without success.

The first problem is that when ever you ring the stream-ring doorbell, the
controller starts executing trbs at the beginning of the first ring segment,
event if it ended somewhere else previously. This can be worked around by
allowing enqueing only one td (not a problem with how streams are typically
used) and then resetting our copies of the enqueueing en dequeueing pointers
on a td completion to match what the controller seems to be doing.

This way things seem to start working with uas and instead of being able
to complete only the very first scsi command, the scsi core can probe the disk.

But then things break later on when td-s get enqueued with more then one
trb. The controller does seem to increase its dequeue pointer while executing
a stream-ring (data transfer events I inserted for debugging do trigger).
However execution seems to stop at the final normal trb of a multi trb td,
even if there is a data transfer event inserted after the final trb.

The first problem alone is a serious deviation from the spec, and esp.
dealing with cancellation would have been very tricky if not outright
impossible, but the second problem simply is a deal breaker altogether,
so this patch simply disables streams.

Note this will cause the usb-storage + uas driver pair to automatically switch
to using usb-storage instead of uas on these devices, essentially reverting
to the 3.14 and earlier behavior when uas was marked CONFIG_BROKEN.

https://bugzilla.redhat.com/show_bug.cgi?id=1121288
https://bugzilla.kernel.org/show_bug.cgi?id=80101

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    4 +++-
 drivers/usb/host/xhci.c     |    3 ++-
 drivers/usb/host/xhci.h     |    2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -143,6 +143,7 @@ static void xhci_pci_quirks(struct devic
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
 			pdev->device == 0x0015)
@@ -230,7 +231,8 @@ static int xhci_pci_probe(struct pci_dev
 		goto put_usb3_hcd;
 	/* Roothub already marked as USB 3.0 speed */
 
-	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (!(xhci->quirks & XHCI_BROKEN_STREAMS) &&
+			HCC_MAX_PSA(xhci->hcc_params) >= 4)
 		xhci->shared_hcd->can_do_streams = 1;
 
 	/* USB-2 and USB-3 roothubs initialized, allow runtime pm suspend */
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3163,7 +3163,8 @@ int xhci_alloc_streams(struct usb_hcd *h
 			num_streams);
 
 	/* MaxPSASize value 0 (2 streams) means streams are not supported */
-	if (HCC_MAX_PSA(xhci->hcc_params) < 4) {
+	if ((xhci->quirks & XHCI_BROKEN_STREAMS) ||
+			HCC_MAX_PSA(xhci->hcc_params) < 4) {
 		xhci_dbg(xhci, "xHCI controller does not support streams.\n");
 		return -ENOSYS;
 	}
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1558,6 +1558,8 @@ struct xhci_hcd {
 #define XHCI_PLAT		(1 << 16)
 #define XHCI_SLOW_SUSPEND	(1 << 17)
 #define XHCI_SPURIOUS_WAKEUP	(1 << 18)
+/* For controllers with a broken beyond repair streams implementation */
+#define XHCI_BROKEN_STREAMS	(1 << 19)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */


