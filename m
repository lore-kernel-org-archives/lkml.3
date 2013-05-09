Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab3EIPVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 11:21:16 -0400
Received: from www.sr71.net ([198.145.64.142]:58559 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729Ab3EIPVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 11:21:15 -0400
Message-ID: <518BBEE9.7060800@sr71.net>
Date: Thu, 09 May 2013 08:21:13 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Linux-MM <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/22] mm: page allocator: Split magazine lock in two
 to reduce contention
References: <1368028987-8369-1-git-send-email-mgorman@suse.de> <1368028987-8369-19-git-send-email-mgorman@suse.de>
In-Reply-To: <1368028987-8369-19-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 09:03 AM, Mel Gorman wrote:
> @@ -368,10 +375,9 @@ struct zone {
>  
>  	/*
>  	 * Keep some order-0 pages on a separate free list
> -	 * protected by an irq-unsafe lock
> +	 * protected by an irq-unsafe lock.
>  	 */
> -	spinlock_t			_magazine_lock;
> -	struct free_area_magazine	_noirq_magazine;
> +	struct free_magazine	noirq_magazine[NR_MAGAZINES];

Looks like pretty cool stuff!

The old per-cpu-pages stuff was all hung off alloc_percpu(), which
surely wasted lots of memory with many NUMA nodes.  It's nice to see
this decoupled a bit from the online cpu count.

That said, the alloc_percpu() stuff is nice in how much it hides from
you when doing cpu hotplug.  We'll _probably_ need this to be
dynamically-sized at some point, right?

> -static inline struct free_area_magazine *find_lock_magazine(struct zone *zone)
> +static inline struct free_magazine *lock_magazine(struct zone *zone)
>  {
> -	struct free_area_magazine *area = &zone->_noirq_magazine;
> -	spin_lock(&zone->_magazine_lock);
> -	return area;
> +	int i = (raw_smp_processor_id() >> 1) & (NR_MAGAZINES-1);
> +	spin_lock(&zone->noirq_magazine[i].lock);
> +	return &zone->noirq_magazine[i];
>  }

I bet this logic will be fun to play with once we have more magazines
around.  For instance, on my system processors 0/80 are HT twins, so
they'd always be going after the same magazine.  I guess that's a good
thing.
