Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaB0ObF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:31:05 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36697 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaB0ObD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:31:03 -0500
Date: Thu, 27 Feb 2014 14:30:59 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] pci: OF: Fix the conversion of IO ranges into IO
 resources.
Message-ID: <20140227143059.GN1692@e106497-lin.cambridge.arm.com>
Mail-Followup-To: "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com>
 <CAPcvp5EqcKEWoH_--azp+sMykmEWtY5whHG=c9t3sZVXZyAPUg@mail.gmail.com>
 <20140227135616.GK1692@e106497-lin.cambridge.arm.com>
 <7049275.SxVd47MEQ4@wuerfel>
MIME-Version: 1.0
In-Reply-To: <7049275.SxVd47MEQ4@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 27 Feb 2014 14:31:00.0207 (UTC) FILETIME=[89013FF0:01CF33C8]
X-MC-Unique: 114022714310106601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 02:08:44PM +0000, Arnd Bergmann wrote:
> On Thursday 27 February 2014 13:56:16 Liviu Dudau wrote:
> > On Thu, Feb 27, 2014 at 01:22:19PM +0000, Andrew Murray wrote:
> > > On 27 February 2014 13:06, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > > >
> > > > +/**
> > > > + * of_pci_range_to_resource - Create a resource from an of_pci_range
> > > > + * @range:     the PCI range that describes the resource
> > > > + * @np:                device node where the range belongs to
> > > > + * @res:       pointer to a valid resource that will be updated to
> > > > + *              reflect the values contained in the range.
> > > > + * Note that if the range is an IO range, the resource will be converted
> > > > + * using pci_address_to_pio() which can fail if it is called to early or
> > > > + * if the range cannot be matched to any host bridge IO space.
> > > > + */
> > > > +void of_pci_range_to_resource(struct of_pci_range *range,
> > > > +       struct device_node *np, struct resource *res)
> > > > +{
> > > > +       res->flags = range->flags;
> > > > +       if (res->flags & IORESOURCE_IO) {
> > > > +               unsigned long port;
> > > > +               port = pci_address_to_pio(range->pci_addr);
> > > 
> > > Is this likely to break existing users of of_pci_range_to_resource?
> > 
> > I've tested the change with a tegra2 based device (trimslice) and I've
> > got a functional board.
> 
> Did you have any devices using I/O ports though? They are fairly rare
> these days.

# cat /proc/ioports 
00001000-0000ffff : PCI0 I/O
  00001000-00001fff : PCI Bus 0000:01
    00001000-000010ff : 0000:01:00.0
      00001000-000010ff : r8169

Looks like it does.

Liviu

> 
> > > I have no idea if I/O previously worked for mips, but this patch seems
> > > to change that behavior. It may be a similar story for microblaze and
> > > powerpc.
> > 
> > Both microblaze and powerpc share an identical implementation and it is
> > expecting that the physical address passed as parameter fits between
> > io_base_phys and io_base_phys + pcibios_io_size(hose). So yes, the
> > correct way is to use cpu_addr and fix the weak implementation? But we
> > don't have enough information for the weak implementation to work, as
> > we don't know where the physical IO base start (we are just about to
> > find out from DT).
> 
> I think using pci_address_to_pio() at that point is just wrong
> in either way. Before the host is fully registered, you can't actually
> look up the port number -- you are only trying to assign one at this time.
> 
> The implementation that Will wrote for ARM would work here: find the
> next available virtual I/O range, call pci_ioremap_io on range->pci_addr
> and then return the virtual address. Unfortunately that code is not
> architecture independent at this time, and we will first have to come
> up with something that can be made to work for powerpc, microblaze,
> mips and arm.
> 
> 	Arnd
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

