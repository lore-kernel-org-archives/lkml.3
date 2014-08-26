Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbaHZMdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:33:55 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:60667 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650AbaHZMdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:33:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Darius Rad <darius@bluespec.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/asm-generic/cmpxchg-local.h: perform comparison in cmpxchg using appropriate size of data
Date: Tue, 26 Aug 2014 14:33:48 +0200
Message-ID: <22513003.HL2jGO1mLV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53FB5733.4010607@bluespec.com>
References: <53FB5733.4010607@bluespec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:949pOrHyn41RXfRkMSEs7wGbanPxv1EI5oNHmoDQmUp
 OYS5FFiHzwwpx5eZ/DkwkVye5gPXw4CQBJI3IDrEsandWefYsa
 ytq2gd3kiqZjWOTL6oI2SlD0GZHohKulnpv3LGyVvd4qzjcrjS
 ffDOjhd95aSTFlpNjl5eyvNH6za6Q3VWWKB+6iDuwuyO1RMvnU
 8kqWeGNNt5fkr6xpRROJDPkuzQ5W5MUIwxj7JGVMPZ1As4tcsb
 RSYcSavtqWi+Rqnk+dY+5P/dTi7WoxxwcA2FANYYjhYbVJBwr3
 V1Bqz7YsjZ9rA8Buj/K24eBrEkgNyKKR2A0i5jpgHCBq8rH2qM
 7P95v/LgOf+AazltxOag=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 August 2014 11:33:07 Darius Rad wrote:
> In the generic implementation of cmpxchg, cast the parameters to the size
> of the data prior to comparison.  Otherwise, it is possible for the
> comparison to be done incorrectly in the case where the data size is
> smaller than the architecture register size.
> 
> For example, on a 64-bit architecture, a 32-bit value is sign extended
> differently if it is typecast from an int to an unsigned long as compared
> to being loaded from memory via an unsigned pointer (u32 *).

I don't see the scenario where this applies yet. The function itself
only deals with unsigned values, so there should never be any sign extension.

Is this a problem with the caller using a signed type? Does the same
code work on architectures that don't use the generic code?

>  Given that
> the primary, or possibly only, use of cmpxchg is with 4 and 8 byte values,
> the incorrect comparison could only occur on 64-bit architectures that make
> use of the generic cmxchg.

cmpxchg is definitely meant to handle 1 and 2 byte values as well, but it's
relatively rare. ARMv6 for instance does not handle 2-byte atomics and only
one driver (xen) has had problems because of this.

> Signed-off-by: Darius Rad <darius@bluespec.com>
> 
> ---
> It does not appear that this is relevant to architectures that are in the
> kernel tree, since the generic cmpxchg is only ever used by some 32-bit
> architectures.  This does impact the RISC-V architecture that is currently
> in development.

I guess that means that RISC-V has no mandatory atomic instructions, right?

> 
>  include/asm-generic/cmpxchg-local.h |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- linux-3.17-rc1.orig/include/asm-generic/cmpxchg-local.h	2014-08-16 12:40:26.000000000 -0400
> +++ linux-3.17-rc1/include/asm-generic/cmpxchg-local.h	2014-08-22 14:26:59.280746090 -0400
> @@ -25,19 +25,19 @@ static inline unsigned long __cmpxchg_lo
>  	raw_local_irq_save(flags);
>  	switch (size) {
>  	case 1: prev = *(u8 *)ptr;
> -		if (prev == old)
> +		if ((u8)prev == (u8)old)
>  			*(u8 *)ptr = (u8)new;
>  		break;
>  	case 2: prev = *(u16 *)ptr;
> -		if (prev == old)
> +		if ((u16)prev == (u16)old)
>  			*(u16 *)ptr = (u16)new;
>  		break;
>  	case 4: prev = *(u32 *)ptr;
> -		if (prev == old)
> +		if ((u32)prev == (u32)old)
>  			*(u32 *)ptr = (u32)new;
>  		break;
>  	case 8: prev = *(u64 *)ptr;
> -		if (prev == old)
> +		if ((u64)prev == (u64)old)
>  			*(u64 *)ptr = (u64)new;
>  		break;
>  	default:

I can see how the cast of 'old' to a narrower type makes sense, but
not 'prev', which we just loaded and zero-extended one line earlier.

	Arnd
