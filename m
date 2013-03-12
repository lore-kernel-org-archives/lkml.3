Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3CLMfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:35:47 -0400
Received: from mail.southpole.se ([37.247.8.11]:43491 "EHLO mail.southpole.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab3CLMfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:35:46 -0400
Message-ID: <513F2124.6060504@southpole.se>
Date: Tue, 12 Mar 2013 13:35:48 +0100
From: Jonas Bonn <jonas@southpole.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130227 Thunderbird/17.0.3
MIME-Version: 1.0
To: arnd@arndb.de
CC: Jonas Bonn <jonas@southpole.se>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/1] asm-generic: move cmpxchg*_local defs to cmpxchg.h
References: <1362030843-25354-1-git-send-email-jonas@southpole.se>
In-Reply-To: <1362030843-25354-1-git-send-email-jonas@southpole.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-Version: 2.2.2(12343) on assp.southpole.se
X-Assp-Client-TLS: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 91741-00941
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Can you comment on this patch?  This is needed so that the generic 
asm/cmpxchg.h can be used standalone (i.e. without pulling in atomic.h). 
  OpenRISC uses the generic asm/cmpxchg.h and things currently don't 
build without this since linux/llist.h now includes asm/cmpxchg.h 
standalone.

Thanks,
Jonas

On 02/28/2013 06:54 AM, Jonas Bonn wrote:
> asm/cmpxchg.h can be included on its own and needs to be self-consistent.
> The definitions for the cmpxchg*_local macros, as such, need to be part
> of this file.
>
> This fixes a build issue on OpenRISC since the system.h smashing patch
> 96f951edb1f1bdbbc99b0cd458f9808bb83d58ae that introdued the direct inclusion
> asm/cmpxchg.h into linux/llist.h.
>
> CC: David Howells <dhowells@redhat.com>
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> ---
>   include/asm-generic/atomic.h  |    6 ------
>   include/asm-generic/cmpxchg.h |   10 ++++++++++
>   2 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
> index 1ced641..33bd2de 100644
> --- a/include/asm-generic/atomic.h
> +++ b/include/asm-generic/atomic.h
> @@ -136,12 +136,6 @@ static inline void atomic_dec(atomic_t *v)
>   #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
>   #define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
>
> -#define cmpxchg_local(ptr, o, n)				  	       \
> -	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
> -			(unsigned long)(n), sizeof(*(ptr))))
> -
> -#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
> -
>   static inline int __atomic_add_unless(atomic_t *v, int a, int u)
>   {
>     int c, old;
> diff --git a/include/asm-generic/cmpxchg.h b/include/asm-generic/cmpxchg.h
> index 1488302..811fb1e 100644
> --- a/include/asm-generic/cmpxchg.h
> +++ b/include/asm-generic/cmpxchg.h
> @@ -92,6 +92,16 @@ unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
>    */
>   #include <asm-generic/cmpxchg-local.h>
>
> +#ifndef cmpxchg_local
> +#define cmpxchg_local(ptr, o, n)				  	       \
> +	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
> +			(unsigned long)(n), sizeof(*(ptr))))
> +#endif
> +
> +#ifndef cmpxchg64_local
> +#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
> +#endif
> +
>   #define cmpxchg(ptr, o, n)	cmpxchg_local((ptr), (o), (n))
>   #define cmpxchg64(ptr, o, n)	cmpxchg64_local((ptr), (o), (n))
>
>

