Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaANTWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:22:35 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54050 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaANTW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:22:29 -0500
MIME-Version: 1.0
In-Reply-To: <1389613034-35196-2-git-send-email-phacht@linux.vnet.ibm.com>
References: <1389613034-35196-1-git-send-email-phacht@linux.vnet.ibm.com>
	<1389613034-35196-2-git-send-email-phacht@linux.vnet.ibm.com>
Date: Tue, 14 Jan 2014 11:22:28 -0800
X-Google-Sender-Auth: Kajj3XjsmtS1wk1sW6qZMyNq2bY
Message-ID: <CAE9FiQUwAr1naCF1wBQN1xKYkb_BwS7w3bmpt8ugB=bQhOGL+Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/nobootmem: free_all_bootmem again
From: Yinghai Lu <yinghai@kernel.org>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Xishi Qiu <qiuxishi@huawei.com>,
        David Howells <dhowells@redhat.com>, daeseok.youn@gmail.com,
        Jiang Liu <liuj97@gmail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, grygorii.strashko@ti.com,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 3:37 AM, Philipp Hachtmann
<phacht@linux.vnet.ibm.com> wrote:
> get_allocated_memblock_reserved_regions_info() should work if it is
> compiled in. Extended the ifdef around
> get_allocated_memblock_memory_regions_info() to include
> get_allocated_memblock_reserved_regions_info() as well.
> Similar changes in nobootmem.c/free_low_memory_core_early() where
> the two functions are called.
>
> Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>

Acked-by: Yinghai Lu <yinghai@kernel.org>

> ---
>  mm/memblock.c  | 17 ++---------------
>  mm/nobootmem.c |  4 ++--
>  2 files changed, 4 insertions(+), 17 deletions(-)
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 64ed243..9c0aeef 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -266,33 +266,20 @@ static void __init_memblock memblock_remove_region(struct memblock_type *type, u
>         }
>  }
>
> +#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
> +
>  phys_addr_t __init_memblock get_allocated_memblock_reserved_regions_info(
>                                         phys_addr_t *addr)
>  {
>         if (memblock.reserved.regions == memblock_reserved_init_regions)
>                 return 0;
>
> -       /*
> -        * Don't allow nobootmem allocator to free reserved memory regions
> -        * array if
> -        *  - CONFIG_DEBUG_FS is enabled;
> -        *  - CONFIG_ARCH_DISCARD_MEMBLOCK is not enabled;
> -        *  - reserved memory regions array have been resized during boot.
> -        * Otherwise debug_fs entry "sys/kernel/debug/memblock/reserved"
> -        * will show garbage instead of state of memory reservations.
> -        */
> -       if (IS_ENABLED(CONFIG_DEBUG_FS) &&
> -           !IS_ENABLED(CONFIG_ARCH_DISCARD_MEMBLOCK))
> -               return 0;
> -
>         *addr = __pa(memblock.reserved.regions);
>
>         return PAGE_ALIGN(sizeof(struct memblock_region) *
>                           memblock.reserved.max);
>  }
>
> -#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
> -
>  phys_addr_t __init_memblock get_allocated_memblock_memory_regions_info(
>                                         phys_addr_t *addr)
>  {
> diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> index 17c8902..e2906a5 100644
> --- a/mm/nobootmem.c
> +++ b/mm/nobootmem.c
> @@ -122,13 +122,13 @@ static unsigned long __init free_low_memory_core_early(void)
>         for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
>                 count += __free_memory_core(start, end);
>
> +#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
> +
>         /* Free memblock.reserved array if it was allocated */
>         size = get_allocated_memblock_reserved_regions_info(&start);
>         if (size)
>                 count += __free_memory_core(start, start + size);
>
> -#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
> -
>         /* Free memblock.memory array if it was allocated */
>         size = get_allocated_memblock_memory_regions_info(&start);
>         if (size)
> --
> 1.8.4.5
>
