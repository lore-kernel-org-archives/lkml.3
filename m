Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab3LTUUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 15:20:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab3LTUUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 15:20:06 -0500
Date: Fri, 20 Dec 2013 15:19:31 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] pid: change task_struct::pid to read-only
Message-ID: <20131220201931.GA22905@madcap2.tricolour.ca>
References: <8aa73d2b884439496f87d5f34c12ba9b4b40f7e5.1377032086.git.rgb@redhat.com>
 <ae3d74e79649d9e4962d0da030fb4852ddc5b8d1.1387227114.git.rgb@redhat.com>
 <20131217153611.GA18321@redhat.com>
 <20131217154004.GA21656@redhat.com>
 <20131220190157.GA1452@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220190157.GA1452@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/20, Oleg Nesterov wrote:
> Richard, Peter,

Oleg,

> sorry I deleted your emails by accident, so I am replying to my email.

That's ok, you could send yourself a new copy from the "forward" link
here:
	https://lkml.org/lkml/2013/12/20/277
	
> Sure, ASSIGN_CONST() looks "dangerous". Still to me it is safer than
> "(pid_t*)&(tsk->pid)" done by hand. And yes, it is visible to grep.
> 
> But the main point, it is much more readable. Just look at the change
> below,

I completely agree it is more readable and safer, if it works.

> On 12/17, Oleg Nesterov wrote:
> > > >  	if (!thread_group_leader(tsk)) {
> > > >  		struct task_struct *leader = tsk->group_leader;
> > > > +		/* tast_struct::pid is const pid_t, hence the ugly cast */
> > > > +		pid_t *pid_p = (pid_t*)&(tsk->pid);
> > > >
> > > >  		sig->notify_count = -1;	/* for exit_notify() */
> > > >  		for (;;) {
> > > > @@ -950,7 +952,7 @@ static int de_thread(struct task_struct *tsk)
> > > >  		 * Note: The old leader also uses this pid until release_task
> > > >  		 *       is called.  Odd but simple and correct.
> > > >  		 */
> > > > -		tsk->pid = leader->pid;
> > > > +		*pid_p = leader->pid;
> 
> Isn't it ugly to add the temporary? And this temporary is the pointer.
> ASSIGN_CONST(task->pid, leader->pid) is self-documenting and clear.
> 
> The only problem is that
> 
> 	#define ASSIGN_CONST(l, r)      (*(typeof(r) *)&(l) = (r))
> 
> obviously can't work in this case ;) We need something more clever.

Go for it.  I'll just stick with what I found works.  I gave it a shot
to do it in one step and failed.  I moved on.

> Oleg.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
