Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177AbaLASbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 13:31:34 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:43685 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaLASbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 13:31:32 -0500
MIME-Version: 1.0
In-Reply-To: <1417435546.1771.400.camel@triegel.csb>
References: <1417098455.1771.338.camel@triegel.csb>
	<CA+55aFxBpLik53Q+Nwpcztox_4ZeEGqr2stiU5qzz1SGdfLGOw@mail.gmail.com>
	<1417435546.1771.400.camel@triegel.csb>
Date: Mon, 1 Dec 2014 10:31:32 -0800
X-Google-Sender-Auth: B5m17pFepYtmzo3s3_hfPK4ROuE
Message-ID: <CA+55aFxiPbr9CJt_+G03zzYvkrr0ENNHFKNU08AjZh-j=PzUig@mail.gmail.com>
Subject: Re: POSIX mutex destruction requirements vs. futexes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 4:05 AM, Torvald Riegel <triegel@redhat.com> wrote:
> On Thu, 2014-11-27 at 11:38 -0800, Linus Torvalds wrote:
>>
>> > (1)  Allow spurious wake-ups from FUTEX_WAIT.
>>
>> because afaik that is what we actually *do* today (we'll wake up
>> whoever re-used that location in another thread), and it's mainly
>> about the whole documentation issue. No?
>
> If that's what the kernel prefers to do, this would be fine with me.

I think it's more of a "can we even do anything else"?

The kernel doesn't even see the reuse of the futex, or the fast path
parts. Not seeing the fast path is obviously by design, and not seeing
the reuse is partly due to pthreads interfaces (I guess people should
generally call mutex_destroy, but I doubt people really do, and even
if they did, how would user space actually handle the nasty race
between "pthread_unlock -> stale futex_wake" "pthread_mutex_destroy()"
anyway?).

So the thing is, I don't see how we could possibly change the existing
FUTEX_WAKE behavior.

And introducing a new "debug mode" that explicitly adds spurious
events might as well be done in user space with a wrapper about
FUTEX_WAKE or something.

Because as far as the *kernel* is concerned, there is no "spurious
wake" event.  It's not spurious. It's real and exists, and the wakeup
was really done by the user. The fact that it's really a stale wakeup
for a previous allocation of a pthread mutex data structure is
something that is completely and fundamentally invisible to the
kernel.

No?

So even from a documentation standpoint, it's really not about "kernel
interfaces" being incorrectly documented, as about a big honking
warning about internal pthread_mutex() implementation in a library,
and the impact that library choice has on allocation re-use, and how
that means that even if the FUTEX_WAKE is guaranteed to not be
spurious from a *kernel* standpoint, certain use models will create
their own spurious wake events in very subtle ways.

So I do disgree with you on the "explicitly allow spurious wake-ups",
in the sense that no, the kernel doesn't do that. But it is definitely
worth adding documentation about how users can cause their *own*
"spurious" wakeups.

So I think we continue to guarantee "no spurious wakeups" from a
kernel interface standpoint. Old programs that depend on it will
continue to work.

But at the same time, old programs that have broken libraries that
didn't realize that those libraries themselves caused "spurious"
wakeups are broken, but it's not due to some kernel issue, it's a
user-mode internal implementation (that is easy to get wrong - as
mentioned, we've had this bug ourselves inside the kernel).

                       Linus
