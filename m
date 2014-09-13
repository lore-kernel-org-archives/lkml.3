Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaIMSKq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 14:10:46 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:58983 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaIMSKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 14:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140913143534.16912.9015.stgit@zurg>
References: <20140913143534.16912.9015.stgit@zurg>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 13 Sep 2014 11:10:24 -0700
Message-ID: <CACT4Y+Y_MZcWnxKMEz==CBdefcD2XPFVzDEysfBirL6eDWV+6Q@mail.gmail.com>
Subject: Re: [PATCH RFC] x86_64: per-cpu memory for user-space
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2014 at 7:35 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> This patch implements user-space per-cpu memory in the same manner as in
> kernel-space: each cpu has its own %gs base address. On x86_64 %fs is used
> for thread local storage, %gs usually is free.
>
> User-space application cannot prevent preemption but x86 read-modify-write
> operations are atomic against interrupts and context switches. Thus percpu
> counters, ring-buffer cursors, per-cpu locks and other cool things might
> be implemented in a very efficient way.
>
> After this patch kernel recalculates %gs at each context switch.
> This's implemented only via MSR_KERNEL_GS_BASE. Loading base via gdt
> selector might be faster but it's much more complicated.
>
> By the way, newer Intel cpus have even faster instructions for
> changing %fs/%gs, but they are still not supported by the kernel.
>
> Additional overhead is near to zero: this patch adds one extra multiplication
> into __switch_to (only if gs is set by user-space and its base is above 4Gb):
>
>         if (next->gs)
> -               wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
> +               wrmsrl(MSR_KERNEL_GS_BASE, next->gs +
> +                               cpu * next->gs_cpu_stride);
>
> Child inherits setup from parent at clone because it gets a copy of task_struct.
> Changing %gs via any other interface (selector, ARCH_SET_GS) disables striping.
>
> Interface:
>
> int arch_prctl(ARCH_GET_GS_PERCPU, unsigned long arg[2]);
> int arch_prctl(ARCH_SET_GS_PERCPU, unsigned long arg[2]);
>
> arg[0] - base address for cpu0
> arg[1] - stride to each next cpu
>
> Error codes:
> -EINVAL     - not implemented (or ia32 compat)
> -ENOENT     - not configured (only for get)
> -EFAULT     - arg isn't addressable
> -EPERM      - base above addressable space (only for set)
> -EOVERFLOW  - stride too big for this base and count nr_cpus (only for set)
>
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> ---
>  arch/x86/include/asm/processor.h  |    1 +
>  arch/x86/include/uapi/asm/prctl.h |    2 ++
>  arch/x86/kernel/process_64.c      |   39 ++++++++++++++++++++++++++++++++++++-
>  3 files changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index eb71ec7..102c1f9 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -484,6 +484,7 @@ struct thread_struct {
>  #endif
>  #ifdef CONFIG_X86_64
>         unsigned long           fs;
> +       unsigned long           gs_cpu_stride;
>  #endif
>         unsigned long           gs;
>         /* Save middle states of ptrace breakpoints */
> diff --git a/arch/x86/include/uapi/asm/prctl.h b/arch/x86/include/uapi/asm/prctl.h
> index 3ac5032..026bd39 100644
> --- a/arch/x86/include/uapi/asm/prctl.h
> +++ b/arch/x86/include/uapi/asm/prctl.h
> @@ -5,5 +5,7 @@
>  #define ARCH_SET_FS 0x1002
>  #define ARCH_GET_FS 0x1003
>  #define ARCH_GET_GS 0x1004
> +#define ARCH_SET_GS_PERCPU 0x1005
> +#define ARCH_GET_GS_PERCPU 0x1006
>
>  #endif /* _ASM_X86_PRCTL_H */
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index ca5b02d..5e7af75 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -351,7 +351,8 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
>                         prev->gs = 0;
>         }
>         if (next->gs)
> -               wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
> +               wrmsrl(MSR_KERNEL_GS_BASE, next->gs +
> +                               cpu * next->gs_cpu_stride);
>         prev->gsindex = gsindex;
>
>         switch_fpu_finish(next_p, fpu);
> @@ -469,6 +470,7 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
>                 if (addr >= TASK_SIZE_OF(task))
>                         return -EPERM;
>                 cpu = get_cpu();
> +               task->thread.gs_cpu_stride = 0;
>                 /* handle small bases via the GDT because that's faster to
>                    switch. */
>                 if (addr <= 0xffffffff) {
> @@ -544,6 +546,41 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
>                 ret = put_user(base, (unsigned long __user *)addr);
>                 break;
>         }
> +       case ARCH_GET_GS_PERCPU:
> +               if (test_tsk_thread_flag(task, TIF_ADDR32))
> +                       return -EINVAL;
> +               if (!task->thread.gs || !task->thread.gs_cpu_stride)
> +                       return -ENOENT;
> +               ret = put_user(task->thread.gs,
> +                               (unsigned long __user *)addr);
> +               if (!ret)
> +                       ret = put_user(task->thread.gs_cpu_stride,
> +                                       ((unsigned long __user *)addr) + 1);
> +               break;
> +       case ARCH_SET_GS_PERCPU: {
> +               unsigned long arg[2];
> +
> +               if (test_tsk_thread_flag(task, TIF_ADDR32))
> +                       return -EINVAL;
> +               if (copy_from_user(arg, (void __user *)addr, sizeof(arg)))
> +                       return -EFAULT;
> +               if (arg[0] >= TASK_SIZE_MAX)
> +                       return -EPERM;
> +               if (arg[1] > (TASK_SIZE_MAX - arg[0]) / num_possible_cpus())
> +                       return -EOVERFLOW;
> +
> +               task->thread.gsindex = 0;
> +               task->thread.gs = arg[0];
> +               task->thread.gs_cpu_stride = arg[1];
> +               if (doit) {
> +                       cpu = get_cpu();
> +                       load_gs_index(0);
> +                       ret = wrmsrl_safe(MSR_KERNEL_GS_BASE,
> +                                         arg[0] + cpu * arg[1]);
> +                       put_cpu();
> +               }
> +               break;
> +       }
>
>         default:
>                 ret = -EINVAL;
>



Nice!

Per-cpu non-lossy stats counters are trivial with this support.

For more complex data structures the trick is to put cpu number in the
per-cpu region of memory, and use CAS-loop to modify the data (but the
CAS does not need LOCK prefix in this case). For example, here is how
a lock-free per-cpu freelist can be implemented:

struct freelist_t
{
        void*   head;
        uint16  cpu;
        uint16  len;
        uint32  aba;
};

bool freelist_push(void *p)
{
        freelist_t *fl, old, new;

        for (;;) {
                fl = (freelist_t*)&GS[OFF];
                old = atomic_load(fl);
                if (old.len == UINT16_MAX)
                        return false;
                *(void**)p = old.head;
                new = old;
                new.aba++;
                new.len++;
                new.head = p;
                if (CMPXCHG16B(fl, old, new))
                        return true;
        }
}

void *freelist_pop(void)
{
        freelist_t *fl, old, new;
        void *p;

        for (;;) {
                fl = (freelist_t*)&GS[OFF];
                old = atomic_load(fl);
                if (old.len == 0)
                        return NULL;
                p = old.head;
                new = old;
                new.len--;
                new.head = *(void**)p;
                if (CMPXCHG16B(fl, old, new))
                        return p;
        }
}
