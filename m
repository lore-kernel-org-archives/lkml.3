Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaI3IyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:54:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50464 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaI3IyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:54:15 -0400
Date: Tue, 30 Sep 2014 09:54:07 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yinghai Lu <yinghai@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
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
        Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [PATCH v13 10/12] PCI: Assign unassigned bus resources in
 pci_scan_root_bus()
Message-ID: <20140930085407.GL841@e106497-lin.cambridge.arm.com>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
 <1412000971-9242-11-git-send-email-Liviu.Dudau@arm.com>
 <CAE9FiQXEUZvkuzwOrK+2zGVj0ywFaQsiWH7SHufZk9BRWnwddQ@mail.gmail.com>
 <CAE9FiQUkcPRMUEn01VJMyXz8aYvk6C5MBNZi5NCV2m3qkNabeg@mail.gmail.com>
 <1412024521.4285.98.camel@pasglop>
 <CAErSpo62ap1YkzvuZ6MCpXry9=VpLv+Skzrwr10h=+Lc4VfVgQ@mail.gmail.com>
 <1412029912.4285.110.camel@pasglop>
 <CAErSpo70t9TMdntjBt+GdTw3FVmMquACQePX8=SKkySPuG3F3Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAErSpo70t9TMdntjBt+GdTw3FVmMquACQePX8=SKkySPuG3F3Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 30 Sep 2014 08:54:08.0685 (UTC) FILETIME=[18CFFDD0:01CFDC8C]
X-MC-Unique: 114093009541107901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:08:49AM +0100, Bjorn Helgaas wrote:
> On Mon, Sep 29, 2014 at 4:31 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Mon, 2014-09-29 at 15:33 -0600, Bjorn Helgaas wrote:
> >> > Right and on powerpc and others as well. We need to survey existing
> >> > resources. We also have a number of platform things that might need
> >> > to happen before we do the final re-assignment pass.
> >>
> >> That's true today.  But I don't know whether it *has* to be this way
> >> forever.  On x86, pcibios_resource_survey() throws in E820 information
> >> (which we know long before we do any PCI enumeration) and some IO-APIC
> >> resources (it looks like we also know these before PCI enumeration).
> >> Powerpc has pcibios_reserve_legacy_regions(), but that looks like
> >> mostly stuff that could be done when we find the host bridge, before
> >> we enumerate PCI devices below it.
> >
> > Oh we can probably change that but it's going to be much more work than
> > just moving the assignment into pci_scan_root_bus().
> 
> Agreed.  It's obvious that we can't apply Liviu's patch as-is.

Thanks everyone for the feedback!

Bjorn, you can drop this patch from the series if you want to add it to
your tree, and the host bridge drivers will have to reimplement pci_scan_root_bus()
for now (most do it already as they need to add msi information as well).

Benjamin, I still have on my ToDo list to convert powerpc. I might not be
able to do it successfully on my own (as I don't understand a lot of the
corner cases) but Bjorn is correct here in that pcibios_reserve_legacy_regions()
will move out of the scanning of the root bus.

> 
> > There are also a
> > number of subtle and not-so-subtle bits of code that rely on side
> > effects of the current code such as anything that tests for bus->added
> > or dev->added. Again, nothing we can't sort out eventually but the
> > transition might be a bit painful.
> >
> > We might need to introduce a new flag for platforms converted to the
> > "new style" generalized resource assignment which we can deprecate once
> > everybody has moved over.
> 
> There's definitely a lot of work here if we ever want to make this happen.

I know :)

Best regards,
Liviu

> 
> Bjorn
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

