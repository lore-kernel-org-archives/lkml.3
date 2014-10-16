Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaJPCzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 22:55:55 -0400
Received: from ozlabs.org ([103.22.144.67]:55031 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbaJPCzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 22:55:53 -0400
Message-ID: <1413428148.20705.2.camel@concordia>
Subject: Re: of/pci: Fix the conversion of IO ranges into IO resources
From: Michael Ellerman <mpe@ellerman.id.au>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>
Date: Thu, 16 Oct 2014 13:55:48 +1100
In-Reply-To: <20141015090239.GB18070@e106497-lin.cambridge.arm.com>
References: <20141009200235.55E5166107E@gitolite.kernel.org>
	 <1413358507.4748.4.camel@pasglop>
	 <20141015090239.GB18070@e106497-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-15 at 10:02 +0100, Liviu Dudau wrote:
> On Wed, Oct 15, 2014 at 08:35:07AM +0100, Benjamin Herrenschmidt wrote:
> > On Thu, 2014-10-09 at 20:02 +0000, Linux Kernel Mailing List wrote:
> > > Gitweb:     http://git.kernel.org/linus/;a=commit;h=0b0b0893d49b34201a6c4416b1a707b580b91e3d
> > > Commit:     0b0b0893d49b34201a6c4416b1a707b580b91e3d
> > > Author:     Liviu Dudau <Liviu.Dudau@arm.com>
> > > Committer:  Bjorn Helgaas <bhelgaas@google.com>
> > >
> > >     of/pci: Fix the conversion of IO ranges into IO resources
> > >
> > >     The ranges property for a host bridge controller in DT describes the
> > >     mapping between the PCI bus address and the CPU physical address.  The
> > >     resources framework however expects that the IO resources start at a pseudo
> > >     "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.  The
> > >     conversion from PCI ranges to resources failed to take that into account,
> > >     returning a CPU physical address instead of a port number.
> > >
> > >     Also fix all the drivers that depend on the old behaviour by fetching the
> > >     CPU physical address based on the port number where it is being needed.
> > 
> > Michael just signaled me that this completely breaks IO space on powerpc ...
> 
> Hi Benjamin,
> 
> I'm sorry to hear that I've broke powerpc before I've had a chance to actually
> change the code there. I would like to get the details of what functionality
> get broken.

You changed code that arch/powerpc depends on, without updating it, or even
CC'ing us on the patches. I'm not sure what you mean by "before I've had a
chance to actually change the code there" - it's too late.

> The pci_register_io_range() function (the "allocator" for IO space) is a
> weak function. It takes the CPU physical address of the range and its size
> and makes sure that it can fit that area in the arch's space for PCI IO.
> The main purpose of that function is to be a helper to pci_address_to_pio()
> in order to help return the correct answer in that function. pci_address_to_pio()
> is also weak and can be overwritten.

Yes, we already provide our own version of pci_address_to_pio().

The problem is it's too early to call it when we come in from
find_and_init_phbs() -> pci_process_bridge_OF_ranges(), so it returns junk.

I think you were expecting us to hit the #ifndef PCI_IOBASE case, which looks
like it might have worked.

For now we're just going to stop using of_pci_range_to_resource().

cheers



