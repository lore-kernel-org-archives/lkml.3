Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3G1Sr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 14:47:26 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33065 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab3G1SrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 14:47:02 -0400
Message-ID: <1375037219.3669.34.camel@edumazet-glaptop>
Subject: Re: [PATCH jiffies] Avoid undefined behavior from signed overflow
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, davem@davemloft.net,
        arnd@arndb.de, mingo@kernel.org, torvalds@linux-foundation.org
Date: Sun, 28 Jul 2013 11:46:59 -0700
In-Reply-To: <20130727225828.GA11864@linux.vnet.ibm.com>
References: <20130727225828.GA11864@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-27 at 15:58 -0700, Paul E. McKenney wrote:
> According to the C standard 3.4.3p3, overflow of a signed integer results
> in undefined behavior.  This commit therefore changes the definitions
> of time_after() and time_after_eq() to avoid this undefined behavior.
> The trick is that the subtraction is done using unsigned arithmetic,
> which according to 6.2.5p9 cannot overflow because it is defined as
> modulo arithmetic.  This has the added (though admittedly quite small)
> benefit of shortening two lines of code by four characters each.
> 
> Note that the C standard considers the cast from signed to
> unsigned to be implementation-defined, see 6.3.1.3p3.  However, on a
> two-complement system, an implementation that defines anything other
> than a reinterpretation of the bits is free come to me, and I will be
> happy to act as a witness for its being committed to an insane asylum.
> (Although I have nothing against saturating arithmetic or signals in
> some cases, these things really should not be the default.)
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> 
> diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
> index 97ba4e7..97967ba 100644
> --- a/include/linux/jiffies.h
> +++ b/include/linux/jiffies.h
> @@ -101,13 +101,13 @@ static inline u64 get_jiffies_64(void)
>  #define time_after(a,b)		\
>  	(typecheck(unsigned long, a) && \
>  	 typecheck(unsigned long, b) && \
> -	 ((long)(b) - (long)(a) < 0))
> +	 ((long)((b) - (a)) < 0))
>  #define time_before(a,b)	time_after(b,a)
>  
>  #define time_after_eq(a,b)	\
>  	(typecheck(unsigned long, a) && \
>  	 typecheck(unsigned long, b) && \
> -	 ((long)(a) - (long)(b) >= 0))
> +	 ((long)((a) - (b)) >= 0))
>  #define time_before_eq(a,b)	time_after_eq(b,a)
>  



time_after64() & time_after_eq64() probably need the same.




