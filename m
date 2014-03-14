Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbaCNSqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:46:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:57749 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbaCNSqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:46:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v7 2/6] pci: OF: Fix the conversion of IO ranges into IO resources.
Date: Fri, 14 Mar 2014 19:46:23 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com> <201403141805.29204.arnd@arndb.de> <20140314171921.GY6457@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140314171921.GY6457@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201403141946.23921.arnd@arndb.de>
X-Provags-ID: V02:K0:ckJoMZcliKtB2Hj/F+DdgO7RdMNgfV5h+N0jhNWY4Ra
 QCsuR9Qqd8wNFUo33aVyKBe9V0XOmbKKtse7zP7LxGmHQN4CZN
 1UzzvzUCJzJenR5OgJn57NUVWS6ZPuJ1C+2eAKc9VZPYM38reA
 eB7CngoN0TNWlEizf5P6cNEWmMWi+TMY+D90IUhbiIX/N7xvdN
 5PmnTeouB06tMyATmfvjbOJlnDCDjWTXmwll1n33X8JEs8bFsD
 RpvOz+KB5QCaXutQ9FMUpAHJ7ftj+bZz0uwYRCxNwNFhOUwusd
 tnjxn1WwXbZvQT555J4fXdvqIhEqMYGrXD8BUtwzSjfEHhoAd6
 rS4/P9LLfd1WeC6hXKGiMevx/58tGEDygmyr7PL8q
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 March 2014, Liviu Dudau wrote:
> You are right, that was lazy of me. What about this version?

Yes, that seems better. Thanks for fixing it up.

But back to the more important question that I realized we have
not resolved yet:

You now have two completely independent allocation functions for
logical I/O space numbers, and they will return different numbers
for any nontrivial scenario.

> +int of_pci_range_to_resource(struct of_pci_range *range,
> +       struct device_node *np, struct resource *res)
> +{
> +       res->flags = range->flags;
> +       res->parent = res->child = res->sibling = NULL;
> +       res->name = np->full_name;
> +
> +       if (res->flags & IORESOURCE_IO) {
> +               unsigned long port = -1;
> +               int err = pci_register_io_range(range->cpu_addr, range->size);
> +               if (err)
> +                       goto invalid_range;
> +               port = pci_address_to_pio(range->cpu_addr);
> +               if (port == (unsigned long)-1) {
> +                       err = -EINVAL;
> +                       goto invalid_range;
> +               }
> +               res->start = port;
> +       } else {

This one concatenates the I/O spaces and assumes that each space starts
at bus address zero, and takes little precaution to avoid filling up IO_SPACE_LIMIT
if the sizes are too big.

>+unsigned long pci_ioremap_io(const struct resource *res, phys_addr_t phys_addr)
>+{
>+       unsigned long start, len, virt_start;
>+       int err;
>+
>+       if (res->end > IO_SPACE_LIMIT)
>+               return -EINVAL;
>+
>+       /*
>+        * try finding free space for the whole size first,
>+        * fall back to 64K if not available
>+        */
>+       len = resource_size(res);
>+       start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
>+                               res->start / PAGE_SIZE, len / PAGE_SIZE, 0);
>+       if (start == IO_SPACE_PAGES && len > SZ_64K) {
>+               len = SZ_64K;
>+               start = 0;
>+               start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
>+                                       start, len / PAGE_SIZE, 0);
>+       }
>+
>+       /* no 64K area found */
>+       if (start == IO_SPACE_PAGES)
>+               return -ENOMEM;
>+
>+       /* ioremap physical aperture to virtual aperture */
>+       virt_start = start * PAGE_SIZE + (unsigned long)PCI_IOBASE;
>+       err = ioremap_page_range(virt_start, virt_start + len,
>+                               phys_addr, __pgprot(PROT_DEVICE_nGnRE));
>+       if (err)
>+               return err;
>+
>+       bitmap_set(pci_iospace, start, len / PAGE_SIZE);
>+
>+       /* return io_offset */
>+       return start * PAGE_SIZE - res->start;
>+}

While this one will try to fall back to smaller sizes, and will honor nonzero
bus addresses.

I think we shouldn't even try to do the same thing twice, but instead just
use a single allocator. I'd prefer the one I came up with, but I realize
that I am biased here ;-)

	Arnd
