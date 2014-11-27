Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaK0DNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 22:13:24 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:44557 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbaK0DNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 22:13:22 -0500
MIME-Version: 1.0
In-Reply-To: <54768059.1080406@oracle.com>
References: <1417046282-31825-1-git-send-email-sasha.levin@oracle.com>
	<CA+55aFwjTTcGFbbEPWckxZHya5PFWo+MFbK9zMzoqZorXV21nQ@mail.gmail.com>
	<54768059.1080406@oracle.com>
Date: Wed, 26 Nov 2014 19:13:21 -0800
X-Google-Sender-Auth: LwwPdj0QBKtsCMRShQ8tRXmeLhY
Message-ID: <CA+55aFxx+Ye+v6bkK0TwzkAHxSEUc7e-EAW-1JD8mySE2nVq2w@mail.gmail.com>
Subject: Re: [RFC v2 1/2] compiler: use compiler to detect integer overflows
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 5:37 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>
> #define IS_UNSIGNED(A) (((typeof(A))-1) >= 0)
> #define TYPE_MAX(A) ((typeof(A))(~0U>>1))
> #define TYPE_MIN(A) (-TYPE_MAX(A) - 1)
> #define check_add_overflow(A, B)                                        \
> ({                                                                      \
>         typeof(A) __a = (A);                                            \
>         typeof(B) __b = (B);                                            \
>         typeof(sizeof(__a) > sizeof(__b) ? __a : __b) __min, __max;     \

That doesn't do what you think it does. The "typeof()" on a ternary
operator will not pick the type of the selected side, it will pick the
normal C integer promotion type of the right-hand sides. The actual
_conditional_ matters not at all for the final type.

Which actually ends up being the thing you want in this case, but the
thing is, it's much better written as

    typeof(__a + __b) __min, __max;

and leave it at that. That way __min and __max have the type of the
integer promotion of A and B.

>         if (IS_UNSIGNED(__a) || IS_UNSIGNED(__b))                       \
>                 0;                                                      \

And again, that's wrong for two reasons. I think you're trying to
"return" 0 from the statement expression, but that's not how it works.

Also, the logic itself is also wrong. If the smaller type is unsigned,
that doesn't help.

But once again, the C integer type promotion DTRT, and you should just then do

      if (IS_UNSIGNED(__a+__b))

but as mentioned, that "if (x) 0;" is not how you'd return 0 anyway.
You'd have to make it part of the next expression.


>         __min = TYPE_MIN(__min);                                        \
>         __max = TYPE_MAX(__max);                                        \
>         (((__a > 0) && (typeof(__max))__b > (__max - ((typeof(__max))__a)))  ||\
>                 ((__a < 0) && (typeof(__max))__b < (__min - ((typeof(__max))__a))));\
> })

.. which I didn't actually validate. And I suspect gcc won't be good
enough to optimize, so it probably generates horrendous code.

And the thing is, I think it's just *wrong* to do "overflow in signed
type". The code that does it shouldn't be helped to do it, it should
be fixed to use an unsigned type.

In other words - in this case, the lofft_t should probably just be a u64.

                   Linus
