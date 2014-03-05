Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbaCEOic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:38:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41794 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbaCEOi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jean Delvare <jdelvare@suse.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 51/62] i7300_edac: Fix device reference count
Date: Wed,  5 Mar 2014 14:36:55 +0000
Message-Id: <1394030226-26652-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Borislav Petkov <bp@suse.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/edac/i7300_edac.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 856a250..3fa8c20 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -943,33 +943,35 @@ static int __devinit i7300_get_devices(struct mem_ctl_info *mci)
 
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
-- 
1.9.0

