Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab3GaDMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 23:12:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab3GaDMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 23:12:45 -0400
Message-ID: <1375240269.31262.92.camel@ul30vt.home>
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
From: Alex Williamson <alex.williamson@redhat.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        Don Dutile <ddutile@redhat.com>,
        "Sumner, William" <bill.sumner@hp.com>,
        Haren Myneni <hbabu@us.ibm.com>
Date: Tue, 30 Jul 2013 21:11:09 -0600
In-Reply-To: <51F85BCC.2070103@jp.fujitsu.com>
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com>
	 <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com>
	 <51B19DF3.2070009@jp.fujitsu.com>
	 <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com>
	 <51B6BEDB.3000509@jp.fujitsu.com>
	 <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com>
	 <51B93221.2040505@jp.fujitsu.com>
	 <CAErSpo5tVK-Z3aOdMTzab-S8o5zLVtDOFQ8-LSYpUgbrJSsxuw@mail.gmail.com>
	 <51BA7BB6.1080104@jp.fujitsu.com> <51EF7466.20703@jp.fujitsu.com>
	 <CAErSpo5B7NzVfxwW3bQnfK+iK+DrRsWQd2Cm14z5PWNnRHWL5w@mail.gmail.com>
	 <51F5B966.9080405@jp.fujitsu.com>
	 <CAErSpo4JtG5qVJb-nCywe3vkft=-cDeRDKn_V92RCZ-sGXpwbg@mail.gmail.com>
	 <51F758B6.9090204@jp.fujitsu.com>
	 <CAErSpo7TNhQO0dx_xZvF=dU2fSWTFf8x=xUJcEsbadJkv8ktuQ@mail.gmail.com>
	 <51F85BCC.2070103@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 09:35 +0900, Takao Indoh wrote:
> (2013/07/31 0:59), Bjorn Helgaas wrote:
> > On Tue, Jul 30, 2013 at 12:09 AM, Takao Indoh
> > <indou.takao@jp.fujitsu.com> wrote:
> >> (2013/07/29 23:17), Bjorn Helgaas wrote:
> >>> On Sun, Jul 28, 2013 at 6:37 PM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
> >>>> (2013/07/26 2:00), Bjorn Helgaas wrote:
> > 
> >>>>> My point about IOMMU and PCI initialization order doesn't go away just
> >>>>> because it doesn't fit "kdump policy."  Having system initialization
> >>>>> occur in a logical order is far more important than making kdump work.
> >>>>
> >>>> My next plan is as follows. I think this is matched to logical order
> >>>> on boot.
> >>>>
> >>>> drivers/pci/pci.c
> >>>> - Add function to reset bus, for example, pci_reset_bus(struct pci_bus *bus)
> >>>>
> >>>> drivers/iommu/intel-iommu.c
> >>>> - On initialization, if IOMMU is already enabled, call this bus reset
> >>>>     function before disabling and re-enabling IOMMU.
> >>>
> >>> I raised this issue because of arches like sparc that enumerate the
> >>> IOMMU before the PCI devices that use it.  In that situation, I think
> >>> you're proposing this:
> >>>
> >>>     panic kernel
> >>>       enable IOMMU
> >>>       panic
> >>>     kdump kernel
> >>>       initialize IOMMU (already enabled)
> >>>         pci_reset_bus
> >>>         disable IOMMU
> >>>         enable IOMMU
> >>>       enumerate PCI devices
> >>>
> >>> But the problem is that when you call pci_reset_bus(), you haven't
> >>> enumerated the PCI devices, so you don't know what to reset.
> >>
> >> Right, so my idea is adding reset code into "intel-iommu.c". intel-iommu
> >> initialization is based on the assumption that enumeration of PCI devices
> >> is already done. We can find target device from IOMMU page table instead
> >> of scanning all devices in pci tree.
> >>
> >> Therefore, this idea is only for intel-iommu. Other architectures need
> >> to implement their own reset code.
> > 
> > That's my point.  I'm opposed to adding code to PCI when it only
> > benefits x86 and we know other arches will need a fundamentally
> > different design.  I would rather have a design that can work for all
> > arches.
> > 
> > If your implementation is totally implemented under arch/x86 (or in
> > intel-iommu.c, I guess), I can't object as much.  However, I think
> > that eventually even x86 should enumerate the IOMMUs via ACPI before
> > we enumerate PCI devices.
> > 
> > It's pretty clear that's how BIOS designers expect the OS to work.
> > For example, sec 8.7.3 of the Intel Virtualization Technology for
> > Directed I/O spec, rev 1.3, shows the expectation that remapping
> > hardware (IOMMU) is initialized before discovering the I/O hierarchy
> > below a hot-added host bridge.  Obviously you're not talking about a
> > hot-add scenario, but I think the same sequence should apply at
> > boot-time as well.
> 
> Of course I won't add something just for x86 into common PCI layer. I
> attach my new patch, though it is not well tested yet.
> 
> On x86, currently IOMMU initialization run *after* PCI enumeration, but
> what you are talking about is that it should be changed so that x86
> IOMMU initialization is done *before* PCI enumeration like sparc, right?
> 
> Hmm, ok, I think I need to post attached patch to iommu list and
> discuss it including current order of x86 IOMMU initialization.
> 
> Thanks,
> Takao Indoh
> ---
>  drivers/iommu/intel-iommu.c |   55 +++++++++++++++++++++++++++++++++-
>  drivers/pci/pci.c           |   53 ++++++++++++++++++++++++++++++++
>  include/linux/pci.h         |    1
>  3 files changed, 108 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index eec0d3e..fb8a546 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -3663,6 +3663,56 @@ static struct notifier_block device_nb = {
>  	.notifier_call = device_notifier,
>  };
>  
> +/* Reset PCI device if its entry exists in DMAR table */
> +static void __init iommu_reset_devices(struct intel_iommu *iommu, u16 segment)
> +{
> +	u64 addr;
> +	struct root_entry *root;
> +	struct context_entry *context;
> +	int bus, devfn;
> +	struct pci_dev *dev;
> +
> +	addr = dmar_readq(iommu->reg + DMAR_RTADDR_REG);
> +	if (!addr)
> +		return;
> +
> +	/*
> +	 *  In the case of kdump, ioremap is needed because root-entry table
> +	 *  exists in first kernel's memory area which is not mapped in second
> +	 *  kernel
> +	 */
> +	root = (struct root_entry*)ioremap(addr, PAGE_SIZE);
> +	if (!root)
> +		return;
> +
> +	for (bus=0; bus<ROOT_ENTRY_NR; bus++) {
> +		if (!root_present(&root[bus]))
> +			continue;
> +
> +		context = (struct context_entry *)ioremap(
> +			root[bus].val & VTD_PAGE_MASK, PAGE_SIZE);
> +		if (!context)
> +			continue;
> +
> +		for (devfn=0; devfn<ROOT_ENTRY_NR; devfn++) {
> +			if (!context_present(&context[devfn]))
> +				continue;
> +
> +			dev = pci_get_domain_bus_and_slot(segment, bus, devfn);
> +			if (!dev)
> +				continue;
> +
> +			if (!pci_reset_bus(dev->bus)) /* go to next bus */
> +				break;
> +			else /* Try per-function reset */
> +				pci_reset_function(dev);
> +
> +		}
> +		iounmap(context);
> +	}
> +	iounmap(root);
> +}
> +
>  int __init intel_iommu_init(void)
>  {
>  	int ret = 0;
> @@ -3687,8 +3737,11 @@ int __init intel_iommu_init(void)
>  			continue;
>  
>  		iommu = drhd->iommu;
> -		if (iommu->gcmd & DMA_GCMD_TE)
> +		if (iommu->gcmd & DMA_GCMD_TE) {
> +			if (reset_devices)
> +				iommu_reset_devices(iommu, drhd->segment);
>  			iommu_disable_translation(iommu);
> +		}
>  	}
>  
>  	if (dmar_dev_scope_init() < 0) {
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index e37fea6..c595997 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3392,6 +3392,59 @@ int pci_reset_function(struct pci_dev *dev)
>  EXPORT_SYMBOL_GPL(pci_reset_function);
>  
>  /**
> + * pci_reset_bus - reset a PCI bus
> + * @bus: PCI bus to reset
> + *
> + * Returns 0 if the bus was successfully reset or negative if failed.
> + */
> +int pci_reset_bus(struct pci_bus *bus)
> +{
> +	struct pci_dev *pdev;
> +	u16 ctrl;
> +
> +	if (!bus->self)
> +		return -ENOTTY;
> +
> +	list_for_each_entry(pdev, &bus->devices, bus_list)
> +		if (pdev->subordinate)
> +			return -ENOTTY;
> +
> +	/* Save config registers of children */
> +	list_for_each_entry(pdev, &bus->devices, bus_list) {
> +		dev_info(&pdev->dev, "Save state\n");
> +		pci_save_state(pdev);
> +	}
> +
> +	dev_info(&bus->self->dev, "Reset Secondary bus\n");
> +
> +	/* Assert Secondary Bus Reset */
> +	pci_read_config_word(bus->self, PCI_BRIDGE_CONTROL, &ctrl);
> +	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
> +	pci_write_config_word(bus->self, PCI_BRIDGE_CONTROL, ctrl);
> +
> +	/* Read config again to flush previous write */
> +	pci_read_config_word(bus->self, PCI_BRIDGE_CONTROL, &ctrl);
> +
> +	msleep(2);
> +
> +	/* De-assert Secondary Bus Reset */
> +	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
> +	pci_write_config_word(bus->self, PCI_BRIDGE_CONTROL, ctrl);
> +
> +	/* Wait for completion */
> +	msleep(1000);


We already have secondary bus reset code in this file, why are we
duplicating it here?  Also, why are these delays different from the
existing code?  I'm also in need of a bus reset interface for when we
assign all of the devices on a bus to userspace and do not have working
function level resets per device.  I'll post my patch series and perhaps
we can collaborate on a pci bus reset interface.  Thanks,

Alex

> +
> +	/* Restore config registers of children */
> +	list_for_each_entry(pdev, &bus->devices, bus_list) {
> +		dev_info(&pdev->dev, "Restore state\n");
> +		pci_restore_state(pdev);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_reset_bus);
> +
> +/**
>   * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
>   * @dev: PCI device to query
>   *
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 0fd1f15..125fbc6 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -924,6 +924,7 @@ int pcie_set_mps(struct pci_dev *dev, int mps);
>  int __pci_reset_function(struct pci_dev *dev);
>  int __pci_reset_function_locked(struct pci_dev *dev);
>  int pci_reset_function(struct pci_dev *dev);
> +int pci_reset_bus(struct pci_bus *bus);
>  void pci_update_resource(struct pci_dev *dev, int resno);
>  int __must_check pci_assign_resource(struct pci_dev *dev, int i);
>  int __must_check pci_reassign_resource(struct pci_dev *dev, int i, resource_size_t add_size, resource_size_t align);
> 



