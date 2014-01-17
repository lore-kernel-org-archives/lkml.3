Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaAQVif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 16:38:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAQVid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 16:38:33 -0500
Date: Fri, 17 Jan 2014 13:38:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: hannes@cmpxchg.org, liuj97@gmail.com, santosh.shilimkar@ti.com,
        grygorii.strashko@ti.com, iamjoonsoo.kim@lge.com,
        robin.m.holt@gmail.com, yinghai@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm/nobootmem: Fix unused variable
Message-Id: <20140117133831.2a9306a03f9c6174ff096e48@linux-foundation.org>
In-Reply-To: <1389879186-43649-1-git-send-email-phacht@linux.vnet.ibm.com>
References: <1389879186-43649-1-git-send-email-phacht@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 14:33:06 +0100 Philipp Hachtmann <phacht@linux.vnet.ibm.com> wrote:

> This fixes an unused variable warning in nobootmem.c
> 
> ...
>
> --- a/mm/nobootmem.c
> +++ b/mm/nobootmem.c
> @@ -116,9 +116,13 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
>  static unsigned long __init free_low_memory_core_early(void)
>  {
>  	unsigned long count = 0;
> -	phys_addr_t start, end, size;
> +	phys_addr_t start, end;
>  	u64 i;
>  
> +#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
> +	phys_addr_t size;
> +#endif
> +
>  	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
>  		count += __free_memory_core(start, end);

Yes, that is a bit of an eyesore.  We often approach the problem this
way, which is nicer:

static unsigned long __init free_low_memory_core_early(void)
{
	unsigned long count = 0;
	phys_addr_t start, end;
	u64 i;

	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
		count += __free_memory_core(start, end);

#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
	{
		phys_addr_t size;

		/* Free memblock.reserved array if it was allocated */
		size = get_allocated_memblock_reserved_regions_info(&start);
		if (size)
			count += __free_memory_core(start, start + size);

		/* Free memblock.memory array if it was allocated */
		size = get_allocated_memblock_memory_regions_info(&start);
		if (size)
			count += __free_memory_core(start, start + size);
	}
#endif

	return count;
}

