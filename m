Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3J0TAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 15:00:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45870 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3J0TAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:00:44 -0400
Message-ID: <526D62D8.8050001@canonical.com>
Date: Sun, 27 Oct 2013 20:00:40 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking fix
References: <20131026121902.GA24890@gmail.com> <CA+55aFwLwZ2SoqLdD9itnXrFJyS9szC+g4J01pLxHFgKYCvrog@mail.gmail.com>
In-Reply-To: <CA+55aFwLwZ2SoqLdD9itnXrFJyS9szC+g4J01pLxHFgKYCvrog@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 27-10-13 18:28, Linus Torvalds schreef:
> On Sat, Oct 26, 2013 at 5:19 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> This tree fixes a boot crash in CONFIG_DEBUG_MUTEXES=y kernels, on
>> kernels built with GCC 3.x. (There are still such distros.)
> Btw, it's really not just gcc 3.x. That code was (a) incomprehensible,
> (b) wrong and (c) caused problems for LLVM too.
>
> It was wrong because "__builtin_constant_p(ww_ctx == NULL)" simply
> makes no sense.
>
> Why?
>
> That expression is largely equivalent to
> "__builtin_constant_p(ww_ctx)" (because iff ww_ctx is constant, then
> the comparison to NULL is constant), which is actually much easier to
> read, while carrying a totally different semantic meaning. Making
> things worse, the comparison to NULL *may* be marked constant under
> some very random situations (ie the compiler could turn a "taking an
> address of a variable is never NULL" kind of knowledge and combining
> it with other knowledge, and turn a complicated "ctx" expression into
> a "I know this cannot be NULL" thing, and thus the "== NULL" is a
> constant, even though ctx itself is some dynamic calculation).
>
> Whoever wrote the original should be shot. And this commit shouldn't
> have been marked as being somehow about gcc-version dependence, but
> about removing completely crap code.
>
Unfortunately gcc disagreed there, which was another compiler bug.
__builtin_constant_p(ww_ctx) was NOT equal to __builtin_constant_p(ww_ctx == NULL), iirc.
__builtin_constant_p(ww_ctx == NULL) is equal to __builtin_constant_p(ww_ctx != NULL), but
the former is more readable, since it shows we expect ww_ctx to be null.

But yeah I guess it was too broken in gcc after all, so that's why it had to be killed altogether.

