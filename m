Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbaEIScx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 14:32:53 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:60725 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374AbaEIScu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 14:32:50 -0400
Date: Fri, 9 May 2014 20:32:41 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 06/20] arch,avr32: Fold atomic_ops
Message-ID: <20140509183241.GA4491@samfundet.no>
References: <20140508135840.956784204@infradead.org>
 <20140508135852.049922584@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140508135852.049922584@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Thu 08 May 2014 15:58:46 +0200 or thereabout, Peter Zijlstra wrote:
> Many of the atomic op implementations are the same except for one
> instruction; fold the lot into a few CPP macros and reduce LoC.

The add and sub atomic operations are not 100% the same. Sub has more
constraints on the integer size than add. Sub only takes a signed 21-bit
integer, while add can do 32-bit additions IIRC correctly the instructions
for AVR32.

This is why you see in atomic_sub_return() that i is typed as "rKs21", while
in atomic_add_return, i is typed "r".

Your change limits both atomic operations to work only on signed 21-bit
integers.

> This also prepares for easy addition of new ops.
> 
> Requires the asm_op because of eor.
> 
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/avr32/include/asm/atomic.h |   96 ++++++++++++++++++----------------------
>  1 file changed, 44 insertions(+), 52 deletions(-)
> 
> --- a/arch/avr32/include/asm/atomic.h
> +++ b/arch/avr32/include/asm/atomic.h
> @@ -22,58 +22,52 @@
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
> +		: "m"(v->counter), "rKs21"(i)				\

All variable i integers are limited to signed 21-bit here.

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
> +		: "m"(v->counter), "rKs21"(i)				\

Same here.

> +		: "cc");						\
> +									\
> +	return result;							\
>  }
>  
> -/*
> - * atomic_add_return - add integer to atomic variable
> - * @i: integer value to add
> - * @v: pointer of type atomic_t
> - *
> - * Atomically adds @i to @v. Returns the resulting value.
> - */
> -static inline int atomic_add_return(int i, atomic_t *v)
> -{
> -	int result;
> -
> -	if (__builtin_constant_p(i) && (i >= -1048575) && (i <= 1048576))
> -		result = atomic_sub_return(-i, v);

I do not recall why we did it like this any more, I would assume both sub and
add to be single cycle instructions.

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
> +#define ATOMIC_OPS(op, asm_op)						\
> +	ATOMIC_OP(op, asm_op)						\
> +	ATOMIC_OP_RETURN(op, asm_op)
> +
> +ATOMIC_OPS(add, add)
> +ATOMIC_OPS(sub, sub)
> +
> +#undef ATOMIC_OPS
> +#undef ATOMIC_OP_RETURN
> +#undef ATOMIC_OP
>  
>  /*
>   * atomic_sub_unless - sub unless the number is a given value
> @@ -168,8 +162,6 @@ static inline int atomic_sub_if_positive
>  #define atomic_xchg(v, new)	(xchg(&((v)->counter), new))
>  #define atomic_cmpxchg(v, o, n)	(cmpxchg(&((v)->counter), (o), (n)))
>  
> -#define atomic_sub(i, v)	(void)atomic_sub_return(i, v)
> -#define atomic_add(i, v)	(void)atomic_add_return(i, v)
>  #define atomic_dec(v)		atomic_sub(1, (v))
>  #define atomic_inc(v)		atomic_add(1, (v))

I like the simplification, do you manage to preprocessor both instruction and
instruction argument limit?

-- 
Best regards,
Hans-Christian Egtvedt
