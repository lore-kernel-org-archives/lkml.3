Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbbA0Smy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:42:54 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42405 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550AbbA0Smc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:42:32 -0500
MIME-Version: 1.0
In-Reply-To: <54C7D576.6030502@ti.com>
References: <1422052359-12384-1-git-send-email-m-karicheri2@ti.com>
 <1422052359-12384-5-git-send-email-m-karicheri2@ti.com> <20150123234124.GW29776@google.com>
 <54C6CCF3.7080308@ti.com> <CAErSpo4w0zVCmXk2D2Qk5W3kceS9Wk+=jqHBDwk6HUXWwXdq_Q@mail.gmail.com>
 <54C7D576.6030502@ti.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 27 Jan 2015 12:42:11 -0600
Message-ID: <CAErSpo4Awgqu0ZtoMm0XSZzhnYtXh3xxH2OJMkyth5YDR9GUiA@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] of/pci: add of_pci_dma_configure() update dma configuration
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 12:14 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> On 01/26/2015 06:59 PM, Bjorn Helgaas wrote:
>>
>> On Mon, Jan 26, 2015 at 5:25 PM, Murali Karicheri<m-karicheri2@ti.com>
>> wrote:
>>>
>>> On 01/23/2015 06:41 PM, Bjorn Helgaas wrote:
>>>>
>>>>
>>>> On Fri, Jan 23, 2015 at 05:32:37PM -0500, Murali Karicheri wrote:
>>>>>
>>>>>
>>>>> Add of_pci_dma_configure() to allow updating the dma configuration
>>>>> of the pci device using the configuration from DT of the parent of
>>>>> the root bridge device.
>>>>>
>   -- Cut ---
>
>>>>>
>>>>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>>>>> ---
>>>>>    drivers/of/of_pci.c    |   39
>>>>> +++++++++++++++++++++++++++++++++++++++
>>>>>    include/linux/of_pci.h |   12 ++++++++++++
>>>>>    2 files changed, 51 insertions(+)
>>>>>
>>>>> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
>>>>> index 88471d3..34878c9 100644
>>>>> --- a/drivers/of/of_pci.c
>>>>> +++ b/drivers/of/of_pci.c
>>>>> @@ -2,6 +2,7 @@
>>>>>    #include<linux/export.h>
>>>>>    #include<linux/of.h>
>>>>>    #include<linux/of_address.h>
>>>>> +#include<linux/of_device.h>
>>>>>    #include<linux/of_pci.h>
>>>>>    #include<linux/slab.h>
>>>>>
>>>>> @@ -229,6 +230,44 @@ parse_failed:
>>>>>          return err;
>>>>>    }
>>>>>    EXPORT_SYMBOL_GPL(of_pci_get_host_bridge_resources);
>>>>> +
>>>>> +/**
>>>>> + * of_get_pci_root_bridge_parent - get the OF node of the root
>>>>> bridge's
>>>>> parent
>>>>> + * @dev: ptr to pci_dev struct of the pci device
>>>>> + *
>>>>> + * This function will traverse the bus up to the root bus starting
>>>>> with
>>>>> + * the child and return the OF node ptr to root bridge device's parent
>>>>> device.
>>>>> + */
>>>>> +struct device_node *of_get_pci_root_bridge_parent(struct pci_dev *dev)
>>>>
>>>>
>>>>
>>>> I'm not an OF person, but this interface seems like it might be too
>>>> special-purpose.  Maybe it would be enough to add
>>>> "of_get_pci_root_bridge()", and the caller could do this:
>>>>
>>>>       struct device *bridge = of_get_pci_root_bridge(dev);
>>>>       struct device_node *parent_np = bridge->parent->of_node;
>>>>
>>>> Also, the name "of_get_..." suggests that it increments a refcount, as
>>>> of_get_parent() does.  But you aren't doing anything with the refcount.
>>>>
>>>> But I guess an "of_get_pci_root_bridge()" isn't doing anything
>>>> OF-related,
>>>> so maybe we should just add a "pci_get_host_bridge(struct pci_dev *)"
>>>> to PCI instead.
>>>
>>>
>>>
>>> Bjorn,
>>>
>>> Thanks for the comment.
>>>
>>> I think adding pci_get_host_bridge() is a good idea. There is already
>>> similar function in host-bridge.c. I have added this function re-using
>>> existing function find_pci_root_bus(). See the incremental diff below
>>> after
>>> this change. Does this look good?
>>
>>
>> I like the implementation, but I think either we need to take a
>> reference on the host bridge, or change the name to  something like
>> "pci_find_host_bridge()", because using "_get_" is conventional for
>> functions that acquire a reference.
>>
>> Since host bridges are hot-pluggable, at least in theory, I vote for
>> taking a reference.  Then of course, you'd have to add code to drop
>> the reference when you're finished with it.
>>
> Bjorn,
>
> Thanks. I agree with your suggestion even though the convention is not
> followed fully :) of_pci_get_devfn(), of_get_pci_domain_nr(),
> of_pci_get_host_bridge_resources() are some of those functions not following
> the convention. I plan to change the function as below. Also want to name
> functions as pci_get/put_host_bridge_device() as existing function
> find_pci_host_bridge() is actually returning ptr to struct pci_host_bridge
> vs the new function returning ptr to device. Here are the new functions and
> how they will be used. Please review and respond so that I can avoid a
> re-spin.
>
> in linux/include/pci.h add the prototypes of
> pci_get/put_host_bridge_device().
>
> in drivers/pci/host-bridge.c add two new functions.
>
> struct device *pci_get_host_bridge_device(struct pci_dev *dev)
> {
>         struct pci_bus *root_bus = find_pci_root_bus(dev->bus);
>         struct device *bridge = root_bus->bridge;
>
>         kobject_get(&bridge->kobj);
>         return bridge;
> }

Looks good to me.

> void  pci_put_host_bridge_device(struct pci_dev *dev)
> {
>         struct pci_bus *root_bus = find_pci_root_bus(dev->bus);
>         struct device *bridge = root_bus->bridge;
>
>         kobject_put(&bridge->kobj);
> }

I think I would pass in the "struct device *" here so we don't have to
call find_pci_root_bus() again.

> drivers/of/of_pci.c
>
> void of_pci_dma_configure(struct pci_dev *pci_dev)
> {
>         struct device *dev = &pci_dev->dev;
>         struct device *bridge = pci_get_host_bridge_device(pci_dev);
>
>         of_dma_configure(dev, bridge->parent->of_node);
>         pci_put_host_bridge_device(pci_dev);

Then this would become "pci_put_host_bridge_device(bridge)"

> }
>
> Murali
>
>> Bjorn
>>
>
>>>>>
>>>
>>>
>>> --
>>> Murali Karicheri
>>> Linux Kernel, Texas Instruments
>
>
>
> --
> Murali Karicheri
> Linux Kernel, Texas Instruments
