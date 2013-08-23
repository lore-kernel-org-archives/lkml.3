Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3HWGga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 02:36:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41635 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab3HWGg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 02:36:29 -0400
Date: Fri, 23 Aug 2013 08:36:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
 task->pid and task->tgid
Message-ID: <20130823063621.GO31370@twins.programming.kicks-ass.net>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
 <20130822200555.GN31370@twins.programming.kicks-ass.net>
 <20130822214347.GB21110@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822214347.GB21110@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 05:43:47PM -0400, Richard Guy Briggs wrote:
> On Thu, Aug 22, 2013 at 10:05:55PM +0200, Peter Zijlstra wrote:
> > On Tue, Aug 20, 2013 at 05:32:03PM -0400, Richard Guy Briggs wrote:
> > > This stops these four task helper functions from using the deprecated and
> > > error-prone task->pid and task->tgid.
> > > 
> > > (informed by ebiederman's ea5a4d01)
> > > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/sched.h |    8 ++++----
> > >  1 files changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > index 8e69807..46e739d 100644
> > > --- a/include/linux/sched.h
> > > +++ b/include/linux/sched.h
> > > @@ -1579,7 +1579,7 @@ static inline int pid_alive(struct task_struct *p)
> > >   */
> > >  static inline int is_global_init(struct task_struct *tsk)
> > >  {
> > > -	return tsk->pid == 1;
> > > +	return task_pid_nr(tsk) == 1;
> > >  }
> > >  
> > >  extern struct pid *cad_pid;
> > > @@ -1930,7 +1930,7 @@ extern struct task_struct *idle_task(int cpu);
> > >   */
> > >  static inline bool is_idle_task(const struct task_struct *p)
> > >  {
> > > -	return p->pid == 0;
> > > +	return task_pid(p) == &init_struct_pid;
> > >  }
> > >  extern struct task_struct *curr_task(int cpu);
> > >  extern void set_curr_task(int cpu, struct task_struct *p);
> > 
> > Why would you ever want to do this? It just makes these tests more
> > expensive for no gain what so ff'ing ever.
> 
> Backups are generally considered a good idea, but in this case, I'd
> quote:
> 	"A man with one watch knows what time it is. A man with two is
> 	never certain."

Except that's not the case, with namespaces there's a clear hierarchy
and the task_struct::pid is the one true value aka. root namespace.

Furthermore idle threads really are special and it doesn't make sense to
address them in any but the root namespace, doubly so because only
kernel space does this.

As for the init thread, that function is called is_global_init() for
crying out loud, what numb nut doesn't get that that's supposed to be
using the root namespace?

Seriously, you namespace guys should stop messing things up and
confusing yourselves and others.
