Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbaBFOnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:43:22 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40619 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbaBFOnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:43:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140206135001.333583247@infradead.org>
References: <20140206134825.305510953@infradead.org>
	<20140206135001.333583247@infradead.org>
Date: Thu, 6 Feb 2014 15:43:19 +0100
X-Google-Sender-Auth: ih2fmysAPHv1Wbt9_m01CJ8WuxY
Message-ID: <CAMuHMdV8BtrwfPWToxX5dUhtSQ4HP+UhWh10LM2voQ82pqcA+Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/5] arch: Sanitize atomic_t bitwise ops
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 2:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> --- a/arch/m68k/include/asm/atomic.h
> +++ b/arch/m68k/include/asm/atomic.h
> @@ -76,6 +76,9 @@ static inline int atomic_##op##_return(i
>
>  ATOMIC_OP(add, +=)
>  ATOMIC_OP(sub, -=)
> +ATOMIC_OP(and, &=)
> +ATOMIC_OP(or , |=)
> +ATOMIC_OP(xor, ^=)

This last one ain't gonna fly. Given

static inline void atomic_##op(int i, atomic_t *v)                     \
{                                                                      \
       __asm__ __volatile__(#op "l %1,%0" : "+m" (*v) : ASM_DI (i));   \
}

from the previous patch, it'll generate the "xorl" mnemonic, which
IIRC does not exist. It's called "eorl".

Verified with m68k-linux-gnu-as:

Error: Unknown operator -- statement `xorl %d0,%d1' ignored

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
