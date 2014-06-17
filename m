Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845AbaFQP6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:58:36 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:29541 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756235AbaFQP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:58:34 -0400
Date: Tue, 17 Jun 2014 16:58:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/24] ARM64:ILP32: Use the same size and layout of the
 signal structures for ILP32 as for LP64.
Message-ID: <20140617155830.GE21752@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-8-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400914939-9708-8-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:02:02AM -0700, Andrew Pinski wrote:
> diff --git a/arch/arm64/include/uapi/asm/siginfo.h b/arch/arm64/include/uapi/asm/siginfo.h
> index 5a74a08..1a6aa32 100644
> --- a/arch/arm64/include/uapi/asm/siginfo.h
> +++ b/arch/arm64/include/uapi/asm/siginfo.h
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (C) 2012 ARM Ltd.
> + * Copyright (C) 2014 Cavium Inc.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -18,6 +19,26 @@
>  
>  #define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
>  
> +#ifdef __ILP32__

Does the compiler define __ILP32__ or it just undefined __LP64__.
Anyway, maybe we should have some consistency and only use one in all
places.

> +# ifdef __AARCH64EB__
> +#  define __SIGINFO_INNER(type, field)		\
> +		int __pad#field;		\
> +		type field
> +# else
> +#  define __SIGINFO_INNER(type, field)		\
> +		type field;			\
> +		int __pad#field
> +# endif
> +
> +# undef __SIGINFO_VOIDPOINTER
> +# define __SIGINFO_VOIDPOINTER(field)		\
> +		__SIGINFO_INNER(void __user*, field)
> +# undef __SIGINFO_BAND
> +
> +# define __SIGINFO_BAND(field)			\
> +	__SIGINFO_INNER(long, field)
> +#endif
> +
>  #include <asm-generic/siginfo.h>
>  
>  #endif

Do the above give us the correct alignment for the _sifields union in
siginfo? Or we get it as a side-effect of some other structure member
forcing 64-bit alignment?

> diff --git a/arch/arm64/include/uapi/asm/signal.h b/arch/arm64/include/uapi/asm/signal.h
> index 8d1e723..d90d53b 100644
> --- a/arch/arm64/include/uapi/asm/signal.h
> +++ b/arch/arm64/include/uapi/asm/signal.h
> @@ -19,6 +19,38 @@
>  /* Required for AArch32 compatibility. */
>  #define SA_RESTORER	0x04000000
>  
> +/* For ILP32, sigset should be the same size fields as LP64 so use
> +   unsigned long long. */
> +#ifdef __ILP32__
> +#define __SIGSET_INNER_TYPE __extension__ unsigned long long
> +#define _NSIG_BPW 64
> +
> +# ifdef __AARCH64EB__
> +#  define __SIGNAL_INNER(type, field)		\
> +	__extension__ struct {			\
> +		int __pad_##field;		\
> +		type field;			\
> +	} __attribute__((aligned(8)))
> +# else
> +#  define __SIGNAL_INNER(type, field)		\
> +	__extension__ struct {			\
> +		type field;			\
> +		int __pad_##field;		\
> +	} __attribute__((aligned(8)))
> +# endif
> +
> +# define __SIGACTION_HANDLER(field)		\
> +	__SIGNAL_INNER(__sighandler_t, field)
> +
> +
> +#define __SIGACTION_FLAGS(field)		\
> +	__extension__ unsigned long long field
> +
> +#define __SIGACTION_RESTORER(field)		\
> +	__SIGNAL_INNER(__sigrestore_t, field)
> +
> +#endif
> +
>  #include <asm-generic/signal.h>
>  
>  #endif

I haven't seen any UAPI header using __extension__. Is this allowed? I
assume we should be allowed to use the exported kernel headers with
non-gcc compilers.

-- 
Catalin
