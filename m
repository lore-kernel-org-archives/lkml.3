Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaJPJFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:05:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57538 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaJPJFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:05:34 -0400
Date: Thu, 16 Oct 2014 10:05:29 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: Re: of/pci: Fix the conversion of IO ranges into IO resources
Message-ID: <20141016090529.GG4599@e106497-lin.cambridge.arm.com>
References: <20141009200235.55E5166107E@gitolite.kernel.org>
 <1413358507.4748.4.camel@pasglop>
 <20141015090239.GB18070@e106497-lin.cambridge.arm.com>
 <1413428148.20705.2.camel@concordia>
MIME-Version: 1.0
In-Reply-To: <1413428148.20705.2.camel@concordia>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 16 Oct 2014 09:05:29.0865 (UTC) FILETIME=[556FCF90:01CFE920]
X-MC-Unique: 114101610053104201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 03:55:48AM +0100, Michael Ellerman wrote:
> On Wed, 2014-10-15 at 10:02 +0100, Liviu Dudau wrote:
> > On Wed, Oct 15, 2014 at 08:35:07AM +0100, Benjamin Herrenschmidt wrote:
> > > On Thu, 2014-10-09 at 20:02 +0000, Linux Kernel Mailing List wrote:
> > > > Gitweb:     http://git.kernel.org/linus/;a=commit;h=0b0b0893d49b34201a6c4416b1a707b580b91e3d
> > > > Commit:     0b0b0893d49b34201a6c4416b1a707b580b91e3d
> > > > Author:     Liviu Dudau <Liviu.Dudau@arm.com>
> > > > Committer:  Bjorn Helgaas <bhelgaas@google.com>
> > > >
> > > >     of/pci: Fix the conversion of IO ranges into IO resources
> > > >
> > > >     The ranges property for a host bridge controller in DT describes the
> > > >     mapping between the PCI bus address and the CPU physical address.  The
> > > >     resources framework however expects that the IO resources start at a pseudo
> > > >     "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.  The
> > > >     conversion from PCI ranges to resources failed to take that into account,
> > > >     returning a CPU physical address instead of a port number.
> > > >
> > > >     Also fix all the drivers that depend on the old behaviour by fetching the
> > > >     CPU physical address based on the port number where it is being needed.
> > > 
> > > Michael just signaled me that this completely breaks IO space on powerpc ...
> > 
> > Hi Benjamin,
> > 
> > I'm sorry to hear that I've broke powerpc before I've had a chance to actually
> > change the code there. I would like to get the details of what functionality
> > get broken.
> 

Hi Michael,

> You changed code that arch/powerpc depends on, without updating it, or even
> CC'ing us on the patches. I'm not sure what you mean by "before I've had a
> chance to actually change the code there" - it's too late.

Sorry, I meant without directly changing the code in arch/powerpc. And I do appologise
for not CC-ing you on the patches. I believe (hope) Benjamin has been on CC for several
revisions, but I know he is very busy and he has told me so.

> 
> > The pci_register_io_range() function (the "allocator" for IO space) is a
> > weak function. It takes the CPU physical address of the range and its size
> > and makes sure that it can fit that area in the arch's space for PCI IO.
> > The main purpose of that function is to be a helper to pci_address_to_pio()
> > in order to help return the correct answer in that function. pci_address_to_pio()
> > is also weak and can be overwritten.
> 
> Yes, we already provide our own version of pci_address_to_pio().
> 
> The problem is it's too early to call it when we come in from
> find_and_init_phbs() -> pci_process_bridge_OF_ranges(), so it returns junk.
> 
> I think you were expecting us to hit the #ifndef PCI_IOBASE case, which looks
> like it might have worked.

That's correct. Unfortunately I lack access to a PowerPC platform with PCI(e) that I can
test my patches on, so most of my testing has been compile tests. Also, due to the
similarities in code between powerpc and microblaze in this area I hoped that focusing
on the simpler microblaze would be faster, until I run into the brick wall of not being
able to source an FPGA image for the test platform I have that contains all the relevant
bits compiled in.

> 
> For now we're just going to stop using of_pci_range_to_resource().

So you are going to continue converting IO ranges as IORESOURCE_MEM resources but with a
different flag. Is that something that powerpc depends on or is it an artifact of too
much code living around the kernel that has built in assumption of that being the fact?
I'm trying to understand the world around powerpc so as to attempt to make a useful
contribution in the future.

Best regards,
Liviu

> 
> cheers
> 
> 
> 
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

