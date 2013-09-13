Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3IMGSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 02:18:52 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61255 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3IMGSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 02:18:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130911143102.GA8825@darko.cambridge.arm.com>
References: <1378762380-13152-1-git-send-email-apinski@cavium.com>
	<1378762380-13152-5-git-send-email-apinski@cavium.com>
	<20130911143102.GA8825@darko.cambridge.arm.com>
Date: Thu, 12 Sep 2013 23:18:48 -0700
Message-ID: <CA+=Sn1nd3Ym8so_=SP4NC1fjKWn4dNPYvz4OZMo0tLZptF8KVw@mail.gmail.com>
Subject: Re: [PATCH 5/5] ARM64: Add support for ILP32 ABI.
From: Andrew Pinski <pinskia@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Andrew Pinski <apinski@cavium.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 7:32 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Mon, Sep 09, 2013 at 10:32:59PM +0100, Andrew Pinski wrote:
>> This patch adds full support of the ABI to the ARM64 target.
>
> This description is too short. Please describe what the ABI is, what are
> the commonalities with AArch64 and AArch32, what other non-obvious
> things had to be done (like __kernel_long_t being long long). Split this
> patch into multiple patches like base syscall handling, signal handling,
> pselect6/ppoll, vdso etc. It's too much to review at once.

Ok. I will do so after my vacation next week.

>
> On top of these, I would really like to see
> Documentation/arm64/ilp32.txt describing the ABI.

No other target does not, not even x86_64 for x32.

>
> I would also like to know (you can state this in the cover letter) the
> level of testing for all 3 types of ABI. I'm worried that at least this
> patch breaks the current compat ABI (has LTP reported anything?).

We did test LTP on an earlier version of this patch for all three
ABIs, I will make sure that the next version I send out is tested on
all three ABIs also.  We also tested ILP32/LP64 on big-endian at the
same time which we will continue to do (I should push for our team
here to push out the big-endian patches).

>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index cc64df5..7fdc994 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -248,7 +248,7 @@ source "fs/Kconfig.binfmt"
>>
>>  config COMPAT
>>         def_bool y
>> -       depends on ARM64_AARCH32
>> +       depends on ARM64_AARCH32 || ARM64_ILP32
>>         select COMPAT_BINFMT_ELF
>>
>>  config ARM64_AARCH32
>> @@ -263,7 +263,14 @@ config ARM64_AARCH32
>>           the user helper functions, VFP support and the ptrace interface are
>>           handled appropriately by the kernel.
>>
>> -         If you want to execute 32-bit userspace applications, say Y.
>> +         If you want to execute Aarch32 userspace applications, say Y.
>> +
>> +config ARM64_ILP32
>> +       bool "Kernel support for ILP32"
>> +       help
>> +         This option enables support for AArch64 ILP32 user space.  These are
>> +         64-bit binaries using 32-bit quantities for addressing and certain
>> +         data that would normally be 64-bit.
>
> You could be even more precise by mentioning that longs and pointers are
> 32-bit, together with the derived types.

I copied this from the MIPS64 n32 description in Kconfig.  But I will
make it more explicit.

>
>> diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
>> index 5ab2676..91bcf13 100644
>> --- a/arch/arm64/include/asm/compat.h
>> +++ b/arch/arm64/include/asm/compat.h
>> @@ -62,6 +62,8 @@ typedef u32           compat_ulong_t;
>>  typedef u64            compat_u64;
>>  typedef u32            compat_uptr_t;
>>
>> +typedef s64            ilp32_clock_t;
>> +
>>  struct compat_timespec {
>>         compat_time_t   tv_sec;
>>         s32             tv_nsec;
>> @@ -180,6 +182,15 @@ typedef struct compat_siginfo {
>>                         compat_clock_t _stime;
>>                 } _sigchld;
>>
>> +               /* SIGCHLD (ILP32 version) */
>> +               struct {
>> +                       compat_pid_t _pid;      /* which child */
>> +                       __compat_uid32_t _uid;  /* sender's uid */
>> +                       int _status;            /* exit code */
>> +                       ilp32_clock_t _utime;
>> +                       ilp32_clock_t _stime;
>> +               } _sigchld_ilp32;
>
> This *breaks* the compat_siginfo alignment. ilp32_clock_t is 64-bit
> which forces the _sigchld_ilp32 to be 64-bit which makes the preamble 16
> instead of 12 bytes. This ilp32_clock_t needs
> __attribute__((aligned(4))).

I will check on this.

>
> The other approach I've been looking at is just using the native siginfo
> instead of the compat one for ILP32. But this requires wider debate
> (cc'ed Arnd if he has time).

This is not useful and as you shown can be very messy and even worse
when it comes taking into account big and little-endian.  Even x32
does not do that.

>
> Basically if you use the current siginfo in the ILP32 context with
> __kernel_clock_t being 64-bit you end up with a structure that doesn't
> match any of the native or compat siginfo. This is because we have some
> pointers which will turn into 32-bit values in ILP32:
>
>         void __user *sival_ptr;         /* accessed via si_ptr */
>         void __user *_addr;             /* accessed via si_addr */
>         void __user *_call_addr;        /* accessed via si_call_addr */
>
> We also have __ARCH_SI_BAND_T defined as long.

I had first thought about this and even started to implement it but I
found the glibc and the kernel messier than it was already.

>
> AFAICT, Linux only does a put_user() on these and never reads them from
> user space. This means that we can add the right padding on either side
> of these pointers (for endianness reasons) and Linux would write 0 as
> the top part of a 64-bit pointer (since the user address is restricted
> to 32-bit anyway). User ILP32 would only access the corresponding
> pointer as a 32-bit value and ignore the padding.

And I am not a fan of changing the generic UAPI files just so it is no
longer generic like you are doing.

>
> It's easier to explain with some code (untested):
>
> diff --git a/arch/arm64/include/uapi/asm/siginfo.h b/arch/arm64/include/uapi/asm/siginfo.h
> index 5a74a08..e3848be 100644
> --- a/arch/arm64/include/uapi/asm/siginfo.h
> +++ b/arch/arm64/include/uapi/asm/siginfo.h
> @@ -18,6 +18,13 @@
>
>  #define __ARCH_SI_PREAMBLE_SIZE        (4 * sizeof(int))
>
> +#ifndef __LP64__       /* ILP32 */
> +#define __ARCH_SI_BAND_T       long long
> +#define VOID_USER_PTR(x)                               \
> +       void __user *x __attribute__((aligned(8)));     \
> +       char _pad[4]
> +#endif
> +
>  #include <asm-generic/siginfo.h>
>
>  #endif
> diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
> index ba5be7f..9c50257 100644
> --- a/include/uapi/asm-generic/siginfo.h
> +++ b/include/uapi/asm-generic/siginfo.h
> @@ -4,9 +4,13 @@
>  #include <linux/compiler.h>
>  #include <linux/types.h>
>
> +#ifndef VOID_USER_PTR
> +#define VOID_USER_PTR(x)       void __user *x
> +#endif
> +
>  typedef union sigval {
>         int sival_int;
> -       void __user *sival_ptr;
> +       VOID_USER_PTR(sival_ptr);
>  } sigval_t;
>
>  /*
> @@ -86,7 +90,7 @@ typedef struct siginfo {
>
>                 /* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
>                 struct {
> -                       void __user *_addr; /* faulting insn/memory ref. */
> +                       VOID_USER_PTR(_addr); /* faulting insn/memory ref. */
>  #ifdef __ARCH_SI_TRAPNO
>                         int _trapno;    /* TRAP # which caused the signal */
>  #endif
> @@ -101,7 +105,7 @@ typedef struct siginfo {
>
>                 /* SIGSYS */
>                 struct {
> -                       void __user *_call_addr; /* calling user insn */
> +                       VOID_USER_PTR(_call_addr); /* calling user insn */
>                         int _syscall;   /* triggering system call number */
>                         unsigned int _arch;     /* AUDIT_ARCH_* of syscall */
>                 } _sigsys;
>
>
> __LP64__ is always defined for AArch64 (kernel and native applications).
> ILP32 user would not get this symbol and compat use a separate
> compat_siginfo anyway.
>
> I'm not entirely sure about defining __ARCH_SI_BAND_T to long long but
> as it also seems to be just written by the kernel, we can use some
> padding as for the void __user *.
>
>
> So, I'm looking for feedback on this proposal.


As I mentioned before even x32 does not do that and it is very messy
to make sure things get zero'd on the glibc and kernel sides.

>
>> diff --git a/arch/arm64/include/asm/stat.h b/arch/arm64/include/asm/stat.h
>> index 989128a..f2e0d3c 100644
>> --- a/arch/arm64/include/asm/stat.h
>> +++ b/arch/arm64/include/asm/stat.h
>> @@ -18,9 +18,11 @@
>>
>>  #include <uapi/asm/stat.h>
>>
>> -#ifdef CONFIG_ARM64_AARCH32
>> -
>> +#ifdef CONFIG_COMPAT
>>  #include <asm/compat.h>
>> +#endif
>
> Doesn't asm/compat.h have guards already? Do you get a conflict with
> is_compat_task()?

The guard was there already, I am just changing it back to be under
CONFIG_COMPAT from when I added CONFIG_ARM64_AARCH32. When I submit
the next version of the set of patches, this change will be done
correctly in the patch which adds CONFIG_ARM64_AARCH32.

>
>> diff --git a/arch/arm64/include/uapi/asm/siginfo.h b/arch/arm64/include/uapi/asm/siginfo.h
>> index 5a74a08..297fb4f 100644
>> --- a/arch/arm64/include/uapi/asm/siginfo.h
>> +++ b/arch/arm64/include/uapi/asm/siginfo.h
>> @@ -16,7 +16,13 @@
>>  #ifndef __ASM_SIGINFO_H
>>  #define __ASM_SIGINFO_H
>>
>> +#ifdef __LP64__
>>  #define __ARCH_SI_PREAMBLE_SIZE        (4 * sizeof(int))
>> +#else /* ILP32 */
>> +typedef long long __kernel_si_clock_t __attribute__((aligned(4)));
>> +#define __ARCH_SI_CLOCK_T      __kernel_si_clock_t
>> +#define __ARCH_SI_ATTRIBUTES   __attribute__((aligned(8)))
>> +#endif
>
> This could go away if we manage to use the native siginfo.

See above why I think this is a bad thing and even worse since even
x32 did not do that already; it was the last added ABI like ILP32 to
the kernel.

>
>> --- /dev/null
>> +++ b/arch/arm64/kernel/signalilp32.c
>> @@ -0,0 +1,30 @@
>> +
>> +#ifdef CONFIG_ARM64_ILP32
>> +
>> +#define rt_sigframe rt_sigframe_ilp32
>
> Can we have the same native rt_sigframe (if we go for the native
> siginfo)? ucontext is an arm64 structure, so we can add padding for
> pointers and long.

No again this is messy due to the zeroing of the values.  As I
mentioned, I started to implement that but it got messy and there was
no right way of having the headers be sane.

>
>> --- /dev/null
>> +++ b/arch/arm64/kernel/sys_ilp32.c
>> @@ -0,0 +1,274 @@
>> +/*
>> + * AArch64- ILP32 specific system calls implementation
>> + *
>> + * Copyright (C) 2013 Cavium Inc.
>> + * Author: Andrew Pinski <apinski@cavium.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +/* Adjust unistd.h to provide 32-bit numbers and functions. */
>> +#define __SYSCALL_COMPAT
>
> No. We need to use as many native syscalls as possible and only define
> those absolutely necessary. In my investigation, I only ended up needing
> these:

No using __SYSCALL_COMPAT is the correct thing to do and then only
reverting back what is needed.

The main reason is due to using the generic support inside glibc already.

>
> #define sys_ioctl               compat_sys_ioctl
> #define sys_readv               compat_sys_readv
> #define sys_writev              compat_sys_writev
> #define sys_preadv              compat_sys_preadv64
> #define sys_pwritev             compat_sys_pwritev64
> #define sys_vmsplice            compat_sys_vmsplice
> #define sys_waitid              compat_sys_waitid
> #define sys_set_robust_list     compat_sys_set_robust_list
> #define sys_get_robust_list     compat_sys_get_robust_list
> #define sys_kexec_load          compat_sys_kexec_load
> #define sys_timer_create        compat_sys_timer_create
> #define sys_ptrace              compat_sys_ptrace
> #define sys_sigaltstack         compat_sys_sigaltstack
> #define sys_rt_sigaction        compat_sys_rt_sigaction
> #define sys_rt_sigpending       compat_sys_rt_sigpending
> #define sys_rt_sigtimedwait     compat_sys_rt_sigtimedwait
> #define sys_rt_sigqueueinfo     compat_sys_rt_sigqueueinfo
> #define sys_rt_sigreturn        compat_sys_rt_sigreturn_wrapper
> #define sys_mq_notify           compat_sys_mq_notify
> #define sys_recvfrom            compat_sys_recvfrom
> #define sys_setsockopt          compat_sys_setsockopt
> #define sys_getsockopt          compat_sys_getsockopt
> #define sys_sendmsg             compat_sys_sendmsg
> #define sys_recvmsg             compat_sys_recvmsg
> #define sys_execve              compat_sys_execve
> #define sys_move_pages          compat_sys_move_pages
> #define sys_rt_tgsigqueueinfo   compat_sys_rt_tgsigqueueinfo
> #define sys_recvmmsg            compat_sys_recvmmsg
> #define sys_sendmmsg            compat_sys_sendmmsg
> #define sys_process_vm_readv    compat_sys_process_vm_readv
> #define sys_process_vm_writev   compat_sys_process_vm_writev

You even forgot compat_sys_openat (where O_LARGEFILE differences does
make a difference).

>
>> diff --git a/arch/arm64/kernel/vdsoilp32/Makefile b/arch/arm64/kernel/vdsoilp32/Makefile
>> new file mode 100644
>> index 0000000..ec93f3f
>> --- /dev/null
>> +++ b/arch/arm64/kernel/vdsoilp32/Makefile
>
> Could we not keep vdso in the same directory?

I started out that way but "make clean ARCH=arm64" did not clean the
vdso files all the time.

>
>> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
>> index 67e8d7c..17b9c39 100644
>> --- a/arch/arm64/mm/init.c
>> +++ b/arch/arm64/mm/init.c
>> @@ -35,6 +35,7 @@
>>  #include <asm/sections.h>
>>  #include <asm/setup.h>
>>  #include <asm/sizes.h>
>> +#include <asm/compat.h>
>>  #include <asm/tlb.h>
>
> Same issue, other header files doesn't include what is necessary.

I will double check these but I think it was a fall out due to my
change that I had originally did for asm/stat.h .

Thanks,
Andrew Pinski
