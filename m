Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934515AbaDJB0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 21:26:55 -0400
Received: from dliviu.plus.com ([80.229.23.120]:43878 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933251AbaDJB0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 21:26:53 -0400
From: "Liviu Dudau" <liviu@dudau.co.uk>
Date: Thu, 10 Apr 2014 02:27:16 +0100
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
Message-ID: <20140410012715.GA1328@bart>
Mail-Followup-To: Bjorn Helgaas <bhelgaas@google.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
 <20140405000007.GD15806@google.com>
 <20140407084623.GG17163@e106497-lin.cambridge.arm.com>
 <1396862058.3671.40.camel@pasglop>
 <20140407100715.GI17163@e106497-lin.cambridge.arm.com>
 <CAErSpo7h+Yew2hBztzkOzcHU5r4OQebxFbcZGkNUwJwfTFsbfg@mail.gmail.com>
 <20140408102043.GV17163@e106497-lin.cambridge.arm.com>
 <CAErSpo4anYBmaRbJEFE9kAXSmnvfqud=w1QA=mSSsTUamM4kSw@mail.gmail.com>
 <20140409120750.GN985@e106497-lin.cambridge.arm.com>
 <CAErSpo4BmoYzf6GxOPRni=q563zhON57s7=5Hz=2Cf-X2ft-1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo4BmoYzf6GxOPRni=q563zhON57s7=5Hz=2Cf-X2ft-1A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu Apr 10 02:26:51 2014
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 13,5345f35b215641226716310
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 08:02:41AM -0600, Bjorn Helgaas wrote:
> On Wed, Apr 9, 2014 at 6:07 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > On Tue, Apr 08, 2014 at 05:28:39PM +0100, Bjorn Helgaas wrote:
> >> On Tue, Apr 8, 2014 at 4:20 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> >> > On Mon, Apr 07, 2014 at 11:44:51PM +0100, Bjorn Helgaas wrote:
> >>
> >> >> Let me try to explain my concern about the
> >> >> pci_create_root_bus_in_domain() interface.  We currently have these
> >> >> interfaces:
> >> >>
> >> >>   pci_scan_root_bus()
> >> >>   pci_scan_bus()
> >> >>   pci_scan_bus_parented()
> >> >>   pci_create_root_bus()
> >> >> ...
> >>
> >> >> One alternative is to add an _in_domain() variant of each of these
> >> >> interfaces, but that doesn't seem very convenient either.  My idea of
> >> >> passing in a structure would also require adding variants, so there's
> >> >> not really an advantage there, but I am thinking of the next
> >> >> unification effort, e.g., for NUMA node info.  I don't really want to
> >> >> have to change all the _in_domain() interfaces to also take yet
> >> >> another parameter for the node number.
> >> >
> >> > OK, what about this: all the functions that you have mentioned take a
> >> > void *sysdata parameter. Should we convert this opaque pointer into a
> >> > specific structure that holds the domain_nr and (in future) the NUMA
> >> > node info?
> >>
> >> I doubt if we can make sysdata itself generic because I suspect we
> >> need a way to have *some* arch-specific data.  But maybe the arch
> >> could supply a structure containing a struct device *, domain, struct
> >> pci_ops *, list of resources, aperture info, etc.  I wonder if struct
> >> pci_host_bridge would be a reasonable place to put this stuff, e.g.,
> >> something like this:
> >>
> >>   struct pci_host_bridge {
> >>     int domain;
> >>     int node;
> >>     struct device *dev;
> >>     struct pci_ops *ops;
> >>     struct list_head resources;
> >>     void *sysdata;
> >>     struct pci_bus *bus;  /* filled in by core, not by arch */
> >>     ... /* other existing contents managed by core */
> >>   };
> >>
> >>   struct pci_bus *pci_scan_host_bridge(struct pci_host_bridge *bridge);
> >
> > I'm really reluctant to give the arches more rope to hang themselves.
> 
> If you mean the sysdata pointer is rope to hang themselves, I think it
> would be great it we didn't need sysdata at all.  But I think it would
> be a huge amount of work to get rid of it completely, and keeping it
> would let us work at that incrementally.

Agree. But then your suggestion was to wrap sysdata inside another structure,
which to me constitutes additional rope.

> 
> > I
> > really dislike the use of xxxx_initcall() to do PCI initialisation ordering
> > that is currently in widespread use through the arch code.
> 
> I certainly agree that initcall ordering is fragile and to be avoided
> when possible.
> 
> > As I hope to
> > have proven with my arm64 code, you can have PCI support for an architecture
> > without having to provide any arch specific code. We have enough correct
> > code in the PCI framework, what would the architectures provide to the generic
> > code that we cannot get by following the standard?
> 
> PCI host bridges are not architected, i.e., the PCI/PCIe specs do not
> say anything about how to discover them or how to program them.  So
> the arch or a driver for another bus (ACPI, OF, etc.) must enumerate
> them and discover the bridge apertures (those are in the resource
> list).  And obviously the arch has to provide the root bus number and
> PCI config accessors.

The "what" for PCI host bridges is defined in the spec. The "how" is implementation
defined. What I'm trying to get with the cleanup is the ordering of pci_host_bridge
creation: core creates the structure first ("what"), arch then has the chance
of adding specific data to it (ops, resources, etc) ("how").

At the moment arm and powerpc do some horrible dances in trying to create their
local idea of a host bridge before passing it to the core code.

As for the root bus number, maybe we can offer some sensible default strategy
for numbering them and the arches that don't care too much can use that.

> 
> > Of course, there are always arch specific corners and they need their data
> > structures to make sense of those, but rather than having architectures
> > fill in a structure *before* we can setup host bridges I think we need
> > to reverse the order. Using your example structure, I don't think is
> > the arch's job to provide the list of resources or the domain number
> > before we can scan the host bridge. We should be able to get those from
> > somewhere else (like adding by default the ioport_resource and
> > iomem_resource and managing domain numbers inside the core framework).
> 
> It's possible we could manage domain numbers in the core.  On ACPI
> systems, we currently we use the ACPI _SEG value as the domain.  In
> some cases, e.g., on ia64, config space access is done via firmware
> interfaces, and those interfaces expect the _SEG values.  We could
> conceivably maintain a mapping between _SEG and domain, but I'm not
> sure there's an advantage there.
> 
> I probably don't understand what you intend by reversing the order.
> Are you suggesting something like new pcibios_*() interfaces the arch
> can use to get the host bridge apertures and domain number?

Yes. Lets stop having the architectures do early inits so that they can
prepare their host bridge structures to be ready for when the PCI framework
calls them. Lets create the host bridge in the PCI core and use pcibios_*()
to add to it where necessary without having to race for position.

Best regards,
Liviu

> 
> Bjorn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...

