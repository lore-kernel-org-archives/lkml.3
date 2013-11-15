Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab3KOMdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:33:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51167 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3KOMdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:33:44 -0500
Date: Fri, 15 Nov 2013 13:33:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: perf code using smp_processor_id() in preemptible [00000000] code
Message-ID: <20131115123336.GG10456@twins.programming.kicks-ass.net>
References: <20131115032907.GA25243@redhat.com>
 <20131115100254.GC2965@twins.programming.kicks-ass.net>
 <20131115101946.GG1754@moon>
 <20131115113046.GA26143@moon>
 <20131115115150.GC10456@twins.programming.kicks-ass.net>
 <20131115121051.GC26143@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115121051.GC26143@moon>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 04:10:51PM +0400, Cyrill Gorcunov wrote:
> On Fri, Nov 15, 2013 at 12:51:50PM +0100, Peter Zijlstra wrote:
> > ok, this will make the error go away, but what about the semantics of
> > the case? Does it really matter for the grouping on which cpu we compute
> > it? That is can we end up with a different group for one cpu as for
> > another?
> > 
> > Or do we simply need a coherent single cpu to do the computation with?
> > In which case raw_smp_processor_id() would also suffice.
> > 
> > If we can indeed get a different result depending on which cpu we do the
> > computation, then things are broken, because it might be a task group
> > we're building which has to be able to migrate around with the task.
> 
> The events are sensitive to which cpu they're scheduled to execute on
> (if HT is turned on, we need to setup thread bit in register).
> As far as I understand once events are assigned to cpu_hw_events
> they are executing on this cpu, when tasks are migrated to another
> cpu, they're re-scheduled. Or I miss something obvious here?

No this is correct, but that is simply about event encoding, right?

The situation we should be avoiding is:

 {x, y, z}

being a valid event group on ht0 but an invalid group for ht1.

So the whole fake_cpuc / validate_{event,group} code that triggered this
isn't actually scheduling them, its testing to see if all the provided
events could possibly be scheduled together -- and we would want to
avoid giving a sibling dependent answer here.
