Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab3IYMNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:13:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46528 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3IYMM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:12:59 -0400
Date: Wed, 25 Sep 2013 14:12:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Prevent divide by zero exception in
 kernel/events/core.c
Message-ID: <20130925121243.GK3081@twins.programming.kicks-ass.net>
References: <5242D207.10306@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5242D207.10306@t-online.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 02:07:35PM +0200, Knut Petersen wrote:
> From: Knut Petersen <Knut_Petersen@t-online.de>
> Date: Wed, 25 Sep 2013 13:34:57 +0200
> Subject: [PATCH] Enforce 1 as lower limit for perf_event_max_sample_rate
> 
> /proc/sys/kernel/perf_event_max_sample_rate will accept
> negative values as well as 0.
> 
> Negative values are unreasonable, and 0 causes a
> divide by zero exception in perf_proc_update_handler.
> 
> This patch enforces a lower limit of 1.
> 
> Signed-off-by: Knut Petersen <Knut_Petersen@t-online.de>
> ---
>  kernel/events/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index dd236b6..350bb53 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -198,6 +198,9 @@ int perf_proc_update_handler(struct ctl_table *table, int write,
>  	if (ret || !write)
>  		return ret;
>  
> +	if (sysctl_perf_event_sample_rate <= 0)
> +		sysctl_perf_event_sample_rate = 1;
> +
>  	max_samples_per_tick = DIV_ROUND_UP(sysctl_perf_event_sample_rate, HZ);
>  	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
>  	update_perf_cpu_limits();

The 'normal' way of doing that is changing the sysctl table entry to use
proc_dointvec_minmax and set .extra = &one. See for example
&sysctl_sched_cfs_bandwidth_slice in kernel/sysctl.c
