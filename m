Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbbAPTKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:10:38 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36575 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbbAPTKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:10:37 -0500
Message-ID: <54B9621E.5080209@arm.com>
Date: Fri, 16 Jan 2015 19:10:22 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Stuart Yoder <b08248@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v2 1/8] device core: Introduce per-device MSI domain pointer
References: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com>	<1420736772-11088-2-git-send-email-marc.zyngier@arm.com> <CALRxmdDVUoYNg3QC0LdvKmCz9x4nzE9+TDiV9K9OH=Gxk-Cd9w@mail.gmail.com>
In-Reply-To: <CALRxmdDVUoYNg3QC0LdvKmCz9x4nzE9+TDiV9K9OH=Gxk-Cd9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stuart,

On 15/01/15 20:35, Stuart Yoder wrote:
> On Thu, Jan 8, 2015 at 11:06 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> As MSI-type features are creeping into non-PCI devices, it is
>> starting to make sense to give our struct device some form of
>> support for this, by allowing a pointer to an MSI irq domain to
>> be set/retrieved.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  include/linux/device.h | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/include/linux/device.h b/include/linux/device.h
>> index fb50673..ec4cee5 100644
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -690,6 +690,7 @@ struct acpi_dev_node {
>>   *             along with subsystem-level and driver-level callbacks.
>>   * @pins:      For device pin management.
>>   *             See Documentation/pinctrl.txt for details.
>> + * @msi_domain: The generic MSI domain this device is using.
>>   * @numa_node: NUMA node this device is close to.
>>   * @dma_mask:  Dma mask (if dma'ble device).
>>   * @coherent_dma_mask: Like dma_mask, but for alloc_coherent mapping as not all
>> @@ -750,6 +751,9 @@ struct device {
>>         struct dev_pm_info      power;
>>         struct dev_pm_domain    *pm_domain;
>>
>> +#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
>> +       struct irq_domain       *msi_domain; /* MSI domain device uses */
>> +#endif
> 
> This is not a comment on this patch specifically, but a question about other
> MSI specific fields that might be needed in struct device.
> 
> Currently the generic MSI domain handling has hardcoded assumptions
> that devices are PCI-- see the for_each_msi_entry() iterator in msi.h:
> 
>   #define dev_to_msi_list(dev)            (&to_pci_dev((dev))->msi_list)
> 
>   #define for_each_msi_entry(desc, dev)   \
>         list_for_each_entry((desc), dev_to_msi_list((dev)), list)
> 
> One approach would be to move the msi_list out of pci_dev and put
> it in struct device, so all devices can have an msi_list.
> 
> The other approach would be to keep msi_list in a bus specific
> device struct, and then dev_to_msi_list() would need to be
> implemented as a bus specific callback of some kind.
> 
> The above hardcoded PCI assumption isn't going to work.   Wanted to
> see if there is any advice in which direction to go.

The question is: can we define a generic msi_desc? If yes, then your
first proposal make sense. If not, then it is the second one.

My hunch is that we'll have to move to a model that would look like this:

struct mybus_msi_desc {
	struct msi_desc desc;
	struct mybus_stuff stuff;
};

and move the PCI-specific stuff out of msi_desc.

Thoughts?

	M.
-- 
Jazz is not dead. It just smells funny...
