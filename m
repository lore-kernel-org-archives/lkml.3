Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3AKMHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:07:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65452 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab3AKMHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:07:39 -0500
X-IronPort-AV: E=Sophos;i="4.84,452,1355068800"; 
   d="scan'208";a="6568159"
Message-ID: <50F00051.4070509@cn.fujitsu.com>
Date: Fri, 11 Jan 2013 20:06:41 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jianguo Wu <wujianguo@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmots: memory-hotplug-remove-memmap-of-sparse-vmemmap.patch compile
 fix
References: <20130111095348.GB7286@dhcp22.suse.cz>
In-Reply-To: <20130111095348.GB7286@dhcp22.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/11 20:07:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/11 20:07:01
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It looks fine to me.
Tested-by: Lin Feng <linfeng@cn.fujitsu.com>

On 01/11/2013 05:53 PM, Michal Hocko wrote:
> Defconfig for x86_64 complains:
> arch/x86/mm/init_64.c: In function ‘vmemmap_free’:
> arch/x86/mm/init_64.c:1317: error: implicit declaration of function ‘remove_pagetable’
> 
> vmemmap_free is only used for CONFIG_MEMORY_HOTPLUG so let's move it
> inside ifdef
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  arch/x86/mm/init_64.c |   16 ++++++++--------
>  include/linux/mm.h    |    2 ++
>  2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 9920ffc..ddd3b58 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -981,6 +981,14 @@ remove_pagetable(unsigned long start, unsigned long end, bool direct)
>  	flush_tlb_all();
>  }
>  
> +void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
> +{
> +	unsigned long start = (unsigned long)memmap;
> +	unsigned long end = (unsigned long)(memmap + nr_pages);
> +
> +	remove_pagetable(start, end, false);
> +}
> +
>  static void __meminit
>  kernel_physical_mapping_remove(unsigned long start, unsigned long end)
>  {
> @@ -1309,14 +1317,6 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
>  	return 0;
>  }
>  
> -void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
> -{
> -	unsigned long start = (unsigned long)memmap;
> -	unsigned long end = (unsigned long)(memmap + nr_pages);
> -
> -	remove_pagetable(start, end, false);
> -}
> -
>  void register_page_bootmem_memmap(unsigned long section_nr,
>  				  struct page *start_page, unsigned long size)
>  {
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0d880df..7c57bd0 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1721,7 +1721,9 @@ int vmemmap_populate_basepages(struct page *start_page,
>  						unsigned long pages, int node);
>  int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
>  void vmemmap_populate_print_last(void);
> +#ifdef CONFIG_MEMORY_HOTPLUG
>  void vmemmap_free(struct page *memmap, unsigned long nr_pages);
> +#endif
>  void register_page_bootmem_memmap(unsigned long section_nr, struct page *map,
>  				  unsigned long size);
>  
> 
