Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaCCRWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:22:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:59879 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaCCRWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:22:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,578,1389772800"; 
   d="scan'208";a="465620122"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>, <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH v3 1/1] xhci: Prevent runtime pm from autosuspending during initialization
Date: Mon,  3 Mar 2014 19:30:17 +0200
Message-Id: <1393867817-10389-2-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1393867817-10389-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1393867817-10389-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org
---
 drivers/usb/host/xhci-pci.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 04f986d..753857f 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -190,6 +190,10 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	struct usb_hcd *hcd;
 
 	driver = (struct hc_driver *)id->driver_data;
+
+	/* Prevent runtime suspending between USB-2 and USB-3 initialization */
+	pm_runtime_get_noresume(&dev->dev);
+
 	/* Register the USB 2.0 roothub.
 	 * FIXME: USB core must know to register the USB 2.0 roothub first.
 	 * This is sort of silly, because we could just set the HCD driver flags
@@ -199,7 +203,7 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	retval = usb_hcd_pci_probe(dev, id);
 
 	if (retval)
-		return retval;
+		goto put_runtime_pm;
 
 	/* USB 2.0 roothub is stored in the PCI device now. */
 	hcd = dev_get_drvdata(&dev->dev);
@@ -228,12 +232,17 @@ static int xhci_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
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
1.8.1.2

