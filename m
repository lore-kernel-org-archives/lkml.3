Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3HLUpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:45:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53130 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab3HLUpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:45:43 -0400
Message-ID: <5209494B.4050209@zytor.com>
Date: Mon, 12 Aug 2013 13:44:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] per-cpu preempt_count
References: <20130812115113.GE27162@twins.programming.kicks-ass.net> <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com> <20130812175830.GB18691@gmail.com> <CA+55aFw=S4xxdkKpjQdg77CehBBW6S-13N6-7tq4=-nN_cCUKA@mail.gmail.com>
In-Reply-To: <CA+55aFw=S4xxdkKpjQdg77CehBBW6S-13N6-7tq4=-nN_cCUKA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 12:00 PM, Linus Torvalds wrote:
> 
> Wrong. The thing is, the common case for preempt is to increment and
> decrement the count, not testing it. Exactly because we do this for
> spinlocks and for rcu read-locked regions.
> 
> Now, what we *could* do is to say:
> 
>  - we will use the high bit of the preempt count for NEED_RESCHED
> 
>  - when we set/clear that high bit, we *always* use atomic sequences,
> and we never change any of the other bits.
> 
>  - we will increment/decrement the other counters, we *only* do so on
> the local CPU, and we don't use atomic accesses.
> 
> Now, the downside of that is that *because* we don't use atomic
> accesses for the inc/dec parts, the updates to the high bit can get
> lost. But because the high bit updates are done with atomics, we know
> that they won't mess up the actual counting bits, so at least the
> count is never corrupted.
> 
> And the NEED_RESCHED bit getting lost would be very unusual. That
> clearly would *not* be acceptable for RT, but it it might be
> acceptable for "in the unusual case where we want to preempt a thread
> that was not preemtible, *and* we ended up having the extra unsual
> case that preemption enable ended up missing the preempt bit, we don't
> get preempted in a timely manner". It's probably impossible to ever
> see in practice, and considering that for non-RT use the PREEMPT bit
> is a "strong hint" rather than anything else, it sounds like it might
> be acceptable.
> 
> It is obviously *not* going to be acceptable for the RT people,
> though, but since they do different code sequences _anyway_, that's
> not really much of an issue.
> 

This seems more pain than need be if checking the count in the slow path
is okay.

	-hpa


