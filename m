Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539Ab3IYBVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:21:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab3IYAQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Yu Y Wang <yu.y.wang@intel.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 021/110] xhci-plat: Dont enable legacy PCI interrupts.
Date: Tue, 24 Sep 2013 17:14:19 -0700
Message-Id: <20130925001325.714679447@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 52fb61250a7a132b0cfb9f4a1060a1f3c49e5a25 upstream.

The xHCI platform driver calls into usb_add_hcd to register the irq for
its platform device.  It does not want the xHCI generic driver to
register an interrupt for it at all.  The original code did that by
setting the XHCI_BROKEN_MSI quirk, which tells the xHCI driver to not
enable MSI or MSI-X for a PCI host.

Unfortunately, if CONFIG_PCI is enabled, and CONFIG_USB_DW3 is enabled,
the xHCI generic driver will attempt to register a legacy PCI interrupt
for the xHCI platform device in xhci_try_enable_msi().  This will result
in a bogus irq being registered, since the underlying device is a
platform_device, not a pci_device, and thus the pci_device->irq pointer
will be bogus.

Add a new quirk, XHCI_PLAT, so that the xHCI generic driver can
distinguish between a PCI device that can't handle MSI or MSI-X, and a
platform device that should not have its interrupts touched at all.
This quirk may be useful in the future, in case other corner cases like
this arise.

This patch should be backported to kernels as old as 3.9, that
contain the commit 00eed9c814cb8f281be6f0f5d8f45025dc0a97eb "USB: xhci:
correctly enable interrupts".

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Yu Y Wang <yu.y.wang@intel.com>
Tested-by: Yu Y Wang <yu.y.wang@intel.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-plat.c |    2 +-
 drivers/usb/host/xhci.c      |    7 ++++++-
 drivers/usb/host/xhci.h      |    1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -24,7 +24,7 @@ static void xhci_plat_quirks(struct devi
 	 * here that the generic code does not try to make a pci_dev from our
 	 * dev struct in order to setup MSI
 	 */
-	xhci->quirks |= XHCI_BROKEN_MSI;
+	xhci->quirks |= XHCI_PLAT;
 }
 
 /* called during probe() after chip reset completes */
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -342,9 +342,14 @@ static void xhci_msix_sync_irqs(struct x
 static int xhci_try_enable_msi(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	struct pci_dev  *pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
+	struct pci_dev  *pdev;
 	int ret;
 
+	/* The xhci platform device has set up IRQs through usb_add_hcd. */
+	if (xhci->quirks & XHCI_PLAT)
+		return 0;
+
+	pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
 	/*
 	 * Some Fresco Logic host controllers advertise MSI, but fail to
 	 * generate interrupts.  Don't even try to enable MSI.
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1516,6 +1516,7 @@ struct xhci_hcd {
 #define XHCI_SPURIOUS_REBOOT	(1 << 13)
 #define XHCI_COMP_MODE_QUIRK	(1 << 14)
 #define XHCI_AVOID_BEI		(1 << 15)
+#define XHCI_PLAT		(1 << 16)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */


