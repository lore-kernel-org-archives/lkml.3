Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3H3QiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:38:07 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:43464
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756344Ab3H3QiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:38:06 -0400
Date: Fri, 30 Aug 2013 16:38:05 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [REVIEW][PATCH 3/5] pidns: Don't have unshare(CLONE_NEWPID)
 imply CLONE_THREAD
Message-ID: <20130830163805.GB18857@mail.hallyn.com>
References: <87ob8gys0d.fsf@xmission.com>
 <87a9k0yrvu.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9k0yrvu.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> I goofed when I made unshare(CLONE_NEWPID) only work in a
> single-threaded process.  There is no need for that requirement and in
> fact I analyzied things right for setns.  The hard requirement
> is for tasks that share a VM to all be in the pid namespace and
> we properly prevent that in do_fork.

I don't understand though - copy_process does have the right test:

   1176          * If the new process will be in a different pid namespace
   1177          * don't allow the creation of threads.
   1178          */
   1179         if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
   1180             (task_active_pid_ns(current) != current->nsproxy->pid_ns))
   1181                 return ERR_PTR(-EINVAL);

but why is it ok for sys_unshare not to do that?  Note that
in order for check_unshare_flags() to bail on &current->mm->mm_users > 1
you do have to set CLONE_VM (for inverse interpretation).

So it seems to me this isn't safe as is, and we need to at least
set CLONE_VM if CLONE_PID is set.

> Just to be certain I took a look through do_wait and
> forget_original_parent and there are no cases that make it any harder
> for children to be in the multiple pid namespaces than it is for
> children to be in the same pid namespace.  I also performed a check to
> see if there were in uses of task->nsproxy_pid_ns I was not familiar
> with, but it is only used when allocating a new pid for a new task,
> and in checks to prevent craziness from happening.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/fork.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 66635c8..eb45f1d 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1818,11 +1818,6 @@ SYSCALL_DEFINE1(unshare, unsigned long, unshare_flags)
>  	if (unshare_flags & CLONE_NEWUSER)
>  		unshare_flags |= CLONE_THREAD | CLONE_FS;
>  	/*
> -	 * If unsharing a pid namespace must also unshare the thread.
> -	 */
> -	if (unshare_flags & CLONE_NEWPID)
> -		unshare_flags |= CLONE_THREAD;
> -	/*
>  	 * If unsharing a thread from a thread group, must also unshare vm.
>  	 */
>  	if (unshare_flags & CLONE_THREAD)
> -- 
> 1.7.5.4
