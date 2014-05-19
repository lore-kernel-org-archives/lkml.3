Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaESB2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:28:39 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:62508 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaESB2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:28:38 -0400
Message-ID: <53795E3B.9000004@huawei.com>
Date: Mon, 19 May 2014 09:28:27 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Mauro Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] time: Provide full featured jiffies_to_nsecs() function
References: <0286550@agluck-desk.sc.intel.com>
In-Reply-To: <0286550@agluck-desk.sc.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.17.191]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/9 1:32, Tony Luck wrote:
> The "uptime" tracer added in:
>     commit 8aacf017b065a805d27467843490c976835eb4a5
>     tracing: Add "uptime" trace clock that uses jiffies
> has wraparound problems when the system has been up more
> than 1 hour 11 minutes and 34 seconds. It converts jiffies
> to nanoseconds using:
> 	(u64)jiffies_to_usecs(jiffy) * 1000ULL
> but since jiffies_to_usecs() only returns a 32-bit value, it
> truncates at 2^32 microseconds.  An additional problem on 32-bit
> systems is that the argument is "unsigned long", so fixing the
> return value only helps until 2^32 jiffies (49.7 days on a HZ=1000
> system).
> 
> So we provide a full featured jiffies_to_nsec() function that
> takes a "u64" argument and provides a "u64" result.  To avoid
> cries of rage from the other user of this: scheduler_tick_max_deferment()
> we check whether the argument is small enough that we can do
> the calculations in 32-bit operations.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/jiffies.h    |  6 +-----
>  kernel/time.c              | 24 ++++++++++++++++++++++++
>  kernel/timeconst.bc        | 12 ++++++++++++
>  kernel/trace/trace_clock.c |  2 +-
>  4 files changed, 38 insertions(+), 6 deletions(-)
> 

[...]

> diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
> index 26dc348332b7..52470fba1d26 100644
> --- a/kernel/trace/trace_clock.c
> +++ b/kernel/trace/trace_clock.c
> @@ -65,7 +65,7 @@ u64 notrace trace_clock_jiffies(void)
>  	u64 jiffy = jiffies - INITIAL_JIFFIES;

Hi Tony and Steven,
Another problem, maybe we should use get_jiffies_64() instead of jiffies
directly here OR we'll meet wraparound problems on 32bit system. But a
same problem is that the jiffies_lock is not safe in NMI context...

>  
>  	/* Return nsecs */
> -	return (u64)jiffies_to_usecs(jiffy) * 1000ULL;
> +	return jiffies_to_nsecs(jiffy);
>  }
>  
>  /*
> 


