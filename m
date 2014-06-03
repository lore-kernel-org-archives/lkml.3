Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaFCSDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:03:52 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:51328 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaFCSDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:03:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140603172632.GA27956@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home>
	<20140603172632.GA27956@redhat.com>
Date: Tue, 3 Jun 2014 11:03:49 -0700
X-Google-Sender-Auth: 0-zkbaPP-q5kAc9S4vjNeTrigVw
Message-ID: <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 10:26 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> looks like, SLAB_DESTROY_BY_RCU logic is broken?

I haven't looked at the code yet, but SLAB_DESTROY_BY_RCU can be
subtle and very dangerous.

The danger is that the *slab* itself is free'd by RCU, but individual
allocations can (and do) get re-used FOR THE SAME OBJECT TYPE without
waiting for RCU!

This is subtle. It means that most people who think that "it's free'd
by RCU" get it wrong. Because individual allocations really aren't at
all RCU-free'd, it's just that the underlying memory is guaranteed to
not change type or be entirely thrown away until after a RCU grace
period.

That means that the only thing you can use rcu-delayed are:
 (a) pure optimistic reads
 (b) idempotent things that are initialized by the constructor, and
_not_ by the allocation.

Nothing else.

An example of (b) is having a lock that is initialized by the
constructor, and that everybody else uses properly: you may have
delayed people locking/unlocking it, but as long as they don't screw
anything else up they won't break even if the data structure was
re-used by a new allocations.

Without looking at the code, it sounds like somebody may doing things
to "sighand->lock->wait_list" that they shouldn't do. We've had cases
like that before, and most of them have been changed to *not* use
SLAB_DESTROY_BY_RCU, and instead make each individual allocation be
RCU-free'd (which is a lot simpler to think about, because then you
don't have the whole re-use issue).

Of course, it could easily be lack of any RCU protection too. As
mentioned, I didn't really check the code. I just wanted to clarify
this subtlety, because while I think Oleg knows about it, maybe others
didn't quite catch that subtlety.

And this could easily be an RT issue, if the RT code does some
re-initialization of the rtmutex that replaces the spinlock we have.

               Linus
