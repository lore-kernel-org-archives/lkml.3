Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3J3UrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:47:23 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50545 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab3J3UrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:47:22 -0400
Date: Wed, 30 Oct 2013 21:47:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: will.deacon@arm.com, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] perf: arch_perf_out_copy_user default
Message-ID: <20131030204718.GC2253@localhost.localdomain>
References: <20131030143750.GT19466@laptop.lan>
 <20131030195013.GA2253@localhost.localdomain>
 <20131030201622.GR16117@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030201622.GR16117@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 09:16:22PM +0100, Peter Zijlstra wrote:
> On Wed, Oct 30, 2013 at 08:50:28PM +0100, Frederic Weisbecker wrote:
> > 
> > Would it make sense to rather make copy_from_user_nmi() to use a return value
> > pattern that is closer to those of the existing copy_from_user_*() ?
> 
> Yeah we can do that I suppose; copy_form_user_nmi() actually uses
> __copy_from_user_inatomic() since about a week.

Ah! Looks like we can even move copy_from_user_nmi() to asm-generic/uaccess.h then.
Its fallback implementation after this patch is the same than the x86 one anyway.

Hmm but there is the range_not_ok()...

> 
> Something like so I suppose.. please check, I'm in fail mode.
> 
> It looks like DEFINE_OUTPUT_COPY() functions already returned the bytes
> not copied, and all its users appear to indeed expect that.
> 
> ---
>  arch/x86/kernel/cpu/perf_event.c           |  4 ++--
>  arch/x86/kernel/cpu/perf_event_intel_ds.c  |  2 +-
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |  2 +-
>  arch/x86/lib/usercopy.c                    |  2 +-
>  arch/x86/oprofile/backtrace.c              |  4 ++--
>  kernel/events/internal.h                   | 35 ++++++++++++++++++++++--------
>  6 files changed, 33 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 94bf3010bb39..0fa7dbe756e6 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1998,7 +1998,7 @@ perf_callchain_user32(struct pt_regs *regs, struct perf_callchain_entry *entry)
>  		frame.return_address = 0;
>  
>  		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
> -		if (bytes != sizeof(frame))
> +		if (bytes != 0)
>  			break;
>  
>  		if (!valid_user_frame(fp, sizeof(frame)))
> @@ -2050,7 +2050,7 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
>  		frame.return_address = 0;
>  
>  		bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
> -		if (bytes != sizeof(frame))
> +		if (bytes != 0)
>  			break;
>  
>  		if (!valid_user_frame(fp, sizeof(frame)))
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> index c1760ff3c757..ae96cfa5eddd 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
> @@ -789,7 +789,7 @@ static int intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
>  
>  		size = ip - to; /* Must fit our buffer, see above */
>  		bytes = copy_from_user_nmi(buf, (void __user *)to, size);
> -		if (bytes != size)
> +		if (bytes != 0)
>  			return 0;
>  
>  		kaddr = buf;
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> index 90ee6c1d0542..d82d155aca8c 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -491,7 +491,7 @@ static int branch_type(unsigned long from, unsigned long to, int abort)
>  
>  		/* may fail if text not present */
>  		bytes = copy_from_user_nmi(buf, (void __user *)from, size);
> -		if (bytes != size)
> +		if (bytes != 0)
>  			return X86_BR_NONE;
>  
>  		addr = buf;
> diff --git a/arch/x86/lib/usercopy.c b/arch/x86/lib/usercopy.c
> index 5465b8613944..ddf9ecb53cc3 100644
> --- a/arch/x86/lib/usercopy.c
> +++ b/arch/x86/lib/usercopy.c
> @@ -31,6 +31,6 @@ copy_from_user_nmi(void *to, const void __user *from, unsigned long n)
>  	ret = __copy_from_user_inatomic(to, from, n);
>  	pagefault_enable();
>  
> -	return n - ret;
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(copy_from_user_nmi);
> diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
> index d6aa6e8315d1..5d04be5efb64 100644
> --- a/arch/x86/oprofile/backtrace.c
> +++ b/arch/x86/oprofile/backtrace.c
> @@ -47,7 +47,7 @@ dump_user_backtrace_32(struct stack_frame_ia32 *head)
>  	unsigned long bytes;
>  
>  	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
> -	if (bytes != sizeof(bufhead))
> +	if (bytes != 0)
>  		return NULL;
>  
>  	fp = (struct stack_frame_ia32 *) compat_ptr(bufhead[0].next_frame);
> @@ -93,7 +93,7 @@ static struct stack_frame *dump_user_backtrace(struct stack_frame *head)
>  	unsigned long bytes;
>  
>  	bytes = copy_from_user_nmi(bufhead, head, sizeof(bufhead));
> -	if (bytes != sizeof(bufhead))
> +	if (bytes != 0)
>  		return NULL;
>  
>  	oprofile_add_trace(bufhead[0].return_address);
> diff --git a/kernel/events/internal.h b/kernel/events/internal.h
> index ca6599723be5..569b218782ad 100644
> --- a/kernel/events/internal.h
> +++ b/kernel/events/internal.h
> @@ -82,16 +82,16 @@ static inline unsigned long perf_data_size(struct ring_buffer *rb)
>  }
>  
>  #define DEFINE_OUTPUT_COPY(func_name, memcpy_func)			\
> -static inline unsigned int						\
> +static inline unsigned long						\
>  func_name(struct perf_output_handle *handle,				\
> -	  const void *buf, unsigned int len)				\
> +	  const void *buf, unsigned long len)				\
>  {									\
>  	unsigned long size, written;					\
>  									\
>  	do {								\
> -		size = min_t(unsigned long, handle->size, len);		\
> -									\
> +		size    = min(handle->size, len);			\
>  		written = memcpy_func(handle->addr, buf, size);		\
> +		written = size - written;				\

I assume copy_from_user_inatomic() shouldn't return negative value. I'm a bit
confused by it's long return type but I haven't found a place where it returns
anything else that the bytes copied. I only checked a very few archs though.

>  									\
>  		len -= written;						\
>  		handle->addr += written;				\
> @@ -110,20 +110,37 @@ func_name(struct perf_output_handle *handle,				\
>  	return len;							\
>  }
>  
> -static inline int memcpy_common(void *dst, const void *src, size_t n)
> +static inline unsigned long
> +memcpy_common(void *dst, const void *src, unsigned long n)
>  {
>  	memcpy(dst, src, n);
> -	return n;
> +	return 0;
>  }
>  
>  DEFINE_OUTPUT_COPY(__output_copy, memcpy_common)
>  
> -#define MEMCPY_SKIP(dst, src, n) (n)
> +static inline unsigned long
> +memcpy_skip(void *dst, const void *src, unsigned long n)
> +{
> +	return 0;
> +}
>  
> -DEFINE_OUTPUT_COPY(__output_skip, MEMCPY_SKIP)
> +DEFINE_OUTPUT_COPY(__output_skip, memcpy_skip)
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
> +	ret = __copy_from_user_inatomic(dst, src, n);
> +	pagefault_enable();
> +
> +	return ret;
> +}
>  #endif

Ok, that all looks good!

Thanks!

>  
>  DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
