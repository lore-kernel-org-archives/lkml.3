Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaGHJXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:23:52 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:64866 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaGHJXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:23:49 -0400
Message-ID: <53BBB893.30808@huawei.com>
Date: Tue, 8 Jul 2014 17:23:31 +0800
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
CC: <mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@gmail.com>,
        <linux-kernel@vger.kernel.org>, <xiaofeng.yan2012@gmail.com>
Subject: Re: [PATCH] sched/deadline: overrun could happen in start_hrtick_dl
References: <1404809607-26197-1-git-send-email-xiaofeng.yan@huawei.com>
In-Reply-To: <1404809607-26197-1-git-send-email-xiaofeng.yan@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.133]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.53BBB89F.00A2,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 49430afb30b899196f13f82b911f5d44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/8 16:53, xiaofeng.yan wrote:

Sorry, I send a old patch and send a new one later.

Thanks
Yan
> It could be wrong for the precision of runtime and deadline
> when the precision is within microsecond level. For example:
> Task runtime deadline period
>   P1   200us   500us   500us
>
> This case need enbale HRTICK feature by the next command
> PC#echo "HRTICK" > /sys/kernel/debug/sched_features
> PC#trace-cmd record -e sched_switch &
> PC#./schedtool -E -t 200000:500000 -e ./test
>
> Some of runtime and deadline run with millisecond level by
> reading kernershark. Some pieces of trace.dat are as follows:
> (remove some irrelevant information)
> <idle>-0   157.603157: sched_switch: :R ==> 2481:4294967295: test
> test-2481  157.603203: sched_switch:  2481:R ==> 0:120: swapper/2
> <idle>-0   157.605657: sched_switch:  :R ==> 2481:4294967295: test
> test-2481  157.608183: sched_switch:  2481:R ==> 2483:120: trace-cmd
> trace-cmd-2483 157.609656: sched_switch:2483:R==>2481:4294967295: test
>
> We can get the runtime from the information at some point.
> runtime = 157.605657 - 157.608183
> runtime = 0.002526(2.526ms)
> The correct runtime should be less than or equal to 200us at some point.
>
> The problem is caused by a conditional judgment "delta > 10000".
> Because no hrtimer start up to control the runtime when runtime is less than 10us.
> So the process will continue to run until tick-period coming.
> For fixing this problem, Let delta is equal to 10us when it is less than 10us.
> So the hrtimer will start up to control the end of process.
>
> Signed-off-by: Xiaofeng Yan <xiaofeng.yan@huawei.com>
> ---
>   kernel/sched/deadline.c |    6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index fc4f98b1..b71c229 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -997,10 +997,8 @@ static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
>   #ifdef CONFIG_SCHED_HRTICK
>   static void start_hrtick_dl(struct rq *rq, struct task_struct *p)
>   {
> -	s64 delta = p->dl.dl_runtime - p->dl.runtime;
> -
> -	if (delta > 10000)
> -		hrtick_start(rq, p->dl.runtime);
> +	delta = max_t(s64, 10000LL, delta);
> +	hrtick_start(rq, delta);
>   }
>   #endif
>   


