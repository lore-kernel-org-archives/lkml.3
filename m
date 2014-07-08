Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaGHKVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:21:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38651 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaGHKV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:21:29 -0400
Date: Tue, 8 Jul 2014 11:21:21 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for
 pci_host_bridge.
Message-ID: <20140708102121.GY6501@e106497-lin.cambridge.arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
 <20140405000007.GD15806@google.com>
 <20140407084623.GG17163@e106497-lin.cambridge.arm.com>
 <1396862058.3671.40.camel@pasglop>
 <20140407100715.GI17163@e106497-lin.cambridge.arm.com>
 <CAErSpo7h+Yew2hBztzkOzcHU5r4OQebxFbcZGkNUwJwfTFsbfg@mail.gmail.com>
 <20140704145752.GJ6501@e106497-lin.cambridge.arm.com>
 <20140708011136.GE22939@google.com>
MIME-Version: 1.0
In-Reply-To: <20140708011136.GE22939@google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 08 Jul 2014 10:21:22.0199 (UTC) FILETIME=[5D87DA70:01CF9A96]
X-MC-Unique: 114070811212600401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 02:11:36AM +0100, Bjorn Helgaas wrote:
> On Fri, Jul 4, 2014 at 8:57 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > On Mon, Apr 07, 2014 at 11:44:51PM +0100, Bjorn Helgaas wrote:
> >> On Mon, Apr 7, 2014 at 4:07 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> >> > On Mon, Apr 07, 2014 at 10:14:18AM +0100, Benjamin Herrenschmidt wrote:
> >> >> On Mon, 2014-04-07 at 09:46 +0100, Liviu Dudau wrote:
> >> >> >
> >> >> > *My* strategy is to get rid of pci_domain_nr(). I don't see why we need
> >> >> > to have arch specific way of providing the number, specially after looking
> >> >> > at the existing implementations that return a value from a variable that
> >> >> > is never touched or incremented. My guess is that pci_domain_nr() was
> >> >> > created to work around the fact that there was no domain_nr maintainance in
> >> >> > the generic code.
> >> >>
> >> >> Well, there was no generic host bridge structure. There is one now, it should
> >> >> go there.
> >> >
> >> > Exactly! Hence my patch. After it gets accepted I will go through architectures
> >> > and remove their version of pci_domain_nr().
> >>
> >> Currently the arch has to supply pci_domain_nr() because that's the
> >> only way for the generic code to learn the domain.  After you add
> >> pci_create_root_bus_in_domain(), the arch can supply the domain that
> >> way, and we won't need the arch-specific pci_domain_nr().  Right?
> >> That makes more sense to me; thanks for the explanation.
> >>
> >> Let me try to explain my concern about the
> >> pci_create_root_bus_in_domain() interface.  We currently have these
> >> interfaces:
> >>
> >>   pci_scan_root_bus()
> >>   pci_scan_bus()
> >>   pci_scan_bus_parented()
> >>   pci_create_root_bus()
> >>
> >> pci_scan_root_bus() is a higher-level interface than
> >> pci_create_root_bus(), so I'm trying to migrate toward it because it
> >> lets us remove a little code from the arch, e.g., pci_scan_child_bus()
> >> and pci_bus_add_devices().
> >>
> >> I think we can only remove the arch-specific pci_domain_nr() if that
> >> arch uses pci_create_root_bus_in_domain().  When we convert an arch
> >> from using scan_bus interfaces to using
> >> pci_create_root_bus_in_domain(), we will have to move the rest of the
> >> scan_bus code (pci_scan_child_bus(), pci_bus_add_devices()) back into
> >> the arch code.
> >>
> >> One alternative is to add an _in_domain() variant of each of these
> >> interfaces, but that doesn't seem very convenient either.  My idea of
> >> passing in a structure would also require adding variants, so there's
> >> not really an advantage there, but I am thinking of the next
> >> unification effort, e.g., for NUMA node info.  I don't really want to
> >> have to change all the _in_domain() interfaces to also take yet
> >> another parameter for the node number.
> >
> > ...
> > My understanding is that when pci_host_bridge structure was introduced
> > you were trying to keep the APIs unchanged and hence the creation of a
> > bridge was hidden inside the pci_create_root_bus() function.
> 
> You mean pci_alloc_host_bridge()?  Right; ideally I would have used
> pci_scan_root_bus() everywhere and gotten rid of pci_create_root_bus().
> The outline of pci_scan_root_bus() is:
> 
>     pci_create_root_bus()
>     pci_scan_child_bus()
>     pci_bus_add_devices()
> 
> The problem was that several arches do interesting things scattered among
> that core.  The ACPI host bridge driver used on x86 and ia64 does resource
> allocation before pci_bus_add_devices(), as does parisc.  Probably all
> arches should do this, but they don't.
> 
> And powerpc and sparc use of_scan_bus() or something similar instead of
> pci_scan_child_bus().  They probably *could* provide config space accessors
> that talk to OF and would allow pci_scan_child_bus() to work.  But that
> seemed like too much work at the time.
> 
> > If we want to store the domain_nr information in the host bridge structure,
> > together with a pointer to sysdata, then we need to break up the creation
> > of the pci_host_bridge from the creation of a root bus. At that moment,
> > pci_scan_root_bus() will need to be changed to accept a pci_host_bridge
> > pointer, while pci_scan_bus() and pci_scan_bus_parented() will create
> > the host bridge in the body of their function.
> 
> It's hard to change an existing interface like pci_scan_root_bus() because
> it's called from so many places and you have to change them all at once.
> Then if something goes wrong, the revert makes a mess for everybody.  But
> I think it makes sense to add a new interface that does what you want.

OK, I understand your concern. It does sort of return us back to the initial
discussion, where you were arguing against adding a new set of functions
for every existing function, but it makes sense from transition point of view.

Best regards,
Liviu

> 
> Bjorn
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

