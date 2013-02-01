Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161045Ab3BAKzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:55:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:39266 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422687Ab3BAKvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:51:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adam Jackson <ajax@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        stathis <stathis@npcglib.org>, Mihai Moldovan <ionic@ionic.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 25/33] iommu/intel: disable DMAR for g4x integrated gfx
Date: Fri,  1 Feb 2013 11:49:30 +0100
Message-Id: <20130201104726.442362197@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104724.605715763@linuxfoundation.org>
References: <20130201104724.605715763@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org
Acked-By: David Woodhouse <David.Woodhouse@intel.com>
Tested-by: stathis <stathis@npcglib.org>
Tested-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4193,6 +4193,21 @@ static struct iommu_ops intel_iommu_ops
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
@@ -4201,12 +4216,6 @@ static void __devinit quirk_iommu_rwbf(s
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


