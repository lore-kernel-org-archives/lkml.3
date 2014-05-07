Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaEGPau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:30:50 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:56297 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308AbaEGPag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:30:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140507134142.GF16702@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
	<1398571754-12443-5-git-send-email-laijs@cn.fujitsu.com>
	<20140505143613.GD11231@htj.dyndns.org>
	<5369DC5C.20001@cn.fujitsu.com>
	<20140507131257.GB16702@htj.dyndns.org>
	<CACvQF50kdodjDGnaxgQC2sW82rvkFVLtWQDOn90cohNkzG-oZw@mail.gmail.com>
	<20140507134142.GF16702@htj.dyndns.org>
Date: Wed, 7 May 2014 23:30:35 +0800
X-Google-Sender-Auth: 4BXtx1u79CCQdsGEaLh0XQwWS70
Message-ID: <CACvQF52KPp++-eMx+4sy+NeAGdTMg_L2kM9rBOToXGcVQ4TzAA@mail.gmail.com>
Subject: Re: [PATCH 04/10] workqueue: destroy worker directly in the idle
 timeout handler
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 9:41 PM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, May 07, 2014 at 09:38:39PM +0800, Lai Jiangshan wrote:
>> On Wed, May 7, 2014 at 9:12 PM, Tejun Heo <tj@kernel.org> wrote:
>> > Hello, Lai.
>> >
>> > On Wed, May 07, 2014 at 03:10:20PM +0800, Lai Jiangshan wrote:
>> >> 1) complete() can't be called inside attach_mutex due to the worker
>> >>    shouldn't access to the pool after complete().
>> >
>> > Sure, complete it after releasing the lock.  Shutdown can't complete
>> > before the completion gets completed, right?
>> >
>> >> 2) put_unbound_pool() may called from get_unbound_pool(), we need to add
>> >>    an additional check and avoid the wait_for_completion() if so.
>>
>> Do you accept if I remove put_unbound_pool() from get_unbound_pool()
>> and use several freeing code instead?
>
> Hah?  How much extra complexity are we talking about?  It's a single
> if, no?

        DECLARE_COMPLETION_ONSTACK(completion);
#1

        ...

        while ((worker = first_worker(pool))) {
                destroy_worker(worker);
                pool->detach_completion = &completion;
#2
        }

        ...
        unlock;

        if (pool->detach_completion)
                wait_for_completion();
#3

One thing is separated into 3 places and about 5~7lines.
I hope a single wait_for_completion() or single wait_event().


get_unbound_pool():
fail:
    if (pool)
        put_unbound_pool(pool);

I think we can change it into:

fail:
    if (pool) {
        if (pool->id >= 0)
            idr_remove(&worker_pool_idr, pool->id);
        call_rcu_sched(&pool->rcu, rcu_free_pool);
    }

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
