Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab3BNQxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:53:47 -0500
Received: from service87.mimecast.com ([91.220.42.44]:34514 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418Ab3BNQxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:53:45 -0500
Date: Thu, 14 Feb 2013 16:53:41 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] of/pci: Provide support for parsing PCI DT ranges
 property
Message-ID: <20130214165341.GA29199@arm.com>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
 <1360570940-17086-2-git-send-email-thierry.reding@avionic-design.de>
 <20130213225311.37FFB3E3557@localhost>
MIME-Version: 1.0
In-Reply-To: <20130213225311.37FFB3E3557@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 Feb 2013 16:53:42.0009 (UTC) FILETIME=[D8170E90:01CE0AD3]
X-MC-Unique: 113021416534305801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 10:53:11PM +0000, Grant Likely wrote:
> On Mon, 11 Feb 2013 09:22:17 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> > From: Andrew Murray <andrew.murray@arm.com>
> > 
> > DT bindings for PCI host bridges often use the ranges property to describe
> > memory and IO ranges - this binding tends to be the same across architectures
> > yet several parsing implementations exist, e.g. arch/mips/pci/pci.c,
> > arch/powerpc/kernel/pci-common.c, arch/sparc/kernel/pci.c and
> > arch/microblaze/pci/pci-common.c (clone of PPC). Some of these duplicate
> > functionality provided by drivers/of/address.c.
> 
> Hi Thierry,
> 
> Following from my comments on not merging these patches, here are my
> comments on this patch...
> 
> > This patch provides a common iterator-based parser for the ranges property, it
> > is hoped this will reduce DT representation differences between architectures
> > and that architectures will migrate in part to this new parser.
> > 
> > It is also hoped (and the motativation for the patch) that this patch will
> > reduce duplication of code when writing host bridge drivers that are supported
> > by multiple architectures.
> > 
> > This patch provides struct resources from a device tree node, e.g.:
> > 
> > 	u32 *last = NULL;
> > 	struct resource res;
> > 	while ((last = of_pci_process_ranges(np, res, last))) {
> > 		//do something with res
> > 	}
> 
> The approach seems reasonable, but it isn't optimal. For one, the setup
> code ends up getting run every time of_pci_process_ranges() gets called.
> It would also be more user-friendly to wrap it up in a
> "for_each_of_pci_range()" macro.
> 
> > Platforms with quirks can then do what they like with the resource or migrate
> > common quirk handling to the parser. In an ideal world drivers can just request
> > the obtained resources and pass them on (e.g. pci_add_resource_offset).
> > 
> > Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> >  drivers/of/address.c       | 63 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/of_address.h |  9 +++++++
> >  2 files changed, 72 insertions(+)
> > 
> > diff --git a/drivers/of/address.c b/drivers/of/address.c
> > index 04da786..f607008 100644
> > --- a/drivers/of/address.c
> > +++ b/drivers/of/address.c
> > @@ -13,6 +13,7 @@
> >  #define OF_CHECK_COUNTS(na, ns)	(OF_CHECK_ADDR_COUNT(na) && (ns) > 0)
> >  
> >  static struct of_bus *of_match_bus(struct device_node *np);
> > +static struct of_bus *of_find_bus(const char *name);
> >  static int __of_address_to_resource(struct device_node *dev,
> >  		const __be32 *addrp, u64 size, unsigned int flags,
> >  		const char *name, struct resource *r);
> > @@ -227,6 +228,57 @@ int of_pci_address_to_resource(struct device_node *dev, int bar,
> >  	return __of_address_to_resource(dev, addrp, size, flags, NULL, r);
> >  }
> >  EXPORT_SYMBOL_GPL(of_pci_address_to_resource);
> > +
> > +const __be32 *of_pci_process_ranges(struct device_node *node,
> > +				    struct resource *res, const __be32 *from)
> > +{
> > +	const __be32 *start, *end;
> > +	int na, ns, np, pna;
> > +	int rlen;
> > +	struct of_bus *bus;
> > +
> > +	WARN_ON(!res);
> > +
> > +	bus = of_find_bus("pci");
> > +	bus->count_cells(node, &na, &ns);
> > +	if (!OF_CHECK_COUNTS(na, ns)) {
> > +		pr_err("Bad cell count for %s\n", node->full_name);
> > +		return NULL;
> > +	}
> 
> Looking up the pci of_bus structure isn't really warrented here. This
> function will only ever be used on PCI busses, and na/ns for PCI is
> always 3/2. Just use those numbers here. You could however validate that
> the node has the correct values in #address-cells and #size-cells
> 
> > +
> > +	pna = of_n_addr_cells(node);
> > +	np = pna + na + ns;
> > +
> > +	start = of_get_property(node, "ranges", &rlen);
> > +	if (start == NULL)
> > +		return NULL;
> > +
> > +	end = start + rlen / sizeof(__be32);
> 
> The above structure means that the ranges property has to be looked up
> each and every time this function is called. It would be better to have
> a state structure that can look it up once and then keep track of the
> iteration.
> 
> > +
> > +	if (!from)
> > +		from = start;
> > +
> > +	while (from + np <= end) {
> > +		u64 cpu_addr, size;
> > +
> > +		cpu_addr = of_translate_address(node, from + na);
> > +		size = of_read_number(from + na + pna, ns);
> > +		res->flags = bus->get_flags(from);
> > +		from += np;
> > +
> > +		if (cpu_addr == OF_BAD_ADDR || size == 0)
> > +			continue;
> > +
> > +		res->name = node->full_name;
> > +		res->start = cpu_addr;
> > +		res->end = res->start + size - 1;
> > +		res->parent = res->child = res->sibling = NULL;
> > +		return from;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +EXPORT_SYMBOL_GPL(of_pci_process_ranges);
> 
> All of the above can be directly factored out of the PCI implementation.
> You don't even need to touch most of the powerpc code. Create your
> iterator helper functions in the same patch that makes PowerPC and
> Microblaze use them, and then improve/modify the behaviour in seperate
> patches. The delta to ppc/microblaze really will be very small with this
> approach.  Here are the relevant PPC lines:
> 
> void pci_process_bridge_OF_ranges(struct pci_controller *hose,
> 				  struct device_node *dev, int primary)
> {
> 	const u32 *ranges;
> 	int rlen;
> 	int pna = of_n_addr_cells(dev);
> 	int np = pna + 5;
> 	int memno = 0, isa_hole = -1;
> 	u32 pci_space;
> 	unsigned long long pci_addr, cpu_addr, pci_next, cpu_next, size;
> 	unsigned long long isa_mb = 0;
> 	struct resource *res;
> 
> 	printk(KERN_INFO "PCI host bridge %s %s ranges:\n",
> 	       dev->full_name, primary ? "(primary)" : "");
> 
> 	/* Get ranges property */
> 	ranges = of_get_property(dev, "ranges", &rlen);
> 	if (ranges == NULL)
> 		return;
> 
> 	/* Parse it */
> 	while ((rlen -= np * 4) >= 0) {
> 		/* Read next ranges element */
> 		pci_space = ranges[0];
> 		pci_addr = of_read_number(ranges + 1, 2);
> 		cpu_addr = of_translate_address(dev, ranges + 3);
> 		size = of_read_number(ranges + pna + 3, 2);
> 		ranges += np;
> 
> 		/* If we failed translation or got a zero-sized region
> 		 * (some FW try to feed us with non sensical zero sized regions
> 		 * such as power3 which look like some kind of attempt at exposing
> 		 * the VGA memory hole)
> 		 */
> 		if (cpu_addr == OF_BAD_ADDR || size == 0)
> 			continue;
> 
> 		/* Now consume following elements while they are contiguous */
> 		for (; rlen >= np * sizeof(u32);
> 		     ranges += np, rlen -= np * 4) {
> 			if (ranges[0] != pci_space)
> 				break;
> 			pci_next = of_read_number(ranges + 1, 2);
> 			cpu_next = of_translate_address(dev, ranges + 3);
> 			if (pci_next != pci_addr + size ||
> 			    cpu_next != cpu_addr + size)
> 				break;
> 			size += of_read_number(ranges + pna + 3, 2);
> 		}
> 
> After factoring out the bits you want to use it will probably look like
> this:
> 
> void pci_process_bridge_OF_ranges(struct pci_controller *hose,
> 				  struct device_node *dev, int primary)
> {
> 	const u32 *ranges;
> 	int memno = 0, isa_hole = -1;
> 	unsigned long long isa_mb = 0;
> 	struct resource *res;
> 	struct of_pci_range_iter iter;
> 
> 	printk(KERN_INFO "PCI host bridge %s %s ranges:\n",
> 	       dev->full_name, primary ? "(primary)" : "");
> 
> 	for_each_of_pci_range(iter, np) {
> 		/* Read next ranges element */
> 		u32 pci_space = iter->pci_space;
> 		unsigned long long pci_addr = iter->pci_addr;
> 		unsigned long long cpu_addr = iter->cpu_addr;
> 		unsigned long long size = iter->size;
> 		int pna = iter->pna;
> 		/* or the remainder of the body of this function could
> 		 * have 'iter->' prefixed to each reference, which is
> 		 * better, but also a bit more invasive */
> 
> here really shouldn't be any further changes the the rest of the
> function. I don't think that is unreasonable to ask, and I can help with
> putting this together if you need it. Plus it will /reduce/ the number
> of lines in the kernel instead of adding to them. That is something I
> always want more of. :-)
> 
> Actually, a lot of the powerpc behaviour should still be
> relevant to all architectures, but I haven't dug that deep yet.

Thierry,

If you don't have much bandwidth I'd be quite happy to take this on - this
would be beneficial for my eventual patchset. I can start by refactoring common
implementations of pci_process_bridge_OF_ranges or similar across the
architectures as per Grant's suggestion? I didn't do this when I first posted
the patch as I was concerned about the testing effort.

Andrew Murray

