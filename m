Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbaDHRd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:33:57 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:45889 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbaDHRd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:33:56 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
	<CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
Date: Tue, 8 Apr 2014 10:33:55 -0700
X-Google-Sender-Auth: quRw9EH2zlCWz6-35JuYLnT0Znc
Message-ID: <CA+55aFyfKOv59hptv9rEcf31X5O8s26z+S8f-MchM1C0WtXx3A@mail.gmail.com>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Stancek <jstancek@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 9:20 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> However, one exception to this is "requeue_futex()". Which is in fact
> the test-case that Jan points to. There, when we move a futex from one
> hash bucket to another, we do the increment inside the spinlock.
>
> So I think the change is correct, although the commit message might
> need a bit of improvement.

Hmm. And let's think about that powerpc race, where "spin_is_locked()"
can be false when somebody is waiting to get the lock..

We're good on the *normal* paths, exactly because we do that
hb_waiters_inc() before getting the lock (which also forces a memory
barrier), so the spin_is_locked() test is unnecessary and we have no
race.

But now Jan's patch is re-introducing spin_is_locked(), so let's think
about what that means for the requeue_futex() case. Especially since
the two accesses in

    spin_is_locked(&hb->lock) || atomic_read(&hb->waiters)

are not ordered any way wrt each other (they are both just
unconstrained reads). How does this all work? This is making me
nervous.

Moving the hb_waiters_inc() to before taking the spinlock (inside
double_lock_hb() or whatever) would make me more comfortable wrt this
whole situation, if only because now the rules would be the same for
that requeue case as for adding the futex in the first place.

But maybe somebody can just show that Jan's simpler patch is
sufficient for that case for some fundamental reason that I
overlooked. In which case I would just want a comment.

It's a day for misquoting Star Wars: "Help me, Davidlohr Bueso. You
are my only hope"

Although comments from others would be good too. PeterZ? He wasn't
originally cc'd, but was involved with the original ordering
discussion. Adding..

                    Linus
