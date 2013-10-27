Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3J0TfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 15:35:24 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:58244 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab3J0TfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:35:22 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFz3MLHcAFqF=WBwmHGQ+8+uU+Hd7avXt=P9L-ohv08bnw@mail.gmail.com>
References: <20131026121902.GA24890@gmail.com>
	<CA+55aFwLwZ2SoqLdD9itnXrFJyS9szC+g4J01pLxHFgKYCvrog@mail.gmail.com>
	<526D62D8.8050001@canonical.com>
	<CA+55aFz3MLHcAFqF=WBwmHGQ+8+uU+Hd7avXt=P9L-ohv08bnw@mail.gmail.com>
Date: Sun, 27 Oct 2013 12:35:21 -0700
X-Google-Sender-Auth: jFdBEOvVnSx5EznsNw_EU9ri9kU
Message-ID: <CA+55aFwOvMQSxwpu3TYc06=87EKam3D7cZgv08jkkX1=4hwuqg@mail.gmail.com>
Subject: Re: [GIT PULL] locking fix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 12:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The *ONLY* thing it is testing for is "how much can the compiler
> optimize this", and as such the *ONLY* thing it tests for is compiler
> differences.

Side note: testing "can the compiler optimize this expression at
compile time" is actually sometimes an interesting question, so it can
be a valid thing to test.

But people should understand that the question is literally about THAT
(ie visibility into compiler optimization) rather than about the value
itself.

So generally, the only thing that a __builtin_constant_p() test can be
used for is in *conjunction* with having an actual test for an actual
value, and then having special-case logic that pertains to that value.

So for example, *this* is a valid test:

    if (__builtin_constant_p(ww_ctx) && ww_ctx == NULL) {
        ... special compile-time shortcut for the NULL value ..
    } else {
        ... generic code that *also* handles the NULL value ..
    }

and it's useful for triggering a compile-time optimized code-sequence
that is only true for NULL. But because __builtin_constant_p() is
about "how well can the compiler optimize this", that "else" statement
had better be able to handle the generic case too.

And yes, there are a few places where we do expect a certain minimal
set of optimizations. So in some cases we *might* have the rule that
the only valid use of NULL in a case like the above is when the
pointer passed in is passed in as a constant. And then we might say
"we rely on the compiler always returning true for
__builtin_constant_p(NULL)", and then we might say "so the "generic"
version of the code is guaranteed to never see NULL".

But notice how *different* that

    __builtin_constant_p(ww_ctx) && ww_ctx == NULL

test is from

    __builtin_constant_p(ww_ctx == NULL)

and really, the two tests are *fundamentally* really really different.
The first one can make sense. While the second one is pure and utter
garbage.

                          Linus
