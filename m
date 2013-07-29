Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab3G2Czc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 22:55:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57905 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3G2Cza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 22:55:30 -0400
Date: Sun, 28 Jul 2013 19:55:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, davem@davemloft.net,
        arnd@arndb.de, mingo@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH jiffies] Avoid undefined behavior from signed overflow
Message-ID: <20130729025523.GJ26694@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130727225828.GA11864@linux.vnet.ibm.com>
 <1375037219.3669.34.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375037219.3669.34.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072902-5406-0000-0000-00000ADA2293
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 28, 2013 at 11:46:59AM -0700, Eric Dumazet wrote:
> On Sat, 2013-07-27 at 15:58 -0700, Paul E. McKenney wrote:
> > According to the C standard 3.4.3p3, overflow of a signed integer results
> > in undefined behavior.  This commit therefore changes the definitions
> > of time_after() and time_after_eq() to avoid this undefined behavior.
> > The trick is that the subtraction is done using unsigned arithmetic,
> > which according to 6.2.5p9 cannot overflow because it is defined as
> > modulo arithmetic.  This has the added (though admittedly quite small)
> > benefit of shortening two lines of code by four characters each.
> > 
> > Note that the C standard considers the cast from signed to
> > unsigned to be implementation-defined, see 6.3.1.3p3.  However, on a
> > two-complement system, an implementation that defines anything other
> > than a reinterpretation of the bits is free come to me, and I will be
> > happy to act as a witness for its being committed to an insane asylum.
> > (Although I have nothing against saturating arithmetic or signals in
> > some cases, these things really should not be the default.)
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: John Stultz <john.stultz@linaro.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
> > index 97ba4e7..97967ba 100644
> > --- a/include/linux/jiffies.h
> > +++ b/include/linux/jiffies.h
> > @@ -101,13 +101,13 @@ static inline u64 get_jiffies_64(void)
> >  #define time_after(a,b)		\
> >  	(typecheck(unsigned long, a) && \
> >  	 typecheck(unsigned long, b) && \
> > -	 ((long)(b) - (long)(a) < 0))
> > +	 ((long)((b) - (a)) < 0))
> >  #define time_before(a,b)	time_after(b,a)
> >  
> >  #define time_after_eq(a,b)	\
> >  	(typecheck(unsigned long, a) && \
> >  	 typecheck(unsigned long, b) && \
> > -	 ((long)(a) - (long)(b) >= 0))
> > +	 ((long)((a) - (b)) >= 0))
> >  #define time_before_eq(a,b)	time_after_eq(b,a)
> 
> time_after64() & time_after_eq64() probably need the same.

It looks that way to me, too, good catch!  Updated patch below.

							Thanx, Paul

------------------------------------------------------------------------

jiffies: Avoid undefined behavior from signed overflow

According to the C standard 3.4.3p3, overflow of a signed integer results
in undefined behavior.  This commit therefore changes the definitions
of time_after(), time_after_eq(), time_after64(), and time_after_eq64()
to avoid this undefined behavior.  The trick is that the subtraction
is done using unsigned arithmetic, which according to 6.2.5p9 cannot
overflow because it is defined as modulo arithmetic.  This has the added
(though admittedly quite small) benefit of shortening two lines of code
by four characters each.

Note that the C standard considers the cast from signed to
unsigned to be implementation-defined, see 6.3.1.3p3.  However, on a
two-complement system, an implementation that defines anything other
than a reinterpretation of the bits is free come to me, and I will be
happy to act as a witness for its being committed to an insane asylum.
(Although I have nothing against saturating arithmetic or signals in
some cases, these things really should not be the default.)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
[ paulmck: Included time_after64() and time_after_eq64(), as suggested
  by Eric Dumazet.]

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 97ba4e7..d235e88 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -101,13 +101,13 @@ static inline u64 get_jiffies_64(void)
 #define time_after(a,b)		\
 	(typecheck(unsigned long, a) && \
 	 typecheck(unsigned long, b) && \
-	 ((long)(b) - (long)(a) < 0))
+	 ((long)((b) - (a)) < 0))
 #define time_before(a,b)	time_after(b,a)
 
 #define time_after_eq(a,b)	\
 	(typecheck(unsigned long, a) && \
 	 typecheck(unsigned long, b) && \
-	 ((long)(a) - (long)(b) >= 0))
+	 ((long)((a) - (b)) >= 0))
 #define time_before_eq(a,b)	time_after_eq(b,a)
 
 /*
@@ -130,13 +130,13 @@ static inline u64 get_jiffies_64(void)
 #define time_after64(a,b)	\
 	(typecheck(__u64, a) &&	\
 	 typecheck(__u64, b) && \
-	 ((__s64)(b) - (__s64)(a) < 0))
+	 ((__s64)((b) - (a)) < 0))
 #define time_before64(a,b)	time_after64(b,a)
 
 #define time_after_eq64(a,b)	\
 	(typecheck(__u64, a) && \
 	 typecheck(__u64, b) && \
-	 ((__s64)(a) - (__s64)(b) >= 0))
+	 ((__s64)((a) - (b)) >= 0))
 #define time_before_eq64(a,b)	time_after_eq64(b,a)
 
 #define time_in_range64(a, b, c) \

