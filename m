Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbbAOILf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:11:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbbAOILe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:11:34 -0500
Date: Thu, 15 Jan 2015 09:10:58 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>, brouer@redhat.com
Subject: Re: [PATCH v2 1/2] mm/slub: optimize alloc/free fastpath by
 removing preemption on/off
Message-ID: <20150115091058.07d0ae25@redhat.com>
In-Reply-To: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1421307633-24045-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 16:40:32 +0900
Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

[...]
> 
> I saw roughly 5% win in a fast-path loop over kmem_cache_alloc/free
> in CONFIG_PREEMPT. (14.821 ns -> 14.049 ns)
> 
> Below is the result of Christoph's slab_test reported by
> Jesper Dangaard Brouer.
>
[...]

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> Acked-by: Christoph Lameter <cl@linux.com>
> Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  mm/slub.c |   35 +++++++++++++++++++++++------------
>  1 file changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index fe376fe..ceee1d7 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2398,13 +2398,24 @@ redo:
[...]
>  	 */
> -	preempt_disable();
> -	c = this_cpu_ptr(s->cpu_slab);
> +	do {
> +		tid = this_cpu_read(s->cpu_slab->tid);
> +		c = this_cpu_ptr(s->cpu_slab);
> +	} while (IS_ENABLED(CONFIG_PREEMPT) && unlikely(tid != c->tid));
> +
> +	/*
> +	 * Irqless object alloc/free alogorithm used here depends on sequence

Spelling of algorithm contains a typo ^^ 

> +	 * of fetching cpu_slab's data. tid should be fetched before anything
> +	 * on c to guarantee that object and page associated with previous tid
> +	 * won't be used with current tid. If we fetch tid first, object and
> +	 * page could be one associated with next tid and our alloc/free
> +	 * request will be failed. In this case, we will retry. So, no problem.
> +	 */
> +	barrier();

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
