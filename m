Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbaCQNlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:41:22 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38077 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390AbaCQNlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:41:08 -0400
Date: Mon, 17 Mar 2014 13:41:03 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 2/6] pci: OF: Fix the conversion of IO ranges into IO
 resources.
Message-ID: <20140317134103.GD6457@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <201403141946.23921.arnd@arndb.de>
 <20140314190017.GA6457@e106497-lin.cambridge.arm.com>
 <201403142016.11105.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201403142016.11105.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 17 Mar 2014 13:41:15.0936 (UTC) FILETIME=[91AD2200:01CF41E6]
X-MC-Unique: 114031713410502801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 07:16:10PM +0000, Arnd Bergmann wrote:
> On Friday 14 March 2014, Liviu Dudau wrote:
> > On Fri, Mar 14, 2014 at 06:46:23PM +0000, Arnd Bergmann wrote:
> > > On Friday 14 March 2014, Liviu Dudau wrote:
> > > 
> > > > +int of_pci_range_to_resource(struct of_pci_range *range,
> > > > +       struct device_node *np, struct resource *res)
> > > > +{
> > > > +       res->flags = range->flags;
> > > > +       res->parent = res->child = res->sibling = NULL;
> > > > +       res->name = np->full_name;
> > > > +
> > > > +       if (res->flags & IORESOURCE_IO) {
> > > > +               unsigned long port = -1;
> > > > +               int err = pci_register_io_range(range->cpu_addr, range->size);
> > > > +               if (err)
> > > > +                       goto invalid_range;
> > > > +               port = pci_address_to_pio(range->cpu_addr);
> > > > +               if (port == (unsigned long)-1) {
> > > > +                       err = -EINVAL;
> > > > +                       goto invalid_range;
> > > > +               }
> > > > +               res->start = port;
> > > > +       } else {
> > > 
> > > This one concatenates the I/O spaces and assumes that each space starts
> > > at bus address zero, and takes little precaution to avoid filling up IO_SPACE_LIMIT
> > > if the sizes are too big.
> > 
> > Actually, you are attaching too much meaning to this one. pci_register_io_range()
> > only tries to remember the ranges, nothing else. And it *does* check that the
> > total sum of registered ranges does not exceed IO_SPACE_LIMIT. This is used before
> > we have any resource mapped for that range (actually it is used to *create* the
> > resource for the range) so there is no other helping hand.
> > 
> > It doesn't assume that space starts at bus address zero, it ignores the bus address.
> > It only handles CPU addresses for the range, to help with generating logical IO ports.
> > If you have overlapping CPU addresses with different bus addresses it will not work,
> > but then I guess you will have different problems then.
> 
> The problem is that it tries to set up a mapping so that pci_address_to_pio
> returns the actual port number, but the port that you assign to res->start
> above is assumed to match the 'start' variable below. If the value ends
> up different, the BARs that get set by the PCI bus scan are not in the
> same place that got ioremapped into the virtual I/O aperture.

Yes, after writting a reply trying to justify why it would actually work I've realised
where the fault of my logic stands (short version, two host controllers will get different
io_offsets but the ports numbers will start from zero leading to confusion about which
host controller the resource belongs to).

I will try to split your function into two parts, one that calculates the io_offset and
another that does the ioremap_page_range() side and replace my cooked function.

Best regards,
Liviu

> 
> > > >+unsigned long pci_ioremap_io(const struct resource *res, phys_addr_t phys_addr)
> > > >+{
> > > >+       unsigned long start, len, virt_start;
> > > >+       int err;
> > > >+
> > > >+       if (res->end > IO_SPACE_LIMIT)
> > > >+               return -EINVAL;
> > > >+
> > > >+       /*
> > > >+        * try finding free space for the whole size first,
> > > >+        * fall back to 64K if not available
> > > >+        */
> > > >+       len = resource_size(res);
> > > >+       start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
> > > >+                               res->start / PAGE_SIZE, len / PAGE_SIZE, 0);
> > > >+       if (start == IO_SPACE_PAGES && len > SZ_64K) {
> > > >+               len = SZ_64K;
> > > >+               start = 0;
> > > >+               start = bitmap_find_next_zero_area(pci_iospace, IO_SPACE_PAGES,
> > > >+                                       start, len / PAGE_SIZE, 0);
> > > >+       }
> > > >+
> > > >+       /* no 64K area found */
> > > >+       if (start == IO_SPACE_PAGES)
> > > >+               return -ENOMEM;
> > > >+
> > > >+       /* ioremap physical aperture to virtual aperture */
> > > >+       virt_start = start * PAGE_SIZE + (unsigned long)PCI_IOBASE;
> > > >+       err = ioremap_page_range(virt_start, virt_start + len,
> > > >+                               phys_addr, __pgprot(PROT_DEVICE_nGnRE));
> > > >+       if (err)
> > > >+               return err;
> > > >+
> > > >+       bitmap_set(pci_iospace, start, len / PAGE_SIZE);
> > > >+
> > > >+       /* return io_offset */
> > > >+       return start * PAGE_SIZE - res->start;
> > > >+}
> 
> 	Arnd
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

