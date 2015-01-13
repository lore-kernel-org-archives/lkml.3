Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbbAMMeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:34:13 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:18114 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbbAMMeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:34:11 -0500
Message-ID: <54B510BA.7030202@huawei.com>
Date: Tue, 13 Jan 2015 20:34:02 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH v2 2/8] PCI/MSI: Add hooks to populate the msi_domain
 field
References: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com> <1420736772-11088-3-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1420736772-11088-3-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.54B510C1.0189,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 25661d8ab10e9569214d3c0452a8aef7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  					   struct pci_dev *bridge, int busnr)
>  {
> @@ -713,6 +727,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  	bridge->subordinate = child;
>  
>  add_dev:
> +	pci_set_bus_msi_domain(child);
>  	ret = device_register(&child->dev);
>  	WARN_ON(ret < 0);
>  
> @@ -1507,6 +1522,17 @@ static void pci_init_capabilities(struct pci_dev *dev)
>  	pci_enable_acs(dev);
>  }
>  
> +static void pci_set_msi_domain(struct pci_dev *dev)
> +{
> +	/*
> +	 * If no domain has been set through the pcibios callback,
> +	 * inherit the default from the bus device.
> +	 */
> +	if (!dev_get_msi_domain(&dev->dev))
> +		dev_set_msi_domain(&dev->dev,
> +				   dev_get_msi_domain(&dev->bus->dev));
> +}

Hi Marc, now we have two ways to associate the pci_dev and msi_domain, right ?

1. associate pci_dev and msi_domain in pcibios_add_device() like x86.

2. Inherit msi_domain from pci_dev->bus.

My question is if all pci devices inherit msi_domain from the pci_bus,
so all pci devices under same pci host bridge have the same msi_domain assigned by
weak pcibios_set_phb_msi_domain(). So why not save the pci host bridge specific
msi_domain in pci_host_bridge. Then pci devices could inherit the msi_domain from
its pci host bridge directly, no need to involve pci bus in the assignment.

If I misunderstood, please let me know, :)

Thanks!
Yijing.

> +
>  void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>  {
>  	int ret;
> @@ -1547,6 +1573,9 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
>  	ret = pcibios_add_device(dev);
>  	WARN_ON(ret < 0);
>  
> +	/* Setup MSI irq domain */
> +	pci_set_msi_domain(dev);
> +
>  	/* Notifier could use PCI capabilities */
>  	dev->match_driver = false;
>  	ret = device_add(&dev->dev);
> @@ -1937,6 +1966,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  	b->bridge = get_device(&bridge->dev);
>  	device_enable_async_suspend(b->bridge);
>  	pci_set_bus_of_node(b);
> +	pci_set_bus_msi_domain(b);
>  
>  	if (!parent)
>  		set_dev_node(b->bridge, pcibus_to_node(b));
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 360a966..13c65ab 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1640,6 +1640,7 @@ int pcibios_set_pcie_reset_state(struct pci_dev *dev,
>  int pcibios_add_device(struct pci_dev *dev);
>  void pcibios_release_device(struct pci_dev *dev);
>  void pcibios_penalize_isa_irq(int irq, int active);
> +void pcibios_set_phb_msi_domain(struct pci_bus *bus);
>  
>  #ifdef CONFIG_HIBERNATE_CALLBACKS
>  extern struct dev_pm_ops pcibios_pm_ops;
> 


-- 
Thanks!
Yijing

