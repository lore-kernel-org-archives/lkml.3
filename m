Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaF0OPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:15:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:35175 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752845AbaF0OPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:15:13 -0400
Date: Fri, 27 Jun 2014 15:14:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jon Masters <jonathan@jonmasters.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140627141451.GJ15296@arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <20140405001953.GE15806@google.com>
 <20140407083120.GE17163@e106497-lin.cambridge.arm.com>
 <5183143.FxBNM0xTAV@wuerfel>
 <CAErSpo4iEV6khP63ZTF+YUTKi9WLFXzMv13nxw15y3qDg15Ztg@mail.gmail.com>
 <20140626085926.GB11244@arm.com>
 <CAL_JsqKCHf6VXR3FFcBSu1xuhP54dYsAJCZwT-X9p5iTZAOJfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKCHf6VXR3FFcBSu1xuhP54dYsAJCZwT-X9p5iTZAOJfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 01:44:21AM +0100, Rob Herring wrote:
> On Thu, Jun 26, 2014 at 3:59 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > Although a bit late, I'm raising this now and hopefully we'll come to a
> > conclusion soon. Delaying arm64 PCIe support even further is not a real
> > option, which leaves us with:
> >
> > 1. Someone else (with enough PCIe knowledge) volunteering to take over
> >    soon or
> > 2. Dropping Liviu's work and going for an arm64-specific implementation
> >    (most likely based on the arm32 implementation, see below)
> 
> 3. Keeping Liviu's patches leaving some of the architecture specific
> bits. I know Arnd and I both commented on it still needing more common
> pieces, but compared to option 2 that would be way better.
> 
> Let's look at the patches in question:
> 
> 3e71867 pci: Introduce pci_register_io_range() helper function.
> 6681dff pci: OF: Fix the conversion of IO ranges into IO resources.
> 
> Both OF patches. I'll happily merge them.

We just need to make sure they don't break other users of
of_pci_range_to_resource() that the second patch introduces.

> 2d5dd85 pci: Create pci_host_bridge before its associated bus in
> pci_create_root_bus.
> f6f2854 pci: Introduce a domain number for pci_host_bridge.
> 524a9f5 pci: Export find_pci_host_bridge() function.
> 
> These don't seem to be too controversial.

I think here there were discussions around introducing domain_nr to
pci_host_bridge, particularly to the pci_create_root_bus_in_domain() API
change. I don't think we reached any conclusion.

> fb75718 pci: of: Parse and map the IRQ when adding the PCI device.
> 
> 6 LOC. Hardly controversial.

I agree.

> 920a685 pci: Add support for creating a generic host_bridge from device tree
> 
> This function could be moved to drivers/of/of_pci.c if having it in
> drivers/pci is too much maintenance burden.

I think it makes sense. Currently drivers/pci/host-bridge.c doesn't have
anything OF related, so of_pci.c looks more appropriate.

> However, nearly the same
> code is already being duplicated in every DT enabled ARM PCI host
> driver and will continue as more PCI hosts are added. So this isn't
> really a question of converting other architectures to common PCI host
> infrastructure, but converting DT based PCI hosts to common
> infrastructure. ARM is the only arch moving host drivers to
> drivers/pci ATM. Until other architectures start doing that,
> converting them is pointless.

I agree. It's probably more important to convert some of the
drivers/pci/host implementations to using the common parsing rather than
a new architecture (this way we avoid even more code duplication).

> bcf5c10 Fix ioport_map() for !CONFIG_GENERIC_IOMAP cases.
> 
> Seems like an independent fix that should be applied regardless.

Indeed. But it got stuck at the top of this series and hasn't been
pushed upstream.

> 7cfde80 arm64: Add architecture support for PCI
> 
> What is here is really just a function of which option we pick.

With Liviu's latest version (not posted) and with
of_create_pci_host_bridge() function moved to of_pci.c, I don't think
there is much new functionality added to drivers/pci/. What I think we
need is clarifying the domain_nr patch (and API change) and more users
of the new generic code. As you said, it doesn't need to be a separate
architecture but rather existing pci host drivers under drivers/pci. Of
course, other arch conversion should follow shortly as well but even
without an immediate conversion, I don't see too much additional
maintenance burden for the core PCIe code (and code sharing between new
PCIe host drivers is even more beneficial).

-- 
Catalin
