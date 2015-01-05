Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbbAEUB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:01:57 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:55402 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbbAEUB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:01:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robh@kernel.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] pci: introduce common pci config space accessors
Date: Mon, 05 Jan 2015 21:01:50 +0100
Message-ID: <1758416.ZHsvLP471N@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_JsqLGh-e2epUdtK07xM_2nwrRO_qcebD-zdCQjRGh9xnsAw@mail.gmail.com>
References: <1420424374-32412-1-git-send-email-robh@kernel.org> <2224125.SvyFyDvrch@wuerfel> <CAL_JsqLGh-e2epUdtK07xM_2nwrRO_qcebD-zdCQjRGh9xnsAw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:BLy3g8DdF/bwRn/fYej7XDRNFDqkIYz/AljsRGxx3H1DEbJLuoT
 M6qFiPPcYsHOrC6YMRLDid/n0fW1ERamVclObLMw4S6Kie2bdN8NJXlbwLjbs7JouA2sZmv
 IavNieFyepTXbE0EYmMn6PiJ7hjkpmaXc5QhRt/f6t0APNI6IdHzzdnbB11pKqKOEkigqJG
 +ZYS08XQNjs5tBLE4AECA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2015 08:46:09 Rob Herring wrote:
> 
> >> diff --git a/include/linux/pci.h b/include/linux/pci.h
> >> index 360a966..e7fd519 100644
> >> --- a/include/linux/pci.h
> >> +++ b/include/linux/pci.h
> >> @@ -560,6 +560,7 @@ static inline int pcibios_err_to_errno(int err)
> >>  /* Low-level architecture-dependent routines */
> >>
> >>  struct pci_ops {
> >> +     void __iomem *(*map_bus)(struct pci_bus *bus, unsigned int devfn, int where);
> >>       int (*read)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *val);
> >>       int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
> >>  };
> >
> > In various other contexts, we have recently discussed adding new callbacks
> > to struct pci_host_bridge, or an operations structure below it. I don't see
> > a strong reason for one place or the other, but maybe someone else does.
> > If we put it into pci_host_bridge_ops, the first argument would need to
> > be the pci_host_bridge pointer of course.
> 
> I think it makes sense to keep map_bus together with read/write. Given
> they are all host specific functions being part of pci_host_bridge
> would make some sense. However, that would be a pretty painful change
> across the tree (Have you seen how many PCI host implementations MIPS
> has?).

We could go wild and do both: if the bus has pci_ops, we use those,
otherwise we fall back to the map_bus/read/write from pci_host_bridge_ops.

> > For the common map_bus implementations, it would also be nice to put them
> > into the same file as your new access functions, but then we need a common
> > location to store at least one __iomem pointer. I guess that place could
> > either be struct pci_host_bridge or struct pci_bus. In theory, struct pci_ops
> > would work too, but then we could no longer mark it 'const' in host bridge
> > drivers.
> >
> > If we have a common set of map_bus functions, we can even export the
> > pci_ops structures from drivers/pci/access.c:
> >
> > const struct pci_ops pci_generic_ecam_ops = {
> >         .map_bus        = ecam_map_bus,
> >         .read           = pci_generic_config_read,
> >         .write          = pci_generic_config_write,
> > };
> > EXPORT_SYMBOL_GPL(pci_generic_ecam_ops);
> >
> > That could of course be done in a follow-up patch, it doesn't have to be
> > part of your patch, but it would be good to be prepared.
> 
> Right, this is what I had in mind for CAM/ECAM. I didn't go this far
> because a lot of the map_bus functions do various checks to prevent
> certain accesses. Of what I've found, I think only generic host and
> Xilinx drivers could be converted to a generic ECAM map_bus. Others
> check bus number and/or device number or link-up status or have a
> fixup for certain registers, for example. I'm not sure how much of it
> is unnecessary or could be common.

How do you want to deal with the overrides? I don't see a way to
do that in map_bus (with the current definition) if the idea is that
for certain registers we return hardcoded values instead of accessing
mmio registers.

	Arnd
