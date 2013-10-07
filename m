Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab3JGXyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:54:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3JGXyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:54:13 -0400
Date: Mon, 7 Oct 2013 16:54:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm/page_alloc.c: Implement an empty
 get_pfn_range_for_nid
Message-Id: <20131007165411.92370f7f6119decee7fbbcba@linux-foundation.org>
In-Reply-To: <52504CF8.6000708@gmail.com>
References: <52504CF8.6000708@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Oct 2013 01:31:36 +0800 Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:

> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> 
> Implement an empty get_pfn_range_for_nid for !CONFIG_HAVE_MEMBLOCK_NODE_MAP,
> so that we could remove the #ifdef in free_area_init_node.
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4566,6 +4566,11 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
>  }
>  
>  #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
> +void __meminit get_pfn_range_for_nid(unsigned int nid,
> +			unsigned long *ignored, unsigned long *ignored)
> +{
> +}
> +
>  static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
>  					unsigned long zone_type,
>  					unsigned long node_start_pfn,
> @@ -4871,9 +4876,7 @@ void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
>  	pgdat->node_id = nid;
>  	pgdat->node_start_pfn = node_start_pfn;
>  	init_zone_allows_reclaim(nid);
> -#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
>  	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
> -#endif
>  	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
>  				  zones_size, zholes_size);

Dunno, really.  This will make the kernel a tiny bit larger by
generating an out-of-line empty function which nobody calls.  This
could be fixed by making this static inline, but it's strange to have
one version of get_pfn_range_for_nid() static inline and the other
global, uninlined.

Is it worth adding a few bytes to vmlinux just to make the source a little
tidier?
