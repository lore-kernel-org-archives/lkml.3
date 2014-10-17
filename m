Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaJQJp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:45:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57861 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaJQJpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:45:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Li\, Zhen-Hua" <zhen-hual@hp.com>
Cc: <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <indou.takao@jp.fujitsu.com>,
        <kexec@lists.infradead.org>, <linda.knippers@hp.com>,
        Randy Wright <rwright@hp.com>
References: <1413537207-16514-1-git-send-email-zhen-hual@hp.com>
Date: Fri, 17 Oct 2014 02:44:43 -0700
In-Reply-To: <1413537207-16514-1-git-send-email-zhen-hual@hp.com> (Zhen-Hua
	Li's message of "Fri, 17 Oct 2014 17:13:27 +0800")
Message-ID: <87siin58tw.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/M+SnUERa7SVjig0heazjYINFYf/X95gM=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  1.0 XM_Sft_Co_L33T No description available.
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;"Li\, Zhen-Hua" <zhen-hual@hp.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 686 ms - load_scoreonly_sql: 0.07 (0.0%),
	signal_user_changed: 6 (0.9%), b_tie_ro: 3.6 (0.5%), parse: 1.78 (0.3%),
	extract_message_metadata: 25 (3.6%), get_uri_detail_list: 6 (0.8%),
	tests_pri_-1000: 12 (1.7%), tests_pri_-950: 1.52 (0.2%), tests_pri_-900: 1.31
	(0.2%), tests_pri_-400: 38 (5.6%), check_bayes: 37 (5.4%), b_tokenize: 14
	(2.0%), b_tok_get_all: 13 (1.9%), b_comp_prob: 3.6 (0.5%), b_tok_touch_all:
	3.3 (0.5%), b_finish: 0.84 (0.1%), tests_pri_0: 587 (85.6%), tests_pri_500: 8
	(1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/1] pci: reset all pci endpoints to stop on going dma
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Li, Zhen-Hua" <zhen-hual@hp.com> writes:

> This is an update of the patch
> 	https://lkml.org/lkml/2014/10/10/37
>
> This patch is doing the reset works before the kdump kernel boots.

If I have said it once I have said it a thousand times.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

It is absolutely inappropriate to do this in the kernel that has
crashed.

Either reserve a chunk of the iommu for use by the crash dump kernel,
or figure out how to do this during boot up.

But this is absolutely and totally inappropriate to do in crash_kexec.
The failure modes are all wrong.  It will impact the reliability of our
crash dumps.

If an the code for a linux architecture is not structured in such a way
as to make it easy or straight forward to do this my sympathies you are
going to have do fix that linux port to be able to do things during
boot.

But things called from crash_kexec should be absolute necessities and I
do not see this as coming anywhere close to being something that is
impossible to do in the target kernel.

Eric


> On a Linux system with iommu supported and many PCI devices on it,
> when kernel crashed and the kdump kernel boots with intel_iommu=on,
> there may be some unexpected DMA requests on this adapter, which will
> cause DMA Remapping faults like:
>     dmar: DRHD: handling fault status reg 102
>     dmar: DMAR:[DMA Read] Request device [41:00.0] fault addr fff81000
>     DMAR:[fault reason 01] Present bit in root entry is clear
>
> This bug may happen on *any* PCI device.
> Analysis for this bug:
>
> The present bit is set in this function:
>
> static struct context_entry * device_to_context_entry(
>                 struct intel_iommu *iommu, u8 bus, u8 devfn)
> {
>     ......
>                 set_root_present(root);
>     ......
> }
>
> Calling tree:
>     device driver
>         intel_alloc_coherent
>             __intel_map_single
>                 domain_context_mapping
>                     domain_context_mapping_one
>                         device_to_context_entry
>
> This means, the present bit in root entry will not be set until the device
> driver is loaded.
>
> But in the kdump kernel, hardware devices are not aware that control has
> transferred to the second kernel, and those drivers must initialize again.
> Consequently there may be unexpected DMA requests from devices activity
> initiated in the first kernel leading to the DMA Remapping errors in the
> second kernel.
>
> To fix this DMAR fault, we need to reset the bus that this device on. Reset
> the device itself does not work.
>
> A patch for this bug that has been sent before:
> https://lkml.org/lkml/2014/9/30/55
> As in discussion, this bug may happen on *any* device, so we need to reset
> all pci devices.
>
> There was an original version(Takao Indoh) that resets the pcie devices:
> https://lkml.org/lkml/2013/5/14/9
>
> According to the previous discussion, On sparc, the IOMMU is initialized
> before PCI devices are enumerated, this patch does the resetting works before
> the kdump kernel boots, so it can also fix the problems on sparc.
>
> Update of this new version, comparing with Takao Indoh's version:
>     Add support for legacy PCI devices.
>     Use pci_try_reset_bus instead of do_downstream_device_reset.
>     Reset all PCI/PCIe deviecs in the first kernel, before kdump kernel boots.
>
> Randy Wright corrects some misunderstanding in this description.
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
> Signed-off-by: Randy Wright <rwright@hp.com>
> ---
>  drivers/pci/pci.c   | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |  6 ++++
>  kernel/kexec.c      |  2 ++
>  3 files changed, 90 insertions(+)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 625a4ac..aa9192a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -23,6 +23,7 @@
>  #include <linux/device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pci_hotplug.h>
> +#include <linux/crash_dump.h>
>  #include <asm-generic/pci-bridge.h>
>  #include <asm/setup.h>
>  #include "pci.h"
> @@ -4466,6 +4467,87 @@ void __weak pci_fixup_cardbus(struct pci_bus *bus)
>  }
>  EXPORT_SYMBOL(pci_fixup_cardbus);
>  
> +/*
> + * Return true if dev is PCI root port or downstream port whose child is PCI
> + * endpoint except VGA device.
> + */
> +static int __pci_dev_need_reset(struct pci_dev *dev)
> +{
> +	struct pci_bus *subordinate;
> +	struct pci_dev *child;
> +
> +	if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
> +		return 0;
> +
> +	if (pci_is_pcie(dev)) {
> +		if ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT) &&
> +		    (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM))
> +			return 0;
> +	}
> +
> +	subordinate = dev->subordinate;
> +	list_for_each_entry(child, &subordinate->devices, bus_list) {
> +		/* Don't reset switch, bridge, VGA device */
> +		if ((child->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
> +		    ((child->class >> 16) == PCI_BASE_CLASS_BRIDGE) ||
> +		    ((child->class >> 16) == PCI_BASE_CLASS_DISPLAY))
> +			return 0;
> +
> +		if (pci_is_pcie(child)) {
> +			if ((pci_pcie_type(child) == PCI_EXP_TYPE_UPSTREAM) ||
> +			    (pci_pcie_type(child) == PCI_EXP_TYPE_PCI_BRIDGE))
> +				return 0;
> +		}
> +	}
> +
> +	return 1;
> +}
> +
> +struct pci_dev_reset_entry {
> +	struct list_head list;
> +	struct pci_dev *dev;
> +};
> +int pci_reset_endpoints(void)
> +{
> +	struct pci_dev *dev = NULL;
> +	struct pci_dev_reset_entry *pdev_entry, *tmp;
> +	struct pci_bus *subordinate = NULL;
> +	int has_it;
> +
> +	LIST_HEAD(pdev_list);
> +
> +
> +	for_each_pci_dev(dev) {
> +		subordinate = dev->subordinate;
> +		if (!subordinate || list_empty(&subordinate->devices))
> +			continue;
> +
> +		has_it = 0;
> +		list_for_each_entry(pdev_entry, &pdev_list, list) {
> +			if (dev == pdev_entry->dev) {
> +				has_it = 1;
> +				break;
> +			}
> +		}
> +		if (has_it)
> +			continue;
> +
> +		if (__pci_dev_need_reset(dev)) {
> +			pdev_entry = kmalloc(sizeof(*pdev_entry), GFP_KERNEL);
> +			pdev_entry->dev = dev;
> +			list_add(&pdev_entry->list, &pdev_list);
> +		}
> +	}
> +
> +	list_for_each_entry_safe(pdev_entry, tmp, &pdev_list, list) {
> +		pci_try_reset_bus(pdev_entry->dev->subordinate);
> +		kfree(pdev_entry);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_reset_endpoints);
> +
>  static int __init pci_setup(char *str)
>  {
>  	while (str) {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 5be8db4..1cf7207 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1869,4 +1869,10 @@ static inline bool pci_is_dev_assigned(struct pci_dev *pdev)
>  {
>  	return (pdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED) == PCI_DEV_FLAGS_ASSIGNED;
>  }
> +
> +/*
> + * Reset all pci devices by resetting the buses.
> + */
> +int pci_reset_endpoints(void);
> +
>  #endif /* LINUX_PCI_H */
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 2abf9f6..986e8f7 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -36,6 +36,7 @@
>  #include <linux/syscore_ops.h>
>  #include <linux/compiler.h>
>  #include <linux/hugetlb.h>
> +#include <linux/pci.h>
>  
>  #include <asm/page.h>
>  #include <asm/uaccess.h>
> @@ -1474,6 +1475,7 @@ void crash_kexec(struct pt_regs *regs)
>  		if (kexec_crash_image) {
>  			struct pt_regs fixed_regs;
>  
> +			pci_reset_endpoints();
>  			crash_setup_regs(&fixed_regs, regs);
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
