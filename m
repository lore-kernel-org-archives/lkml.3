Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3BEQT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:19:29 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:49402 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3BEQT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:19:27 -0500
MIME-Version: 1.0
In-Reply-To: <20130204210429.GB27963@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
	<20130204210429.GB27963@mtj.dyndns.org>
Date: Wed, 6 Feb 2013 00:19:26 +0800
Message-ID: <CACvQF52Lqi2TuXc9oCdGkAzxcpE12YfuX=9-jp5tePsOqPBe6w@mail.gmail.com>
Subject: Re: [PATCH 00/13] workqueue: enhance locking and record global worker
 id for work data
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 5:04 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Lai.
>
> Generally, I *really* like where you're headed but like before it's a
> bit difficult for me to apply the patches as-is.  Please read on.
>
> On Fri, Feb 01, 2013 at 02:41:23AM +0800, Lai Jiangshan wrote:
>> Better Locking:
>> mainly based on *mb() which is the most dangerous code and bad for readability.
>> This series change the usage of CWQ bit and makes these code simpler.
>>       --PATCH 3,4,5
>
> Yeah, that's one ugly piece of memory barrier magic which has been
> around forever.  I never bothered with it as it was fairly localized
> and not broken.  I *do* like removing it.  A bit on the fence about
> adding another field to delayed_work tho.  The @cpu addition was about
> correctness but this one doesn't really buy us anything other than
> cleaner code.  Folding the wq field into work_struct would be ugly,
> right?  Hmmm....
>
>> We have get_work_pool(), but it requires the caller do the later check and locking,
>> we replace it which 3 better internal locking API. 1) More proper API and
>> 2) merge the duplicated code and 3) simplify the caller.
>>       --PATCH 8,9,10
>
> This mostly leads up to gwid change, right?
>
>> get_work_pool()/get_work_pool_id() are called everywhere, something they are
>> overkill(called idr_find() unneeded) and indirectly(caller knows it is onq or not),
>> we replace them with get_work_cwq()/offq_work_pool_id()/locking APIs.
>>       --PATCH 3,4,5,6,8,9,10
>
> Can't we just make get_work_pool_id() do a fast path if OFFQ than
> requiring the user to distinguish off and on queue cases?

old code, get_work_pool_id() is only called when offq.
after series applied, offq_work_worker_id() *must* be called only when offq,
and we can't offer get_work_worker_id().

so removing get_work_pool_id() and using offq_work_pool_id() instead
are preparing.



>
>> Safely/one-step searching and worker id:
>> ----------------------------------------
>>
>> We are planing to add non-std worker_pool, but old get_work_pool() or new
>> lock_pool_executing_work() was not prepared for this plan, idr_find(pool_id)
>> is unsafe when we introduce free-able non-std worker_pool. Although we can
>> fix it by adding rcu to worker_pool. but "recording global worker id for
>> work data and adding rcu to worker" is another way and more straight forward.
>> We implement the later one,  Now, lock_pool_executing_work() is ready for this plan.
>>       --PATCH 12,13
>>
>> When every time we need to find out the running worker from a work,
>> we need two searches: search work_pool from work's data, and search worker
>> from hash. We record global worker id for work data and we only need one search.
>>       --PATCH 13
>
> While I'm a bit worried about capping total number of workers by the
> amount bits left in work->data, if that doesn't cause any practical
> issue (how many do we have available on 32bit?), I think this is the
> better approach.  We couldn't do this before because work -> worker
> relationship could be 1:N but it should now be doable.  Note that we
> need RCU no matter what we index (pool or worker) to avoid locking on
> each lookup.

BUILD_BUG_ON((BITS_PER_LONG != 64) && (WORK_OFFQ_WORKER_SHIFT > 12));

Every worker needs at least 4k memory for its stack, the bits are enough if
WORK_OFFQ_WORKER_SHIFT <= 12.

>
> So, I like both major changes made by the patchset and most changes
> seem correct, well at least on casual review that is.
>
> The problem is that I'm not very happy with the descriptions and
> comments (what's up with the weird /** formatting?).  At least for me,
> the patchset is quite difficult to follow.  I'm not sure whether it
> has actual organizational issues or the descriptions aren't detailed /
> clear enough yet.
>
> From past experience, I *think* it's gonna be a bit of struggle for
> both of us to get the series in a shape that I would find acceptable
> by reviewing and iterating, so I might just swallow it and regurgitate
> into a form that I like.  Hmm.... dunno.  Will think about it.
>

It is not nightmare for me! the work and discusses will consume most
time of my night, no night time for nightmare.

> Anyways, nice work.
>
I'm glad you like it. My daughter was born about 3month ago and I left
workqueue work then. I think it is time to pick up old pending
patches.

Thanks,
Lai

>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
