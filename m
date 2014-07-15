Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbaGOLDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:03:43 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:42275 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758108AbaGOLDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:03:39 -0400
Message-ID: <53C50A87.6000902@codesourcery.com>
Date: Tue, 15 Jul 2014 19:03:35 +0800
From: Chung-Lin Tang <cltang@codesourcery.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <lftan.linux@gmail.com>
Subject: Re: [PATCH v2 22/29] nios2: Miscellaneous header files
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-23-git-send-email-lftan@altera.com> <4999408.jEEY9BVX9F@wuerfel>
In-Reply-To: <4999408.jEEY9BVX9F@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2014 11:03:37.0251 (UTC) FILETIME=[6D6E5730:01CFA01C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/15 06:22 PM, Arnd Bergmann wrote:
>> +
>> > +#ifndef _UAPI_ASM_NIOS2_STATFS_H
>> > +#define _UAPI_ASM_NIOS2_STATFS_H
>> > +
>> > +#define __statfs_word __s32
> Why this? Every other architecture except parisc uses the default __u32 here.

Because include/uapi/asm/statfs.h has this:

#ifndef __statfs_word
#if __BITS_PER_LONG == 64
#define __statfs_word __kernel_long_t
#else
#define __statfs_word __u32
#endif
#endif
...
struct statfs64 {
        __statfs_word f_type;
        __statfs_word f_bsize;
        __u64 f_blocks;
        __u64 f_bfree;
...

While the bits/statfs.h header in glibc has this:
struct statfs
  {
    __SWORD_TYPE f_type;
    __SWORD_TYPE f_bsize;
    __field64(__fsblkcnt_t, __fsblkcnt64_t, f_blocks);
...
struct statfs64
  {
    __SWORD_TYPE f_type;
    __SWORD_TYPE f_bsize;
    __fsblkcnt64_t f_blocks;
...

Where __SWORD_TYPE is always a signed integer (int or long int depending
on 32/64-bit word size).  Hence we define the kernel __statfs_word to be
signed 32-bit to match.

Supposedly, tilepro should have a similar issue too, though I guess this
is quite obscure in practice. We so far haven't encountered any issues
on nios2 without this __s32 override either, it's just by observation.

>> > +#include <linux/types.h>
>> > +#include <asm-generic/swab.h>
>> > +
>> > +#ifdef CONFIG_NIOS2_CI_SWAB_SUPPORT
>> > +#ifdef __GNUC__
>> > +
>> > +#define __nios2_swab(x)		\
>> > +	__builtin_custom_ini(CONFIG_NIOS2_CI_SWAB_NO, (x))
>> > +
>> > +static inline __attribute__((const)) __u16 __arch_swab16(__u16 x)
>> > +{
>> > +	return (__u16) __nios2_swab(((__u32) x) << 16);
>> > +}
> Is this actually better than ___constant_swab16()?
> 
> Also, have you checked if you need to support old compiler versions that
> don't have __builtin_bswap16/32/64? With newer compilers you don't need
> to define any of these yourself.
> 
> 	Arnd

This swap is configured/implemented using Nios II's custom instruction
facility; it is not part of the compiler supported Nios II core
instruction set. In fact, even the exact opcode allocated is not fixed.

So the custom swap will not be in a form usable by the compiler, and
hence no use of it during code generation (if it is, you might not even
need to use __builtin_swap*(), there's a optimization pass that
recognizes the shift+or-ing C code patterns)

Thanks,
Chung-Lin

