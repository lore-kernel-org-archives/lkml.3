Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab3EOTod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:44:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:44881 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab3EOToc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:44:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,679,1363158000"; 
   d="scan'208";a="338191016"
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Dave Hansen <dave@sr71.net>, Christoph Lameter <cl@linux.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/22] mm: page allocator: Split magazine lock in two to reduce contention
References: <1368028987-8369-1-git-send-email-mgorman@suse.de>
	<1368028987-8369-19-git-send-email-mgorman@suse.de>
Date: Wed, 15 May 2013 12:44:31 -0700
In-Reply-To: <1368028987-8369-19-git-send-email-mgorman@suse.de> (Mel Gorman's
	message of "Wed, 8 May 2013 17:03:03 +0100")
Message-ID: <m24ne43u5c.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:
>  
> -static inline struct free_area_magazine *find_lock_filled_magazine(struct zone *zone)
> +static inline struct free_magazine *find_lock_magazine(struct zone *zone)
>  {
> -	struct free_area_magazine *area = &zone->_noirq_magazine;
> -	if (!area->nr_free)
> +	int i = (raw_smp_processor_id() >> 1) & (NR_MAGAZINES-1);
> +	int start = i;
> +
> +	do {
> +		if (spin_trylock(&zone->noirq_magazine[i].lock))
> +			goto out;

I'm not sure doing it this way is great. It optimizes for lock
contention vs the initial cost of just fetching the cache line.
Doing the try lock already has to fetch the cache line, even
if the lock is contended.

Page allocation should be limited more by the cache line bouncing
than long contention

So you may be paying the fetch cost multiple times without actually
amortizing it.

If you want to do it this way I would read the lock only. That can
be much cheaper because it doesn't have to take the cache line 
exclusive. It may still need to transfer it though (because another
CPU just took it exclusive), which may be already somewhat expensive.

So overall I'm not sure it's a good idea.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
