Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab3LQPjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:39:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab3LQPjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:39:31 -0500
Date: Tue, 17 Dec 2013 16:40:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] pid: change task_struct::pid to read-only
Message-ID: <20131217154004.GA21656@redhat.com>
References: <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com> <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com> <20131217153611.GA18321@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217153611.GA18321@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17, Oleg Nesterov wrote:
>
> On 12/16, Richard Guy Briggs wrote:
> >
> > task->pid is only ever assigned once (well ok, twice).  For system health and
> > secure logging confidence, make it const to make it much more intentional when
> > it is being changed.
>
> Hmm. I am a bit suprized you decided to constify task->pid, but OK.
>
> And we can do the same with task->signal, this can actually help to generate
> a better code, probably.
>
> >  	if (!thread_group_leader(tsk)) {
> >  		struct task_struct *leader = tsk->group_leader;
> > +		/* tast_struct::pid is const pid_t, hence the ugly cast */
> > +		pid_t *pid_p = (pid_t*)&(tsk->pid);
> >
> >  		sig->notify_count = -1;	/* for exit_notify() */
> >  		for (;;) {
> > @@ -950,7 +952,7 @@ static int de_thread(struct task_struct *tsk)
> >  		 * Note: The old leader also uses this pid until release_task
> >  		 *       is called.  Odd but simple and correct.
> >  		 */
> > -		tsk->pid = leader->pid;
> > +		*pid_p = leader->pid;
>
> Well, imho this (and de_thread) looks a bit ugly. Perhaps we should add
> something like
>
> 	#define ASSIGN_CONST(l, r)      (*(typeof(r) *)&(l) = (r))
>
> into compiler.h ?

Or even

	#define ASSIGN_CONST(l, r)      \
	        ({ BUILD_BUG_ON(sizeof(l) != sizeof(r)); *(typeof(r) *)&(l) = (r); })

perhaps it will have more users.

Oleg.

