Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3CFQLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 11:11:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:44045 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3CFQLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 11:11:08 -0500
Date: Wed, 6 Mar 2013 17:10:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v3 4/5] clocksource: Enable clocksource_cyc2ns() to cover
 big cycles
In-Reply-To: <20130306143742.GB25790@feng-snb>
Message-ID: <alpine.LFD.2.02.1303061701130.22263@ionos>
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com> <1362554271-22382-5-git-send-email-feng.tang@intel.com> <alpine.LFD.2.02.1303061451340.22263@ionos> <20130306143742.GB25790@feng-snb>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013, Feng Tang wrote:
> Hi Thomas,
> 
> Thanks for the reviews.
> 
> On Wed, Mar 06, 2013 at 03:09:26PM +0100, Thomas Gleixner wrote:
> > On Wed, 6 Mar 2013, Feng Tang wrote:
> > 
> > > Current clocksource_cyc2ns() has a implicit limit that the (cycles * mult)
> > > can not exceed 64 bits limit. Jason Gunthorpe proposed a way to
> > > handle this big cycles case, and this patch put the handling into
> > > clocksource_cyc2ns() so that it could be used unconditionally.
> > 
> > Could be used if it wouldn't break the world and some more.
> 
> Exactly.
> 
> One excuse I can think of is usually the clocksource_cyc2ns() will be called
> for cycles less than 600 seconds, based on which the "mult" and "shift" are
> calculated for a clocksource.

That's not an excuse for making even the build fail on ARM and other
32bit archs.
 
> > >  static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
> > >  {
> > > -	return ((u64) cycles * mult) >> shift;
> > > +	u64 max = ULLONG_MAX / mult;
> > 
> > This breaks everything which does not have a 64/32bit divide
> > instruction. And you can't replace it with do_div() as that would
> > impose massive overhead on those architectures in the fast path.
> 
> I thought about this once. And in my v2 patch, I used some code like
> 
> +		/*
> +		 * The system suspended time and the delta cycles may be very
> +		 * long, so we can't call clocksource_cyc2ns() directly with
> +		 * clocksource's default mult and shift to avoid overflow.
> +		 */
> +		max_cycles = 1ULL << (63 - (ilog2(mult) + 1));
> +		while (cycle_delta > max_cycles) {
> +			max_cycles <<= 1;
> +			mult >>= 1;
> +			shift--;
> +		}
> +
> 
> trying to avoid expensieve maths. But as Jason pointed, there is some accuracy
> lost. 

Right, but if you precalculate the max_fast_cycles value you can avoid
at least the division in the fast path and then do

   if (cycles > max_fast_cycles)
      return clocksource_cyc2ns_slow();
   return ((u64) cycles * mult) >> shift;	      

clocksource_cyc2ns_slow() should be out of line and there you can do
all the slow 64 bit operations. That keeps the fast path sane and we
don't need extra magic for the large cycle values.

Thanks,

	tglx

