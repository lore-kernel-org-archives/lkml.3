Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480Ab3GWW1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934427Ab3GWW06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:26:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 004/103] powerpc/powernv: Fix iommu initialization again
Date: Tue, 23 Jul 2013 15:25:15 -0700
Message-Id: <20130723220419.067967543@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 74251fe21bfa9310ddba9e0436d1fcf389e602ee upstream.

So because those things always end up in trainwrecks... In 7846de406
we moved back the iommu initialization earlier, essentially undoing
37f02195b which was causing us endless trouble... except that in the
meantime we had merged 959c9bdd58 (to workaround the original breakage)
which is now ... broken :-)

This fixes it by doing a partial revert of the latter (we keep the
ppc_md. path which will be needed in the hotplug case, which happens
also during some EEH error recovery situations).

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/pci-ioda.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -441,6 +441,17 @@ static void pnv_pci_ioda_dma_dev_setup(s
 	set_iommu_table_base(&pdev->dev, &pe->tce32_table);
 }
 
+static void pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe, struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		set_iommu_table_base(&dev->dev, &pe->tce32_table);
+		if (dev->subordinate)
+			pnv_ioda_setup_bus_dma(pe, dev->subordinate);
+	}
+}
+
 static void pnv_pci_ioda1_tce_invalidate(struct iommu_table *tbl,
 					 u64 *startp, u64 *endp)
 {
@@ -596,6 +607,11 @@ static void pnv_pci_ioda_setup_dma_pe(st
 	}
 	iommu_init_table(tbl, phb->hose->node);
 
+	if (pe->pdev)
+		set_iommu_table_base(&pe->pdev->dev, tbl);
+	else
+		pnv_ioda_setup_bus_dma(pe, pe->pbus);
+
 	return;
  fail:
 	/* XXX Failure: Try to fallback to 64-bit only ? */
@@ -667,6 +683,11 @@ static void pnv_pci_ioda2_setup_dma_pe(s
 	}
 	iommu_init_table(tbl, phb->hose->node);
 
+	if (pe->pdev)
+		set_iommu_table_base(&pe->pdev->dev, tbl);
+	else
+		pnv_ioda_setup_bus_dma(pe, pe->pbus);
+
 	return;
 fail:
 	if (pe->tce32_seg >= 0)


