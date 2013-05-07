Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432Ab3EGCdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:33:14 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:49765 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934418Ab3EGCdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:33:11 -0400
MIME-Version: 1.0
In-Reply-To: <51885AA0.4090807@zytor.com>
References: <51884263.4020608@zytor.com>
	<CA+55aFzwjQ03ZA71rgKMhCqh_+1fcMbPJUK3upcOacX2F8+Z9A@mail.gmail.com>
	<51885AA0.4090807@zytor.com>
Date: Mon, 6 May 2013 19:33:09 -0700
X-Google-Sender-Auth: O0bdfE29tsiGJaAm4FFQs7bP4jI
Message-ID: <CA+55aFxqnB4CmJQyE1_r7swFyWUYhSU7Eyvg+7uRpCXUtpU1jg@mail.gmail.com>
Subject: Re: The type of bitops
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 6:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> That sounds insane. Just *how* could the size of the argument even
>> matter? Seriously, there's no *difference* between a 32-bit or a
>> 64-bit index. The code is the same, there's no possible reason to make
>> it be different.
>>
>
> The only reason on x86 would be to avoid the REX prefix.  Hardly worth
> it, though.

Hmm. You *might* be able to do it by simply turning the inline
functions into statement expressions, and letting the compiler do the
types as it will. Use "(nr)+0" to make sure that the type is at least
"int", and then "Ir" as the asm constraint.

A quick test seems to imply that this works:

  #define test_bit(nr, addr) \
    ({ int oldbit; \
        asm volatile("bt %2,%1\n\t" \
                "sbb %0,%0" \
                : "=r" (oldbit) \
                : "m" (*(unsigned long *)(addr)), \
                 "Ir" ((nr)+0)); \
    oldbit; })

  int test(int idx1, long idx2, void *addr)
  {
    return test_bit(idx1, addr) + test_bit(idx2, addr);
  }

and I get

    ...
    bt %edi,(%rdx)
    ...
    bt %rsi,(%rdx)
    ...

for the int/long index respectively. So if the argument is an 'int',
it will avoid the rex prefix.

And I tested that using a "char" index does indeed do the right thing too:

    movsbl %dil,%eax
    bt     %eax,(%rcx)

so that all seems surmountable.Whether it really matters, I dunno.

                 Linus
