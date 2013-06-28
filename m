Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab3F1K46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:56:58 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:44763 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab3F1K45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:56:57 -0400
MIME-Version: 1.0
In-Reply-To: <51C867CF.70908@intel.com>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
 <51C7B9B8.6090309@intel.com> <CAPM31RKq4sVR2_mU8PWx8dK+STQDj3Geyi8dVg3MnL=ymjfV6Q@mail.gmail.com>
 <51C867CF.70908@intel.com>
From: Paul Turner <pjt@google.com>
Date: Fri, 28 Jun 2013 03:56:25 -0700
Message-ID: <CAPM31RLTrQ_E6VAwO000zcL09F1oV7vgkjTJXY9wPC-pZ_6h0Q@mail.gmail.com>
Subject: Re: [Resend patch v8 0/13] use runnable load in schedule balance
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, jkosina@suse.cz,
        Clark Williams <clark.williams@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>, keescook@chromium.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 8:37 AM, Alex Shi <alex.shi@intel.com> wrote:
> On 06/24/2013 06:40 PM, Paul Turner wrote:
>>> > Ingo & Peter,
>>> >
>>> > This patchset was discussed spread and deeply.
>>> >
>>> > Now just 6th/8th patch has some arguments on them, Paul think it is
>>> > better to consider blocked_load_avg in balance, since it is helpful on
>>> > some scenarios, but I think on most of scenarios, the blocked_load_avg
>>> > just cause load imbalance among cpus. and plus testing show with
>>> > blocked_load_avg the performance is just worse on some benchmarks. So, I
>>> > still prefer to keep it out of balance.
>> I think you have perhaps misunderstood what I was trying to explain.
>>
>> I have no problems with not including blocked load in load-balance, in
>> fact, I encouraged not accumulating it in an average of averages in
>> CPU load.
>>
>
> Many thanks for re-clarification!
>> The problem is that your current approach has removed it both from
>> load-balance _and_ from shares distribution; isolation matters as much
>> as performance in the cgroup case (otherwise you would just not use
>> cgroups).  I would expect the latter to have quite negative effects on
>> fairness, this is my primary concern.
>>
>
> So the argument is just on patch 'sched/tg: remove blocked_load_avg in balance'. :)
>
> I understand your correctness concern. but blocked_load_avg still will be decayed to zero in few hundreds ms. So such correctness needs just in few hundreds ms. (and cause performance drop)
> The blocked_load_avg is decayed on same degree as runnable load, it is a bit overweight since task slept. since it may will be waken up on other cpu. So to relieve this overweight, could we use the half or a quarter weight of blocked_load_avg? like following:
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index ddbc19f..395f57c 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1358,7 +1358,7 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>         struct task_group *tg = cfs_rq->tg;
>         s64 tg_contrib;
>
> -       tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
> +       tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg / 2;
>         tg_contrib -= cfs_rq->tg_load_contrib;

So this is actually an interesting idea, but don't think of it as
overweight.  What "cfs_rq->blocked_load_avg / 2" means is actually
blocked_load_avg one period from now.  This is interesting because it
makes the (reasonable) supposition that blocked load is not about to
immediately wake, but will continue to decay.

Could you try testing the gvr_lb_tip branch at
git://git.kernel.org/pub/scm/linux/kernel/git/pjt/sched-tip.git ?

It's an extension to your series that tries to improve some of the
cpu_load interactions in an alternate way to the above.

It seems a little better on one and two-socket machines; but we
couldn't reproduce/compare to your best performance results since they
were taken on larger machines.

Thanks,

- Paul
