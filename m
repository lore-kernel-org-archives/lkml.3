Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060Ab3HNQGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:06:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58640 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab3HNQGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:06:42 -0400
Date: Wed, 14 Aug 2013 18:06:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] preempt_count rework
Message-ID: <20130814160632.GJ24092@twins.programming.kicks-ass.net>
References: <20130814131539.790947874@chello.nl>
 <520B8A81.1080405@zytor.com>
 <1376494751.7355.28.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376494751.7355.28.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 05:39:11PM +0200, Mike Galbraith wrote:
> On Wed, 2013-08-14 at 06:47 -0700, H. Peter Anvin wrote:
> 
> > On x86, you never want to take the address of a percpu variable if you
> > can avoid it, as you end up generating code like:
> > 
> > 	movq %fs:0,%rax
> > 	subl $1,(%rax)
> 
> Hmmm..
> 
> #define cpu_rq(cpu)             (&per_cpu(runqueues, (cpu)))
> #define this_rq()               (&__get_cpu_var(runqueues))
> 
> ffffffff81438c7f:       48 c7 c3 80 11 01 00    mov    $0x11180,%rbx
>         /*
>          * this_rq must be evaluated again because prev may have moved
>          * CPUs since it called schedule(), thus the 'rq' on its stack
>          * frame will be invalid.
>          */
>         finish_task_switch(this_rq(), prev);
> ffffffff81438c86:       e8 25 b4 c0 ff          callq  ffffffff810440b0 <finish_task_switch>
>                  * The context switch have flipped the stack from under us
>                  * and restored the local variables which were saved when
>                  * this task called schedule() in the past. prev == current
>                  * is still correct, but it can be moved to another cpu/rq.
>                  */
>                 cpu = smp_processor_id();
> ffffffff81438c8b:       65 8b 04 25 b8 c5 00    mov    %gs:0xc5b8,%eax
> ffffffff81438c92:       00
>                 rq = cpu_rq(cpu);
> ffffffff81438c93:       48 98                   cltq
> ffffffff81438c95:       48 03 1c c5 00 f3 bb    add    -0x7e440d00(,%rax,8),%rbx
> 
> ..so could the rq = cpu_rq(cpu) sequence be improved cycle expenditure
> wise by squirreling rq pointer away in a percpu this_rq, and replacing
> cpu_rq(cpu) above with a __this_cpu_read(this_rq) version of this_rq()?

Well, this_rq() should already get you that. The above code sucks for
using cpu_rq() when we know cpu == smp_processor_id().
