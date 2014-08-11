Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaHKOBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:01:20 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52556 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaHKOBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:01:18 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E8CCAB.8000202@roeck-us.net>
Date: Mon, 11 Aug 2014 07:01:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
CC: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] seccomp: Replace BUG(!spin_is_locked()) with assert_spin_lock
References: <1407729030-30283-1-git-send-email-linux@roeck-us.net> <CAGUYZuSx3rMiLaPdDcmQYAZyTW9-6tZ_AL=8KQ_Mvv5FO0YHgA@mail.gmail.com>
In-Reply-To: <CAGUYZuSx3rMiLaPdDcmQYAZyTW9-6tZ_AL=8KQ_Mvv5FO0YHgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2014 11:19 PM, sanjeev sharma wrote:
> Hello Guenter Roeck
>
> The same thing should be taken care in futex.c
>

That is using WARN_ON_SMP which is provided for that purpose.

Guenter

> Regards
> Sanjeev Sharma
>
>
> On Mon, Aug 11, 2014 at 9:20 AM, Guenter Roeck <linux@roeck-us.net <mailto:linux@roeck-us.net>> wrote:
>
>     Current upstream kernel hangs with mips and powerpc targets in
>     uniprocessor mode if SECCOMP is configured.
>
>     Bisect points to commit dbd952127d11 ("seccomp: introduce writer locking").
>     Turns out that code such as
>              BUG_ON(!spin_is_locked(&list_lock));
>     can not be used in uniprocessor mode because spin_is_locked() always
>     returns false in this configuration, and that assert_spin_locked()
>     exists for that very purpose and must be used instead.
>
>     Fixes: dbd952127d11 ("seccomp: introduce writer locking")
>     Cc: Kees Cook <keescook@chromium.org <mailto:keescook@chromium.org>>
>     Signed-off-by: Guenter Roeck <linux@roeck-us.net <mailto:linux@roeck-us.net>>
>     ---
>       kernel/fork.c    |  2 +-
>       kernel/seccomp.c | 10 +++++-----
>       2 files changed, 6 insertions(+), 6 deletions(-)
>
>     diff --git a/kernel/fork.c b/kernel/fork.c
>     index 1380d8a..0cf9cdb 100644
>     --- a/kernel/fork.c
>     +++ b/kernel/fork.c
>     @@ -1105,7 +1105,7 @@ static void copy_seccomp(struct task_struct *p)
>               * needed because this new task is not yet running and cannot
>               * be racing exec.
>               */
>     -       BUG_ON(!spin_is_locked(&current->sighand->siglock));
>     +       assert_spin_locked(&current->sighand->siglock);
>
>              /* Ref-count the new filter user, and assign it. */
>              get_seccomp_filter(current);
>     diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>     index 25b0043..44eb005 100644
>     --- a/kernel/seccomp.c
>     +++ b/kernel/seccomp.c
>     @@ -203,7 +203,7 @@ static u32 seccomp_run_filters(int syscall)
>
>       static inline bool seccomp_may_assign_mode(unsigned long seccomp_mode)
>       {
>     -       BUG_ON(!spin_is_locked(&current->sighand->siglock));
>     +       assert_spin_locked(&current->sighand->siglock);
>
>              if (current->seccomp.mode && current->seccomp.mode != seccomp_mode)
>                      return false;
>     @@ -214,7 +214,7 @@ static inline bool seccomp_may_assign_mode(unsigned long seccomp_mode)
>       static inline void seccomp_assign_mode(struct task_struct *task,
>                                             unsigned long seccomp_mode)
>       {
>     -       BUG_ON(!spin_is_locked(&task->sighand->siglock));
>     +       assert_spin_locked(&task->sighand->siglock);
>
>              task->seccomp.mode = seccomp_mode;
>              /*
>     @@ -253,7 +253,7 @@ static inline pid_t seccomp_can_sync_threads(void)
>              struct task_struct *thread, *caller;
>
>              BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
>     -       BUG_ON(!spin_is_locked(&current->sighand->siglock));
>     +       assert_spin_locked(&current->sighand->siglock);
>
>              /* Validate all threads being eligible for synchronization. */
>              caller = current;
>     @@ -294,7 +294,7 @@ static inline void seccomp_sync_threads(void)
>              struct task_struct *thread, *caller;
>
>              BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
>     -       BUG_ON(!spin_is_locked(&current->sighand->siglock));
>     +       assert_spin_locked(&current->sighand->siglock);
>
>              /* Synchronize all threads. */
>              caller = current;
>     @@ -464,7 +464,7 @@ static long seccomp_attach_filter(unsigned int flags,
>              unsigned long total_insns;
>              struct seccomp_filter *walker;
>
>     -       BUG_ON(!spin_is_locked(&current->sighand->siglock));
>     +       assert_spin_locked(&current->sighand->siglock);
>
>              /* Validate resulting filter length. */
>              total_insns = filter->prog->len;
>     --
>     1.9.1
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>     the body of a message to majordomo@vger.kernel.org <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>     Please read the FAQ at http://www.tux.org/lkml/
>
>

