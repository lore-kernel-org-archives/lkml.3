Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab3HZWIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:08:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab3HZWIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:08:11 -0400
Date: Mon, 26 Aug 2013 18:07:11 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
 task->pid and task->tgid
Message-ID: <20130826220711.GA21098@madcap2.tricolour.ca>
References: <cover.1377032086.git.rgb@redhat.com>
 <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
 <20130822190848.GA25053@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822190848.GA25053@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 09:08:48PM +0200, Oleg Nesterov wrote:
> On 08/20, Richard Guy Briggs wrote:
> >
> >  static inline int is_global_init(struct task_struct *tsk)
> >  {
> > -	return tsk->pid == 1;
> > +	return task_pid_nr(tsk) == 1;
> >  }
> 
> Probably it would be better to simply kill it. Almost every usage is
> wrong.

Can you be more clear?  I don't follow.  It should instead return a
boolean.  Usage of is_global_init() or task_pid_nr()?

If is_global_init(), is that because they could be unaware of pid
namespaces?

If task_pid_nr(), is that for the same reason?

> >  static inline bool is_idle_task(const struct task_struct *p)
> >  {
> > -	return p->pid == 0;
> > +	return task_pid(p) == &init_struct_pid;
> >  }
> 
> hmm. there should be a simpler check for this...

Other than the original, this one is pretty simple.  What did you have
in mind?

> >  static inline int has_group_leader_pid(struct task_struct *p)
> >  {
> > -	return p->pid == p->tgid;
> > +	return task_pid(p) == task_tgid(p);
> >  }
> >  
> >  static inline
> >  int same_thread_group(struct task_struct *p1, struct task_struct *p2)
> >  {
> > -	return p1->tgid == p2->tgid;
> > +	return task_tgid(p1) == task_tgid(p2);
> 
> This is suboptinal. See the attached
> include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
> from -mm below.

I'm fine with that if it is deemed better.  The point was to remove the
dependence on task_struct::tgid.

> Oleg.

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
