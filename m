Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab3AKK31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:29:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54620 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab3AKK30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:29:26 -0500
Date: Fri, 11 Jan 2013 11:29:24 +0100
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
Message-ID: <20130111102924.GE7286@dhcp22.suse.cz>
References: <20130111095658.GC7286@dhcp22.suse.cz>
 <20130111101745.GD7286@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130111101745.GD7286@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 11-01-13 11:17:45, Michal Hocko wrote:
[...]
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index be2b90c..59eddff 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -128,6 +128,64 @@ void __ref put_page_bootmem(struct page *page)
>  
>  }
>  
> +void register_page_bootmem_memmap(unsigned long section_nr,
> +				  struct page *start_page, unsigned long size)
> +{
> +	unsigned long addr = (unsigned long)start_page;
> +	unsigned long end = (unsigned long)(start_page + size);
> +	unsigned long next;
> +	pgd_t *pgd;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +	unsigned int nr_pages;
> +	struct page *page;
> +
> +	for (; addr < end; addr = next) {
> +		pte_t *pte = NULL;
> +
> +		pgd = pgd_offset_k(addr);
> +		if (pgd_none(*pgd)) {
> +			next = (addr + PAGE_SIZE) & PAGE_MASK;
> +			continue;
> +		}
> +		get_page_bootmem(section_nr, pgd_page(*pgd), MIX_SECTION_INFO);
> +
> +		pud = pud_offset(pgd, addr);
> +		if (pud_none(*pud)) {
> +			next = (addr + PAGE_SIZE) & PAGE_MASK;
> +			continue;
> +		}
> +		get_page_bootmem(section_nr, pud_page(*pud), MIX_SECTION_INFO);
> +
> +		if (!cpu_has_pse) {

Darn! And now that I am looking at the patch closer it is too x86
centric so this cannot be in the generic code. I will try to cook
something better. Sorry about the noise.
[...]
-- 
Michal Hocko
SUSE Labs
