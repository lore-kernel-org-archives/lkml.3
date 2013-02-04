Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3BDVEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:04:36 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:39513 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab3BDVEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:04:35 -0500
Date: Mon, 4 Feb 2013 13:04:29 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] workqueue: enhance locking and record global
 worker id for work data
Message-ID: <20130204210429.GB27963@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

Generally, I *really* like where you're headed but like before it's a
bit difficult for me to apply the patches as-is.  Please read on.

On Fri, Feb 01, 2013 at 02:41:23AM +0800, Lai Jiangshan wrote:
> Better Locking:
> mainly based on *mb() which is the most dangerous code and bad for readability.
> This series change the usage of CWQ bit and makes these code simpler.
> 	--PATCH 3,4,5

Yeah, that's one ugly piece of memory barrier magic which has been
around forever.  I never bothered with it as it was fairly localized
and not broken.  I *do* like removing it.  A bit on the fence about
adding another field to delayed_work tho.  The @cpu addition was about
correctness but this one doesn't really buy us anything other than
cleaner code.  Folding the wq field into work_struct would be ugly,
right?  Hmmm....

> We have get_work_pool(), but it requires the caller do the later check and locking,
> we replace it which 3 better internal locking API. 1) More proper API and
> 2) merge the duplicated code and 3) simplify the caller.
> 	--PATCH 8,9,10

This mostly leads up to gwid change, right?

> get_work_pool()/get_work_pool_id() are called everywhere, something they are
> overkill(called idr_find() unneeded) and indirectly(caller knows it is onq or not),
> we replace them with get_work_cwq()/offq_work_pool_id()/locking APIs.
> 	--PATCH 3,4,5,6,8,9,10

Can't we just make get_work_pool_id() do a fast path if OFFQ than
requiring the user to distinguish off and on queue cases?

> Safely/one-step searching and worker id:
> ----------------------------------------
> 
> We are planing to add non-std worker_pool, but old get_work_pool() or new
> lock_pool_executing_work() was not prepared for this plan, idr_find(pool_id)
> is unsafe when we introduce free-able non-std worker_pool. Although we can
> fix it by adding rcu to worker_pool. but "recording global worker id for
> work data and adding rcu to worker" is another way and more straight forward.
> We implement the later one,  Now, lock_pool_executing_work() is ready for this plan.
> 	--PATCH 12,13
>
> When every time we need to find out the running worker from a work,
> we need two searches: search work_pool from work's data, and search worker
> from hash. We record global worker id for work data and we only need one search.
> 	--PATCH 13

While I'm a bit worried about capping total number of workers by the
amount bits left in work->data, if that doesn't cause any practical
issue (how many do we have available on 32bit?), I think this is the
better approach.  We couldn't do this before because work -> worker
relationship could be 1:N but it should now be doable.  Note that we
need RCU no matter what we index (pool or worker) to avoid locking on
each lookup.

So, I like both major changes made by the patchset and most changes
seem correct, well at least on casual review that is.

The problem is that I'm not very happy with the descriptions and
comments (what's up with the weird /** formatting?).  At least for me,
the patchset is quite difficult to follow.  I'm not sure whether it
has actual organizational issues or the descriptions aren't detailed /
clear enough yet.

>From past experience, I *think* it's gonna be a bit of struggle for
both of us to get the series in a shape that I would find acceptable
by reviewing and iterating, so I might just swallow it and regurgitate
into a form that I like.  Hmm.... dunno.  Will think about it.

Anyways, nice work.

Thanks.

-- 
tejun
