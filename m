Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407AbaIVRTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:19:08 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:38326 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaIVRTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:19:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140922153207.GA1994@e106497-lin.cambridge.arm.com>
References: <1411003825-21521-1-git-send-email-Liviu.Dudau@arm.com>
 <1411003825-21521-5-git-send-email-Liviu.Dudau@arm.com> <541DBA57.2000903@gmail.com>
 <20140922153207.GA1994@e106497-lin.cambridge.arm.com>
From: Rob Herring <robherring2@gmail.com>
Date: Mon, 22 Sep 2014 12:18:42 -0500
Message-ID: <CAL_JsqL9heHCEyXV5e4pOS3iWN51Q7KAQ-FxW_rzcWudqjwcdQ@mail.gmail.com>
Subject: Re: [PATCH v11 04/10] PCI: OF: Fix the conversion of IO ranges into
 IO resources.
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
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
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:32 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> On Sat, Sep 20, 2014 at 06:33:11PM +0100, Rob Herring wrote:
>> On 09/17/2014 08:30 PM, Liviu Dudau wrote:
>> > The ranges property for a host bridge controller in DT describes
>> > the mapping between the PCI bus address and the CPU physical address.
>> > The resources framework however expects that the IO resources start
>> > at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
>> > The conversion from pci ranges to resources failed to take that into account.

[...]

>> >               if ((range.flags & IORESOURCE_MEM) &&
>> >                       (range.flags & IORESOURCE_PREFETCH)) {
>> >                       pre_mem_pci = range.pci_addr;
>> >                       pre_mem_pci_sz = range.size;
>> > -                     of_pci_range_to_resource(&range, np, &pre_mem);
>> > +                     ret = of_pci_range_to_resource(&range, np, &pre_mem);
>> >                       pre_mem.name = "PCIv3 prefetched mem";
>> >               }
>> > -     }
>> >
>> > -     if (!conf_mem.start || !io_mem.start ||
>> > -         !non_mem.start || !pre_mem.start) {
>> > -             dev_err(&pdev->dev, "missing ranges in device node\n");
>> > -             return -EINVAL;
>> > +             if (ret < 0) {
>> > +                     dev_err(&pdev->dev, "missing ranges in device node\n");
>> > +                     return -EINVAL;
>>
>> You should return ret rather than potentially changing the return value.
>
> I was trying to keep the existing behaviour, which was to return -EINVAL if the
> parsing has failed. But I can return ret and propagate the original error code.

A valid concern, but I checked and I believe the return from
of_pci_range_to_resource is currently -EINVAL.

>> > +int of_pci_range_to_resource(struct of_pci_range *range,
>> > +     struct device_node *np, struct resource *res)
>> > +{
>> > +     int err;
>> > +     res->flags = range->flags;
>> > +     res->parent = res->child = res->sibling = NULL;
>> > +     res->name = np->full_name;
>> > +
>> > +     if (res->flags & IORESOURCE_IO) {
>> > +             unsigned long port = -1;
>>
>> Assigning a signed value to unsigned...
>
> Ooops, sorry about that. Removed the initialisation now.
>
>>
>> Does port need to be 64-bit on 64-bit hosts?
>
> I'm following existing APIs. Basically my function is a variant of __of_address_to_resource()

Okay.

Rob
