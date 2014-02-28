Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaB1Iqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:46:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:50385 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaB1Iqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:46:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel@lists.linaro.org, linux-pci <linux-pci@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 4/4] pci: Add support for creating a generic host_bridge from device tree
Date: Fri, 28 Feb 2014 09:46:39 +0100
Message-ID: <41426943.fCMrEO9t9X@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1393543924.14012.56.camel@pasglop>
References: <1393506402-11474-1-git-send-email-Liviu.Dudau@arm.com> <18746655.qWHLpMg2Yy@wuerfel> <1393543924.14012.56.camel@pasglop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZSvMBO8jP0iwofCCT3LC8bjz5kBiFK1H2g5ER/kJ8x4
 ef5acuL5cMxChv+4d6yvOLva1wRCy8gclu1Ri7OHRMVhDpHgTL
 u1PHiOn4A3oLR3nV7nOjzzNJjjyeM9OCV3u9W0juEMgmwLxZ49
 A8owtcpi4CSRo+W5LXdRJv/U8yTyfYHvyAPc96MeIC2abhSDtw
 h7lCBsHHu88x3RWVBlZq9qsjPaqW898535xF12o/8O24jgniN5
 hPbPU5P/RDDP2bbFGu+ftbSPpYzWefJ5HNdAUFAc3YwQ6auOVc
 uuKdFRupH/IvHm8siYfnUovnbBeRRBTdpsr59FSQmLqcG1wsJB
 et7RdmzLkGwkcDSSdXug=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 February 2014 10:32:04 Benjamin Herrenschmidt wrote:
> On Thu, 2014-02-27 at 14:38 +0100, Arnd Bergmann wrote:
> > On Thursday 27 February 2014 13:06:42 Liviu Dudau wrote:
> > > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > 
> > Please add Benjamin Herrenschmidt to Cc here, I think it would be helpful
> > to get his input so we can make this work on powerpc as well.
> 
> Tricky... We would need hooks which would turn the whole thing into a
> pile of spaghetti. I think we should stick to using the range helpers
> (Andrew latest patch), which makes the powerpc code a lot smaller,
> and leave it at that.

We can certainly do both: small helpers that let you shrink the powerpc
code, and a generic implementation that can be shared by some of the
other architectures that you don't use. The PCI core already uses
a number of 'weak' functions here, and we can expand on that.

 > > +		res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> > > +		if (!res) {
> > > +			err = -ENOMEM;
> > > +			goto bridge_ranges_nomem;
> > > +		}
> > > +
> > > +		of_pci_range_to_resource(&range, dev, res);
> > > +
> > > +		if (resource_type(res) == IORESOURCE_IO)
> > > +			*io_base = range.cpu_addr;
> 
> You don't care about the size of the IO space ?

We probably should. The ARM code currently assumes that each I/O
space is 64KB, but for a generic implementation we probably want
to handle both smaller and larger windows. I suggested not supporting
more than 1MB though, which is the maximum that I can see a reason
for, i.e. the pci-mvebu fake host bridge that has to combine
multiple per-port HW I/O spaces into one logical space.

> > > +		pci_add_resource_offset(resources, res,
> > > +				res->start - range.pci_addr);
> > > +	}
> > 
> > This is not the correct resource for I/O space at all. Please talk
> > to Will, I've been over this with him in detail and he probably
> > understands it now. I assume you are both working in the same
> > building.
> 
> Yes, the IO offsets work differently on powerpc as well

As I noticed later, the first patch in the series actually changes
the range_to_resource parser to return the logical start here, which
would make the offset correct even on powerpc, but unfortunately
I think that cannot work.

> > > +struct pci_host_bridge *
> > > +of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops, void *host_data)
> > > +{
> > > +	int err, domain, busno;
> > > +	struct resource bus_range;
> > > +	struct pci_bus *root_bus;
> > > +	struct pci_host_bridge *bridge;
> > > +	resource_size_t io_base;
> > > +	LIST_HEAD(res);
> > > +
> > > +	domain = of_alias_get_id(parent->of_node, "pci-domain");
> > > +	if (domain == -ENODEV)
> > > +		domain = domain_nr++;
> > >
> We probably want some uniqueness testing here.

I thought this at first too, but as Liviu mentioned, this does
get caught later when trying to create the root bus with
a conflicting number.

What the above code cannot do is to put multiple host bridges
into the same domain, using distinct bus ranges. This is an
intentional simplification over what some architectures currently
do, and we could not see a reason why you would still need
to put multiple host bridges into one domain in 2014.

x86 with ACPI does it, but they won't call of_create_pci_host_bridge.

	Arnd
