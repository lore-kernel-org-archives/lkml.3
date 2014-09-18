Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbaIRDld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:41:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:53221 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbaIRDlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:41:31 -0400
Message-ID: <541A545C.3030307@huawei.com>
Date: Thu, 18 Sep 2014 11:41:16 +0800
From: zhangjian <bamvor.zhangjian@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Pinski <apinski@cavium.com>,
        zhangjian <bamvor.zhangjian@huawei.com>,
        Dingtianhong <dingtianhong@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <pinskia@gmail.com>, Xinwei Hu <huxinwei@huawei.com>
Subject: Re: [PATCH 07/24] ARM64:ILP32: Use the same size and layout of the
 signal structures for ILP32 as for LP64
References: <1409779158-30963-1-git-send-email-apinski@cavium.com> <1409779158-30963-8-git-send-email-apinski@cavium.com>
In-Reply-To: <1409779158-30963-8-git-send-email-apinski@cavium.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.75.31]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/4 5:19, Andrew Pinski wrote:
> Defines the macros which allow the signal structures to be the same between ILP32 and LP64.
> 
> Signed-off-by: Andrew Pinski <apinski@cavium.com>
> ---
>  arch/arm64/include/uapi/asm/siginfo.h |   33 ++++++++++++++++++++++++++++++++
>  arch/arm64/include/uapi/asm/signal.h  |   34 +++++++++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm64/include/uapi/asm/siginfo.h b/arch/arm64/include/uapi/asm/siginfo.h
> index 5a74a08..c80c612 100644
> --- a/arch/arm64/include/uapi/asm/siginfo.h
> +++ b/arch/arm64/include/uapi/asm/siginfo.h
> @@ -1,5 +1,6 @@
>  /*
>   * Copyright (C) 2012 ARM Ltd.
> + * Copyright (C) 2014 Cavium Inc.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -18,6 +19,38 @@
>  
>  #define __ARCH_SI_PREAMBLE_SIZE	(4 * sizeof(int))
>  
> +#ifdef __ILP32__
> +
> +/*
> + * For ILP32, the siginfo structures should share the same layout and
> + * alignement requirements as LP64 ABI.
> + * To do this, use an extra pad field and add aligned attribute
> + * to the structure.
> + */
> +
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
> +# undef __SIGINFO_VOIDPTR
> +# define __SIGINFO_VOIDPTR(field)		\
> +		__SIGINFO_INNER(void __user*, field)
> +# undef __SIGINFO_BAND
> +
> +# define __SIGINFO_BAND(field)			\
> +	__SIGINFO_INNER(long, field)
> +
> +/* Make the alignment of siginfo always 8 byte aligned. */
> +#define __ARCH_SI_ATTRIBUTES __attribute__((aligned(8)))
> +
> +#endif
> +
>  #include <asm-generic/siginfo.h>
>  
>  #endif
> diff --git a/arch/arm64/include/uapi/asm/signal.h b/arch/arm64/include/uapi/asm/signal.h
> index 8d1e723..d33a5f7 100644
> --- a/arch/arm64/include/uapi/asm/signal.h
> +++ b/arch/arm64/include/uapi/asm/signal.h
> @@ -16,9 +16,43 @@
>  #ifndef __ASM_SIGNAL_H
>  #define __ASM_SIGNAL_H
>  
> +#include <asm/posix-types.h>
typos here, it should be
#include <asm/posix_types.h>
> +
>  /* Required for AArch32 compatibility. */
>  #define SA_RESTORER	0x04000000
>  
> +/*
> + * Since sigset is a bitmask, we need the same size fields for ILP32
> + * and LP64.  With big-endian, 32bit bitmask does not match up to
> + * 64bit bitmask (unlike with little-endian).
> + */
> +#ifdef __ILP32__
> +
> +#define __SIGSET_INNER_TYPE __kernel_ulong_t
> +#define _NSIG_BPW 64
> +
> +# ifdef __AARCH64EB__
> +#  define __SIGNAL_INNER(type, field)		\
> +		int __pad_##field;		\
> +		type field;
> +# else
> +#  define __SIGNAL_INNER(type, field)		\
> +		type field;			\
> +		int __pad_##field;
> +# endif
> +
> +# define __SIGACTION_HANDLER(field)		\
> +	__SIGNAL_INNER(__sighandler_t, field)
> +
> +
> +#define __SIGACTION_FLAGS(field)		\
> +	__kernel_ulong_t field
> +
> +#define __SIGACTION_RESTORER(field)		\
> +	__SIGNAL_INNER(__sigrestore_t, field)
> +
> +#endif
> +
>  #include <asm-generic/signal.h>
>  
>  #endif
> 


