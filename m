Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaGNGFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:05:39 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:56588 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbaGNGFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:05:31 -0400
Date: Mon, 14 Jul 2014 11:33:34 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v4 0/6] Add Keystone PCIe controller driver
Message-ID: <20140714060334.GB2930@pratyush-vbox>
References: <1405110995-24676-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1405110995-24676-1-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-13_03:2014-07-11,2014-07-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh.. I see my reply from gmail is not readable at all. (I forgot to
switch to plain text :( ) Please ignore last mail I am replying again
here.

On Sat, Jul 12, 2014 at 04:36:29AM +0800, Murali Karicheri wrote:

[...]

> Murali Karicheri (6):
>   PCI: designware: add rd[wr]_other_conf API
>   PCI: designware: refactor MSI code to work with v3.65 dw hardware

For  above two you can add my reviewed-by:

>   PCI: designware: refactor host init code to re-use on keystone PCI
>   PCI: designware: enhance dw core driver to support keystone PCI host

In stead of using version number and then changing few functions from
static to global , I would have used same philosophy of adding callbacks
wherever needed. May be maintainers can give their view, instead of patch 
3 and 4 I would have gone with something like this, where kc_pcie can be 
passed through pp->plat_data.
 
diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
index 905941c..b216192 100644
--- a/drivers/pci/host/pcie-designware.c
+++ b/drivers/pci/host/pcie-designware.c
@@ -490,16 +490,21 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
        }
 
        if (IS_ENABLED(CONFIG_PCI_MSI)) {
-               pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
-                                       MAX_MSI_IRQS, &msi_domain_ops,
-                                       &dw_pcie_msi_chip);
-               if (!pp->irq_domain) {
-                       dev_err(pp->dev, "irq domain init failed\n");
-                       return -ENXIO;
-               }
+               if (!pp->ops->msi_init) {
+                       pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
+                                               MAX_MSI_IRQS, &msi_domain_ops,
+                                               &dw_pcie_msi_chip);
+                       if (!pp->irq_domain) {
+                               dev_err(pp->dev, "irq domain init failed\n");
+                               return -ENXIO;
+                       }
 
-               for (i = 0; i < MAX_MSI_IRQS; i++)
-                       irq_create_mapping(pp->irq_domain, i);
+                       for (i = 0; i < MAX_MSI_IRQS; i++)
+                               irq_create_mapping(pp->irq_domain, i);
+               } else {
+                       pp->ops->msi_init(pp, &msi_domain_ops,
+                                               &dw_pcie_msi_chip);
+               }
        }
 
        if (pp->ops->host_init)
@@ -759,6 +764,9 @@ static struct pci_bus *dw_pcie_scan_bus(int nr, struct pci_sys_data *sys)
                BUG();
        }
 
+       if (bus && pp->ops->scan_bus)
+               bus = pp->ops->scan_bus(pp);
+
        return bus;
 }
 
diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
index 387f69e..39ce496 100644
--- a/drivers/pci/host/pcie-designware.h
+++ b/drivers/pci/host/pcie-designware.h
@@ -52,6 +52,7 @@ struct pcie_port {
        struct irq_domain       *irq_domain;
        unsigned long           msi_data;
        DECLARE_BITMAP(msi_irq_in_use, MAX_MSI_IRQS);
+       void                    *plat_data;
 };
 
 struct pcie_host_ops {
@@ -70,6 +71,9 @@ struct pcie_host_ops {
        void (*msi_set_irq)(struct pcie_port *pp, int irq);
        void (*msi_clear_irq)(struct pcie_port *pp, int irq);
        u32 (*get_msi_data)(struct pcie_port *pp);
+       struct pci_bus *(*scan_bus)(struct pcie_port *pp);
+       void (*msi_init) (struct pcie_port *pp, struct irq_domain_ops *ops,
+                       struct msi_chip *chip);
 };
 
 int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);


~Pratyush
