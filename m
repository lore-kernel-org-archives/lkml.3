Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaLKNUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:20:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbaLKNUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:20:02 -0500
Date: Thu, 11 Dec 2014 14:19:38 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, akpm <akpm@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, iamjoonsoo@lge.com,
        brouer@redhat.com
Subject: Re: [PATCH 3/7] slub: Do not use c->page on free
Message-ID: <20141211141938.6420b94a@redhat.com>
In-Reply-To: <alpine.DEB.2.11.1412101136520.6639@gentwo.org>
References: <20141210163017.092096069@linux.com>
	<20141210163033.717707217@linux.com>
	<CAOJsxLFEN_w7q6NvbxkH2KTujB9auLkQgskLnGtN9iBQ4hV9sw@mail.gmail.com>
	<alpine.DEB.2.11.1412101107350.6291@gentwo.org>
	<CAOJsxLH4BGT9rGgg_4nxUMgW3sdEzLrmX2WtM8Ld3aytdR5e8g@mail.gmail.com>
	<alpine.DEB.2.11.1412101136520.6639@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Dec 2014 11:37:56 -0600 (CST) Christoph Lameter <cl@linux.com> wrote:

[...]
> 
> There were some other issues so its now:
> 
> 
> Subject: slub: Do not use c->page on free
> 
> Avoid using the page struct address on free by just doing an
> address comparison. That is easily doable now that the page address
> is available in the page struct and we already have the page struct
> address of the object to be freed calculated.
> 
> Reviewed-by: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/mm/slub.c
> ===================================================================
> --- linux.orig/mm/slub.c	2014-12-10 11:35:32.538563734 -0600
> +++ linux/mm/slub.c	2014-12-10 11:36:39.032447807 -0600
> @@ -2625,6 +2625,17 @@ slab_empty:
>  	discard_slab(s, page);
>  }
> 
> +static bool is_pointer_to_page(struct page *page, void *p)
> +{
> +	long d = p - page->address;
> +
> +	/*
> +	 * Do a comparison for a MAX_ORDER page first before using
> +	 * compound_order() to determine the actual page size.
> +	 */
> +	return d >= 0 && d < (1 << MAX_ORDER) && d < (compound_order(page) << PAGE_SHIFT);
> +}

My current compiler (gcc 4.9.1), choose not to inline is_pointer_to_page().

 (perf record of [1])
 Samples: 8K of event 'cycles', Event count (approx.): 5737618489
 +   46.13%  modprobe  [kernel.kallsyms]  [k] kmem_cache_free
 +   33.02%  modprobe  [kernel.kallsyms]  [k] kmem_cache_alloc
 +   16.14%  modprobe  [kernel.kallsyms]  [k] is_pointer_to_page

If I explicitly add "inline", then it gets inlined, and performance is good again.

Test[1] cost of kmem_cache_alloc+free:
 * baseline: 47 cycles(tsc) 19.032 ns  (net-next without patchset)
 * patchset: 50 cycles(tsc) 20.028 ns
 * inline  : 45 cycles(tsc) 18.135 ns  (inlined is_pointer_to_page())


>  /*
>   * Fastpath with forced inlining to produce a kfree and kmem_cache_free that
>   * can perform fastpath freeing without additional function calls.
> @@ -2658,7 +2669,7 @@ redo:
>  	tid = c->tid;
>  	preempt_enable();
> 
> -	if (likely(page == c->page)) {
> +	if (likely(is_pointer_to_page(page, c->freelist))) {
>  		set_freepointer(s, object, c->freelist);
> 
>  		if (unlikely(!this_cpu_cmpxchg_double(


[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_kmem_cache1.c

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
