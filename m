Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaC1Rad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:30:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaC1Ra2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3.4 07/13] i7300_edac: Fix device reference count
Date: Fri, 28 Mar 2014 10:31:57 -0700
Message-Id: <20140328173054.048010910@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173053.049244535@linuxfoundation.org>
References: <20140328173053.049244535@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <jdelvare@suse.de>

commit 75135da0d68419ef8a925f4c1d5f63d8046e314d upstream.

pci_get_device() decrements the reference count of "from" (last
argument) so when we break off the loop successfully we have only one
device reference - and we don't know which device we have. If we want
a reference to each device, we must take them explicitly and let
the pci_get_device() walk complete to avoid duplicate references.

This is serious, as over-putting device references will cause
the device to eventually disappear. Without this fix, the kernel
crashes after a few insmod/rmmod cycles.

Tested on an Intel S7000FC4UR system with a 7300 chipset.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Link: http://lkml.kernel.org/r/20140224111656.09bbb7ed@endymion.delvare
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: stable@vger.kernel.org
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/edac/i7300_edac.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -962,33 +962,35 @@ static int __devinit i7300_get_devices(s
 
 	/* Attempt to 'get' the MCH register we want */
 	pdev = NULL;
-	while (!pvt->pci_dev_16_1_fsb_addr_map ||
-	       !pvt->pci_dev_16_2_fsb_err_regs) {
-		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-				      PCI_DEVICE_ID_INTEL_I7300_MCH_ERR, pdev);
-		if (!pdev) {
-			/* End of list, leave */
-			i7300_printk(KERN_ERR,
-				"'system address,Process Bus' "
-				"device not found:"
-				"vendor 0x%x device 0x%x ERR funcs "
-				"(broken BIOS?)\n",
-				PCI_VENDOR_ID_INTEL,
-				PCI_DEVICE_ID_INTEL_I7300_MCH_ERR);
-			goto error;
-		}
-
+	while ((pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
+				      PCI_DEVICE_ID_INTEL_I7300_MCH_ERR,
+				      pdev))) {
 		/* Store device 16 funcs 1 and 2 */
 		switch (PCI_FUNC(pdev->devfn)) {
 		case 1:
-			pvt->pci_dev_16_1_fsb_addr_map = pdev;
+			if (!pvt->pci_dev_16_1_fsb_addr_map)
+				pvt->pci_dev_16_1_fsb_addr_map =
+							pci_dev_get(pdev);
 			break;
 		case 2:
-			pvt->pci_dev_16_2_fsb_err_regs = pdev;
+			if (!pvt->pci_dev_16_2_fsb_err_regs)
+				pvt->pci_dev_16_2_fsb_err_regs =
+							pci_dev_get(pdev);
 			break;
 		}
 	}
 
+	if (!pvt->pci_dev_16_1_fsb_addr_map ||
+	    !pvt->pci_dev_16_2_fsb_err_regs) {
+		/* At least one device was not found */
+		i7300_printk(KERN_ERR,
+			"'system address,Process Bus' device not found:"
+			"vendor 0x%x device 0x%x ERR funcs (broken BIOS?)\n",
+			PCI_VENDOR_ID_INTEL,
+			PCI_DEVICE_ID_INTEL_I7300_MCH_ERR);
+		goto error;
+	}
+
 	debugf1("System Address, processor bus- PCI Bus ID: %s  %x:%x\n",
 		pci_name(pvt->pci_dev_16_0_fsb_ctlr),
 		pvt->pci_dev_16_0_fsb_ctlr->vendor,


