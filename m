Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3JDP1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:27:17 -0400
Received: from a194-110.smtp-out.amazonses.com ([199.255.194.110]:46149 "EHLO
	a194-110.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316Ab3JDP1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:27:16 -0400
Date: Fri, 4 Oct 2013 15:27:15 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [pchecks v2 2/2] percpu: Add preemption checks to __this_cpu
 ops
In-Reply-To: <20131004082728.GG3081@twins.programming.kicks-ass.net>
Message-ID: <0000014184145d57-7481d88a-649c-4016-8c59-5da2c822efec-000000@email.amazonses.com>
References: <20131003182902.174251532@linux.com> <000001417f93fb74-f307f391-26a4-431a-8295-04c5319d1373-000000@email.amazonses.com> <20131004082728.GG3081@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Oct 2013, Peter Zijlstra wrote:

> > -# define __this_cpu_read(pcp)	__pcpu_size_call_return(__this_cpu_read_, (pcp))
> > +# define __this_cpu_read(pcp) \
> > +	(__this_cpu_preempt_check(),__pcpu_size_call_return(__this_cpu_read_, (pcp)))
> >  #endif
>
> Would it not be move convenient to implement it in terms of the
> raw_this_cpu*() thingies? That way you're sure they actually do the same
> thing and there's only 1 site to change when changing the
> implementation.

The __this_cpu_read_xxx() are asm primitives provided by various arches.
__this_cpu_read() is currently not overriden by any arches. That is why
the approach here of replicating only the higher level for raw_cpu_ops
works. Renaming the __this_cpu_xxx primitives would be a significant
change.

> >  	if (!printk_ratelimit())
> >  		goto out_enable;
> >
> > -	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
> > -			"code: %s/%d\n",
> > +	printk(KERN_ERR "%s in preemptible [%08x] "
> > +			"code: %s/%d\n", what,
> >  			preempt_count() - 1, current->comm, current->pid);
>
> I would argue for keeping the "BUG" string intact and in front of the
> %s.

Most of the place that I have seen are not bugs but there was a
reason for the code to run a __this_cpu op without preemption disabled.
