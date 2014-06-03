Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794AbaFCUCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:02:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084AbaFCUCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:02:39 -0400
Date: Tue, 3 Jun 2014 22:01:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
Message-ID: <20140603200125.GB1105@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home> <20140603172632.GA27956@redhat.com> <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Linus Torvalds wrote:
>
> On Tue, Jun 3, 2014 at 10:26 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > looks like, SLAB_DESTROY_BY_RCU logic is broken?
>
> I haven't looked at the code yet, but SLAB_DESTROY_BY_RCU can be
> subtle and very dangerous.
>
> The danger is that the *slab* itself is free'd by RCU, but individual
> allocations can (and do) get re-used FOR THE SAME OBJECT TYPE without
> waiting for RCU!
>
> This is subtle. It means that most people who think that "it's free'd
> by RCU" get it wrong. Because individual allocations really aren't at
> all RCU-free'd, it's just that the underlying memory is guaranteed to
> not change type or be entirely thrown away until after a RCU grace
> period.

Yes, exactly. And unless you use current->sighand (which is obviously
stable) you need lock_task_sighand() which relies on ->siglock initialized
by sighand_ctor().

> Without looking at the code, it sounds like somebody may doing things
> to "sighand->lock->wait_list" that they shouldn't do. We've had cases
> like that before, and most of them have been changed to *not* use
> SLAB_DESTROY_BY_RCU, and instead make each individual allocation be
> RCU-free'd (which is a lot simpler to think about, because then you
> don't have the whole re-use issue).

Sure, we only need to change __cleanup_sighand() to use call_rcu().
But I am not sure this makes sense, I mean, I do not think this can
make something more simple/clear.

> And this could easily be an RT issue, if the RT code does some
> re-initialization of the rtmutex that replaces the spinlock we have.

Unlikely... this should be done by sighand_ctor() anyway.

I'll try to recheck rt_mutex_unlock() tomorrow. _Perhaps_ rcu_read_unlock()
should be shifted from lock_task_sighand() to unlock_task_sighand() to
ensure that rt_mutex_unlock() does nothihg with this memory after it
makes another lock/unlock possible.

But if we need this (currently I do not think so), this doesn't depend on
SLAB_DESTROY_BY_RCU. And, at first glance, in this case rcu_read_unlock_special()
might be wrong too.

Oleg.

