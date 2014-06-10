Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaFJIFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:05:51 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:55013 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaFJIFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:05:47 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 10 Jun 2014 17:09:35 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: akpm@linux-foundation.org, cl@linux.com, rientjes@google.com,
        penberg@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm v2 7/8] slub: make dead memcg caches discard free
 slabs immediately
Message-ID: <20140610080935.GG19036@js1304-P5Q-DELUXE>
References: <cover.1402060096.git.vdavydov@parallels.com>
 <3b53266b76556dd042bbf6147207c70473572a7e.1402060096.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b53266b76556dd042bbf6147207c70473572a7e.1402060096.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 05:22:44PM +0400, Vladimir Davydov wrote:
> Since a dead memcg cache is destroyed only after the last slab allocated
> to it is freed, we must disable caching of empty slabs for such caches,
> otherwise they will be hanging around forever.
> 
> This patch makes SLUB discard dead memcg caches' slabs as soon as they
> become empty. To achieve that, it disables per cpu partial lists for
> dead caches (see put_cpu_partial) and forbids keeping empty slabs on per
> node partial lists by setting cache's min_partial to 0 on
> kmem_cache_shrink, which is always called on memcg offline (see
> memcg_unregister_all_caches).
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Thanks-to: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  mm/slub.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index e46d6abe8a68..1dad7e2c586a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2015,6 +2015,8 @@ static void unfreeze_partials(struct kmem_cache *s,
>  #endif
>  }
>  
> +static void flush_all(struct kmem_cache *s);
> +
>  /*
>   * Put a page that was just frozen (in __slab_free) into a partial page
>   * slot if available. This is done without interrupts disabled and without
> @@ -2064,6 +2066,21 @@ static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
>  
>  	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
>  								!= oldpage);
> +
> +	if (memcg_cache_dead(s)) {
> +               bool done = false;
> +               unsigned long flags;
> +
> +               local_irq_save(flags);
> +               if (this_cpu_read(s->cpu_slab->partial) == page) {
> +                       unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
> +                       done = true;
> +               }
> +               local_irq_restore(flags);
> +
> +               if (!done)
> +                       flush_all(s);
> +	}

Now, slab_free() is non-preemptable so flush_all() isn't needed.

Thanks.

