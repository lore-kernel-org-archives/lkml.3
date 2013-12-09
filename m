Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab3LITV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:21:56 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:42686 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3LITVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:21:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7HaAbsoy0n5sr_d3iPazEnpnO8WupJrDn2QR2Kid=EgQ@mail.gmail.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
	<1386546869-31900-2-git-send-email-yinghai@kernel.org>
	<CAErSpo7HaAbsoy0n5sr_d3iPazEnpnO8WupJrDn2QR2Kid=EgQ@mail.gmail.com>
Date: Mon, 9 Dec 2013 11:21:53 -0800
X-Google-Sender-Auth: Ko4opU_WlInkyY4AipNZPOg7sV4
Message-ID: <CAE9FiQUebPPcTyHGssxTwJJ3GYx4aq-=infapvxOQgAm+PL4rA@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: pcibus address to resource converting take bus
 instead of dev
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 9:52 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sun, Dec 8, 2013 at 4:54 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> For allocating resource under bus path, we do not have dev to pass along,
>> and we only have bus to use instead.
>>
>> -v2: drop pcibios_bus_addr_to_resource().
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: stable@vger.kernel.org
>> ---
>>  drivers/pci/host-bridge.c | 34 +++++++++++++++++++++-------------
>>  include/linux/pci.h       |  5 +++++
>>  2 files changed, 26 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
>> index a68dc61..c988a30 100644
>> --- a/drivers/pci/host-bridge.c
>> +++ b/drivers/pci/host-bridge.c
>> @@ -9,22 +9,19 @@
>>
>>  #include "pci.h"
>>
>> -static struct pci_bus *find_pci_root_bus(struct pci_dev *dev)
>> +static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
>>  {
>> -       struct pci_bus *bus;
>> -
>> -       bus = dev->bus;
>>         while (bus->parent)
>>                 bus = bus->parent;
>>
>>         return bus;
>>  }
>>
>> -static struct pci_host_bridge *find_pci_host_bridge(struct pci_dev *dev)
>> +static struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
>>  {
>> -       struct pci_bus *bus = find_pci_root_bus(dev);
>> +       struct pci_bus *root_bus = find_pci_root_bus(bus);
>>
>> -       return to_pci_host_bridge(bus->bridge);
>> +       return to_pci_host_bridge(root_bus->bridge);
>>  }
>>
>>  void pci_set_host_bridge_release(struct pci_host_bridge *bridge,
>> @@ -40,10 +37,11 @@ static bool resource_contains(struct resource *res1, struct resource *res2)
>>         return res1->start <= res2->start && res1->end >= res2->end;
>>  }
>>
>> -void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
>> -                            struct resource *res)
>> +void __pcibios_resource_to_bus(struct pci_bus *bus,
>> +                                     struct pci_bus_region *region,
>> +                                     struct resource *res)
>>  {
>> -       struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
>> +       struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
>>         struct pci_host_bridge_window *window;
>>         resource_size_t offset = 0;
>>
>> @@ -60,6 +58,11 @@ void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
>>         region->start = res->start - offset;
>>         region->end = res->end - offset;
>>  }
>> +void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
>> +                            struct resource *res)
>> +{
>> +       __pcibios_resource_to_bus(dev->bus, region, res);
>> +}
>>  EXPORT_SYMBOL(pcibios_resource_to_bus);
>>
>>  static bool region_contains(struct pci_bus_region *region1,
>> @@ -68,10 +71,10 @@ static bool region_contains(struct pci_bus_region *region1,
>>         return region1->start <= region2->start && region1->end >= region2->end;
>>  }
>>
>> -void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
>> -                            struct pci_bus_region *region)
>> +void __pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
>> +                                     struct pci_bus_region *region)
>>  {
>> -       struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
>> +       struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
>>         struct pci_host_bridge_window *window;
>>         resource_size_t offset = 0;
>>
>> @@ -93,4 +96,9 @@ void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
>>         res->start = region->start + offset;
>>         res->end = region->end + offset;
>>  }
>> +void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
>> +                            struct pci_bus_region *region)
>> +{
>> +       __pcibios_bus_to_resource(dev->bus, res, region);
>> +}
>>  EXPORT_SYMBOL(pcibios_bus_to_resource);
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 1084a15..5c2cf8e 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -737,8 +737,13 @@ void pci_fixup_cardbus(struct pci_bus *);
>>
>>  /* Generic PCI functions used internally */
>>
>> +void __pcibios_resource_to_bus(struct pci_bus *bus,
>> +                              struct pci_bus_region *region,
>> +                              struct resource *res);
>>  void pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
>>                              struct resource *res);
>> +void __pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
>> +                                     struct pci_bus_region *region);
>>  void pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
>>                              struct pci_bus_region *region);
>>  void pcibios_scan_specific_bus(int busn);
>
> Ugh.  Why would we add new functions with "__" prefixes?  There are
> only a handful of callers to pcibios_bus_to_resource() and
> pcibios_resource_to_bus().  We can just change them to supply a
> "struct pci_bus *" directly.  That's a better match for how the
> hardware works anyway.

ok, will update that if you prefer that.

Yinghai
