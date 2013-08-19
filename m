Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab3HSSLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:11:04 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:64688 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3HSSLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:11:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130819172524.GA22268@redhat.com>
References: <20130819172524.GA22268@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 19 Aug 2013 11:10:41 -0700
Message-ID: <CALCETrW+dEwR38ERQhx25-aw1dhsCE6X+9BQZJhusO88aUxN1A@mail.gmail.com>
Subject: Re: PATCH? fix unshare(NEWPID) && vfork()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Walters <walters@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 10:25 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Hello.
>
> Colin reports that vfork() doesn't work after unshare(PIDNS). The
> reason is trivial, copy_process() does:
>
>         /*
>          * If the new process will be in a different pid namespace
>          * don't allow the creation of threads.
>          */
>         if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
>             (task_active_pid_ns(current) != current->nsproxy->pid_ns))
>                 return ERR_PTR(-EINVAL);
>
> and CLONE_VM obviously nacks vfork(). So perhaps we can relax
> this check to CLONE_THREAD? Or should we really nack CLONE_VM
> by security reasons?
>
> OTOH. Perhaps we should also deny CLONE_PARENT in this case?
>
> In short. So far I am thinking about the patch below but I got
> lost and totally confused. Will try to think more tomorrow, but
> I would like to see the fix from someone who still understands
> this all.
>
> Oleg.

By way of (partial) explanation:

http://marc.info/?l=linux-kernel&m=135545831607095

(tl;dr: I think that CLONE_VM is irrelevant here, but there may be
other issues lurking around.)

--Andy

>
> --- x/kernel/fork.c     2013-08-14 18:34:06.000000000 +0200
> +++ x/kernel/fork.c     2013-08-19 19:03:43.848823039 +0200
> @@ -1172,14 +1172,6 @@ static struct task_struct *copy_process(
>                                 current->signal->flags & SIGNAL_UNKILLABLE)
>                 return ERR_PTR(-EINVAL);
>
> -       /*
> -        * If the new process will be in a different pid namespace
> -        * don't allow the creation of threads.
> -        */
> -       if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
> -           (task_active_pid_ns(current) != current->nsproxy->pid_ns))
> -               return ERR_PTR(-EINVAL);
> -
>         retval = security_task_create(clone_flags);
>         if (retval)
>                 goto fork_out;
> @@ -1578,8 +1570,9 @@ long do_fork(unsigned long clone_flags,
>          * Do some preliminary argument and permissions checking before we
>          * actually start allocating stuff
>          */
> -       if (clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) {
> -               if (clone_flags & (CLONE_THREAD|CLONE_PARENT))
> +       if ((clone_flags & (CLONE_NEWUSER | CLONE_NEWPID)) ||
> +           (task_active_pid_ns(current) != current->nsproxy->pid_ns)) {
> +               if (clone_flags & (CLONE_THREAD | CLONE_PARENT | CLONE_NEWPID))
>                         return -EINVAL;
>         }
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
