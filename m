Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab3J0Tv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 15:51:27 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:41701 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3J0TvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:51:25 -0400
MIME-Version: 1.0
In-Reply-To: <526D6B6D.2000605@canonical.com>
References: <20131026121902.GA24890@gmail.com>
	<CA+55aFwLwZ2SoqLdD9itnXrFJyS9szC+g4J01pLxHFgKYCvrog@mail.gmail.com>
	<526D62D8.8050001@canonical.com>
	<CA+55aFz3MLHcAFqF=WBwmHGQ+8+uU+Hd7avXt=P9L-ohv08bnw@mail.gmail.com>
	<526D6B6D.2000605@canonical.com>
Date: Sun, 27 Oct 2013 12:51:24 -0700
X-Google-Sender-Auth: tSYaynA9OVOEMMy8KeOoEFdiSu4
Message-ID: <CA+55aFz4Fd-dibRL0+VKxz3PhppasvqCU7E6ToW2AWfnsenP_w@mail.gmail.com>
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

On Sun, Oct 27, 2013 at 12:37 PM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
>
> I would love for a compiler to become that smart though, but I do not think it's likely.

Dammit, even if that is true, then write the conditional *correctly*.

As mentioned, the conditional

    __builtin_constant_p(ww_ctx) && ww_ctx == NULL

is actually sensible, in a way the original one was *not*. It actually
tests what you apparently intended to test, and is more readable to
humans to boot.

And no, it still isn't actually guaranteed to do what you want it to
do. Historically, in gcc, __builtin_constant_p() really only ever
worked in macros, because by the time you use it in inline functions,
a constant NULL in the caller will have been turned into a argument
variable in the inline function, and __builtin_constant_p() would be
done before that was optimized away. Over the years, gcc has pushed
some of the builtin evaluation deeper down, and these days it actually
works within inline functions, but my point that
__builtin_constant_p() is about a certain level of compiler
optimization is very much true: you're actually testing for a compiler
optimization detail.

I know the LLVM people had similar issues with this comparison, so
these days it's not even just about gcc versions. We may never have
cared very much about icc, but llvm is actually an interesting target
compiler.

            Linus
