Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaIYUtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 16:49:52 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:51701 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaIYUtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 16:49:50 -0400
MIME-Version: 1.0
In-Reply-To: <201409252222.23825.arnd@arndb.de>
References: <1411573068-12952-1-git-send-email-rric@kernel.org>
 <201409252126.38945.arnd@arndb.de> <CAErSpo5rhL7pLha-yWt7sZUBmAnwA6FkacL+sWXBKkSzsuC7Sg@mail.gmail.com>
 <201409252222.23825.arnd@arndb.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Sep 2014 14:49:29 -0600
Message-ID: <CAErSpo6yXoETkXkimW2Lv724D4gn8ENi0U3wM=dFhQVkZJKXKg@mail.gmail.com>
Subject: Re: [PATCH 3/6] pci, thunder: Add PCIe host controller devicetree bindings
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sunil Kovvuri <sunil.kovvuri@gmail.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Robert Richter <rric@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <rrichter@cavium.com>,
        Sunil Goutham <sgoutham@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 2:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 25 September 2014, Bjorn Helgaas wrote:
>> OK.  You said "a range that has the nonrelocatable flag set should be
>> used for IORESOURCE_PCI_FIXED mappings."  I thought you meant that the
>> range was a bridge window, and somehow PCI_FIXED BARs should be put in
>> that window.
>>
>> But maybe you meant that nonrelocatable ranges should have the
>> IORESOURCE_PCI_FIXED bit set in their struct resources.  That would
>> mean we couldn't move the window, but we could put relocatable BARs
>> inside the window.
>>
>> What needs to be implemented?  Just the code that would set
>> IORESOURCE_PCI_FIXED for nonrelocatable ranges?
>
> It might be more complex than I thought. Let's see what the original
> hack does:
>
> +/*
> + * All PCIe devices in Thunder have fixed resources, shouldn't be reassigned.
> + * Also claim the device's valid resources to set 'res->parent' hierarchy.
> + */
> +static void pci_dev_resource_fixup(struct pci_dev *dev)
> +{
> +       struct resource *res;
> +       int resno;
> +
> +       for (resno = 0; resno < PCI_NUM_RESOURCES; resno++)
> +               dev->resource[resno].flags |= IORESOURCE_PCI_FIXED;
> +
> +       for (resno = 0; resno < PCI_BRIDGE_RESOURCES; resno++) {
> +               res = &dev->resource[resno];
> +               if (res->parent || !(res->flags & IORESOURCE_MEM))
> +                       continue;
> +               pci_claim_resource(dev, resno);
> +       }
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CAVIUM, PCI_ANY_ID,
> +                       pci_dev_resource_fixup);
>
> This actually looks harmful, because it means that any kernel that contains
> the thunder host controller driver will do the above for any device made
> by Cavium, whether it's connected to this bridge or not.

I agree, that looks broken.

> What I think we want instead is to mark any resource whose parent
> resource is IORESOURCE_PCI_FIXED to have the same flag, and mark
> the PCI host controller resources IORESOURCE_PCI_FIXED when the
> nonrelocatable flag is set, and that should all be done in core
> code, not in a driver fixup.

The PCI host controller resources are host bridge windows, right?  I
don't think it matters whether they have IORESOURCE_PCI_FIXED set,
because the bridge is not itself a PCI device, and PCI resource
assignment treats the host bridge windows as fixed.

That doesn't imply that the PCI device resources *inside* the windows
need to be fixed, though.  Regular BARs can be moved around inside the
window.

Sunil said "All on-board PCI devices connected to this PCI controller
have fixed resources..."  That sounds like these on-board PCI devices
are non-compliant because their BARs don't work per spec.  But that
doesn't sound right, because we wouldn't be able to size them.

> The part that still looks weird is the pci_claim_resource() that
> Sunil mentioned. This is currently done for resources that do not
> have a parent, but AFAICT all PCI device resources should have a
> parent that connects it to the upstream bridge.

Ideally the pci_claim_resource() would be in the core, not in arch
code, but it's a bit of a hodge-podge right now.

Bjorn
