Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaG3HUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:20:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57903 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbaG3HUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:20:49 -0400
Message-ID: <53D89CA1.7000501@huawei.com>
Date: Wed, 30 Jul 2014 15:20:01 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, <Paul.Mundt@huawei.com>,
        Marc Zyngier <marc.zyngier@arm.com>, <linux-pci@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        <virtualization@lists.linux-foundation.org>,
        "Xinwei Hu" <huxinwei@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Wuyun <wuyun.wu@huawei.com>
Subject: Re: [RFC PATCH 00/11] Refactor MSI to support Non-PCI device
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com> <1748052.OMBQJiOLYT@wuerfel> <53D85C2E.3060205@huawei.com> <53D89502.60506@linux.intel.com>
In-Reply-To: <53D89502.60506@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/30 14:47, Jiang Liu wrote:
> 
> 
> On 2014/7/30 10:45, Yijing Wang wrote:
>> On 2014/7/29 22:08, Arnd Bergmann wrote:
>>> On Saturday 26 July 2014 11:08:37 Yijing Wang wrote:
>>>>         The series is a draft of generic MSI driver that supports PCI
>>>> and Non-PCI device which have MSI capability. If you're not interested
>>>> it, sorry for the noise.
>>>
>>> I've finally managed to take some time to look at the series. Overall,
>>> the concept looks good to me, and the patches look very well implemented.
>>>
>>> The part I'm not sure about is the interface we want to end up with
>>> at the end of the series. More on that below
>>
>> Hi Arnd,
>>    Thanks for your review and comments very much!
>> Please refer the inline comments.
>>
>>>
>>>> The series is based on Linux-3.16-rc1.
>>>>
>>>> MSI was introduced in PCI Spec 2.2. Currently, kernel MSI 
>>>> driver codes are bonding with PCI device. Because MSI has a lot
>>>> advantages in design. More and more non-PCI devices want to
>>>> use MSI as their default interrupt. The existing MSI device
>>>> include HPET. HPET driver provide its own MSI code to initialize
>>>> and process MSI interrupts. In the latest GIC v3 spec, legacy device
>>>> can deliver MSI by the help of a relay device named consolidator.
>>>> Consolidator can translate the legacy interrupts connected to it
>>>> to MSI/MSI-X. And new non-PCI device will be designed to 
>>>> support MSI in future. So make the MSI driver code be generic will 
>>>> help the non-PCI device use MSI more simply.
>>>>
>>>> The new data struct for generic MSI driver.
>>>> struct msi_irqs {
>>>>         u8 msi_enabled:1; /* Enable flag */
>>>>         u8 msix_enabled:1;
>>>>         struct list_head msi_list; /* MSI desc list */
>>>>         void *data;     /* help to find the MSI device */
>>>>         struct msi_ops *ops; /* MSI device specific hook */
>>>> };
>>>> struct msi_irqs is used to manage MSI related informations. Every device supports
>>>> MSI should contain this data struct and allocate it.
>>>
>>> I think you should have a stronger association with the 'struct
>>> device' here. Can you replace the 'void *data' with 'struct device *dev'?
>>
>> Actually, I used the struct device *dev in my first draft, finally, I replaced
>> it with void *data, because some MSI devices don't have a struct device *dev,
>> like the existing hpet device, dmar msi device, and OF device, like the ARM consolidator.
>>
>> Of course, we can make the MSI devices have their own struct device, and register to
>> device tree, eg, add a class device named MSI_DEV. But I'm not sure whether it is appropriate.
>>
>>>
>>> The other part I'm not completely sure about is how you want to
>>> have MSIs map into normal IRQ descriptors. At the moment, all
>>> MSI users are based on IRQ numbers, but this has known scalability problems.
>>
>> Hmmm, I still use the IRQ number to map the MSIs to IRQ description.
>> I'm sorry, I don't understand you meaning.
>> What are the scalability problems you mentioned ?
> We have soft limitation of nr_irqs or hard limitation NR_IRQS,
> we couldn't allocate as much irq number as we need in some cases,
> such as to support MSI-x.

Oh, yes, this is a potential issue. Gerry, thanks for you explanation. :)

> 
>> For device drivers, they always process interrupt in two steps.
>> If irq is the legacy interrupt, drivers will first
>> use the irq_of_parse_and_map() or pci_enable_device() to parse and get the IRQ number.
>> Then drivers will call the request_irq() to register the interrupt handler.
>> If irq is MSIs, first call pci_enable_msi/x() to get the IRQ number and then call
>> request_irq() to register interrupt handler.
>>
>>> I wonder if we can do the interface in a way that
>>> hides the interrupt number from generic device drivers and just
>>> passes a 'struct irq_desc'. Note that there are long-term plans to
>>> get rid of IRQ numbers entirely, but those plans have existed for
>>> a long time already without anybody seriously addressing the device
>>> driver interfaces so far, so it might never really happen.
>>>
>>
>> Maybe this is a huge work, now hundreds drivers use the IRQ number, so maybe we can consider
>> this in a separate title.
>>
>>>> struct msi_ops {
>>>>         struct msi_desc *(*msi_setup_entry)(struct msi_irqs *msi, struct msi_desc *entry);
>>>>         int msix_setup_entries(struct msi_irqs *msi, struct msix_entry *entries);
>>>>         u32 (*msi_mask_irq)(struct msi_desc *desc, u32 mask, u32 flag);
>>>>         u32 (*msix_mask_irq)(struct msi_desc *desc, u32 flag);
>>>>         void (*msi_read_message)(struct msi_desc *desc, struct msi_msg *msg);
>>>>         void (*msi_write_message)(struct msi_desc *desc, struct msi_msg *msg);
>>>>         void (*msi_set_intx)(struct msi_irqs *msi, int enable);
>>>> };
>>>> struct msi_ops provides several hook functions, generic MSI driver will call
>>>> the hook functions to access device specific registers. PCI devices will share
>>>> the same msi_ops, because they have the same way to access MSI hardware registers.
>>>>
>>>> Generic MSI layer export msi_capability_init() and msix_capability_init() functions
>>>> to drivers. msi/x_capability_init() will initialize MSI capability data struct msi_desc
>>>> and alloc the irq, then write the msi address/data value to hardware registers.
>>>>
>>>> This series only did compile test, we will test it in x86 and arm platform later.
>>>
>>> For the generic drivers, I don't see much point in differentiating between
>>> MSI and MSI-X, as I believe the difference is something internal to the PCI
>>> implementation.
>>
>> Yes, we can integrate them, and use a generic ops, add a type in hook function to
>> differentiate them.
>>
>>>
>>> With the other operations, I think they should all take a 'struct device *'
>>> as the first argument for convenience and consistency. I don't think you actually
>>> need msi_read_message(), and we could avoid msi_write_message() by doing it
>>> the other way round.
>>>
>>
>> There only two functions use the read_msi_msg(), because every msi_desc has
>> a struct msi_msg, and it caches the msi address and data. I will consider to
>> retrieve the msg from cached msi_msg, then we can avoid the msi_read_message().
>> But msi_write_message() maybe necessary, some xxx_set_affinity() functions and
>> restore functions need the msi_write_message() to rewrite the address and data.
>>
>>> What I'd envision as the API from the device driver perspective is something
>>> as simple like this:
>>>
>>> struct msi_desc *msi_request(struct msi_chip *chip, irq_handler_t handler,
>>> 			unsigned long flags, const char *name, struct device *dev);
>>>
>>> which would get an msi descriptor that is valid for this device (dev)
>>> connected to a particular msi_chip, and associate a handler function
>>> with it. The device driver can call that function and retrieve the
>>> address/message pair from the msi_desc in order to store it in its own
>>> device specific registers. The request_irq() can be handled internally
>>> to msi_request().
>>
>> This is a huge change for device drivers, and some device drivers don't know which msi_chip
>> their MSI irq deliver to. I'm reworking the msi_chip, and try to use msi_chip to eliminate
>> all arch_msi_xxx() under every arch in kernel. And the important point is how to create the
>> binding for the MSI device to the target msi_chip.
>>
>> For PCI device, some arm platform already bound the msi_chip to the pci hostbridge, then all
>> pci devices under the pci hostbridge deliver their MSI irqs to the target msi_chip.
>> And other platform create the binding in DTS file, then the MSI device can find their msi_chip
>> by device_node.
>> I don't know whether there are other situations, we should provide a generic interface that
>> every MSI device under every platform can use it to find its msi_chip exactly.
>>
>>
>> Thanks!
>> Yijing.
>>
>>>
>>> .
>>>
>>
>>
> 
> .
> 


-- 
Thanks!
Yijing

