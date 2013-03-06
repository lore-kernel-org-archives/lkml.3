Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348Ab3CFOiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:38:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:18715 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757274Ab3CFOit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:38:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,795,1355126400"; 
   d="scan'208";a="300113128"
Date: Wed, 6 Mar 2013 22:37:42 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v3 4/5] clocksource: Enable clocksource_cyc2ns() to cover
 big cycles
Message-ID: <20130306143742.GB25790@feng-snb>
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com>
 <1362554271-22382-5-git-send-email-feng.tang@intel.com>
 <alpine.LFD.2.02.1303061451340.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303061451340.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for the reviews.

On Wed, Mar 06, 2013 at 03:09:26PM +0100, Thomas Gleixner wrote:
> On Wed, 6 Mar 2013, Feng Tang wrote:
> 
> > Current clocksource_cyc2ns() has a implicit limit that the (cycles * mult)
> > can not exceed 64 bits limit. Jason Gunthorpe proposed a way to
> > handle this big cycles case, and this patch put the handling into
> > clocksource_cyc2ns() so that it could be used unconditionally.
> 
> Could be used if it wouldn't break the world and some more.

Exactly.

One excuse I can think of is usually the clocksource_cyc2ns() will be called
for cycles less than 600 seconds, based on which the "mult" and "shift" are
calculated for a clocksource.

> 
> > Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> > Signed-off-by: Feng Tang <feng.tang@intel.com>
> > ---
> >  include/linux/clocksource.h |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> > index aa7032c..1ecc872 100644
> > --- a/include/linux/clocksource.h
> > +++ b/include/linux/clocksource.h
> > @@ -274,7 +274,16 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
> >   */
> >  static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
> >  {
> > -	return ((u64) cycles * mult) >> shift;
> > +	u64 max = ULLONG_MAX / mult;
> 
> This breaks everything which does not have a 64/32bit divide
> instruction. And you can't replace it with do_div() as that would
> impose massive overhead on those architectures in the fast path.

I thought about this once. And in my v2 patch, I used some code like

+		/*
+		 * The system suspended time and the delta cycles may be very
+		 * long, so we can't call clocksource_cyc2ns() directly with
+		 * clocksource's default mult and shift to avoid overflow.
+		 */
+		max_cycles = 1ULL << (63 - (ilog2(mult) + 1));
+		while (cycle_delta > max_cycles) {
+			max_cycles <<= 1;
+			mult >>= 1;
+			shift--;
+		}
+

trying to avoid expensieve maths. But as Jason pointed, there is some accuracy
lost. 

> 
> The max value can be precalculated and stored in the timekeeper
> struct. We really do not want expensive calculations in the fast path.

Yeah, just like the max_idle_ns.

> > +	s64 nsec = 0;
> > +
> > +	/* The (mult * cycles) may overflow 64 bits, so add a max check */
> > +	if (cycles > max) {
> > +		nsec = ((max * mult) >> shift) * (cycles / max);
> 
> This breaks everything which does not have a 64/64bit divide instruction.
>  
> > +		cycles %= max;
> 
> Ditto.
> 
> As this is the slow path on resume you can use the 64bit functions
> declared in math64.h. And you want to put the slow path out of line.

So should I leave the clocksource_cyl2ns() untouched and only add these
do_div() 64 bit operation inside the timekeeping_resume() slow path?

Thanks,
Feng


 

