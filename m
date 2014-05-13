Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813AbaEMJor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:44:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60873 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760098AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 083/182] xhci: Prevent runtime pm from autosuspending during initialization
Date: Tue, 13 May 2014 11:27:15 +0200
Message-Id: <5b105ec53cbf68159c8f0f89821fffead3412537.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Nyman <mathias.nyman@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/xhci-pci.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 1af67a214d33..d06922469000 100644
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
1.9.3

