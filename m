Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3AONt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:49:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab3AONty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:49:54 -0500
Message-ID: <50F55E80.3060106@canonical.com>
Date: Tue, 15 Jan 2013 14:49:52 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH 1/7] arch: add __mutex_fastpath_lock_retval_arg to generic/sh/x86/powerpc/ia64
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com> <1358253244-11453-2-git-send-email-maarten.lankhorst@canonical.com>
In-Reply-To: <1358253244-11453-2-git-send-email-maarten.lankhorst@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, missing entry :(

Op 15-01-13 13:33, Maarten Lankhorst schreef:
> Needed for reservation slowpath.

I was hoping to convert the 'mutexes' in ttm to proper mutexes, so I extended the
core mutex code slightly to add support for reservations. This requires however
passing an argument to __mutex_fastpath_lock_retval, so I added this for all archs
based on their existing __mutex_fastpath_lock_retval implementation.

I'm guessing this would have to be split up in the final version, but for now it's
easier to edit as a single patch.

> ---
>  arch/ia64/include/asm/mutex.h    | 20 ++++++++++++++++++++
>  arch/powerpc/include/asm/mutex.h | 20 ++++++++++++++++++++
>  arch/sh/include/asm/mutex-llsc.h | 20 ++++++++++++++++++++
>  arch/x86/include/asm/mutex_32.h  | 20 ++++++++++++++++++++
>  arch/x86/include/asm/mutex_64.h  | 20 ++++++++++++++++++++
>  include/asm-generic/mutex-dec.h  | 20 ++++++++++++++++++++
>  include/asm-generic/mutex-null.h |  1 +
>  include/asm-generic/mutex-xchg.h | 21 +++++++++++++++++++++
>  8 files changed, 142 insertions(+)
>
> diff --git a/arch/ia64/include/asm/mutex.h b/arch/ia64/include/asm/mutex.h
> index bed73a6..2510058 100644
> --- a/arch/ia64/include/asm/mutex.h
> +++ b/arch/ia64/include/asm/mutex.h
> @@ -44,6 +44,26 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
>  }
>  
>  /**
> + *  __mutex_fastpath_lock_retval_arg - try to take the lock by moving the count
> + *                                     from 1 to a 0 value
> + *  @count: pointer of type atomic_t
> + *  @arg: argument to pass along if fastpath fails.
> + *  @fail_fn: function to call if the original value was not 1
> + *
> + * Change the count from 1 to a value lower than 1, and call <fail_fn> if
> + * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
> + * or anything the slow path function returns.
> + */
> +static inline int __mutex_fastpath_lock_retval_arg(atomic_t *count,
> +				void *arg, int (*fail_fn)(atomic_t *, void*))
> +{
> +	if (unlikely(ia64_fetchadd4_acq(count, -1) != 1))
> +		return fail_fn(count, arg);
> +	else
> +		return 0;
> +}
> +
> +/**
>   *  __mutex_fastpath_unlock - try to promote the count from 0 to 1
>   *  @count: pointer of type atomic_t
>   *  @fail_fn: function to call if the original value was not 0
> diff --git a/arch/powerpc/include/asm/mutex.h b/arch/powerpc/include/asm/mutex.h
> index 5399f7e..df4bcff 100644
> --- a/arch/powerpc/include/asm/mutex.h
> +++ b/arch/powerpc/include/asm/mutex.h
> @@ -97,6 +97,26 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
>  }
>  
>  /**
> + *  __mutex_fastpath_lock_retval_arg - try to take the lock by moving the count
> + *                                     from 1 to a 0 value
> + *  @count: pointer of type atomic_t
> + *  @arg: argument to pass along if fastpath fails.
> + *  @fail_fn: function to call if the original value was not 1
> + *
> + * Change the count from 1 to a value lower than 1, and call <fail_fn> if
> + * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
> + * or anything the slow path function returns.
> + */
> +static inline int __mutex_fastpath_lock_retval_arg(atomic_t *count,
> +				void *arg, int (*fail_fn)(atomic_t *, void*))
> +{
> +	if (unlikely(__mutex_dec_return_lock(count) < 0))
> +		return fail_fn(count, arg);
> +	else
> +		return 0;
> +}
> +
> +/**
>   *  __mutex_fastpath_unlock - try to promote the count from 0 to 1
>   *  @count: pointer of type atomic_t
>   *  @fail_fn: function to call if the original value was not 0
> diff --git a/arch/sh/include/asm/mutex-llsc.h b/arch/sh/include/asm/mutex-llsc.h
> index 090358a..b68dd6d 100644
> --- a/arch/sh/include/asm/mutex-llsc.h
> +++ b/arch/sh/include/asm/mutex-llsc.h
> @@ -56,6 +56,26 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
>  	return __res;
>  }
>  
> +static inline int __mutex_fastpath_lock_retval_arg(atomic_t *count,
> +				void *arg, int (*fail_fn)(atomic_t *, void *))
> +{
> +	int __done, __res;
> +
> +	__asm__ __volatile__ (
> +		"movli.l	@%2, %0	\n"
> +		"add		#-1, %0	\n"
> +		"movco.l	%0, @%2	\n"
> +		"movt		%1	\n"
> +		: "=&z" (__res), "=&r" (__done)
> +		: "r" (&(count)->counter)
> +		: "t");
> +
> +	if (unlikely(!__done || __res != 0))
> +		__res = fail_fn(count, arg);
> +
> +	return __res;
> +}
> +
>  static inline void
>  __mutex_fastpath_unlock(atomic_t *count, void (*fail_fn)(atomic_t *))
>  {
> diff --git a/arch/x86/include/asm/mutex_32.h b/arch/x86/include/asm/mutex_32.h
> index 03f90c8..34f77f9 100644
> --- a/arch/x86/include/asm/mutex_32.h
> +++ b/arch/x86/include/asm/mutex_32.h
> @@ -58,6 +58,26 @@ static inline int __mutex_fastpath_lock_retval(atomic_t *count,
>  }
>  
>  /**
> + *  __mutex_fastpath_lock_retval_arg - try to take the lock by moving the count
> + *                                     from 1 to a 0 value
> + *  @count: pointer of type atomic_t
> + *  @arg: argument to pass along if fastpath fails.
> + *  @fail_fn: function to call if the original value was not 1
> + *
> + * Change the count from 1 to a value lower than 1, and call <fail_fn> if
> + * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
> + * or anything the slow path function returns.
> + */
> +static inline int __mutex_fastpath_lock_retval_arg(atomic_t *count,
> +				void *arg, int (*fail_fn)(atomic_t *, void*))
> +{
> +	if (unlikely(atomic_dec_return(count) < 0))
> +		return fail_fn(count, arg);
> +	else
> +		return 0;
> +}
> +
> +/**
>   *  __mutex_fastpath_unlock - try to promote the mutex from 0 to 1
>   *  @count: pointer of type atomic_t
>   *  @fail_fn: function to call if the original value was not 0
> diff --git a/arch/x86/include/asm/mutex_64.h b/arch/x86/include/asm/mutex_64.h
> index 68a87b0..148249e 100644
> --- a/arch/x86/include/asm/mutex_64.h
> +++ b/arch/x86/include/asm/mutex_64.h
> @@ -53,6 +53,26 @@ static inline int __mutex_fastpath_lock_retval(atomic_t *count,
>  }
>  
>  /**
> + *  __mutex_fastpath_lock_retval_arg - try to take the lock by moving the count
> + *                                     from 1 to a 0 value
> + *  @count: pointer of type atomic_t
> + *  @arg: argument to pass along if fastpath fails.
> + *  @fail_fn: function to call if the original value was not 1
> + *
> + * Change the count from 1 to a value lower than 1, and call <fail_fn> if
> + * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
> + * or anything the slow path function returns.
> + */
> +static inline int __mutex_fastpath_lock_retval_arg(atomic_t *count,
> +				void *arg, int (*fail_fn)(atomic_t *, void*))
> +{
> +	if (unlikely(atomic_dec_return(count) < 0))
> +		return fail_fn(count, arg);
> +	else
> +		return 0;
> +}
> +
> +/**
>   * __mutex_fastpath_unlock - increment and call function if nonpositive
>   * @v: pointer of type atomic_t
>   * @fail_fn: function to call if the result is nonpositive
> diff --git a/include/asm-generic/mutex-dec.h b/include/asm-generic/mutex-dec.h
> index f104af7..f5d027e 100644
> --- a/include/asm-generic/mutex-dec.h
> +++ b/include/asm-generic/mutex-dec.h
> @@ -43,6 +43,26 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
>  }
>  
>  /**
> + *  __mutex_fastpath_lock_retval_arg - try to take the lock by moving the count
> + *                                     from 1 to a 0 value
> + *  @count: pointer of type atomic_t
> + *  @arg: argument to pass along if fastpath fails.
> + *  @fail_fn: function to call if the original value was not 1
> + *
> + * Change the count from 1 to a value lower than 1, and call <fail_fn> if
> + * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
> + * or anything the slow path function returns.
> + */
> +static inline int
> +__mutex_fastpath_lock_retval_arg(atomic_t *count, void *arg,
> +				 int (*fail_fn)(atomic_t *, void*))
> +{
> +	if (unlikely(atomic_dec_return(count) < 0))
> +		return fail_fn(count, arg);
> +	return 0;
> +}
> +
> +/**
>   *  __mutex_fastpath_unlock - try to promote the count from 0 to 1
>   *  @count: pointer of type atomic_t
>   *  @fail_fn: function to call if the original value was not 0
> diff --git a/include/asm-generic/mutex-null.h b/include/asm-generic/mutex-null.h
> index e1bbbc7..991e9c3 100644
> --- a/include/asm-generic/mutex-null.h
> +++ b/include/asm-generic/mutex-null.h
> @@ -12,6 +12,7 @@
>  
>  #define __mutex_fastpath_lock(count, fail_fn)		fail_fn(count)
>  #define __mutex_fastpath_lock_retval(count, fail_fn)	fail_fn(count)
> +#define __mutex_fastpath_lock_retval_arg(count, arg, fail_fn)	fail_fn(count, arg)
>  #define __mutex_fastpath_unlock(count, fail_fn)		fail_fn(count)
>  #define __mutex_fastpath_trylock(count, fail_fn)	fail_fn(count)
>  #define __mutex_slowpath_needs_to_unlock()		1
> diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
> index c04e0db..d9cc971 100644
> --- a/include/asm-generic/mutex-xchg.h
> +++ b/include/asm-generic/mutex-xchg.h
> @@ -55,6 +55,27 @@ __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
>  }
>  
>  /**
> + *  __mutex_fastpath_lock_retval_arg - try to take the lock by moving the count
> + *                                     from 1 to a 0 value
> + *  @count: pointer of type atomic_t
> + *  @arg: argument to pass along if fastpath fails.
> + *  @fail_fn: function to call if the original value was not 1
> + *
> + * Change the count from 1 to a value lower than 1, and call <fail_fn> if
> + * it wasn't 1 originally. This function returns 0 if the fastpath succeeds,
> + * or anything the slow path function returns.
> + */
> +static inline int
> +__mutex_fastpath_lock_retval_arg(atomic_t *count, void *arg,
> +				 int (*fail_fn)(atomic_t *, void*))
> +{
> +	if (unlikely(atomic_xchg(count, 0) != 1))
> +		if (likely(atomic_xchg(count, -1) != 1))
> +			return fail_fn(count, arg);
> +	return 0;
> +}
> +
> +/**
>   *  __mutex_fastpath_unlock - try to promote the mutex from 0 to 1
>   *  @count: pointer of type atomic_t
>   *  @fail_fn: function to call if the original value was not 0

