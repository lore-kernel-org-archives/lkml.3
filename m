Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab3BCPGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:06:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34490 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754590Ab3BCO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:39 -0500
Message-Id: <20130203144652.191455164@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Adam Jackson <ajax@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        stathis <stathis@npcglib.org>, Mihai Moldovan <ionic@ionic.de>
Subject: [ 092/128] iommu/intel: disable DMAR for g4x integrated gfx
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/intel-iommu.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4090,6 +4090,21 @@ static struct iommu_ops intel_iommu_ops
 	.domain_has_cap = intel_iommu_domain_has_cap,
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
@@ -4098,12 +4113,6 @@ static void __devinit quirk_iommu_rwbf(s
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


