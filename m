Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab3HAVFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:05:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55857 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917Ab3HAVEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:04:52 -0400
Message-ID: <51FACD4D.9080300@kernel.dk>
Date: Thu, 01 Aug 2013 15:04:13 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
CC: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, tj@kernel.org,
        seiji.aguchi@hds.com
Subject: Re: [RFC PATCH] cfq-iosched: limit slice_idle when many busy queues
 are in idle window
References: <20130730193033.27856.58005.stgit@hds.com> <20130731020928.GA27570@kernel.org> <51FAC4DD.70400@hds.com>
In-Reply-To: <51FAC4DD.70400@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 02:28 PM, Tomoki Sekiyama wrote:
> On 7/30/13 10:09 PM, Shaohua Li wrote:
>> On Tue, Jul 30, 2013 at 03:30:33PM -0400, Tomoki Sekiyama wrote:
>>> Hi,
>>>
>>> When some application launches several hundreds of processes that issue
>>> only a few small sync I/O requests, CFQ may cause heavy latencies
>>> (10+ seconds at the worst case), although the request rate is low enough for
>>> the disk to handle it without waiting. This is because CFQ waits for
>>> slice_idle (default:8ms) every time before processing each request, until
>>> their thinktimes are evaluated.
>>>
>>> This scenario can be reproduced using fio with parameters below:
>>>   fio -filename=/tmp/test -rw=randread -size=5G -runtime=15 -name=file1 \
>>>       -bs=4k -numjobs=500 -thinktime=1000000
>>> In this case, 500 processes issue a random read request every second.
>>
>> For this workload CFQ should perfectly detect it's a seek queue and disable
>> idle. I suppose the reason is CFQ hasn't enough data/time to disable idle yet,
>> since your thinktime is long and runtime is short.
> 
> Right, CFQ will learn the patten, but it takes too long time to reach stable
> performance when a lot of I/O processes are launched.
> 
>> I thought the real problem here is cfq_init_cfqq() shouldn't set idle_window
>> when initializing a queue. We should enable idle window after we detect the
>> queue is worthy idle.
> 
> Do you think the patch below is appropriate? Or should we check whether
> busy_idle_queues in my original patch is high enough and only then
> disable default idle_window in cfq_init_cfqq()?
> 
>> Thanks,
>> Shaohua
> 
> Thanks,
> Tomoki Sekiyama
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index d5cd313..abbe28f 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -3514,11 +3514,8 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  
>  	cfq_mark_cfqq_prio_changed(cfqq);
>  
> -	if (is_sync) {
> -		if (!cfq_class_idle(cfqq))
> -			cfq_mark_cfqq_idle_window(cfqq);
> +	if (is_sync)
>  		cfq_mark_cfqq_sync(cfqq);
> -	}
>  	cfqq->pid = pid;
>  }

I do agree in principle with this, but now you are going to have the
reverse problem where idling workloads take longer to reach their
natural steady state. It could probably be argued that they should
converge quicker, however, in which case it's probably a good change.

-- 
Jens Axboe

