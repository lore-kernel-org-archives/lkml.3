Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbaGAPGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:06:06 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:23064 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757975AbaGAPGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:06:05 -0400
Date: Tue, 1 Jul 2014 16:05:39 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/24] ARM64:ILP32: Use a seperate syscall table as a few
 syscalls need to be using the compat syscalls.
Message-ID: <20140701150539.GA18309@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-23-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400914939-9708-23-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:02:17AM -0700, Andrew Pinski wrote:
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 1e1ebfc..8241ffe 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -620,9 +620,14 @@ ENDPROC(ret_from_fork)
>   */
>  	.align	6
>  el0_svc:
> -	adrp	stbl, sys_call_table		// load syscall table pointer
>  	uxtw	scno, w8			// syscall number in w8
>  	mov	sc_nr, #__NR_syscalls
> +#ifdef CONFIG_ARM64_ILP32
> +	get_thread_info tsk
> +	ldr	x16, [tsk, #TI_FLAGS]
> +	tbnz	x16, #TIF_32BIT_AARCH64, el0_ilp32_svc // We are using ILP32
> +#endif
> +	adrp	stbl, sys_call_table		// load syscall table pointer

This adds a slight penalty on the AArch64 SVC entry path. I can't tell
whether that's visible or not but I think the x86 guys decided to set an
extra bit to the syscall number to distinguish it from native calls.

> diff --git a/arch/arm64/kernel/sys_ilp32.c b/arch/arm64/kernel/sys_ilp32.c
> new file mode 100644
> index 0000000..1da1d11
> --- /dev/null
> +++ b/arch/arm64/kernel/sys_ilp32.c
[...]
> +/*
> + * Wrappers to pass the pt_regs argument.
> + */
> +#define sys_rt_sigreturn sys_rt_sigreturn_wrapper
> +
> +
> +/* Using Compat syscalls where necessary */
> +#define sys_ioctl		compat_sys_ioctl
> +/* iovec */
> +#define sys_readv		compat_sys_readv
> +#define sys_writev		compat_sys_writev
> +#define sys_preadv		compat_sys_preadv64
> +#define sys_pwritev		compat_sys_pwritev64
> +#define sys_vmsplice		compat_sys_vmsplice

Do these actually work? compat_iovec has two members of 32-bit each
while the ILP32 iovec has a void * (32-bit) and a __kernel_size_t which
is 64-bit.

> +/* robust_list_head */
> +#define sys_set_robust_list	compat_sys_set_robust_list
> +#define sys_get_robust_list	compat_sys_get_robust_list

Same here, we have a size_t * argument. The compat function would write
back 32-bit but size_t is 64-bit for ILP32.

> +/* kexec_segment */
> +#define sys_kexec_load		compat_sys_kexec_load

More size_t members in the kexec_segment structure (but we don't yet
have kexec on arm64).

> +/* struct msghdr */
> +#define sys_recvfrom		compat_sys_recvfrom

Why compat here? struct sockaddr seems to be the same as the native one.

> +#define sys_recvmmsg		compat_sys_recvmmsg
> +#define sys_sendmmsg		compat_sys_sendmmsg
> +#define sys_sendmsg		compat_sys_sendmsg
> +#define sys_recvmsg		compat_sys_recvmsg

These get messier as well with a different size_t affecting struct
msghdr.

> +#define sys_setsockopt		compat_sys_setsockopt
> +#define sys_getsockopt		compat_sys_getsockopt

Looking at the sock_getsockopt() function, we have a union v copied
to/from user. However, such a union contains a struct timeval which for
ILP32 would be different than the compat one.

> +/* iovec */
> +#define sys_process_vm_readv	compat_sys_process_vm_readv
> +#define sys_process_vm_writev	compat_sys_process_vm_writev

See above for iovec.

> +/* Pointer in struct */
> +#define sys_mount               compat_sys_mount

Which structure is this?

> +/* Scheduler */
> +/* unsigned long bitmaps */
> +#define sys_sched_setaffinity   compat_sys_sched_setaffinity
> +#define sys_sched_getaffinity   compat_sys_sched_getaffinity

Does the long bitmask matter here? I can see the length is passed in
bytes.

> +/* iov usage */
> +#define sys_keyctl              compat_sys_keyctl

Same problem as iovec above.

> +/* aio */
> +/* Pointer to Pointer  */
> +#define sys_io_setup		compat_sys_io_setup

sys_io_setup takes a pointer to aio_context_t which is defined as
__kernel_ulong_t (same as LP64).

-- 
Catalin
