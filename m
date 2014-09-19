Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbaISHKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 03:10:47 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54661 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378AbaISHKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 03:10:44 -0400
Date: Fri, 19 Sep 2014 17:09:39 +1000
From: Gavin Shan <gwshan@linux.vnet.ibm.com>
To: Michael Neuling <mikey@neuling.org>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, cbe-oss-dev@lists.ozlabs.org,
        imunsie@au1.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, anton@samba.org
Subject: Re: [PATCH 07/15] powerpc/powerpc: Add new PCIe functions for
 allocating cxl interrupts
Message-ID: <20140919070939.GB27190@shangw>
Reply-To: Gavin Shan <gwshan@linux.vnet.ibm.com>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
 <1411028820-29933-8-git-send-email-mikey@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411028820-29933-8-git-send-email-mikey@neuling.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091907-5140-0000-0000-0000004DDFF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 06:26:52PM +1000, Michael Neuling wrote:
>From: Ian Munsie <imunsie@au1.ibm.com>
>
>This adds a number of functions for allocating IRQs under powernv PCIe for cxl.
>
>Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
>Signed-off-by: Michael Neuling <mikey@neuling.org>
>---
> arch/powerpc/include/asm/pnv-pci.h        |  27 +++++
> arch/powerpc/platforms/powernv/pci-ioda.c | 186 ++++++++++++++++++++++++++++++
> 2 files changed, 213 insertions(+)
> create mode 100644 arch/powerpc/include/asm/pnv-pci.h
>
>diff --git a/arch/powerpc/include/asm/pnv-pci.h b/arch/powerpc/include/asm/pnv-pci.h
>new file mode 100644
>index 0000000..71717b5
>--- /dev/null
>+++ b/arch/powerpc/include/asm/pnv-pci.h
>@@ -0,0 +1,27 @@
>+/*
>+ * Copyright 2014 IBM Corp.
>+ *
>+ * This program is free software; you can redistribute it and/or
>+ * modify it under the terms of the GNU General Public License
>+ * as published by the Free Software Foundation; either version
>+ * 2 of the License, or (at your option) any later version.
>+ */
>+
>+#ifndef _ASM_PNV_PCI_H
>+#define _ASM_PNV_PCI_H
>+
>+#include <linux/pci.h>
>+#include <misc/cxl.h>
>+
>+int pnv_phb_to_cxl(struct pci_dev *dev);
>+int pnv_cxl_ioda_msi_setup(struct pci_dev *dev, unsigned int hwirq,
>+			   unsigned int virq);
>+int pnv_cxl_alloc_hwirqs(struct pci_dev *dev, int num);
>+void pnv_cxl_release_hwirqs(struct pci_dev *dev, int hwirq, int num);
>+int pnv_cxl_alloc_hwirq_ranges(struct cxl_irq_ranges *irqs,
>+			       struct pci_dev *dev, int num);
>+void pnv_cxl_release_hwirq_ranges(struct cxl_irq_ranges *irqs,
>+				  struct pci_dev *dev);
>+int pnv_cxl_get_irq_count(struct pci_dev *dev);
>+
>+#endif
>diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
>index 194f90a..80919f8 100644
>--- a/arch/powerpc/platforms/powernv/pci-ioda.c
>+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
>@@ -38,6 +38,8 @@
> #include <asm/debug.h>
> #include <asm/firmware.h>
> 
>+#include <misc/cxl.h>
>+
> #include "powernv.h"
> #include "pci.h"
> 
>@@ -503,6 +505,163 @@ static struct pnv_ioda_pe *pnv_ioda_get_pe(struct pci_dev *dev)
> 		return NULL;
> 	return &phb->ioda.pe_array[pdn->pe_number];
> }
>+
>+struct device_node *pnv_pci_to_phb_node(struct pci_dev *dev)
>+{
>+	struct device_node *np;
>+	struct property *prop = NULL;
>+
>+	np = of_node_get(pci_device_to_OF_node(dev));
>+
>+	/* Scan up the tree looking for the PHB node */
>+	while (np) {
>+		if ((prop = of_find_property(np, "ibm,opal-phbid", NULL)))
>+			break;
>+		np = of_get_next_parent(np);
>+	}
>+
>+	if (!prop) {
>+		of_node_put(np);
>+		return NULL;
>+	}
>+
>+	return np;
>+}
>+EXPORT_SYMBOL(pnv_pci_to_phb_node);

Nitpick: I'm not sure it's better way. "struct pci_controller::dn" should
always have valid "ibm,opal-phbid", so I guess the code could be like this
way:

	struct pci_controller *hose = pci_bus_to_host(dev->bus);

	return hose->dn;

>+
>+#ifdef CONFIG_CXL_BASE
>+int pnv_phb_to_cxl(struct pci_dev *dev)
>+{
>+	struct device_node *np;
>+	struct pnv_ioda_pe *pe;
>+	const u64 *prop64;
>+	u64 phb_id;
>+	int rc;
>+
>+	dev_info(&dev->dev, "switch PHB to CXL\n");
>+
>+	if (!(np = pnv_pci_to_phb_node(dev)))
>+		return -ENODEV;
>+
>+	prop64 = of_get_property(np, "ibm,opal-phbid", NULL);
>+
>+	phb_id = be64_to_cpup(prop64);
>+	dev_info(&dev->dev, "PHB-ID  : 0x%016llx\n", phb_id);
>+

The PHB ID would have been there: struct pnv_phb::opal_id. So
I guess we needn't grab it from device-tree again :)

>+	if (!(pe = pnv_ioda_get_pe(dev))) {
>+		rc = -ENODEV;
>+		goto out;
>+	}
>+	dev_info(&dev->dev, "     pe : %i\n", pe->pe_number);

Perhaps you can reuse pe_info() here.

>+
>+	if ((rc = opal_pci_set_phb_cxl_mode(phb_id, 1, pe->pe_number)))
>+		dev_err(&dev->dev, "opal_pci_set_phb_cxl_mode failed: %i\n", rc);
>+
>+out:
>+	of_node_put(np);
>+	return rc;
>+}
>+EXPORT_SYMBOL(pnv_phb_to_cxl);
>+
>+int pnv_cxl_alloc_hwirqs(struct pci_dev *dev, int num)
>+{
>+	struct pci_controller *hose = pci_bus_to_host(dev->bus);
>+	struct pnv_phb *phb = hose->private_data;
>+	int hwirq = msi_bitmap_alloc_hwirqs(&phb->msi_bmp, num);
>+
>+	if (hwirq < 0) {
>+		dev_warn(&dev->dev, "Failed to find a free MSI\n");
>+		return -ENOSPC;
>+	}
>+
>+	return phb->msi_base + hwirq;
>+}
>+EXPORT_SYMBOL(pnv_cxl_alloc_hwirqs);
>+
>+void pnv_cxl_release_hwirqs(struct pci_dev *dev, int hwirq, int num)
>+{
>+	struct pci_controller *hose = pci_bus_to_host(dev->bus);
>+	struct pnv_phb *phb = hose->private_data;
>+
>+	msi_bitmap_free_hwirqs(&phb->msi_bmp, hwirq - phb->msi_base, num);
>+}
>+EXPORT_SYMBOL(pnv_cxl_release_hwirqs);
>+
>+
>+int pnv_cxl_alloc_hwirq_ranges(struct cxl_irq_ranges *irqs,
>+			       struct pci_dev *dev, int num)
>+{
>+	struct pci_controller *hose = pci_bus_to_host(dev->bus);
>+	struct pnv_phb *phb = hose->private_data;
>+	int range = 0;
>+	int hwirq;
>+	int try;
>+
>+	memset(irqs, 0, sizeof(struct cxl_irq_ranges));
>+
>+	for (range = 1; range < CXL_IRQ_RANGES && num; range++) {
>+		try = num;
>+		while (try) {
>+			hwirq = msi_bitmap_alloc_hwirqs(&phb->msi_bmp, try);
>+			if (hwirq >= 0)
>+				break;
>+			try /= 2;
>+		}
>+		if (!try)
>+			goto fail;
>+
>+		irqs->offset[range] = phb->msi_base + hwirq;
>+		irqs->range[range] = try;
>+		pr_devel("cxl alloc irq range 0x%x: offset: 0x%lx  limit: %li\n",
>+			 range, irqs->offset[range], irqs->range[range]);
>+		num -= try;
>+	}
>+	if (num)
>+		goto fail;
>+
>+	return 0;
>+fail:
>+	for (range--; range >= 0; range--) {
>+		hwirq = irqs->offset[range] - phb->msi_base;
>+		msi_bitmap_free_hwirqs(&phb->msi_bmp, hwirq,
>+				       irqs->range[range]);
>+		irqs->range[range] = 0;
>+	}
>+	return -ENOSPC;
>+}
>+EXPORT_SYMBOL(pnv_cxl_alloc_hwirq_ranges);
>+
>+void pnv_cxl_release_hwirq_ranges(struct cxl_irq_ranges *irqs,
>+				  struct pci_dev *dev)
>+{
>+	struct pci_controller *hose = pci_bus_to_host(dev->bus);
>+	struct pnv_phb *phb = hose->private_data;
>+	int range = 0;
>+	int hwirq;
>+
>+	for (range = 0; range < 4; range++) {
>+		hwirq = irqs->offset[range] - phb->msi_base;
>+		if (irqs->range[range]) {
>+			pr_devel("cxl release irq range 0x%x: offset: 0x%lx  limit: %ld\n",
>+				 range, irqs->offset[range],
>+				 irqs->range[range]);
>+			msi_bitmap_free_hwirqs(&phb->msi_bmp, hwirq,
>+					       irqs->range[range]);
>+		}
>+	}
>+}
>+EXPORT_SYMBOL(pnv_cxl_release_hwirq_ranges);
>+
>+int pnv_cxl_get_irq_count(struct pci_dev *dev)
>+{
>+	struct pci_controller *hose = pci_bus_to_host(dev->bus);
>+        struct pnv_phb *phb = hose->private_data;
>+
>+	return phb->msi_bmp.irq_count;
>+}
>+EXPORT_SYMBOL(pnv_cxl_get_irq_count);
>+
>+#endif /* CONFIG_CXL_BASE */
> #endif /* CONFIG_PCI_MSI */
> 
> static int pnv_ioda_configure_pe(struct pnv_phb *phb, struct pnv_ioda_pe *pe)
>@@ -1330,6 +1489,33 @@ static void set_msi_irq_chip(struct pnv_phb *phb, unsigned int virq)
> 	}
> }
> 
>+#ifdef CONFIG_CXL_BASE
>+int pnv_cxl_ioda_msi_setup(struct pci_dev *dev, unsigned int hwirq,
>+			   unsigned int virq)
>+{
>+	struct pci_controller *hose = pci_bus_to_host(dev->bus);
>+	struct pnv_phb *phb = hose->private_data;
>+	unsigned int xive_num = hwirq - phb->msi_base;
>+	struct pnv_ioda_pe *pe;
>+	int rc;
>+
>+	if (!(pe = pnv_ioda_get_pe(dev)))
>+		return -ENODEV;
>+
>+	/* Assign XIVE to PE */
>+	rc = opal_pci_set_xive_pe(phb->opal_id, pe->pe_number, xive_num);
>+	if (rc) {
>+		pr_warn("%s: OPAL error %d setting msi_base 0x%x hwirq 0x%x XIVE 0x%x PE\n",
>+			pci_name(dev), rc, phb->msi_base, hwirq, xive_num);
>+		return -EIO;
>+	}

It seems current firmware doesn't support the OPAL API for PHB3.

>+	set_msi_irq_chip(phb, virq);
>+
>+	return 0;
>+}
>+EXPORT_SYMBOL(pnv_cxl_ioda_msi_setup);
>+#endif
>+
> static int pnv_pci_ioda_msi_setup(struct pnv_phb *phb, struct pci_dev *dev,
> 				  unsigned int hwirq, unsigned int virq,
> 				  unsigned int is_64, struct msi_msg *msg)

Thanks,
Gavin
>-- 
>1.9.1
>
>_______________________________________________
>Linuxppc-dev mailing list
>Linuxppc-dev@lists.ozlabs.org
>https://lists.ozlabs.org/listinfo/linuxppc-dev

