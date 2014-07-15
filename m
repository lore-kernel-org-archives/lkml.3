Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119AbaGOM2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:28:04 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59530 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794AbaGOM2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:28:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chung-Lin Tang <cltang@codesourcery.com>
Cc: Ley Foon Tan <lftan@altera.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        lftan.linux@gmail.com
Subject: Re: [PATCH v2 22/29] nios2: Miscellaneous header files
Date: Tue, 15 Jul 2014 14:27:57 +0200
Message-ID: <4477048.XUlURsz4uq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53C50A87.6000902@codesourcery.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <4999408.jEEY9BVX9F@wuerfel> <53C50A87.6000902@codesourcery.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cBKcQD74rC6srcP5kuf+zQ8RSxYAGbGkbYrczf/6Hpo
 50ENY+CS9iCWqLtmxDswfVROy54UpDhCE8XvS0iFYeFxg72mnx
 LVztZZ/6AhD6gLUoITrOn4ARVqeTg1i5itIHkxndkadRbdsvXa
 Y67ihGj8ICZLDI8w/KdRpqNdIpldHX6vj6cKt1JVseWAk4EYv7
 xW81BVUoIC5UyQNfGUZJ5sWhhTZ00vijt8/sFa9ZVEWkAVu1KK
 hjhflthkDUbcqMY91ooIsrinNeJ8f3F5KMsdGrOGEjiwrFOq+U
 dIioI/9MknP1IlXFjHLvXIdz1IaFDob2cCo6Zd1VHZvJEEeOKm
 o0cFq6oIDKdD0MYu/05k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 July 2014 19:03:35 Chung-Lin Tang wrote:
> On 2014/7/15 06:22 PM, Arnd Bergmann wrote:
> >> +
> >> > +#ifndef _UAPI_ASM_NIOS2_STATFS_H
> >> > +#define _UAPI_ASM_NIOS2_STATFS_H
> >> > +
> >> > +#define __statfs_word __s32
> > Why this? Every other architecture except parisc uses the default __u32 here.
> 
> Because include/uapi/asm/statfs.h has this:
> 
> #ifndef __statfs_word
> #if __BITS_PER_LONG == 64
> #define __statfs_word __kernel_long_t
> #else
> #define __statfs_word __u32
> #endif
> #endif
> ...
> struct statfs64 {
>         __statfs_word f_type;
>         __statfs_word f_bsize;
>         __u64 f_blocks;
>         __u64 f_bfree;
> ...
> 
> While the bits/statfs.h header in glibc has this:
> struct statfs
>   {
>     __SWORD_TYPE f_type;
>     __SWORD_TYPE f_bsize;
>     __field64(__fsblkcnt_t, __fsblkcnt64_t, f_blocks);
> ...
> struct statfs64
>   {
>     __SWORD_TYPE f_type;
>     __SWORD_TYPE f_bsize;
>     __fsblkcnt64_t f_blocks;
> ...
> 
> Where __SWORD_TYPE is always a signed integer (int or long int depending
> on 32/64-bit word size).  Hence we define the kernel __statfs_word to be
> signed 32-bit to match.
> 
> Supposedly, tilepro should have a similar issue too, though I guess this
> is quite obscure in practice. We so far haven't encountered any issues
> on nios2 without this __s32 override either, it's just by observation.

I think you should just do what x86 (and presumably most other
architectures) has, that also uses a signed type in user space
and unsigned in kernel space.

It's not really clean, but it doesn't seem to cause problems
elsewhere, and in cases like this you're normally better off
copying the mistakes that everybody else made than doing something
unusual.

> >> > +#include <linux/types.h>
> >> > +#include <asm-generic/swab.h>
> >> > +
> >> > +#ifdef CONFIG_NIOS2_CI_SWAB_SUPPORT
> >> > +#ifdef __GNUC__
> >> > +
> >> > +#define __nios2_swab(x)		\
> >> > +	__builtin_custom_ini(CONFIG_NIOS2_CI_SWAB_NO, (x))
> >> > +
> >> > +static inline __attribute__((const)) __u16 __arch_swab16(__u16 x)
> >> > +{
> >> > +	return (__u16) __nios2_swab(((__u32) x) << 16);
> >> > +}
> > Is this actually better than ___constant_swab16()?
> > 
> > Also, have you checked if you need to support old compiler versions that
> > don't have __builtin_bswap16/32/64? With newer compilers you don't need
> > to define any of these yourself.
> 
> This swap is configured/implemented using Nios II's custom instruction
> facility; it is not part of the compiler supported Nios II core
> instruction set. In fact, even the exact opcode allocated is not fixed.
> 
> So the custom swap will not be in a form usable by the compiler, and
> hence no use of it during code generation (if it is, you might not even
> need to use __builtin_swap*(), there's a optimization pass that
> recognizes the shift+or-ing C code patterns).

Ok, I see.

	Arnd
