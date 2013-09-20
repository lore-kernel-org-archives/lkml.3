Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3ITQcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:32:22 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:50253 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3ITQcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:32:21 -0400
Date: Fri, 20 Sep 2013 11:26:05 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
Message-ID: <20130920162603.GA30381@localhost.localdomain>
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>
 <CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>
 <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 01:03:17PM +0200, Thomas Gleixner wrote:
> On Thu, 19 Sep 2013, Linus Torvalds wrote:
> 
> > On Thu, Sep 19, 2013 at 2:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > >
> > > It fixes stacks overruns reported by Benjamin Herrenschmidt:
> > > http://lkml.kernel.org/r/1378330796.4321.50.camel%40pasglop
> > 
> > So I don't really dislike this patch-series, but isn't "irq_exit()"
> > (which calls the new softirq_on_stack()) already running in the
> > context of the irq stack? And it's run at the very end of the irq
> > processing, so the irq stack should be empty too at that point.
> 
> Right, but most of the implementations are braindamaged.
> 
>       irq_enter();
>       handle_irq_on_hardirq_stack();
>       irq_exit();
> 
> instead of doing:
> 	
>       switch_stack()
>       irq_enter()
>       handle_irq()
>       irq_exit()
>       restore_stack()
> 
> So in the case of softirq processing (the likely case) we end up doing:
> 
>    switch_to_hardirq_stack()
>    ...
>    restore_original_stack()
>    switch_to_softirq_stack()
>    ...
>    restore_original_stack()
> 
> Two avoidable stack switch operations for no gain.
> 
> > I'm assuming that the problem is that since we're already on the irq
> > stack, if *another* irq comes in, now that *other* irq doesn't get yet
> > another irq stack page. And I'm wondering whether we shouldn't just
> > fix that (hopefully unlikely) case instead? So instead of having a
> > softirq stack, we'd have just an extra irq stack for the case where
> > the original irq stack is already in use.
> 
> Why not have a single irq_stack large enough to accomodate interrupt
> handling during softirq processing? We have no interrupt nesting so
> the maximum stack depth necessary is
> 
>   max(softirq_stack_usage) + max(irq_stack_usage)
> 
> Today we allocate THREAD_SIZE_ORDER for the hard and the soft context,
> so allocating 2 * THREAD_SIZE_ORDER should be sufficient.

Looks good to me.

Now just for clarity, what do we then do with inline sofirq executions: on local_bh_enable()
for example, or explicit calls to do_softirq() other than irq exit?

Should we keep the current switch to a different softirq stack? If we have a generic irq stack
(used for both hard and soft) that is big enough, perhaps we can also switch to this
generic irq stack for inline softirqs executions? After all there is no much point in keeping
a separate stack for that: this result in cache misses if the inline softirq is interrupted by
a hardirq, also inlined softirqs can't happen in hardirq, so there should be no much risk of overruns.

Or am I missing other things?

> 
> Thanks,
> 
> 	tglx
