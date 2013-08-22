Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab3HVSLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:11:18 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:59304 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab3HVSLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:11:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130822171004.GA20324@redhat.com>
References: <20130822170939.GA20296@redhat.com> <20130822171004.GA20324@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Aug 2013 11:10:56 -0700
Message-ID: <CALCETrU9D59MqxPm2SNegPFH_+gpPfoQJkD2E2Q8zjJ94QhLDg@mail.gmail.com>
Subject: Re: [PATCH 3/3] fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 10:10 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> do_fork() denies CLONE_THREAD | CLONE_PARENT if NEWUSER | NEWPID.
>
> Then later copy_process() denies CLONE_SIGHAND if the new process
> will be in a different pid namespace (task_active_pid_ns() doesn't
> match current->nsproxy->pid_ns).
>
> This looks confusing and inconsistent. CLONE_NEWPID is very similar
> to the case when ->pid_ns was already unshared, we want the same
> restrictions so copy_process() should also nack CLONE_PARENT.
>
> And it would be better to deny CLONE_NEWUSER && CLONE_SIGHAND as
> well just for consistency.
>
> Kill the "CLONE_NEWUSER | CLONE_NEWPID" check in do_fork() and
> change copy_process() to the same check along with nsproxy->pid_ns
> we already have.

Did the old code actually prevent clone(CLONE_PARENT | CLONE_NEWPID)?
The new code explicitly does, and that looks like a good thing.

>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/fork.c |   22 ++++++++--------------
>  1 files changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 8d56338..fae2ff7 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1173,12 +1173,15 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>                 return ERR_PTR(-EINVAL);
>
>         /*
> -        * If the new process will be in a different pid namespace don't
> -        * allow the creation of threads, or share the signal handlers.
> +        * If the new process will be in a different pid or user namespace
> +        * don't allow the creation of threads, or share the signal handlers,
> +        * or share the parent.
>          */
> -       if ((clone_flags & CLONE_SIGHAND) &&
> -           (task_active_pid_ns(current) != current->nsproxy->pid_ns))
> -               return ERR_PTR(-EINVAL);
> +       if (clone_flags & (CLONE_SIGHAND | CLONE_PARENT)) {
> +               if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
> +                   (task_active_pid_ns(current) != current->nsproxy->pid_ns))
> +                       return ERR_PTR(-EINVAL);
> +       }
>
>         retval = security_task_create(clone_flags);
>         if (retval)
> @@ -1575,15 +1578,6 @@ long do_fork(unsigned long clone_flags,
>         long nr;
>
>         /*
> -        * Do some preliminary argument and permissions checking before we
> -        * actually start allocating stuff
> -        */
> -       if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
> -               if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
> -                       return -EINVAL;
> -       }
> -
> -       /*
>          * Determine whether and which event to report to ptracer.  When
>          * called from kernel_thread or CLONE_UNTRACED is explicitly
>          * requested, no event is reported; otherwise, report if the event
> --
> 1.5.5.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
