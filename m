Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3HCTFn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 15:05:43 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39704 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3HCTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 15:05:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130801190511.GA3213@redhat.com>
References: <20130801190455.GA3194@redhat.com>
	<20130801190511.GA3213@redhat.com>
Date: Sat, 3 Aug 2013 12:05:41 -0700
X-Google-Sender-Auth: mbKKwTRxqfl9Jg-ztSQdurE4miE
Message-ID: <CAGXu5jK+8xKW3Hbzg7g7o2c3G4aWrT4Y4UBCBmaM74cUPMYnQA@mail.gmail.com>
Subject: Re: [PATCH 1/3] exec: introduce exec_binprm() for "depth == 0" code
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 12:05 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> task_pid_nr_ns() and trace/ptrace code in the middle of the
> recursive search_binary_handler() looks confusing and imho
> annoying. We only need this code if "depth == 0", lets add
> a simple helper which calls search_binary_handler() and does
> trace_sched_process_exec() + ptrace_event().
>
> The patch also moves the setting of task->did_exec, we need
> to do this only once.
>
> Note: we can kill either task->did_exec or PF_FORKNOEXEC.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  fs/exec.c |   36 ++++++++++++++++++++++--------------
>  1 files changed, 22 insertions(+), 14 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 9c73def..a9ae4f2 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1373,7 +1373,6 @@ int search_binary_handler(struct linux_binprm *bprm)
>         unsigned int depth = bprm->recursion_depth;
>         int try,retval;
>         struct linux_binfmt *fmt;
> -       pid_t old_pid, old_vpid;
>
>         /* This allows 4 levels of binfmt rewrites before failing hard. */
>         if (depth > 5)
> @@ -1387,12 +1386,6 @@ int search_binary_handler(struct linux_binprm *bprm)
>         if (retval)
>                 return retval;
>
> -       /* Need to fetch pid before load_binary changes it */
> -       old_pid = current->pid;
> -       rcu_read_lock();
> -       old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
> -       rcu_read_unlock();
> -
>         retval = -ENOENT;
>         for (try=0; try<2; try++) {
>                 read_lock(&binfmt_lock);
> @@ -1407,16 +1400,11 @@ int search_binary_handler(struct linux_binprm *bprm)
>                         retval = fn(bprm);
>                         bprm->recursion_depth = depth;
>                         if (retval >= 0) {
> -                               if (depth == 0) {
> -                                       trace_sched_process_exec(current, old_pid, bprm);
> -                                       ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
> -                               }
>                                 put_binfmt(fmt);
>                                 allow_write_access(bprm->file);
>                                 if (bprm->file)
>                                         fput(bprm->file);
>                                 bprm->file = NULL;
> -                               current->did_exec = 1;
>                                 proc_exec_connector(current);
>                                 return retval;
>                         }
> @@ -1450,9 +1438,29 @@ int search_binary_handler(struct linux_binprm *bprm)
>         }
>         return retval;
>  }
> -
>  EXPORT_SYMBOL(search_binary_handler);
>
> +static int exec_binprm(struct linux_binprm *bprm)
> +{
> +       pid_t old_pid, old_vpid;
> +       int ret;
> +
> +       /* Need to fetch pid before load_binary changes it */
> +       old_pid = current->pid;
> +       rcu_read_lock();
> +       old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
> +       rcu_read_unlock();
> +
> +       ret = search_binary_handler(bprm);
> +       if (ret >= 0) {
> +               trace_sched_process_exec(current, old_pid, bprm);
> +               ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
> +               current->did_exec = 1;
> +       }

Cleanup looks good. One idea here, though: this could be made more
pretty by doing:

if (ret < 0)
    return ret;

to avoid the indentation for the "expected" code path.

-Kees

> +
> +       return ret;
> +}
> +
>  /*
>   * sys_execve() executes a new program.
>   */
> @@ -1541,7 +1549,7 @@ static int do_execve_common(const char *filename,
>         if (retval < 0)
>                 goto out;
>
> -       retval = search_binary_handler(bprm);
> +       retval = exec_binprm(bprm);
>         if (retval < 0)
>                 goto out;
>
> --
> 1.5.5.1
>



-- 
Kees Cook
Chrome OS Security
