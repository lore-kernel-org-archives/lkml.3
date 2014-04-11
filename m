Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbaDKPXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 11:23:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:39693 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754045AbaDKPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:23:08 -0400
Date: Fri, 11 Apr 2014 11:22:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RESEND 1/2] tracing: syscall_*regfunc() can race with
 copy_process()
Message-ID: <20140411112259.79f0a0ba@gandalf.local.home>
In-Reply-To: <20140410133435.GB12228@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
	<1397059882-23063-3-git-send-email-fweisbec@gmail.com>
	<360091921.1294.1397060915052.JavaMail.zimbra@efficios.com>
	<20140409124249.4081e665@gandalf.local.home>
	<20140409170505.GA27638@redhat.com>
	<20140409170542.GB27638@redhat.com>
	<20140410090643.46ca2226@gandalf.local.home>
	<20140410133435.GB12228@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 15:34:35 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/10, Steven Rostedt wrote:
> >
> > On Wed, 9 Apr 2014 19:05:42 +0200
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > --- a/kernel/fork.c
> > > +++ b/kernel/fork.c
> > > @@ -1472,7 +1472,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> > >
> > >  	total_forks++;
> > >  	spin_unlock(&current->sighand->siglock);
> > > +	syscall_tracepoint_update(p);
> > >  	write_unlock_irq(&tasklist_lock);
> > > +
> >
> > So this looks to be a fix that probably should go to stable?
> 
> Not sure, this is up to you.

I'll have to think about this one, whether or not it should go to
stable.

> 
> > > @@ -732,33 +732,31 @@ static int sys_tracepoint_refcount;
> > >
> > >  void syscall_regfunc(void)
> > >  {
> > > -	unsigned long flags;
> > >  	struct task_struct *g, *t;
> > >
> > >  	if (!sys_tracepoint_refcount) {
> > > -		read_lock_irqsave(&tasklist_lock, flags);
> > > +		read_lock(&tasklist_lock);
> > >  		do_each_thread(g, t) {
> > >  			/* Skip kernel threads. */
> > > -			if (t->mm)
> > > +			if (!(t->flags & PF_KTHREAD))
> > >  				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
> > >  		} while_each_thread(g, t);
> > > -		read_unlock_irqrestore(&tasklist_lock, flags);
> > > +		read_unlock(&tasklist_lock);
> > >  	}
> > >  	sys_tracepoint_refcount++;
> > >  }
> > >
> > >  void syscall_unregfunc(void)
> > >  {
> > > -	unsigned long flags;
> > >  	struct task_struct *g, *t;
> > >
> > >  	sys_tracepoint_refcount--;
> > >  	if (!sys_tracepoint_refcount) {
> > > -		read_lock_irqsave(&tasklist_lock, flags);
> > > +		read_lock(&tasklist_lock);
> > >  		do_each_thread(g, t) {
> > >  			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
> > >  		} while_each_thread(g, t);
> > > -		read_unlock_irqrestore(&tasklist_lock, flags);
> > > +		read_unlock(&tasklist_lock);
> >
> > These changes should be in a separate patch, as they can wait till 3.16.
> 
> OK, I'll split this change.

Are you going to send a new series?

-- Steve

