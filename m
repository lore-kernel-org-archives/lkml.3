Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650Ab3DHBfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 21:35:54 -0400
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:53290 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934610Ab3DHBfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 21:35:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAKgdYlGVhxBY/2dsb2JhbAANRMRggRmDEwEBAQMBAQIkUgULCxgJJQ8CFy8GDQEFAgEBiAqqEpJAjyMHg0EDlDWMNYhtgUg
X-IronPort-AV: E=Sophos;i="4.87,427,1363104000"; 
   d="scan'208";a="333310277"
X-WN-REMOTEIP: 149.135.16.88
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 333310277
X-WN-SMTPAUTHID: gregungerer
Message-ID: <51621E92.10400@uclinux.org>
Date: Mon, 08 Apr 2013 11:34:10 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: Re: [PATCH v4, part3 24/41] mm/m68k: prepare for removing num_physpages
 and simplify mem_init()
References: <1365258760-30821-1-git-send-email-jiang.liu@huawei.com> <1365258760-30821-25-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1365258760-30821-25-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/13 00:32, Jiang Liu wrote:
> Prepare for removing num_physpages and simplify mem_init().
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Greg Ungerer <gerg@uclinux.org>

Acked-by: Greg Ungerer <gerg@uclinux.org


> Cc: linux-m68k@lists.linux-m68k.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/m68k/mm/init.c |   31 ++-----------------------------
>  1 file changed, 2 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
> index 2485a8c..0723141 100644
> --- a/arch/m68k/mm/init.c
> +++ b/arch/m68k/mm/init.c
> @@ -149,33 +149,11 @@ void __init print_memmap(void)
>  void __init mem_init(void)
>  {
>  	pg_data_t *pgdat;
> -	int codepages = 0;
> -	int datapages = 0;
> -	int initpages = 0;
>  	int i;
>  
>  	/* this will put all memory onto the freelists */
> -	num_physpages = 0;
> -	for_each_online_pgdat(pgdat) {
> -		num_physpages += pgdat->node_present_pages;
> -
> +	for_each_online_pgdat(pgdat)
>  		free_all_bootmem_node(pgdat);
> -		for (i = 0; i < pgdat->node_spanned_pages; i++) {
> -			struct page *page = pgdat->node_mem_map + i;
> -			char *addr = page_to_virt(page);
> -
> -			if (!PageReserved(page))
> -				continue;
> -			if (addr >= _text &&
> -			    addr < _etext)
> -				codepages++;
> -			else if (addr >= __init_begin &&
> -				 addr < __init_end)
> -				initpages++;
> -			else
> -				datapages++;
> -		}
> -	}
>  
>  #if defined(CONFIG_MMU) && !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
>  	/* insert pointer tables allocated so far into the tablelist */
> @@ -190,12 +168,7 @@ void __init mem_init(void)
>  		init_pointer_table((unsigned long)zero_pgtable);
>  #endif
>  
> -	pr_info("Memory: %luk/%luk available (%dk kernel code, %dk data, %dk init)\n",
> -	       nr_free_pages() << (PAGE_SHIFT-10),
> -	       totalram_pages << (PAGE_SHIFT-10),
> -	       codepages << (PAGE_SHIFT-10),
> -	       datapages << (PAGE_SHIFT-10),
> -	       initpages << (PAGE_SHIFT-10));
> +	mem_init_print_info(NULL);
>  	print_memmap();
>  }
>  
> 

