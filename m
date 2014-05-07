Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaEGLvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 07:51:18 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35848 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaEGLvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 07:51:16 -0400
MIME-Version: 1.0
In-Reply-To: <201404301734.14478.arnd@arndb.de>
References: <1397561911-11647-1-git-send-email-sthokal@xilinx.com>
	<201404301734.14478.arnd@arndb.de>
Date: Wed, 7 May 2014 17:21:13 +0530
X-Google-Sender-Auth: Z5tjabTU8bk1APtH8BrNONlLjys
Message-ID: <CA+mB=1K_AU5cLsW0J9OhVXmpvc+nYSZwpS5iyNXVTFpibfHq6g@mail.gmail.com>
Subject: Re: [PATCH v3] pcie: Add Xilinx PCIe Host Bridge IP driver
From: Srikanth Thokala <sthokal@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Srikanth Thokala <sthokal@xilinx.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 9:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 15 April 2014, Srikanth Thokala wrote:
>> +Required properties:
>> +- #address-cells: Address representation for root ports, set to <3>
>> +- #size-cells: Size representation for root ports, set to <2>
>> +- #interrupt-cells: specifies the number of cells needed to encode an
>> +     interrupt source. The value must be 1.
>> +- compatible: Should contain "xlnx,axi-pcie-host-1.00.a"
>> +- reg: Should contain AXI PCIe registers location and length
>> +- device_type: must be "pci"
>> +- interrupts: Should contain AXI PCIe interrupt
>> +- interrupt-map-mask,
>> +  interrupt-map: standard PCI properties to define the mapping of the
>> +     PCI interface to interrupt numbers.
>> +- ranges: ranges for the PCI memory regions (I/O space region is noti
>
> typo: noti -> not

Ok, will fix.

>
>> +     supported by hardware)
>> +     Please refer to the standard PCI bus binding document for a more
>> +     detailed explanation
>> +
>> +Optional properties:
>> +- bus-range: PCI bus numbers covered
>> +
>> +Interrupt controller child node
>> ++++++++++++++++++++++++++++++++
>> +Required properties:
>> +- interrupt-controller: identifies the node as an interrupt controller
>> +- #address-cells: specifies the number of cells needed to encode an
>> +     address. The value must be 0.
>> +- #interrupt-cells: specifies the number of cells needed to encode an
>> +     interrupt source. The value must be 1.
>> +
>> +NOTE:
>> +The core provides a single interrupt for both INTx/MSI messages. So,
>> +created a interrupt controller node to support 'interrupt-map' DT
>> +functionality.  The driver will create an IRQ domain for this map, decode
>> +the four INTx interrupts in ISR and route them to this domain.
>
> How does this work if the pci core is combined with a GIC version that
> also has MSI support. Presumably you'd want to use that for performance
> reason rather than the integrated MSI chip.
>
> Shouldn't there be a way to pick between the two?

I will check and come back to you on this.

>
>> +/**
>> + * xilinx_pcie_get_config_base - Get configuration base
>> + * @bus: Bus structure of current bus
>> + * @devfn: Device/function
>> + * @where: Offset from base
>> + *
>> + * Return: Base address of the configuration space needed to be
>> + *      accessed.
>> + */
>> +static void __iomem *xilinx_pcie_get_config_base(struct pci_bus *bus,
>> +                                              unsigned int devfn,
>> +                                              int where)
>> +{
>> +     struct xilinx_pcie_port *port = sys_to_pcie(bus->sysdata);
>> +     int relbus;
>> +
>> +     relbus = (bus->number << ECAM_BUS_NUM_SHIFT) |
>> +              (devfn << ECAM_DEV_NUM_SHIFT);
>> +
>> +     return port->reg_base + relbus + where;
>> +}
>
> Does this mean you have an ECAM-compliant config space? Nice!
>
> Would it be possible to split the config space access out into
> a separate file? It would be nice to share that with the generic
> ECAM driver that Will Deacon has sent.

Yes, it should be possible.  Is it ok, if I work on top of this driver?

>
>> +
>> +     msg.address_hi = 0;
>> +     msg.address_lo = virt_to_phys((void *)port->msg_addr);
>> +     msg.data = irq;
>> +
>> +     write_msi_msg(irq, &msg);
>
> It seems strange to pass the msg_addr as an integer referring to
> a virtual address. I'd suggest using phys_addr_t for the type
> and converting it at the point the page gets allocated, and then
> always assigning both the high and low part here. You'll need
> that anyway for 64-bit operation.

Ok, I will fix it. Thanks.

>
>> +/**
>> + * xilinx_pcie_enable_msi - Enable MSI support
>> + * @port: PCIe port information
>> + */
>> +static void xilinx_pcie_enable_msi(struct xilinx_pcie_port *port)
>> +{
>> +     port->msg_addr = __get_free_pages(GFP_KERNEL, 0);
>> +
>> +     pcie_write(port, 0x0, XILINX_PCIE_REG_MSIBASE1);
>> +     pcie_write(port, virt_to_phys((void *)port->msg_addr),
>> +                XILINX_PCIE_REG_MSIBASE2);
>> +}
>
> here too.
>
> As a general comment about the MSI implementation, I wonder if this is actually
> generic enough to be shared with other host controllers. It could be moved
> into a separate file like the config space access in that case.

I feel the MSI implementation is not generic by looking into the other
host controllers,
it is more specific to the hardware.  Correct me, if am wrong.

>
>> +/**
>> + * xilinx_pcie_init_irq_domain - Initialize IRQ domain
>> + * @port: PCIe port information
>> + *
>> + * Return: '0' on success and error value on failure
>> + */
>> +static int xilinx_pcie_init_irq_domain(struct xilinx_pcie_port *port)
>> +{
>> +     struct device *dev = port->dev;
>> +     struct device_node *node = dev->of_node;
>> +
>> +     if (IS_ENABLED(CONFIG_PCI_MSI)) {
>> +             /* Setup MSI */
>> +             int i;
>> +
>> +             port->irq_domain = irq_domain_add_linear(node,
>> +                                                      XILINX_NUM_MSI_IRQS,
>> +                                                      &msi_domain_ops,
>> +                                                      &xilinx_pcie_msi_chip);
>> +             if (!port->irq_domain) {
>> +                     dev_err(dev, "Failed to get a MSI IRQ domain\n");
>> +                     return PTR_ERR(port->irq_domain);
>> +             }
>> +
>> +             for (i = 0; i < XILINX_NUM_MSI_IRQS; i++)
>> +                     irq_create_mapping(port->irq_domain, i);
>
> I'm still not that familiar with the irqdomain code, but shouldn't you
> do the irq_create_mapping() in xilinx_pcie_assign_msi()?
>
> It seems wasteful to create all 128 mappings upfront.

Ok, I agree with you.  I will fix it.

>
>> +/**
>> + * xilinx_pcie_setup - Setup memory resources
>> + * @nr: Bus number
>> + * @sys: Per controller structure
>> + *
>> + * Return: '1' on success and error value on failure
>> + */
>> +static int xilinx_pcie_setup(int nr, struct pci_sys_data *sys)
>> +{
>
> I think if you move most of the code from this function into the probe()
> function, it will be easier later to add arm64 support, and you can handle
> errors better.
>
> AFAICT, the only thing you need here is to list_move() the resources
> from the xilinx_pcie_port to sys->resources. Ideally, the entire range
> parsing can go away soon, once we have generic infrastructure for that.

Sure.  I will do.

>
>
>> +     /* Register the device */
>> +     pci_common_init_dev(dev, &hw);
>> +
>> +     platform_set_drvdata(pdev, port);
>
> Don't you have to do the platform_set_drvdata() before pci_common_init_dev()?

It should be fine, as I don't see any dependencies.

Srikanth

>
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
