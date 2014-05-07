Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaEGPh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:37:27 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:57540 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaEGPhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:37:22 -0400
Date: Wed, 7 May 2014 11:37:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] workqueue: destroy worker directly in the idle
 timeout handler
Message-ID: <20140507153718.GA26540@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-5-git-send-email-laijs@cn.fujitsu.com>
 <20140505143613.GD11231@htj.dyndns.org>
 <5369DC5C.20001@cn.fujitsu.com>
 <20140507131257.GB16702@htj.dyndns.org>
 <CACvQF50kdodjDGnaxgQC2sW82rvkFVLtWQDOn90cohNkzG-oZw@mail.gmail.com>
 <20140507134142.GF16702@htj.dyndns.org>
 <CACvQF52KPp++-eMx+4sy+NeAGdTMg_L2kM9rBOToXGcVQ4TzAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF52KPp++-eMx+4sy+NeAGdTMg_L2kM9rBOToXGcVQ4TzAA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Wed, May 07, 2014 at 11:30:35PM +0800, Lai Jiangshan wrote:
> > Hah?  How much extra complexity are we talking about?  It's a single
> > if, no?
> 
>         DECLARE_COMPLETION_ONSTACK(completion);
> #1
> 
>         ...
> 
>         while ((worker = first_worker(pool))) {
>                 destroy_worker(worker);
>                 pool->detach_completion = &completion;
> #2
>         }
> 
>         ...
>         unlock;
> 
>         if (pool->detach_completion)
>                 wait_for_completion();
> #3
> 
> One thing is separated into 3 places and about 5~7lines.
> I hope a single wait_for_completion() or single wait_event().

This is negligible amount of complexity contained in a single
function.

> get_unbound_pool():
> fail:
>     if (pool)
>         put_unbound_pool(pool);
> 
> I think we can change it into:
> 
> fail:
>     if (pool) {
>         if (pool->id >= 0)
>             idr_remove(&worker_pool_idr, pool->id);
>         call_rcu_sched(&pool->rcu, rcu_free_pool);
>     }

This is destruction logic unnecessarily duplicated in two places,
which is shittier to maintain when the destruction path changes.

There's more to complexity than simple number of lines.  It sure is a
minute difference here but I find the obsessions with LOC a bit
disturbing.  That's just one aspect and involving more lines doesn't
necessarily mean it's more complex.

Thanks.

-- 
tejun
