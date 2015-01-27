Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbbA0BSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:18:24 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:45862 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbbA0BST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:18:19 -0500
Message-ID: <1422320515.2493.53.camel@misato.fc.hp.com>
Subject: Re: [RFC PATCH 2/7] lib: Add huge I/O map capability interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, arnd@arndb.de,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Jan 2015 18:01:55 -0700
In-Reply-To: <20150126155456.a40df49e42b1b7f8077421f4@linux-foundation.org>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
	 <1422314009-31667-3-git-send-email-toshi.kani@hp.com>
	 <20150126155456.a40df49e42b1b7f8077421f4@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-26 at 15:54 -0800, Andrew Morton wrote:
> On Mon, 26 Jan 2015 16:13:24 -0700 Toshi Kani <toshi.kani@hp.com> wrote:
> 
> > Add ioremap_pud_enabled() and ioremap_pmd_enabled(), which
> > return 1 when I/O mappings of pud/pmd are enabled on the kernel.
> > 
> > ioremap_huge_init() calls arch_ioremap_pud_supported() and
> > arch_ioremap_pmd_supported() to initialize the capabilities.
> > 
> > A new kernel option "nohgiomap" is also added, so that user can
> > disable the huge I/O map capabilities if necessary.
> 
> Why?  What's the problem with leaving it enabled?

No, there should not be any problem with leaving it enabled.  This
option is added as a way to workaround a problem when someone hit an
issue unexpectedly.

> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2304,6 +2304,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  			register save and restore. The kernel will only save
> >  			legacy floating-point registers on task switch.
> >  
> > +	nohgiomap	[KNL,x86] Disable huge I/O mappings.
> 
> That reads like "no high iomap" to me.  "nohugeiomap" would be better.

Agreed.  Will use "nohugeiomap".

> > --- a/lib/ioremap.c
> > +++ b/lib/ioremap.c
> > @@ -13,6 +13,44 @@
> >  #include <asm/cacheflush.h>
> >  #include <asm/pgtable.h>
> >  
> > +#ifdef CONFIG_HUGE_IOMAP
> > +int __read_mostly ioremap_pud_capable;
> > +int __read_mostly ioremap_pmd_capable;
> > +int __read_mostly ioremap_huge_disabled;
> > +
> > +static int __init set_nohgiomap(char *str)
> > +{
> > +	ioremap_huge_disabled = 1;
> > +	return 0;
> > +}
> > +early_param("nohgiomap", set_nohgiomap);
> 
> Why early?

On my system, the first ioremap() call is made at:

  start_kernel()
   -> late_time_init()
     -> x86_late_time_init()
       -> hpet_time_init()

I think this is too early for module_param().  Also, lib/ioremap.c is
not really a module.

> > +static inline void ioremap_huge_init(void)
> > +{
> > +	if (!ioremap_huge_disabled) {
> > +		if (arch_ioremap_pud_supported())
> > +			ioremap_pud_capable = 1;
> > +		if (arch_ioremap_pmd_supported())
> > +			ioremap_pmd_capable = 1;
> > +	}
> > +}
> > +
> > +static inline int ioremap_pud_enabled(void)
> > +{
> > +	return ioremap_pud_capable;
> > +}
> > +
> > +static inline int ioremap_pmd_enabled(void)
> > +{
> > +	return ioremap_pmd_capable;
> > +}
> > +
> > +#else	/* !CONFIG_HUGE_IOMAP */
> > +static inline void ioremap_huge_init(void) { }
> > +static inline int ioremap_pud_enabled(void) { return 0; }
> > +static inline int ioremap_pmd_enabled(void) { return 0; }
> > +#endif	/* CONFIG_HUGE_IOMAP */
> > +
> >  static int ioremap_pte_range(pmd_t *pmd, unsigned long addr,
> >  		unsigned long end, phys_addr_t phys_addr, pgprot_t prot)
> >  {
> > @@ -74,6 +112,12 @@ int ioremap_page_range(unsigned long addr,
> >  	unsigned long start;
> >  	unsigned long next;
> >  	int err;
> > +	static int ioremap_huge_init_done;
> > +
> > +	if (!ioremap_huge_init_done) {
> > +		ioremap_huge_init_done = 1;
> > +		ioremap_huge_init();
> > +	}
> 
> Looks hacky.  Why can't we just get the startup ordering correct?  It
> at least needs a comment which fully explains the situation.

How about calling it from mm_init() after vmalloc_init()?  

void __init mm_init(void)
		:
        percpu_init_late();
        pgtable_init();
        vmalloc_init();
+       ioremap_huge_init();
 }

Thanks,
-Toshi


