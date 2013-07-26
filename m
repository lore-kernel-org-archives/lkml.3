Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3GZDBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:01:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18904 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab3GZDBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:01:45 -0400
Message-ID: <51F1E68A.2080703@oracle.com>
Date: Fri, 26 Jul 2013 11:01:30 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>, bhelgaas@google.com,
        Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Subject: Re: [PATCH 2/3] Refactor msi/msix restore code Part2
References: <51EF451A.8050003@oracle.com> <20130724134622.GC2518@phenom.dumpdata.com> <51F0CB10.1070500@oracle.com> <20130725122552.GA23927@konrad-lan.dumpdata.com>
In-Reply-To: <20130725122552.GA23927@konrad-lan.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2013-07-25 20:25, Konrad Rzeszutek Wilk wrote:
> On Thu, Jul 25, 2013 at 02:52:00PM +0800, Zhenzhong Duan wrote:
>> On 2013-07-24 21:46, Konrad Rzeszutek Wilk wrote:
>>> On Wed, Jul 24, 2013 at 11:08:10AM +0800, Zhenzhong Duan wrote:
>>>> xen_initdom_restore_msi_irqs trigger a hypercall to restore addr/data/mask
>>>> in dom0. It's better to do the same for default_restore_msi_irqs in baremetal.
>>>>
>>>> Move restore of mask in default_restore_msi_irqs, this could avoid mask
>>>> restored twice in dom0, once in hypercall, the other in kernel.
>>> Why not remove the hypercall then?
>> If removed, msi entry couldn't be restored, such as
>> pci_reset_function who will reset pci registers.
> I did not read your email first time correctly. You are saying
> that we restore it twice in the host kernel (aka dom0), once in the
> hypervisor (b/c the guest tries to do MSI-X write and it ends up in
> the hypervisor), and then we also do it in the guest kernel?
Non business of guest kernel, this patch is fixing driver load issue in 
dom0.
Driver qlcnic called pci_reset_function during init. The call path:
pci_reset_function->pci_restore_state->__pci_restore_msix_state->arch_restore_msi_irqs->
xen_initdom_restore_msi_irqs->PHYSDEVOP_restore_msi hypercall

First mask restore is in 
xen_initdom_restore_msi_irqs->PHYSDEVOP_restore_msi hypercall
Second restore is __pci_restore_msix_state->msix_mask_irq(entry, 
entry->masked)

Mask bits are under full control of xen, and the entry->masked in dom0 
kernel is invalid.
We restore an invalid value to mask register could mask the msix interrupt.
>
> That is a lot of duplicate calls.
>>> Or alter the function to detect
>>> whether the restore of the mask has occurred?
>> Then we need to add the check for dom0 only.
> I am not sure I completly follow this. Is the reason for the lost of
> interrupt b/c one of those four MSI-X writes ends up masking and the
> subsequent writes end up with invalid data?
The first restore in hypercall is needed, and second restore should be 
removed for dom0
But baremetal need that restore, so I move it in 
default_restore_msi_irqs which is the func for baremetal.
>
>>>> Without that, qlcnic driver calling pci_reset_function will lost interrupt
>>>> in dom0.
> But if you pass said PCI device to a guest there is no need for the
> interrupts to go to the host (dom0). They should go to the hypervisor
> which will deliever them to the guest.
>
> Is that what you meant by 'in dom0' ?
>
>>>> Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
>>>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>>>> ---
>>>>   drivers/pci/msi.c |   17 ++++++++++++++---
>>>>   1 files changed, 14 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>>>> index 87223ae..922fb49 100644
>>>> --- a/drivers/pci/msi.c
>>>> +++ b/drivers/pci/msi.c
>>>> @@ -216,6 +216,8 @@ void unmask_msi_irq(struct irq_data *data)
>>>>   #ifdef HAVE_DEFAULT_MSI_RESTORE_IRQS
>>>>   void default_restore_msi_irqs(struct pci_dev *dev, int irq)
>>>>   {
>>>> +	int pos;
>>>> +	u16 control;
>>>>   	struct msi_desc *entry;
>>>>   	entry = NULL;
>>>> @@ -228,8 +230,19 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq)
>>>>   		entry = irq_get_msi_desc(irq);
>>>>   	}
>>>> -	if (entry)
>>>> +	if (entry) {
>>>>   		write_msi_msg(irq, &entry->msg);
>>>> +		if (dev->msix_enabled) {
>>>> +			msix_mask_irq(entry, entry->masked);
>>>> +			readl(entry->mask_base);
>>>> +		} else {
>>>> +			pos = entry->msi_attrib.pos;
>>>> +			pci_read_config_word(dev, pos + PCI_MSI_FLAGS,
>>>> +					     &control);
>>>> +			msi_mask_irq(entry, msi_capable_mask(control),
>>>> +				     entry->masked);
>>>> +		}
>>>> +	}
>>>>   }
>>>>   #endif
>>>> @@ -406,7 +419,6 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
>>>>   	arch_restore_msi_irqs(dev, dev->irq);
>>>>   	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
>>>> -	msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
>>> Before this patch we had:
>>>
>>> 	write_msi_msg(..)
>>> 	pci_read_config_work(PCI_MSI_FLAGS, &control)
>>> 	pci_write_config_dword(~msi_capable_mask(control) | entry->masked)
>>> 	control &= ~_PCI_MSI_FLAGS_QSIZE;
>>> 	control |= ...
>>> 	pci_write_config_dword(PCI_MSI_FLAGS, control)
>>>
>>> while with this you have now:
>>>
>>> 	write_msi_msg(..)
>>> 	pci_read_config_work(PCI_MSI_FLAGS, &_control)
>>> 	pci_write_config_dword(~msi_capable_mask(_control) | entry->masked)
>>> --> 	pci_read_config_work(PCI_MSI_FLAGS, &control)
>>> 	control &= ~_PCI_MSI_FLAGS_QSIZE;
>>> 	control |= ...
>>> 	pci_write_config_dword(PCI_MSI_FLAGS, control)
>>>
>>> see the problem? The 'control' value in __pci_restore_msi_state reads the
>>> value _after_ it has been masked (which is now done in default_restore_msi_irqs).
>>>
>>> Wouldn't that cause problems?
>>>
>> pci_write_config_dword(~msi_capable_mask(_control) | entry->masked) restore per vector
>> msi mask bits based on the support of PCI_MSI_FLAGS_MASKBIT. This is different from the
>> global mask bit in PCI_MSI_FLAGS.
> So I think you are saying that it won't cause problems?
Yes
