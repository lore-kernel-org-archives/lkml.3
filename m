Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbbATRRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:17:31 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38906 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbbATRR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:17:29 -0500
MIME-Version: 1.0
In-Reply-To: <54BC6799.2040907@linux.intel.com>
References: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com>
	<1420736772-11088-2-git-send-email-marc.zyngier@arm.com>
	<CALRxmdDVUoYNg3QC0LdvKmCz9x4nzE9+TDiV9K9OH=Gxk-Cd9w@mail.gmail.com>
	<54BC6799.2040907@linux.intel.com>
Date: Tue, 20 Jan 2015 11:17:29 -0600
Message-ID: <CALRxmdCRGY2Sw+UyHTp5PP4R=v2301LTqpKq0bCEs08SWsh1bg@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] device core: Introduce per-device MSI domain pointer
From: Stuart Yoder <b08248@gmail.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yijing Wang <wangyijing@huawei.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gerry,

So which direction did you take in your patch set--  a) common,
generic msi_desc, or b)  bus-specific msi_desc like Marc showed
(mybus_msi_desc)?

Thanks,
Stuart

On Sun, Jan 18, 2015 at 8:10 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
>
>
> On 2015/1/16 4:35, Stuart Yoder wrote:
>> On Thu, Jan 8, 2015 at 11:06 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> As MSI-type features are creeping into non-PCI devices, it is
>>> starting to make sense to give our struct device some form of
>>> support for this, by allowing a pointer to an MSI irq domain to
>>> be set/retrieved.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  include/linux/device.h | 20 ++++++++++++++++++++
>>>  1 file changed, 20 insertions(+)
>>>
>>> diff --git a/include/linux/device.h b/include/linux/device.h
>>> index fb50673..ec4cee5 100644
>>> --- a/include/linux/device.h
>>> +++ b/include/linux/device.h
>>> @@ -690,6 +690,7 @@ struct acpi_dev_node {
>>>   *             along with subsystem-level and driver-level callbacks.
>>>   * @pins:      For device pin management.
>>>   *             See Documentation/pinctrl.txt for details.
>>> + * @msi_domain: The generic MSI domain this device is using.
>>>   * @numa_node: NUMA node this device is close to.
>>>   * @dma_mask:  Dma mask (if dma'ble device).
>>>   * @coherent_dma_mask: Like dma_mask, but for alloc_coherent mapping as not all
>>> @@ -750,6 +751,9 @@ struct device {
>>>         struct dev_pm_info      power;
>>>         struct dev_pm_domain    *pm_domain;
>>>
>>> +#ifdef CONFIG_GENERIC_MSI_IRQ_DOMAIN
>>> +       struct irq_domain       *msi_domain; /* MSI domain device uses */
>>> +#endif
>>
>> This is not a comment on this patch specifically, but a question about other
>> MSI specific fields that might be needed in struct device.
>>
>> Currently the generic MSI domain handling has hardcoded assumptions
>> that devices are PCI-- see the for_each_msi_entry() iterator in msi.h:
>>
>>   #define dev_to_msi_list(dev)            (&to_pci_dev((dev))->msi_list)
>>
>>   #define for_each_msi_entry(desc, dev)   \
>>         list_for_each_entry((desc), dev_to_msi_list((dev)), list)
>>
>> One approach would be to move the msi_list out of pci_dev and put
>> it in struct device, so all devices can have an msi_list.
>>
>> The other approach would be to keep msi_list in a bus specific
>> device struct, and then dev_to_msi_list() would need to be
>> implemented as a bus specific callback of some kind.
>>
>> The above hardcoded PCI assumption isn't going to work.   Wanted to
>> see if there is any advice in which direction to go.
> Hi Stuart,
>         I already have some a patch set to go that direction waiting
> send out for review:)
> Thanks!
> Gerry
>
>>
>> Thanks,
>> Stuart Yoder
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
