Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaFSMtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:49:20 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25614 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752553AbaFSMtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:49:19 -0400
Date: Thu, 19 Jun 2014 13:49:14 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/24] ARM64: Add is_ilp32_compat_task and
 is_ilp32_compat_thread and TIF_32BIT_AARCH64.
Message-ID: <20140619124914.GA8476@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-13-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400914939-9708-13-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:02:07AM -0700, Andrew Pinski wrote:
> diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
> index fad7612..85f945c 100644
> --- a/arch/arm64/include/asm/compat.h
> +++ b/arch/arm64/include/asm/compat.h
> @@ -313,6 +313,26 @@ static inline int is_a32_compat_thread(struct thread_info *thread)
>  }
>  #endif
>  
> +#ifdef CONFIG_ARM64_ILP32
> +static inline int is_ilp32_compat_task(void)
> +{
> +	return test_thread_flag(TIF_32BIT_AARCH64);
> +}
> +static inline int is_ilp32_compat_thread(struct thread_info *thread)
> +{
> +	return test_ti_thread_flag(thread, TIF_32BIT_AARCH64);
> +}
> +#else
> +static inline int is_ilp32_compat_task(void)
> +{
> +	return 0;
> +}
> +static inline int is_ilp32_compat_thread(struct thread_info *thread)
> +{
> +	return 0;
> +}
> +#endif
> +
>  #else /* !CONFIG_COMPAT */
>  
>  static inline int is_a32_compat_task(void)
> @@ -323,17 +343,25 @@ static inline int is_a32_compat_thread(struct thread_info *thread)
>  {
>  	return 0;
>  }
> +static inline int is_ilp32_compat_task(void)
> +{
> +	return 0;
> +}
> +static inline int is_ilp32_compat_thread(struct thread_info *thread)
> +{
> +	return 0;
> +}

As for a previous patch, it looks like we have too many dummy
definitions for is_ilp32_compat_*().

>  
>  #endif /* CONFIG_COMPAT */
>  
>  static inline int is_compat_task(void)
>  {
> -	return is_a32_compat_task();
> +	return is_a32_compat_task() || is_ilp32_compat_task();
>  }
>  
>  static inline int is_compat_thread(struct thread_info *thread)
>  {
> -	return is_a32_compat_thread(thread);
> +	return is_a32_compat_thread(thread) || is_ilp32_compat_thread(thread);
>  }
>  #endif /* __KERNEL__ */
>  #endif /* __ASM_COMPAT_H */
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index b2bf728..98baf65 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -108,6 +108,7 @@ static inline struct thread_info *current_thread_info(void)
>  #define TIF_SINGLESTEP		21
>  #define TIF_32BIT		22	/* AARCH32 process */
>  #define TIF_SWITCH_MM		23	/* deferred switch_mm */
> +#define TIF_32BIT_AARCH64	24	/* 32 bit process on AArch64(ILP32) */

The is_compat_task() code could be simplified if we keep the TIF_32BIT
flag for both 32 and 64-bit applications (ILP32) and define TIF_AARCH32.

-- 
Catalin
