Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaJPK2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:28:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46692 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaJPK2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:28:47 -0400
Date: Thu, 16 Oct 2014 11:28:33 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>
Subject: Re: of/pci: Fix the conversion of IO ranges into IO resources
Message-ID: <20141016102833.GL4599@e106497-lin.cambridge.arm.com>
References: <20141009200235.55E5166107E@gitolite.kernel.org>
 <1413358507.4748.4.camel@pasglop>
 <20141015090239.GB18070@e106497-lin.cambridge.arm.com>
 <1413428148.20705.2.camel@concordia>
 <20141016090529.GG4599@e106497-lin.cambridge.arm.com>
 <1413453882.11213.95.camel@pasglop>
MIME-Version: 1.0
In-Reply-To: <1413453882.11213.95.camel@pasglop>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 16 Oct 2014 10:28:34.0349 (UTC) FILETIME=[F06BB5D0:01CFE92B]
X-MC-Unique: 114101611284007601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:04:42AM +0100, Benjamin Herrenschmidt wrote:
> On Thu, 2014-10-16 at 10:05 +0100, Liviu Dudau wrote:
> > So you are going to continue converting IO ranges as IORESOURCE_MEM resources but with a
> > different flag. Is that something that powerpc depends on or is it an artifact of too
> > much code living around the kernel that has built in assumption of that being the fact?
> > I'm trying to understand the world around powerpc so as to attempt to make a useful
> > contribution in the future.
> 
> I'm not sure I understand what you mean and which specific resources you
> are talking about.
> 
> For PCI devices, the IO BAR resources have IORESOURCE_IO ... 

Correct. But the old version of of_pci_range_to_resource() and the powerpc opencoded
version generate the same .start .end values for an IO range as it would for an
MEM range, just the type of resource is different.

Like I've said before and also put down in the commit message for 0b0b0893d49b, my
understanding of the way Linux uses IORESOURCE_IO resources is that they are supposed
to be based on the "magic port address 0." Nothing wrong with saying that powerpc
sees IORESOURCE_IO as being something capable of covering the entire CPU address
space, but ARM based architectures have decided to use an offset value for .start and
.end and to base IO starting from PCI_IOBASE (which is what the macro signals).

I'm just trying to understand how things stand here, I'm not starting a polemic.

> 
> The case where we might get an IORESOURCE_MEM, at least that's how my old
> code used to work, was is if we try to use the device-tree to convert a
> PCI IO device address before we have initialized our mappings (ie, before
> we have probed our PCI host bridges).

Although we might be cross-talking here, I would like to understand better this case.
What do you mean by "use the device-tree to convert a PCI IO device address" ? Are
you trying to do IO transactions before PCI host brige was setup?

> 
> In that case, we would get an IORESOURCE_MEM (which is functional as long
> as one ioremap's and uses the proper accessors for memory resources).
> 
> Once we have the PCI host bridges probed, the IO space is assigned, and
> such conversion routines will transform the addresses properly into IO
> resources.

The way I'm leaning to is to get everyone towards the following workflow:
  - gather PCI resources describing the host bridge address space (IO + MEM)
  - (future) create a struct pci_host_bridge that holds those resources
    plus any other information that might be required for successfully
    scanning the root bus
  - (in driver) create a host bridge struct to hold driver specific data
  - create root bus passing on the driver host bridge struct and (in future)
    the pci_host_bridge structure
  - scan root bus.

Is this workflow going to be useful to powerpc or is there something missing
here?

> 
> Note that it's fairly rare that we use the device-tree for PCI based
> resources anyway and even rarer than we do that before the PCI host
> bridges have been properly setup and thus their IO space allocated.
> 
> Note that the problems exposed by these patches can be entirely reproduced
> in qemu using virtio, so you should be able to test a little bit if you
> have a reasonably fast x86 box to run qemu on.

Which host bridge/device(s) do I need to tell qemu to emulate/pass through?
Do you have a wiki/README page where I can get details on how to setup a
test environment with powerpc-qemu + virtio + PCIe?

Best regards,
Liviu

> 
> Cheers,
> Ben.
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

