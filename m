Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab3BEWKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:10:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48070 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab3BEWKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Adam Jackson <ajax@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 50/93] iommu/intel: disable DMAR for g4x integrated gfx
Date: Tue,  5 Feb 2013 20:06:39 -0200
Message-Id: <1360102042-10732-51-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 9452618e7462181ed9755236803b6719298a13ce upstream.

DMAR support on g4x/gm45 integrated gpus seems to be totally busted.
So don't bother, but instead disable it by default to allow distros to
unconditionally enable DMAR support.

v2: Actually wire up the right quirk entry, spotted by Adam Jackson.

Note that according to intel marketing materials only g45 and gm45
support DMAR/VT-d. So we have reports for all relevant gen4 pci ids by
now. Still, keep all the other gen4 ids in the quirk table in case the
marketing stuff confused me again, which would not be the first time.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=51921
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=538163
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=538163
Cc: Adam Jackson <ajax@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-By: David Woodhouse <David.Woodhouse@intel.com>
Tested-by: stathis <stathis@npcglib.org>
Tested-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/iommu/intel-iommu.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 92f5912..1f78d86 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4191,6 +4191,21 @@ static struct iommu_ops intel_iommu_ops = {
 	.pgsize_bitmap	= INTEL_IOMMU_PGSIZES,
 };
 
+static void quirk_iommu_g4x_gfx(struct pci_dev *dev)
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
@@ -4199,12 +4214,6 @@ static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)
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
1.7.9.5

