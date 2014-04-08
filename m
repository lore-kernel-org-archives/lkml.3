Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbaDHQUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:20:44 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:39320 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbaDHQUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:20:43 -0400
MIME-Version: 1.0
In-Reply-To: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com>
Date: Tue, 8 Apr 2014 09:20:42 -0700
X-Google-Sender-Auth: wBHwfcntHYZn2C3Xthuzi7WfvKU
Message-ID: <CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Stancek <jstancek@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr, comments?

On Tue, Apr 8, 2014 at 1:47 AM, Jan Stancek <jstancek@redhat.com> wrote:
> pthread_cond_broadcast/4-1.c testcase from openposix testsuite (LTP)
> occasionally fails, because some threads fail to wake up.

Jan, I _assume_ this is on x86(-64), but can you please confirm?

Because if it's on anything else, the whole situation changes.

> Taking hb->lock in this situation will ensure that thread A needs to wait
> in futex_wake() until main thread finishes requeue operation.

So the argument was that doing *both* spin_is_locked() and
atomic_read(&hb->waiters) _should_ be unnecessary, because
hb_waiters_inc() is done *before* getting the spinlock

However, one exception to this is "requeue_futex()". Which is in fact
the test-case that Jan points to. There, when we move a futex from one
hash bucket to another, we do the increment inside the spinlock.

So I think the change is correct, although the commit message might
need a bit of improvement. I also hate that "if/else" thing, since
there's no point in an "else" if the if-statement did a "return". So
either make it just

    if (spin_is_locked(&hb->lock))
        return 1;
    return atomic_read(&hb->waiters);

or (perhaps preferably) make it

    return spin_is_locked(&hb->lock) || atomic_read(&hb->waiters);

but that "if/else" just makes me go "why?".

But I'd also like to have Davidlohr look at this, because I have a few
questions:

 - how did this never show up in the original loads? No requeueing
under those test-loads?

 - would we be better off incrementing the waiter count at the top of
futex_requeue(), at the retry_private label?

That would make us follow the "has to be incremented before taking the
lock" rule, but at the expense of making the error case handling more
complex. Although maybe we could do it as part of
"double_lock/unlock_hb()" and just mark both hb1/hb2 busy?

                      Linus
