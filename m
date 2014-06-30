Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaF3PKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:10:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:41194 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751015AbaF3PKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:10:42 -0400
Date: Mon, 30 Jun 2014 11:10:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Xie XiuQi <xiexiuqi@huawei.com>
Cc: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <tony.luck@intel.com>,
        <fweisbec@gmail.com>, <m.chehab@samsung.com>
Subject: Re: [PATCH 1/2] tracing: fix uptime overflow problem
Message-ID: <20140630111040.58fe70de@gandalf.local.home>
In-Reply-To: <1403953801-19068-2-git-send-email-xiexiuqi@huawei.com>
References: <1403953801-19068-1-git-send-email-xiexiuqi@huawei.com>
	<1403953801-19068-2-git-send-email-xiexiuqi@huawei.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2014 19:10:00 +0800
Xie XiuQi <xiexiuqi@huawei.com> wrote:

 
>  /*
> - * trace_jiffy_clock(): Simply use jiffies as a clock counter.
> + * trace_clock_uptime(): Use lockless version __current_kernel_time,
> + * so it's safe in NMI context.
>   */
> -u64 notrace trace_clock_jiffies(void)
> +u64 notrace trace_clock_uptime(void)
>  {
> -	u64 jiffy = jiffies - INITIAL_JIFFIES;
> +	struct timespec uptime, now, boottime;
> +
> +	/* Does not take xtime_lock, so it's safe in NMI context. */
> +	now = __current_kernel_time();

The problem with this patch is that you have a race:

        ts.tv_sec = tk->xtime_sec;
        ts.tv_nsec = (long)(tk->xtime_nsec >> tk->shift);

There's a chance that gets done between the update of xtime_sec an
xtime_nsec, and make time go backwards.

This call is lockless but is not reliable.

-- Steve


> +	getboottime(&boottime);
> +	uptime = timespec_sub(now, boottime);
>  
>  	/* Return nsecs */
> -	return (u64)jiffies_to_usecs(jiffy) * 1000ULL;
> +	return timespec_to_ns(&uptime);
>  }
>  
>  /*

