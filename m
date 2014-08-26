Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbaHZOxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:53:42 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16369 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755399AbaHZOxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:53:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/e9IKes0KTvD/qiWccAXne
Date: Tue, 26 Aug 2014 07:53:11 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] pstore/ram_core: Fix hang on ARMs because of
 pgprot_noncached
Message-ID: <20140826145311.GT17254@atomide.com>
References: <20140825231449.GS17254@atomide.com>
 <4959575.hJIGzK9yj7@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4959575.hJIGzK9yj7@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [140826 02:16]:
> On Monday 25 August 2014 16:14:50 Tony Lindgren wrote:
> > -static void *persistent_ram_vmap(phys_addr_t start, size_t size)
> > +static void *persistent_ram_vmap(phys_addr_t start, size_t size,
> > +               unsigned int cached)
> >  {
> >         struct page **pages;
> >         phys_addr_t page_start;
> > @@ -392,7 +393,10 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
> >         page_start = start - offset_in_page(start);
> >         page_count = DIV_ROUND_UP(size + offset_in_page(start), PAGE_SIZE);
> >  
> > -       prot = pgprot_noncached(PAGE_KERNEL);
> > +       if (cached)
> > +               prot = pgprot_writecombine(PAGE_KERNEL);
> > +       else
> > +               prot = pgprot_noncached(PAGE_KERNEL);
> >  
> >         pages = kmalloc_array(page_count, sizeof(struct page *), GFP_KERNEL);
> >         if (!pages) {
> 
> If you have a 'struct page', you also have a cacheable mapping in the kernel already,
> so you are not really supposed to add another uncached mapping. On some architectures
> (e.g. powerpc) that will cause the CPU to checkstop, on others it is undefined
> behavior. What is the reason for using an uncached mapping here in the first place?

The reason for using uncached mapping (really strongly ordered for ARM)
here is because Colin observed lost debug prints just before hanging register
writes because of the write buffer.

But it also sounds like pstore is broken for powerpc in addition to a bunch of
ARMs, and possibly other architectures too.
 
> > @@ -411,8 +415,11 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size)
> >         return vaddr;
> >  }
> >  
> > -static void *persistent_ram_iomap(phys_addr_t start, size_t size)
> > +static void *persistent_ram_iomap(phys_addr_t start, size_t size,
> > +               unsigned int cached)
> >  {
> > +       void *va;
> > +
> >         if (!request_mem_region(start, size, "persistent_ram")) {
> >                 pr_err("request mem region (0x%llx@0x%llx) failed\n",
> >                         (unsigned long long)size, (unsigned long long)start);
> > @@ -422,19 +429,24 @@ static void *persistent_ram_iomap(phys_addr_t start, size_t size)
> >         buffer_start_add = buffer_start_add_locked;
> >         buffer_size_add = buffer_size_add_locked;
> >  
> > -       return ioremap(start, size);
> > +       if (cached)
> > +               va = ioremap(start, size);
> > +       else
> > +               va = ioremap_wc(start, size);
> > +
> > +       return va;
> >  }
> 
> This seems confusing at best, but is probably just wrong: so you use
> an uncached mapping if someone asks for cached, but use a (more relaxed)
> write-combining mapping if someone asked for a stricter mapping?
> It's also the other way round for persistent_ram_vmap above.

Indeed, the cached test for the ioremap is the wrong way around here.
 
> According to your description, the intention is to make atomic operations
> work, however most architectures don't allow atomics on either type of
> uncached mapping, since atomicity is a feature of the cache coherency
> fabric.
> 
> The only way I see to actually make atomics work here is to use a cached
> mapping and explicit dcache flushes to actually force the data into
> persistent storage.

Right, that's what Rob attempted to patch a while back:

https://lkml.org/lkml/2013/4/9/831

See also the comments from Colin in that thread:

https://lkml.org/lkml/2013/4/9/854

The reason why I added the module_param is because Rob's fix did not
go anywhere for over a year now. And adding the module_param seemed to
help with the concerns Colin had. Personally I don't need the strongly
ordered option though, I just need pgprot_writecombine :)

It's starting to sound that we should first apply Rob's original fix
to get pstore working. Then we can figure out how to deal with the
unbuffered mapping for architectures and SoCs that support it.

Regards,

Tony
