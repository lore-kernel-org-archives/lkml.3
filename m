Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3CLAYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:24:47 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47534 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3CLAYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:24:34 -0400
Date: Mon, 11 Mar 2013 17:21:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] atomic: improve
 atomic_inc_unless_negative/atomic_dec_unless_positive
Message-ID: <20130312002131.GA29650@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1362843501-31159-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362843501-31159-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031200-5518-0000-0000-00000C71F8FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 11:38:21PM +0800, Ming Lei wrote:
> Generally, both atomic_inc_unless_negative() and
> atomic_dec_unless_positive() need at least two atomic_cmpxchg()
> to complete the atomic operation. In fact, the 1st atomic_cmpxchg()
> is just used to read current value of the atomic variable at most times.
> 
> Considered memory barrier, bus lock, cache walking, etc. things may be
> involved in atomic_cmpxchg(), it is much expensive than atomic_read(),
> which is just the simple below:
> 
> 	(*(volatile int *)&(v)->counter)
> 
> so this patch can save one extra atomic_cmpxchg() for the two
> helpers under general situation, and should improve them a bit.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  include/linux/atomic.h |   28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/atomic.h b/include/linux/atomic.h
> index 5b08a85..aa951d8 100644
> --- a/include/linux/atomic.h
> +++ b/include/linux/atomic.h
> @@ -63,26 +63,34 @@ static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
>  #ifndef atomic_inc_unless_negative
>  static inline int atomic_inc_unless_negative(atomic_t *p)
>  {
> -	int v, v1;
> -	for (v = 0; v >= 0; v = v1) {
> -		v1 = atomic_cmpxchg(p, v, v + 1);
> -		if (likely(v1 == v))
> +	int v, t;
> +
> +	v = atomic_read(p);
> +	while (1) {
> +		if (unlikely(v < 0))

As Frederic noted, you need an smp_mb() right here.  Because
atomic_inc_unless_negative() returns a value, it is required to
act as a full memory barrier.  On the other code paths, atomic_cmpxchg()
supplies the needed memory ordering, but not on this path.

> +			return 0;
> +		t = atomic_cmpxchg(p, v, v + 1);
> +		if (likely(t == v))
>  			return 1;
> +		v = t;
>  	}
> -	return 0;
>  }
>  #endif
>  
>  #ifndef atomic_dec_unless_positive
>  static inline int atomic_dec_unless_positive(atomic_t *p)
>  {
> -	int v, v1;
> -	for (v = 0; v <= 0; v = v1) {
> -		v1 = atomic_cmpxchg(p, v, v - 1);
> -		if (likely(v1 == v))
> +	int v, t;
> +
> +	v = atomic_read(p);
> +	while (1) {
> +		if (unlikely(v > 0))

Ditto here.

							Thanx, Paul

> +			return 0;
> +		t = atomic_cmpxchg(p, v, v - 1);
> +		if (likely(t == v))
>  			return 1;
> +		v = t;
>  	}
> -	return 0;
>  }
>  #endif
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

