Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622Ab3JPK00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:26:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50272 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760583Ab3JPK0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:26:24 -0400
Date: Wed, 16 Oct 2013 12:25:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 5/6] net: __this_cpu_inc in route.c
Message-ID: <20131016102557.GV10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
 <20131015174747.307585124@linux.com>
 <20131016084659.GS10651@twins.programming.kicks-ass.net>
 <1381915369.2045.118.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381915369.2045.118.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 02:22:49AM -0700, Eric Dumazet wrote:
> On Wed, 2013-10-16 at 10:46 +0200, Peter Zijlstra wrote:
> 
> > Are we sure all !x86 implementations will DTRT in that it will increment
> > some CPU and not get horribly confused? I suppose it would; but is
> > that a guarantee given someplace?
> 
> I think we should be fine, these are only stats exposed
> on /proc/net/stat/rt_cache

My concern was really that an unprotected __this_cpu op would complete
coherent and not corrupt state. If we cannot guarantee this it should
always be a full BUG to use it without proper protection.

For x86 its fairly easy to see its correct this way; but for load-store
archs this isn't immediately obvious to me.

Suppose; r1 contains our per-cpu pointer:

	LOAD  r2, per-cpu-base
	ADD   r1, r2
	LOAD  r2, $(r1) # load value
	INC   r2
	STORE $(r1), r2 # store value

If such a thing is done without preempt disable; we could be
preempted/migrated at any place along that chain. In that case the STORE
could be to another CPUs memory (we get migrated near the INC) and could
conflict with a per-cpu operation on that CPU corrupting state.

If I look at percpu.h; the generic __this_cpu versions look like they
generate the above for such archs.

In that case; I don't see how even for statistics (where we really don't
care what cpu the op happens on, as long as it happens to a cpu,
coherently) it is correct to use the raw_this_cpu stuff without
preemption protection.

In fact; I think the comment near __this_cpu_read actually alludes to
this.
