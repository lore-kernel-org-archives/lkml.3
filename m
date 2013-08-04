Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab3HDUU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 16:20:59 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43968 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3HDUU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 16:20:58 -0400
Date: Sun, 4 Aug 2013 13:20:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Easton <kevin@guarana.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH jiffies] Avoid undefined behavior from signed overflow
Message-ID: <20130804202050.GP3836@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130727225828.GA11864@linux.vnet.ibm.com>
 <20130729153035.18805zox54aoyubf@chicago.guarana.org>
 <20130729135411.GM26694@linux.vnet.ibm.com>
 <20130730000103.35524r83mpydvs7z@chicago.guarana.org>
 <20130729142812.GN26694@linux.vnet.ibm.com>
 <CA+55aFxOp-uNHQydWfa90H+DCDvZK6d2N0fGgSNkHNrLuYWMLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxOp-uNHQydWfa90H+DCDvZK6d2N0fGgSNkHNrLuYWMLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080420-4834-0000-0000-000009C71509
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 04, 2013 at 12:16:02PM -0700, Linus Torvalds wrote:
> On Mon, Jul 29, 2013 at 7:28 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >>
> >> Ahh, there's an error in the commit message (it says signed to unsigned).
> >
> > Good catch, fixed!
> 
> .. so I ended up waiting for that fixed version due to this email, but
> it never came. Should I just apply the original and re-fix it myself?
> Or is this queued up for 3.12 as being "not likely to actually
> matter", which is quite possibly true (since we compile with
> "-fno-strict-overflow", and thus gcc should hopefully not ever do any
> transformations that depend on signed integer overflows being
> undefined)

I have it queued up for 3.12, as you say, due to "-fno-strict-overflow".
But if you would rather have it sooner, please let me know and I will send
a pull request.  Or, alternatively, please see below for the fixed patch.

Your choice!  ;-)

							Thanx, Paul

-------------------------------------------------------------------------

jiffies: Avoid undefined behavior from signed overflow

According to the C standard 3.4.3p3, overflow of a signed integer results
in undefined behavior.  This commit therefore changes the definitions
of time_after(), time_after_eq(), time_after64(), and time_after_eq64()
to avoid this undefined behavior.  The trick is that the subtraction
is done using unsigned arithmetic, which according to 6.2.5p9 cannot
overflow because it is defined as modulo arithmetic.  This has the added
(though admittedly quite small) benefit of shortening two lines of code
by four characters each.

Note that the C standard considers the cast from unsigned to
signed to be implementation-defined, see 6.3.1.3p3.  However, on a
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
Cc: Kevin Easton <kevin@guarana.org>
[ paulmck: Included time_after64() and time_after_eq64(), as suggested
  by Eric Dumazet, also fixed commit message.]

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

