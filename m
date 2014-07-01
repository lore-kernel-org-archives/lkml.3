Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625AbaGAQh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:37:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49603 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758283AbaGAQhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:37:55 -0400
Date: Tue, 1 Jul 2014 17:37:51 +0100
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
Message-ID: <20140701163751.GW2173@e106497-lin.cambridge.arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com>
 <20140405000007.GD15806@google.com>
 <20140407084623.GG17163@e106497-lin.cambridge.arm.com>
 <1396862058.3671.40.camel@pasglop>
 <20140407100715.GI17163@e106497-lin.cambridge.arm.com>
 <CAErSpo7h+Yew2hBztzkOzcHU5r4OQebxFbcZGkNUwJwfTFsbfg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAErSpo7h+Yew2hBztzkOzcHU5r4OQebxFbcZGkNUwJwfTFsbfg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 01 Jul 2014 16:37:53.0114 (UTC) FILETIME=[CDDFABA0:01CF954A]
X-MC-Unique: 114070117375300201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 11:44:51PM +0100, Bjorn Helgaas wrote:
> On Mon, Apr 7, 2014 at 4:07 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > On Mon, Apr 07, 2014 at 10:14:18AM +0100, Benjamin Herrenschmidt wrote:
> >> On Mon, 2014-04-07 at 09:46 +0100, Liviu Dudau wrote:
> >> >
> >> > *My* strategy is to get rid of pci_domain_nr(). I don't see why we need
> >> > to have arch specific way of providing the number, specially after looking
> >> > at the existing implementations that return a value from a variable that
> >> > is never touched or incremented. My guess is that pci_domain_nr() was
> >> > created to work around the fact that there was no domain_nr maintainance in
> >> > the generic code.
> >>
> >> Well, there was no generic host bridge structure. There is one now, it should
> >> go there.
> >
> > Exactly! Hence my patch. After it gets accepted I will go through architectures
> > and remove their version of pci_domain_nr().
> 
> Currently the arch has to supply pci_domain_nr() because that's the
> only way for the generic code to learn the domain.  After you add
> pci_create_root_bus_in_domain(), the arch can supply the domain that
> way, and we won't need the arch-specific pci_domain_nr().  Right?
> That makes more sense to me; thanks for the explanation.
> 
> Let me try to explain my concern about the
> pci_create_root_bus_in_domain() interface.  We currently have these
> interfaces:
> 
>   pci_scan_root_bus()
>   pci_scan_bus()
>   pci_scan_bus_parented()
>   pci_create_root_bus()
> 
> pci_scan_root_bus() is a higher-level interface than
> pci_create_root_bus(), so I'm trying to migrate toward it because it
> lets us remove a little code from the arch, e.g., pci_scan_child_bus()
> and pci_bus_add_devices().
> 
> I think we can only remove the arch-specific pci_domain_nr() if that
> arch uses pci_create_root_bus_in_domain().  When we convert an arch
> from using scan_bus interfaces to using
> pci_create_root_bus_in_domain(), we will have to move the rest of the
> scan_bus code (pci_scan_child_bus(), pci_bus_add_devices()) back into
> the arch code.
> 
> One alternative is to add an _in_domain() variant of each of these
> interfaces, but that doesn't seem very convenient either.  My idea of
> passing in a structure would also require adding variants, so there's
> not really an advantage there, but I am thinking of the next
> unification effort, e.g., for NUMA node info.  I don't really want to
> have to change all the _in_domain() interfaces to also take yet
> another parameter for the node number.

Resurecting this thread as I'm about to send an updated patch:

TL;DR: Bjorn is concerned that my introduction of an _in_domain() version
of pci_create_root_bus() as a way to pass a domain number from the arch
code down (or up?) into the generic PCI code is incomplete, as other
APIs that he listed make use of the non-domain aware version of
pci_create_root_bus() and as he plans to remove the use of the function
and use higher level APIs like pci_scan_root_bus() we will have to
introduce an _in_domain() version for those higher level functions.

After a bit of thinking I think the change I'm proposing is fine exactly
because it is a low level API. My intention is to automate the management
of the PCI domain numbers and any architecture that wants to go against
that should probably use the lower abstraction API to better control the
flow. So, in my updated v8 version of the patch I'm going to keep the
suggestion *as is* and hope we can have a(nother) discussion and come up
with a conclusion.

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
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

