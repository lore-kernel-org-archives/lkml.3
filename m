Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbaGPTOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:14:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbaGPTOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:14:09 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] PCI: Add device specific (non)reset for AMD GPUs
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 16 Jul 2014 13:14:08 -0600
Message-ID: <20140716190955.4722.25453.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are numerous ATI/AMD GPUs available that report that they
support a PM reset (NoSoftRst-) but for which such a reset has no
apparent effect on the device.  These devices continue to display the
same framebuffer across PM reset and the fan speed remains constant,
while a proper bus reset causes the display to lose sync and the fan
to reset to high speed.  Create a device specific reset for ATI vendor
devices that tries to catch these devices and report that
pci_reset_function() is not supported.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

This patch makes the series "vfio-pci: Reset improvements" far more
useful for users with one of these GPUs.  If pci_reset_function()
indicates that it's supported and successful, then I have no reason
to resort to a bus/slot reset in the vfio-pci code.  Since it doesn't
seem to do anything anyway, let's just forget that PM reset exists
for these devices.

 drivers/pci/quirks.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 460c354..bed9c63 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3289,6 +3289,57 @@ static int reset_chelsio_generic_dev(struct pci_dev *dev, int probe)
 	return 0;
 }
 
+/*
+ * Numerous AMD/ATI GPUs report that they're capable of PM reset (NoSoftRst-)
+ * and pci_reset_function() reports the device as successfully reset, but
+ * there's no apparent effect from the reset.  Test for these, being sure to
+ * allow FLR should it ever exist, and use the device specific reset to
+ * disable any sort of function-local reset if only PM reset is available.
+ */
+static int reset_ati_gpu(struct pci_dev *dev, int probe)
+{
+	u16 pm_csr;
+	u32 devcap;
+	int af_pos;
+
+	/*
+	 * VGA class devices, not on the root bus, PCI function 0 of a
+	 * multifunction device with PM capabilities
+	 */
+	if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA ||
+	    pci_is_root_bus(dev->bus) || PCI_FUNC(dev->devfn) ||
+	    !dev->multifunction || !dev->pm_cap)
+		return -ENOTTY;
+
+	/* PM reports NoSoftRst- */
+	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pm_csr);
+	if (pm_csr & PCI_PM_CTRL_NO_SOFT_RESET)
+		return -ENOTTY;
+
+	/* No PCIe FLR */
+	pcie_capability_read_dword(dev, PCI_EXP_DEVCAP, &devcap);
+	if (devcap & PCI_EXP_DEVCAP_FLR)
+		return -ENOTTY;
+
+	/* No AF FLR */
+	af_pos = pci_find_capability(dev, PCI_CAP_ID_AF);
+	if (af_pos) {
+		u8 af_cap;
+
+		pci_read_config_byte(dev, af_pos + PCI_AF_CAP, &af_cap);
+		if ((af_cap && PCI_AF_CAP_TP) && (af_cap && PCI_AF_CAP_FLR))
+			return -ENOTTY;
+	}
+
+	/*
+	 * We could attempt a singleton bus/slot reset here to override
+	 * PM reset priority over these, but the devices we're interested
+	 * in are multifunction GPU + audio devices in their known configs.
+	 */
+
+	return -EINVAL;
+}
+
 #define PCI_DEVICE_ID_INTEL_82599_SFP_VF   0x10ed
 #define PCI_DEVICE_ID_INTEL_IVB_M_VGA      0x0156
 #define PCI_DEVICE_ID_INTEL_IVB_M2_VGA     0x0166
@@ -3304,6 +3355,8 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 		reset_intel_generic_dev },
 	{ PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
 		reset_chelsio_generic_dev },
+	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+		reset_ati_gpu },
 	{ 0 }
 };
 

