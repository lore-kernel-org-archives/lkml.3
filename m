Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283Ab3JPRML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:12:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59640 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761244Ab3JPRMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:12:08 -0400
Date: Wed, 16 Oct 2013 19:11:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20131016171153.GC10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
 <20131015174747.813545438@linux.com>
 <20131016084920.GT10651@twins.programming.kicks-ass.net>
 <00000141c1d04300-e935e477-6669-4388-8109-c77064ee27e7-000000@email.amazonses.com>
 <20131016153603.GZ10651@twins.programming.kicks-ass.net>
 <00000141c1fae3ba-6b52fea1-74f9-42f7-b1db-70dda847e7f9-000000@email.amazonses.com>
 <20131016162537.GB10651@twins.programming.kicks-ass.net>
 <20131016125238.5f970fd5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016125238.5f970fd5@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 12:52:38PM -0400, Steven Rostedt wrote:
> On Wed, 16 Oct 2013 18:25:37 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>  
> > But yes, the way its set-up an arch could indeed provide __this_cup_$op
> > itself -- without providing the _$n variants; in which case the
> > raw_cpu_$op provided by you is broken.
> > 
> > Can't we have a 'simple' coccinelle script rename the entire __this_cpu*
> > implementation over to raw_cpu* and then provide generic __this_cpu* ->
> > raw_cpu maps?
> > 
> 
> Perhaps we should match the way spinlocks are.
> 
> 
> this_cpu*() be the normal use.
> 
> raw_this_cpu() could perhaps not do the checks?
> 
> arch_this_cpu() be the architecture specific version of this_cpu*

In that case we'd need to do something like:

 this_cpu_$op   -> this_cpu_$op_irq (disables irqs itself)
 __this_cpu_$op -> this_cpu_$op     (with check)
 		-> raw_cpu_$op      (without the check)

I don't think the arch bits feature heavily for percpu; normally an arch
provides __this_cpu_$op_$n; raw_cpu_$op_$n in my latest proposal.


Anyway; I don't think the spinlock pattern matches too good and I don't
mind the proposed:

  this_cpu_$op    (disables IRQs itself)
  __this_cpu_$op  (with preemption check)
  raw_cpu_$op	  (without preemption check)


