Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaHKUG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 16:06:26 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63826 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaHKUGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 16:06:24 -0400
MIME-Version: 1.0
In-Reply-To: <1407729030-30283-1-git-send-email-linux@roeck-us.net>
References: <1407729030-30283-1-git-send-email-linux@roeck-us.net>
Date: Mon, 11 Aug 2014 13:06:24 -0700
X-Google-Sender-Auth: 7QMq16STLKAZ5IKNHku1JKg6xfU
Message-ID: <CAGXu5jLhyGSw0CndSS6iXc2xTrwV9zpBygnZRzSE60aELMBbyw@mail.gmail.com>
Subject: Re: [PATCH] seccomp: Replace BUG(!spin_is_locked()) with assert_spin_lock
From: Kees Cook <keescook@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 8:50 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> Current upstream kernel hangs with mips and powerpc targets in
> uniprocessor mode if SECCOMP is configured.
>
> Bisect points to commit dbd952127d11 ("seccomp: introduce writer locking").
> Turns out that code such as
>         BUG_ON(!spin_is_locked(&list_lock));
> can not be used in uniprocessor mode because spin_is_locked() always
> returns false in this configuration, and that assert_spin_locked()
> exists for that very purpose and must be used instead.
>
> Fixes: dbd952127d11 ("seccomp: introduce writer locking")
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied, thanks! Should be visible here shortly:

http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=seccomp/tip

-Kees

> ---
>  kernel/fork.c    |  2 +-
>  kernel/seccomp.c | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 1380d8a..0cf9cdb 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1105,7 +1105,7 @@ static void copy_seccomp(struct task_struct *p)
>          * needed because this new task is not yet running and cannot
>          * be racing exec.
>          */
> -       BUG_ON(!spin_is_locked(&current->sighand->siglock));
> +       assert_spin_locked(&current->sighand->siglock);
>
>         /* Ref-count the new filter user, and assign it. */
>         get_seccomp_filter(current);
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 25b0043..44eb005 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -203,7 +203,7 @@ static u32 seccomp_run_filters(int syscall)
>
>  static inline bool seccomp_may_assign_mode(unsigned long seccomp_mode)
>  {
> -       BUG_ON(!spin_is_locked(&current->sighand->siglock));
> +       assert_spin_locked(&current->sighand->siglock);
>
>         if (current->seccomp.mode && current->seccomp.mode != seccomp_mode)
>                 return false;
> @@ -214,7 +214,7 @@ static inline bool seccomp_may_assign_mode(unsigned long seccomp_mode)
>  static inline void seccomp_assign_mode(struct task_struct *task,
>                                        unsigned long seccomp_mode)
>  {
> -       BUG_ON(!spin_is_locked(&task->sighand->siglock));
> +       assert_spin_locked(&task->sighand->siglock);
>
>         task->seccomp.mode = seccomp_mode;
>         /*
> @@ -253,7 +253,7 @@ static inline pid_t seccomp_can_sync_threads(void)
>         struct task_struct *thread, *caller;
>
>         BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
> -       BUG_ON(!spin_is_locked(&current->sighand->siglock));
> +       assert_spin_locked(&current->sighand->siglock);
>
>         /* Validate all threads being eligible for synchronization. */
>         caller = current;
> @@ -294,7 +294,7 @@ static inline void seccomp_sync_threads(void)
>         struct task_struct *thread, *caller;
>
>         BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
> -       BUG_ON(!spin_is_locked(&current->sighand->siglock));
> +       assert_spin_locked(&current->sighand->siglock);
>
>         /* Synchronize all threads. */
>         caller = current;
> @@ -464,7 +464,7 @@ static long seccomp_attach_filter(unsigned int flags,
>         unsigned long total_insns;
>         struct seccomp_filter *walker;
>
> -       BUG_ON(!spin_is_locked(&current->sighand->siglock));
> +       assert_spin_locked(&current->sighand->siglock);
>
>         /* Validate resulting filter length. */
>         total_insns = filter->prog->len;
> --
> 1.9.1
>



-- 
Kees Cook
Chrome OS Security
