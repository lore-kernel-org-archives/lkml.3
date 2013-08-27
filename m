Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3H0MLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:11:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60500 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3H0MLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:11:43 -0400
Date: Tue, 27 Aug 2013 14:11:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
 task->pid and task->tgid
Message-ID: <20130827121133.GD10002@twins.programming.kicks-ass.net>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
 <20130822200555.GN31370@twins.programming.kicks-ass.net>
 <20130822214347.GB21110@madcap2.tricolour.ca>
 <20130823063621.GO31370@twins.programming.kicks-ass.net>
 <20130827023722.GB21098@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827023722.GB21098@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 10:37:22PM -0400, Richard Guy Briggs wrote:
> On Fri, Aug 23, 2013 at 08:36:21AM +0200, Peter Zijlstra wrote:
> > Except that's not the case, with namespaces there's a clear hierarchy
> > and the task_struct::pid is the one true value aka. root namespace.
> 
> Peter, I agonized over the access efficiency of dropping this one or the
> duplicate in task_struct::pids and this one was far easier to drop in
> terms of somehow always forcing
> task->pids[PIDTYPE_PID].pid->numbers[0].nr to point to task->pid.

You mean there's more than 1 site that sets task_struct::pid? I thought
we only assign that thing once in fork.c someplace.

> It should be possible to audit the kernel to make certain task->pid is
> only ever written at the time of task creation and copied to its own
> task->pids[PIDTYPE_PID].pid->numbers[0].nr at the time of task creation
> so that the two values are consistent.  Continuously auditing the kernel
> so this is the case would be a bit more of a challenge.

I know there's people running scripts over git commits to catch abuse,
if this is scriptable that might be doable.

> Would it be reasonable to suggest task_struct::pid only be accessed by
> the existing inlined task_pid_nr() converted to const?

Sure that works for me, alternatively what's wrong with making
task_struct::pid itself a const pid_t ? Then assignment will need an
ugly cast to even work.

> The goal is to gain assurance that any PIDs referred to in audit logs
> are indisputable.
> 
> Would you be alright with doing away with task_struct::tgid?

So I don't particularly use that one much -- if at all. So no I don't
mind it too much.

> > Furthermore idle threads really are special and it doesn't make sense to
> > address them in any but the root namespace, doubly so because only
> > kernel space does this.
> 
> If that is the case, and the above holds true, then we don't need the
> second hunk, I agree.

It should be the case -- not entirely sure it is the case, but in any
case pid-0 should be 'special' by all accounts.

> > As for the init thread, that function is called is_global_init() for
> > crying out loud, what numb nut doesn't get that that's supposed to be
> > using the root namespace?
> 
> A process in another pid namespace?  If that's never going to happen,
> then drop it.

That'd be a bug I suppose, you want the 'global' init when using that
function. I don't use this function, never have. So I really don't know
_that_ much about it. It just seems to me that the name really implies
it wants the root init process and not any other.

> > Seriously, you namespace guys should stop messing things up and
> > confusing yourselves and others.
> 
> "you namespace guys"?  I'm not a namespace guy.  I'm a rusty kernel
> network security guy taking on audit, trying to prepare it for moving
> into a more and more namespace-enabled place of
> containerization/light-virtualization.

Well, you let yourself in with 'those' people ;-)

> We aren't ready for it yet, but there is demand to run additional auditd
> daemons in other pid namespaces and some of this work is trying to move
> in that direction.

So afaict that's 'simply' writing the 'right' pid to your logger, right?
Your additional concern that the pid space isn't corrupted sounds a bit
superfluous to me, we don't typically muck about with pids, stuff would
horribly break if we did that.

There's a few special cases, like the idle threads having pid-0 and
'simple' people like myself prefer to use task_struct::pid for debugging
when we run our simple kernels without all this namespace stuff enabled.

The entire task->pids[PIDTYPE_PID].pid->numbers[0].nr thing just seems
increddibly unwieldy and double dereferences, even if the lines are
'hot' are worse than single derefs.
