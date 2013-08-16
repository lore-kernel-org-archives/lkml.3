Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3HPRHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:07:15 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37347 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3HPRHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:07:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130815110905.GO24092@twins.programming.kicks-ass.net>
References: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1375778203-31343-4-git-send-email-iamjoonsoo.kim@lge.com>
	<20130815110905.GO24092@twins.programming.kicks-ass.net>
Date: Sat, 17 Aug 2013 02:07:10 +0900
Message-ID: <CAAmzW4Mf+dsQEGMe5vzg8VTO8UjN8jJQ44RkAsPMfLX3_r4Urw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] sched: clean-up struct sd_lb_stat
From: JoonSoo Kim <js1304@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/15 Peter Zijlstra <peterz@infradead.org>:
> On Tue, Aug 06, 2013 at 05:36:43PM +0900, Joonsoo Kim wrote:
>> There is no reason to maintain separate variables for this_group
>> and busiest_group in sd_lb_stat, except saving some space.
>> But this structure is always allocated in stack, so this saving
>> isn't really benificial.
>>
>> This patch unify these variables, so IMO, readability may be improved.
>>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> So I like the idea I had to reformat some of the code and I think we can
> do less memsets. See how the below reduces the sds memset by the two
> sgs. If we never set busiest we'll never look at sds->busiest_stat so we
> don't need to clear that. And if we make the sgs memset in
> update_sd_lb_stats() unconditional we'll cover sds->this_stats while
> reducing complexity.

At first glance, below changes look good.
When I return to the office on next Monday, I will look at it in detail.
Just one comment below.

> @@ -4890,13 +4893,12 @@ static inline void calculate_imbalance(s
>   *                return the least loaded group whose CPUs can be
>   *                put to idle by rebalancing its tasks onto our group.
>   */
> -static struct sched_group *
> -find_busiest_group(struct lb_env *env)
> +static struct sched_group *find_busiest_group(struct lb_env *env)
>  {
> -       struct sd_lb_stats sds;
>         struct sg_lb_stats *this, *busiest;
> +       struct sd_lb_stats sds;
>
> -       memset(&sds, 0, sizeof(sds));
> +       memset(&sds, 0, sizeof(sds) - 2*sizeof(struct sg_lb_stats));

How about using offsetof() macro, instead of using subtraction to
calculate size?

Thanks.
