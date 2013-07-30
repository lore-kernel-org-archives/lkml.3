Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3G3NWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:22:07 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:51656 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab3G3NWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:22:02 -0400
Date: Tue, 30 Jul 2013 15:21:14 +0200
From: Robert Richter <rric@kernel.org>
To: Jed Davis <jld@mozilla.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf: Fix handling of arch_perf_out_copy_user return
 value.
Message-ID: <20130730131818.GA31198@rric.localhost>
References: <1375146761-4339-1-git-send-email-jld@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375146761-4339-1-git-send-email-jld@mozilla.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.07.13 18:12:40, Jed Davis wrote:
> All architectures except x86 use __copy_from_user_inatomic to provide
> arch_perf_out_copy_user; like the other copy_from routines, it returns
> the number of bytes not copied.  perf was expecting the number of bytes
> that had been copied.  This change corrects that, and thereby allows
> PERF_SAMPLE_STACK_USER to be enabled on non-x86 architectures.
> 
> x86 uses copy_from_user_nmi, which deviates from the other copy_from
> routines by returning the number of bytes copied.  (This cancels out
> the effect of perf being backwards; apparently this code has only ever
> been tested on x86.)  This change therefore adds a second wrapper to
> re-reverse it for perf; the next patch in this series will clean it up.
> 
> Signed-off-by: Jed Davis <jld@mozilla.com>
> ---
>  arch/x86/include/asm/perf_event.h |  9 ++++++++-
>  kernel/events/internal.h          | 11 ++++++++++-
>  2 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 8249df4..ddae5bd 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -274,6 +274,13 @@ static inline void perf_check_microcode(void) { }
>   static inline void amd_pmu_disable_virt(void) { }
>  #endif
>  
> -#define arch_perf_out_copy_user copy_from_user_nmi
> +static inline unsigned long copy_from_user_nmi_for_perf(void *to,
> +							const void __user *from,
> +							unsigned long n)
> +{
> +	return n - copy_from_user_nmi(to, from, n);
> +}
> +
> +#define arch_perf_out_copy_user copy_from_user_nmi_for_perf

I like your change of copy_from_user_nmi() to return bytes not copied
since it makes callers simpler and has the same i/f as other copy
functions.

Please do not introduce code that you later remove, instead merge this
patch with your next.

>  
>  #endif /* _ASM_X86_PERF_EVENT_H */
> diff --git a/kernel/events/internal.h b/kernel/events/internal.h
> index ca65997..e61b22c 100644
> --- a/kernel/events/internal.h
> +++ b/kernel/events/internal.h
> @@ -81,6 +81,7 @@ static inline unsigned long perf_data_size(struct ring_buffer *rb)
>  	return rb->nr_pages << (PAGE_SHIFT + page_order(rb));
>  }
>  
> +/* The memcpy_func must return the number of bytes successfully copied. */
>  #define DEFINE_OUTPUT_COPY(func_name, memcpy_func)			\
>  static inline unsigned int						\
>  func_name(struct perf_output_handle *handle,				\
> @@ -122,11 +123,19 @@ DEFINE_OUTPUT_COPY(__output_copy, memcpy_common)
>  
>  DEFINE_OUTPUT_COPY(__output_skip, MEMCPY_SKIP)
>  
> +/* arch_perf_out_copy_user must return the number of bytes not copied. */
>  #ifndef arch_perf_out_copy_user
>  #define arch_perf_out_copy_user __copy_from_user_inatomic
>  #endif
>  
> -DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
> +static inline unsigned long perf_memcpy_from_user(void *to,
> +						  const void __user *from,
> +						  unsigned long n)
> +{
> +	return n - arch_perf_out_copy_user(to, from, n);
> +}
> +
> +DEFINE_OUTPUT_COPY(__output_copy_user, perf_memcpy_from_user)

Better modify DEFINE_OUTPUT_COPY() to deal with bytes-not-copied as
return value for memcpy_func(). Other users of DEFINE_OUTPUT_COPY()
could be fixed easily.

-Robert
