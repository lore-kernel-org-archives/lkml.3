Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaEMUku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:40:50 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:45315 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaEMUkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:40:40 -0400
Date: Tue, 13 May 2014 22:40:32 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 06/20] arch,avr32: Fold atomic_ops
Message-ID: <20140513204032.GB14023@samfundet.no>
References: <20140508135840.956784204@infradead.org>
 <20140508135852.049922584@infradead.org>
 <20140509183241.GA4491@samfundet.no>
 <20140509204309.GA13467@laptop.programming.kicks-ass.net>
 <20140509205155.GH1429@laptop.programming.kicks-ass.net>
 <20140509211728.GI1429@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509211728.GI1429@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Fri 09 May 2014 23:17:28 +0200 or thereabout, Peter Zijlstra wrote:
> On Fri, May 09, 2014 at 10:51:55PM +0200, Peter Zijlstra wrote:
>> On Fri, May 09, 2014 at 10:43:09PM +0200, Peter Zijlstra wrote:
>> > On Fri, May 09, 2014 at 08:32:41PM +0200, Hans-Christian Egtvedt wrote:
>> > > > -	if (__builtin_constant_p(i) && (i >= -1048575) && (i <= 1048576))
>> > > > -		result = atomic_sub_return(-i, v);
>> > > 
>> > > I do not recall why we did it like this any more, I would assume both sub and
>> > > add to be single cycle instructions.
>> 
>> Similarly, can I rip out atomic_sub_unless() ?
> 
> Something like so?
> 
> ---
> Subject: arch,avr32: Fold atomic_ops
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed Apr 9 21:51:29 CEST 2014
> 
> Many of the atomic op implementations are the same except for one
> instruction; fold the lot into a few CPP macros and reduce LoC.
> 
> This also prepares for easy addition of new ops.
> 
> Requires the asm_op because of eor.
> 
> The avr32 sub instruction is limited to 21 bits, Hans-Christian cannot
> recall the reason for the weird __builtin_constant_p() tests so take all
> that out and use a straight fwd negate add instead of subtract.

Probably found the reason why we want to use sub with the signed 21-bit
limit, it uses one less register than the add instruction that can add up to
32-bit values.

Both instructions are 32-bit, to use a 16-bit instruction the immediate is
very small; 4 bit.

sub 32-bit, type IV, takes a register and subtracts a 21-bit immediate.
add 32-bit, type II, adds two register values together.

So by simplifying you loose this optimization.

> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/avr32/include/asm/atomic.h |  145 +++++++++++++++-------------------------
>  1 file changed, 55 insertions(+), 90 deletions(-)
> 
> --- a/arch/avr32/include/asm/atomic.h
> +++ b/arch/avr32/include/asm/atomic.h
> @@ -22,117 +22,84 @@
>  #define atomic_read(v)		(*(volatile int *)&(v)->counter)
>  #define atomic_set(v, i)	(((v)->counter) = i)
>  
> -/*
> - * atomic_sub_return - subtract the atomic variable
> - * @i: integer value to subtract
> - * @v: pointer of type atomic_t
> - *
> - * Atomically subtracts @i from @v. Returns the resulting value.
> - */
> -static inline int atomic_sub_return(int i, atomic_t *v)
> -{
> -	int result;
> -
> -	asm volatile(
> -		"/* atomic_sub_return */\n"
> -		"1:	ssrf	5\n"
> -		"	ld.w	%0, %2\n"
> -		"	sub	%0, %3\n"
> -		"	stcond	%1, %0\n"
> -		"	brne	1b"
> -		: "=&r"(result), "=o"(v->counter)
> -		: "m"(v->counter), "rKs21"(i)
> -		: "cc");
> -
> -	return result;
> +#define ATOMIC_OP(op, asm_op)						\
> +static inline void atomic_##op(int i, atomic_t *v)			\
> +{									\
> +	int result;							\
> +									\
> +	asm volatile(							\
> +		"/* atomic_" #op " */\n"				\
> +		"1:	ssrf	5\n"					\
> +		"	ld.w	%0, %2\n"				\
> +		"	" #asm_op "	%0, %3\n"			\
> +		"	stcond	%1, %0\n"				\
> +		"	brne	1b"					\
> +		: "=&r"(result), "=o"(v->counter)			\
> +		: "m"(v->counter), "r"(i)				\
> +		: "cc");						\
> +}									\
> +
> +#define ATOMIC_OP_RETURN(op, asm_op)					\
> +static inline int atomic_##op##_return(int i, atomic_t *v)		\
> +{									\
> +	int result;							\
> +									\
> +	asm volatile(							\
> +		"/* atomic_" #op "_return */\n"				\
> +		"1:	ssrf	5\n"					\
> +		"	ld.w	%0, %2\n"				\
> +		"	" #asm_op "	%0, %3\n"			\
> +		"	stcond	%1, %0\n"				\
> +		"	brne	1b"					\
> +		: "=&r"(result), "=o"(v->counter)			\
> +		: "m"(v->counter), "r"(i)				\
> +		: "cc");						\
> +									\
> +	return result;							\
>  }
>  
> +#define ATOMIC_OPS(op, asm_op)						\
> +	ATOMIC_OP(op, asm_op)						\
> +	ATOMIC_OP_RETURN(op, asm_op)
> +
> +ATOMIC_OPS(add, add)
> +
> +#undef ATOMIC_OPS
> +#undef ATOMIC_OP_RETURN
> +#undef ATOMIC_OP
> +
>  /*
> - * atomic_add_return - add integer to atomic variable
> - * @i: integer value to add
> - * @v: pointer of type atomic_t
> - *
> - * Atomically adds @i to @v. Returns the resulting value.
> + * The 'sub' instruction is limited to 21 bits, use negate add instead.
>   */
> -static inline int atomic_add_return(int i, atomic_t *v)
> -{
> -	int result;
> -
> -	if (__builtin_constant_p(i) && (i >= -1048575) && (i <= 1048576))
> -		result = atomic_sub_return(-i, v);
> -	else
> -		asm volatile(
> -			"/* atomic_add_return */\n"
> -			"1:	ssrf	5\n"
> -			"	ld.w	%0, %1\n"
> -			"	add	%0, %3\n"
> -			"	stcond	%2, %0\n"
> -			"	brne	1b"
> -			: "=&r"(result), "=o"(v->counter)
> -			: "m"(v->counter), "r"(i)
> -			: "cc", "memory");
> -
> -	return result;
> -}
> +#define atomic_sub(i, v)	atomic_add(-(i), (v))
> +#define atomic_sub_return(i, v)	atomic_add_return(-(i), (v))
>  
>  /*
> - * atomic_sub_unless - sub unless the number is a given value
> + * __atomic_add_unless - add unless the number is a given value
>   * @v: pointer of type atomic_t
> - * @a: the amount to subtract from v...
> + * @a: the amount to add to v...
>   * @u: ...unless v is equal to u.
>   *
> - * Atomically subtract @a from @v, so long as it was not @u.
> + * Atomically adds @a to @v, so long as it was not @u.
>   * Returns the old value of @v.
>  */
> -static inline void atomic_sub_unless(atomic_t *v, int a, int u)
> +static inline int __atomic_add_unless(atomic_t *v, int a, int u)
>  {
> -	int tmp;
> +	int tmp, old = atomic_read(v);
>  
>  	asm volatile(
> -		"/* atomic_sub_unless */\n"
> +		"/* __atomic_add_unless */\n"
>  		"1:	ssrf	5\n"
>  		"	ld.w	%0, %2\n"
>  		"	cp.w	%0, %4\n"
>  		"	breq	1f\n"
> -		"	sub	%0, %3\n"
> +		"	add	%0, %3\n"
>  		"	stcond	%1, %0\n"
>  		"	brne	1b\n"
>  		"1:"
>  		: "=&r"(tmp), "=o"(v->counter)
> -		: "m"(v->counter), "rKs21"(a), "rKs21"(u)
> +		: "m"(v->counter), "r"(a), "ir"(u)
>  		: "cc", "memory");
> -}
> -
> -/*
> - * __atomic_add_unless - add unless the number is a given value
> - * @v: pointer of type atomic_t
> - * @a: the amount to add to v...
> - * @u: ...unless v is equal to u.
> - *
> - * Atomically adds @a to @v, so long as it was not @u.
> - * Returns the old value of @v.
> -*/
> -static inline int __atomic_add_unless(atomic_t *v, int a, int u)
> -{
> -	int tmp, old = atomic_read(v);
> -
> -	if (__builtin_constant_p(a) && (a >= -1048575) && (a <= 1048576))
> -		atomic_sub_unless(v, -a, u);
> -	else {
> -		asm volatile(
> -			"/* __atomic_add_unless */\n"
> -			"1:	ssrf	5\n"
> -			"	ld.w	%0, %2\n"
> -			"	cp.w	%0, %4\n"
> -			"	breq	1f\n"
> -			"	add	%0, %3\n"
> -			"	stcond	%1, %0\n"
> -			"	brne	1b\n"
> -			"1:"
> -			: "=&r"(tmp), "=o"(v->counter)
> -			: "m"(v->counter), "r"(a), "ir"(u)
> -			: "cc", "memory");
> -	}
>  
>  	return old;
>  }
> @@ -168,8 +135,6 @@ static inline int atomic_sub_if_positive
>  #define atomic_xchg(v, new)	(xchg(&((v)->counter), new))
>  #define atomic_cmpxchg(v, o, n)	(cmpxchg(&((v)->counter), (o), (n)))
>  
> -#define atomic_sub(i, v)	(void)atomic_sub_return(i, v)
> -#define atomic_add(i, v)	(void)atomic_add_return(i, v)
>  #define atomic_dec(v)		atomic_sub(1, (v))
>  #define atomic_inc(v)		atomic_add(1, (v))
>  
> 

-- 
mvh
Hans-Christian Egtvedt
