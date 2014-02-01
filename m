Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaBAMNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 07:13:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbaBAMNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 07:13:19 -0500
Date: Sat, 1 Feb 2014 13:13:12 +0100
From: Petr Tesarik <ptesarik@suse.cz>
To: Dave Hansen <dave@sr71.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix the initialization of physnode_map
Message-ID: <20140201131312.5b63fde3@hananiah.suse.cz>
In-Reply-To: <52EC1235.30909@sr71.net>
References: <20140131110517.4b7e86d6@hananiah.suse.cz>
	<52EC1235.30909@sr71.net>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 13:14:29 -0800
Dave Hansen <dave@sr71.net> wrote:

> On 01/31/2014 02:05 AM, Petr Tesarik wrote:
> > With DISCONTIGMEM, the mapping between a pfn and its owning node is
> > initialized using data provided by the BIOS or from the command line.
> > However, the initialization may fail if the extents are not aligned
> > to section boundary (64M).
> 
> So is this a problem that shows up with DISCONTIGMEM?

Yes, that's it.

> Just curious, but
> what the heck kind of 32-bit NUMA hardware is still in the wild?  Did
> someon buy a NUMA-Q on eBay? :)

In fact, this is a patch that has been floating around in SUSE
Enterprise kernels for some time. It was originally added to pass
certification on IBM SurePOS 700 x4900-785.

When cleaning up our kernel patches, I noticed that the bug is still
present in the upstream kernel, so I posted this patch. While I don't
have any evidence that someone actually needs the fix today, it seems
wrong to leave buggy code in the kernel.

If you all agree that we rip off DISCONTIGMEM instead, I can post
patches to do that and be equally happy. ;-)

> >  void memory_present(int nid, unsigned long start, unsigned long end)
> >  {
> > -	unsigned long pfn;
> > +	unsigned long sect, endsect;
> >  
> >  	printk(KERN_INFO "Node: %d, start_pfn: %lx, end_pfn: %lx\n",
> >  			nid, start, end);
> >  	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
> >  	printk(KERN_DEBUG "  ");
> > -	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
> > -		physnode_map[pfn / PAGES_PER_SECTION] = nid;
> > -		printk(KERN_CONT "%lx ", pfn);
> > +	endsect = (end - 1) / PAGES_PER_SECTION;
> > +	for (sect = start / PAGES_PER_SECTION; sect <= endsect; ++sect) {
> > +		physnode_map[sect] = nid;
> > +		printk(KERN_CONT "%lx ", sect * PAGES_PER_SECTION);
> >  	}
> >  	printk(KERN_CONT "\n");
> >  }
> 
> So, if start and end are not aligned to section boundaries, we will miss
> setting physnode_map[] for the final section?

If end belongs to a different section than start, the final section
will not be initialized, yes.

> For instance, if we have a 64MB section size and try to call
> memory_present(32MB -> 96MB), we will set 0->64MB present, but not set
> the 64MB->128MB section as present.
> 
> Right?

Exactly.

> Can you just align 'start' down to the section's start and 'end' up to
> the end of the section that contains it?  I guess you do that
> implicitly, but you should be able to do it without refactoring the for
> loop entirely.

Works for me.

Petr Tesarik
