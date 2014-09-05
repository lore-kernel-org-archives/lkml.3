Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaIEUna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:43:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53761 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaIEUn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:43:28 -0400
Message-ID: <540A206A.6070503@ti.com>
Date: Fri, 5 Sep 2014 16:43:22 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH v2] PCI: keystone: add a pci quirk to limit mrrs
References: <1407527132-3294-1-git-send-email-m-karicheri2@ti.com> <20140905192329.GE8080@google.com> <540A1D54.9030103@ti.com> <CAErSpo7LHFbg-CiWr+UYdy4vuvPjcCyERyTzU_F59An-gW-O4w@mail.gmail.com>
In-Reply-To: <CAErSpo7LHFbg-CiWr+UYdy4vuvPjcCyERyTzU_F59An-gW-O4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 04:40 PM, Bjorn Helgaas wrote:
> On Fri, Sep 5, 2014 at 2:30 PM, Murali Karicheri<m-karicheri2@ti.com>  wrote:
>> On 09/05/2014 03:23 PM, Bjorn Helgaas wrote:
>>>
>>> On Fri, Aug 08, 2014 at 03:45:32PM -0400, Murali Karicheri wrote:
>>>>
>>>> Keystone PCI controller has a limitation that memory read request
>>>> size must not exceed 256 bytes. This is a hardware limitation and
>>>> add a quirk to force this limit on all downstream devices by
>>>> updating mrrs.
>>>>
>>>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>>>> ---
>>>>    -v2: made the quirk happens after tuning
>>>>    -v1: changed printk to indicate PCI bdf
>>>>    This applies on top of the Keystone PCI controller patch series
>>>>    at http://thread.gmane.org/gmane.linux.kernel.pci/33523
>>>>    drivers/pci/host/pci-keystone.c |   40
>>>> +++++++++++++++++++++++++++++++++++++++
>>>>    1 file changed, 40 insertions(+)
>>>>
>>>> diff --git a/drivers/pci/host/pci-keystone.c
>>>> b/drivers/pci/host/pci-keystone.c
>>>> index c1cfaef..a132622 100644
>>>> --- a/drivers/pci/host/pci-keystone.c
>>>> +++ b/drivers/pci/host/pci-keystone.c
>>>> @@ -42,8 +42,48 @@
>>>>    /* DEV_STAT_CTRL */
>>>>    #define PCIE_CAP_BASE         0x70
>>>>
>>>> +/* PCIE controller device IDs */
>>>> +#define PCIE_RC_K2HK           0xb008
>>>> +#define PCIE_RC_K2E            0xb009
>>>> +#define PCIE_RC_K2L            0xb00a
>>>
>>>
>>> A Root Complex doesn't appear in config space as a PCI device, so I think
>>> these are actually Root Port devices, aren't they?
>>
>>
>> Yes.
>>
>>>
>>> I suppose the spec would allow Root Complex Integrated Endpoints, on which
>>> MRRS could also be set, but I think your quirk ignores them because they
>>> would appear on the root bus.  Is ignoring them OK, or would you want to
>>> set MRRS for those as well?
>>
>>
>> How does the Root Complex integrated endpoints are designed? Our PCI can act
>> as a RC or EP and not both at the same time. So I guess this is not
>> applicable.
>
> My guess is that you probably don't have any integrated endpoints and
> hence don't need to worry about MRRS for them.  The PCIe spec (r3.0,
> sec 1.3.2.3) says "A Root Complex Integrated Endpoint is implemented
> on internal logic of Root Complexes that contains [sic] the Root
> Ports."
>
> For example, my laptop has:
>
>    00:03.0 Audio device: Intel Corporation Haswell-ULT HD Audio Controller
>    00:1c.0 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root Port 1
>    00:1c.3 PCI bridge: Intel Corporation Lynx Point-LP PCI Express Root Port 4
>
> the 00:03.0 Audio device is a PCIe device but it is a sibling of the
> Root Ports rather than being downstream from them, i.e., it's an
> Integrated Endpoint that is part of the Root Complex itself.
Ok. Got it. This is not applicable for Keystone PCI RC.

Regards,

Murali
>
>>>> +
>>>>    #define to_keystone_pcie(x)   container_of(x, struct keystone_pcie, pp)
>>>>
>>>> +static void quirk_limit_mrrs(struct pci_dev *dev)
>>>> +{
>>>> +       struct pci_bus *bus = dev->bus;
>>>> +       struct pci_dev *bridge = bus->self;
>>>> +
>>>> +       if (pci_is_root_bus(bus))
>>>> +               return;
>>>> +
>>>> +       /* look for the host bridge */
>>>> +       while (!pci_is_root_bus(bus)) {
>>>> +               bridge = bus->self;
>>>> +               bus = bus->parent;
>>>> +       }
>>>> +
>>>> +       if (bridge) {
>>>> +               u16 id;
>>>> +
>>>> +               /*
>>>> +                * Keystone PCI controller has a h/w limitation of
>>>> +                * 256 bytes maximum read request size. It can't handle
>>>> +                * anything higher than this. So force this limit on
>>>> +                * all downstream devices
>>>> +                */
>>>> +               pci_read_config_word(bridge, PCI_DEVICE_ID,&id);
>>>
>>>
>>> I think you should check the Vendor ID here as well.  Otherwise, there's a
>>> possibility of applying this quirk to devices under a bridge with the same
>>> Device ID but different Vendor ID.
>>>
>>> And I think you should be able to use the bridge->vendor and
>>> bridge->device
>>> fields instead of reading them from config space.  Actually, this might be
>>> a good place to use pci_match_id().
>>
>>
>> Ok.
>>
>>
>>>
>>>> +               if ((id == PCIE_RC_K2HK) || (id == PCIE_RC_K2E) ||
>>>> +                   (id == PCIE_RC_K2L)) {
>>>> +                       if (pcie_get_readrq(dev)>   256) {
>>>> +                               dev_info(&dev->dev, "limiting mrrs to
>>>> 256\n");
>>>> +                               pcie_set_readrq(dev, 256);
>>>> +                       }
>>>> +               }
>>>> +       }
>>>> +}
>>>> +DECLARE_PCI_FIXUP_ENABLE(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_mrrs);
>>>> +
>>>>    static int ks_pcie_establish_link(struct keystone_pcie *ks_pcie)
>>>>    {
>>>>          struct pcie_port *pp =&ks_pcie->pp;
>>>> --
>>>> 1.7.9.5
>>>>
>>

