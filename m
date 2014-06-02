Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaFBRJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:09:50 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:37497 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbaFBRJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <0d75554db5eab82852470f82d984c096d93bd61f.1401486790.git.luto@amacapital.net>
References: <cover.1401486790.git.luto@amacapital.net> <0d75554db5eab82852470f82d984c096d93bd61f.1401486790.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 2 Jun 2014 10:09:28 -0700
Message-ID: <CALCETrV4ML3rrN3ODs2MtZstL+9_oD=YWXThFg9R+-DGpOMx0g@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86,syscall: Add syscall_in_syscall to test whether
 we're in a syscall
To: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        linux-audit@redhat.com, Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 30, 2014 2:58 PM, "Andy Lutomirski" <luto@amacapital.net> wrote:
>
> syscall_in_syscall will return true if we're in a real syscall and
> will return false if we're not in a syscall.  If we're in a bad
> syscall, the return value can vary.
>
> The idea is to use this to come up with a much simpler replacement
> for syscall auditing.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/Kconfig               |  1 +
>  arch/x86/include/asm/syscall.h | 21 +++++++++++++++++++++
>  init/Kconfig                   |  3 +++
>  3 files changed, 25 insertions(+)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 25d2c6f..e2602d4 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -130,6 +130,7 @@ config X86
>         select HAVE_CC_STACKPROTECTOR
>         select GENERIC_CPU_AUTOPROBE
>         select HAVE_ARCH_AUDITSYSCALL
> +       select HAVE_SYSCALL_IN_SYSCALL
>
>  config INSTRUCTION_DECODER
>         def_bool y
> diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
> index d6a756a..91e38b3 100644
> --- a/arch/x86/include/asm/syscall.h
> +++ b/arch/x86/include/asm/syscall.h
> @@ -23,6 +23,27 @@
>  typedef void (*sys_call_ptr_t)(void);
>  extern const sys_call_ptr_t sys_call_table[];
>
> +/**
> + * syscall_in_syscall() - are we in a syscall context?
> + * @task: The task to query.
> + * @regs: The task's pt_regs.
> + *
> + * This checks whether we are in a syscall.  If it returns true, then
> + * syscall_get_nr(), etc are usable and the current task is guaranteed
> + * to either die or to go through the syscall exit path when the syscall
> + * is done.
> + *
> + * If it returns false, no particular guarantees are made.  In
> + * particular, a malicious task can issue a syscall that causes
> + * syscall_in_syscall to return false.  Such a syscall won't do much,
> + * but it can still cause tracing code and such to run.
> + */
> +static inline bool syscall_in_syscall(struct task_struct *task,
> +                                     struct pt_regs *regs)
> +{
> +       return regs->orig_ax != -1;

This is insufficient: anything that interrupts an errorentry too early
will incorrectly return true.  Also, the actual IRQ entries seem to
shove the IRQ number into orig_ax.

I'll send a new version.

--Andy
