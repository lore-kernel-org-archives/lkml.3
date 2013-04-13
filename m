Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab3DMOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 10:25:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3DMOZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 10:25:26 -0400
Date: Sat, 13 Apr 2013 16:22:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] kernel: move exit_task_work() past exit_notify()
Message-ID: <20130413142246.GA864@redhat.com>
References: <1365794853-23912-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365794853-23912-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Andrey Vagin wrote:
> exit_task_work() must be called after exit_notify, because
> exit_task_namespaces() may release a file and fput() enqueues a work.
>
> exit_notify
>   exit_task_namespaces
>     free_ipc_ns
>       shm_destroy
>         fput
>           task_work_add
>
> so if task works don't run after exit_notify(), a few files may leak.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  kernel/exit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 60bc027..1d1129b 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -795,7 +795,6 @@ void do_exit(long code)
>  	exit_shm(tsk);
>  	exit_files(tsk);
>  	exit_fs(tsk);
> -	exit_task_work(tsk);
>  	check_stack_usage();
>  	exit_thread();
>
> @@ -822,6 +821,7 @@ void do_exit(long code)
>  	ptrace_put_breakpoints(tsk);
>
>  	exit_notify(tsk, group_dead);
> +	exit_task_work(tsk);

I am not comfortable with this change...

The task is "really dead" after exit_notify(), even release_task(current)
can be called.

Let me think a bit... It seems that we have the alternative.

Oleg.

