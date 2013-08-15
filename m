Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab3HOUnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:43:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3HOUnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:43:50 -0400
Date: Thu, 15 Aug 2013 13:43:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Russ Anderson <rja@sgi.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memblock, numa: Binary search node id
Message-Id: <20130815134348.bb119a7987af0bb64ed77b7b@linux-foundation.org>
In-Reply-To: <1376545589-32129-1-git-send-email-yinghai@kernel.org>
References: <1376545589-32129-1-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 22:46:29 -0700 Yinghai Lu <yinghai@kernel.org> wrote:

> Current early_pfn_to_nid() on arch that support memblock go
> over memblock.memory one by one, so will take too many try
> near the end.
> 
> We can use existing memblock_search to find the node id for
> given pfn, that could save some time on bigger system that
> have many entries memblock.memory array.

Looks nice.  I wonder how much difference it makes.
 
> ...
>
> --- linux-2.6.orig/include/linux/memblock.h
> +++ linux-2.6/include/linux/memblock.h
> @@ -60,6 +60,8 @@ int memblock_reserve(phys_addr_t base, p
>  void memblock_trim_memory(phys_addr_t align);
>  
>  #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
> +int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
> +			    unsigned long  *end_pfn);
>  void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
>  			  unsigned long *out_end_pfn, int *out_nid);
>  
> Index: linux-2.6/mm/memblock.c
> ===================================================================
> --- linux-2.6.orig/mm/memblock.c
> +++ linux-2.6/mm/memblock.c
> @@ -914,6 +914,24 @@ int __init_memblock memblock_is_memory(p
>  	return memblock_search(&memblock.memory, addr) != -1;
>  }
>  
> +#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
> +int __init_memblock memblock_search_pfn_nid(unsigned long pfn,
> +			 unsigned long *start_pfn, unsigned long *end_pfn)
> +{
> +	struct memblock_type *type = &memblock.memory;
> +	int mid = memblock_search(type, (phys_addr_t)pfn << PAGE_SHIFT);
> +
> +	if (mid == -1)
> +		return -1;
> +
> +	*start_pfn = type->regions[mid].base >> PAGE_SHIFT;
> +	*end_pfn = (type->regions[mid].base + type->regions[mid].size)
> +			>> PAGE_SHIFT;
> +
> +	return type->regions[mid].nid;
> +}
> +#endif

This function will have no callers if
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y.  That's not too bad as the
function is __init_memblock.  But this depends on
CONFIG_ARCH_DISCARD_MEMBLOCK.  Messy :(


