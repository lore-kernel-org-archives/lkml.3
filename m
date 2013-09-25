Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3IYUbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:31:35 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43748 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab3IYUbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:31:34 -0400
Date: Wed, 25 Sep 2013 13:31:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sergey Dyasly <dserrg@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Sha Zhengju <handai.szj@taobao.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] OOM killer: wait for tasks with pending SIGKILL to
 exit
In-Reply-To: <20130911190605.5528ee4563272dbea1ed56a6@gmail.com>
Message-ID: <alpine.DEB.2.02.1309251328130.24412@chino.kir.corp.google.com>
References: <1378740624-2456-1-git-send-email-dserrg@gmail.com> <alpine.DEB.2.02.1309091303010.12523@chino.kir.corp.google.com> <20130911190605.5528ee4563272dbea1ed56a6@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013, Sergey Dyasly wrote:

> > >  		/*
> > >  		 * If this task is not being ptraced on exit, then wait for it
> > >  		 * to finish before killing some other task unnecessarily.
> > >  		 */
> > > -		if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
> > > +		if (!(task->group_leader->ptrace & PT_TRACE_EXIT)) {
> > > +			set_tsk_thread_flag(task, TIF_MEMDIE);
> > 
> > This does not, we do not give access to memory reserves unless the process 
> > needs it to allocate memory.  The task here, which is not current, can 
> > call into the oom killer and be granted memory reserves if necessary.
> 
> True. However, why TIF_MEMDIE is set for PF_EXITING task in oom_kill_process()
> then?

If current needs access to memory reserves while PF_EXITING, it should 
call the page allocator, find that it is out of memory, and call the oom 
killer to silently be granted memory reserves.

> > > @@ -412,16 +415,6 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> > >  	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
> > >  					      DEFAULT_RATELIMIT_BURST);
> > >  
> > > -	/*
> > > -	 * If the task is already exiting, don't alarm the sysadmin or kill
> > > -	 * its children or threads, just set TIF_MEMDIE so it can die quickly
> > > -	 */
> > > -	if (p->flags & PF_EXITING) {
> > > -		set_tsk_thread_flag(p, TIF_MEMDIE);
> > > -		put_task_struct(p);
> > > -		return;
> > > -	}
> > 
> > I think you misunderstood the point of this; if a selected process is 
> > already in the exit path then this is simply avoiding dumping oom kill 
> > lines to the kernel log.  We want to keep doing that.
> 
> This happens in oom_kill_process() after victim has been selected by
> select_bad_process(). But there is already PF_EXITING check in
> oom_scan_process_thread() and in this case OOM code won't call oom_kill_process.

select_bad_process() is one of three callers to oom_kill_process().

> The only difference is in force_kill flag, and the only case where it's set
> is SysRq. And I think in this case OOM killer messages are a good thing to have
> even when victim is already exiting, instead of just silence.
> 

Read the comment about why we don't emit anything to the kernel log in 
this case; the process is already exiting, there's no need to kill it or 
make anyone believe that it was killed.
