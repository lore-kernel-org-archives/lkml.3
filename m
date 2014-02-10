Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaBJX1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:27:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbaBJX1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:27:41 -0500
Date: Mon, 10 Feb 2014 15:27:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        mgorman@suse.de, aarcange@redhat.com, andi@firstfloor.org,
        riel@redhat.com
Subject: Re: [PATCH 1/4] memblock: memblock_virt_alloc_internal(): alloc
 from specified node only
Message-Id: <20140210152739.6253f77b78ec9ef7d971ddd2@linux-foundation.org>
In-Reply-To: <1392053268-29239-2-git-send-email-lcapitulino@redhat.com>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
	<1392053268-29239-2-git-send-email-lcapitulino@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 12:27:45 -0500 Luiz Capitulino <lcapitulino@redhat.com> wrote:

> From: Luiz capitulino <lcapitulino@redhat.com>
> 
> If an allocation from the node specified by the nid argument fails,
> memblock_virt_alloc_internal() automatically tries to allocate memory
> from other nodes.
> 
> This is fine is the caller don't care which node is going to allocate
> the memory. However, there are cases where the caller wants memory to
> be allocated from the specified node only. If that's not possible, then
> memblock_virt_alloc_internal() should just fail.
> 
> This commit adds a new flags argument to memblock_virt_alloc_internal()
> where the caller can control this behavior.
> 
> ...
>
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1028,6 +1028,8 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
>  	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
>  }
>  
> +#define ALLOC_SPECIFIED_NODE_ONLY 0x1
> +
>  /**
>   * memblock_virt_alloc_internal - allocate boot memory block
>   * @size: size of memory block to be allocated in bytes
> @@ -1058,7 +1060,7 @@ phys_addr_t __init memblock_alloc_try_nid(phys_addr_t size, phys_addr_t align, i
>  static void * __init memblock_virt_alloc_internal(
>  				phys_addr_t size, phys_addr_t align,
>  				phys_addr_t min_addr, phys_addr_t max_addr,
> -				int nid)
> +				int nid, unsigned int flags)
>  {
>  	phys_addr_t alloc;
>  	void *ptr;
> @@ -1085,6 +1087,8 @@ again:
>  					    nid);
>  	if (alloc)
>  		goto done;
> +	else if (flags & ALLOC_SPECIFIED_NODE_ONLY)
> +		goto error;

"else" is unneeded.

>  	if (nid != NUMA_NO_NODE) {
>  		alloc = memblock_find_in_range_node(size, align, min_addr,
>
> ...
>
