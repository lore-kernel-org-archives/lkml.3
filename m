Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaIXKOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:14:37 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:39326 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaIXKOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:14:33 -0400
MIME-Version: 1.0
X-Originating-IP: [92.2.96.9]
In-Reply-To: <20140924002253.GB27357@google.com>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
	<1411498874-9864-6-git-send-email-Liviu.Dudau@arm.com>
	<20140924002253.GB27357@google.com>
Date: Wed, 24 Sep 2014 11:14:32 +0100
Message-ID: <CAPcvp5GeZCkxC-_9e3VQQ=VwiAwFn-kJL_yCr9V3H-Go5eJvyw@mail.gmail.com>
Subject: Re: [PATCH v12 05/12] PCI: OF: Fix the conversion of IO ranges into
 IO resources.
From: Andrew Murray <amurray@embedded-bits.co.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 September 2014 01:22, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Andrew]
>
> On Tue, Sep 23, 2014 at 08:01:07PM +0100, Liviu Dudau wrote:
>> The ranges property for a host bridge controller in DT describes
>> the mapping between the PCI bus address and the CPU physical address.
>> The resources framework however expects that the IO resources start
>> at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
>> The conversion from pci ranges to resources failed to take that into account,
>> returning a CPU physical address instead of a port number.
>>
>> Also fix all the drivers that depend on the old behaviour by fetching
>> the CPU physical address based on the port number where it is being needed.
>>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Thierry Reding <thierry.reding@gmail.com>
>> Cc: Simon Horman <horms@verge.net.au>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>> ---
>>  arch/arm/mach-integrator/pci_v3.c | 23 ++++++++++----------
>>  drivers/of/address.c              | 44 +++++++++++++++++++++++++++++++++++----
>>  drivers/pci/host/pci-tegra.c      | 10 ++++++---
>>  drivers/pci/host/pcie-rcar.c      | 21 +++++++++++++------
>>  include/linux/of_address.h        | 15 ++++++-------
>>  5 files changed, 82 insertions(+), 31 deletions(-)
>> ...
>
> The of_pci_range_to_resource() implementation in drivers/of/address.c is
> always compiled when CONFIG_OF_ADDRESS=y, but when CONFIG_OF_ADDRESS=y and
> CONFIG_PCI is not set, we get the static inline version from
> include/linux/of_address.h as well, causing a redefinition error.
>
>> diff --git a/drivers/of/address.c b/drivers/of/address.c
>> @@ -957,12 +957,48 @@ bool of_dma_is_coherent(struct device_node *np)
>> ...
>> +int of_pci_range_to_resource(struct of_pci_range *range,
>> +     struct device_node *np, struct resource *res)
>
>> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
>> ...
>>  #else /* CONFIG_OF_ADDRESS && CONFIG_PCI */
>>  static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
>>                                            struct resource *r)
>> @@ -144,6 +139,12 @@ static inline int of_pci_address_to_resource(struct device_node *dev, int bar,
>>       return -ENOSYS;
>>  }
>>
>> +static inline int of_pci_range_to_resource(struct of_pci_range *range,
>> +             struct device_node *np, struct resource *res)
>> +{
>> +     return -ENOSYS;
>> +}
>
> My proposal to fix it is the following three patches.  The first moves the
> inline version of of_pci_range_to_resource() into the existing "#if
> defined(CONFIG_OF_ADDRESS) && defined(CONFIG_PCI)" block.
>
> Andrew added it (and some other PCI-related things) with 29b635c00f3e
> ("of/pci: Provide support for parsing PCI DT ranges property") to
> of_address.h outside of any ifdefs, so it's always available.  Maybe
> there's a reason that's needed in the non-CONFIG_PCI case, but I didn't see
> it with a quick look.
>

There was no reason - it probably should have been inside a #ifdef
like the others.

Andrew Murray
