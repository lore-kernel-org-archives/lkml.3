Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbaIZQV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 12:21:57 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:37233 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaIZQV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:21:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140926145854.GS841@e106497-lin.cambridge.arm.com>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
 <1411498874-9864-7-git-send-email-Liviu.Dudau@arm.com> <CAE9FiQXuJZnj74dwTbKJCQNJ+OdEbjSB0fpwqh92+WZ_XGnrxQ@mail.gmail.com>
 <CAErSpo6eUEV81n1rFjjvRcFVmsFkeUxhdL6JauTmx_Et6XdBuQ@mail.gmail.com> <20140926145854.GS841@e106497-lin.cambridge.arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 26 Sep 2014 10:17:21 -0600
Message-ID: <CAErSpo4e5iWKTW7cHD8D+LwZyVhsaDz2tkL-wEitJ9RNYp+0fg@mail.gmail.com>
Subject: Re: [PATCH v12 06/12] PCI: Create pci_host_bridge before its
 associated bus in pci_create_root_bus.
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
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
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 8:58 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> On Thu, Sep 25, 2014 at 08:59:26PM +0100, Bjorn Helgaas wrote:
>> On Thu, Sep 25, 2014 at 12:15 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Tue, Sep 23, 2014 at 12:01 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>> >> Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
>> >> As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
>> >> the creation order has been changed for no good reason. Revert the order of
>> >> creation as we are going to depend on the pci_host_bridge structure to retrieve the
>> >> domain number of the root bus.
>> >>
>> >> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> >> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>> >> Acked-by: Grant Likely <grant.likely@linaro.org>
>> >> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> >> Tested-by: Tanmay Inamdar <tinamdar@apm.com>
>> >> ---
>> >>  drivers/pci/probe.c | 32 +++++++++++++++++---------------
>> >>  1 file changed, 17 insertions(+), 15 deletions(-)
>> >>
>> >> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> >> index e3cf8a2..5ff72ec 100644
>> >> --- a/drivers/pci/probe.c
>> >> +++ b/drivers/pci/probe.c
>> >> @@ -515,7 +515,7 @@ static void pci_release_host_bridge_dev(struct device *dev)
>> >>         kfree(bridge);
>> >>  }
>> >>
>> >> -static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
>> >> +static struct pci_host_bridge *pci_alloc_host_bridge(void)
>> >>  {
>> >>         struct pci_host_bridge *bridge;
>> >>
>> >> @@ -524,7 +524,8 @@ static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
>> >>                 return NULL;
>> >>
>> >>         INIT_LIST_HEAD(&bridge->windows);
>> >> -       bridge->bus = b;
>> >> +       bridge->dev.release = pci_release_host_bridge_dev;
>> >> +
>> >>         return bridge;
>> >>  }
>> >>
>> >> @@ -1761,9 +1762,15 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>> >>         char bus_addr[64];
>> >>         char *fmt;
>> >>
>> >> +       bridge = pci_alloc_host_bridge();
>> >> +       if (!bridge)
>> >> +               return NULL;
>> >> +
>> >> +       bridge->dev.parent = parent;
>> >> +
>> >>         b = pci_alloc_bus();
>> >>         if (!b)
>> >> -               return NULL;
>> >> +               goto err_out;
>> >>
>> >>         b->sysdata = sysdata;
>> >>         b->ops = ops;
>> >> @@ -1772,26 +1779,19 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>> >>         if (b2) {
>> >>                 /* If we already got to this bus through a different bridge, ignore it */
>> >>                 dev_dbg(&b2->dev, "bus already known\n");
>> >> -               goto err_out;
>> >> +               goto err_bus_out;
>> >>         }
>> >>
>> >> -       bridge = pci_alloc_host_bridge(b);
>> >> -       if (!bridge)
>> >> -               goto err_out;
>> >> -
>> >> -       bridge->dev.parent = parent;
>> >> -       bridge->dev.release = pci_release_host_bridge_dev;
>> >> +       bridge->bus = b;
>> >>         dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
>> >>         error = pcibios_root_bridge_prepare(bridge);
>> >> -       if (error) {
>> >> -               kfree(bridge);
>> >> +       if (error)
>> >>                 goto err_out;
>> >> -       }
>> >>
>> >>         error = device_register(&bridge->dev);
>> >>         if (error) {
>> >>                 put_device(&bridge->dev);
>> >> -               goto err_out;
>> >> +               goto err_bus_out;
>> >>         }
>> >>         b->bridge = get_device(&bridge->dev);
>> >>         device_enable_async_suspend(b->bridge);
>> >> @@ -1848,8 +1848,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>> >>  class_dev_reg_err:
>> >>         put_device(&bridge->dev);
>> >>         device_unregister(&bridge->dev);
>> >> -err_out:
>> >> +err_bus_out:
>> >>         kfree(b);
>> >> +err_out:
>> >> +       kfree(bridge);
>> >>         return NULL;
>> >>  }
>> >
>> > Hi Bjorn,
>> >
>> > Noticed that you put this one into pci/next.
>> >
>> > This patch has problem for the class_dev_reg_err path.
>> > as device_unregister(&bridge->dev) will trigger pci_release_host_bridge_dev.
>> > So will have double free for bridge or else.
>> >
>> > Please drop this patch from pci/next.
>> >
>> > Also looks strange that the patch have long CC list, but just omit me
>> > and Jiang Liu that
>> > touched those code before.
>>
>> Thanks for noticing that.  I was concerned, but couldn't remember the details.
>>
>> I dropped this patch and the subsequent ones from pci/host and rebased
>> my "next" branch.
>>
>> Sorry I didn't notice you weren't on the CC list.
>>
>> Bjorn
>>
>
> Bjorn,
>
> I have refreshed/rebuilt the series from what was on 25th in linux-next and I have
> dropped this patch. I have pushed the series into
>
> git://linux-arm.org/linux-ld.git for-upstream/pci-next
>
> I hope that I've carried all your Sign-off-bys correctly, but I would like to ask you
> to double check that I haven't screwed up things.

I personally don't pull directly from git trees because I'm in the
habit of applying patches from email.  That's partly just habit, but
it's also a convenient way to ensure that every patch is posted on
linux-pci, which in turn helps me use patchwork as a "to-do" list, and
it allows me to make minor edits (whitespace, changelogs, etc.) for
consistency.

> This patch dates from the times I was trying to add the domain number information
> into the pci_host_bridge structure. Now, with Catalin's patch that adds the data in
> the pci_bus structure, this is not needed, so it is safe to drop. I did try to fix
> the patch but I've realised how intricately linked pci_host_bridge and root bus are,
> which to my opinion is a strong hint that the creation of the two should be split
> into separate functions.
>
> I can send an official v13 patchset to the mailing list if you want, but if not, here
> is the changelog:
>
> - updated "[PATCH 01/12] asm-generic/io.h: Fix ioport_map() for !CONFIG_GENERIC_IOMAP" to match
>   the patch that Thierry Reding has submitted through the asm-generic branch. If his
>   series lands first upstream this patch will be skipped.
> - updated "[PATCH 03/12] ARM: Define PCI_IOBASE as the base of virtual PCI IO space" to
>   cast the PCI_IOBASE value to (void __iomem *) as is the case with most #defined versions
> - dropped the patch that was changing the order of initialisation between pci_host_bridge
>   and root bus in pci_create_root_bus()
> - fixed "[PATCH 07/12] PCI: Add generic domain handling" to account for the previous patch
>   being removed
> - fixed the title of commit 08/12 to reflect the name of the functions that are actually
>   added (s/of_pci_get_domain_nr/pci_get_new_domain_nr/)
>
> I've compiled tested the series on sparc, microblaze (no)mmu_defconfig, arm omap2plus_defconfig
> and multi_v7_defconfig and arm64. I've also tested the series on my Juno (arm64) board.

It sounds like the v3.18 merge window is likely to open this weekend.
Therefore, I don't want to change anything that's already in my "next"
branch unless it is seriously broken, e.g., introduces a regression or
build error.

But you can post a series that would apply on top if you want, and
it's possible we could merge that later in the merge window,
especially if it is obviously low-risk.  If you go this route, please
do post it to the mailing list.

Bjorn
