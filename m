Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab3CURfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:35:18 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:34991 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3CURfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:35:16 -0400
Date: Thu, 21 Mar 2013 10:34:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
        Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
 atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive
	.patch added to -mm tree
Message-ID: <20130321173454.GZ3637@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130314162413.GA21344@redhat.com>
 <CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com>
 <20130315134632.GA18335@redhat.com>
 <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com>
 <20130315165131.GA32065@redhat.com>
 <20130317172621.GQ3656@linux.vnet.ibm.com>
 <20130321170827.GA23539@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321170827.GA23539@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032117-5518-0000-0000-00000CC1C9A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 06:08:27PM +0100, Oleg Nesterov wrote:
> On 03/17, Paul E. McKenney wrote:
> >
> > On Sat, Mar 16, 2013 at 07:30:22PM +0100, Oleg Nesterov wrote:
> > >
> > > > The rule is that if an atomic primitive returns non-void, then there is
> > > > a full memory barrier before and after.
> > >
> > > This case is documented...
> > >
> > > > This applies to primitives
> > > > returning boolean as well, with atomic_dec_and_test() setting this
> > > > precedent from what I can see.
> > >
> > > I don't think this is the "fair" comparison. Unlike atomic_add_unless(),
> > > atomic_dec_and_test() always changes the memory even if it "fails".
> > >
> > > If atomic_add_unless() returns 0, nothing was changed and if we add
> > > the barrier it is not clear what it should be paired with.
> > >
> > > But OK. I have to agree that "keep the rules simple" makes sense, so
> > > we should change atomic_add_unless() as well.
> >
> > Agreed!
> 
> OK... since nobody volunteered to make a patch, what do you think about
> the change below?
> 
> It should "fix" atomic_add_unless() (only on x86) and optimize
> atomic_inc/dec_unless.
> 
> With this change atomic_*_unless() can do the unnecessary mb() after
> cmpxchg() fails, but I think this case is very unlikely.
> 
> And, in the likely case atomic_inc/dec_unless avoids the 1st cmpxchg()
> which in most cases just reads the memory for the next cmpxchg().

Thank you, Oleg!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Oleg.
> 
> --- x/arch/x86/include/asm/atomic.h
> +++ x/arch/x86/include/asm/atomic.h
> @@ -212,15 +212,12 @@ static inline int atomic_xchg(atomic_t *
>  static inline int __atomic_add_unless(atomic_t *v, int a, int u)
>  {
>  	int c, old;
> -	c = atomic_read(v);
> -	for (;;) {
> -		if (unlikely(c == (u)))
> -			break;
> -		old = atomic_cmpxchg((v), c, c + (a));
> +	for (c = atomic_read(v); c != u; c = old) {
> +		old = atomic_cmpxchg(v, c, c + a);
>  		if (likely(old == c))
> -			break;
> -		c = old;
> +			return c;
>  	}
> +	smp_mb();
>  	return c;
>  }
> 
> --- x/include/linux/atomic.h
> +++ x/include/linux/atomic.h
> @@ -64,11 +64,12 @@ static inline int atomic_inc_not_zero_hi
>  static inline int atomic_inc_unless_negative(atomic_t *p)
>  {
>  	int v, v1;
> -	for (v = 0; v >= 0; v = v1) {
> +	for (v = atomic_read(p); v >= 0; v = v1) {
>  		v1 = atomic_cmpxchg(p, v, v + 1);
>  		if (likely(v1 == v))
>  			return 1;
>  	}
> +	smp_mb();
>  	return 0;
>  }
>  #endif
> @@ -77,11 +78,12 @@ static inline int atomic_inc_unless_nega
>  static inline int atomic_dec_unless_positive(atomic_t *p)
>  {
>  	int v, v1;
> -	for (v = 0; v <= 0; v = v1) {
> +	for (atomic_read(p); v <= 0; v = v1) {
>  		v1 = atomic_cmpxchg(p, v, v - 1);
>  		if (likely(v1 == v))
>  			return 1;
>  	}
> +	smp_mb();
>  	return 0;
>  }
>  #endif
> 

