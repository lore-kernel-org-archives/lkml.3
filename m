Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaEOUFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:05:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51435 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaEOUFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:05:34 -0400
Message-ID: <53751DDF.40304@ti.com>
Date: Thu, 15 May 2014 16:04:47 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware
 core driver
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com> <6048322.x3M3sdDEWO@wuerfel> <5374FD24.8000806@ti.com> <22200719.Jb5jnJylJH@wuerfel> <20140515183919.GC11650@obsidianresearch.com>
In-Reply-To: <20140515183919.GC11650@obsidianresearch.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/2014 2:39 PM, Jason Gunthorpe wrote:
> On Thu, May 15, 2014 at 08:20:13PM +0200, Arnd Bergmann wrote:
>> On Thursday 15 May 2014 13:45:08 Murali Karicheri wrote:
>>>>> +#ifdef CONFIG_PCI_KEYSTONE
>>>>> +/*
>>>>> + * The KeyStone PCIe controller has maximum read request size of 256 bytes.
>>>>> + */
>>>>> +static void quirk_limit_readrequest(struct pci_dev *dev)
>>>>> +{
>>>>> +    int readrq = pcie_get_readrq(dev);
>>>>> +
>>>>> +    if (readrq > 256)
>>>>> +            pcie_set_readrq(dev, 256);
>>>>> +}
>>>>> +DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, quirk_limit_readrequest);
>>>>> +#endif /* CONFIG_PCI_KEYSTONE */
>>>> This doesn't work: you can't just limit do this for all devices just based
>>>> on PCI_KEYSTONE being enabled, you have to check if you are actually using
>>>> this controller.
>>>>
>>>>        Arnd
>>>    I assume, I need to check if PCI controller's vendor ID/ device ID
>>> match with the keystone
>>>    PCI controller's ID and call pcie_set_readrq() for all of the slave
>>> PCI devices and do this fixup.
>>> Is this correct understanding?  If you can point me to an example code
>>> for this that will be
>>> really helpful so that I can avoid re-inventing the wheel.
>> I think it would be best to move the quirk into the keystone pci driver
>> and compare compare the dev->driver pointer of the PCI controller device.
> The PCI core handles setting the maximum read request size already,
> can you figure out why the core code isn't doing what you need and
> correct the root problem?
>
> I'm guessing the values in the root port bridge config space are not
> correct or something like that??
>
> Jason
What you mean by "The PCI core handles setting the maximum read request 
size already"
I see there is function pcie_write_mrrs() in the drivers/pci/probe.c 
that reads the mps
using pcie_get_mps() and then set mrrs to mps. But this function is 
called only from
pcie_bus_configure_set() that is called by pcie_bus_configure_settings()

pcie_bus_configure_settings() is called by

0 pci-common.c pcibios_scan_phb             1676 
pcie_bus_configure_settings(child);
1 pci_gx.c     fixup_read_and_payload_sizes  606 
pcie_bus_configure_settings(child);
2 acpi.c       pci_acpi_scan_root            556 
pcie_bus_configure_settings(child);
3 pcihp_slot.c pci_configure_slot            164 
pcie_bus_configure_settings(dev->bus);

None of them gets called on ARM platform.

What is needed for Keystone PCI is that we need to limit mrrs to 256 
bytes for all
of the downstream devices that talks to PCIe controller. This needs to 
be enforced
through a quirk. Or Is there something missing that Keystone or DW 
driver is not
making use of that reads the mrrs value of the RC and set the same on 
all of the
downstream devices connected to the bus that the controller is connected to?

Murali

