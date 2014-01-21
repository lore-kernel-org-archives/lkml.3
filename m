Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaAUOhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:37:04 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:56894 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbaAUOg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:36:58 -0500
MIME-Version: 1.0
In-Reply-To: <20131217123352.692059839@infradead.org>
References: <20131217122720.950475833@infradead.org> <20131217123352.692059839@infradead.org>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 21 Jan 2014 15:36:37 +0100
X-Google-Sender-Auth: usfsKdxtZNSO3Ljp73eCYhIsqts
Message-ID: <CAHO5Pa3=+Zhg72tVfddSUvgirUyObir6atJVo4_16bVWB2Osgw@mail.gmail.com>
Subject: Re: [PATCH 01/13] sched: Add 3 new scheduler syscalls to support an
 extended scheduling parameters ABI
To: Peter Zijlstra <peterz@infradead.org>, Dario Faggioli <raistlin@linux.it>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, Linux Kernel <linux-kernel@vger.kernel.org>,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Dario,


On Tue, Dec 17, 2013 at 1:27 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> From: Dario Faggioli <raistlin@linux.it>
>
> Add the syscalls needed for supporting scheduling algorithms
> with extended scheduling parameters (e.g., SCHED_DEADLINE).
>
> In general, it makes possible to specify a periodic/sporadic task,
> that executes for a given amount of runtime at each instance, and is
> scheduled according to the urgency of their own timing constraints,
> i.e.:
>
>  - a (maximum/typical) instance execution time,
>  - a minimum interval between consecutive instances,
>  - a time constraint by which each instance must be completed.
>
> Thus, both the data structure that holds the scheduling parameters of
> the tasks and the system calls dealing with it must be extended.
> Unfortunately, modifying the existing struct sched_param would break
> the ABI and result in potentially serious compatibility issues with
> legacy binaries.
>
> For these reasons, this patch:
>
>  - defines the new struct sched_attr, containing all the fields
>    that are necessary for specifying a task in the computational
>    model described above;
>  - defines and implements the new scheduling related syscalls that
>    manipulate it, i.e., sched_setscheduler2(), sched_setattr()
>    and sched_getattr().

Is someone (e.g., one of you) planning to write man pages for the new
sched_setattr() and sched_getattr() system calls? (Also, for the
future, please CC linux-api@vger.kernel.org on patches that change the
API, then those of us who don't follow LKML get a heads up about
upcoming API changes.)

Thanks,

Michael


> Syscalls are introduced for x86 (32 and 64 bits) and ARM only, as a
> proof of concept and for developing and testing purposes. Making them
> available on other architectures is straightforward.
>
> Since no "user" for these new parameters is introduced in this patch,
> the implementation of the new system calls is just identical to their
> already existing counterpart. Future patches that implement scheduling
> policies able to exploit the new data structure must also take care of
> modifying the sched_*attr() calls accordingly with their own purposes.
>
> Cc: oleg@redhat.com
> Cc: darren@dvhart.com
> Cc: paulmck@linux.vnet.ibm.com
> Cc: dhaval.giani@gmail.com
> Cc: p.faure@akatech.ch
> Cc: fchecconi@gmail.com
> Cc: fweisbec@gmail.com
> Cc: harald.gustafsson@ericsson.com
> Cc: hgu1972@gmail.com
> Cc: insop.song@gmail.com
> Cc: rostedt@goodmis.org
> Cc: jkacur@redhat.com
> Cc: tommaso.cucinotta@sssup.it
> Cc: johan.eker@ericsson.com
> Cc: vincent.guittot@linaro.org
> Cc: liming.wang@windriver.com
> Cc: luca.abeni@unitn.it
> Cc: michael@amarulasolutions.com
> Cc: bruce.ashfield@windriver.com
> Cc: nicola.manica@disi.unitn.it
> Cc: claudio@evidence.eu.com
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
> [ Twiddled the changelog. ]
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/arm/include/asm/unistd.h      |    2
>  arch/arm/include/uapi/asm/unistd.h |    3
>  arch/arm/kernel/calls.S            |    3
>  arch/x86/syscalls/syscall_32.tbl   |    3
>  arch/x86/syscalls/syscall_64.tbl   |    3
>  include/linux/sched.h              |   54 ++++++++
>  include/linux/syscalls.h           |    8 +
>  kernel/sched/core.c                |  234 +++++++++++++++++++++++++++++++++++--
>  8 files changed, 298 insertions(+), 12 deletions(-)
>
> --- a/arch/arm/include/asm/unistd.h
> +++ b/arch/arm/include/asm/unistd.h
> @@ -15,7 +15,7 @@
>
>  #include <uapi/asm/unistd.h>
>
> -#define __NR_syscalls  (380)
> +#define __NR_syscalls  (383)
>  #define __ARM_NR_cmpxchg               (__ARM_NR_BASE+0x00fff0)
>
>  #define __ARCH_WANT_STAT64
> --- a/arch/arm/include/uapi/asm/unistd.h
> +++ b/arch/arm/include/uapi/asm/unistd.h
> @@ -406,6 +406,9 @@
>  #define __NR_process_vm_writev         (__NR_SYSCALL_BASE+377)
>  #define __NR_kcmp                      (__NR_SYSCALL_BASE+378)
>  #define __NR_finit_module              (__NR_SYSCALL_BASE+379)
> +#define __NR_sched_setscheduler2       (__NR_SYSCALL_BASE+380)
> +#define __NR_sched_setattr             (__NR_SYSCALL_BASE+381)
> +#define __NR_sched_getattr             (__NR_SYSCALL_BASE+382)
>
>  /*
>   * This may need to be greater than __NR_last_syscall+1 in order to
> --- a/arch/arm/kernel/calls.S
> +++ b/arch/arm/kernel/calls.S
> @@ -389,6 +389,9 @@
>                 CALL(sys_process_vm_writev)
>                 CALL(sys_kcmp)
>                 CALL(sys_finit_module)
> +/* 380 */      CALL(sys_sched_setscheduler2)
> +               CALL(sys_sched_setattr)
> +               CALL(sys_sched_getattr)
>  #ifndef syscalls_counted
>  .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
>  #define syscalls_counted
> --- a/arch/x86/syscalls/syscall_32.tbl
> +++ b/arch/x86/syscalls/syscall_32.tbl
> @@ -357,3 +357,6 @@
>  348    i386    process_vm_writev       sys_process_vm_writev           compat_sys_process_vm_writev
>  349    i386    kcmp                    sys_kcmp
>  350    i386    finit_module            sys_finit_module
> +351    i386    sched_setattr           sys_sched_setattr
> +352    i386    sched_getattr           sys_sched_getattr
> +353    i386    sched_setscheduler2     sys_sched_setscheduler2
> --- a/arch/x86/syscalls/syscall_64.tbl
> +++ b/arch/x86/syscalls/syscall_64.tbl
> @@ -320,6 +320,9 @@
>  311    64      process_vm_writev       sys_process_vm_writev
>  312    common  kcmp                    sys_kcmp
>  313    common  finit_module            sys_finit_module
> +314    common  sched_setattr           sys_sched_setattr
> +315    common  sched_getattr           sys_sched_getattr
> +316    common  sched_setscheduler2     sys_sched_setscheduler2
>
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -56,6 +56,58 @@ struct sched_param {
>
>  #include <asm/processor.h>
>
> +#define SCHED_ATTR_SIZE_VER0   40      /* sizeof first published struct */
> +
> +/*
> + * Extended scheduling parameters data structure.
> + *
> + * This is needed because the original struct sched_param can not be
> + * altered without introducing ABI issues with legacy applications
> + * (e.g., in sched_getparam()).
> + *
> + * However, the possibility of specifying more than just a priority for
> + * the tasks may be useful for a wide variety of application fields, e.g.,
> + * multimedia, streaming, automation and control, and many others.
> + *
> + * This variant (sched_attr) is meant at describing a so-called
> + * sporadic time-constrained task. In such model a task is specified by:
> + *  - the activation period or minimum instance inter-arrival time;
> + *  - the maximum (or average, depending on the actual scheduling
> + *    discipline) computation time of all instances, a.k.a. runtime;
> + *  - the deadline (relative to the actual activation time) of each
> + *    instance.
> + * Very briefly, a periodic (sporadic) task asks for the execution of
> + * some specific computation --which is typically called an instance--
> + * (at most) every period. Moreover, each instance typically lasts no more
> + * than the runtime and must be completed by time instant t equal to
> + * the instance activation time + the deadline.
> + *
> + * This is reflected by the actual fields of the sched_attr structure:
> + *
> + *  @sched_priority     task's priority (might still be useful)
> + *  @sched_flags        for customizing the scheduler behaviour
> + *  @sched_deadline     representative of the task's deadline
> + *  @sched_runtime      representative of the task's runtime
> + *  @sched_period       representative of the task's period
> + *
> + * Given this task model, there are a multiplicity of scheduling algorithms
> + * and policies, that can be used to ensure all the tasks will make their
> + * timing constraints.
> + *
> + *  @size              size of the structure, for fwd/bwd compat.
> + */
> +struct sched_attr {
> +       int sched_priority;
> +       unsigned int sched_flags;
> +       u64 sched_runtime;
> +       u64 sched_deadline;
> +       u64 sched_period;
> +       u32 size;
> +
> +       /* Align to u64. */
> +       u32 __reserved;
> +};
> +
>  struct exec_domain;
>  struct futex_pi_state;
>  struct robust_list_head;
> @@ -1960,6 +2012,8 @@ extern int sched_setscheduler(struct tas
>                               const struct sched_param *);
>  extern int sched_setscheduler_nocheck(struct task_struct *, int,
>                                       const struct sched_param *);
> +extern int sched_setscheduler2(struct task_struct *, int,
> +                                const struct sched_attr *);
>  extern struct task_struct *idle_task(int cpu);
>  /**
>   * is_idle_task - is the specified task an idle task?
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -38,6 +38,7 @@ struct rlimit;
>  struct rlimit64;
>  struct rusage;
>  struct sched_param;
> +struct sched_attr;
>  struct sel_arg_struct;
>  struct semaphore;
>  struct sembuf;
> @@ -277,11 +278,18 @@ asmlinkage long sys_clock_nanosleep(cloc
>  asmlinkage long sys_nice(int increment);
>  asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
>                                         struct sched_param __user *param);
> +asmlinkage long sys_sched_setscheduler2(pid_t pid, int policy,
> +                                       struct sched_attr __user *attr);
>  asmlinkage long sys_sched_setparam(pid_t pid,
>                                         struct sched_param __user *param);
> +asmlinkage long sys_sched_setattr(pid_t pid,
> +                                       struct sched_attr __user *attr);
>  asmlinkage long sys_sched_getscheduler(pid_t pid);
>  asmlinkage long sys_sched_getparam(pid_t pid,
>                                         struct sched_param __user *param);
> +asmlinkage long sys_sched_getattr(pid_t pid,
> +                                       struct sched_attr __user *attr,
> +                                       unsigned int size);
>  asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
>                                         unsigned long __user *user_mask_ptr);
>  asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3023,7 +3023,8 @@ static bool check_same_owner(struct task
>  }
>
>  static int __sched_setscheduler(struct task_struct *p, int policy,
> -                               const struct sched_param *param, bool user)
> +                               const struct sched_attr *attr,
> +                               bool user)
>  {
>         int retval, oldprio, oldpolicy = -1, on_rq, running;
>         unsigned long flags;
> @@ -3053,11 +3054,11 @@ static int __sched_setscheduler(struct t
>          * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
>          * SCHED_BATCH and SCHED_IDLE is 0.
>          */
> -       if (param->sched_priority < 0 ||
> -           (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
> -           (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
> +       if (attr->sched_priority < 0 ||
> +           (p->mm && attr->sched_priority > MAX_USER_RT_PRIO-1) ||
> +           (!p->mm && attr->sched_priority > MAX_RT_PRIO-1))
>                 return -EINVAL;
> -       if (rt_policy(policy) != (param->sched_priority != 0))
> +       if (rt_policy(policy) != (attr->sched_priority != 0))
>                 return -EINVAL;
>
>         /*
> @@ -3073,8 +3074,8 @@ static int __sched_setscheduler(struct t
>                                 return -EPERM;
>
>                         /* can't increase priority */
> -                       if (param->sched_priority > p->rt_priority &&
> -                           param->sched_priority > rlim_rtprio)
> +                       if (attr->sched_priority > p->rt_priority &&
> +                           attr->sched_priority > rlim_rtprio)
>                                 return -EPERM;
>                 }
>
> @@ -3123,7 +3124,7 @@ static int __sched_setscheduler(struct t
>          * If not changing anything there's no need to proceed further:
>          */
>         if (unlikely(policy == p->policy && (!rt_policy(policy) ||
> -                       param->sched_priority == p->rt_priority))) {
> +                    attr->sched_priority == p->rt_priority))) {
>                 task_rq_unlock(rq, p, &flags);
>                 return 0;
>         }
> @@ -3160,7 +3161,7 @@ static int __sched_setscheduler(struct t
>
>         oldprio = p->prio;
>         prev_class = p->sched_class;
> -       __setscheduler(rq, p, policy, param->sched_priority);
> +       __setscheduler(rq, p, policy, attr->sched_priority);
>
>         if (running)
>                 p->sched_class->set_curr_task(rq);
> @@ -3188,10 +3189,20 @@ static int __sched_setscheduler(struct t
>  int sched_setscheduler(struct task_struct *p, int policy,
>                        const struct sched_param *param)
>  {
> -       return __sched_setscheduler(p, policy, param, true);
> +       struct sched_attr attr = {
> +               .sched_priority = param->sched_priority
> +       };
> +       return __sched_setscheduler(p, policy, &attr, true);
>  }
>  EXPORT_SYMBOL_GPL(sched_setscheduler);
>
> +int sched_setscheduler2(struct task_struct *p, int policy,
> +                       const struct sched_attr *attr)
> +{
> +       return __sched_setscheduler(p, policy, attr, true);
> +}
> +EXPORT_SYMBOL_GPL(sched_setscheduler2);
> +
>  /**
>   * sched_setscheduler_nocheck - change the scheduling policy and/or RT priority of a thread from kernelspace.
>   * @p: the task in question.
> @@ -3208,7 +3219,10 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
>  int sched_setscheduler_nocheck(struct task_struct *p, int policy,
>                                const struct sched_param *param)
>  {
> -       return __sched_setscheduler(p, policy, param, false);
> +       struct sched_attr attr = {
> +               .sched_priority = param->sched_priority
> +       };
> +       return __sched_setscheduler(p, policy, &attr, false);
>  }
>
>  static int
> @@ -3233,6 +3247,97 @@ do_sched_setscheduler(pid_t pid, int pol
>         return retval;
>  }
>
> +/*
> + * Mimics kernel/events/core.c perf_copy_attr().
> + */
> +static int sched_copy_attr(struct sched_attr __user *uattr,
> +                          struct sched_attr *attr)
> +{
> +       u32 size;
> +       int ret;
> +
> +       if (!access_ok(VERIFY_WRITE, uattr, SCHED_ATTR_SIZE_VER0))
> +               return -EFAULT;
> +
> +       /*
> +        * zero the full structure, so that a short copy will be nice.
> +        */
> +       memset(attr, 0, sizeof(*attr));
> +
> +       ret = get_user(size, &uattr->size);
> +       if (ret)
> +               return ret;
> +
> +       if (size > PAGE_SIZE)   /* silly large */
> +               goto err_size;
> +
> +       if (!size)              /* abi compat */
> +               size = SCHED_ATTR_SIZE_VER0;
> +
> +       if (size < SCHED_ATTR_SIZE_VER0)
> +               goto err_size;
> +
> +       /*
> +        * If we're handed a bigger struct than we know of,
> +        * ensure all the unknown bits are 0 - i.e. new
> +        * user-space does not rely on any kernel feature
> +        * extensions we dont know about yet.
> +        */
> +       if (size > sizeof(*attr)) {
> +               unsigned char __user *addr;
> +               unsigned char __user *end;
> +               unsigned char val;
> +
> +               addr = (void __user *)uattr + sizeof(*attr);
> +               end  = (void __user *)uattr + size;
> +
> +               for (; addr < end; addr++) {
> +                       ret = get_user(val, addr);
> +                       if (ret)
> +                               return ret;
> +                       if (val)
> +                               goto err_size;
> +               }
> +               size = sizeof(*attr);
> +       }
> +
> +       ret = copy_from_user(attr, uattr, size);
> +       if (ret)
> +               return -EFAULT;
> +
> +out:
> +       return ret;
> +
> +err_size:
> +       put_user(sizeof(*attr), &uattr->size);
> +       ret = -E2BIG;
> +       goto out;
> +}
> +
> +static int
> +do_sched_setscheduler2(pid_t pid, int policy,
> +                      struct sched_attr __user *attr_uptr)
> +{
> +       struct sched_attr attr;
> +       struct task_struct *p;
> +       int retval;
> +
> +       if (!attr_uptr || pid < 0)
> +               return -EINVAL;
> +
> +       if (sched_copy_attr(attr_uptr, &attr))
> +               return -EFAULT;
> +
> +       rcu_read_lock();
> +       retval = -ESRCH;
> +       p = find_process_by_pid(pid);
> +       if (p != NULL)
> +               retval = sched_setscheduler2(p, policy, &attr);
> +       rcu_read_unlock();
> +
> +       return retval;
> +}
> +
>  /**
>   * sys_sched_setscheduler - set/change the scheduler policy and RT priority
>   * @pid: the pid in question.
> @@ -3252,6 +3357,21 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_
>  }
>
>  /**
> + * sys_sched_setscheduler2 - same as above, but with extended sched_param
> + * @pid: the pid in question.
> + * @policy: new policy (could use extended sched_param).
> + * @attr: structure containg the extended parameters.
> + */
> +SYSCALL_DEFINE3(sched_setscheduler2, pid_t, pid, int, policy,
> +               struct sched_attr __user *, attr)
> +{
> +       if (policy < 0)
> +               return -EINVAL;
> +
> +       return do_sched_setscheduler2(pid, policy, attr);
> +}
> +
> +/**
>   * sys_sched_setparam - set/change the RT priority of a thread
>   * @pid: the pid in question.
>   * @param: structure containing the new RT priority.
> @@ -3264,6 +3384,17 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, p
>  }
>
>  /**
> + * sys_sched_setattr - same as above, but with extended sched_attr
> + * @pid: the pid in question.
> + * @attr: structure containing the extended parameters.
> + */
> +SYSCALL_DEFINE2(sched_setattr, pid_t, pid,
> +               struct sched_attr __user *, attr)
> +{
> +       return do_sched_setscheduler2(pid, -1, attr);
> +}
> +
> +/**
>   * sys_sched_getscheduler - get the policy (scheduling class) of a thread
>   * @pid: the pid in question.
>   *
> @@ -3329,6 +3460,87 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, p
>         return retval;
>
>  out_unlock:
> +       rcu_read_unlock();
> +       return retval;
> +}
> +
> +static int sched_read_attr(struct sched_attr __user *uattr,
> +                          struct sched_attr *attr,
> +                          unsigned int usize)
> +{
> +       int ret;
> +
> +       if (!access_ok(VERIFY_WRITE, uattr, usize))
> +               return -EFAULT;
> +
> +       /*
> +        * If we're handed a smaller struct than we know of,
> +        * ensure all the unknown bits are 0 - i.e. old
> +        * user-space does not get uncomplete information.
> +        */
> +       if (usize < sizeof(*attr)) {
> +               unsigned char *addr;
> +               unsigned char *end;
> +
> +               addr = (void *)attr + usize;
> +               end  = (void *)attr + sizeof(*attr);
> +
> +               for (; addr < end; addr++) {
> +                       if (*addr)
> +                               goto err_size;
> +               }
> +
> +               attr->size = usize;
> +       }
> +
> +       ret = copy_to_user(uattr, attr, usize);
> +       if (ret)
> +               return -EFAULT;
> +
> +out:
> +       return ret;
> +
> +err_size:
> +       ret = -E2BIG;
> +       goto out;
> +}
> +
> +/**
> + * sys_sched_getattr - same as above, but with extended "sched_param"
> + * @pid: the pid in question.
> + * @attr: structure containing the extended parameters.
> + * @size: sizeof(attr) for fwd/bwd comp.
> + */
> +SYSCALL_DEFINE3(sched_getattr, pid_t, pid, struct sched_attr __user *, uattr,
> +               unsigned int, size)
> +{
> +       struct sched_attr attr = {
> +               .size = sizeof(struct sched_attr),
> +       };
> +       struct task_struct *p;
> +       int retval;
> +
> +       if (!uattr || pid < 0 || size > PAGE_SIZE ||
> +           size < SCHED_ATTR_SIZE_VER0)
> +               return -EINVAL;
> +
> +       rcu_read_lock();
> +       p = find_process_by_pid(pid);
> +       retval = -ESRCH;
> +       if (!p)
> +               goto out_unlock;
> +
> +       retval = security_task_getscheduler(p);
> +       if (retval)
> +               goto out_unlock;
> +
> +       attr.sched_priority = p->rt_priority;
> +       rcu_read_unlock();
> +
> +       retval = sched_read_attr(uattr, &attr, size);
> +       return retval;
> +
> +out_unlock:
>         rcu_read_unlock();
>         return retval;
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
