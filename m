Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990AbaIBGnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 02:43:24 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43902 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBGnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 02:43:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140829181603.GB30659@redhat.com>
References: <20140827185138.GA12487@redhat.com>
	<CA+55aFwi-S27_maZXU+baOqPAYfi_NTGcfbnRnk45+B8+i4hVQ@mail.gmail.com>
	<20140828111628.GB15276@redhat.com>
	<20140829181533.GA30659@redhat.com>
	<20140829181603.GB30659@redhat.com>
Date: Mon, 1 Sep 2014 23:43:21 -0700
Message-ID: <CALmL7E-9SQMqXvNpot0AyjnvNz9gUj33uirx01f3YyMGV1x0og@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86, fpu: introduce per-cpu "bool in_kernel_fpu"
From: Suresh Siddha <sbsiddha@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 11:16 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> interrupted_kernel_fpu_idle() tries to detect if kernel_fpu_begin()
> is safe or not. In particulat it should obviously deny the nested
> kernel_fpu_begin() and this logic doesn't look clean.
>
> If use_eager_fpu() == T we rely on a) __thread_has_fpu() check in
> interrupted_kernel_fpu_idle(), and b) on the fact that _begin() does
> __thread_clear_has_fpu().
>
> Otherwise we demand that the interrupted task has no FPU if it is in
> kernel mode, this works becase __kernel_fpu_begin() does clts().
>
> Add the per-cpu "bool in_kernel_fpu" variable, and change this code
> to check/set/clear it. This allows to do some cleanups (see the next
> changes) and fixes.
>
> Note that the current code looks racy. Say, kernel_fpu_begin() right
> after math_state_restore()->__thread_fpu_begin() will overwrite the
> regs we are going to restore. This patch doesn't even try to fix this,

yes indeed, explicit calls to math_state_restore() in eager_fpu case
has this race. I guess this is present from the commit 5187b28f.

thanks,
suresh


> it just adds the comment, but "in_kernel_fpu" can also be used to
> implement kernel_fpu_disable() / kernel_fpu_enable().
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/include/asm/i387.h |    2 +-
>  arch/x86/kernel/i387.c      |   10 ++++++++++
>  2 files changed, 11 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
> index ed8089d..5e275d3 100644
> --- a/arch/x86/include/asm/i387.h
> +++ b/arch/x86/include/asm/i387.h
> @@ -40,8 +40,8 @@ extern void __kernel_fpu_end(void);
>
>  static inline void kernel_fpu_begin(void)
>  {
> -       WARN_ON_ONCE(!irq_fpu_usable());
>         preempt_disable();
> +       WARN_ON_ONCE(!irq_fpu_usable());
>         __kernel_fpu_begin();
>  }
>
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index d5dd808..8fb8868 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -19,6 +19,8 @@
>  #include <asm/fpu-internal.h>
>  #include <asm/user.h>
>
> +static DEFINE_PER_CPU(bool, in_kernel_fpu);
> +
>  /*
>   * Were we in an interrupt that interrupted kernel mode?
>   *
> @@ -33,6 +35,9 @@
>   */
>  static inline bool interrupted_kernel_fpu_idle(void)
>  {
> +       if (this_cpu_read(in_kernel_fpu))
> +               return false;
> +
>         if (use_eager_fpu())
>                 return __thread_has_fpu(current);
>
> @@ -73,6 +78,9 @@ void __kernel_fpu_begin(void)
>  {
>         struct task_struct *me = current;
>
> +       this_cpu_write(in_kernel_fpu, true);
> +
> +       /* FIXME: race with math_state_restore()-like code */
>         if (__thread_has_fpu(me)) {
>                 __thread_clear_has_fpu(me);
>                 __save_init_fpu(me);
> @@ -99,6 +107,8 @@ void __kernel_fpu_end(void)
>         } else {
>                 stts();
>         }
> +
> +       this_cpu_write(in_kernel_fpu, false);
>  }
>  EXPORT_SYMBOL(__kernel_fpu_end);
>
> --
> 1.5.5.1
>
>
