Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaKLHJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 02:09:04 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:54964 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaKLHJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 02:09:02 -0500
MIME-Version: 1.0
In-Reply-To: <CA+mB=1LEEtPCixB9Ej74L03yPPH7D6YvfpkZyJgsHCm97-GvKg@mail.gmail.com>
References: <1415733454-24322-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1415733454-24322-3-git-send-email-suravee.suthikulpanit@amd.com>
	<CA+mB=1LEEtPCixB9Ej74L03yPPH7D6YvfpkZyJgsHCm97-GvKg@mail.gmail.com>
Date: Wed, 12 Nov 2014 12:39:00 +0530
Message-ID: <CA+mB=1LKghLd9CuyLgDE9WGG5+VrUJF8r4DEbR7CiZojjoRdvQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] PCI: generic: Add msi_parent DT binding
From: Srikanth Thokala <sriku.linux@gmail.com>
To: suravee.suthikulpanit@amd.com
Cc: Bjorn Helgaas <bhelgaas@google.com>, liviu.dudau@arm.com,
        lorenzo.pieralisi@arm.com, will.deacon@arm.com,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 12, 2014 at 12:26 PM, Srikanth Thokala
<sriku.linux@gmail.com> wrote:
> Hi,
>
> On Wed, Nov 12, 2014 at 12:47 AM,  <suravee.suthikulpanit@amd.com> wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> This patch introduces a new DT binding, msi-parent, which can
>> be used to specify MSI-parent phandle for a particular PCI
>> generic host controller.
>>
>> Also, it implements and registers set_msi_parent callback.
>>
>> Cc: Bjorn Helgass <bhelgaas@google.com>
>> Cc: Liviu Dudau <liviu.dudau@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>> ---
>>  Documentation/devicetree/bindings/pci/host-generic-pci.txt |  3 +++
>>  drivers/pci/host/pci-host-generic.c                        | 13 +++++++++++++
>>  2 files changed, 16 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/pci/host-generic-pci.txt b/Documentation/devicetree/bindings/pci/host-generic-pci.txt
>> index cf3e205..6996af7 100644
>> --- a/Documentation/devicetree/bindings/pci/host-generic-pci.txt
>> +++ b/Documentation/devicetree/bindings/pci/host-generic-pci.txt
>> @@ -36,6 +36,8 @@ Properties of the host controller node:
>>  - reg            : The Configuration Space base address and size, as accessed
>>                     from the parent bus.
>>
>> +- msi-parent     : Specify the phandle of the corresponded MSI controller
>> +                   for this PCI host controller.
>>
>>  Properties of the /chosen node:
>>
>> @@ -77,6 +79,7 @@ pci {
>>      device_type = "pci";
>>      #address-cells = <3>;
>>      #size-cells = <2>;
>> +    msi-parent = <&msictrl0>;
>>      bus-range = <0x0 0x1>;
>>
>>      // CPU_PHYSICAL(2)  SIZE(2)
>> diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
>> index 1895907..c4fbcda 100644
>> --- a/drivers/pci/host/pci-host-generic.c
>> +++ b/drivers/pci/host/pci-host-generic.c
>> @@ -42,6 +42,7 @@ struct gen_pci {
>>         struct pci_host_bridge                  host;
>>         struct gen_pci_cfg_windows              cfg;
>>         struct list_head                        resources;
>> +       struct msi_chip                         *mchip;
>>  };
>>
>>  static void __iomem *gen_pci_map_cfg_bus_cam(struct pci_bus *bus,
>> @@ -122,9 +123,19 @@ static int gen_pci_config_write(struct pci_bus *bus, unsigned int devfn,
>>         return PCIBIOS_SUCCESSFUL;
>>  }
>>
>> +static int gen_pci_set_msi_parent(struct pci_bus *bus)
>> +{
>> +       struct gen_pci *pci = bus_to_gen_pci(bus);
>> +
>> +       bus->msi = pci->mchip;
>> +
>> +       return PCIBIOS_SUCCESSFUL;
>> +}
>> +
>>  static struct pci_ops gen_pci_ops = {
>>         .read   = gen_pci_config_read,
>>         .write  = gen_pci_config_write,
>> +       .set_msi_parent = gen_pci_set_msi_parent,
>
> We assign the msi chip through add_bus() call, do we still need this?
>

There are series of patches from Yijing Wang around this.  You may have
to go through them.

Srikanth

> Srikanth
>
>>  };
>>
>>  static const struct of_device_id gen_pci_of_match[] = {
>> @@ -303,6 +314,8 @@ static int gen_pci_probe(struct platform_device *pdev)
>>                 return err;
>>         }
>>
>> +       pci->mchip = of_pci_find_msi_chip_by_node(of_parse_phandle(np,
>> +                                                 "msi-parent", 0));
>>         pci_common_init_dev(dev, &hw);
>>         return 0;
>>  }
>> --
>> 1.9.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
