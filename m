Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935944Ab3BOPmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:42:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935835Ab3BOPmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:42:31 -0500
Message-ID: <511E5762.4020303@redhat.com>
Date: Fri, 15 Feb 2013 16:42:26 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, jan.kratochvil@redhat.com
Subject: Re: [PATCH] x86: make PTRACE_GETREGSET return 32-bit regs if 64-bit
 process entered kernel with int 80
References: <511CE3D0.8000308@redhat.com> <20130214150046.GA30543@redhat.com> <511D2779.7040504@zytor.com> <20130214191842.GA11620@redhat.com> <511D3928.80402@zytor.com>
In-Reply-To: <511D3928.80402@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 08:21 PM, H. Peter Anvin wrote:
> On 02/14/2013 11:18 AM, Oleg Nesterov wrote:
>> On 02/14, H. Peter Anvin wrote:
>>>
>>> On 02/14/2013 07:00 AM, Oleg Nesterov wrote:
>>>> On 02/14, Denys Vlasenko wrote:
>>>>>
>>>>> Determining personality of a ptraced process is a murky area.
>>>>> On x86, for years strace was looking at segment selectors,
>>>>> which is conceptually wrong: see, for example,
>>>>> https://lkml.org/lkml/2012/1/18/320
>>>>>
>>>
>>> One proposal that keeps being on the table is to export a regset with
>>> metadatam, including process mode at launch (i386, x86-64, x32).
>>
>> Yes... but if this metadata includes TS_COMPAT-is-set, then strace should
>> do PTRACE_GETREGSET(REGSET_META) + PTRACE_GETREGSET(REGSET_GENERAL) every
>> time. Or REGSET_META should include META+GENERAL.
>>
>> IOW, it is not clear to me what this "meta" should actually report.
> 
> That is one of the things that needs to be nailed down.  In particular,
> what are the things people need.

Let's see what strace needs, by examining its source for various arches.

Ow. Six instances of PTRACE_PEEKTEXT (i.e. attempts to read tracee's
code - inherently unsafe operation) in syscall.c, affected arches:
S390: for syscall# fetch, thankfully only needed before 2.5.44;
ARM: for syscall# fetch. Looks like only needed for non-EABI?
SPARC: for personality detection.

Examples of personality detection:
POWERPC64: by examining registers (MSR)
X86: by looking at GETREGSET size
IA64: by examining registers (CR_IPSR)
ARM: by checking syscall no (scno & 0x0f0000)
SPARC: by looking at trap instruction

Syscall entry versus exit detection (i.e. a sanity check):
ALPHA, MIPS: registers (if a3 is 0 or -1, it's exit)
S390: registers (messy code)
X86: registers (eax must be -ENOSYS on entry)

In general, it is not reliable: eax must be -ENOSYS on entry,
but it can be -ENOSYS on exit too. IOW: if we see eax == -ENOSYS,
we have noi idea whether it's entry or exit.

Syscall parameters fetching. Some architectures
need to use nontrivial code. Look at this:

#elif defined(IA64)
	if (!ia32) {
		unsigned long *out0, cfm, sof, sol;
		long rbs_end;
		/* be backwards compatible with kernel < 2.4.4... */
#		ifndef PT_RBS_END
#		  define PT_RBS_END	PT_AR_BSP
#		endif

		if (upeek(tcp, PT_RBS_END, &rbs_end) < 0)
			return -1;
		if (upeek(tcp, PT_CFM, (long *) &cfm) < 0)
			return -1;

		sof = (cfm >> 0) & 0x7f;
		sol = (cfm >> 7) & 0x7f;
		out0 = ia64_rse_skip_regs((unsigned long *) rbs_end, -sof + sol);

		for (i = 0; i < nargs; ++i) {
			if (umoven(tcp, (unsigned long) ia64_rse_skip_regs(out0, i),
				   sizeof(long), (char *) &tcp->u_arg[i]) < 0)
				return -1;
		}

or this:

#elif defined(MIPS)
	if (nargs > 4) {
		long sp;

		if (upeek(tcp, REG_SP, &sp) < 0)
			return -1;
		for (i = 0; i < 4; ++i)
			if (upeek(tcp, REG_A0 + i, &tcp->u_arg[i]) < 0)
				return -1;
		umoven(tcp, sp + 16, (nargs - 4) * sizeof(tcp->u_arg[0]),
		       (char *)(tcp->u_arg + 4));
	} else {
		for (i = 0; i < nargs; ++i)
			if (upeek(tcp, REG_A0 + i, &tcp->u_arg[i]) < 0)
				return -1;
	}

Detecting error exits from syscalls. Most arches use the -errno
convention, others (IA64, SPARC, MIPS) have dedicated register
or bit in a status register to indicate error. Some syscalls
"never fail" (e.g. getgid), and strace needs to know which syscalls
never fail.

If you want to take a look yourself, for your convenience I attached
larger excerpts from strace's syscall.c source file.


To summarize:

Looks like this particular ptrace user would benefit from
the following data:

* is it a syscall entry, exit, or something else.
* for syscall entry:
  - parameters width (32/64/etc) and personality data
    (if arch has personality data more fine-grained than "32/64 bits")
  - syscall no
  - parameters
* for syscall exit:
  - parameters width (32/64/etc) and personality data
  - error indicator (errno)?
  - syscall result

Does this look as a good format?

-- 
vda




static int
get_scno(struct tcb *tcp)
{
	long scno = 0;

#if defined(S390) || defined(S390X)
	if (upeek(tcp, PT_GPR2, &syscall_mode) < 0)
		return -1;

	if (syscall_mode != -ENOSYS) {
		/*
		 * Since kernel version 2.5.44 the scno gets passed in gpr2.
		 */
		scno = syscall_mode;
	} else {
		/*
		 * Old style of "passing" the scno via the SVC instruction.
		 */
		long psw;
		long opcode, offset_reg, tmp;
		void *svc_addr;
		static const int gpr_offset[16] = {
				PT_GPR0,  PT_GPR1,  PT_ORIGGPR2, PT_GPR3,
				PT_GPR4,  PT_GPR5,  PT_GPR6,     PT_GPR7,
				PT_GPR8,  PT_GPR9,  PT_GPR10,    PT_GPR11,
				PT_GPR12, PT_GPR13, PT_GPR14,    PT_GPR15
		};

		if (upeek(tcp, PT_PSWADDR, &psw) < 0)
			return -1;
		errno = 0;
		opcode = ptrace(PTRACE_PEEKTEXT, tcp->pid, (char *)(psw - sizeof(long)), 0);
		if (errno) {
			perror_msg("%s", "peektext(psw-oneword)");
			return -1;
		}

		/*
		 *  We have to check if the SVC got executed directly or via an
		 *  EXECUTE instruction. In case of EXECUTE it is necessary to do
		 *  instruction decoding to derive the system call number.
		 *  Unfortunately the opcode sizes of EXECUTE and SVC are differently,
		 *  so that this doesn't work if a SVC opcode is part of an EXECUTE
		 *  opcode. Since there is no way to find out the opcode size this
		 *  is the best we can do...
		 */
		if ((opcode & 0xff00) == 0x0a00) {
			/* SVC opcode */
			scno = opcode & 0xff;
		}
		else {
			/* SVC got executed by EXECUTE instruction */

			/*
			 *  Do instruction decoding of EXECUTE. If you really want to
			 *  understand this, read the Principles of Operations.
			 */
			svc_addr = (void *) (opcode & 0xfff);

			tmp = 0;
			offset_reg = (opcode & 0x000f0000) >> 16;
			if (offset_reg && (upeek(tcp, gpr_offset[offset_reg], &tmp) < 0))
				return -1;
			svc_addr += tmp;

			tmp = 0;
			offset_reg = (opcode & 0x0000f000) >> 12;
			if (offset_reg && (upeek(tcp, gpr_offset[offset_reg], &tmp) < 0))
				return -1;
			svc_addr += tmp;

			scno = ptrace(PTRACE_PEEKTEXT, tcp->pid, svc_addr, 0);
			if (errno)
				return -1;
# if defined(S390X)
			scno >>= 48;
# else
			scno >>= 16;
# endif
			tmp = 0;
			offset_reg = (opcode & 0x00f00000) >> 20;
			if (offset_reg && (upeek(tcp, gpr_offset[offset_reg], &tmp) < 0))
				return -1;

			scno = (scno | tmp) & 0xff;
		}
	}
#elif defined(POWERPC)
	if (upeek(tcp, sizeof(unsigned long)*PT_R0, &scno) < 0)
		return -1;
# ifdef POWERPC64
	/* TODO: speed up strace by not doing this at every syscall.
	 * We only need to do it after execve.
	 */
	int currpers;
	long val;

	/* Check for 64/32 bit mode. */
	if (upeek(tcp, sizeof(unsigned long)*PT_MSR, &val) < 0)
		return -1;
	/* SF is bit 0 of MSR */
	if (val < 0)
		currpers = 0;
	else
		currpers = 1;
	update_personality(tcp, currpers);
# endif
#elif defined(X86_64) || defined(X32)
	int currpers;
	/* GETREGSET of NT_PRSTATUS tells us regset size,
	 * which unambiguously detects i386.
	 *
	 * Linux kernel distinguishes x86-64 and x32 processes
	 * solely by looking at __X32_SYSCALL_BIT:
	 * arch/x86/include/asm/compat.h::is_x32_task():
	 * if (task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT)
	 *         return true;
	 */
	if (x86_io.iov_len == sizeof(i386_regs)) {
		scno = i386_regs.orig_eax;
		currpers = 1;
	} else {
		scno = x86_64_regs.orig_rax;
		currpers = 0;
		if (scno & __X32_SYSCALL_BIT) {
			scno -= __X32_SYSCALL_BIT;
			currpers = 2;
		}
	}
	update_personality(tcp, currpers);
#elif defined(IA64)
	long psr;
	if (upeek(tcp, PT_CR_IPSR, &psr) >= 0)
		ia32 = (psr & IA64_PSR_IS) != 0;
	if (ia32) {
		if (upeek(tcp, PT_R1, &scno) < 0)
			return -1;
	} else {
		if (upeek(tcp, PT_R15, &scno) < 0)
			return -1;
	}
#elif defined(AARCH64)
	switch (aarch64_io.iov_len) {
		case sizeof(aarch64_regs):
			/* We are in 64-bit mode */
			scno = aarch64_regs.regs[8];
			update_personality(tcp, 1);
			break;
		case sizeof(arm_regs):
			/* We are in 32-bit mode */
			scno = arm_regs.ARM_r7;
			update_personality(tcp, 0);
			break;
	}
#elif defined(ARM)
	/*
	 * We only need to grab the syscall number on syscall entry.
	 */
	if (arm_regs.ARM_ip == 0) {
		/*
		 * Note: we only deal with 32-bit CPUs here
		 */
		if (arm_regs.ARM_cpsr & 0x20) {
			/*
			 * Get the Thumb-mode system call number
			 */
			scno = arm_regs.ARM_r7;
		} else {
			/*
			 * Get the ARM-mode system call number
			 */
			errno = 0;
			scno = ptrace(PTRACE_PEEKTEXT, tcp->pid, (void *)(arm_regs.ARM_pc - 4), NULL);
			if (errno)
				return -1;

			/* Handle the EABI syscall convention.  We do not
			   bother converting structures between the two
			   ABIs, but basic functionality should work even
			   if strace and the traced program have different
			   ABIs.  */
			if (scno == 0xef000000) {
				scno = arm_regs.ARM_r7;
			} else {
				if ((scno & 0x0ff00000) != 0x0f900000) {
					fprintf(stderr, "syscall: unknown syscall trap 0x%08lx\n",
						scno);
					return -1;
				}

				/*
				 * Fixup the syscall number
				 */
				scno &= 0x000fffff;
			}
		}
		if (scno & 0x0f0000) {
			/*
			 * Handle ARM specific syscall
			 */
			update_personality(tcp, 1);
			scno &= 0x0000ffff;
		} else
			update_personality(tcp, 0);

	} else {
		fprintf(stderr, "pid %d stray syscall entry\n", tcp->pid);
		tcp->flags |= TCB_INSYSCALL;
	}
#elif defined(LINUX_MIPSN32)
	unsigned long long regs[38];

	if (ptrace(PTRACE_GETREGS, tcp->pid, NULL, (long) &regs) < 0)
		return -1;
	mips_a3 = regs[REG_A3];
	mips_r2 = regs[REG_V0];

	scno = mips_r2;
	if (!SCNO_IN_RANGE(scno)) {
		if (mips_a3 == 0 || mips_a3 == -1) {
			if (debug_flag)
				fprintf(stderr, "stray syscall exit: v0 = %ld\n", scno);
			return 0;
		}
	}
#elif defined(MIPS)
	if (upeek(tcp, REG_A3, &mips_a3) < 0)
		return -1;
	if (upeek(tcp, REG_V0, &scno) < 0)
		return -1;

	if (!SCNO_IN_RANGE(scno)) {
		if (mips_a3 == 0 || mips_a3 == -1) {
			if (debug_flag)
				fprintf(stderr, "stray syscall exit: v0 = %ld\n", scno);
			return 0;
		}
	}
#elif defined(ALPHA)
	if (upeek(tcp, REG_A3, &alpha_a3) < 0)
		return -1;
	if (upeek(tcp, REG_R0, &scno) < 0)
		return -1;

	/*
	 * Do some sanity checks to figure out if it's
	 * really a syscall entry
	 */
	if (!SCNO_IN_RANGE(scno)) {
		if (alpha_a3 == 0 || alpha_a3 == -1) {
			if (debug_flag)
				fprintf(stderr, "stray syscall exit: r0 = %ld\n", scno);
			return 0;
		}
	}
#elif defined(SPARC) || defined(SPARC64)
	/* Disassemble the syscall trap. */
	/* Retrieve the syscall trap instruction. */
	unsigned long trap;
	errno = 0;
# if defined(SPARC64)
	trap = ptrace(PTRACE_PEEKTEXT, tcp->pid, (char *)regs.tpc, 0);
	trap >>= 32;
# else
	trap = ptrace(PTRACE_PEEKTEXT, tcp->pid, (char *)regs.pc, 0);
# endif
	if (errno)
		return -1;

	/* Disassemble the trap to see what personality to use. */
	switch (trap) {
	case 0x91d02010:
		/* Linux/SPARC syscall trap. */
		update_personality(tcp, 0);
		break;
	case 0x91d0206d:
		/* Linux/SPARC64 syscall trap. */
		update_personality(tcp, 2);
		break;
	case 0x91d02000:
		/* SunOS syscall trap. (pers 1) */
		fprintf(stderr, "syscall: SunOS no support\n");
		return -1;
	case 0x91d02008:
		/* Solaris 2.x syscall trap. (per 2) */
		update_personality(tcp, 1);
		break;
	case 0x91d02009:
		/* NetBSD/FreeBSD syscall trap. */
		fprintf(stderr, "syscall: NetBSD/FreeBSD not supported\n");
		return -1;
	case 0x91d02027:
		/* Solaris 2.x gettimeofday */
		update_personality(tcp, 1);
		break;
	default:
# if defined(SPARC64)
		fprintf(stderr, "syscall: unknown syscall trap %08lx %016lx\n", trap, regs.tpc);
# else
		fprintf(stderr, "syscall: unknown syscall trap %08lx %08lx\n", trap, regs.pc);
# endif
		return -1;
	}

	/* Extract the system call number from the registers. */
	if (trap == 0x91d02027)
		scno = 156;
	else
		scno = regs.u_regs[U_REG_G1];
	if (scno == 0) {
		scno = regs.u_regs[U_REG_O0];
		memmove(&regs.u_regs[U_REG_O0], &regs.u_regs[U_REG_O1], 7*sizeof(regs.u_regs[0]));
	}
#elif defined(TILE)
	int currpers;
	scno = tile_regs.regs[10];
# ifdef __tilepro__
	currpers = 1;
# else
#  ifndef PT_FLAGS_COMPAT
#   define PT_FLAGS_COMPAT 0x10000  /* from Linux 3.8 on */
#  endif
	if (tile_regs.flags & PT_FLAGS_COMPAT)
		currpers = 1;
	else
		currpers = 0;
# endif
	update_personality(tcp, currpers);
#endif
	tcp->scno = scno;
	return 1;
}

/* Called at each syscall entry.
 * Returns:
 * 0: "ignore this ptrace stop", bail out of trace_syscall_entering() silently.
 * 1: ok, continue in trace_syscall_entering().
 * other: error, trace_syscall_entering() should print error indicator
 *    ("????" etc) and bail out.
 */
static int
syscall_fixup_on_sysenter(struct tcb *tcp)
{
	/* A common case of "not a syscall entry" is post-execve SIGTRAP */
#if defined(I386)
	if (i386_regs.eax != -ENOSYS) {
		if (debug_flag)
			fprintf(stderr, "not a syscall entry (eax = %ld)\n", i386_regs.eax);
		return 0;
	}
#elif defined(X86_64) || defined(X32)
	{
		long rax;
		if (x86_io.iov_len == sizeof(i386_regs)) {
			/* Sign extend from 32 bits */
			rax = (int32_t)i386_regs.eax;
		} else {
			/* Note: in X32 build, this truncates 64 to 32 bits */
			rax = x86_64_regs.rax;
		}
		if (rax != -ENOSYS) {
			if (debug_flag)
				fprintf(stderr, "not a syscall entry (rax = %ld)\n", rax);
			return 0;
		}
	}
#elif defined(S390) || defined(S390X)
	/* TODO: we already fetched PT_GPR2 in get_scno
	 * and stored it in syscall_mode, reuse it here
	 * instead of re-fetching?
	 */
	if (upeek(tcp, PT_GPR2, &gpr2) < 0)
		return -1;
	if (syscall_mode != -ENOSYS)
		syscall_mode = tcp->scno;
	if (gpr2 != syscall_mode) {
		if (debug_flag)
			fprintf(stderr, "not a syscall entry (gpr2 = %ld)\n", gpr2);
		return 0;
	}
#elif defined(M68K)
	if (upeek(tcp, 4*PT_D0, &m68k_d0) < 0)
		return -1;
	if (m68k_d0 != -ENOSYS) {
		if (debug_flag)
			fprintf(stderr, "not a syscall entry (d0 = %ld)\n", m68k_d0);
		return 0;
	}
#elif defined(IA64)
	if (upeek(tcp, PT_R10, &ia64_r10) < 0)
		return -1;
	if (upeek(tcp, PT_R8, &ia64_r8) < 0)
		return -1;
	if (ia32 && ia64_r8 != -ENOSYS) {
		if (debug_flag)
			fprintf(stderr, "not a syscall entry (r8 = %ld)\n", ia64_r8);
		return 0;
	}
#elif defined(CRISV10) || defined(CRISV32)
	if (upeek(tcp, 4*PT_R10, &cris_r10) < 0)
		return -1;
	if (cris_r10 != -ENOSYS) {
		if (debug_flag)
			fprintf(stderr, "not a syscall entry (r10 = %ld)\n", cris_r10);
		return 0;
	}
#elif defined(MICROBLAZE)
	if (upeek(tcp, 3 * 4, &microblaze_r3) < 0)
		return -1;
	if (microblaze_r3 != -ENOSYS) {
		if (debug_flag)
			fprintf(stderr, "not a syscall entry (r3 = %ld)\n", microblaze_r3);
		return 0;
	}
#endif
	return 1;
}

/* Return -1 on error or 1 on success (never 0!) */
static int
get_syscall_args(struct tcb *tcp)
{
	int i, nargs;

	if (SCNO_IN_RANGE(tcp->scno))
		nargs = tcp->u_nargs = sysent[tcp->scno].nargs;
	else
		nargs = tcp->u_nargs = MAX_ARGS;

#if defined(S390) || defined(S390X)
	for (i = 0; i < nargs; ++i)
		if (upeek(tcp, i==0 ? PT_ORIGGPR2 : PT_GPR2 + i*sizeof(long), &tcp->u_arg[i]) < 0)
			return -1;
#elif defined(ALPHA)
	for (i = 0; i < nargs; ++i)
		if (upeek(tcp, REG_A0+i, &tcp->u_arg[i]) < 0)
			return -1;
#elif defined(IA64)
	if (!ia32) {
		unsigned long *out0, cfm, sof, sol;
		long rbs_end;
		/* be backwards compatible with kernel < 2.4.4... */
#		ifndef PT_RBS_END
#		  define PT_RBS_END	PT_AR_BSP
#		endif

		if (upeek(tcp, PT_RBS_END, &rbs_end) < 0)
			return -1;
		if (upeek(tcp, PT_CFM, (long *) &cfm) < 0)
			return -1;

		sof = (cfm >> 0) & 0x7f;
		sol = (cfm >> 7) & 0x7f;
		out0 = ia64_rse_skip_regs((unsigned long *) rbs_end, -sof + sol);

		for (i = 0; i < nargs; ++i) {
			if (umoven(tcp, (unsigned long) ia64_rse_skip_regs(out0, i),
				   sizeof(long), (char *) &tcp->u_arg[i]) < 0)
				return -1;
		}
	} else {
		static const int argreg[MAX_ARGS] = { PT_R11 /* EBX = out0 */,
						      PT_R9  /* ECX = out1 */,
						      PT_R10 /* EDX = out2 */,
						      PT_R14 /* ESI = out3 */,
						      PT_R15 /* EDI = out4 */,
						      PT_R13 /* EBP = out5 */};

		for (i = 0; i < nargs; ++i) {
			if (upeek(tcp, argreg[i], &tcp->u_arg[i]) < 0)
				return -1;
			/* truncate away IVE sign-extension */
			tcp->u_arg[i] &= 0xffffffff;
		}
	}
#elif defined(MIPS)
	if (nargs > 4) {
		long sp;

		if (upeek(tcp, REG_SP, &sp) < 0)
			return -1;
		for (i = 0; i < 4; ++i)
			if (upeek(tcp, REG_A0 + i, &tcp->u_arg[i]) < 0)
				return -1;
		umoven(tcp, sp + 16, (nargs - 4) * sizeof(tcp->u_arg[0]),
		       (char *)(tcp->u_arg + 4));
	} else {
		for (i = 0; i < nargs; ++i)
			if (upeek(tcp, REG_A0 + i, &tcp->u_arg[i]) < 0)
				return -1;
	}
#elif defined(M68K)
	for (i = 0; i < nargs; ++i)
		if (upeek(tcp, (i < 5 ? i : i + 2)*4, &tcp->u_arg[i]) < 0)
			return -1;
#else /* Other architecture (32bits specific) */
	for (i = 0; i < nargs; ++i)
		if (upeek(tcp, i*4, &tcp->u_arg[i]) < 0)
			return -1;
#endif
	return 1;
}

/* Returns:
 * 1: ok, continue in trace_syscall_exiting().
 * -1: error, trace_syscall_exiting() should print error indicator
 *    ("????" etc) and bail out.
 */
static int
get_syscall_result(struct tcb *tcp)
{
#if defined(S390) || defined(S390X)
	if (upeek(tcp, PT_GPR2, &gpr2) < 0)
		return -1;
#elif defined(POWERPC)
# define SO_MASK 0x10000000
	{
		long flags;
		if (upeek(tcp, sizeof(unsigned long)*PT_CCR, &flags) < 0)
			return -1;
		if (upeek(tcp, sizeof(unsigned long)*PT_R3, &ppc_result) < 0)
			return -1;
		if (flags & SO_MASK)
			ppc_result = -ppc_result;
	}
#elif defined(AVR32)
	/* already done by get_regs */
#elif defined(BFIN)
	if (upeek(tcp, PT_R0, &bfin_r0) < 0)
		return -1;
#elif defined(I386)
	/* already done by get_regs */
#elif defined(X86_64) || defined(X32)
	/* already done by get_regs */
#elif defined(IA64)
#	define IA64_PSR_IS	((long)1 << 34)
	long psr;
	if (upeek(tcp, PT_CR_IPSR, &psr) >= 0)
		ia32 = (psr & IA64_PSR_IS) != 0;
	if (upeek(tcp, PT_R8, &ia64_r8) < 0)
		return -1;
	if (upeek(tcp, PT_R10, &ia64_r10) < 0)
		return -1;
#elif defined(ARM)
	/* already done by get_regs */
#elif defined(AARCH64)
	/* register reading already done by get_regs */

	/* Used to do this, but we did it on syscall entry already: */
	/* We are in 64-bit mode (personality 1) if register struct is aarch64_regs,
	 * else it's personality 0.
	 */
	/*update_personality(tcp, aarch64_io.iov_len == sizeof(aarch64_regs));*/
#elif defined(M68K)
	if (upeek(tcp, 4*PT_D0, &m68k_d0) < 0)
		return -1;
#elif defined(LINUX_MIPSN32)
	unsigned long long regs[38];

	if (ptrace(PTRACE_GETREGS, tcp->pid, NULL, (long) &regs) < 0)
		return -1;
	mips_a3 = regs[REG_A3];
	mips_r2 = regs[REG_V0];
#elif defined(MIPS)
	if (upeek(tcp, REG_A3, &mips_a3) < 0)
		return -1;
	if (upeek(tcp, REG_V0, &mips_r2) < 0)
		return -1;
#elif defined(ALPHA)
	if (upeek(tcp, REG_A3, &alpha_a3) < 0)
		return -1;
	if (upeek(tcp, REG_R0, &alpha_r0) < 0)
		return -1;
#elif defined(SPARC) || defined(SPARC64)
	/* already done by get_regs */
#elif defined(HPPA)
	if (upeek(tcp, PT_GR28, &hppa_r28) < 0)
		return -1;
#elif defined(SH)
	/* new syscall ABI returns result in R0 */
	if (upeek(tcp, 4*REG_REG0, (long *)&sh_r0) < 0)
		return -1;
#elif defined(SH64)
	/* ABI defines result returned in r9 */
	if (upeek(tcp, REG_GENERAL(9), (long *)&sh64_r9) < 0)
		return -1;
#elif defined(CRISV10) || defined(CRISV32)
	if (upeek(tcp, 4*PT_R10, &cris_r10) < 0)
		return -1;
#elif defined(TILE)
	/* already done by get_regs */
#elif defined(MICROBLAZE)
	if (upeek(tcp, 3 * 4, &microblaze_r3) < 0)
		return -1;
#elif defined(OR1K)
	/* already done by get_regs */
#endif
	return 1;
}

/* Called at each syscall exit */
static void
syscall_fixup_on_sysexit(struct tcb *tcp)
{
#if defined(S390) || defined(S390X)
	if (syscall_mode != -ENOSYS)
		syscall_mode = tcp->scno;
	if ((tcp->flags & TCB_WAITEXECVE)
		 && (gpr2 == -ENOSYS || gpr2 == tcp->scno)) {
		/*
		 * Return from execve.
		 * Fake a return value of zero.  We leave the TCB_WAITEXECVE
		 * flag set for the post-execve SIGTRAP to see and reset.
		 */
		gpr2 = 0;
	}
#endif
}

/* Returns:
 * 1: ok, continue in trace_syscall_exiting().
 * -1: error, trace_syscall_exiting() should print error indicator
 *    ("????" etc) and bail out.
 */
static int
get_error(struct tcb *tcp)
{
	int u_error = 0;
	int check_errno = 1;
	if (SCNO_IN_RANGE(tcp->scno) &&
	    sysent[tcp->scno].sys_flags & SYSCALL_NEVER_FAILS) {
		check_errno = 0;
	}
#if defined(S390) || defined(S390X)
	if (check_errno && is_negated_errno(gpr2)) {
		tcp->u_rval = -1;
		u_error = -gpr2;
	}
	else {
		tcp->u_rval = gpr2;
	}
#elif defined(I386)
	if (check_errno && is_negated_errno(i386_regs.eax)) {
		tcp->u_rval = -1;
		u_error = -i386_regs.eax;
	}
	else {
		tcp->u_rval = i386_regs.eax;
	}
#elif defined(X86_64)
	long rax;
	if (x86_io.iov_len == sizeof(i386_regs)) {
		/* Sign extend from 32 bits */
		rax = (int32_t)i386_regs.eax;
	} else {
		rax = x86_64_regs.rax;
	}
	if (check_errno && is_negated_errno(rax)) {
		tcp->u_rval = -1;
		u_error = -rax;
	}
	else {
		tcp->u_rval = rax;
	}
#elif defined(X32)
	/* In X32, return value is 64-bit (llseek uses one).
	 * Using merely "long rax" would not work.
	 */
	long long rax;
	if (x86_io.iov_len == sizeof(i386_regs)) {
		/* Sign extend from 32 bits */
		rax = (int32_t)i386_regs.eax;
	} else {
		rax = x86_64_regs.rax;
	}
	/* Careful: is_negated_errno() works only on longs */
	if (check_errno && is_negated_errno_x32(rax)) {
		tcp->u_rval = -1;
		u_error = -rax;
	}
	else {
		tcp->u_rval = rax; /* truncating */
		tcp->u_lrval = rax;
	}
#elif defined(IA64)
	if (ia32) {
		int err;

		err = (int)ia64_r8;
		if (check_errno && is_negated_errno(err)) {
			tcp->u_rval = -1;
			u_error = -err;
		}
		else {
			tcp->u_rval = err;
		}
	} else {
		if (check_errno && ia64_r10) {
			tcp->u_rval = -1;
			u_error = ia64_r8;
		} else {
			tcp->u_rval = ia64_r8;
		}
	}
#elif defined(MIPS)
	if (check_errno && mips_a3) {
		tcp->u_rval = -1;
		u_error = mips_r2;
	} else {
		tcp->u_rval = mips_r2;
# if defined(LINUX_MIPSN32)
		tcp->u_lrval = mips_r2;
# endif
	}
#elif defined(POWERPC)
	if (check_errno && is_negated_errno(ppc_result)) {
		tcp->u_rval = -1;
		u_error = -ppc_result;
	}
	else {
		tcp->u_rval = ppc_result;
	}
#elif defined(M68K)
	if (check_errno && is_negated_errno(m68k_d0)) {
		tcp->u_rval = -1;
		u_error = -m68k_d0;
	}
	else {
		tcp->u_rval = m68k_d0;
	}
#elif defined(ARM) || defined(AARCH64)
# if defined(AARCH64)
	if (tcp->currpers == 1) {
		if (check_errno && is_negated_errno(aarch64_regs.regs[0])) {
			tcp->u_rval = -1;
			u_error = -aarch64_regs.regs[0];
		}
		else {
			tcp->u_rval = aarch64_regs.regs[0];
		}
	}
	else
# endif
	{
		if (check_errno && is_negated_errno(arm_regs.ARM_r0)) {
			tcp->u_rval = -1;
			u_error = -arm_regs.ARM_r0;
		}
		else {
			tcp->u_rval = arm_regs.ARM_r0;
		}
	}
#elif defined(AVR32)
	if (check_errno && regs.r12 && (unsigned) -regs.r12 < nerrnos) {
		tcp->u_rval = -1;
		u_error = -regs.r12;
	}
	else {
		tcp->u_rval = regs.r12;
	}
#elif defined(BFIN)
	if (check_errno && is_negated_errno(bfin_r0)) {
		tcp->u_rval = -1;
		u_error = -bfin_r0;
	} else {
		tcp->u_rval = bfin_r0;
	}
#elif defined(ALPHA)
	if (check_errno && alpha_a3) {
		tcp->u_rval = -1;
		u_error = alpha_r0;
	}
	else {
		tcp->u_rval = alpha_r0;
	}
#elif defined(SPARC)
	if (check_errno && regs.psr & PSR_C) {
		tcp->u_rval = -1;
		u_error = regs.u_regs[U_REG_O0];
	}
	else {
		tcp->u_rval = regs.u_regs[U_REG_O0];
	}
#elif defined(SPARC64)
	if (check_errno && regs.tstate & 0x1100000000UL) {
		tcp->u_rval = -1;
		u_error = regs.u_regs[U_REG_O0];
	}
	else {
		tcp->u_rval = regs.u_regs[U_REG_O0];
	}
#elif defined(HPPA)
	if (check_errno && is_negated_errno(hppa_r28)) {
		tcp->u_rval = -1;
		u_error = -hppa_r28;
	}
	else {
		tcp->u_rval = hppa_r28;
	}
#elif defined(SH)
	if (check_errno && is_negated_errno(sh_r0)) {
		tcp->u_rval = -1;
		u_error = -sh_r0;
	}
	else {
		tcp->u_rval = sh_r0;
	}
#elif defined(SH64)
	if (check_errno && is_negated_errno(sh64_r9)) {
		tcp->u_rval = -1;
		u_error = -sh64_r9;
	}
	else {
		tcp->u_rval = sh64_r9;
	}
#elif defined(CRISV10) || defined(CRISV32)
	if (check_errno && cris_r10 && (unsigned) -cris_r10 < nerrnos) {
		tcp->u_rval = -1;
		u_error = -cris_r10;
	}
	else {
		tcp->u_rval = cris_r10;
	}
#elif defined(TILE)
	/*
	 * The standard tile calling convention returns the value (or negative
	 * errno) in r0, and zero (or positive errno) in r1.
	 * Until at least kernel 3.8, however, the r1 value is not reflected
	 * in ptregs at this point, so we use r0 here.
	 */
	if (check_errno && is_negated_errno(tile_regs.regs[0])) {
		tcp->u_rval = -1;
		u_error = -tile_regs.regs[0];
	} else {
		tcp->u_rval = tile_regs.regs[0];
	}
#elif defined(MICROBLAZE)
	if (check_errno && is_negated_errno(microblaze_r3)) {
		tcp->u_rval = -1;
		u_error = -microblaze_r3;
	}
	else {
		tcp->u_rval = microblaze_r3;
	}
#elif defined(OR1K)
	if (check_errno && is_negated_errno(or1k_regs.gpr[11])) {
		tcp->u_rval = -1;
		u_error = -or1k_regs.gpr[11];
	}
	else {
		tcp->u_rval = or1k_regs.gpr[11];
	}
#endif
	tcp->u_error = u_error;
	return 1;
}

