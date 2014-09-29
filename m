Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaI2VeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 17:34:03 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:33476 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaI2Vd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 17:33:58 -0400
MIME-Version: 1.0
In-Reply-To: <1412024521.4285.98.camel@pasglop>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
 <1412000971-9242-11-git-send-email-Liviu.Dudau@arm.com> <CAE9FiQXEUZvkuzwOrK+2zGVj0ywFaQsiWH7SHufZk9BRWnwddQ@mail.gmail.com>
 <CAE9FiQUkcPRMUEn01VJMyXz8aYvk6C5MBNZi5NCV2m3qkNabeg@mail.gmail.com> <1412024521.4285.98.camel@pasglop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 29 Sep 2014 15:33:37 -0600
Message-ID: <CAErSpo62ap1YkzvuZ6MCpXry9=VpLv+Skzrwr10h=+Lc4VfVgQ@mail.gmail.com>
Subject: Re: [PATCH v13 10/12] PCI: Assign unassigned bus resources in pci_scan_root_bus()
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
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
        Jiang Liu <jiang.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 3:02 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2014-09-29 at 12:06 -0700, Yinghai Lu wrote:
>> On Mon, Sep 29, 2014 at 11:25 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Mon, Sep 29, 2014 at 7:29 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>> >> If the firmware has not assigned all the bus resources and we are not just
>> >> probing the PCI buses, it makes sense to assign the unassigned resources
>> >> in pci_scan_root_bus().
>> >>
>> >> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>> >> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> >> CC: Arnd Bergmann <arnd@arndb.de>
>> >> CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> >> CC: Rob Herring <robh+dt@kernel.org>
>> >> ---
>> >>  drivers/pci/probe.c | 3 +++
>> >>  1 file changed, 3 insertions(+)
>> >>
>> >> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> >> index 636d1c9..d2ebd49 100644
>> >> --- a/drivers/pci/probe.c
>> >> +++ b/drivers/pci/probe.c
>> >> @@ -1951,6 +1951,9 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, int bus,
>> >>         if (!found)
>> >>                 pci_bus_update_busn_res_end(b, max);
>> >>
>> >> +       if (!pci_has_flag(PCI_PROBE_ONLY))
>> >> +               pci_assign_unassigned_bus_resources(b);
>> >> +
>> >>         pci_bus_add_devices(b);
>> >>         return b;
>> >>  }
>> >
>> > No, you can not do it that early.
>> >
>> > On x86, we need to call
>> > pcibios_resource_survey_bus at first.
>>
>> on x86:
>> pcibios_init
>> pcibios_resource_survey()
>> pcibios_assign_resources() via fs_initcall
>
> Right and on powerpc and others as well. We need to survey existing
> resources. We also have a number of platform things that might need
> to happen before we do the final re-assignment pass.

That's true today.  But I don't know whether it *has* to be this way
forever.  On x86, pcibios_resource_survey() throws in E820 information
(which we know long before we do any PCI enumeration) and some IO-APIC
resources (it looks like we also know these before PCI enumeration).
Powerpc has pcibios_reserve_legacy_regions(), but that looks like
mostly stuff that could be done when we find the host bridge, before
we enumerate PCI devices below it.

Bjorn
