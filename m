Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbaDGWpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:45:16 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:52903 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaDGWpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:45:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140407100715.GI17163@e106497-lin.cambridge.arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-5-git-send-email-Liviu.Dudau@arm.com> <20140405000007.GD15806@google.com>
 <20140407084623.GG17163@e106497-lin.cambridge.arm.com> <1396862058.3671.40.camel@pasglop>
 <20140407100715.GI17163@e106497-lin.cambridge.arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 Apr 2014 16:44:51 -0600
Message-ID: <CAErSpo7h+Yew2hBztzkOzcHU5r4OQebxFbcZGkNUwJwfTFsbfg@mail.gmail.com>
Subject: Re: [PATCH v7 4/6] pci: Introduce a domain number for pci_host_bridge.
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
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

On Mon, Apr 7, 2014 at 4:07 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> On Mon, Apr 07, 2014 at 10:14:18AM +0100, Benjamin Herrenschmidt wrote:
>> On Mon, 2014-04-07 at 09:46 +0100, Liviu Dudau wrote:
>> >
>> > *My* strategy is to get rid of pci_domain_nr(). I don't see why we need
>> > to have arch specific way of providing the number, specially after looking
>> > at the existing implementations that return a value from a variable that
>> > is never touched or incremented. My guess is that pci_domain_nr() was
>> > created to work around the fact that there was no domain_nr maintainance in
>> > the generic code.
>>
>> Well, there was no generic host bridge structure. There is one now, it should
>> go there.
>
> Exactly! Hence my patch. After it gets accepted I will go through architectures
> and remove their version of pci_domain_nr().

Currently the arch has to supply pci_domain_nr() because that's the
only way for the generic code to learn the domain.  After you add
pci_create_root_bus_in_domain(), the arch can supply the domain that
way, and we won't need the arch-specific pci_domain_nr().  Right?
That makes more sense to me; thanks for the explanation.

Let me try to explain my concern about the
pci_create_root_bus_in_domain() interface.  We currently have these
interfaces:

  pci_scan_root_bus()
  pci_scan_bus()
  pci_scan_bus_parented()
  pci_create_root_bus()

pci_scan_root_bus() is a higher-level interface than
pci_create_root_bus(), so I'm trying to migrate toward it because it
lets us remove a little code from the arch, e.g., pci_scan_child_bus()
and pci_bus_add_devices().

I think we can only remove the arch-specific pci_domain_nr() if that
arch uses pci_create_root_bus_in_domain().  When we convert an arch
from using scan_bus interfaces to using
pci_create_root_bus_in_domain(), we will have to move the rest of the
scan_bus code (pci_scan_child_bus(), pci_bus_add_devices()) back into
the arch code.

One alternative is to add an _in_domain() variant of each of these
interfaces, but that doesn't seem very convenient either.  My idea of
passing in a structure would also require adding variants, so there's
not really an advantage there, but I am thinking of the next
unification effort, e.g., for NUMA node info.  I don't really want to
have to change all the _in_domain() interfaces to also take yet
another parameter for the node number.

Bjorn
