Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaAWEAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 23:00:32 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:16428 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752213AbaAWEAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 23:00:31 -0500
Date: Wed, 22 Jan 2014 23:00:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing: Use task_nice() in function __update_max_tr()
 to get the nice value of task.
Message-ID: <20140122230029.638e9a53@gandalf.local.home>
In-Reply-To: <20140122225632.73c2fbdf@gandalf.local.home>
References: <1390430505-17234-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140122225632.73c2fbdf@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014 22:56:32 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 22 Jan 2014 17:41:45 -0500
> Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:
> 
> > There is already a function named task_nice in sched.h to get the nice value
> > of task_struct. We can use it in __update_max_tr() rather than calculate it
> > manually.
> > 
> > Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> > ---
> >  kernel/trace/trace.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 9d20cd9..ec149b4 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -970,7 +970,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
> >  	else
> >  		max_data->uid = task_uid(tsk);
> >  
> > -	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
> > +	max_data->nice = task_nice(tsk);
> 
> Except that's a function call in a critical path. Switch it to
> TASK_NICE(), and I'll take the patch.

Bah, I just noticed that TASK_NICE is in kernel/sched/sched.h not
include/linux/sched.h

Peter, is there a reason that task_nice() is not a static inline in
sched.h and have these macros there too? They only reference fields in
task_struct that are already defined there. I don't see why they need
to be private to kernel/sched.

-- Steve

> 
> Thanks,
> 
> -- Steve
> 
> >  	max_data->policy = tsk->policy;
> >  	max_data->rt_priority = tsk->rt_priority;
> >  
> 

