Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaB1Jno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:43:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbaB1JnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:43:18 -0500
Date: Fri, 28 Feb 2014 10:43:14 +0100
From: Borislav Petkov <bp@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] EDAC fixes for 3.14
Message-ID: <20140228094314.GA4326@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the two fixes below for PCI devices disappearing when a
reference count underflow happens after a couple of insmod/rmmod cycles
in succession.

Thanks.

The following changes since commit cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/edac_fixes_for_3.14

for you to fetch changes up to 75135da0d68419ef8a925f4c1d5f63d8046e314d:

  i7300_edac: Fix device reference count (2014-02-25 09:43:13 +0100)

----------------------------------------------------------------
Two reference counting fixes for two Intel EDAC drivers.

----------------------------------------------------------------
Jean Delvare (2):
      i7core_edac: Fix PCI device reference count
      i7300_edac: Fix device reference count

 drivers/edac/i7300_edac.c  | 38 ++++++++++++++++++++------------------
 drivers/edac/i7core_edac.c |  9 +++++++--
 2 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index d63f4798f7d0..57e96a3350f0 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -943,33 +943,35 @@ static int i7300_get_devices(struct mem_ctl_info *mci)
 
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
 	edac_dbg(1, "System Address, processor bus- PCI Bus ID: %s  %x:%x\n",
 		 pci_name(pvt->pci_dev_16_0_fsb_ctlr),
 		 pvt->pci_dev_16_0_fsb_ctlr->vendor,
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 87533ca7752e..d871275196f6 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1334,14 +1334,19 @@ static int i7core_get_onedevice(struct pci_dev **prev,
 	 * is at addr 8086:2c40, instead of 8086:2c41. So, we need
 	 * to probe for the alternate address in case of failure
 	 */
-	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_I7_NONCORE && !pdev)
+	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_I7_NONCORE && !pdev) {
+		pci_dev_get(*prev);	/* pci_get_device will put it */
 		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 				      PCI_DEVICE_ID_INTEL_I7_NONCORE_ALT, *prev);
+	}
 
-	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE && !pdev)
+	if (dev_descr->dev_id == PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE &&
+	    !pdev) {
+		pci_dev_get(*prev);	/* pci_get_device will put it */
 		pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
 				      PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_ALT,
 				      *prev);
+	}
 
 	if (!pdev) {
 		if (*prev) {
-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
