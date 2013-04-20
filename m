Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab3DTHcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 03:32:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55644 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab3DTHcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 03:32:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang <gang.chen@asianux.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Tony Lindgren <tony@atomide.com>,
        "olof@lixom.net" <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] ARM64: kernel: compiling issue, need implement cmpxchg64 with assembler language.
Date: Sat, 20 Apr 2013 09:32:02 +0200
Message-ID: <2182812.ymprEm6XBb@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <5171FD67.2080104@asianux.com>
References: <51712E5E.2020809@asianux.com> <201304191412.54601.arnd@arndb.de> <5171FD67.2080104@asianux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hm8QtM/qLNx5QIzQM+QLj1Vn2KG//kdOvK18MGwHGli
 zhWJIhDqUb/Gn1E6bkol40ECQ5uZUFOH62D8ZmvnAO/V2j5fCD
 B1d22r7JeYvjZKEBR4kKDbXrBVcj2LwvFi0coXScRsjhazcN+X
 Q4zgSgD+wh+dRKU7ho8Lc8qrCwVht1W7gVy3i3ufAJWifjQK8U
 lSw8+27JWbdEaVVmVIb5wEq+9DJ6L/Issic/GWIsQ6EHIHIh9A
 B9/sxUSzPSiZyYfuRS3b4vZqqCwHLj6jjuhObO0LmNx4ZPj+RT
 1aWObuWzdbABBp/ZpJ8kUBgRB9qLmdr/W5/QBIleyi+brbwknW
 tyYwE+/W9MV1WQhpgR6A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 April 2013 10:28:55 Chen Gang wrote:
> 
> -------------------------------patch begin--------------------------------------
> 
> diff --git a/arch/arm64/include/asm/cmpxchg.h b/arch/arm64/include/asm/cmpxchg.h
> index 968b5cb..b572d2b 100644
> --- a/arch/arm64/include/asm/cmpxchg.h
> +++ b/arch/arm64/include/asm/cmpxchg.h
> @@ -170,4 +170,6 @@ static inline unsigned long __cmpxchg_mb(volatile void *ptr, unsigned long old,
>                                        (unsigned long)(n),              \
>                                        sizeof(*(ptr))))
>  
> +#define cmpxchg64(ptr,o,n)     cmpxchg((ptr),(o),(n))
> +
>  #endif /* __ASM_CMPXCHG_H */

Yes, this looks good. Please provide the same for cmpxchg64_local.

> -------------------------------patch end----------------------------------------
> 
> 
> 
>   I think, we can also reference the implementation of s390:
>     it is in arch/s390/include/asm/cmpxchg.h.
>     since we are ARM64, excluding ARM(32,16...), we can only consider 64-bit.
>     if in the future, ARM64 and ARM are merged together:
>       we can use CONFIG_64BIT to switch the cmpxchg64 definition.
>       if define CONFIG_64BIT, use cmpxchg instead of cmpxchg64.
>       else, use the definition of ARM (arch/arm/include/asm/cmpxchg.h already defines cmpxchg64)

I would not worry aobut merging the two at the moment.

> -------------------------------reference begin----------------------------------
> 
> #ifdef CONFIG_64BIT
> #define cmpxchg64(ptr, o, n)                                            \
> ({                                                                      \
>         cmpxchg((ptr), (o), (n));                                       \
> })
> #else /* CONFIG_64BIT */
> ...
> -------------------------------reference end------------------------------------

This implementation in unnecessarily verbose, I think the one you have
above is nicer.

	Arnd
