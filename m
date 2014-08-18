Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaHRO0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:26:46 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:36093 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751958AbaHRO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:26:42 -0400
Date: Mon, 18 Aug 2014 15:25:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 02/12] PCI: OF: Parse and map the IRQ when adding the
 PCI device.
Message-ID: <20140818142550.GN20043@localhost>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860725-25202-3-git-send-email-Liviu.Dudau@arm.com>
 <20140814145804.GA5586@richard>
 <20140814154959.GG25761@e106497-lin.cambridge.arm.com>
 <20140815085632.GA4954@richard>
 <20140815103052.GD27553@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140815103052.GD27553@e106497-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 11:30:52AM +0100, Liviu Dudau wrote:
> On Fri, Aug 15, 2014 at 09:56:32AM +0100, Wei Yang wrote:
> > On Thu, Aug 14, 2014 at 04:49:59PM +0100, Liviu Dudau wrote:
> > >On Thu, Aug 14, 2014 at 03:58:04PM +0100, Wei Yang wrote:
> > >> On Tue, Aug 12, 2014 at 05:25:15PM +0100, Liviu Dudau wrote:
> > >> > int __weak pcibios_add_device(struct pci_dev *dev)
> > >> > {
> > >> >+	dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
> > >> >+
> > >> > 	return 0;
> > >> > }
> > >> 
> > >> For this, my suggestion is to add arch dependent function to setup the irq
> > >> line for pci devices. I can't find an obvious reason this won't work on other
> > >> archs, but maybe this will hurt some of them?
> > >
> > >I'm not sure I understand your point. Architectures that support OF will obviously
> > >benefit from this common approach, and for the other ones the function is empty
> > >so it will not change existing behaviour. If you are suggesting that I should
> > >create a new API that each architecture could go and implement for setting up the
> > >IRQ line then I would agree that it would be nice to have that, but the question
> > >is how many architectures are outside OF that need this?
> > 
> > My suggestion is to define the pcibios_add_device() for arm arch, like the one
> > in arch/powerpc/kernel/pci-common.c. If my understanding is correct, this
> > patch set address the pci bus setup mostly on arm arch.
> 
> And also arm64 at the least.
...
> Well, it will become necessary as old code gets dismantled and converted towards
> this patchset. To give you an example that I'm familiar with, for arch/arm the
> host bridge drivers have moved into drivers/pci/host, but they still depend/use
> the bios32 infrastructure that takes care of setting up the irq. When they switch
> to my version they would have to go and debug the "irq not being assigned" issue
> and it is quite likely that some of the people doing the conversion will complain
> about my code rather than understanding the issue. What I'm trying to do is to
> make switching to my patchset as painless as possible, with a cleanup to remove
> redundant operations coming after the switchover.

While the goal is fine, until we see a common pattern for what needs to
go into pcibios_add_device() I think we should have an arm64-specific
implementation (and probably an arm32 specific one as well). I can see
powerpc uses it for setting the DMA ops. Would we have a similar need on
arm64 to choose between coherent and non-coherent dma_ops?

Also at some point we'll get ACPI support, so I'm not sure what we do
with assigning the dev->irq here but definitely of_* functions won't
work.

-- 
Catalin
