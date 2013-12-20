Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3LTTBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:01:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab3LTTBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:01:35 -0500
Date: Fri, 20 Dec 2013 20:01:57 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] pid: change task_struct::pid to read-only
Message-ID: <20131220190157.GA1452@redhat.com>
References: <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com> <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com> <20131217153611.GA18321@redhat.com> <20131217154004.GA21656@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217154004.GA21656@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard, Peter,

sorry I deleted your emails by accident, so I am replying to my email.

Sure, ASSIGN_CONST() looks "dangerous". Still to me it is safer than
"(pid_t*)&(tsk->pid)" done by hand. And yes, it is visible to grep.

But the main point, it is much more readable. Just look at the change
below,

On 12/17, Oleg Nesterov wrote:
>
> > >  	if (!thread_group_leader(tsk)) {
> > >  		struct task_struct *leader = tsk->group_leader;
> > > +		/* tast_struct::pid is const pid_t, hence the ugly cast */
> > > +		pid_t *pid_p = (pid_t*)&(tsk->pid);
> > >
> > >  		sig->notify_count = -1;	/* for exit_notify() */
> > >  		for (;;) {
> > > @@ -950,7 +952,7 @@ static int de_thread(struct task_struct *tsk)
> > >  		 * Note: The old leader also uses this pid until release_task
> > >  		 *       is called.  Odd but simple and correct.
> > >  		 */
> > > -		tsk->pid = leader->pid;
> > > +		*pid_p = leader->pid;

Isn't it ugly to add the temporary? And this temporary is the pointer.
ASSIGN_CONST(task->pid, leader->pid) is self-documenting and clear.

The only problem is that

	#define ASSIGN_CONST(l, r)      (*(typeof(r) *)&(l) = (r))

obviously can't work in this case ;) We need something more clever.

Oleg.

