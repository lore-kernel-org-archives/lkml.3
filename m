Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaIXOQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:16:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaIXOQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:16:36 -0400
Date: Wed, 24 Sep 2014 16:16:33 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>, Dave Hansen <dave@sr71.net>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: lockless page counters
Message-ID: <20140924141633.GB4558@dhcp22.suse.cz>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
 <20140922144158.GC20398@esperanza>
 <20140922185736.GB6630@cmpxchg.org>
 <20140923110634.GH18526@esperanza>
 <20140923132801.GA14302@cmpxchg.org>
 <20140923152150.GL18526@esperanza>
 <20140923170525.GA28460@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923170525.GA28460@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 23-09-14 13:05:25, Johannes Weiner wrote:
[...]
>  #include <trace/events/vmscan.h>
>  
> -int page_counter_sub(struct page_counter *counter, unsigned long nr_pages)
> +/**
> + * page_counter_cancel - take pages out of the local counter
> + * @counter: counter
> + * @nr_pages: number of pages to cancel
> + *
> + * Returns whether there are remaining pages in the counter.
> + */
> +int page_counter_cancel(struct page_counter *counter, unsigned long nr_pages)
>  {
>  	long new;
>  
>  	new = atomic_long_sub_return(nr_pages, &counter->count);
>  
> -	if (WARN_ON(unlikely(new < 0)))
> -		atomic_long_set(&counter->count, 0);
> +	if (WARN_ON_ONCE(unlikely(new < 0)))
> +		atomic_long_add(nr_pages, &counter->count);
>  
>  	return new > 0;
>  }

I am not sure I understand this correctly.

The original res_counter code has protection against < 0 because it used
unsigned longs and wanted to protect from really disturbing effects of
underflow I guess (this wasn't documented anywhere). But you are using
long so even underflow shouldn't be a big problem so why do we need a
fixup?

The only way how we can end up < 0 would be a cancel without pairing
charge AFAICS. A charge should always appear before uncharge
because both of them are using atomics which imply memory barriers
(atomic_*_return). So do I understand correctly that your motivation
is to fix up those cancel-without-charge automatically? This would
definitely ask for a fat comment. Or am I missing something?

Besides that do we need to have any memory barrier there?

Thanks!
-- 
Michal Hocko
SUSE Labs
