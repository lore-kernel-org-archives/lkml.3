Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaLCV6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:58:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaLCV6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:58:12 -0500
Date: Wed, 3 Dec 2014 13:58:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] oom: don't assume that a coredumping thread will
 exit soon
Message-Id: <20141203135810.d7e9d4f5e93e3087717e452d@linux-foundation.org>
In-Reply-To: <20141203195020.GB11558@redhat.com>
References: <20141127230349.GA25075@redhat.com>
	<20141203195001.GA11558@redhat.com>
	<20141203195020.GB11558@redhat.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014 20:50:20 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> oom_kill.c assumes that PF_EXITING task should exit and free the memory
> soon. This is wrong in many ways and one important case is the coredump.
> A task can sleep in exit_mm() "forever" while the coredumping sub-thread
> can need more memory.
> 
> Change the PF_EXITING checks to take SIGNAL_GROUP_COREDUMP into account,
> we add the new trivial helper for that.
> 
> Note: this is only the first step, this patch doesn't try to solve other
> problems. The SIGNAL_GROUP_COREDUMP check is obviously racy, a task can
> participate in coredump after it was already observed in PF_EXITING state,
> so TIF_MEMDIE (which also blocks oom-killer) still can be wrongly set.
> fatal_signal_pending() can be true because of SIGNAL_GROUP_COREDUMP so
> out_of_memory() and mem_cgroup_out_of_memory() shouldn't blindly trust it.
> And even the name/usage of the new helper is confusing, an exiting thread
> can only free its ->mm if it is the only/last task in thread group.
> 
> ...
>
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -92,6 +92,12 @@ static inline bool oom_gfp_allowed(gfp_t gfp_mask)
>  
>  extern struct task_struct *find_lock_task_mm(struct task_struct *p);
>  
> +static inline bool task_will_free_mem(struct task_struct *task)
> +{
> +	return (task->flags & PF_EXITING) &&
> +		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
> +}

The SIGNAL_GROUP_COREDUMP test is utterly obscure.  Let's help our poor
readers?

--- a/include/linux/oom.h~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2-fix
+++ a/include/linux/oom.h
@@ -89,6 +89,11 @@ extern struct task_struct *find_lock_tas
 
 static inline bool task_will_free_mem(struct task_struct *task)
 {
+	/*
+	 * A coredumping process may sleep for extended periods in exit_mm(), so
+	 * the oom killer cannot assume that the process will promptly exit and
+	 * release memory.
+	 */
 	return (task->flags & PF_EXITING) &&
 		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
 }

