Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3H1IQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:16:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56223 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3H1IQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:16:37 -0400
Date: Wed, 28 Aug 2013 10:16:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Richard Guy Briggs <rgb@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
 task->pid and task->tgid
Message-ID: <20130828081631.GG10002@twins.programming.kicks-ass.net>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
 <20130822200555.GN31370@twins.programming.kicks-ass.net>
 <20130822214347.GB21110@madcap2.tricolour.ca>
 <20130823063621.GO31370@twins.programming.kicks-ass.net>
 <20130827023722.GB21098@madcap2.tricolour.ca>
 <20130827121133.GD10002@twins.programming.kicks-ass.net>
 <87ob8ihl68.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob8ihl68.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 02:35:11PM -0700, Eric W. Biederman wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Mon, Aug 26, 2013 at 10:37:22PM -0400, Richard Guy Briggs wrote:
> >> On Fri, Aug 23, 2013 at 08:36:21AM +0200, Peter Zijlstra wrote:
> >> > Except that's not the case, with namespaces there's a clear hierarchy
> >> > and the task_struct::pid is the one true value aka. root namespace.
> >> 
> >> Peter, I agonized over the access efficiency of dropping this one or the
> >> duplicate in task_struct::pids and this one was far easier to drop in
> >> terms of somehow always forcing
> >> task->pids[PIDTYPE_PID].pid->numbers[0].nr to point to task->pid.
> >
> > You mean there's more than 1 site that sets task_struct::pid? I thought
> > we only assign that thing once in fork.c someplace.
> 
> No there is not and that is not a concern.
> 
> Now I had thought given how the perf subsystem was constructed that only
> the god like root was even allowed to use the code.  But it turns out
> there is sysctl_perf_event_paranoid that can bet twiddled that in some
> circumstance that unprivileged users are allowed to use perf.  

Even without poking at that, a user is always allowed to use perf on his
own tasks.

> Which
> ultimately means perf will return the wrong data.

How so, perf uses pid-namespaces, have a look at
kernel/events/core.c:perf_event_[pt]id(). We store the namespace of the
task creating the event (which is also -- hopefully -- the consumer of
the data it generates). If you create an event and then switch
namespaces you've bigger issues I suppose.

> Meaning that perf is broken by design and perf has no excuse to be using
> task->pid.

It doesn't.

> Similarly every other place in the kernel that has made the
> same mistake.  I mention perf explicitly for two reasons.  perf gets the
> namespace handling horribly wrong, 

Do tell.

> perf is the only place in the kernel
> where we are accessing pids frequently enough for an extra cache line
> miss to be a concern.
> 
> When really pids in the kernel what we care about is not some stupid
> number but the stuct pid which points to that tasks, process groups, and
> sessions.  You know the object that a pid is the name for.
> 
> So yes as a long term direction task->pid and task->tgid need to be
> killed because we keep getting subsystems like perf that return the
> wrong data to userspace, or perform the wrong checks, because the
> current structure makes it seem like it is ok to do the wrong thing.

I think you should have a look at code before you start raving.. makes
you looks silly.
