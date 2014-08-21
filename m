Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaHUSC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:02:28 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:37102 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaHUSCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:02:25 -0400
Date: Thu, 21 Aug 2014 12:02:16 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Liviu Dudau <liviu@dudau.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH] drivers: pci: convert generic host controller to DT host
 bridge creation API
Message-ID: <20140821180216.GA15311@google.com>
References: <1407861695-25549-1-git-send-email-Liviu.Dudau@arm.com>
 <201408201327.57376.arnd@arndb.de>
 <20140820123112.GG13147@bart.dudau.co.uk>
 <CAErSpo6Z4b3w7j=X9C1YGOV59JHZwZUt7pnVp+Z0erY2RLCNAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6Z4b3w7j=X9C1YGOV59JHZwZUt7pnVp+Z0erY2RLCNAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Lorenzo]

On Wed, Aug 20, 2014 at 05:35:59PM -0500, Bjorn Helgaas wrote:
> On Wed, Aug 20, 2014 at 7:31 AM, Liviu Dudau <liviu@dudau.co.uk> wrote:
> > On Wed, Aug 20, 2014 at 01:27:57PM +0200, Arnd Bergmann wrote:
> >> On Tuesday 12 August 2014, Liviu Dudau wrote:
> >> > +       return of_create_pci_host_bridge(dev, 0, 0xff, &gen_pci_ops,
> >> > +                                       gen_pci_setup, pci);
> >>
> >> I had not noticed it earlier, but the setup callback is actually a feature
> >> of the arm32 PCI code that I had hoped to avoid when moving to the
> >> generic API. Can we do this as a more regular sequence of
> >>
> >>
> >>       ret = of_create_pci_host_bridge(dev, 0, 0xff, &gen_pci_ops, pci);
> >>       if (ret)
> >>               return ret;
> >>
> >>       ret = gen_pci_setup(pci);
> >>       if (ret)
> >>               pci_destroy_host_bridge(dev, pci);
> >>       return ret;
> >>
> >> ?
> >>
> >>       Arnd
> >
> > Hi Arnd,
> >
> > That has been the general approach of my patchset up to v9. But, as Bjorn has
> > mentioned in his v8 review and I have put in my cover letter, the regular
> > aproach means that architectures that use pci_scan_root_bus() will have to
> > drop their one liner and replace it with the more verbose of_create_pci_host_bridge()
> > followed by pci_scan_child_bus() and pci_bus_add_devices() (basically, the content
> > of pci_scan_root_bus()). For those architectures it will lead to a net increase of
> > lines of code.
> >
> > The patch for pci-host-generic.c is the first to use the callback setup function, but
> > not the only one. My PCI host bridge driver for Juno has the same need, and I'm betting
> > all other host bridge controllers will use it as it will be the only opportunity to
> > finish the controller setup before we start scanning the child busses. I'm trying to
> > balance ease of read vs ease of use here and it is the best version I've come up with
> > so far.
> 
> My guess is that you're referring to
> http://lkml.kernel.org/r/20140708011136.GE22939@google.com
> 
> I'm trying to get to the point where arch code can discover the host
> bridge, configure it, learn its properties (apertures, etc.), then
> pass it off completely to the PCI core for PCI device enumeration.
> pci_scan_root_bus() is the closest thing we have to that right now, so
> that's why I point to that.  Here's the current pci_scan_root_bus():
> 
>   pci_scan_root_bus()
>   {
>     pci_create_root_bus();
>     /* 1 */
>     pci_scan_child_bus()
>     /* 2 */
>     pci_bus_add_devices()
>   }
> 
> This is obviously incomplete as it is -- for example, it does nothing
> about assigning resources to PCI devices, so it only works if we rely
> completely on the firmware to do that.  Some arches (x86, ia64, etc.)
> don't want to rely on firmware, so they basically open-code
> pci_scan_root_bus() and insert resource assignment at (2) above.  That
> resource assignment really *should* be done in pci_scan_root_bus()
> itself, but it's quite a bit of work to make that happen.
> 
> In your case, of_create_pci_host_bridge() open-codes
> pci_scan_root_bus() and calls the "setup" callback at (1) in the
> outline above.  I don't have any problem with that, and I don't care
> whether you do it by passing in a callback function pointer or via
> some other means.
> 
> However, I would ask whether this is really a requirement.  Most
> (maybe all) other arches require nothing special at (1), i.e., between
> pci_create_root_bus() and pci_scan_child_bus().  If you can do it
> *before* pci_create_root_bus(), I think that would be nicer, but maybe
> you can't.

I talked to Lorenzo here at LinuxCon and he explained this so it makes a
lot more sense to me now.  Would something like the following work?

  gen_pci_probe()
  {
    LIST_HEAD(res);
    resource_size_t io_base = 0;

    of_parse_pci_host_bridge_resources(dev, &res, 0, 0xff, &io_base);
    gen_pci_setup(&res, io_base);

    pci_create_root_bus(..., &res);
    pci_scan_child_bus();
    ... pci_assign_unassigned_bus_resources
    pci_bus_add_resources();
  }

Then we at least have all the PCI-related code consolidated, without
the arch-specific stuff mixed in.  We could almost use pci_scan_root_bus(),
but not quite, because of the pci_assign_unassigned_bus_resources() call
that pci_scan_root_bus() doesn't do.

Bjorn
