Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab3H1TBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:01:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57346 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752084Ab3H1TBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:01:48 -0400
Message-ID: <1377716507.1928.57.camel@joe-AO722>
Subject: Re: [PATCH] ARC: Fix __udelay parentheses
From: Joe Perches <joe@perches.com>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: "Vineet.Gupta1@synopsys.com" <Vineet.Gupta1@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 28 Aug 2013 12:01:47 -0700
In-Reply-To: <E6BF041E97966E4DB955F0DF883AD2D684F1F601@de02wembxa.internal.synopsys.com>
References: <1377714588-2144-1-git-send-email-mjonker@synopsys.com>
	 <1377715539.1928.45.camel@joe-AO722>
	 <E6BF041E97966E4DB955F0DF883AD2D684F1F601@de02wembxa.internal.synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-28 at 18:53 +0000, Mischa Jonker wrote:
> > > Make sure that usecs is casted to long long, to ensure that the (usecs
> > > * 4295 * HZ) multiplication is 64 bit.
> > >
> > > Initially, the (usecs * 4295 * HZ) part was done as a 32 bit
> > > multiplication, with the result casted to 64 bit. This led to some
> > > bits falling off.
> > >
> > > Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
> > > ---
> > >  arch/arc/include/asm/delay.h |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/arc/include/asm/delay.h
> > > b/arch/arc/include/asm/delay.h index 442ce5d..8d35fe1 100644
> > > --- a/arch/arc/include/asm/delay.h
> > > +++ b/arch/arc/include/asm/delay.h
> > > @@ -56,8 +56,8 @@ static inline void __udelay(unsigned long usecs)
> > >  	/* (long long) cast ensures 64 bit MPY - real or emulated
> > >  	 * HZ * 4295 is pre-evaluated by gcc - hence only 2 mpy ops
> > >  	 */
> > > -	loops = ((long long)(usecs * 4295 * HZ) *
> > > -		 (long long)(loops_per_jiffy)) >> 32;
> > > +	loops = (((long long) usecs) * 4295 * HZ *
> > > +		  (long long) loops_per_jiffy) >> 32;
> > 
> > Shouldn't this be unsigned long long or u64?
> Yes, it should, but that is not directly related to the issue:) 
> 
> > Why is it >> 32 again?
> > 
> > The comment above it doesn't seem to match the code.
> > 
> The original code explains about the >> 32:
> 
> /*
>  * Normal Math for computing loops in "N" usecs
>  *  -we have precomputed @loops_per_jiffy
>  *  -1 sec has HZ jiffies
>  * loops per "N" usecs = ((loops_per_jiffy * HZ / 1000000) * N)
>  *
>  * Approximate Division by multiplication:
>  *  -Mathematically if we multiply and divide a number by same value the
>  *   result remains unchanged:  In this case, we use 2^32
>  *  -> (loops_per_N_usec * 2^32 ) / 2^32
>  *  -> (((loops_per_jiffy * HZ / 1000000) * N) * 2^32) / 2^32
>  *  -> (loops_per_jiffy * HZ * N * 4295) / 2^32
>  *
>  *  -Divide by 2^32 is very simply right shift by 32
>  *  -We simply need to ensure that the multiply per above eqn happens in
>  *   64-bit precision (if CPU doesn't support it - gcc can emaulate it)
>  */

I don't see the loops_per_jiffy initial shift << 32.

> The problem is that the original code already _tried_ to cast to 64 bits (to ensure a 64 bit multiply), but only did so after the multiply (so 32 bit multiply).

I know that.  It's the use of a signed long long
vs the unsigned long long that I think wrong.

Why cast a unsigned to a signed?


