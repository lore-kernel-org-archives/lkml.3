Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912Ab3DKOuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:50:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935762Ab3DKOuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:50:18 -0400
Date: Thu, 11 Apr 2013 16:50:53 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        fweisbec@gmail.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
Message-ID: <20130411145052.GA31644@redhat.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
 <20130326140147.GB2029@redhat.com>
 <1365687946.8824.3.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365687946.8824.3.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 03:45:46PM +0200, Peter Zijlstra wrote:
> On Tue, 2013-03-26 at 15:01 +0100, Stanislaw Gruszka wrote:
> > Thoughts?
> 
> Would something like the below work?

Not sure, need to validate that?

> (warning: it's never even been near a compiler)

It compile, but probably has some bugs.
> +	/*
> +	 * Since the stime:utime ratio is already an approximation through
> +	 * the sampling, reducing its resolution isn't too big a deal.
> +	 * And since total = stime+utime; the total_fls will be the biggest
> +	 * of the two;
> +	 */
> +	if (total_fls > 32) {
> +		shift = total_fls - 32; /* a = 2^shift */
> +		stime >>= shift;
> +		total >>= shift;
> +		stime_fls -= shift;
> +		total_fls -= shift;
> +	}
> +
> +	/*
> +	 * Since we limited stime to 32bits the multiplication reduced to 96bit.
> +	 *   stime * rtime = stime * (rl + rh * 2^32) = 
> +	 *                   stime * rl + stime * rh * 2^32
> +	 */
> +	lo = stime * rtime_lo;
> +	hi = stime * rtime_hi;
> +	t = hi << 32;
> +	lo += t;
> +	if (lo < t) /* overflow */
> +		hi += 0x100000000L;
> +	hi >>= 32;

I do not understand why we shift hi value here, is that correct?

> +	/*
> +	 * Pick the 64 most significant bits for division into @lo.
> +	 * 
> +	 * NOTE: res_fls is an approximation (upper-bound) do we want to
> +	 *       properly calculate?
> +	 */
> +	shift = 0;
> +	res_fls = stime_fls + rtime_fls;
> +	if (res_fls > 64) {
> +		shift = res_fls - 64; /* b = 2^shift */
> +		lo >>= shift;
> +		hi <<= 64 - shift;
> +		lo |= hi;
>  	}
>  
> -	return (__force cputime_t) scaled;
> +	/*
> +	 * So here we do:
> +	 *
> +	 *    ((stime / a) * rtime / b)
> +	 *    --------------------------- / b
> +	 *           (total / a)
> +	 */
> +	return div_u64(lo, total) >> shift;

I think it should be:

 ((stime / a) * rtime / b)
--------------------------- * b
        (total / a)

return div_u64(lo, total) << shift;

Thanks
Stanislaw

