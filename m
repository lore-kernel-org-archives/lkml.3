Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaLAVbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:31:31 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:63253 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaLAVb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:31:29 -0500
MIME-Version: 1.0
In-Reply-To: <1417466640.1771.576.camel@triegel.csb>
References: <1417098455.1771.338.camel@triegel.csb>
	<CA+55aFxBpLik53Q+Nwpcztox_4ZeEGqr2stiU5qzz1SGdfLGOw@mail.gmail.com>
	<1417435546.1771.400.camel@triegel.csb>
	<CA+55aFxiPbr9CJt_+G03zzYvkrr0ENNHFKNU08AjZh-j=PzUig@mail.gmail.com>
	<1417466640.1771.576.camel@triegel.csb>
Date: Mon, 1 Dec 2014 13:31:29 -0800
X-Google-Sender-Auth: o1E35TJ_FqGspe4ASO18ZW8yp8U
Message-ID: <CA+55aFxgDALOqxzaFC6bNNmyHQ+FEPQ7x5C1vF6S5oY49gKKnw@mail.gmail.com>
Subject: Re: POSIX mutex destruction requirements vs. futexes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 12:44 PM, Torvald Riegel <triegel@redhat.com> wrote:
>
> User space could introduce a wrapper (e.g., glibc could provide a futex
> wrapper that allows spurious wakeup on return of 0) -- but glibc can't
> prevent users from not using futexes directly and not through the
> wrapper.  Or should it try to intercept direct, non-wrapper uses of the
> futex syscall in some way?

So I don't think we even need to worry about direct users of the futex
system call. They had better know what they are doing.

> I agree, and that's why I mentioned that it may seem odd to fix this on
> the level of the kernel interface.  However, it just seems the best
> approach when considering practice in kernel and user space, the
> by-design futex properties, and the realities of what POSIX requires.

Sure. That said, I think there really are very few cases we need to worry about:

 - the ptreads_mutex implementation itself.

   This is, after all, what 99% of all applications will use. And
here, the only worry is to make sure that glibc (or whatever other
libc) is aware of its own reuse of allocations, and basically know
that it can get into the situation where a reused mutex memory
allocation can effectively see "stale" wakeups. That is, of course,
assuming that the library implementation is the expected racy one.
There *are* ways to avoid the races, although they are generally not
really even worth the bother - just calling futex_wait() in a loop is
the RightThing(tm) to do.

 - other random direct futex users

   Quite frankly, these are few. There are valid and real use cases
(the CLONE_CHILD_CLEARTID interface, for example, expects the user to
use a raw futex), but they tend to be low-level enough that they'd
really better know about this. And again, it should be easy enough to
just loop around FUTEX_WAIT and just reading the value if somebody is
worried about this.

Making the documentation talk about the issue, and making the strong
suggestion to make any FUTEX_WAIT style use just always loop and check
the actual value for simplicity and robustness is probably the right
approach.

               Linus
