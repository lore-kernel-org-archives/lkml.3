Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3KNIbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:31:15 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:49270 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3KNIbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:31:12 -0500
Date: Thu, 14 Nov 2013 09:31:04 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/17] tile: Remove tile-specific _sinitdata and
 _einitdata
In-Reply-To: <528414A6.8090208@tilera.com>
Message-ID: <alpine.DEB.2.02.1311140927170.9407@ayla.of.borg>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-11-git-send-email-geert@linux-m68k.org> <528414A6.8090208@tilera.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Chris,

On Wed, 13 Nov 2013, Chris Metcalf wrote:
> On 11/12/2013 2:42 PM, Geert Uytterhoeven wrote:
> > Use standard __init_begin and __init_end instead.
> >
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> [...]
> > @@ -534,7 +534,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
> >  
> >  		BUG_ON(address != (unsigned long)_text);
> >  		pte = NULL;
> > -		for (; address < (unsigned long)_einittext;
> > +		for (; address < (unsigned long)__init_end;
> >  		     pfn++, address += PAGE_SIZE) {
> >  			pte_ofs = pte_index(address);
> >  			if (pte_ofs == 0) {
> > @@ -572,7 +572,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
> >  		else
> >  			pteval = hv_pte_set_mode(pteval,
> >  						 HV_PTE_MODE_CACHE_NO_L3);
> > -		for (; address < (unsigned long)_einittext;
> > +		for (; address < (unsigned long)__init_end;
> >  		     pfn += PFN_DOWN(HPAGE_SIZE), address += HPAGE_SIZE)
> >  			*(pte_t *)(pmd++) = pfn_pte(pfn, pteval);
> >  	}
> > @@ -632,9 +632,9 @@ int devmem_is_allowed(unsigned long pagenr)
> >  {
> >  	return pagenr < kaddr_to_pfn(_end) &&
> >  		!(pagenr >= kaddr_to_pfn(&init_thread_union) ||
> > -		  pagenr < kaddr_to_pfn(_einitdata)) &&
> > +		  pagenr < kaddr_to_pfn(__init_end)) &&
> >  		!(pagenr >= kaddr_to_pfn(_sinittext) ||
> > -		  pagenr <= kaddr_to_pfn(_einittext-1));
> > +		  pagenr <= kaddr_to_pfn(__init_end-1));
> >  }
> >  
> >  #ifdef CONFIG_HIGHMEM
> [...]
> > @@ -984,7 +984,7 @@ void free_initmem(void)
> >  	 */
> >  	free_init_pages("unused kernel text",
> >  			(unsigned long)_sinittext - text_delta,
> > -			(unsigned long)_einittext - text_delta);
> > +			(unsigned long)__init_end - text_delta);
> >  	/* Do a global TLB flush so everyone sees the changes. */
> >  	flush_tlb_all();
> >  }
> 
> These changes are touching _einittext, and they shouldn't.  Only bomb _einitdata (and _sinitdata).

Woops, that's a serious brain fart. Sorry about that, and thanks for
noticing!

> With those changes removed:
> 
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
> 
> or let me know if you'd rather I staged your v2 change into the tile tree.

Feel free to take v2 below. Thanks!

>From d761d4d63945ff0a6eab5a9058c132f870c92aff Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 8 Nov 2013 21:33:29 +0100
Subject: [PATCH -v2] tile: Remove tile-specific _sinitdata and _einitdata

Use standard __init_begin and __init_end instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
---
v2: Remove bogus _einittext changes.

 arch/tile/include/asm/sections.h |    3 ---
 arch/tile/kernel/vmlinux.lds.S   |    2 --
 arch/tile/mm/init.c              |   10 +++++-----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/tile/include/asm/sections.h b/arch/tile/include/asm/sections.h
index 5d5d3b739a6b..86a746243dc8 100644
--- a/arch/tile/include/asm/sections.h
+++ b/arch/tile/include/asm/sections.h
@@ -19,9 +19,6 @@
 
 #include <asm-generic/sections.h>
 
-/* Text and data are at different areas in the kernel VA space. */
-extern char _sinitdata[], _einitdata[];
-
 /* Write-once data is writable only till the end of initialization. */
 extern char __w1data_begin[], __w1data_end[];
 
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index f1819423ffc9..0e059a0101ea 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -66,11 +66,9 @@ SECTIONS
 
   . = ALIGN(PAGE_SIZE);
   __init_begin = .;
-  VMLINUX_SYMBOL(_sinitdata) = .;
   INIT_DATA_SECTION(16) :data =0
   PERCPU_SECTION(L2_CACHE_BYTES)
   . = ALIGN(PAGE_SIZE);
-  VMLINUX_SYMBOL(_einitdata) = .;
   __init_end = .;
 
   _sdata = .;                   /* Start of data section */
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 0fa1acfac79a..489a5a00cfaa 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -254,7 +254,7 @@ static pgprot_t __init init_pgprot(ulong address)
 	 * Everything else that isn't data or bss is heap, so mark it
 	 * with the initial heap home (hash-for-home, or this cpu).  This
 	 * includes any addresses after the loaded image and any address before
-	 * _einitdata, since we already captured the case of text before
+	 * __init_end, since we already captured the case of text before
 	 * _sinittext, and __pa(einittext) is approximately __pa(sinitdata).
 	 *
 	 * All the LOWMEM pages that we mark this way will get their
@@ -263,7 +263,7 @@ static pgprot_t __init init_pgprot(ulong address)
 	 * homes, but with a zero free_time we don't have to actually
 	 * do a flush action the first time we use them, either.
 	 */
-	if (address >= (ulong) _end || address < (ulong) _einitdata)
+	if (address >= (ulong) _end || address < (ulong) __init_end)
 		return construct_pgprot(PAGE_KERNEL, initial_heap_home());
 
 	/* Use hash-for-home if requested for data/bss. */
@@ -632,7 +632,7 @@ int devmem_is_allowed(unsigned long pagenr)
 {
 	return pagenr < kaddr_to_pfn(_end) &&
 		!(pagenr >= kaddr_to_pfn(&init_thread_union) ||
-		  pagenr < kaddr_to_pfn(_einitdata)) &&
+		  pagenr < kaddr_to_pfn(__init_end)) &&
 		!(pagenr >= kaddr_to_pfn(_sinittext) ||
 		  pagenr <= kaddr_to_pfn(_einittext-1));
 }
@@ -975,8 +975,8 @@ void free_initmem(void)
 
 	/* Free the data pages that we won't use again after init. */
 	free_init_pages("unused kernel data",
-			(unsigned long)_sinitdata,
-			(unsigned long)_einitdata);
+			(unsigned long)__init_begin,
+			(unsigned long)__init_end);
 
 	/*
 	 * Free the pages mapped from 0xc0000000 that correspond to code
-- 
1.7.9.5

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
