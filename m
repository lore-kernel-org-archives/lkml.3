Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaA3TUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:20:47 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:53696 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaA3TUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:20:41 -0500
MIME-Version: 1.0
In-Reply-To: <20140130185645.GC4437@mudshark.cambridge.arm.com>
References: <1391014246-9715-1-git-send-email-ard.biesheuvel@linaro.org>
	<1391014246-9715-6-git-send-email-ard.biesheuvel@linaro.org>
	<20140130185645.GC4437@mudshark.cambridge.arm.com>
Date: Thu, 30 Jan 2014 20:20:38 +0100
Message-ID: <CAKv+Gu_NdVHawdVz3KUeZPHUL4ZPNSpeq7EWAgsVy+DfS6Kaqw@mail.gmail.com>
Subject: Re: [PATCH 5/5] arm64: add Crypto Extensions based synchronous core
 AES cipher
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 January 2014 19:56, Will Deacon <will.deacon@arm.com> wrote:
> Hi Ard,
>
> On Wed, Jan 29, 2014 at 04:50:46PM +0000, Ard Biesheuvel wrote:
>> diff --git a/arch/arm64/crypto/aes-ce-cipher.c b/arch/arm64/crypto/aes-ce-cipher.c
>> new file mode 100644
>> index 000000000000..b5a5d5d6e4b8
>> --- /dev/null
>> +++ b/arch/arm64/crypto/aes-ce-cipher.c
>> @@ -0,0 +1,103 @@
>> +/*
>> + * linux/arch/arm64/crypto/aes-ce-cipher.c
>> + *
>> + * Copyright (C) 2013 Linaro Ltd <ard.biesheuvel@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <asm/neon.h>
>> +#include <crypto/aes.h>
>> +#include <linux/crypto.h>
>> +#include <linux/module.h>
>> +#include <linux/cpufeature.h>
>> +
>> +MODULE_DESCRIPTION("Synchronous AES cipher using ARMv8 Crypto Extensions");
>> +MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>> +MODULE_LICENSE("GPL");
>> +
>> +static void aes_cipher_encrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
>> +{
>> +     struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>> +     u32 rounds = 6 + ctx->key_length / 4;
>
> Can you document these constants please?
>

Sure.

>> +
>> +     kernel_neon_begin();
>> +
>> +     __asm__("       ld1             {v0.16b}, [%[in]]               ;"
>> +             "       ld1             {v1.16b}, [%[key]], #16         ;"
>> +             "0:     aese            v0.16b, v1.16b                  ;"
>> +             "       subs            %[rounds], %[rounds], #1        ;"
>> +             "       ld1             {v1.16b}, [%[key]], #16         ;"
>> +             "       beq             1f                              ;"
>> +             "       aesmc           v0.16b, v0.16b                  ;"
>> +             "       b               0b                              ;"
>> +             "1:     eor             v0.16b, v0.16b, v1.16b          ;"
>> +             "       st1             {v0.16b}, [%[out]]              ;"
>> +     : :
>> +             [out]           "r"(dst),
>> +             [in]            "r"(src),
>> +             [rounds]        "r"(rounds),
>> +             [key]           "r"(ctx->key_enc)
>> +     :                       "cc");
>
> You probably need a memory output to stop this being re-ordered by the
> compiler. Can GCC not generate the addressing modes you need directly,
> allowing you to avoid moving everything into registers?
>

Would a memory clobber work as well?

Re addressing modes: I would prefer to explicitly use v0 and v1, I
have another patch pending that allows partial saves/restores of the
NEON register file when called from interrupt context. I suppose I
could use 'register asm("v0")' or something like that, but that won't
make it any prettier.

>
>> +     kernel_neon_end();
>> +}
>> +
>> +static void aes_cipher_decrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
>> +{
>> +     struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>> +     u32 rounds = 6 + ctx->key_length / 4;
>> +
>> +     kernel_neon_begin();
>> +
>> +     __asm__("       ld1             {v0.16b}, [%[in]]               ;"
>> +             "       ld1             {v1.16b}, [%[key]], #16         ;"
>> +             "0:     aesd            v0.16b, v1.16b                  ;"
>> +             "       ld1             {v1.16b}, [%[key]], #16         ;"
>> +             "       subs            %[rounds], %[rounds], #1        ;"
>> +             "       beq             1f                              ;"
>> +             "       aesimc          v0.16b, v0.16b                  ;"
>> +             "       b               0b                              ;"
>> +             "1:     eor             v0.16b, v0.16b, v1.16b          ;"
>> +             "       st1             {v0.16b}, [%[out]]              ;"
>> +     : :
>> +             [out]           "r"(dst),
>> +             [in]            "r"(src),
>> +             [rounds]        "r"(rounds),
>> +             [key]           "r"(ctx->key_dec)
>> +     :                       "cc");
>
> Same comments here.
>
> FWIW: I spoke to the guy at ARM who designed the crypto instructions and he
> reckons your code works :)
>

Good!

Care to comment on the rest of the series?

Cheers.
Ard.
