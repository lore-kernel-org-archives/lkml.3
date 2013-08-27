Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab3H0Chz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 22:37:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab3H0Chy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 22:37:54 -0400
Date: Mon, 26 Aug 2013 22:37:22 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
 task->pid and task->tgid
Message-ID: <20130827023722.GB21098@madcap2.tricolour.ca>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
 <20130822200555.GN31370@twins.programming.kicks-ass.net>
 <20130822214347.GB21110@madcap2.tricolour.ca>
 <20130823063621.GO31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823063621.GO31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 08:36:21AM +0200, Peter Zijlstra wrote:
> On Thu, Aug 22, 2013 at 05:43:47PM -0400, Richard Guy Briggs wrote:
> > On Thu, Aug 22, 2013 at 10:05:55PM +0200, Peter Zijlstra wrote:
> > > On Tue, Aug 20, 2013 at 05:32:03PM -0400, Richard Guy Briggs wrote:
> > > > This stops these four task helper functions from using the deprecated and
> > > > error-prone task->pid and task->tgid.
> > > > 
> > > > (informed by ebiederman's ea5a4d01)
> > > > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > ---
> > > >  include/linux/sched.h |    8 ++++----
> > > >  1 files changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > > index 8e69807..46e739d 100644
> > > > --- a/include/linux/sched.h
> > > > +++ b/include/linux/sched.h
> > > > @@ -1579,7 +1579,7 @@ static inline int pid_alive(struct task_struct *p)
> > > >   */
> > > >  static inline int is_global_init(struct task_struct *tsk)
> > > >  {
> > > > -	return tsk->pid == 1;
> > > > +	return task_pid_nr(tsk) == 1;
> > > >  }
> > > >  
> > > >  extern struct pid *cad_pid;
> > > > @@ -1930,7 +1930,7 @@ extern struct task_struct *idle_task(int cpu);
> > > >   */
> > > >  static inline bool is_idle_task(const struct task_struct *p)
> > > >  {
> > > > -	return p->pid == 0;
> > > > +	return task_pid(p) == &init_struct_pid;
> > > >  }
> > > >  extern struct task_struct *curr_task(int cpu);
> > > >  extern void set_curr_task(int cpu, struct task_struct *p);
> > > 
> > > Why would you ever want to do this? It just makes these tests more
> > > expensive for no gain what so ff'ing ever.
> > 
> > Backups are generally considered a good idea, but in this case, I'd
> > quote:
> > 	"A man with one watch knows what time it is. A man with two is
> > 	never certain."
> 
> Except that's not the case, with namespaces there's a clear hierarchy
> and the task_struct::pid is the one true value aka. root namespace.

Peter, I agonized over the access efficiency of dropping this one or the
duplicate in task_struct::pids and this one was far easier to drop in
terms of somehow always forcing
task->pids[PIDTYPE_PID].pid->numbers[0].nr to point to task->pid.

It should be possible to audit the kernel to make certain task->pid is
only ever written at the time of task creation and copied to its own
task->pids[PIDTYPE_PID].pid->numbers[0].nr at the time of task creation
so that the two values are consistent.  Continuously auditing the kernel
so this is the case would be a bit more of a challenge.

Would it be reasonable to suggest task_struct::pid only be accessed by
the existing inlined task_pid_nr() converted to const?

The goal is to gain assurance that any PIDs referred to in audit logs
are indisputable.

Would you be alright with doing away with task_struct::tgid?

> Furthermore idle threads really are special and it doesn't make sense to
> address them in any but the root namespace, doubly so because only
> kernel space does this.

If that is the case, and the above holds true, then we don't need the
second hunk, I agree.

> As for the init thread, that function is called is_global_init() for
> crying out loud, what numb nut doesn't get that that's supposed to be
> using the root namespace?

A process in another pid namespace?  If that's never going to happen,
then drop it.

> Seriously, you namespace guys should stop messing things up and
> confusing yourselves and others.

"you namespace guys"?  I'm not a namespace guy.  I'm a rusty kernel
network security guy taking on audit, trying to prepare it for moving
into a more and more namespace-enabled place of
containerization/light-virtualization.

We aren't ready for it yet, but there is demand to run additional auditd
daemons in other pid namespaces and some of this work is trying to move
in that direction.

This patchset certainly wasn't intended to be ready for adoption just
yet.  It was this sort of discussion I was hoping to have.


- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
