Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaLDKFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:05:06 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52801 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaLDKFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:05:00 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: RE: [RFC] fdt:free the fdt reserved memory
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'robh+dt@kernel.org'" <robh+dt@kernel.org>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>,
        "'pawel.moll@arm.com'" <pawel.moll@arm.com>,
        "'mark.rutland@arm.com'" <mark.rutland@arm.com>,
        "'ijc+devicetree@hellion.org.uk'" <ijc+devicetree@hellion.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313E7@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103D6DB49161A@CNBJMBX05.corpusers.net>
	<20140924144520.697A8C40738@trevor.secretlab.ca>
	<35FD53F367049845BC99AC72306C23D103E688B313E7@CNBJMBX05.corpusers.net>
Date: Thu, 04 Dec 2014 10:04:53 +0000
Message-Id: <20141204100453.49DF2C40992@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014 14:56:11 +0800
, "Wang, Yalin" <Yalin.Wang@sonymobile.com>
 wrote:
> > -----Original Message-----
> > From: Grant Likely [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
> > Sent: Wednesday, September 24, 2014 10:45 PM
> > To: Wang, Yalin; 'robh+dt@kernel.org'; 'devicetree@vger.kernel.org';
> > 'pawel.moll@arm.com'; 'mark.rutland@arm.com';
> > 'ijc+devicetree@hellion.org.uk'; 'linux-kernel@vger.kernel.org'
> > Subject: Re: [RFC] fdt:free the fdt reserved memory
> > 
> > On Thu, 18 Sep 2014 17:25:12 +0800, "Wang, Yalin"
> > <Yalin.Wang@sonymobile.com> wrote:
> > > This patch make some change to unflatten_dt_node(), make sure the
> > > device_node don't reference to fdt raw blob memory, so that we can
> > > free the raw blob reserved memory after initcalls.
> > >
> > > Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> > 
> > Do you have any measurements showing a change in available memory before
> > and after the patch?
> > 
> Does anyone have a look at this patch?
> It can save 12K on my platform,
> My dtb is 164K

Yes, I've been thinking about this one. Unfortunately there is a
conflict with another feature that I'm merging for v3.19. See commit
08d53aa5, "of/fdt: export fdt blob as /sys/firmware/fdt" in linux-next.
That commit requires the original blob to be kept around.

In order to free the original dtb, the /sys/firmware/fdt feature will
need to be changed to let it be configured out. All things considered,
that is probably the right thing to do, but doing so increases the
memory load for the platforms that want /sys/firmware/fdt. I'd like to
see what the impact would be on the code to switch to this method when
/sys/firmware/fdt is configured out.

g.

> 
> Thanks
> 
> > 
> > > ---
> > >  drivers/of/fdt.c       | 27 +++++++++++++++++++++++----
> > >  include/linux/of_fdt.h |  2 ++
> > >  2 files changed, 25 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c index
> > > 79cb831..e891ef6 100644
> > > --- a/drivers/of/fdt.c
> > > +++ b/drivers/of/fdt.c
> > > @@ -240,6 +240,7 @@ static void * unflatten_dt_node(void *blob,
> > >  	     (offset = fdt_next_property_offset(blob, offset))) {
> > >  		const char *pname;
> > >  		u32 sz;
> > > +		int name_len;
> > >
> > >  		if (!(p = fdt_getprop_by_offset(blob, offset, &pname, &sz))) {
> > >  			offset = -FDT_ERR_INTERNAL;
> > > @@ -250,10 +251,12 @@ static void * unflatten_dt_node(void *blob,
> > >  			pr_info("Can't find property name in list !\n");
> > >  			break;
> > >  		}
> > > +		name_len = strlen(pname);
> > >  		if (strcmp(pname, "name") == 0)
> > >  			has_name = 1;
> > > -		pp = unflatten_dt_alloc(&mem, sizeof(struct property),
> > > -					__alignof__(struct property));
> > > +		pp = unflatten_dt_alloc(&mem,
> > > +				ALIGN(sizeof(struct property) + name_len + 1, 4)
> > > +				+ sz, __alignof__(struct property));
> > >  		if (allnextpp) {
> > >  			/* We accept flattened tree phandles either in
> > >  			 * ePAPR-style "phandle" properties, or the @@ -270,9
> > +273,11 @@
> > > static void * unflatten_dt_node(void *blob,
> > >  			 * stuff */
> > >  			if (strcmp(pname, "ibm,phandle") == 0)
> > >  				np->phandle = be32_to_cpup(p);
> > > -			pp->name = (char *)pname;
> > > +			pp->name = (char *)memcpy(pp + 1, pname, name_len + 1);
> > >  			pp->length = sz;
> > > -			pp->value = (__be32 *)p;
> > > +			pp->value = (__be32 *)memcpy((void *)pp +
> > > +					ALIGN(sizeof(struct property) +
> > > +						name_len + 1, 4), p, sz);
> > >  			*prev_pp = pp;
> > >  			prev_pp = &pp->next;
> > >  		}
> > > @@ -564,6 +569,20 @@ void __init early_init_fdt_scan_reserved_mem(void)
> > >  	fdt_init_reserved_mem();
> > >  }
> > >
> > > +void __init free_early_init_fdt_scan_reserved_mem(void)
> > > +{
> > > +	unsigned long start, end, size;
> > > +	if (!initial_boot_params)
> > > +		return;
> > > +
> > > +	size = fdt_totalsize(initial_boot_params);
> > > +	memblock_free(__pa(initial_boot_params), size);
> > > +	start = round_down((unsigned long)initial_boot_params, PAGE_SIZE);
> > > +	end = round_up((unsigned long)initial_boot_params + size, PAGE_SIZE);
> > > +	free_reserved_area((void *)start, (void *)end, 0, "fdt");
> > > +	initial_boot_params = 0;
> > > +}
> > > +
> > >  /**
> > >   * of_scan_flat_dt - scan flattened tree blob and call callback on each.
> > >   * @it: callback function
> > > diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h index
> > > 0ff360d..21d51ce 100644
> > > --- a/include/linux/of_fdt.h
> > > +++ b/include/linux/of_fdt.h
> > > @@ -62,6 +62,7 @@ extern int early_init_dt_scan_chosen(unsigned long
> > > node, const char *uname,  extern int early_init_dt_scan_memory(unsigned
> > long node, const char *uname,
> > >  				     int depth, void *data);
> > >  extern void early_init_fdt_scan_reserved_mem(void);
> > > +extern void free_early_init_fdt_scan_reserved_mem(void);
> > >  extern void early_init_dt_add_memory_arch(u64 base, u64 size);
> > > extern int early_init_dt_reserve_memory_arch(phys_addr_t base,
> > phys_addr_t size,
> > >  					     bool no_map);
> > > @@ -89,6 +90,7 @@ extern u64 fdt_translate_address(const void *blob,
> > > int node_offset);  extern void of_fdt_limit_memory(int limit);  #else
> > > /* CONFIG_OF_FLATTREE */  static inline void
> > > early_init_fdt_scan_reserved_mem(void) {}
> > > +static inline void free_early_init_fdt_scan_reserved_mem(void) {}
> > >  static inline const char *of_flat_dt_get_machine_name(void) { return
> > > NULL; }  static inline void unflatten_device_tree(void) {}  static
> > > inline void unflatten_and_copy_device_tree(void) {}
> > > --
> > > 2.1.0
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

