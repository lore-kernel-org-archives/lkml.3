Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaB0N6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:58:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:65242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaB0N6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:58:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Murray <amurray@embedded-bits.co.uk>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/4] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Thu, 27 Feb 2014 14:58:34 +0100
Message-ID: <23116993.AhiSYlcnvx@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAPcvp5EqcKEWoH_--azp+sMykmEWtY5whHG=c9t3sZVXZyAPUg@mail.gmail.com>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com> <1393506402-11474-2-git-send-email-Liviu.Dudau@arm.com> <CAPcvp5EqcKEWoH_--azp+sMykmEWtY5whHG=c9t3sZVXZyAPUg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:z2j4Z9lOBLdGjXRzi5ry/4a9DDoD2Gx2uqIY6zP8JBw
 20N4pOJP1naiwLs6dCwOP1uUbLKyGeQyiK6IURQlrj/5ZnADEg
 g2T6BTlmHT1YkZNprgbkuZPXzy/6B/tX7V02DiR7ci+e+Wfly7
 8fHg1aFgN6AcYVBeM8qhIT6TODZO1HPGhHwm6FXYtI8PyJmTVF
 tNdVGff8p0FgvHvP2CtV562rA/budObxQlE+AMhsVBdckVxP52
 x3PWmHfBktTCNMVGUx62lws7IQHG5F/NnE53eOTU9wQrwdFCEe
 1OySX2YRkw7pUIGbQFtIQ3BmWTjNM8gjj2bhf2LlFEE6weRjrR
 5H+qdiJEIjKJ1buueXlU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 February 2014 13:22:19 Andrew Murray wrote:
> On 27 February 2014 13:06, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> >
> > The ranges property for a host bridge controller in DT describes
> > the mapping between the PCI bus address and the CPU physical address.
> > The resources framework however expects that the IO resources start
> > at a pseudo "port" address 0 (zero) and have a maximum size of 64kb.
> 
> Is this just in the case of ARM? (I've tried to keep up with the
> conversation, but apologies if I've misunderstood).

We are a bit inconsistent on Linux. The limitation cited above is
indeed something we came up with on ARM to simplify the possible
cases we have to worry about.

In theory, each PCI host can have its own 4GB I/O space, but in practice
limiting to 64KB is the most reasonable way to use it, and that
still provides plenty of room for I/O registers since most devices
don't use any, and at most a few bytes of address space.

The limit we enforce on Linux is IO_SPACE_LIMIT, which is sometimes set
to 0xffffffff, but I think most if not all of those cases are done so
in error.

> > + * of_pci_range_to_resource - Create a resource from an of_pci_range
> > + * @range:     the PCI range that describes the resource
> > + * @np:                device node where the range belongs to
> > + * @res:       pointer to a valid resource that will be updated to
> > + *              reflect the values contained in the range.
> > + * Note that if the range is an IO range, the resource will be converted
> > + * using pci_address_to_pio() which can fail if it is called to early or
> > + * if the range cannot be matched to any host bridge IO space.
> > + */
> > +void of_pci_range_to_resource(struct of_pci_range *range,
> > +       struct device_node *np, struct resource *res)
> > +{
> > +       res->flags = range->flags;
> > +       if (res->flags & IORESOURCE_IO) {
> > +               unsigned long port;
> > +               port = pci_address_to_pio(range->pci_addr);
> 
> Is this likely to break existing users of of_pci_range_to_resource?
> 
> For example arch/mips: IO_SPACE_LIMIT defaults to 0xffff and there is
> no overridden implementation for pci_address_to_pio, therefore this
> will set res->start to OF_BAD_ADDR whereas previously it would have
> been the CPU address for I/O (assuming the cpu_addr was previously >
> 64K).

The function is used on MIPS, Microblaze and ARM at the moment.
MIPS currently gets it wrong, by calling pci_add_resource_offset
on the CPU address for IORESOURCE_IO, which is the wrong space.
Limiting to IO_SPACE_LIMIT will fix it for the first host bridge
on MIPS, and the second one will still not work, until
IO_SPACE_LIMIT is fixed.

On ARM, I believe we have a couple of drivers that make the
same mistake, and others that at the moment override the
address with range->pci_addr, so they won't change.

Microblaze does 'range.cpu_addr = range.pci_addr;' for the I/O
space window to fix it up. We should probably take a closer look there.

	Arnd
