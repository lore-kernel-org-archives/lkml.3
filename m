Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965166AbaDJDsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:48:41 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40158 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935123AbaDJDsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:48:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140410012715.GA1328@bart>
References: <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
 <20140405000007.GD15806@google.com> <20140407084623.GG17163@e106497-lin.cambridge.arm.com>
 <1396862058.3671.40.camel@pasglop> <20140407100715.GI17163@e106497-lin.cambridge.arm.com>
 <CAErSpo7h+Yew2hBztzkOzcHU5r4OQebxFbcZGkNUwJwfTFsbfg@mail.gmail.com>
 <20140408102043.GV17163@e106497-lin.cambridge.arm.com> <CAErSpo4anYBmaRbJEFE9kAXSmnvfqud=w1QA=mSSsTUamM4kSw@mail.gmail.com>
 <20140409120750.GN985@e106497-lin.cambridge.arm.com> <CAErSpo4BmoYzf6GxOPRni=q563zhON57s7=5Hz=2Cf-X2ft-1A@mail.gmail.com>
 <20140410012715.GA1328@bart>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 9 Apr 2014 21:48:14 -0600
Message-ID: <CAErSpo7egL2T_W_OCJw2kPHFDqspwOHXtZJw8JyjWU=56ofFKQ@mail.gmail.com>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for pci_host_bridge.
To: Bjorn Helgaas <bhelgaas@google.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 7:27 PM, Liviu Dudau <liviu@dudau.co.uk> wrote:
> On Wed, Apr 09, 2014 at 08:02:41AM -0600, Bjorn Helgaas wrote:
>> On Wed, Apr 9, 2014 at 6:07 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>> > On Tue, Apr 08, 2014 at 05:28:39PM +0100, Bjorn Helgaas wrote:
>> >> On Tue, Apr 8, 2014 at 4:20 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>> >> > On Mon, Apr 07, 2014 at 11:44:51PM +0100, Bjorn Helgaas wrote:
>> >>
>> >> >> Let me try to explain my concern about the
>> >> >> pci_create_root_bus_in_domain() interface.  We currently have these
>> >> >> interfaces:
>> >> >>
>> >> >>   pci_scan_root_bus()
>> >> >>   pci_scan_bus()
>> >> >>   pci_scan_bus_parented()
>> >> >>   pci_create_root_bus()
>> >> >> ...
>> >>
>> >> >> One alternative is to add an _in_domain() variant of each of these
>> >> >> interfaces, but that doesn't seem very convenient either.  My idea of
>> >> >> passing in a structure would also require adding variants, so there's
>> >> >> not really an advantage there, but I am thinking of the next
>> >> >> unification effort, e.g., for NUMA node info.  I don't really want to
>> >> >> have to change all the _in_domain() interfaces to also take yet
>> >> >> another parameter for the node number.
>> >> >
>> >> > OK, what about this: all the functions that you have mentioned take a
>> >> > void *sysdata parameter. Should we convert this opaque pointer into a
>> >> > specific structure that holds the domain_nr and (in future) the NUMA
>> >> > node info?
>> >>
>> >> I doubt if we can make sysdata itself generic because I suspect we
>> >> need a way to have *some* arch-specific data.  But maybe the arch
>> >> could supply a structure containing a struct device *, domain, struct
>> >> pci_ops *, list of resources, aperture info, etc.  I wonder if struct
>> >> pci_host_bridge would be a reasonable place to put this stuff, e.g.,
>> >> something like this:
>> >>
>> >>   struct pci_host_bridge {
>> >>     int domain;
>> >>     int node;
>> >>     struct device *dev;
>> >>     struct pci_ops *ops;
>> >>     struct list_head resources;
>> >>     void *sysdata;
>> >>     struct pci_bus *bus;  /* filled in by core, not by arch */
>> >>     ... /* other existing contents managed by core */
>> >>   };
>> >>
>> >>   struct pci_bus *pci_scan_host_bridge(struct pci_host_bridge *bridge);
>> >
>> > I'm really reluctant to give the arches more rope to hang themselves.
>>
>> If you mean the sysdata pointer is rope to hang themselves, I think it
>> would be great it we didn't need sysdata at all.  But I think it would
>> be a huge amount of work to get rid of it completely, and keeping it
>> would let us work at that incrementally.
>
> Agree. But then your suggestion was to wrap sysdata inside another structure,
> which to me constitutes additional rope.

I'll ponder this more, but I don't see your point here yet.  The arch
already supplies a sysdata pointer to pci_scan_root_bus(), and we
stash it in every struct pci_bus already.  My idea was just to pass it
in differently, as a structure member rather than a separate argument.
 (And I'm not completely attached to my proposal; it was only to
illustrate my concern about the explosion of interfaces if we have to
add *_domain(), *_node(), etc.)

> The "what" for PCI host bridges is defined in the spec. The "how" is implementation
> defined. What I'm trying to get with the cleanup is the ordering of pci_host_bridge
> creation: core creates the structure first ("what"), arch then has the chance
> of adding specific data to it (ops, resources, etc) ("how").
>
> At the moment arm and powerpc do some horrible dances in trying to create their
> local idea of a host bridge before passing it to the core code.
>
> As for the root bus number, maybe we can offer some sensible default strategy
> for numbering them and the arches that don't care too much can use that.

I think we're at the limit of what can be accomplished with the
abstractness of English.

My opinion is that it's reasonable for the arch to discover the host
bridge properties first and pass them to the core, and it doesn't
require unreasonable things of the arch.  I know the arm PCI setup is
complicated, partly because it deals with a huge number of machines
that don't have a consistent firmware interface.  The x86/ACPI setup
is relatively simple because it deals with a simple firmware
interface.  But that's just my opinion, and maybe your code will show
otherwise.

Bjorn
