Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaCCSNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:13:25 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:50790 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaCCSNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:13:23 -0500
MIME-Version: 1.0
In-Reply-To: <20140303174325.GB31062@obsidianresearch.com>
References: <1393854036-5244-1-git-send-email-sthokal@xilinx.com>
	<20140303174325.GB31062@obsidianresearch.com>
Date: Mon, 3 Mar 2014 23:43:21 +0530
X-Google-Sender-Auth: 31gsLtiRfDA0mjhwiC6V8BGfW0w
Message-ID: <CA+mB=1Lz6Wux-fZ-tECpn3QnwXa4pAZxpSbNng9KHbs_ACnzXQ@mail.gmail.com>
Subject: Re: [PATCH v2] pcie: Add Xilinx PCIe Host Bridge IP driver
From: Srikanth Thokala <sthokal@xilinx.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Srikanth Thokala <sthokal@xilinx.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 11:13 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Mon, Mar 03, 2014 at 07:10:36PM +0530, Srikanth Thokala wrote:
>
>> +Required properties:
>> +- #address-cells: Address representation for root ports, set to <3>
>> +- #size-cells: Size representation for root ports, set to <2>
>> +- compatible: Should contain "xlnx,axi-pcie-host-1.00.a"
>> +- reg: Should contain AXI PCIe registers location and length
>> +- interrupts: Should contain AXI PCIe interrupt
>> +- ranges: ranges for the PCI memory regions
>> +     Please refer to the standard PCI bus binding document for a more
>> +     detailed explanation
>> +
>> +Example:
>> +++++++++
>> +
>> +     pci_express: axi-pcie@50000000 {
>> +             #address-cells = <3>;
>> +             #size-cells = <2>;
>> +             compatible = "xlnx,axi-pcie-host-1.00.a";
>> +             reg = < 0x50000000 0x10000000 >;
>> +             interrupts = < 0 52 4 >;
>> +             ranges = < 0x02000000 0 0x60000000 0x60000000 0 0x10000000 >;
>> +     };
>
> That is much shorter, more notes:
>  - It looks like the driver (HW?) has no support for IO space?

Yes, there is no support for IO space.

>  - How are INTA/B/C/D handled? Typically I'd like to see an
>    interrupt-mapping block describing them.

                                  /
                                 /
CPU   <--- PCIe IP  <---



>
>    There are a few options here, if the HW can decode A/B/C/D then
>    it probably needs another irq_domain for INTx, and have the IRQ
>    handler decode like it does for MSI.
> - The stanza needs a
>     device_type = "pci";
>
>> +     for (i = 0; i < port->mem_resno; i++)
>> +             pci_add_resource_offset(&sys->resources, &port->mem[i],
>> +                                     sys->mem_offset);
>
> The sys->mem_offset is probably wrong, please review Arnd's comments
> on the recent threads with Will and Liviu regarding how this is
> supposed to work with DT.
>
> You may want to work with Liviu to use his patch set which provides
> more generic support. Also, the driver needs to put every one of these
> ports in a PCI domain, Liviu is working on generic support for that
> too.

Sure, I will check and come back to you.

>
>> +static struct pci_bus __init *xilinx_pcie_scan_bus(int nr,
>> +                             struct pci_sys_data *sys)
>> +{
>> +     struct xilinx_pcie_port *port = sys_to_pcie(sys);
>> +     struct pci_bus *bus;
>> +
>> +     if (port) {
>> +             port->root_busno = sys->busnr;
>> +             bus = pci_scan_root_bus(NULL, sys->busnr, &xilinx_pcie_ops,
>> +                                     sys, &sys->resources);
>
> The NULL is probably wrong, please review the recent thread with Lucas
> and Jingoo 'PCI irq mapping fixes and cleanups'

Ok.

>
>> +static int xilinx_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
>> +{
>> +     struct xilinx_pcie_port *port = sys_to_pcie(dev->bus->sysdata);
>> +
>> +     if (!port)
>> +             return -EINVAL;
>> +
>> +     return port->irq;
>> +}
>
> It is preferred to use DT mechanisms via of_irq_parse_and_map_pci
> (interrupt-mapping, etc) to define the slot IRQ, drivers should not
> provide a map_irq unless absolutely necessary.

Ok.

>
>> +     /* make sure it is root port before touching header */
>> +     pcie_write(port, PCI_COMMAND_MASTER, PCI_COMMAND);
>
> Bit of a confusing comment

I will correct it.

>
>> +     /* Check if PCIe link is up? */
>> +     port->link_up = xilinx_pcie_is_link_up(port);
>> +     if (!port->link_up)
>> +             dev_info(port->dev, "PCIe Link is DOWN\n");
>> +     else
>> +             dev_info(port->dev, "PCIe Link is UP\n");
>
> Don't forget to think about hot plug

Ok, you mean using the 'rescan' correct?

>
>> +     /* Register Interrupt Handler */
>> +     err = request_irq(port->irq, xilinx_pcie_intr_handler,
>> +                             IRQF_SHARED, "xilinx-pcie", port);
>
> Use devm? This is leaking on error cases.
>
> Review other resources too...
>
>> +     /* Request and map I/O memory */
>> +     io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     port->phys_reg_base = io->start;
>> +     port->reg_size = resource_size(io);
>
> Here it uses the platform resource..
>
>> +     /* Map the IRQ */
>> +     port->irq = irq_of_parse_and_map(node, 0);
>
> .. And here it doesn't, probably should be consistent and just use the
> platform resources.

Ok, I will correct it.

Srikanth

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
