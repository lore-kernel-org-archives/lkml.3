Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3HVSFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 14:05:42 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:33530 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3HVSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 14:05:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130822171001.GA20321@redhat.com>
References: <20130822170939.GA20296@redhat.com> <20130822171001.GA20321@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Aug 2013 11:05:21 -0700
Message-ID: <CALCETrUjZYBsZKnkJXbHF40Y3qcXy0YxT0jNfrh5ksDg=kn4Ug@mail.gmail.com>
Subject: Re: [PATCH 2/3] pidns: kill the unnecessary CLONE_NEWPID in copy_process()
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
> 8382fcac "pidns: Outlaw thread creation after unshare(CLONE_NEWPID)"
> nacks CLONE_NEWPID if the forking process unshared pid_ns. This is
> correct but unnecessary, copy_pid_ns() does the same check.
>
> Test-case (needs root or CLONE_NEWUSER should be added):
>
>         static int child(void *arg)
>         {
>                 return 0;
>         }
>
>         static char stack[16 * 1024];
>
>         int main(void)
>         {
>                 pid_t pid;
>
>                 assert(unshare(CLONE_NEWPID) == 0);
>
>                 pid = clone(child, stack + sizeof(stack) / 2,
>                                 CLONE_NEWPID | SIGCHLD, NULL);
>                 assert(pid < 0 && errno == EINVAL);
>
>                 return 0;
>         }
>
> clone(CLONE_NEWPID) correctly fails with or without this change.

Acked-by: Andy Lutomirski <luto@amacapital.net>

>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/fork.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 86f5376..8d56338 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1176,7 +1176,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>          * If the new process will be in a different pid namespace don't
>          * allow the creation of threads, or share the signal handlers.
>          */
> -       if ((clone_flags & (CLONE_SIGHAND | CLONE_NEWPID)) &&
> +       if ((clone_flags & CLONE_SIGHAND) &&
>             (task_active_pid_ns(current) != current->nsproxy->pid_ns))
>                 return ERR_PTR(-EINVAL);
>
> --
> 1.5.5.1
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
