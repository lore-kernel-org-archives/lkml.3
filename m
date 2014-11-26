Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaKZUxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:53:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbaKZUwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:52:53 -0500
Date: Wed, 26 Nov 2014 21:52:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc: Lukasz Pawelczyk <havner@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Sameer Nanda <snanda@chromium.org>,
        Guillaume Morin <guillaume@morinfr.org>, Li Zefan <lizefan@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/exit.c: make sure current's nsproxy != NULL
	while checking caps
Message-ID: <20141126205230.GA22121@redhat.com>
References: <1417011661-19230-1-git-send-email-l.pawelczyk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417011661-19230-1-git-send-email-l.pawelczyk@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26, Lukasz Pawelczyk wrote:
>
> My understanding is that while we have to use task_nsproxy()

task_nsproxy() has already gone... probably this doesn't matter but which
kernel version ?

> task's nsproxy and check whether it's NULL, for the 'current' we don't
> have to and it's expected not to be NULL.

Well, unless exit_task_namespaces() was called ;)

> There seem to be no crash currently because of this, but with other LSM
> modules or in future there might be. This is the backtrace:

Confused... backtrace of what? did kernel crash or what?

> 0  smk_tskacc (task=0xffff88003b0b92e0, obj_known=0x2 <irq_stack_union+2>, mode=2, a=0xffff88003be53dd8) at security/smack/smack_access.c:261
> 1  0xffffffff8130e2aa in smk_curacc (obj_known=<optimized out>, mode=<optimized out>, a=<optimized out>) at security/smack/smack_access.c:318
> 2  0xffffffff8130a50d in smack_task_kill (p=0xffff88003b0b92e0, info=<optimized out>, sig=<optimized out>, secid=<optimized out>) at security/smack/smack_lsm.c:2071

I do not know this code, so could you please tell more? How/wher smk_tskacc()
uses ->nsproxy?  smack_access.c:261 leads to the comment header above smk_curacc()
in my tree, so this tells me nothing.

> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -751,7 +751,6 @@ void do_exit(long code)
>  	exit_fs(tsk);
>  	if (group_dead)
>  		disassociate_ctty(1);
> -	exit_task_namespaces(tsk);
>  	exit_task_work(tsk);
>  	exit_thread();
>  
> @@ -773,6 +772,13 @@ void do_exit(long code)
>  	flush_ptrace_hw_breakpoint(tsk);
>  
>  	exit_notify(tsk, group_dead);
> +
> +	/*
> +	 * This should be after all things that pottentially require
> +	 * process's namespaces (e.g. capability checks).
> +	 */
> +	exit_task_namespaces(tsk);
> +
>  	proc_exit_connector(tsk);

Well, we can probably move exit_task_namespaces() down (perhaps we even
want to move it after exit_task_work).

But I am not sure about exit_notify(), in this case free_nsproxy() can
be called when the caller is already reaped.

In any case, please more details?

Oleg.

