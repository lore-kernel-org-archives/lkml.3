Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaCOSWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 14:22:21 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:61250 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608AbaCOSWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 14:22:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140224192734.GA15573@bender.morinfr.org>
References: <20140224192734.GA15573@bender.morinfr.org>
Date: Sat, 15 Mar 2014 11:22:18 -0700
X-Google-Sender-Auth: tGVGPHJtNaWMvw2PbFMUP5Q9W90
Message-ID: <CA+55aFyXCh8ETJH2XODzWM_Hj8_eTe4fjHt6v630YJB8OzS-Ew@mail.gmail.com>
Subject: Re: [PATCH] exit.c: call proc_exit_connector() after exit_state is set
From: Linus Torvalds <torvalds@linux-foundation.org>
To: matt.helsley@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Evgeniy Polyakov <zbr@ioremap.net>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Going through old emails, adding relevant people, ie Oleg for
kernel/exit.c and David because he seems to be the go-to person for
connector issues judging by commits ]

Patch looks sane to me, and logically that exit_connector thing would
pair with exit_notify(), but I'd like some comments on it. That
usability issue/race has been there since forever afaik. We probably
should never have added that process events connector thing, but since
we did and people apparently use it..

Comments?

             Linus

On Mon, Feb 24, 2014 at 11:27 AM, Guillaume Morin <guillaume@morinfr.org> wrote:
> From: Guillaume Morin <guillaume@morinfr.org>
>
> The process events connector delivers a notification when a process
> exits.  This is really convenient for a process that spawns and wants
> to monitor its children through an epoll-able() interface.
>
> Unfortunately, there is a small window between when the event is
> delivered and the child become wait()-able.
>
> This is creates a race if the parent wants to make sure that it knows
> about the exit, e.g
>
> pid_t pid = fork();
> if (pid > 0) {
>         register_interest_for_pid(pid);
>         if (waitpid(pid, NULL, WNOHANG) > 0)
>         {
>           /* We might have raced with exit() */
>         }
>         return;
> }
>
> /* Child */
> execve(...)
>
> register_interest_for_pid() would be telling the the connector socket
> reader to pay attention to events related to pid.
>
> Though this is not a bug, I think it would make the connector a bit
> more usable if this race was closed by simply moving the call to
> proc_exit_connector() from just before exit_notify() to right after.
>
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
> Cc: matt.helsley@gmail.com
> ---
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 1e77fc6..9b0ac8c 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -804,7 +804,6 @@ void do_exit(long code)
>
>         module_put(task_thread_info(tsk)->exec_domain->module);
>
> -       proc_exit_connector(tsk);
>
>         /*
>          * FIXME: do that only when needed, using sched_exit tracepoint
> @@ -812,6 +811,7 @@ void do_exit(long code)
>         flush_ptrace_hw_breakpoint(tsk);
>
>         exit_notify(tsk, group_dead);
> +       proc_exit_connector(tsk);
>  #ifdef CONFIG_NUMA
>         task_lock(tsk);
>         mpol_put(tsk->mempolicy);
>
>
>
> --
> Guillaume Morin <guillaume@morinfr.org>
