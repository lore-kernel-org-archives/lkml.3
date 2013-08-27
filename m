Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3H0QWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 12:22:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab3H0QWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 12:22:04 -0400
Date: Tue, 27 Aug 2013 18:15:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
	task->pid and task->tgid
Message-ID: <20130827161536.GA29147@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com> <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com> <20130822190848.GA25053@redhat.com> <20130826220711.GA21098@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826220711.GA21098@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26, Richard Guy Briggs wrote:
>
> On Thu, Aug 22, 2013 at 09:08:48PM +0200, Oleg Nesterov wrote:
> > On 08/20, Richard Guy Briggs wrote:
> > >
> > >  static inline int is_global_init(struct task_struct *tsk)
> > >  {
> > > -	return tsk->pid == 1;
> > > +	return task_pid_nr(tsk) == 1;
> > >  }
> >
> > Probably it would be better to simply kill it. Almost every usage is
> > wrong.
>
> Can you be more clear?  I don't follow.  It should instead return a
> boolean.  Usage of is_global_init() or task_pid_nr()?

Just look at the callers. For example, how is_global_init() can save
/sbin/init from oom-killer if it is multithreaded ?

> If is_global_init(), is that because they could be unaware of pid
> namespaces?

Because I think nobody actually needs is_a_group_leader_of_global_init(),
and this is what this helper actually is.

> > >  static inline bool is_idle_task(const struct task_struct *p)
> > >  {
> > > -	return p->pid == 0;
> > > +	return task_pid(p) == &init_struct_pid;
> > >  }
> >
> > hmm. there should be a simpler check for this...
>
> Other than the original, this one is pretty simple.

I meant that the original check is cheaper,

> What did you have
> in mind?

Well. I agree that it would be nice to avoid the dependence on task->pid
if possible. And perhaps even kill it eventually. But I am not sure how
much we should try.

If it was the last user of ->pid, then I would agree with this change.
Although we can make it cheaper, say, we can change idle_init() to
nullify tasks->next and use ->next == NULL.

But we have a lot more ->pid users, perhaps we should change them first.

And more importantly, let me repeat. I do not think that this change
should be mixed with other changes in this series.

> > >  static inline int has_group_leader_pid(struct task_struct *p)
> > >  {
> > > -	return p->pid == p->tgid;
> > > +	return task_pid(p) == task_tgid(p);
> > >  }
> > >
> > >  static inline
> > >  int same_thread_group(struct task_struct *p1, struct task_struct *p2)
> > >  {
> > > -	return p1->tgid == p2->tgid;
> > > +	return task_tgid(p1) == task_tgid(p2);
> >
> > This is suboptinal. See the attached
> > include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
> > from -mm below.
>
> I'm fine with that if it is deemed better.  The point was to remove the
> dependence on task_struct::tgid.

But I agree! My only point was, this conflicts with the patch we already
have and that patch is more optimal. p1->leader == p2->leader is cheaper.

Oleg.

