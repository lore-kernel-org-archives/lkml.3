Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3JPPHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:07:46 -0400
Received: from a9-99.smtp-out.amazonses.com ([54.240.9.99]:43465 "EHLO
	a9-99.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab3JPPHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:07:45 -0400
Date: Wed, 16 Oct 2013 15:07:43 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 5/6] net: __this_cpu_inc in route.c
In-Reply-To: <20131016102557.GV10651@twins.programming.kicks-ass.net>
Message-ID: <00000141c1cee440-28c489c7-4335-4f03-933f-138440dbf427-000000@email.amazonses.com>
References: <20131015174722.615394057@linux.com> <20131015174747.307585124@linux.com> <20131016084659.GS10651@twins.programming.kicks-ass.net> <1381915369.2045.118.camel@edumazet-glaptop.roam.corp.google.com>
 <20131016102557.GV10651@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.10.16-54.240.9.99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013, Peter Zijlstra wrote:

> For x86 its fairly easy to see its correct this way; but for load-store
> archs this isn't immediately obvious to me.
>
> Suppose; r1 contains our per-cpu pointer:
>
> 	LOAD  r2, per-cpu-base
> 	ADD   r1, r2
> 	LOAD  r2, $(r1) # load value
> 	INC   r2
> 	STORE $(r1), r2 # store value
>
> If such a thing is done without preempt disable; we could be
> preempted/migrated at any place along that chain. In that case the STORE
> could be to another CPUs memory (we get migrated near the INC) and could
> conflict with a per-cpu operation on that CPU corrupting state.
>
> If I look at percpu.h; the generic __this_cpu versions look like they
> generate the above for such archs.

Yes they do.

> In that case; I don't see how even for statistics (where we really don't
> care what cpu the op happens on, as long as it happens to a cpu,
> coherently) it is correct to use the raw_this_cpu stuff without
> preemption protection.
>
> In fact; I think the comment near __this_cpu_read actually alludes to
> this.

Indeed. This is well known. For some statistics this has been
judged to be acceptable in the past when the alternative was disabling
interrupts since the overhead was so much higher and the statistics
operations had to be used in very performance critical sections.

