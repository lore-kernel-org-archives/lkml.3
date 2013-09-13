Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3IMMNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:13:33 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54079 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752346Ab3IMMNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:13:32 -0400
Date: Fri, 13 Sep 2013 13:12:44 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <pinskia@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Andrew Pinski <apinski@cavium.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5/5] ARM64: Add support for ILP32 ABI.
Message-ID: <20130913121244.GC10385@arm.com>
References: <1378762380-13152-1-git-send-email-apinski@cavium.com>
 <1378762380-13152-5-git-send-email-apinski@cavium.com>
 <20130911143102.GA8825@darko.cambridge.arm.com>
 <CA+=Sn1nd3Ym8so_=SP4NC1fjKWn4dNPYvz4OZMo0tLZptF8KVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+=Sn1nd3Ym8so_=SP4NC1fjKWn4dNPYvz4OZMo0tLZptF8KVw@mail.gmail.com>
Thread-Topic: [PATCH 5/5] ARM64: Add support for ILP32 ABI.
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 07:18:48AM +0100, Andrew Pinski wrote:
> On Wed, Sep 11, 2013 at 7:32 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Mon, Sep 09, 2013 at 10:32:59PM +0100, Andrew Pinski wrote:
> >
> > On top of these, I would really like to see
> > Documentation/arm64/ilp32.txt describing the ABI.
> 
> No other target does not, not even x86_64 for x32.

That's not really a good argument.

> > The other approach I've been looking at is just using the native siginfo
> > instead of the compat one for ILP32. But this requires wider debate
> > (cc'ed Arnd if he has time).
> 
> This is not useful and as you shown can be very messy and even worse
> when it comes taking into account big and little-endian.  Even x32
> does not do that.

Well, please don't bring the "x32 does not do that" argument. It doesn't
mean we shouldn't investigate better ways. Initially x32 got the siginfo
members alignment wrong and they ended up __ARCH_SI_CLOCK_T and
__ARCH_SI_ATTRIBUTES, changing the generic uapi files.

> > Basically if you use the current siginfo in the ILP32 context with
> > __kernel_clock_t being 64-bit you end up with a structure that doesn't
> > match any of the native or compat siginfo. This is because we have some
> > pointers which will turn into 32-bit values in ILP32:
> >
> >         void __user *sival_ptr;         /* accessed via si_ptr */
> >         void __user *_addr;             /* accessed via si_addr */
> >         void __user *_call_addr;        /* accessed via si_call_addr */
> >
> > We also have __ARCH_SI_BAND_T defined as long.
> 
> I had first thought about this and even started to implement it but I
> found the glibc and the kernel messier than it was already.

The kernel part wasn't bad IMO (of course, needs ack from generic
headers maintainer). I can't talk about glibc but wouldn't it just
access these members explicitly?

> > AFAICT, Linux only does a put_user() on these and never reads them from
> > user space. This means that we can add the right padding on either side
> > of these pointers (for endianness reasons) and Linux would write 0 as
> > the top part of a 64-bit pointer (since the user address is restricted
> > to 32-bit anyway). User ILP32 would only access the corresponding
> > pointer as a 32-bit value and ignore the padding.
> 
> And I am not a fan of changing the generic UAPI files just so it is no
> longer generic like you are doing.

As I said above, x32 did that already and your are doing similar things
for __ARCH_SI_CLOCK_T.

> > So, I'm looking for feedback on this proposal.
> 
> As I mentioned before even x32 does not do that and it is very messy
> to make sure things get zero'd on the glibc and kernel sides.

(not the x32 argument again)

On the kernel side, they get zeroed automatically because the kernel
assumes it is a 64-bit address for user space, which is restricted to
32-bit only. Are these members ever read back by the kernel? That's
where glibc zeroing would be needed (and I wouldn't like it either).

> >> diff --git a/arch/arm64/include/uapi/asm/siginfo.h b/arch/arm64/include/uapi/asm/siginfo.h
> >> index 5a74a08..297fb4f 100644
> >> --- a/arch/arm64/include/uapi/asm/siginfo.h
> >> +++ b/arch/arm64/include/uapi/asm/siginfo.h
> >> @@ -16,7 +16,13 @@
> >>  #ifndef __ASM_SIGINFO_H
> >>  #define __ASM_SIGINFO_H
> >>
> >> +#ifdef __LP64__
> >>  #define __ARCH_SI_PREAMBLE_SIZE        (4 * sizeof(int))
> >> +#else /* ILP32 */
> >> +typedef long long __kernel_si_clock_t __attribute__((aligned(4)));
> >> +#define __ARCH_SI_CLOCK_T      __kernel_si_clock_t
> >> +#define __ARCH_SI_ATTRIBUTES   __attribute__((aligned(8)))
> >> +#endif
> >
> > This could go away if we manage to use the native siginfo.
> 
> See above why I think this is a bad thing and even worse since even
> x32 did not do that already; it was the last added ABI like ILP32 to
> the kernel.

The x32 thing is becoming the central theme.

> >> --- /dev/null
> >> +++ b/arch/arm64/kernel/sys_ilp32.c
> >> @@ -0,0 +1,274 @@
> >> +/*
> >> + * AArch64- ILP32 specific system calls implementation
> >> + *
> >> + * Copyright (C) 2013 Cavium Inc.
> >> + * Author: Andrew Pinski <apinski@cavium.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public License
> >> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> >> + */
> >> +
> >> +/* Adjust unistd.h to provide 32-bit numbers and functions. */
> >> +#define __SYSCALL_COMPAT
> >
> > No. We need to use as many native syscalls as possible and only define
> > those absolutely necessary. In my investigation, I only ended up needing
> > these:
> 
> No using __SYSCALL_COMPAT is the correct thing to do and then only
> reverting back what is needed.

I _disagree_. "Even x32 does not to that". Some past discussions:

http://thread.gmane.org/gmane.linux.kernel/1184913

> > #define sys_ioctl               compat_sys_ioctl
> > #define sys_readv               compat_sys_readv
> > #define sys_writev              compat_sys_writev
> > #define sys_preadv              compat_sys_preadv64
> > #define sys_pwritev             compat_sys_pwritev64
> > #define sys_vmsplice            compat_sys_vmsplice
> > #define sys_waitid              compat_sys_waitid
> > #define sys_set_robust_list     compat_sys_set_robust_list
> > #define sys_get_robust_list     compat_sys_get_robust_list
> > #define sys_kexec_load          compat_sys_kexec_load
> > #define sys_timer_create        compat_sys_timer_create
> > #define sys_ptrace              compat_sys_ptrace
> > #define sys_sigaltstack         compat_sys_sigaltstack
> > #define sys_rt_sigaction        compat_sys_rt_sigaction
> > #define sys_rt_sigpending       compat_sys_rt_sigpending
> > #define sys_rt_sigtimedwait     compat_sys_rt_sigtimedwait
> > #define sys_rt_sigqueueinfo     compat_sys_rt_sigqueueinfo
> > #define sys_rt_sigreturn        compat_sys_rt_sigreturn_wrapper
> > #define sys_mq_notify           compat_sys_mq_notify
> > #define sys_recvfrom            compat_sys_recvfrom
> > #define sys_setsockopt          compat_sys_setsockopt
> > #define sys_getsockopt          compat_sys_getsockopt
> > #define sys_sendmsg             compat_sys_sendmsg
> > #define sys_recvmsg             compat_sys_recvmsg
> > #define sys_execve              compat_sys_execve
> > #define sys_move_pages          compat_sys_move_pages
> > #define sys_rt_tgsigqueueinfo   compat_sys_rt_tgsigqueueinfo
> > #define sys_recvmmsg            compat_sys_recvmmsg
> > #define sys_sendmmsg            compat_sys_sendmmsg
> > #define sys_process_vm_readv    compat_sys_process_vm_readv
> > #define sys_process_vm_writev   compat_sys_process_vm_writev
> 
> You even forgot compat_sys_openat (where O_LARGEFILE differences does
> make a difference).

Just read the above thread. "Even x32 does not do that".

> >> diff --git a/arch/arm64/kernel/vdsoilp32/Makefile b/arch/arm64/kernel/vdsoilp32/Makefile
> >> new file mode 100644
> >> index 0000000..ec93f3f
> >> --- /dev/null
> >> +++ b/arch/arm64/kernel/vdsoilp32/Makefile
> >
> > Could we not keep vdso in the same directory?
> 
> I started out that way but "make clean ARCH=arm64" did not clean the
> vdso files all the time.

I'll leave vdso comments to Will.

-- 
Catalin
