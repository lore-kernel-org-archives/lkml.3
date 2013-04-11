Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935946Ab3DKRbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:31:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35332 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935328Ab3DKRbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:31:23 -0400
Message-ID: <1365701469.10217.6.camel@laptop>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling
 overflow
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        fweisbec@gmail.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Apr 2013 19:31:09 +0200
In-Reply-To: <20130411145052.GA31644@redhat.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
	 <20130326140147.GB2029@redhat.com> <1365687946.8824.3.camel@laptop>
	 <20130411145052.GA31644@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 16:50 +0200, Stanislaw Gruszka wrote:

> > +	/*
> > +	 * Since the stime:utime ratio is already an approximation through
> > +	 * the sampling, reducing its resolution isn't too big a deal.
> > +	 * And since total = stime+utime; the total_fls will be the biggest
> > +	 * of the two;
> > +	 */
> > +	if (total_fls > 32) {
> > +		shift = total_fls - 32; /* a = 2^shift */
> > +		stime >>= shift;
> > +		total >>= shift;
> > +		stime_fls -= shift;
> > +		total_fls -= shift;
> > +	}
> > +
> > +	/*
> > +	 * Since we limited stime to 32bits the multiplication reduced to 96bit.
> > +	 *   stime * rtime = stime * (rl + rh * 2^32) = 
> > +	 *                   stime * rl + stime * rh * 2^32
> > +	 */
> > +	lo = stime * rtime_lo;
> > +	hi = stime * rtime_hi;
> > +	t = hi << 32;
> > +	lo += t;
> > +	if (lo < t) /* overflow */
> > +		hi += 0x100000000L;
> > +	hi >>= 32;
> 
> I do not understand why we shift hi value here, is that correct?

Yes.. remember that we have:

  stime * rl + stime * rh * 2^32

How we get this 96bit value but our two 64bit values overlap:

 | w3 | w2 | w1 | w0 |
 +----+----+----+----+
           |    lo   |
       |   hi   |

So what I do is I add the low word of hi to lo and shift the high word
of hi to get:

 |     hi  |    lo   |

Two non-overlapping 64bit values where the high word of hi is always 0.

> > +	/*
> > +	 * Pick the 64 most significant bits for division into @lo.
> > +	 * 
> > +	 * NOTE: res_fls is an approximation (upper-bound) do we want to
> > +	 *       properly calculate?
> > +	 */
> > +	shift = 0;
> > +	res_fls = stime_fls + rtime_fls;
> > +	if (res_fls > 64) {
> > +		shift = res_fls - 64; /* b = 2^shift */
> > +		lo >>= shift;
> > +		hi <<= 64 - shift;
> > +		lo |= hi;
> >  	}
> > -	return (__force cputime_t) scaled;
> > +	/*
> > +	 * So here we do:
> > +	 *
> > +	 *    ((stime / a) * rtime / b)
> > +	 *    --------------------------- / b
> > +	 *           (total / a)
> > +	 */
> > +	return div_u64(lo, total) >> shift;
> 
> I think it should be:
> 
>  ((stime / a) * rtime / b)
> --------------------------- * b
>         (total / a)
> 
> return div_u64(lo, total) << shift;

I think you're very right about that.. got my head twisted by staring
at this stuff too long.

