Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab3CGOcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:32:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab3CGOce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:32:34 -0500
Date: Thu, 7 Mar 2013 15:32:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] sched: Lower chances of cputime scaling overflow
Message-ID: <20130307143246.GB1859@redhat.com>
References: <1362586015-27951-1-git-send-email-fweisbec@gmail.com>
 <1362586015-27951-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362586015-27951-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 05:06:55PM +0100, Frederic Weisbecker wrote:
> If this solution appears not to be enough in the end, we'll
> need to partly revert back to the behaviour prior to commit
>      0cf55e1ec08bb5a22e068309e2d8ba1180ab4239
>      ("sched, cputime: Introduce thread_group_times()")
> 
> Back then, the scaling was done on exit() time before adding the cputime
> of an exiting thread to the signal struct. And then we'll need to
> scale one-by-one the live threads cputime in thread_group_cputime(). The
> drawback may be a slightly slower code on exit time.

I do not see this part in the patch ? What I can see is just scaling
algorithm change. 

> -static cputime_t scale_stime(cputime_t stime, cputime_t rtime, cputime_t total)
> +static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
>  {
> -	u64 temp = (__force u64) rtime;
> +	u64 rem, res, scaled;
>  
> -	temp *= (__force u64) stime;
> -
> -	if (sizeof(cputime_t) == 4)
> -		temp = div_u64(temp, (__force u32) total);
> -	else
> -		temp = div64_u64(temp, (__force u64) total);
> +	if (rtime >= total) {
> +		res = div64_u64_rem(rtime, total, &rem);
> +		scaled = stime * res;
> +		scaled += div64_u64(stime * rem, total);
> +	} else {
> +		res = div64_u64_rem(total, rtime, &rem);
> +		scaled = div64_u64(stime, res);
> +		scaled -= div64_u64(scaled * rem, total);

Those calculus are not obvious. Perhaps it should be commented, how
they evolved from scaled = (rtime*stime)/total ?

> +	} else if (!total) {
>  		stime = rtime;

I would prefer stime = rtime/2 (hence utime will be rtime/2 too), but this
is not so important.

Other than that, patch looks great.

Stanislaw
