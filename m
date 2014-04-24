Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbaDXIww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:52:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46391 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaDXIwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 035/182] xhci: Prevent runtime pm from autosuspending during initialization
Date: Thu, 24 Apr 2014 09:49:20 +0100
Message-Id: <1398329507-5911-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index c1f6005..9b9fa3e 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -185,6 +185,10 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	struct usb_hcd *hcd;
 
 	driver = (struct hc_driver *)id->driver_data;
+
+	/* Prevent runtime suspending between USB-2 and USB-3 initialization */
+	pm_runtime_get_noresume(&dev->dev);
+
 	/* Register the USB 2.0 roothub.
 	 * FIXME: USB core must know to register the USB 2.0 roothub first.
 	 * This is sort of silly, because we could just set the HCD driver flags
@@ -194,7 +198,7 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	retval = usb_hcd_pci_probe(dev, id);
 
 	if (retval)
-		return retval;
+		goto put_runtime_pm;
 
 	/* USB 2.0 roothub is stored in the PCI device now. */
 	hcd = dev_get_drvdata(&dev->dev);
@@ -223,12 +227,17 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
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
 
-- 
1.9.1

