Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3COSpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:45:14 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:43215 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3COSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:45:11 -0400
MIME-Version: 1.0
In-Reply-To: <1363372123-8861-2-git-send-email-nschichan@freebox.fr>
References: <1363372123-8861-1-git-send-email-nschichan@freebox.fr>
	<1363372123-8861-2-git-send-email-nschichan@freebox.fr>
Date: Fri, 15 Mar 2013 11:45:07 -0700
X-Google-Sender-Auth: uJaNrTUqpVjLocRuI_T8-H8ubsk
Message-ID: <CAGXu5jLMPFoeAD5uXaMf-CS9yz_8_1zRJEkzxT7R6U4HruJSjQ@mail.gmail.com>
Subject: Re: [PATCH RFC 1/3] seccomp: add generic code for jitted seccomp filters.
From: Kees Cook <keescook@chromium.org>
To: Nicolas Schichan <nschichan@freebox.fr>
Cc: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 11:28 AM, Nicolas Schichan <nschichan@freebox.fr> wrote:
> Architecture must select HAVE_SECCOMP_FILTER_JIT and implement
> seccomp_jit_compile() and seccomp_jit_free() if they intend to support
> jitted seccomp filters.
>
> struct seccomp_filter has been moved to <linux/seccomp.h> to make its
> content available to the jit compilation code.
>
> In a way similar to the net BPF, the jit compilation code is expected
> to updates struct seccomp_filter.bpf_func pointer to the generated
> code.

Exciting. :) Thanks for working on this!

>
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
> ---
>  arch/Kconfig            |   14 ++++++++++++++
>  include/linux/seccomp.h |   39 +++++++++++++++++++++++++++++++++++++++
>  kernel/seccomp.c        |   34 +++++-----------------------------
>  3 files changed, 58 insertions(+), 29 deletions(-)
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 5a1779c..1284367 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -339,6 +339,10 @@ config HAVE_ARCH_SECCOMP_FILTER
>           - secure_computing return value is checked and a return value of -1
>             results in the system call being skipped immediately.
>
> +# Used by archs to tell that they support SECCOMP_FILTER_JIT
> +config HAVE_SECCOMP_FILTER_JIT
> +       bool
> +
>  config SECCOMP_FILTER
>         def_bool y
>         depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET
> @@ -349,6 +353,16 @@ config SECCOMP_FILTER
>
>           See Documentation/prctl/seccomp_filter.txt for details.
>
> +config SECCOMP_FILTER_JIT
> +       bool "enable Seccomp filter Just In Time compiler"
> +       depends on HAVE_SECCOMP_FILTER_JIT && BPF_JIT && SECCOMP_FILTER
> +       help
> +         Seccomp syscall filtering capabilities are normally handled
> +         by an interpreter. This option allows kernel to generate a native
> +         code when filter is loaded in memory. This should speedup
> +         syscall filtering. Note : Admin should enable this feature
> +         changing /proc/sys/net/core/bpf_jit_enable
> +
>  config HAVE_CONTEXT_TRACKING
>         bool
>         help
> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> index 6f19cfd..af27494 100644
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -6,6 +6,7 @@
>  #ifdef CONFIG_SECCOMP
>
>  #include <linux/thread_info.h>
> +#include <linux/filter.h>
>  #include <asm/seccomp.h>
>
>  struct seccomp_filter;
> @@ -47,6 +48,44 @@ static inline int seccomp_mode(struct seccomp *s)
>         return s->mode;
>  }
>
> +/**
> + * struct seccomp_filter - container for seccomp BPF programs
> + *
> + * @usage: reference count to manage the object lifetime.
> + *         get/put helpers should be used when accessing an instance
> + *         outside of a lifetime-guarded section.  In general, this
> + *         is only needed for handling filters shared across tasks.
> + * @prev: points to a previously installed, or inherited, filter
> + * @len: the number of instructions in the program
> + * @insns: the BPF program instructions to evaluate

This should be updated to include the new bpf_func field.

Regardless, it'd be better to not expose this structure to userspace.

> + *
> + * seccomp_filter objects are organized in a tree linked via the @prev
> + * pointer.  For any task, it appears to be a singly-linked list starting
> + * with current->seccomp.filter, the most recently attached or inherited filter.
> + * However, multiple filters may share a @prev node, by way of fork(), which
> + * results in a unidirectional tree existing in memory.  This is similar to
> + * how namespaces work.
> + *
> + * seccomp_filter objects should never be modified after being attached
> + * to a task_struct (other than @usage).
> + */
> +struct seccomp_filter {
> +       atomic_t usage;
> +       struct seccomp_filter *prev;
> +       unsigned short len;  /* Instruction count */
> +       unsigned int (*bpf_func)(const struct sk_buff *skb,
> +                                const struct sock_filter *filter);
> +       struct sock_filter insns[];
> +};
> +
> +#ifdef CONFIG_SECCOMP_FILTER_JIT
> +extern void seccomp_jit_compile(struct seccomp_filter *fp);
> +extern void seccomp_jit_free(struct seccomp_filter *fp);
> +#else
> +static inline void seccomp_jit_compile(struct seccomp_filter *fp) { }
> +static inline void seccomp_jit_free(struct seccomp_filter *fp) { }
> +#endif
> +
>  #else /* CONFIG_SECCOMP */
>
>  #include <linux/errno.h>
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index b7a1004..a1aadaa 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -30,34 +30,6 @@
>  #include <linux/tracehook.h>
>  #include <linux/uaccess.h>
>
> -/**
> - * struct seccomp_filter - container for seccomp BPF programs
> - *
> - * @usage: reference count to manage the object lifetime.
> - *         get/put helpers should be used when accessing an instance
> - *         outside of a lifetime-guarded section.  In general, this
> - *         is only needed for handling filters shared across tasks.
> - * @prev: points to a previously installed, or inherited, filter
> - * @len: the number of instructions in the program
> - * @insns: the BPF program instructions to evaluate
> - *
> - * seccomp_filter objects are organized in a tree linked via the @prev
> - * pointer.  For any task, it appears to be a singly-linked list starting
> - * with current->seccomp.filter, the most recently attached or inherited filter.
> - * However, multiple filters may share a @prev node, by way of fork(), which
> - * results in a unidirectional tree existing in memory.  This is similar to
> - * how namespaces work.
> - *
> - * seccomp_filter objects should never be modified after being attached
> - * to a task_struct (other than @usage).
> - */
> -struct seccomp_filter {
> -       atomic_t usage;
> -       struct seccomp_filter *prev;
> -       unsigned short len;  /* Instruction count */
> -       struct sock_filter insns[];
> -};
> -
>  /* Limit any path through the tree to 256KB worth of instructions. */
>  #define MAX_INSNS_PER_PATH ((1 << 18) / sizeof(struct sock_filter))
>
> @@ -213,7 +185,7 @@ static u32 seccomp_run_filters(int syscall)
>          * value always takes priority (ignoring the DATA).
>          */
>         for (f = current->seccomp.filter; f; f = f->prev) {
> -               u32 cur_ret = sk_run_filter(NULL, f->insns);
> +               u32 cur_ret = f->bpf_func(NULL, f->insns);

This will make bpf_func a rather attractive target inside the kernel.
I wonder if there could be ways to harden it against potential attack.

>                 if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
>                         ret = cur_ret;
>         }
> @@ -275,6 +247,9 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
>         if (ret)
>                 goto fail;
>
> +       filter->bpf_func = sk_run_filter;
> +       seccomp_jit_compile(filter);
> +
>         /*
>          * If there is an existing filter, make it the prev and don't drop its
>          * task reference.
> @@ -332,6 +307,7 @@ void put_seccomp_filter(struct task_struct *tsk)
>         while (orig && atomic_dec_and_test(&orig->usage)) {
>                 struct seccomp_filter *freeme = orig;
>                 orig = orig->prev;
> +               seccomp_jit_free(freeme);
>                 kfree(freeme);
>         }
>  }
> --
> 1.7.10.4
>

In addition to this work, I'm curious if anyone has looked at JIT
hardening, to make it a less trivial ROP target? For example:
http://grsecurity.net/~spender/jit_prot.diff

-Kees

--
Kees Cook
Chrome OS Security
