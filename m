Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3LJXjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:39:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3LJXjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:39:10 -0500
Date: Tue, 10 Dec 2013 15:39:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, page_alloc: make __GFP_NOFAIL really not fail
Message-Id: <20131210153909.8b4bfa1d643e5f8582eff7c9@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1312101504120.22701@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312091355360.11026@chino.kir.corp.google.com>
	<20131209152202.df3d4051d7dc61ada7c420a9@linux-foundation.org>
	<alpine.DEB.2.02.1312101504120.22701@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013 15:20:17 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> On Mon, 9 Dec 2013, Andrew Morton wrote:
> 
> > > __GFP_NOFAIL specifies that the page allocator cannot fail to return
> > > memory.  Allocators that call it may not even check for NULL upon
> > > returning.
> > > 
> > > It turns out GFP_NOWAIT | __GFP_NOFAIL or GFP_ATOMIC | __GFP_NOFAIL can
> > > actually return NULL.  More interestingly, processes that are doing
> > > direct reclaim and have PF_MEMALLOC set may also return NULL for any
> > > __GFP_NOFAIL allocation.
> > 
> > __GFP_NOFAIL is a nasty thing and making it pretend to work even better
> > is heading in the wrong direction, surely?  It would be saner to just
> > disallow these even-sillier combinations.  Can we fix up the current
> > callers then stick a WARN_ON() in there?
> > 
> 
> Heh, it's difficult to remove __GFP_NOFAIL when new users get added: 
> 84235de394d9 ("fs: buffer: move allocation failure loop into the 
> allocator") added a new user

That wasn't reeeeealy a new user - it was "convert an existing
open-coded retry-for-ever loop".  Which is what __GFP_NOFAIL is for.

I don't think I've ever seen anyone actually fix one of these things
(by teaching the caller to handle ENOMEM), so it obviously isn't
working...

> and a bypass of memcg limits in oom 
> conditions so __GFP_NOFAIL just essentially became 
> __GFP_BYPASS_MEMCG_LIMIT_ON_OOM.
> 
> We can probably ignore the PF_MEMALLOC behavior since it allows full 
> access to memory reserves and the only time we would see a __GFP_NOFAIL 
> allocation fail in such a context is if every zone's free memory was 0.  
> We have bigger problems if memory reserves are completely depleted like 
> that, so it's probably sufficient not to address it.
> 
> I'd be concerned about new users of __GFP_NOFAIL that are added for 
> GFP_NOWAIT or GFP_ATOMIC and never actually trigger such a warning because 
> in testing they never trigger the slowpath, but the conditional is 
> probably better placed outside of the fastpath:
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2536,8 +2536,15 @@ rebalance:
>  	}
>  
>  	/* Atomic allocations - we can't balance anything */
> -	if (!wait)
> +	if (!wait) {
> +		/*
> +		 * All existing users of the deprecated __GFP_NOFAIL are
> +		 * blockable, so warn of any new users that actually allow this
> +		 * type of allocation to fail.
> +		 */
> +		WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL);
>  		goto nopage;
> +	}

Seems sensible.

> But perhaps the best way to do this in a preventative way is to add a 
> warning to checkpatch.pl that actually warns about adding new users.

yup.
