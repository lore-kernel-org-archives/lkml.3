Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3J0R2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 13:28:08 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:47455 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3J0R2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 13:28:07 -0400
MIME-Version: 1.0
In-Reply-To: <20131026121902.GA24890@gmail.com>
References: <20131026121902.GA24890@gmail.com>
Date: Sun, 27 Oct 2013 10:28:05 -0700
X-Google-Sender-Auth: FTM_-27muKrylPZSkxxmgekdM6Y
Message-ID: <CA+55aFwLwZ2SoqLdD9itnXrFJyS9szC+g4J01pLxHFgKYCvrog@mail.gmail.com>
Subject: Re: [GIT PULL] locking fix
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 5:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> This tree fixes a boot crash in CONFIG_DEBUG_MUTEXES=y kernels, on
> kernels built with GCC 3.x. (There are still such distros.)

Btw, it's really not just gcc 3.x. That code was (a) incomprehensible,
(b) wrong and (c) caused problems for LLVM too.

It was wrong because "__builtin_constant_p(ww_ctx == NULL)" simply
makes no sense.

Why?

That expression is largely equivalent to
"__builtin_constant_p(ww_ctx)" (because iff ww_ctx is constant, then
the comparison to NULL is constant), which is actually much easier to
read, while carrying a totally different semantic meaning. Making
things worse, the comparison to NULL *may* be marked constant under
some very random situations (ie the compiler could turn a "taking an
address of a variable is never NULL" kind of knowledge and combining
it with other knowledge, and turn a complicated "ctx" expression into
a "I know this cannot be NULL" thing, and thus the "== NULL" is a
constant, even though ctx itself is some dynamic calculation).

Whoever wrote the original should be shot. And this commit shouldn't
have been marked as being somehow about gcc-version dependence, but
about removing completely crap code.

                    Linus
