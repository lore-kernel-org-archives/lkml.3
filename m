Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762181Ab3DDPtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 11:49:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761807Ab3DDPtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 11:49:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH v2, part1 03/29] mm/ARM: use common help functions to free reserved pages
Date: Thu, 4 Apr 2013 15:47:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org
References: <1362896833-21104-1-git-send-email-jiang.liu@huawei.com> <1362896833-21104-4-git-send-email-jiang.liu@huawei.com>
In-Reply-To: <1362896833-21104-4-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304041547.52539.arnd@arndb.de>
X-Provags-ID: V02:K0:fyFiFrAMn2LztEPlu693ciFENDPq/qgMt5hbr3Bz/mA
 i4Dw4UQF6KdD7/QtOFgxyMJXuRs1y4nfvHg6No/lkdPmGA3dvX
 u/gglAL0ChH7yzSe0LRccmS2HQ5U+XKGc2HlL+F/mI8w7dTv1L
 RVQdunve2LprMIrk2n0VB8lwRYIPNIsf1rlBe8poBF6QohFFHr
 VxEBlKofmWAA4IybkB+JKqc+tv8QkEOdFCTmMjsNxF+g6Plf9F
 /7lj8qLGbiONJ3iuNB2C/VMBUXZKdqfi1/UxKP+pZARrpihr1l
 o/dh0x6mIS4NbdO/Oe/BXXZrABhgGHeo18ZTNSA1jYN6P2vYQj
 CCFodGJqEP/BFh12NMIQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 March 2013, Jiang Liu wrote:
> Use common help functions to free reserved pages.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org

Hello Jiang Liu,

I'm getting a few new build warnings from this patch in linux-next, can you please
have a look what's going on here? 

> @@ -609,8 +600,7 @@ void __init mem_init(void)
>  
>  #ifdef CONFIG_SA1111
>  	/* now that our DMA memory is actually so designated, we can free it */
> -	totalram_pages += free_area(PHYS_PFN_OFFSET,
> -				    __phys_to_pfn(__pa(swapper_pg_dir)), NULL);
> +	free_reserved_area(__va(PHYS_PFN_OFFSET), swapper_pg_dir, 0, NULL);
>  #endif

Using neponset_defconfig:

arch/arm/mm/init.c: In function 'mem_init':
arch/arm/mm/init.c:603:2: warning: passing argument 1 of 'free_reserved_area' makes integer from pointer without a cast [enabled by default]
  free_reserved_area(__va(PHYS_PFN_OFFSET), swapper_pg_dir, 0, NULL);
  ^
In file included from include/linux/mman.h:4:0,
                 from arch/arm/mm/init.c:15:
include/linux/mm.h:1301:22: note: expected 'long unsigned int' but argument is of type 'void *'
 extern unsigned long free_reserved_area(unsigned long start, unsigned long end,
                      ^

> @@ -738,16 +728,12 @@ void free_initmem(void)
>  	extern char __tcm_start, __tcm_end;
>  
>  	poison_init_mem(&__tcm_start, &__tcm_end - &__tcm_start);
> -	totalram_pages += free_area(__phys_to_pfn(__pa(&__tcm_start)),
> -				    __phys_to_pfn(__pa(&__tcm_end)),
> -				    "TCM link");
> +	free_reserved_area(&__tcm_start, &__tcm_end, 0, "TCM link");
>  #endif

Using one of {realview,s3c6400,u300}_defconfig:

/git/arm-soc/arch/arm/mm/init.c: In function 'free_initmem':
/git/arm-soc/arch/arm/mm/init.c:731:2: warning: passing argument 1 of 'free_reserved_area' makes integer from pointer without a cast [enabled by default]
  free_reserved_area(&__tcm_start, &__tcm_end, 0, "TCM link");
  ^
In file included from /git/arm-soc/include/linux/mman.h:4:0,
                 from /git/arm-soc/arch/arm/mm/init.c:15:
/git/arm-soc/include/linux/mm.h:1301:22: note: expected 'long unsigned int' but argument is of type 'char *'
 extern unsigned long free_reserved_area(unsigned long start, unsigned long end,
                      ^

	Arnd
