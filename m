Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaIDOGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:06:34 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49887 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaIDOGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:06:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Will Deacon <will.deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Jingoo Han <jg1.han@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drivers: pci: convert generic host controller to DT host bridge creation API
Date: Thu, 04 Sep 2014 16:05:53 +0200
Message-ID: <6930538.Get2YiuMvJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140904133956.GA12351@e102568-lin.cambridge.arm.com>
References: <1407861695-25549-1-git-send-email-Liviu.Dudau@arm.com> <20140819120553.GA23128@arm.com> <20140904133956.GA12351@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vUyfFA/graZoZW1ybB/BJBvWWPRxKNjIDkmQ+JkmcZs
 CRqABiEzUa0dOo+R5V0H4fmEbK0rlfhi2SubcsbRTSq4tk7Y3Y
 gf+Pz59j1Tn7wBP7m2s2UpZwP3q816WCXHRqwqkCj0+UKl23fz
 Brutc/B4fSunIaNbEfHM3h1E5M8JWVvWZ2Ku+5mXdH3YUBK+Y8
 ki9ob6yiQGuvOdS2JTR+ipbUkyASGt06Bg6ViHBR/dYPgCoXpL
 zgPfi8xjtlMHA4j8VSyEooiVGHEn8HIqklbJ+7Rk5AmVqcYYh1
 u1HuizItN0Pzyqawy4fAjTPoBUKrSb5JJ0O9dEDwgwRARpOox7
 mCm3BatugO+qqaLKEEYI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 September 2014 14:39:56 Lorenzo Pieralisi wrote:
> > > +   if (!res_valid) {
> > > +           dev_err(dev, "non-prefetchable memory resource required\n");
> > > +           return -EINVAL;
> > > +   }
> > > +
> > > +   if (iores) {
> > > +           if (!PAGE_ALIGNED(io_cpuaddr))
> > > +                   return -EINVAL;
> > 
> > Why is this alignment check not in the core code? Probably a question for
> > somebody like Arnd, but do we need to deal with multiple IO resources?
> > Currently we'll just silently take the last one that we found, which doesn't
> > sound ideal.
> 
> (1) Yes, the alignment check should be made in core code

Makes sense. In theory we could support unaligned addresses (as long as
the offset in the page is the same for virtual and physical), but I don't
see why we should implement that unless some implementation absolutely
requires it.

> (2) I could take the first IO resource and warn on multiple IO resources if
>     they are detected. Thoughts ?

I think we should either warn, or be reasonably sure that it will work.
Again, in theory this should work, but no sane hardware implementation
would do it like that.

> > > +           if (err)
> > > +                   return err;
> > > +   }
> > > +
> > > +   /* Parse and map our Configuration Space windows */
> > > +   err = gen_pci_parse_map_cfg_windows(host);
> > > +   if (err)
> > > +           return err;
> > > +
> > > +   pci_add_flags(PCI_ENABLE_PROC_DOMAINS);
> > > +   pci_add_flags(PCI_REASSIGN_ALL_BUS | PCI_REASSIGN_ALL_RSRC);
> > 
> > Why does this belong in the host controller driver and how does it interact
> > with the probe-only property?
> 
> That's a very good question and it is one that confuses me too.
> 
> Current code in pci_common_init_dev() sets PCI_REASSIGN_ALL_RSRC behind
> our backs silently. That flag has a side effect only if the probing code
> detects PCI bridges in the list of devices, since PCI core probing code
> will try to reassign the bus numbers upon PCI bridge detection IIUC. I do
> not think that PCI_REASSIGN_ALL_BUS has any side effect on ARM (by grepping
> around I noticed that PCI_REASSIGN_ALL_RSRC is used in
> 
> pcibios_assign_all_busses()
> 
> which in turn is triggered only if PCI bridges are detected, still grokking
> the code though).

Interesting point: the generic implementation should probably not default
to reassigning all buses at all. We could have a (host controller specific,
but with standardized name) DT property for it, but it would be best if
firmware already probes it to not have to do it again.

> Apart from the PCI_ENABLE_PROC_DOMAINS flag which I think it is safe to
> set by default (but let me check that too),

I think it should be enabled here, as no legacy machine will use this
driver.

> I *think* that setting of
> 
> PCI_REASSIGN_ALL_BUS and PCI_REASSIGN_ALL_RSRC
> 
> should be set by DT, as the probe-only flag is. At the moment this is not a
> problem (well...) since:
> 
> (a) PCI_REASSIGN_ALL_RSRC is forced by pcibios on ARM
> (b) it has no implications on the generic host controller since it is
>     run on kvmtools with no PCI bridge devices
> 
> If Bjorn or Arnd can help me understand the complete reasoning behind
> those flags I would be very grateful and update code according to
> Liviu's v10.

I suspect they were just copied over to preserve the existing behavior.

	Arnd
