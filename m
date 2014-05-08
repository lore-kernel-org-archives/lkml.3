Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaEHN23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:28:29 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:58373 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbaEHN21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:28:27 -0400
MIME-Version: 1.0
In-Reply-To: <4288313.uDFYZQS3W7@wuerfel>
References: <1397561911-11647-1-git-send-email-sthokal@xilinx.com>
	<201404301734.14478.arnd@arndb.de>
	<CA+mB=1K_AU5cLsW0J9OhVXmpvc+nYSZwpS5iyNXVTFpibfHq6g@mail.gmail.com>
	<4288313.uDFYZQS3W7@wuerfel>
Date: Thu, 8 May 2014 18:58:25 +0530
X-Google-Sender-Auth: qPIvA5upcvHK402pIwqihhXN424
Message-ID: <CA+mB=1LiwKEZgOF7wUMfhpNCv2+n00QLibjznvP_FuZ6eTb3=g@mail.gmail.com>
Subject: Re: [PATCH v3] pcie: Add Xilinx PCIe Host Bridge IP driver
From: Srikanth Thokala <sthokal@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Srikanth Thokala <sthokal@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, will.deacon@arm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 8:05 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 07 May 2014 17:21:13 Srikanth Thokala wrote:
>> On Wed, Apr 30, 2014 at 9:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Tuesday 15 April 2014, Srikanth Thokala wrote:
>> >> +/**
>> >> + * xilinx_pcie_get_config_base - Get configuration base
>> >> + * @bus: Bus structure of current bus
>> >> + * @devfn: Device/function
>> >> + * @where: Offset from base
>> >> + *
>> >> + * Return: Base address of the configuration space needed to be
>> >> + *      accessed.
>> >> + */
>> >> +static void __iomem *xilinx_pcie_get_config_base(struct pci_bus *bus,
>> >> +                                              unsigned int devfn,
>> >> +                                              int where)
>> >> +{
>> >> +     struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
>> >> +     int relbus;
>> >> +
>> >> +     relbus = (bus->number << ECAM_BUS_NUM_SHIFT) |
>> >> +              (devfn << ECAM_DEV_NUM_SHIFT);
>> >> +
>> >> +     return port->reg_base + relbus + where;
>> >> +}
>> >
>> > Does this mean you have an ECAM-compliant config space? Nice!
>> >
>> > Would it be possible to split the config space access out into
>> > a separate file? It would be nice to share that with the generic
>> > ECAM driver that Will Deacon has sent.
>>
>> Yes, it should be possible.  Is it ok, if I work on top of this driver?
>
> Do you mean as a follow-on patch? My feeling is that since we are trying
> to merge both for 3.16, it would be good to get it done right away if
> it doesn't cause too much extra work.

Sure, I will work with Will and let you know.

>
>> >> +/**
>> >> + * xilinx_pcie_enable_msi - Enable MSI support
>> >> + * @port: PCIe port information
>> >> + */
>> >> +static void xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)
>> >> +{
>> >> +     port->msg_addr = __get_free_pages(GFP_KERNEL, 0);
>> >> +
>> >> +     pcie_write(port, 0x0, XILINX_PCIE_REG_MSIBASE1);
>> >> +     pcie_write(port, virt_to_phys((void *)port->msg_addr),
>> >> +                XILINX_PCIE_REG_MSIBASE2);
>> >> +}
>> >
>> > As a general comment about the MSI implementation, I wonder if this is actually
>> > generic enough to be shared with other host controllers. It could be moved
>> > into a separate file like the config space access in that case.
>>
>> I feel the MSI implementation is not generic by looking into the other
>> host controllers,
>> it is more specific to the hardware.  Correct me, if am wrong.
>
> The other host controllers are certainly incompatible, but this one looks
> like it could be used on other controllers easily.
>
> Splitting it out would also make it easier to use another MSI implementation
> like the one in the GIC.

I need to look into this and I will come back to you.

>
>
>> >> +     /* Register the device */
>> >> +     pci_common_init_dev(dev, &hw);
>> >> +
>> >> +     platform_set_drvdata(pdev, port);
>> >
>> > Don't you have to do the platform_set_drvdata() before pci_common_init_dev()?
>>
>> It should be fine, as I don't see any dependencies.
>
> Ah, it's only used in the remove function. It looks correct then, but I think
> it would be better to set it first anyway, in case another function starts using
> the drvdata later and that function may get called by the PCI initialization.

Ok.

Srikanth

>
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
