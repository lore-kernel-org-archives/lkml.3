Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaIVFBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 01:01:54 -0400
Received: from ozlabs.org ([103.22.144.67]:35065 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbaIVFBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 01:01:36 -0400
Message-ID: <1411362094.984.15.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH 07/15] powerpc/powerpc: Add new PCIe functions for
 allocating cxl interrupts
From: Michael Neuling <mikey@neuling.org>
To: Gavin Shan <gwshan@linux.vnet.ibm.com>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, cbe-oss-dev@lists.ozlabs.org,
        imunsie@au1.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, anton@samba.org
Date: Mon, 22 Sep 2014 15:01:34 +1000
In-Reply-To: <20140919070939.GB27190@shangw>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	 <1411028820-29933-8-git-send-email-mikey@neuling.org>
	 <20140919070939.GB27190@shangw>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<snip>
> >+struct device_node *pnv_pci_to_phb_node(struct pci_dev *dev)
> >+{
> >+	struct device_node *np;
> >+	struct property *prop = NULL;
> >+
> >+	np = of_node_get(pci_device_to_OF_node(dev));
> >+
> >+	/* Scan up the tree looking for the PHB node */
> >+	while (np) {
> >+		if ((prop = of_find_property(np, "ibm,opal-phbid", NULL)))
> >+			break;
> >+		np = of_get_next_parent(np);
> >+	}
> >+
> >+	if (!prop) {
> >+		of_node_put(np);
> >+		return NULL;
> >+	}
> >+
> >+	return np;
> >+}
> >+EXPORT_SYMBOL(pnv_pci_to_phb_node);
> 
> Nitpick: I'm not sure it's better way. "struct pci_controller::dn" should
> always have valid "ibm,opal-phbid", so I guess the code could be like this
> way:
> 
> 	struct pci_controller *hose = pci_bus_to_host(dev->bus);
> 
> 	return hose->dn;

Nice.. that makes it much simpler.  I'll update.

<snip>
> >+
> >+#ifdef CONFIG_CXL_BASE
> >+int pnv_phb_to_cxl(struct pci_dev *dev)
> >+{
> >+	struct device_node *np;
> >+	struct pnv_ioda_pe *pe;
> >+	const u64 *prop64;
> >+	u64 phb_id;
> >+	int rc;
> >+
> >+	dev_info(&dev->dev, "switch PHB to CXL\n");
> >+
> >+	if (!(np = pnv_pci_to_phb_node(dev)))
> >+		return -ENODEV;
> >+
> >+	prop64 = of_get_property(np, "ibm,opal-phbid", NULL);
> >+
> >+	phb_id = be64_to_cpup(prop64);
> >+	dev_info(&dev->dev, "PHB-ID  : 0x%016llx\n", phb_id);
> >+
> 
> The PHB ID would have been there: struct pnv_phb::opal_id. So
> I guess we needn't grab it from device-tree again :)

Nice, I'll update.

> >+	if (!(pe = pnv_ioda_get_pe(dev))) {
> >+		rc = -ENODEV;
> >+		goto out;
> >+	}
> >+	dev_info(&dev->dev, "     pe : %i\n", pe->pe_number);
> 
> Perhaps you can reuse pe_info() here.

Yep, will do.

<snip>
> >+#ifdef CONFIG_CXL_BASE
> >+int pnv_cxl_ioda_msi_setup(struct pci_dev *dev, unsigned int hwirq,
> >+			   unsigned int virq)
> >+{
> >+	struct pci_controller *hose = pci_bus_to_host(dev->bus);
> >+	struct pnv_phb *phb = hose->private_data;
> >+	unsigned int xive_num = hwirq - phb->msi_base;
> >+	struct pnv_ioda_pe *pe;
> >+	int rc;
> >+
> >+	if (!(pe = pnv_ioda_get_pe(dev)))
> >+		return -ENODEV;
> >+
> >+	/* Assign XIVE to PE */
> >+	rc = opal_pci_set_xive_pe(phb->opal_id, pe->pe_number, xive_num);
> >+	if (rc) {
> >+		pr_warn("%s: OPAL error %d setting msi_base 0x%x hwirq 0x%x XIVE 0x%x PE\n",
> >+			pci_name(dev), rc, phb->msi_base, hwirq, xive_num);
> >+		return -EIO;
> >+	}
> 
> It seems current firmware doesn't support the OPAL API for PHB3.

The current public version of skiboot seems to be doing something here
in hw/phb3.c in phb3_set_ive_pe():

https://github.com/open-power/skiboot/blob/c34c4ef8c660e3e439365c8f5c06143ff00bc6bc/hw/phb3.c#L1096

I think we still need this.

Thanks again!
Mikey
