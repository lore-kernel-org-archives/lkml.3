Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaBCXkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:40:01 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:59496 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaBCXj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:39:59 -0500
Date: Mon, 3 Feb 2014 15:39:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, ptesarik@suse.cz
Subject: Re: + arch-x86-mm-numa_32c-fix-the-initialization-of-physnode_map.patch
 added to -mm tree
In-Reply-To: <52f01c8b.ExcxiTlno1BIC/r9%akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1402031537490.7643@chino.kir.corp.google.com>
References: <52f01c8b.ExcxiTlno1BIC/r9%akpm@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, akpm@linux-foundation.org wrote:

> From: Petr Tesarik <ptesarik@suse.cz>
> Subject: arch/x86/mm/numa_32.c: fix the initialization of physnode_map
> 
> With DISCONTIGMEM, the mapping between a pfn and its owning node is
> initialized using data provided by the BIOS.  However, the initialization
> may fail if the extents are not aligned to section boundary (64M).
> 
> The symptom of this bug is an early boot failure in pfn_to_page(), as it
> tries to access NODE_DATA(__nid) using index from an unitialized element
> of the physnode_map[] array.
> 
> While the bug is always present, it is more likely to be hit in kdump
> kernels on large machines, because:
> 
> 1. The memory map for a kdump kernel is specified as exactmap, and
>    exactmap is more likely to be unaligned.
> 
> 2. Large reservations are more likely to span across a 64M boundary.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  arch/x86/mm/numa_32.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff -puN arch/x86/mm/numa_32.c~arch-x86-mm-numa_32c-fix-the-initialization-of-physnode_map arch/x86/mm/numa_32.c
> --- a/arch/x86/mm/numa_32.c~arch-x86-mm-numa_32c-fix-the-initialization-of-physnode_map
> +++ a/arch/x86/mm/numa_32.c
> @@ -52,6 +52,8 @@ void memory_present(int nid, unsigned lo
>  			nid, start, end);
>  	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
>  	printk(KERN_DEBUG "  ");
> +	pfn = round_down(pfn, PAGES_PER_SECTION);
> +	end = round_up(end, PAGES_PER_SECTION);
>  	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
>  		physnode_map[pfn / PAGES_PER_SECTION] = nid;
>  		printk(KERN_CONT "%lx ", pfn);

This is the buggy version of the patch which erroneously rounds down the 
uninitialized "pfn" rather than "start".  hpa has already merged the 
corrected patch into x86/urgent.
