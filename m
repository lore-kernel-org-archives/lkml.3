Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934962Ab3E2Rny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 13:43:54 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:55365 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171Ab3E2Rnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 13:43:47 -0400
Message-ID: <51A63E51.2060202@cogentembedded.com>
Date: Wed, 29 May 2013 21:43:45 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        linux-m68k@vger.kernel.org
Subject: Re: [PATCH, v2 13/13] mm/m68k: fix build warning of unused variable
References: <1369838692-26860-1-git-send-email-jiang.liu@huawei.com> <1369838692-26860-14-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1369838692-26860-14-git-send-email-jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/29/2013 06:44 PM, Jiang Liu wrote:

> Fix build warning of unused variable:
> arch/m68k/mm/init.c: In function 'mem_init':
> arch/m68k/mm/init.c:151:6: warning: unused variable 'i' [-Wunused-variable]
>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Cc: linux-m68k@lists.linux-m68k.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   arch/m68k/mm/init.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
> index 6e0a938..6b4baa6 100644
> --- a/arch/m68k/mm/init.c
> +++ b/arch/m68k/mm/init.c
> @@ -146,14 +146,11 @@ void __init print_memmap(void)
>   		MLK_ROUNDUP(__bss_start, __bss_stop));
>   }
>   
> -void __init mem_init(void)
> +static inline void init_pointer_tables(void)
>   {
> +#if defined(CONFIG_MMU) && !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)

    #ifdef's in the function bodies are frowned upon, this should better be:

#if defined(CONFIG_MMU) && !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)

static inline void init_pointer_tables(void)
{
[...]
}
#else
static inline void init_pointer_tables(void) {}
#endif

>   	int i;
>   
> -	/* this will put all memory onto the freelists */
> -	free_all_bootmem();
> -
> -#if defined(CONFIG_MMU) && !defined(CONFIG_SUN3) && !defined(CONFIG_COLDFIRE)
>   	/* insert pointer tables allocated so far into the tablelist */
>   	init_pointer_table((unsigned long)kernel_pg_dir);
>   	for (i = 0; i < PTRS_PER_PGD; i++) {
> @@ -165,7 +162,13 @@ void __init mem_init(void)
>   	if (zero_pgtable)
>   		init_pointer_table((unsigned long)zero_pgtable);
>   #endif
> +}
>   
> +void __init mem_init(void)
> +{
> +	/* this will put all memory onto the freelists */
> +	free_all_bootmem();
> +	init_pointer_tables();
>   	mem_init_print_info(NULL);
>   	print_memmap();
>   }

WBR, Sergei

