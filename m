Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3J3Tue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:50:34 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46409 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab3J3Tub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:50:31 -0400
Date: Wed, 30 Oct 2013 20:50:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: will.deacon@arm.com, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf: arch_perf_out_copy_user default
Message-ID: <20131030195013.GA2253@localhost.localdomain>
References: <20131030143750.GT19466@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030143750.GT19466@laptop.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 03:37:50PM +0100, Peter Zijlstra wrote:
> Hi Frederic,
> 
> I just spotted:
> 
> #ifndef arch_perf_out_copy_user
> #define arch_perf_out_copy_user __copy_from_user_inatomic
> #endif
> 
> vs:
> 
> arch/x86/include/asm/perf_event.h:#define arch_perf_out_copy_user copy_from_user_nmi
> 
> Now the problem is that copy_from_user_nmi() and
> __copy_from_user_inatomic() have different return semantics.
> 
> Furthermore, the macro you use them in DEFINE_OUTPUT_COPY() assumes the
> return value is the amount of memory copied; as also illustrated by
> memcpy_common().
> 
> Trouble is, __copy_from_user_inatomic() returns the number of bytes
> _NOT_ copied.

Aie, sorry about that, I did a wrong assumption indeed.

> 
> With this, my question to Will is, how did your ARM unwind support
> patches ever work? AFAICT they end up using the
> __copy_from_user_inatomic() thing.
> 
> 
> ---
>  kernel/events/internal.h | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/internal.h b/kernel/events/internal.h
> index ca6599723be5..d7a0f753e695 100644
> --- a/kernel/events/internal.h
> +++ b/kernel/events/internal.h
> @@ -110,7 +110,8 @@ func_name(struct perf_output_handle *handle,				\
>  	return len;							\
>  }
>  
> -static inline int memcpy_common(void *dst, const void *src, size_t n)
> +static inline unsigned long
> +memcpy_common(void *dst, const void *src, unsigned long n)
>  {
>  	memcpy(dst, src, n);
>  	return n;
> @@ -123,7 +124,19 @@ DEFINE_OUTPUT_COPY(__output_copy, memcpy_common)
>  DEFINE_OUTPUT_COPY(__output_skip, MEMCPY_SKIP)
>  
>  #ifndef arch_perf_out_copy_user
> -#define arch_perf_out_copy_user __copy_from_user_inatomic
> +#define arch_perf_out_copy_user arch_perf_out_copy_user
> +
> +static inline unsigned long
> +arch_perf_out_copy_user(void *dst, const void *src, unsigned long n)
> +{
> +	unsigned long ret;
> +
> +	pagefault_disable();
> +	ret = __copy_from_user_inatomic(to, from, n);
> +	pagefault_enable();
> +
> +	return n - ret;

Would it make sense to rather make copy_from_user_nmi() to use a return value
pattern that is closer to those of the existing copy_from_user_*() ?

This way we avoid future mistakes of that kind.

Thanks.

> +}
>  #endif
>  
>  DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
