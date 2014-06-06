Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaFFGZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 02:25:44 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:44858 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaFFGZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 02:25:43 -0400
Date: Fri, 6 Jun 2014 08:25:29 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 06/20] arch,avr32: Fold atomic_ops
Message-ID: <20140606062528.GA19702@samfundet.no>
References: <20140508135840.956784204@infradead.org>
 <20140508135852.049922584@infradead.org>
 <20140509183241.GA4491@samfundet.no>
 <20140509204309.GA13467@laptop.programming.kicks-ass.net>
 <20140509205155.GH1429@laptop.programming.kicks-ass.net>
 <20140509211728.GI1429@laptop.programming.kicks-ass.net>
 <20140513204032.GB14023@samfundet.no>
 <20140531141445.GD16155@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140531141445.GD16155@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sat 31 May 2014 16:14:45 +0200 or thereabout, Peter Zijlstra wrote:
> On Tue, May 13, 2014 at 10:40:32PM +0200, Hans-Christian Egtvedt wrote:
>> Probably found the reason why we want to use sub with the signed 21-bit
>> limit, it uses one less register than the add instruction that can add up to
>> 32-bit values.
>> 
>> Both instructions are 32-bit, to use a 16-bit instruction the immediate is
>> very small; 4 bit.
>> 
>> sub 32-bit, type IV, takes a register and subtracts a 21-bit immediate.
>> add 32-bit, type II, adds two register values together.
> 
> How about something like so? It fixes the problem that your
> atomic_sub*() can only deal with a 21bit offset, while the general
> kernel interface assumes it can deal with the full 32 bits.
> 
> It also adds the above as a comment, hopefully explaining the 21bit
> magic to the next person stumbling over this.

Looks great, I only have one comment.

> ---
>  arch/avr32/include/asm/atomic.h |  121 +++++++++++++++++++---------------------
>  1 file changed, 60 insertions(+), 61 deletions(-)
> 
> --- a/arch/avr32/include/asm/atomic.h
> +++ b/arch/avr32/include/asm/atomic.h
> @@ -22,30 +22,43 @@
>  #define atomic_read(v)		(*(volatile int *)&(v)->counter)
>  #define atomic_set(v, i)	(((v)->counter) = i)
>  
> +#define ATOMIC_OP_RETURN(op, asm_op, asm_con)				\
> +static inline int __atomic_##op##_return(int i, atomic_t *v)		\
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
> +		: "=&r" (result), "=o" (v->counter)			\
> +		: "m" (v->counter), #asm_con (i)			\
> +		: "cc");						\
> +									\
> +	return result;							\
> +}
> +
> +ATOMIC_OP_RETURN(sub, sub, rKs21)
> +ATOMIC_OP_RETURN(add, add, i)
> +
> +#undef ATOMIC_OP_RETURN
> +
>  /*
> - * atomic_sub_return - subtract the atomic variable
> - * @i: integer value to subtract
> - * @v: pointer of type atomic_t
> + * Probably found the reason why we want to use sub with the signed 21-bit
> + * limit, it uses one less register than the add instruction that can add up to
> + * 32-bit values.
>   *
> - * Atomically subtracts @i from @v. Returns the resulting value.
> + * Both instructions are 32-bit, to use a 16-bit instruction the immediate is
> + * very small; 4 bit.
> + *
> + * sub 32-bit, type IV, takes a register and subtracts a 21-bit immediate.
> + * add 32-bit, type II, adds two register values together.
>   */
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
> -}
> +#define IS_21BIT_CONST(i)						\
> +	(__builtin_constant_p(i) && ((i) >= -1048575) && ((i) <= 1048576))

Perhaps undef this macro once we're done using it?

>  
>  /*
>   * atomic_add_return - add integer to atomic variable
> @@ -56,51 +69,25 @@ static inline int atomic_sub_return(int
>   */
>  static inline int atomic_add_return(int i, atomic_t *v)
>  {
> -	int result;
> +	if (IS_21BIT_CONST(i))
> +		return __atomic_sub_return(-i, v);
>  
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
> +	return __atomic_add_return(i, v);
>  }
>  
>  /*
> - * atomic_sub_unless - sub unless the number is a given value
> + * atomic_sub_return - subtract the atomic variable
> + * @i: integer value to subtract
>   * @v: pointer of type atomic_t
> - * @a: the amount to subtract from v...
> - * @u: ...unless v is equal to u.
>   *
> - * Atomically subtract @a from @v, so long as it was not @u.
> - * Returns the old value of @v.
> -*/
> -static inline void atomic_sub_unless(atomic_t *v, int a, int u)
> + * Atomically subtracts @i from @v. Returns the resulting value.
> + */
> +static inline int atomic_sub_return(int i, atomic_t *v)
>  {
> -	int tmp;
> +	if (IS_21BIT_CONST(i))
> +		return __atomic_sub_return(i, v);
>  
> -	asm volatile(
> -		"/* atomic_sub_unless */\n"
> -		"1:	ssrf	5\n"
> -		"	ld.w	%0, %2\n"
> -		"	cp.w	%0, %4\n"
> -		"	breq	1f\n"
> -		"	sub	%0, %3\n"
> -		"	stcond	%1, %0\n"
> -		"	brne	1b\n"
> -		"1:"
> -		: "=&r"(tmp), "=o"(v->counter)
> -		: "m"(v->counter), "rKs21"(a), "rKs21"(u)
> -		: "cc", "memory");
> +	return __atomic_add_return(-i, v);
>  }
>  
>  /*
> @@ -116,9 +103,21 @@ static inline int __atomic_add_unless(at
>  {
>  	int tmp, old = atomic_read(v);
>  
> -	if (__builtin_constant_p(a) && (a >= -1048575) && (a <= 1048576))
> -		atomic_sub_unless(v, -a, u);
> -	else {
> +	if (IS_21BIT_CONST(a)) {
> +		asm volatile(
> +			"/* __atomic_sub_unless */\n"
> +			"1:	ssrf	5\n"
> +			"	ld.w	%0, %2\n"
> +			"	cp.w	%0, %4\n"
> +			"	breq	1f\n"
> +			"	sub	%0, %3\n"
> +			"	stcond	%1, %0\n"
> +			"	brne	1b\n"
> +			"1:"
> +			: "=&r"(tmp), "=o"(v->counter)
> +			: "m"(v->counter), "rKs21"(-a), "rKs21"(u)
> +			: "cc", "memory");
> +	} else {
>  		asm volatile(
>  			"/* __atomic_add_unless */\n"
>  			"1:	ssrf	5\n"

+#undef IS_21BIT_CONST

-- 
Hans-Christian Egtvedt
