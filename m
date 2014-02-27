Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaB0Lqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:46:50 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52398 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbaB0Lqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:46:49 -0500
Date: Thu, 27 Feb 2014 11:46:13 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Dave P Martin <Dave.Martin@arm.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/7] perf: kill perf_event_context_type
Message-ID: <20140227114613.GF6945@e106331-lin.cambridge.arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
 <1392054264-23570-4-git-send-email-mark.rutland@arm.com>
 <20140225113848.GO9987@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225113848.GO9987@twins.programming.kicks-ass.net>
Thread-Topic: [PATCH 3/7] perf: kill perf_event_context_type
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 11:38:48AM +0000, Peter Zijlstra wrote:
> On Mon, Feb 10, 2014 at 05:44:20PM +0000, Mark Rutland wrote:
> > Currently perf_event_context::type is used to determine whether a
> > context is cpu-bound or task-bound. However perf_event_context::task can
> > be used to determine this just as cheaply, and requires no additional
> > initialisation.
> > 
> > This patch removes perf_event_context::type, and modifies existing users
> > to check check perf_event_context::task instead. The now unused enum
> > perf_event_context_type is removed.
> 
> > @@ -7130,7 +7129,7 @@ SYSCALL_DEFINE5(perf_event_open,
> >  		 * task or CPU context:
> >  		 */
> >  		if (move_group) {
> > -			if (group_leader->ctx->type != ctx->type)
> > +			if (group_leader->ctx->task != ctx->task)
> >  				goto err_context;
> >  		} else {
> >  			if (group_leader->ctx != ctx)
> 
> That's not an equivalent statement. ctx->task (t1) != ctx->task (t2)
> while they're still both of the same type.

True. However, that case seems fishy -- if group semantics are respected
a group with events in different tasks should never have any of its
events scheduled and enabled.

For all but the sw leader, hw follower case we reject groups spanning
multiple tasks, and the fact we allow that particular case appears to be
a bug (more on that below).

> Now I don't think you'll ever end up with different tasks in this case
> so it might still work out; but you don't mention this and I'd have to
> like think to make sure.

The short answer is we can, but that itself appears to be a bug. My
patch is not sufficient as it doesn't protect accesses to ctx->task.
Unfortunately even with appropriate locking, we'll race with the context
switch optimisation and may reject sane requests from userspace (as we
currently do in other cases).

Commit b04243ef7006 (perf: Complete software pmu grouping) allowed pure
software groups to be moved into a hardware context by comparing
ctx->type rather than ctx. This dropped the implicit test that ctx->task
is the same across the two events. Thus if a task-following hardware
event is created with a software group leader following another task,
said software event will be pulled across tasks into the hardware
context of the new event's task. This is not the case for any other
hw/sw leader/follower combination as ctx rather than ctx->type is still
compared. Where the ctx comparison fails we return -EINVAL (which we
used to for the sw leader, hw follower case also).

I'll rework my original patch to try to make that behaviour consistent.
However there's another race I'm not sure how to deal with.

Since commit 5a3126d4fe7c (perf: Fix the perf context switch
optimization) creating an event, forking, then creating a follower of
the original event will only succeed if the context switch optimisation
never came into play between the parent and a child, or came into play
multiple times and returned the original context to the parent. This
affects all cases other than the sw leader, hw follower case, where it
is masked by the behaviour above.

Cheers,
Mark.
