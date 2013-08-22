Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3HVSAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:00:21 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:48081 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3HVSAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:00:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130822170958.GA20314@redhat.com>
References: <20130822170939.GA20296@redhat.com> <20130822170958.GA20314@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Aug 2013 10:59:58 -0700
Message-ID: <CALCETrUGd-+Z4tWF3uJa18eKgK+GcMaOp0Jm4dtQm7E=wz1NMg@mail.gmail.com>
Subject: Re: [PATCH 1/3] pidns: fix vfork() after unshare(CLONE_NEWPID)
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

On Thu, Aug 22, 2013 at 10:09 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> 8382fcac "pidns: Outlaw thread creation after unshare(CLONE_NEWPID)"
> nacks CLONE_VM if the forking process unshared pid_ns, this obviously
> breaks vfork:
>
>         int main(void)
>         {
>                 assert(unshare(CLONE_NEWUSER | CLONE_NEWPID) == 0);
>                 assert(vfork() >= 0);
>                 _exit(0);
>                 return 0;
>         }
>
> fails without this patch.
>
> Change this check to use CLONE_SIGHAND instead. This also forbids
> CLONE_THREAD automatically, and this is what the comment implies.
>
> We could probably even drop CLONE_SIGHAND and use CLONE_THREAD,
> but it would be safer to not do this. The current check denies
> CLONE_SIGHAND implicitely and there is no reason to change this.

Acked-by: Andy Lutomirski <luto@amacapital.net>

although...

>
> Reported-by: Colin Walters <walters@redhat.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/fork.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e23bb19..86f5376 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1173,10 +1173,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>                 return ERR_PTR(-EINVAL);
>
>         /*
> -        * If the new process will be in a different pid namespace
> -        * don't allow the creation of threads.
> +        * If the new process will be in a different pid namespace don't
> +        * allow the creation of threads, or share the signal handlers.

...how about "If the new process will be in a different pid namespace,
don't allow it to share a thread group or signal handlers with the
parent"?

--Andy
