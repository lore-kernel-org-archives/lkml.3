Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaIWGhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:37:21 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:51635 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbaIWGhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:37:18 -0400
MIME-Version: 1.0
In-Reply-To: <54210D7B.8030103@huawei.com>
References: <54210D3F.2090409@huawei.com>
	<54210D7B.8030103@huawei.com>
Date: Mon, 22 Sep 2014 23:37:17 -0700
X-Google-Sender-Auth: UGDVD6_hkKmsLXk3jtCIJr96_sk
Message-ID: <CAGXu5jJKNJ=PsTtkPaoMyCNf2fK07szP-hv4NdaiDVx4tHacQw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] sched: add a macro to define bitops for task
 atomic flags
From: Kees Cook <keescook@chromium.org>
To: Zefan Li <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Miao Xie <miaox@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 11:04 PM, Zefan Li <lizefan@huawei.com> wrote:
> This will simplify code when we add new flags.
>
> v2:
> - updated scripts/tags.sh, suggested by Peter
>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Miao Xie <miaox@cn.fujitsu.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Zefan Li <lizefan@huawei.com>
> ---
>  include/linux/sched.h | 20 +++++++++++---------
>  scripts/tags.sh       |  6 ++++++
>  2 files changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 4557765..04a2ae2 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1959,15 +1959,17 @@ static inline void memalloc_noio_restore(unsigned int flags)
>  /* Per-process atomic flags. */
>  #define PFA_NO_NEW_PRIVS 0     /* May not gain new privileges. */
>
> -static inline bool task_no_new_privs(struct task_struct *p)
> -{
> -       return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
> -}
> -
> -static inline void task_set_no_new_privs(struct task_struct *p)
> -{
> -       set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
> -}
> +#define TASK_PFA_BITOPS(name, func)                            \
> +static inline bool task_##func(struct task_struct *p)          \
> +{ return test_bit(PFA_##name, &p->atomic_flags); }             \
> +                                                               \
> +static inline void task_set_##func(struct task_struct *p)      \
> +{ set_bit(PFA_##name, &p->atomic_flags); }                     \
> +                                                               \
> +static inline void task_clear_##func(struct task_struct *p)    \
> +{ clear_bit(PFA_##name, &p->atomic_flags); }
> +
> +TASK_PFA_BITOPS(NO_NEW_PRIVS, no_new_privs)

One thing I don't like about this is that task_clear_no_new_privs()
ends up getting defined, and it should absolutely never be used. NNP
should never be cleared or there could be security issues. I realize
this isn't a very useful nit-pick, but I'd rather the function wasn't
even available for someone to accidentally use. Maybe break up the
macro with some kind of "write only" version like:

#define TASK_PFA_BITOPS_WO(name, func)                            \
static inline bool task_##func(struct task_struct *p)          \
{ return test_bit(PFA_##name, &p->atomic_flags); }             \
static inline void task_set_##func(struct task_struct *p)      \
{ set_bit(PFA_##name, &p->atomic_flags); }

#define TASK_PFA_BITOPS(name, func)                            \
TASK_PFA_BITOPS_WO(name, func);          \
static inline void task_clear_##func(struct task_struct *p)    \
{ clear_bit(PFA_##name, &p->atomic_flags); }

TASK_PFA_BITOPS_WO(NO_NEW_PRIVS, no_new_privs)

And then all the new users can use TASK_PFA_BITOPS() normally since
they expect to use "clear"?

-Kees

>
>  /*
>   * task->jobctl flags
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index cbfd269..8591b57 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -197,6 +197,9 @@ exuberant()
>         --regex-c++='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'          \
>         --regex-c++='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'      \
>         --regex-c++='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
> +       --regex-c++='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_\1/'     \
> +       --regex-c++='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_set_\1/' \
> +       --regex-c++='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_clear_\1/'  \
>         --regex-c='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
>         --regex-c='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
>         --regex-c='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'     \
> @@ -260,6 +263,9 @@ emacs()
>         --regex='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'      \
>         --regex='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'  \
>         --regex='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
> +       --regex='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_\1/' \
> +       --regex='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_set_\1/'     \
> +       --regex='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_clear_\1/'   \
>         --regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'           \
>         --regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
>         --regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'\
> --
> 1.8.0.2
>



-- 
Kees Cook
Chrome OS Security
