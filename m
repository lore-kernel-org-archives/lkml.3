Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3ATWsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 17:48:15 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:62730 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3ATWsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 17:48:13 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Adam Jackson <ajax@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org
Subject: [PATCH] iommu/intel: disable DMAR for g4x integrated gfx
Date: Sun, 20 Jan 2013 23:50:13 +0100
Message-Id: <1358722213-2075-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMAR support on g4x/gm45 integrated gpus seems to be totally busted.
So don't bother, but instead disable it by default to allow distros to
unconditionally enable DMAR support.

v2: Actually wire up the right quirk entry, spotted by Adam Jackson.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=51921
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=538163
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=538163
Cc: Adam Jackson <ajax@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: stable@vger.kernel.org
Tested-by: stathis <stathis@npcglib.org>
Tested-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/iommu/intel-iommu.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d4a4cd4..9743769 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4196,6 +4196,21 @@ static struct iommu_ops intel_iommu_ops = {
 	.pgsize_bitmap	= INTEL_IOMMU_PGSIZES,
 };
 
+static void __devinit quirk_iommu_g4x_gfx(struct pci_dev *dev)
+{
+	/* G4x/GM45 integrated gfx dmar support is totally busted. */
+	printk(KERN_INFO "DMAR: Disabling IOMMU for graphics on this chipset\n");
+	dmar_map_gfx = 0;
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_g4x_gfx);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e00, quirk_iommu_g4x_gfx);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e10, quirk_iommu_g4x_gfx);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e20, quirk_iommu_g4x_gfx);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e30, quirk_iommu_g4x_gfx);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e40, quirk_iommu_g4x_gfx);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e90, quirk_iommu_g4x_gfx);
+
 static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)
 {
 	/*
@@ -4204,12 +4219,6 @@ static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)
 	 */
 	printk(KERN_INFO "DMAR: Forcing write-buffer flush capability\n");
 	rwbf_quirk = 1;
-
-	/* https://bugzilla.redhat.com/show_bug.cgi?id=538163 */
-	if (dev->revision == 0x07) {
-		printk(KERN_INFO "DMAR: Disabling IOMMU for graphics on this chipset\n");
-		dmar_map_gfx = 0;
-	}
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_rwbf);
-- 
1.7.10.4

