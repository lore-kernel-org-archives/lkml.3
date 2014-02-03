Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaBCQT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:19:59 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57002 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216AbaBCQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:19:58 -0500
Date: Mon, 3 Feb 2014 16:17:50 +0000
From: Will Deacon <will.deacon@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
Subject: Re: [PATCH 5/5] arm64: add Crypto Extensions based synchronous core
 AES cipher
Message-ID: <20140203161750.GH14112@mudshark.cambridge.arm.com>
References: <1391014246-9715-1-git-send-email-ard.biesheuvel@linaro.org>
 <1391014246-9715-6-git-send-email-ard.biesheuvel@linaro.org>
 <20140130185645.GC4437@mudshark.cambridge.arm.com>
 <CAKv+Gu_NdVHawdVz3KUeZPHUL4ZPNSpeq7EWAgsVy+DfS6Kaqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_NdVHawdVz3KUeZPHUL4ZPNSpeq7EWAgsVy+DfS6Kaqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 07:20:38PM +0000, Ard Biesheuvel wrote:
> On 30 January 2014 19:56, Will Deacon <will.deacon@arm.com> wrote:
> > On Wed, Jan 29, 2014 at 04:50:46PM +0000, Ard Biesheuvel wrote:
> >> +static void aes_cipher_encrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[])
> >> +{
> >> +     struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> >> +     u32 rounds = 6 + ctx->key_length / 4;
> >
> > Can you document these constants please?
> >
> 
> Sure.

Thanks.

> >> +
> >> +     kernel_neon_begin();
> >> +
> >> +     __asm__("       ld1             {v0.16b}, [%[in]]               ;"
> >> +             "       ld1             {v1.16b}, [%[key]], #16         ;"
> >> +             "0:     aese            v0.16b, v1.16b                  ;"
> >> +             "       subs            %[rounds], %[rounds], #1        ;"
> >> +             "       ld1             {v1.16b}, [%[key]], #16         ;"
> >> +             "       beq             1f                              ;"
> >> +             "       aesmc           v0.16b, v0.16b                  ;"
> >> +             "       b               0b                              ;"
> >> +             "1:     eor             v0.16b, v0.16b, v1.16b          ;"
> >> +             "       st1             {v0.16b}, [%[out]]              ;"
> >> +     : :
> >> +             [out]           "r"(dst),
> >> +             [in]            "r"(src),
> >> +             [rounds]        "r"(rounds),
> >> +             [key]           "r"(ctx->key_enc)
> >> +     :                       "cc");
> >
> > You probably need a memory output to stop this being re-ordered by the
> > compiler. Can GCC not generate the addressing modes you need directly,
> > allowing you to avoid moving everything into registers?
> >
> 
> Would a memory clobber work as well?

It would, but it could lead to suboptimal code generation by GCC (although
neon_{begin,end} may well stop GCC in its tracks anyway, so worth looking at
the disassembly).

> Re addressing modes: I would prefer to explicitly use v0 and v1, I
> have another patch pending that allows partial saves/restores of the
> NEON register file when called from interrupt context. I suppose I
> could use 'register asm("v0")' or something like that, but that won't
> make it any prettier.

It's not the use of v0/v1 that I was objecting to. I was hoping that we
could describe [in] and [out] as memory operands, so that GCC could
potentially reduce register usage for base + offset style addressing modes.
Unfortunately, I don't think we have such a constraint for AArch64 :(

If the disassembly looks ok, the "memory" clobber is probably our best bet.

Will
