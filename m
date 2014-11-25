Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaKYQ57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:57:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbaKYQ55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:57:57 -0500
Date: Tue, 25 Nov 2014 17:57:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] exit: reparent: fix/update the comments in
	zap_pid_ns_processes()
Message-ID: <20141125165745.GB28913@redhat.com>
References: <20141124200626.GA21006@redhat.com> <874mtodzhd.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874mtodzhd.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > The comments in zap_pid_ns_processes() are simply wrong, we need
> > to explain how this code actually works.
> >
> > 1. "Ignore SIGCHLD" looks like optimization but it is not, we also
> >    need this for correctness.
> >
> > 2. The comment above sys_wait4() could be more clear.
> >
> > 3. The comment about TASK_DEAD children is outdated. Contrary to
> >    what it says we do not need to make sure they all go away.
>
> We absolutely do need to wait until they all go away.

I can easily miss something, and that is why I asked you to review this
change. But if I missed something, perhaps we should update the comments?

This "wait until TASK_DEAD children" loop was added to ensure that
child_reaper can't be reaped before other tasks in this pid namespace.
6347e90091041e "pidns: guarantee that the pidns init will be the last pidns
process reaped".

But this was needed because proc_flush_task(pid == 1) called
kern_unmount(proc_mnt). After 0a01f2cc390e10633 "pidns: Make the pidns
proc mount/umount logic obvious" we can rely on schedule_work() in
free_pid(nr_hashed == 0).

So in any case I think that the current comment is outdated.


> - rusage will be wrong if we don't wait.

I already answered in 0/2, let me quote myself:

	Do you mean cstime/cutime/c* accounting?

	Firstly it is not clear what makes child_reaper special in _this_ sense, but
	this doesn't matter at all.

	The auotoreaping/EXIT_DEAD children are not accounted, only wait_task_zombie()
	accumulates these counters. (just in case, accounting in __exit_signal() is
	another thing).


> - We won't wait for an injected process in a pid namespace,
>   or a processes debugged with gdb to be reaped before the pid
>   init process exits if we don't wait.

Yes, and I do not see why this is bad, but this is off-topic.

Again, lets discuss this in another thread. This patch doesn't try to
document the desired semantics, it only tries to explain why zap_pid_ns
_has_ to wait until EXIT_DEAD (and in fact EXIT_ZOMBIE) tasks go away.


> The user visible semantics go from weird to completely insane if we
> relax the rule that the init process is the last process in a pid
> namespace.
>
> I don't see anything approaching a good reason for changing the user
> space semantics.

See above.

> > @@ -190,7 +190,11 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
> >  	/* Don't allow any more processes into the pid namespace */
> >  	disable_pid_allocation(pid_ns);
>
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> The above line disables injections of new processes in this pid
> namespace.

Yes, sure. See below.

> > -	/* Ignore SIGCHLD causing any terminated children to autoreap */
> > +	/*
> > +	 * Ignore SIGCHLD causing any terminated children to autoreap.
> > +	 * This speeds up the namespace shutdown, plus see the comment
> > +	 * below.
> > +	 */
>
> 	This speeds up the namespace shutdown and ensures that after we
> 	have waited for all existing zombies there will be no more
> 	zombies to wait for.

Afaics, no, see below.

> > -	 * sys_wait4() above can't reap the TASK_DEAD children.
> > -	 * Make sure they all go away, see free_pid().
> > +	 * sys_wait4() above can't reap the TASK_DEAD children but we do not
> > +	 * really care, we could reparent them to the global init.
>
> We do care.

See above. I only meant that nothing bad can happen from the kernel
perspective.

> > +	 * But this namespace can also have other tasks injected by setns().
> > +	 * Again, we do not really need to wait until they are all reaped,
>
> We do, and setns does not matter here.  Injection was stopped way up above.

I think that setns() does matter.

Yes injection was stopped. But a task T can be already injected before
disable_pid_allocation() was called.

Now it is killed (or it could even exit before). To simplify, suppose it
is already EXIT_ZOMBIE, although this doesn't really matter.

The sys_wait4() loop can't see it, it is not our child.

Now suppose that its parent doesn't do wait() but exits. This means that
the exiting parent will try to reparent T to pid_ns->child_reaper.

child_reaper already sleeps in "wait for nr_hashed == init_pids" loop, it
can do nothing with T.

So we rely on autoreaping (forced by ignored SIGCHLD), and this is the
(technical) reason why child_reaper can't exit: pid_ns->child_reaper should
be valid.

No?

> > +	 * We rely on ignored SIGCHLD, an injected zombie must be autoreaped
> > +	 * if reparented.
>
> Your new comment is about 90% wrong.

See above.

Eric. I'd really ask you to take another look. But in any case: thanks for
looking at this.

Oleg.

