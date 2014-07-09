Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaGIIcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:32:21 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:56064 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbaGIIcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:32:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v8 4/9] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Wed, 9 Jul 2014 10:31:50 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robherring2@gmail.com>, Sinan Kaya <okaya@codeaurora.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Device Tree ML <devicetree@vger.kernel.org>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Will Deacon <Will.Deacon@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <201407072322.00990.arnd@arndb.de> <20140708100332.GW6501@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140708100332.GW6501@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201407091031.50402.arnd@arndb.de>
X-Provags-ID: V02:K0:Yqh2qGy0AIOdhIy1P3HOaGO12iBLTggYlwSFXBIOnb8
 ggDPa1sBz/1NjTRLEVEAgMmcxbXztS0fNdBEjKLxtze59HDEjm
 xx/5jC7xpFu6U0u1Z8la+0ZkbXCXxlOJ7K+pmjTKMjmHFlGQky
 utmvOtTzovAmscbRKsuI2g0ffd11FV/u2sp0gd0dCmpmTYYpZu
 aJKlQb5naLqsMNGc+WDXMhQMZ5JuIba7zgYLA1seQ5hTfEVdBO
 Guma1oNISQUEd9KML3Y23vD4ZxETb+1NGbxVmrfavzDG9JIPgN
 JslmRXrGpmpUx1MVSML760OxgN0c1D13NF/qJit3ms/9M121cL
 E4e5dyvTOUiJTb+mGqJ2wZNOOlSF8pm1rYwtlmt5j
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2014, Liviu Dudau wrote:
> On Mon, Jul 07, 2014 at 10:22:00PM +0100, Arnd Bergmann wrote:
> > 
> > I looked at the other drivers briefly, and I think you indeed fix the Tegra
> > driver with this but break the integrator driver as mentioned above.
> > The other callers of of_pci_range_to_resource() are apparently not
> > impacted as they recalculate the values they get.
> 
> I would argue that integrator version is having broken assumptions. If it would
> try to allocate that IO range or request the resource as returned currently by
> of_pci_range_to_resource (without my patch) it would fail. I know because I did
> the same thing in my host bridge driver and it failed miserably. That's why I
> tried to patch it.

The integrator code was just introduced and the reason for how it does things
is the way that of_pci_range_to_resource() works today. We tried to cope with
it and not change the existing behavior in order to not break any other drivers.

It's certainly not fair to call the integrator version broken, it just works
around the common code having a quirky interface. We should probably have
done of_pci_range_to_resource better than it is today (I would have argued
for it to return an IORESOURCE_MEM with the CPU address), but it took long
enough to get that merged and I was sick of arguing about it.

> If the IO space is memory mapped, then we use the port number, the io_offset
> and the PCI_IOBASE to get to the virtual address that, when accessed, will
> generate the correct addresses on the bus, based on what the host bridge has
> been configured.
> 
> This is the current level of my understanding of PCI IO.

Your understanding is absolutely correct, and that's great because very few
people get that right. What I think we're really arguing about is what the
of_pci_range_to_resource is supposed to return. As you and Bjorn both pointed
out earlier, there are in fact two resources associated with the I/O window
and the flaw in the current implementation is that of_pci_range_to_resource
returns the numeric values for the IORESOURCE_MEM resource, but sets the
type to IORESOURCE_IO, which is offset from that by PCI_IOBASE.

You try to fix that by making it return the correct IORESOURCE_IO resource,
which is a reasonable approach but you must not break drivers that rely
on the broken resource while doing that.

The approach that I would have picked is to return the IORESOURCE_MEM
resource associated with the I/O window and pick a (basically random)
IORESOURCE_IO resource struct based on what hasn't been used and then
compute the appropriate io_offset from that. This approach of course
would also have required fixing up all drivers relying on the current
behavior.

To be clear, I'm fine with you (and Bjorn if he cares) picking the
approach you like here, either one of these works fine as long as the
host drivers use the interface in the way it is defined.

> Now, I believe Rob has switched entirely to using my series in some test that
> he has run and he hasn't encountered any issues, as long as one remembers in
> the host bridge driver to add the io_base offset to the .start resource. If
> not then I need to patch pci_v3.c.

The crazy part of all these discussions is that basically nobody ever uses
I/O port access, so it's very hard to test and we don't even notice when
we get it wrong, but we end up spending most of the time for PCI host controller
reviews trying to get these right.

I'm very thankful that you are doing this work to get it moved into common
code so hopefully this is the last time we ever have to worry about it because
all future drivers will be able to use the common implemnetation.

	Arnd
