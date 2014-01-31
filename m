Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbaAaVCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 16:02:50 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41748 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbaAaVCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 16:02:48 -0500
Date: Fri, 31 Jan 2014 13:02:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Petr Tesarik <ptesarik@suse.cz>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jiang Liu <liuj97@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix the initialization of physnode_map
In-Reply-To: <20140131110517.4b7e86d6@hananiah.suse.cz>
Message-ID: <alpine.DEB.2.02.1401311255380.27318@chino.kir.corp.google.com>
References: <20140131110517.4b7e86d6@hananiah.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014, Petr Tesarik wrote:

> With DISCONTIGMEM, the mapping between a pfn and its owning node is
> initialized using data provided by the BIOS or from the command line.
> However, the initialization may fail if the extents are not aligned
> to section boundary (64M).
> 
> The symptom of this bug is an early boot failure in pfn_to_page(),
> as it tries to access NODE_DATA(__nid) using index from an unitialized
> element of the physnode_map[] array.
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

What's missing here is how you're trying to fix the issue.

> diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
> index 0342d27..f278b04 100644
> --- a/arch/x86/mm/numa_32.c
> +++ b/arch/x86/mm/numa_32.c
> @@ -46,15 +46,16 @@ EXPORT_SYMBOL(physnode_map);
>  
>  void memory_present(int nid, unsigned long start, unsigned long end)
>  {
> -	unsigned long pfn;
> +	unsigned long sect, endsect;
>  
>  	printk(KERN_INFO "Node: %d, start_pfn: %lx, end_pfn: %lx\n",
>  			nid, start, end);
>  	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
>  	printk(KERN_DEBUG "  ");
> -	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
> -		physnode_map[pfn / PAGES_PER_SECTION] = nid;
> -		printk(KERN_CONT "%lx ", pfn);
> +	endsect = (end - 1) / PAGES_PER_SECTION;
> +	for (sect = start / PAGES_PER_SECTION; sect <= endsect; ++sect) {
> +		physnode_map[sect] = nid;
> +		printk(KERN_CONT "%lx ", sect * PAGES_PER_SECTION);
>  	}
>  	printk(KERN_CONT "\n");
>  }

This looks more like refactoring than anything else and doesn't make it 
clear at all what the fix is.
