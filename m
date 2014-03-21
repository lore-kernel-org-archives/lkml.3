Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaCURiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbaCURiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:38:03 -0400
Date: Fri, 21 Mar 2014 13:37:23 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-audit@redhat.com, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, linux-s390@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux390@de.ibm.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] syscall_get_arch: remove useless function arguments
Message-ID: <20140321173723.GA16467@madcap2.tricolour.ca>
References: <1394573578-2558-1-git-send-email-eparis@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394573578-2558-1-git-send-email-eparis@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/11, Eric Paris wrote:
> Every caller of syscall_get_arch() uses current for the task and no
> implementors of the function need args.  So just get rid of both of
> those things.  Admittedly, since these are inline functions we aren't
> wasting stack space, but it just makes the prototypes better.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-mips@linux-mips.org
> Cc: linux390@de.ibm.com
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: linux-arch@vger.kernel.org

Acked-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  arch/arm/include/asm/syscall.h  | 3 +--
>  arch/mips/include/asm/syscall.h | 2 +-
>  arch/mips/kernel/ptrace.c       | 2 +-
>  arch/s390/include/asm/syscall.h | 5 ++---
>  arch/x86/include/asm/syscall.h  | 8 +++-----
>  include/asm-generic/syscall.h   | 4 +---
>  kernel/seccomp.c                | 4 ++--
>  7 files changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
> index 73ddd72..ed805f1 100644
> --- a/arch/arm/include/asm/syscall.h
> +++ b/arch/arm/include/asm/syscall.h
> @@ -103,8 +103,7 @@ static inline void syscall_set_arguments(struct task_struct *task,
>  	memcpy(&regs->ARM_r0 + i, args, n * sizeof(args[0]));
>  }
>  
> -static inline int syscall_get_arch(struct task_struct *task,
> -				   struct pt_regs *regs)
> +static inline int syscall_get_arch(void)
>  {
>  	/* ARM tasks don't change audit architectures on the fly. */
>  	return AUDIT_ARCH_ARM;
> diff --git a/arch/mips/include/asm/syscall.h b/arch/mips/include/asm/syscall.h
> index 81c8913..625e709 100644
> --- a/arch/mips/include/asm/syscall.h
> +++ b/arch/mips/include/asm/syscall.h
> @@ -101,7 +101,7 @@ extern const unsigned long sys_call_table[];
>  extern const unsigned long sys32_call_table[];
>  extern const unsigned long sysn32_call_table[];
>  
> -static inline int __syscall_get_arch(void)
> +static inline int syscall_get_arch(void)
>  {
>  	int arch = EM_MIPS;
>  #ifdef CONFIG_64BIT
> diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
> index b52e1d2..65ba622 100644
> --- a/arch/mips/kernel/ptrace.c
> +++ b/arch/mips/kernel/ptrace.c
> @@ -671,7 +671,7 @@ asmlinkage void syscall_trace_enter(struct pt_regs *regs)
>  	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
>  		trace_sys_enter(regs, regs->regs[2]);
>  
> -	audit_syscall_entry(__syscall_get_arch(),
> +	audit_syscall_entry(syscall_get_arch(),
>  			    regs->regs[2],
>  			    regs->regs[4], regs->regs[5],
>  			    regs->regs[6], regs->regs[7]);
> diff --git a/arch/s390/include/asm/syscall.h b/arch/s390/include/asm/syscall.h
> index cd29d2f..bebc0bd 100644
> --- a/arch/s390/include/asm/syscall.h
> +++ b/arch/s390/include/asm/syscall.h
> @@ -89,11 +89,10 @@ static inline void syscall_set_arguments(struct task_struct *task,
>  		regs->orig_gpr2 = args[0];
>  }
>  
> -static inline int syscall_get_arch(struct task_struct *task,
> -				   struct pt_regs *regs)
> +static inline int syscall_get_arch(void)
>  {
>  #ifdef CONFIG_COMPAT
> -	if (test_tsk_thread_flag(task, TIF_31BIT))
> +	if (test_tsk_thread_flag(current, TIF_31BIT))
>  		return AUDIT_ARCH_S390;
>  #endif
>  	return sizeof(long) == 8 ? AUDIT_ARCH_S390X : AUDIT_ARCH_S390;
> diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
> index aea284b..7e6d0c4 100644
> --- a/arch/x86/include/asm/syscall.h
> +++ b/arch/x86/include/asm/syscall.h
> @@ -91,8 +91,7 @@ static inline void syscall_set_arguments(struct task_struct *task,
>  	memcpy(&regs->bx + i, args, n * sizeof(args[0]));
>  }
>  
> -static inline int syscall_get_arch(struct task_struct *task,
> -				   struct pt_regs *regs)
> +static inline int syscall_get_arch(void)
>  {
>  	return AUDIT_ARCH_I386;
>  }
> @@ -221,8 +220,7 @@ static inline void syscall_set_arguments(struct task_struct *task,
>  		}
>  }
>  
> -static inline int syscall_get_arch(struct task_struct *task,
> -				   struct pt_regs *regs)
> +static inline int syscall_get_arch(void)
>  {
>  #ifdef CONFIG_IA32_EMULATION
>  	/*
> @@ -234,7 +232,7 @@ static inline int syscall_get_arch(struct task_struct *task,
>  	 *
>  	 * x32 tasks should be considered AUDIT_ARCH_X86_64.
>  	 */
> -	if (task_thread_info(task)->status & TS_COMPAT)
> +	if (task_thread_info(current)->status & TS_COMPAT)
>  		return AUDIT_ARCH_I386;
>  #endif
>  	/* Both x32 and x86_64 are considered "64-bit". */
> diff --git a/include/asm-generic/syscall.h b/include/asm-generic/syscall.h
> index 5b09392..d401e54 100644
> --- a/include/asm-generic/syscall.h
> +++ b/include/asm-generic/syscall.h
> @@ -144,8 +144,6 @@ void syscall_set_arguments(struct task_struct *task, struct pt_regs *regs,
>  
>  /**
>   * syscall_get_arch - return the AUDIT_ARCH for the current system call
> - * @task:	task of interest, must be in system call entry tracing
> - * @regs:	task_pt_regs() of @task
>   *
>   * Returns the AUDIT_ARCH_* based on the system call convention in use.
>   *
> @@ -155,5 +153,5 @@ void syscall_set_arguments(struct task_struct *task, struct pt_regs *regs,
>   * Architectures which permit CONFIG_HAVE_ARCH_SECCOMP_FILTER must
>   * provide an implementation of this.
>   */
> -int syscall_get_arch(struct task_struct *task, struct pt_regs *regs);
> +int syscall_get_arch(void);
>  #endif	/* _ASM_SYSCALL_H */
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index b7a1004..eda2da3 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -95,7 +95,7 @@ u32 seccomp_bpf_load(int off)
>  	if (off == BPF_DATA(nr))
>  		return syscall_get_nr(current, regs);
>  	if (off == BPF_DATA(arch))
> -		return syscall_get_arch(current, regs);
> +		return syscall_get_arch();
>  	if (off >= BPF_DATA(args[0]) && off < BPF_DATA(args[6])) {
>  		unsigned long value;
>  		int arg = (off - BPF_DATA(args[0])) / sizeof(u64);
> @@ -351,7 +351,7 @@ static void seccomp_send_sigsys(int syscall, int reason)
>  	info.si_code = SYS_SECCOMP;
>  	info.si_call_addr = (void __user *)KSTK_EIP(current);
>  	info.si_errno = reason;
> -	info.si_arch = syscall_get_arch(current, task_pt_regs(current));
> +	info.si_arch = syscall_get_arch();
>  	info.si_syscall = syscall;
>  	force_sig_info(SIGSYS, &info, current);
>  }
> -- 
> 1.8.5.3
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
