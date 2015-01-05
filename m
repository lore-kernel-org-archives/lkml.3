Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbbAEO5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:57:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:47338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbbAEO5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:57:54 -0500
Date: Mon, 5 Jan 2015 15:57:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v2 1/2] arm: perf: Prevent wraparound during overflow
Message-ID: <20150105145739.GU30905@twins.programming.kicks-ass.net>
References: <1416412346-8759-1-git-send-email-daniel.thompson@linaro.org>
 <1416587067-3220-1-git-send-email-daniel.thompson@linaro.org>
 <1416587067-3220-2-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416587067-3220-2-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 04:24:26PM +0000, Daniel Thompson wrote:
> If the overflow threshold for a counter is set above or near the
> 0xffffffff boundary then the kernel may lose track of the overflow
> causing only events that occur *after* the overflow to be recorded.
> Specifically the problem occurs when the value of the performance counter
> overtakes its original programmed value due to wrap around.
> 
> Typical solutions to this problem are either to avoid programming in
> values likely to be overtaken or to treat the overflow bit as the 33rd
> bit of the counter.
> 
> Its somewhat fiddly to refactor the code to correctly handle the 33rd bit
> during irqsave sections (context switches for example) so instead we take
> the simpler approach of avoiding values likely to be overtaken.
> 
> We set the limit to half of max_period because this matches the limit
> imposed in __hw_perf_event_init(). This causes a doubling of the interrupt
> rate for large threshold values, however even with a very fast counter
> ticking at 4GHz the interrupt rate would only be ~1Hz.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> ---
>  arch/arm/kernel/perf_event.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index 266cba46db3e..ab68833c1e31 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -115,8 +115,14 @@ int armpmu_event_set_period(struct perf_event *event)
>  		ret = 1;
>  	}
>  
> -	if (left > (s64)armpmu->max_period)
> -		left = armpmu->max_period;
> +	/*
> +	 * Limit the maximum period to prevent the counter value
> +	 * from overtaking the one we are about to program. In
> +	 * effect we are reducing max_period to account for
> +	 * interrupt latency (and we are being very conservative).
> +	 */
> +	if (left > (armpmu->max_period >> 1))
> +		left = armpmu->max_period >> 1;

On x86 we simply half max_period, why did you choose to do differently?
