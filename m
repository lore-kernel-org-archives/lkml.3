Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3DOJ52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 05:57:28 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:49737 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3DOJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 05:57:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130413155521.GB6533@redhat.com>
References: <1365794853-23912-1-git-send-email-avagin@openvz.org>
	<20130413142246.GA864@redhat.com>
	<20130413155457.GA6533@redhat.com>
	<20130413155521.GB6533@redhat.com>
Date: Mon, 15 Apr 2013 13:57:25 +0400
Message-ID: <CANaxB-wb3h9zb1C38W=pSjg_sf4RiRbpUHRU2pKppohmDy5Dtg@mail.gmail.com>
Subject: Re: [PATCH 1/1] move exit_task_namespaces() outside of exit_notify()
From: Andrey Wagin <avagin@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/13 Oleg Nesterov <oleg@redhat.com>
>
> exit_notify() does exit_task_namespaces() after
> forget_original_parent(). This was needed to ensure that ->nsproxy
> can't be cleared prematurely, an exiting child we are going to
> reparent can do do_notify_parent() and use the parent's (ours) pid_ns.
>
> However, after 32084504 "pidns: use task_active_pid_ns in
> do_notify_parent" ->nsproxy != NULL is no longer needed, we rely
> on task_active_pid_ns().
>
> Move exit_task_namespaces() from exit_notify() to do_exit(), after
> exit_fs() and before exit_task_work().
>
> This solves the problem reported by Andrey, free_ipc_ns()->shm_destroy()
> does fput() which needs task_work_add(). And this allows us do simplify
> exit_notify(), we can avoid unlock/lock(tasklist) and we can change
> ->exit_state instead of PF_EXITING in forget_original_parent().
>

It looks good for me. I have tested it a bit and don't find any problem.
Oleg, thank you.

Acked-by: Andrew Vagin <avagin@gmail.com>

> Reported-by: Andrey Vagin <avagin@openvz.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> --- x/kernel/exit.c
> +++ x/kernel/exit.c
> @@ -649,7 +649,6 @@ static void exit_notify(struct task_stru
>          *      jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
>          */
>         forget_original_parent(tsk);
> -       exit_task_namespaces(tsk);
>
>         write_lock_irq(&tasklist_lock);
>         if (group_dead)
> @@ -795,6 +794,7 @@ void do_exit(long code)
>         exit_shm(tsk);
>         exit_files(tsk);
>         exit_fs(tsk);
> +       exit_task_namespaces(tsk);
>         exit_task_work(tsk);
>         check_stack_usage();
>         exit_thread();
>
