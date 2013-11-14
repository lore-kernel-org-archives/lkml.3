Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3KNPdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:33:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57344 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3KNPdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:33:12 -0500
Date: Thu, 14 Nov 2013 16:33:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>, masami.hiramatsu.pt@hitachi.com
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131114153301.GD5364@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109151014.GN16117@laptop.programming.kicks-ass.net>
 <20131114152304.GC5364@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114152304.GC5364@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 04:23:04PM +0100, Peter Zijlstra wrote:
>  /*
> + * We must dis-allow sampling irq_work_exit() because perf event sampling
> + * itself can cause irq_work, which would lead to an infinite loop;
> + *
> + *  1) irq_work_exit happens
> + *  2) generates perf sample
> + *  3) generates irq_work
> + *  4) goto 1
> + */
> +TRACE_EVENT_PERF_PERM(irq_work_exit, is_sampling_event(p_event) ? -EPERM : 0);

And the only reason this doesn't feed fwd itself into oblivion for
irq_work_enter() is because the irq_work_list must not be empty when the
interrupt is raised, and queueing further work does not re-raise the
IPI.


Also, we should probably do something 'smart' for kprobes, as all of
irq_work.c and plenty of perf itself is not __kprobe marked so you're
all free to insert kprobes in the middle of perf and then attach perf to
such a thing.

