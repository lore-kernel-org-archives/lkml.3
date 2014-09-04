Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaIDQCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:02:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47836 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaIDQCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:02:22 -0400
Date: Thu, 4 Sep 2014 17:02:17 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Jingoo Han <jg1.han@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drivers: pci: convert generic host controller to DT host
 bridge creation API
Message-ID: <20140904160217.GC12351@e102568-lin.cambridge.arm.com>
References: <1407861695-25549-1-git-send-email-Liviu.Dudau@arm.com>
 <20140819120553.GA23128@arm.com>
 <20140904133956.GA12351@e102568-lin.cambridge.arm.com>
 <6930538.Get2YiuMvJ@wuerfel>
MIME-Version: 1.0
In-Reply-To: <6930538.Get2YiuMvJ@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 04 Sep 2014 16:02:18.0668 (UTC) FILETIME=[9A7ECEC0:01CFC859]
X-MC-Unique: 114090417022001501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

thanks for having a look.

On Thu, Sep 04, 2014 at 03:05:53PM +0100, Arnd Bergmann wrote:
> On Thursday 04 September 2014 14:39:56 Lorenzo Pieralisi wrote:
> > > > +   if (!res_valid) {
> > > > +           dev_err(dev, "non-prefetchable memory resource required\n");
> > > > +           return -EINVAL;
> > > > +   }
> > > > +
> > > > +   if (iores) {
> > > > +           if (!PAGE_ALIGNED(io_cpuaddr))
> > > > +                   return -EINVAL;
> > > 
> > > Why is this alignment check not in the core code? Probably a question for
> > > somebody like Arnd, but do we need to deal with multiple IO resources?
> > > Currently we'll just silently take the last one that we found, which doesn't
> > > sound ideal.
> > 
> > (1) Yes, the alignment check should be made in core code
> 
> Makes sense. In theory we could support unaligned addresses (as long as
> the offset in the page is the same for virtual and physical), but I don't
> see why we should implement that unless some implementation absolutely
> requires it.
> 
> > (2) I could take the first IO resource and warn on multiple IO resources if
> >     they are detected. Thoughts ?
> 
> I think we should either warn, or be reasonably sure that it will work.
> Again, in theory this should work, but no sane hardware implementation
> would do it like that.

Ok, I will refactor the IO resources mapping code on top of Livius's v10.

> > > > +           if (err)
> > > > +                   return err;
> > > > +   }
> > > > +
> > > > +   /* Parse and map our Configuration Space windows */
> > > > +   err = gen_pci_parse_map_cfg_windows(host);
> > > > +   if (err)
> > > > +           return err;
> > > > +
> > > > +   pci_add_flags(PCI_ENABLE_PROC_DOMAINS);
> > > > +   pci_add_flags(PCI_REASSIGN_ALL_BUS | PCI_REASSIGN_ALL_RSRC);
> > > 
> > > Why does this belong in the host controller driver and how does it interact
> > > with the probe-only property?
> > 
> > That's a very good question and it is one that confuses me too.
> > 
> > Current code in pci_common_init_dev() sets PCI_REASSIGN_ALL_RSRC behind
> > our backs silently. That flag has a side effect only if the probing code
> > detects PCI bridges in the list of devices, since PCI core probing code
> > will try to reassign the bus numbers upon PCI bridge detection IIUC. I do
> > not think that PCI_REASSIGN_ALL_BUS has any side effect on ARM (by grepping
> > around I noticed that PCI_REASSIGN_ALL_RSRC is used in
> > 
> > pcibios_assign_all_busses()
> > 
> > which in turn is triggered only if PCI bridges are detected, still grokking
> > the code though).
> 
> Interesting point: the generic implementation should probably not default
> to reassigning all buses at all. We could have a (host controller specific,
> but with standardized name) DT property for it, but it would be best if
> firmware already probes it to not have to do it again.

I think that makes sense, let me point out though that this is
*not* how the code works today, since the pcibios code sets:

PCI_REASSIGN_ALL_RSRC (pci_common_init_dev() in arch/arm/kernel/bios32.c)

by default. I won't set the PCI_REASSIGN_ALL_RSRC and PCI_REASSIGN_ALL_BUS
flags.

> > Apart from the PCI_ENABLE_PROC_DOMAINS flag which I think it is safe to
> > set by default (but let me check that too),
> 
> I think it should be enabled here, as no legacy machine will use this
> driver.

+1

I will wait for Liviu's v10 and repost accordingly.

Lorenzo

