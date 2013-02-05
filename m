Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3BEVSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:18:49 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62178 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3BEVSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:18:46 -0500
Message-ID: <51117731.4010105@gmail.com>
Date: Tue, 05 Feb 2013 14:18:41 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>
CC: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>, tglx <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>  <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet>
In-Reply-To: <1359728280.8360.15.camel@hornet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/13 7:18 AM, Pawel Moll wrote:
> 8<---
>  From 2ad51a27fbf64bf98cee190efc3fbd7002819692 Mon Sep 17 00:00:00 2001
> From: Pawel Moll <pawel.moll@arm.com>
> Date: Fri, 1 Feb 2013 14:03:56 +0000
> Subject: [PATCH] perf: Add ioctl to return current time value
>
> To co-relate user space events with the perf events stream
> a current (as in: "what time(stamp) is it now?") time value
> must be made available.
>
> This patch adds a perf ioctl that makes this possible.

Are there any objections to this approach? I need a solution for my 
time-of-day patch as well.

David

>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>   include/uapi/linux/perf_event.h |    1 +
>   kernel/events/core.c            |    8 ++++++++
>   2 files changed, 9 insertions(+)
>
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 4f63c05..b745fb0 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -316,6 +316,7 @@ struct perf_event_attr {
>   #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
>   #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
>   #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
> +#define PERF_EVENT_IOC_GET_TIME		_IOR('$', 7, __u64)
>
>   enum perf_event_ioc_flags {
>   	PERF_IOC_FLAG_GROUP		= 1U << 0,
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 301079d..4202b1c 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3298,6 +3298,14 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>   	case PERF_EVENT_IOC_SET_FILTER:
>   		return perf_event_set_filter(event, (void __user *)arg);
>
> +	case PERF_EVENT_IOC_GET_TIME:
> +	{
> +		u64 time = perf_clock();
> +		if (copy_to_user((void __user *)arg, &time, sizeof(time)))
> +			return -EFAULT;
> +		return 0;
> +	}
> +
>   	default:
>   		return -ENOTTY;
>   	}
>

