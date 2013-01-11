Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3AKKsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:48:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab3AKKsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:48:02 -0500
Date: Fri, 11 Jan 2013 11:47:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wen Congyang <wency@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Wu Jianguo <wujianguo@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmots: memory-hotplug: implement
 register_page_bootmem_info_section of sparse-vmemmap fix
Message-ID: <20130111104759.GF7286@dhcp22.suse.cz>
References: <20130111095658.GC7286@dhcp22.suse.cz>
 <20130111101745.GD7286@dhcp22.suse.cz>
 <20130111102924.GE7286@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130111102924.GE7286@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11-01-13 11:29:24, Michal Hocko wrote:
> On Fri 11-01-13 11:17:45, Michal Hocko wrote:
> [...]
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > index be2b90c..59eddff 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -128,6 +128,64 @@ void __ref put_page_bootmem(struct page *page)
> >  
> >  }
> >  
> > +void register_page_bootmem_memmap(unsigned long section_nr,
> > +				  struct page *start_page, unsigned long size)
> > +{
> > +	unsigned long addr = (unsigned long)start_page;
> > +	unsigned long end = (unsigned long)(start_page + size);
> > +	unsigned long next;
> > +	pgd_t *pgd;
> > +	pud_t *pud;
> > +	pmd_t *pmd;
> > +	unsigned int nr_pages;
> > +	struct page *page;
> > +
> > +	for (; addr < end; addr = next) {
> > +		pte_t *pte = NULL;
> > +
> > +		pgd = pgd_offset_k(addr);
> > +		if (pgd_none(*pgd)) {
> > +			next = (addr + PAGE_SIZE) & PAGE_MASK;
> > +			continue;
> > +		}
> > +		get_page_bootmem(section_nr, pgd_page(*pgd), MIX_SECTION_INFO);
> > +
> > +		pud = pud_offset(pgd, addr);
> > +		if (pud_none(*pud)) {
> > +			next = (addr + PAGE_SIZE) & PAGE_MASK;
> > +			continue;
> > +		}
> > +		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
> > +
> > +		if (!cpu_has_pse) {
> 
> Darn! And now that I am looking at the patch closer it is too x86
> centric so this cannot be in the generic code. I will try to cook
> something better. Sorry about the noise.

It is more complicated than I thought. One would tell it's a mess.
The patch bellow fixes the compilation issue but I am not sure we want
to include memory_hotplug.h into arch/x86/mm/init_64.c. Moreover

+void register_page_bootmem_memmap(unsigned long section_nr,
+				  struct page *start_page, unsigned long size)
+{
+	/* TODO */
+}

for other archs would suggest that the code is not ready yet. Should
this rather be dropped for now?
---
>From 2c79d0467132c7e236b0fdf98a7d5c43ed6640a5 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 11 Jan 2013 10:50:42 +0100
Subject: [PATCH] memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap.patch
 fix
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Defconfig for x86_64 complains
arch/x86/mm/init_64.c: In function ‘register_page_bootmem_memmap’:
arch/x86/mm/init_64.c:1340: error: implicit declaration of function ‘get_page_bootmem’
arch/x86/mm/init_64.c:1340: error: ‘MIX_SECTION_INFO’ undeclared (first
use in this function)
arch/x86/mm/init_64.c:1340: error: (Each undeclared identifier is
reported only once
arch/x86/mm/init_64.c:1340: error: for each function it appears in.)
arch/x86/mm/init_64.c:1361: error: ‘SECTION_INFO’ undeclared (first use in this function)

put register_page_bootmem_memmap inside CONFIG_MEMORY_HOTPLUG_SPARSE
and include memory_hotplug.h in arch/x86/mm/init_64.c

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 arch/x86/mm/init_64.c |    3 +++
 include/linux/mm.h    |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ddd3b58..d8edf52 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -32,6 +32,7 @@
 #include <linux/memory_hotplug.h>
 #include <linux/nmi.h>
 #include <linux/gfp.h>
+#include <linux/memory_hotplug.h>
 
 #include <asm/processor.h>
 #include <asm/bios_ebda.h>
@@ -1317,6 +1318,7 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
 	return 0;
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 void register_page_bootmem_memmap(unsigned long section_nr,
 				  struct page *start_page, unsigned long size)
 {
@@ -1374,6 +1376,7 @@ void register_page_bootmem_memmap(unsigned long section_nr,
 		}
 	}
 }
+#endif
 
 void __meminit vmemmap_populate_print_last(void)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c57bd0..67e0c31 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1724,8 +1724,10 @@ void vmemmap_populate_print_last(void);
 #ifdef CONFIG_MEMORY_HOTPLUG
 void vmemmap_free(struct page *memmap, unsigned long nr_pages);
 #endif
+#ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
 				  unsigned long size);
+#endif
 
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
