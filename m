Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3CARSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:18:24 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56052 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3CARSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:18:20 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, Prarit Bhargava <prarit@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>, linux-pci@vger.kernel.org
Subject: [PATCH] irq: add quirk for broken interrupt remapping on 55XX chipsets
Date: Fri,  1 Mar 2013 12:17:56 -0500
Message-Id: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.7.11.7
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few years back intel published a spec update:
http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf

For the 5520 and 5500 chipsets which contained an errata (specificially errata
53), which noted that these chipsets can't properly do interrupt remapping, and
as a result the recommend that interrupt remapping be disabled in bios.  While
many vendors have a bios update to do exactly that, not all do, and of course
not all users update their bios to a level that corrects the problem.  As a
result, occasionally interrupts can arrive at a cpu even after affinity for that
interrupt has be moved, leading to lost or spurrious interrupts (usually
characterized by the message:
kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)

There have been several incidents recently of people seeing this error, and
investigation has shown that they have system for which their BIOS level is such
that this feature was not properly turned off.  As such, it would be good to
give them a reminder that their systems are vulnurable to this problem.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Don Zickus <dzickus@redhat.com>
CC: Don Dutile <ddutile@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Asit Mallick <asit.k.mallick@intel.com>
CC: linux-pci@vger.kernel.org
---
 drivers/iommu/intel_irq_remapping.c | 20 ++++++++++++++++++++
 include/linux/pci_ids.h             |  2 ++
 2 files changed, 22 insertions(+)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index f3b8f23..9bfb6c2 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -1113,3 +1113,23 @@ struct irq_remap_ops intel_irq_remap_ops = {
 	.msi_setup_irq		= intel_msi_setup_irq,
 	.setup_hpet_msi		= intel_setup_hpet_msi,
 };
+
+
+static void intel_remapping_check(struct pci_dev *dev)
+{
+	u8 revision;
+
+	pci_read_config_byte(dev, PCI_REVISION_ID, &revision);
+
+	if ((revision == 0x13) && irq_remapping_enabled) {
+		pr_warn("WARNING WARNING WARNING WARNING WARNING WARNING\n"
+			"This system BIOS has enabled interrupt remapping\n"
+			"on a chipset that contains an errata making that\n"
+			"feature unstable.  Please reboot with nointremap\n"
+			"added to the kernel command line and contact\n"
+			"your BIOS vendor for an update");
+	}
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5520_IOHUB, intel_remapping_check);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5500_IOHUB, intel_remapping_check);
+
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 31717bd..54027a6 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2732,6 +2732,8 @@
 #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_RANK_REV2  0x2db2
 #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_TC_REV2    0x2db3
 #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
+#define PCI_DEVICE_ID_INTEL_5500_IOHUB	0x3403
+#define PCI_DEVICE_ID_INTEL_5520_IOHUB	0x3406
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG4	0x3429
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG5	0x342a
 #define PCI_DEVICE_ID_INTEL_IOAT_TBG6	0x342b
-- 
1.7.11.7

