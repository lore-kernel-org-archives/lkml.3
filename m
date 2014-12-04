Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaLDK1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:27:15 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:44561 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaLDK1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:27:11 -0500
Date: Thu, 4 Dec 2014 10:27:09 +0000
From: Will Deacon <will.deacon@arm.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v2 2/2] arm64: perf: Prevent wraparound during overflow
Message-ID: <20141204102709.GC14519@arm.com>
References: <1416412346-8759-1-git-send-email-daniel.thompson@linaro.org>
 <1416587067-3220-1-git-send-email-daniel.thompson@linaro.org>
 <1416587067-3220-3-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416587067-3220-3-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 04:24:27PM +0000, Daniel Thompson wrote:
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
>  arch/arm64/kernel/perf_event.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Thanks, applied.

Will

> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index aa29ecb4f800..25a5308744b1 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -169,8 +169,14 @@ armpmu_event_set_period(struct perf_event *event,
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
>  
>  	local64_set(&hwc->prev_count, (u64)-left);
>  
> -- 
> 1.9.3
> 
> 
