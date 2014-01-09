Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaAIUoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:44:16 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:58624 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaAIUoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:44:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo4BpCYQ1q8ogqAtn7pbCXkKHM4M4DCffF9m+Gd4tjit1w@mail.gmail.com>
References: <CA+2TWzXvZrVZDJA-KkuUVuCP8kwX3GENL_rTf=_dZ_HBqJUArw@mail.gmail.com>
	<CAErSpo4BpCYQ1q8ogqAtn7pbCXkKHM4M4DCffF9m+Gd4tjit1w@mail.gmail.com>
Date: Thu, 9 Jan 2014 12:44:10 -0800
X-Google-Sender-Auth: x6bKfOBsY7tfCleK198iirQtWSo
Message-ID: <CAE9FiQUU6-mtXQUpV=HFXaXpbL9-1UdFjkoed2+ROjJMtHQWSQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Allocate prefetch mmio resource first when possible
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: threeTigers Lin <threeflytigers@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 4:24 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Yinghai]
>
> On Wed, Jan 8, 2014 at 11:17 AM, threeTigers Lin
> <threeflytigers@gmail.com> wrote:
>> From f7a37ed1c61b5939ccef810e28b25ecf3bfa9077 Mon Sep 17 00:00:00 2001
>> From: linmuhui <linmuhui@huawei.com>
>> Date: Thu, 9 Jan 2014 01:03:12 +0800
>> Subject: [PATCH] PCI: Allocate prefetch mmio resource first when possible
>
> This patch is not in the standard format and does not apply cleanly.
> See Documentation/SubmittingPatches.
>
>> Hi Bjorn,
>>
>> PCI bus resources will be set up at pci_bridge_check_ranges() or
>> pci_read_bridge_bases(). In both cases, we can find that the PCI bus'
>> non-pref mmio will be assigned to bus->resource[1] and pref mmio will be
>> assigned to bus->resource[2]. So, in the scenario that we need to allocate
>> pref resources from PCI bus such as hotplug operation, the bus' non-pref
>> mmio will be quickly eaten up first if we try to allocate bus resources in
>> the order from bus->resource[0] to bus->resource[PCI_BRIDGE_RESOURCE_NUM -
>> 1] in the function pci_bus_alloc_resource(), even though there is enough
>> pref mmio resource of the bus. This may lead to the later requester who want
>> to allocate non-pref mmio cannot allocate the resource from the bus. So, I
>> think the order of allocating PCI bus resources in function
>> pci_bus_alloc_resource() should be changed to try pref mmio first when
>> possible.
>
> Don't we do this already?  The code in __pci_assign_resource() looks
> like it should prefer an exact prefetching match.
>
> If that code doesn't work, we should fix it there.  I don't want to
> fiddle with pci_bus_for_each_resource() for this -- that's a really
> arcane place to hide such a fix.

Looks like he was trying to do sorting work like we try to do with
root bus resource before, but with new patches in pci/resource, we do
NOT need to do that anymore.

Hi, Lin,

Can you check linus/master + pci/next + pci/resource

and

http://patchwork.ozlabs.org/patch/303740/
PCI: Try best to allocate pref mmio 64bit above 4g

would fix the problem in your setup?

Thanks

Yinghai
