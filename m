Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3I0O6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:58:39 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:56164 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3I0O6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:58:37 -0400
Date: Fri, 27 Sep 2013 18:58:33 +0400
From: Sergey Dyasly <dserrg@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Sha Zhengju <handai.szj@taobao.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] OOM killer: wait for tasks with pending SIGKILL to exit
Message-Id: <20130927185833.6c72b77ab105d70d4996ebef@gmail.com>
In-Reply-To: <alpine.DEB.2.02.1309251328130.24412@chino.kir.corp.google.com>
References: <1378740624-2456-1-git-send-email-dserrg@gmail.com>
	<alpine.DEB.2.02.1309091303010.12523@chino.kir.corp.google.com>
	<20130911190605.5528ee4563272dbea1ed56a6@gmail.com>
	<alpine.DEB.2.02.1309251328130.24412@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 13:31:32 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 11 Sep 2013, Sergey Dyasly wrote:
> 
> > > >  		/*
> > > >  		 * If this task is not being ptraced on exit, then wait for it
> > > >  		 * to finish before killing some other task unnecessarily.
> > > >  		 */
> > > > -		if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
> > > > +		if (!(task->group_leader->ptrace & PT_TRACE_EXIT)) {
> > > > +			set_tsk_thread_flag(task, TIF_MEMDIE);
> > > 
> > > This does not, we do not give access to memory reserves unless the process 
> > > needs it to allocate memory.  The task here, which is not current, can 
> > > call into the oom killer and be granted memory reserves if necessary.
> > 
> > True. However, why TIF_MEMDIE is set for PF_EXITING task in oom_kill_process()
> > then?
> 
> If current needs access to memory reserves while PF_EXITING, it should 
> call the page allocator, find that it is out of memory, and call the oom 
> killer to silently be granted memory reserves.

I understand this and you are repeating yourself :)
What you are saying contradicts current OOMk code the way I read it. Comment in
oom_kill_process() says:

"If the task is already exiting ... set TIF_MEMDIE so it can die quickly"

I just want to know the right solution.

> > > > @@ -412,16 +415,6 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> > > >  	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
> > > >  					      DEFAULT_RATELIMIT_BURST);
> > > >  
> > > > -	/*
> > > > -	 * If the task is already exiting, don't alarm the sysadmin or kill
> > > > -	 * its children or threads, just set TIF_MEMDIE so it can die quickly
> > > > -	 */
> > > > -	if (p->flags & PF_EXITING) {
> > > > -		set_tsk_thread_flag(p, TIF_MEMDIE);
> > > > -		put_task_struct(p);
> > > > -		return;
> > > > -	}
> > > 
> > > I think you misunderstood the point of this; if a selected process is 
> > > already in the exit path then this is simply avoiding dumping oom kill 
> > > lines to the kernel log.  We want to keep doing that.
> > 
> > This happens in oom_kill_process() after victim has been selected by
> > select_bad_process(). But there is already PF_EXITING check in
> > oom_scan_process_thread() and in this case OOM code won't call oom_kill_process.
> 
> select_bad_process() is one of three callers to oom_kill_process().

You are mistaken, oom_kill_process() is only called from out_of_memory()
and mem_cgroup_out_of_memory().

> > The only difference is in force_kill flag, and the only case where it's set
> > is SysRq. And I think in this case OOM killer messages are a good thing to have
> > even when victim is already exiting, instead of just silence.
> > 
> 
> Read the comment about why we don't emit anything to the kernel log in 
> this case; the process is already exiting, there's no need to kill it or 
> make anyone believe that it was killed.

Yes, but there is already the PF_EXITING check in oom_scan_process_thread(),
and in this case oom_kill_process() won't be even called. That's why it's
redundant.

--
Sergey Dyasly <dserrg@gmail.com>
