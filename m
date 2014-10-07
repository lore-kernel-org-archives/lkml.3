Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaJGXR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:17:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34566 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbaJGXR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:17:56 -0400
Message-ID: <5434749D.9070301@gmail.com>
Date: Tue, 07 Oct 2014 17:17:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: PERF_EVENT_IOC_SET_FILTER has different values based on bitness
References: <54347238.2060908@gmail.com>
In-Reply-To: <54347238.2060908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/14, 5:07 PM, David Ahern wrote:
>
> 32-bit perf binaries are not able to set filters on 64-bit kernels.
>
>     $ perf record -e  net:netif_receive_skb --filter 'name == "eth1"
>     Error: failed to set filter with 25 (Inappropriate ioctl for device)
>
> The reason is that the definition of PERF_EVENT_IOC_SET_FILTER contains
> a pointer:
>
> #define PERF_EVENT_IOC_SET_FILTER       _IOW('$', 6, char *)
>
> the size of which of course differs for 32-bit and 64-bit. This has been
> there since the original commit (6fb2915df7f07) back in 2009.
>
> Thoughts on how to fix this? Changing the definition of SET_FILTER
> breaks existing setups so that rules it out. What about something like
> this:
>
> #define PERF_EVENT_IOC_SET_FILTER_32       _IOW('$', 6, u32)
>
> and then
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 963bf139e2b2..c805132ac1cf 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3714,6 +3714,7 @@ static long perf_ioctl(struct file *file, unsigned
> int cmd, unsigned long arg)
>      }
>
>      case PERF_EVENT_IOC_SET_FILTER:
> +   case PERF_EVENT_IOC_SET_FILTER_32:
>          return perf_event_set_filter(event, (void __user *)arg);
>
>      default:
>

Oh, PERF_EVENT_IOC_ID has the same problem:

#define PERF_EVENT_IOC_ID               _IOR('$', 7, __u64 *)

David

