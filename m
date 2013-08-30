Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3H3T5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:57:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab3H3T5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:57:23 -0400
Date: Fri, 30 Aug 2013 15:56:46 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>
Subject: Re: [PATCH 03/12] pid: get ppid pid_t of task in init_pid_ns safely
Message-ID: <20130830195646.GJ21110@madcap2.tricolour.ca>
References: <cover.1377032086.git.rgb@redhat.com>
 <a411b87ba4c4af251166ee5877cb8c646cf7826c.1377032086.git.rgb@redhat.com>
 <20130827172155.GC29147@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827172155.GC29147@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 07:21:55PM +0200, Oleg Nesterov wrote:
> On 08/20, Richard Guy Briggs wrote:
> >
> > Added the functions
> >         task_ppid()
> >         task_ppid_nr_ns()
> >         task_ppid_nr_init_ns()
> > to safely abstract the lookup of the PPID
> 
> but it is not safe.
> 
> > +static inline struct pid *task_ppid(struct task_struct *task)
> > +{
> > +	return task_tgid(rcu_dereference(current->real_parent));
>                                          ^^^^^^^
> task?

Yup, thanks for those two catches.

> > +	rcu_read_unlock();
> 
> And why this is safe?
> 
> rcu_read_lock() can't help if tsk was already dead _before_ it takes
> the rcu lock. ->real_parent can point the already freed/reused/unmapped
> memory.

Does it not bump a refcount if it is holding a pointer to it?  So the
parent task might be dead, but it won't cause a pointer dereference
issue.

> This is safe if, for example, the caller alredy holds rcu_read_lock()
> and tsk was found by find_task_by*(), or tsk is current.

Fair enough, I'll have a more careful look at this.  Thanks.

Most of the instances are current, but the one called from apparmour is
stored.  I've just learned that this is bad and someone else just chimed
in that they have a patch to remove it...

So what is a reliable way of keeping a reference to a task?  I had
assumed that the best way was to keep a pointer to its task_struct,
making sure its refcount had been bumped by something like
get_task_struct().  Another way would be to do the same with its struct
pid.  The third that I'm trying to avoid is using its init_pid_namespace
pid_t since it could refer to a completely different task if the pid_t
rolls over.

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
