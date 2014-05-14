Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbaENT0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:26:43 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1662 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751068AbaENT0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:26:41 -0400
Message-ID: <5373C36E.3020900@nod.at>
Date: Wed, 14 May 2014 21:26:38 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux-Arch <linux-arch@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 13/27] m68k: Use common bits from generic tlb.h
References: <1400093999-18703-1-git-send-email-richard@nod.at>	<1400093999-18703-14-git-send-email-richard@nod.at> <CAMuHMdUddNc3Suq25JU7UC+YdWQHmk0nCRzCEbqmKg1+a+=FXw@mail.gmail.com>
In-Reply-To: <CAMuHMdUddNc3Suq25JU7UC+YdWQHmk0nCRzCEbqmKg1+a+=FXw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.05.2014 21:19, schrieb Geert Uytterhoeven:
> On Wed, May 14, 2014 at 8:59 PM, Richard Weinberger <richard@nod.at> wrote:
>> --- a/arch/m68k/include/asm/tlb.h
>> +++ b/arch/m68k/include/asm/tlb.h
>> @@ -1,19 +1,11 @@
>>  #ifndef _M68K_TLB_H
>>  #define _M68K_TLB_H
>>
>> -/*
>> - * m68k doesn't need any special per-pte or
>> - * per-vma handling..
>> - */
>> -#define tlb_start_vma(tlb, vma)        do { } while (0)
>> -#define tlb_end_vma(tlb, vma)  do { } while (0)
>> -#define __tlb_remove_tlb_entry(tlb, ptep, address)     do { } while (0)
>> -
>> -/*
>> - * .. because we flush the whole mm when it
>> - * fills up.
>> - */
>> -#define tlb_flush(tlb)         flush_tlb_mm((tlb)->mm)
>> +#ifdef CONFIG_MMU && !defined(CONFIG_COLDFIRE) && !defined(CONFIG_SUN3)
> 
> Syntax error:
> 
> #if defined(CONFIG_MMU) && ...

Whoops, thanks for pointing this out.

> But why this sudden #ifdef checks?

They are needed because in pgalloc.h you have:
#ifdef CONFIG_MMU
#include <asm/virtconvert.h>
#if defined(CONFIG_COLDFIRE)
#include <asm/mcf_pgalloc.h>
#elif defined(CONFIG_SUN3)
#include <asm/sun3_pgalloc.h>
#else
#include <asm/motorola_pgalloc.h>
#endif

And only asm/motorola_pgalloc.h have __pte/pmd_free_tlb as static inline functions.
Therefore we need to define them such that the generic tlb.h versions will not clash
with yours.

Thanks,
//richard
