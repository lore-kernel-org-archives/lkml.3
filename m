Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaAPBKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:10:04 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:26710 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaAPBJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:09:59 -0500
Message-ID: <52D73148.4090408@huawei.com>
Date: Thu, 16 Jan 2014 09:09:28 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Robert Richter <rric@kernel.org>
CC: <oprofile-list@lists.sf.net>, <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, <wangnan0@huawei.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>
Subject: Re: [PATCH] oprofile: check whether oprofile perf enabled in op_overflow_handler()
References: <52B3F66D.6060707@huawei.com> <20140113084555.GU20315@rric.localhost> <52D4984B.9090600@huawei.com> <20140114150553.GC20315@rric.localhost> <52D5EC44.30101@huawei.com> <20140115102445.GE20315@rric.localhost>
In-Reply-To: <20140115102445.GE20315@rric.localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/1/15 18:24, Robert Richter wrote:
> On 15.01.14 10:02:44, Weng Meiling wrote:
>> On 2014/1/14 23:05, Robert Richter wrote:
>>> @@ -94,6 +98,11 @@ static int op_create_counter(int cpu, int event)
>>>  
>>>  	per_cpu(perf_events, cpu)[event] = pevent;
>>>  
>>> +	/* sync perf_events with overflow handler: */
>>> +	smp_wmb();
>>> +
>>> +	perf_event_enable(pevent);
>>> +
>>
>> Should this step go before the if check:pevent->state != PERF_EVENT_STATE_ACTIVE ?
>> Because the attr->disabled is true, So after the perf_event_create_kernel_counter
>> the pevent->state is not PERF_EVENT_STATE_ACTIVE.
> 
> Right, the check is a problem. We need to move it after the event was
> enabled. On error, we need to NULL the event, see below.
> 
> -Robert
> 
> ---
>  drivers/oprofile/oprofile_perf.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
> index d5b2732..9dfb236 100644
> --- a/drivers/oprofile/oprofile_perf.c
> +++ b/drivers/oprofile/oprofile_perf.c
> @@ -38,6 +38,9 @@ static void op_overflow_handler(struct perf_event *event,
>  	int id;
>  	u32 cpu = smp_processor_id();
>  
> +	/* sync perf_events with op_create_counter(): */
> +	smp_rmb();
> +
>  	for (id = 0; id < num_counters; ++id)
>  		if (per_cpu(perf_events, cpu)[id] == event)
>  			break;
> @@ -68,6 +71,7 @@ static void op_perf_setup(void)
>  		attr->config		= counter_config[i].event;
>  		attr->sample_period	= counter_config[i].count;
>  		attr->pinned		= 1;
> +		attr->disabled		= 1;
>  	}
>  }
>  
> @@ -85,16 +89,23 @@ static int op_create_counter(int cpu, int event)
>  	if (IS_ERR(pevent))
>  		return PTR_ERR(pevent);
>  
> -	if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
> -		perf_event_release_kernel(pevent);
> -		pr_warning("oprofile: failed to enable event %d "
> -				"on CPU %d\n", event, cpu);
> -		return -EBUSY;
> -	}
> -
>  	per_cpu(perf_events, cpu)[event] = pevent;
>  
> -	return 0;
> +	/* sync perf_events with overflow handler: */
> +	smp_wmb();
> +
> +	perf_event_enable(pevent);
> +
> +	if (pevent->state == PERF_EVENT_STATE_ACTIVE)
> +		return 0;
> +
> +	perf_event_release_kernel(pevent);
> +	per_cpu(perf_events, cpu)[event] = NULL;
> +
> +	pr_warning("oprofile: failed to enable event %d on CPU %d\n",
> +		event, cpu);
> +
> +	return -EBUSY;
>  }
>  
>  static void op_destroy_counter(int cpu, int event)
> 

OK, I'll test the patch, and send the result as soon as possible.

