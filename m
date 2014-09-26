Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaIZVxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:53:51 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:63058 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbaIZVxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:53:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140926212052.GA6030@borg.dudau.co.uk>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
 <1411498874-9864-9-git-send-email-Liviu.Dudau@arm.com> <CAL_Jsq+j40Xf208wCf4as3H=cDU=htJ-JWinB0DjpcORjatNXQ@mail.gmail.com>
 <20140926212052.GA6030@borg.dudau.co.uk>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 26 Sep 2014 16:53:26 -0500
Message-ID: <CAL_JsqKJ6bfPuOofo4grVm3qW_WOpUzcS1juZvHxZdFyyF_19A@mail.gmail.com>
Subject: Re: [PATCH v12 08/12] PCI: OF: Introduce helper function for
 retrieving PCI domain numbers
To: Rob Herring <robherring2@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
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
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 4:20 PM,  <liviu@dudau.co.uk> wrote:
> On Fri, Sep 26, 2014 at 01:20:39PM -0500, Rob Herring wrote:
>> On Tue, Sep 23, 2014 at 2:01 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>> > Add pci_get_new_domain_nr() to allocate a new domain number
>> > and of_get_pci_domain_nr() to retrieve the PCI domain number
>> > of a given device from DT. Host bridge drivers or architecture
>> > specific code can choose to implement their PCI domain number
>> > policy using these two functions.
>> >
>> > Using of_get_pci_domain_nr() guarantees a stable PCI domain
>> > number on every boot provided that all host bridge controllers
>> > are assigned a number in the device tree using "linux,pci-domain"
>> > property. Mix use of pci_get_new_domain_nr() and of_get_pci_domain_nr()
>> > is not recommended as it can lead to potentially conflicting
>> > domain numbers being assigned to root busses behind different
>> > host bridges.
>> >
>> > Cc: Bjorn Helgaas <bhelgaas@google.com>
>> > Cc: Arnd Bergmann <arnd@arndb.de>
>> > Cc: Grant Likely <grant.likely@linaro.org>
>> > Cc: Rob Herring <robh+dt@kernel.org>
>> > Cc: Catalin Marinas <catalin.marinas@arm.com>
>> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>>
>> Looks pretty good, but a couple of comments that can be addressed as
>> follow-up patches.
>>
>> > ---
>> >  drivers/of/of_pci.c    | 25 +++++++++++++++++++++++++
>> >  drivers/pci/pci.c      |  9 +++++++++
>> >  include/linux/of_pci.h |  7 +++++++
>> >  include/linux/pci.h    |  3 +++
>> >  4 files changed, 44 insertions(+)
>> >
>> > diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
>> > index 8481996..82d172f 100644
>> > --- a/drivers/of/of_pci.c
>> > +++ b/drivers/of/of_pci.c
>> > @@ -89,6 +89,31 @@ int of_pci_parse_bus_range(struct device_node *node, struct resource *res)
>> >  }
>> >  EXPORT_SYMBOL_GPL(of_pci_parse_bus_range);
>> >
>> > +/**
>> > + * This function will try to obtain the host bridge domain number by
>> > + * finding a property called "linux,pci-domain" of the given device node.
>> > + *
>> > + * @node: device tree node with the domain information
>> > + *
>> > + * Returns the associated domain number from DT in the range [0-0xffff], or
>> > + * a negative value if the required property is not found.
>> > + */
>> > +int of_get_pci_domain_nr(struct device_node *node)
>> > +{
>> > +       const __be32 *value;
>> > +       int len;
>> > +       u16 domain;
>> > +
>> > +       value = of_get_property(node, "linux,pci-domain", &len);
>>
>> This needs to be documented.
>
> I would say needs agreed on *and* documented.

I thought Bjorn already applied the series. Who's agreement are you
waiting for specifically.

>>
>> > +       if (!value || len < sizeof(*value))
>> > +               return -EINVAL;
>> > +
>> > +       domain = (u16)be32_to_cpup(value);
>>
>> of_property_read_u32 would not work here?
>
> It should, I guess, but I want to limit the domain number range to 16 bits.

Okay, but it would still be fewer lines to use of_property_read_u32
and then cast it. You could use the u16 variant and make the property
be defined to be 16-bit in the documentation.

Rob
