Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3FGKvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:51:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab3FGKvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:51:00 -0400
Date: Fri, 7 Jun 2013 12:46:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        John Johansen <john.johansen@canonical.com>
Subject: Re: [ 020/184] ptrace: ensure arch_ptrace/ptrace_request can never
Message-ID: <20130607104640.GA30017@redhat.com>
References: <20130604172131.136042108@1wt.eu> <87sj0wucft.fsf@canonical.com> <20130605154051.GA23025@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605154051.GA23025@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05, Oleg Nesterov wrote:
>
> On 06/05, Luis Henriques wrote:
> >
> >  /* Ensure that nothing can wake it up, even SIGKILL */
> > -static bool ptrace_freeze_traced(struct task_struct *task)
> > +static bool ptrace_freeze_traced(struct task_struct *task, int kill)
> >  {
> > -	bool ret = false;
> > +	bool ret = true;
> >  
> >  	spin_lock_irq(&task->sighand->siglock);
> > -	if (task_is_traced(task) && !__fatal_signal_pending(task)) {
> > +	if (task_is_stopped(task) && !__fatal_signal_pending(task))
> >  		task->state = __TASK_TRACED;
> > -		ret = true;
> > +	else if (!kill) {
> > +		if (task_is_traced(task) && !__fatal_signal_pending(task))
> > +			task->state = __TASK_TRACED;
> > +		else
> > +			ret = false;
> >  	}
> >  	spin_unlock_irq(&task->sighand->siglock);
> >  
> > @@ -131,7 +135,7 @@ int ptrace_check_attach(struct task_struct *child, int kill)
> >  		 * child->sighand can't be NULL, release_task()
> >  		 * does ptrace_unlink() before __exit_signal().
> >  		 */
> > -		if (kill || ptrace_freeze_traced(child))
> > +		if (ptrace_freeze_traced(child, kill))
> >  			ret = 0;
> 
> I can't apply this patch, probably I misread it...
> 
> But it looks very wrong. It seems that ptrace_freeze_traced(kill => true)
> always succeeds? Even if task is TASK_RUNNING/UNINTERRUPTIBLE/etc ?

I am sorry for noise!

Yes I misread the patch. Now I actually applied both patches and
I believe the fix is fine.

ptrace_freeze_traced(kill => true) succeeds, but this is correct.
Somehow I confused this case with !kill.

Oleg.

