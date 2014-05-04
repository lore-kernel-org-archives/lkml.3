Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaEDQGG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:06:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730AbaEDPmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 3.10 60/86] xhci: Prevent runtime pm from autosuspending during initialization
Date: Sun,  4 May 2014 11:41:35 -0400
Message-Id: <20140504154148.598326185@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit bcffae7708eb8352f44dc510b326541fe43a02a4 upstream.

xHCI driver has its own pci probe function that will call usb_hcd_pci_probe
to register its usb-2 bus, and then continue to manually register the
usb-3 bus. usb_hcd_pci_probe does a pm_runtime_put_noidle at the end and
might thus trigger a runtime suspend before the usb-3 bus is ready.

Prevent the runtime suspend by increasing the usage count in the
beginning of xhci_pci_probe, and decrease it once the usb-3 bus is
ready.

xhci-platform driver is not using usb_hcd_pci_probe to set up
busses and should not need to have it's usage count increased during probe.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -161,6 +161,10 @@ static int xhci_pci_probe(struct pci_dev
 	struct usb_hcd *hcd;
 
 	driver = (struct hc_driver *)id->driver_data;
+
+	/* Prevent runtime suspending between USB-2 and USB-3 initialization */
+	pm_runtime_get_noresume(&dev->dev);
+
 	/* Register the USB 2.0 roothub.
 	 * FIXME: USB core must know to register the USB 2.0 roothub first.
 	 * This is sort of silly, because we could just set the HCD driver flags
@@ -170,7 +174,7 @@ static int xhci_pci_probe(struct pci_dev
 	retval = usb_hcd_pci_probe(dev, id);
 
 	if (retval)
-		return retval;
+		goto put_runtime_pm;
 
 	/* USB 2.0 roothub is stored in the PCI device now. */
 	hcd = dev_get_drvdata(&dev->dev);
@@ -199,12 +203,17 @@ static int xhci_pci_probe(struct pci_dev
 	if (xhci->quirks & XHCI_LPM_SUPPORT)
 		hcd_to_bus(xhci->shared_hcd)->root_hub->lpm_capable = 1;
 
+	/* USB-2 and USB-3 roothubs initialized, allow runtime pm suspend */
+	pm_runtime_put_noidle(&dev->dev);
+
 	return 0;
 
 put_usb3_hcd:
 	usb_put_hcd(xhci->shared_hcd);
 dealloc_usb2_hcd:
 	usb_hcd_pci_remove(dev);
+put_runtime_pm:
+	pm_runtime_put_noidle(&dev->dev);
 	return retval;
 }
 


