Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3JDQwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:52:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51382 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3JDQwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:52:33 -0400
Date: Fri, 4 Oct 2013 18:52:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131004165222.GS3081@twins.programming.kicks-ass.net>
References: <20131003182902.174251532@linux.com>
 <000001417f93fb74-f307f391-26a4-431a-8295-04c5319d1373-000000@email.amazonses.com>
 <20131004082728.GG3081@twins.programming.kicks-ass.net>
 <0000014184145d57-7481d88a-649c-4016-8c59-5da2c822efec-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014184145d57-7481d88a-649c-4016-8c59-5da2c822efec-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 03:27:15PM +0000, Christoph Lameter wrote:
> On Fri, 4 Oct 2013, Peter Zijlstra wrote:
> 
> > > -# define __this_cpu_read(pcp)	__pcpu_size_call_return(__this_cpu_read_, (pcp))
> > > +# define __this_cpu_read(pcp) \
> > > +	(__this_cpu_preempt_check(),__pcpu_size_call_return(__this_cpu_read_, (pcp)))
> > >  #endif
> >
> > Would it not be move convenient to implement it in terms of the
> > raw_this_cpu*() thingies? That way you're sure they actually do the same
> > thing and there's only 1 site to change when changing the
> > implementation.
> 
> The __this_cpu_read_xxx() are asm primitives provided by various arches.
> __this_cpu_read() is currently not overriden by any arches. That is why
> the approach here of replicating only the higher level for raw_cpu_ops
> works. Renaming the __this_cpu_xxx primitives would be a significant
> change.

This isn't about read; this is about all of them. Make sure the raw_*
implementation is the actual real implementation; then implement the
checking variant in terms of those.

> > >  	if (!printk_ratelimit())
> > >  		goto out_enable;
> > >
> > > -	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
> > > -			"code: %s/%d\n",
> > > +	printk(KERN_ERR "%s in preemptible [%08x] "
> > > +			"code: %s/%d\n", what,
> > >  			preempt_count() - 1, current->comm, current->pid);
> >
> > I would argue for keeping the "BUG" string intact and in front of the
> > %s.
> 
> Most of the place that I have seen are not bugs but there was a
> reason for the code to run a __this_cpu op without preemption disabled.

No; it is an actual BUG; it means that whoemever wrote the code didn't
think straight and forgot to use the right primitive and comments.
