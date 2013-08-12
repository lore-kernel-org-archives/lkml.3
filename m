Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3HLTA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:00:58 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:37239 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3HLTAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:00:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130812175830.GB18691@gmail.com>
References: <20130812115113.GE27162@twins.programming.kicks-ass.net>
	<CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
	<20130812175830.GB18691@gmail.com>
Date: Mon, 12 Aug 2013 12:00:53 -0700
X-Google-Sender-Auth: Nz8qZPRqufdUo1grKocJWxN2leM
Message-ID: <CA+55aFw=S4xxdkKpjQdg77CehBBW6S-13N6-7tq4=-nN_cCUKA@mail.gmail.com>
Subject: Re: [RFC] per-cpu preempt_count
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 10:58 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> We could still have the advantages of NEED_RESCHED in preempt_count() by
> realizing that we only rarely actually set/clear need_resched and mostly
> read it from the highest freq user, the preempt_enable() check.
>
> So we could have it atomic, but do atomic_read() in the preempt_enable()
> hotpath which wouldn't suck donkey balls, right?

Wrong. The thing is, the common case for preempt is to increment and
decrement the count, not testing it. Exactly because we do this for
spinlocks and for rcu read-locked regions.

Now, what we *could* do is to say:

 - we will use the high bit of the preempt count for NEED_RESCHED

 - when we set/clear that high bit, we *always* use atomic sequences,
and we never change any of the other bits.

 - we will increment/decrement the other counters, we *only* do so on
the local CPU, and we don't use atomic accesses.

Now, the downside of that is that *because* we don't use atomic
accesses for the inc/dec parts, the updates to the high bit can get
lost. But because the high bit updates are done with atomics, we know
that they won't mess up the actual counting bits, so at least the
count is never corrupted.

And the NEED_RESCHED bit getting lost would be very unusual. That
clearly would *not* be acceptable for RT, but it it might be
acceptable for "in the unusual case where we want to preempt a thread
that was not preemtible, *and* we ended up having the extra unsual
case that preemption enable ended up missing the preempt bit, we don't
get preempted in a timely manner". It's probably impossible to ever
see in practice, and considering that for non-RT use the PREEMPT bit
is a "strong hint" rather than anything else, it sounds like it might
be acceptable.

It is obviously *not* going to be acceptable for the RT people,
though, but since they do different code sequences _anyway_, that's
not really much of an issue.

             Linus
