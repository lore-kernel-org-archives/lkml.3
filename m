Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbaGOJXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:23:09 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64725 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaGOJXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:23:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 06/29] nios2: I/O Mapping
Date: Tue, 15 Jul 2014 11:22:54 +0200
Message-ID: <6508070.FGfEk39Nmq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405413956-2772-7-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-7-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:eydFO2DTa0jnkti4bO5CYYgRbWHsrIBzkvlypDGDDL9
 JhuycvOuHqpjvf8ltsPZTLkWbFaAKY0K5tg+A1I+RbDWGoBLjI
 tUb8wji6rI/I7I0JcsXN8NTYLqCTBU9kNFOxWjJuHW9oCrxZYU
 RIbU/rz43HE1jM3bVdC9mBJVPoI/UbaQvD17V9qiUM0u0GRvqj
 y3yKcLr8r2nzRb/fmrjXYoqaZ4dZLmpLiQXcG2SyeezDM5cPBL
 L7KA05iw6BPBFr7vpgpcKCEXPdqBxm6aBLjpZa1Bi9XM6PCZOn
 /vu9DLVL3dhb8RWEV1bltUBcPXaiWCF2XcAURR1yxPIamVdElr
 FRDbaD52NN2ky2/NSuJw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2014 16:45:33 Ley Foon Tan wrote:
> +#ifdef __IO_USE_DUFFS
> +
> +/* Use "Duff's Device" to unroll the loops. */
> +#define __IO_OUT_LOOP(a, b, l)				\
> +	do {						\

The I/O loops can probably better go into the C file that uses them.

> +
> +/*
> + * PCI is not enabled in nios2. Provide dummy implementation to get 'allyesconfig'
> + * to build successfully.
> + */
> +#define inb(addr)	0
> +#define inw(addr)	0
> +#define inl(addr)	0
> +#define outb(x, addr)
> +#define outw(x, addr)
> +#define outl(x, addr)

These should either use inline functions or macros that behave like them,
to avoid miscompilation. The normal way to define those macros is

#define inb(a) ({ 0; })
#define outb(x, a) do { } while (0)

> +static inline void __iomem *ioremap_writethrough(unsigned long physaddr,
> +						unsigned long size)
> +{
> +	return __ioremap(physaddr, size, 0);
> +}

ioremap_writethrough() is not a standard interface, just drop it.

> +static inline void __iomem *ioremap_fullcache(unsigned long physaddr,
> +						unsigned long size)
> +{
> +	return __ioremap(physaddr, size, _PAGE_CACHED);
> +}

This is more commonly called ioremap_cache().

ioremap_fullcache() is defined on some architectures but never used. If
you don't use this in your own code, you can drop it as well.

	Arnd
