Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaEMCBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 22:01:33 -0400
Received: from ozlabs.org ([103.22.144.67]:57148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaEMCBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 22:01:31 -0400
Date: Tue, 13 May 2014 12:01:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Blanchard <anton@samba.org>
Subject: linux-next: manual merge of the powerpc tree with the fixes tree
Message-ID: <20140513120121.27d41f76@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/N/qEL/lZ0PmQ913pmc2rK2."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/N/qEL/lZ0PmQ913pmc2rK2.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the powerpc tree got a conflict in
arch/powerpc/kernel/exceptions-64s.S between commit 0be9d8b61c0c
("powerpc/ppc64: Allow allmodconfig to build (finally !)") from the
fixes tree and commits b1576fec7f4d ("powerpc: No need to use dot
symbols when branching to a function") and 354255014a90 ("powerpc:
Remove dot symbol usage in exception macros") from the powerpc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/kernel/exceptions-64s.S
index 833a68dc4cc8,20f11eb4dff7..000000000000
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@@ -891,186 -1025,14 +891,186 @@@ END_FTR_SECTION_IFSET(CPU_FTR_CFAR
  	std	r12,RESULT(r1)
  	std	r11,STACK_FRAME_OVERHEAD-16(r1)
  1:	addi	r3,r1,STACK_FRAME_OVERHEAD
- 	bl	.kernel_bad_stack
+ 	bl	kernel_bad_stack
  	b	1b
 =20
 +
 +#if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_PPC_POWERNV)
 +/*
 + * Data area reserved for FWNMI option.
 + * This address (0x7000) is fixed by the RPA.
 + */
 +	.=3D 0x7000
 +	.globl fwnmi_data_area
 +fwnmi_data_area:
 +
 +	/* pseries and powernv need to keep the whole page from
 +	 * 0x7000 to 0x8000 free for use by the firmware
 +	 */
 +	. =3D 0x8000
 +#endif /* defined(CONFIG_PPC_PSERIES) || defined(CONFIG_PPC_POWERNV) */
 +
  /*
 - * Here r13 points to the paca, r9 contains the saved CR,
 - * SRR0 and SRR1 are saved in r11 and r12,
 - * r9 - r13 are saved in paca->exgen.
 + * Denorm interrupt assist moved out of line to here, where it remains
 + * close enough to the call site which uses a small conditional branch
   */
 +#ifdef CONFIG_PPC_DENORMALISATION
 +denorm_assist:
 +BEGIN_FTR_SECTION
 +/*
 + * To denormalise we need to move a copy of the register to itself.
 + * For POWER6 do that here for all FP regs.
 + */
 +	mfmsr	r10
 +	ori	r10,r10,(MSR_FP|MSR_FE0|MSR_FE1)
 +	xori	r10,r10,(MSR_FE0|MSR_FE1)
 +	mtmsrd	r10
 +	sync
 +
 +#define FMR2(n)  fmr (n), (n) ; fmr n+1, n+1
 +#define FMR4(n)  FMR2(n) ; FMR2(n+2)
 +#define FMR8(n)  FMR4(n) ; FMR4(n+4)
 +#define FMR16(n) FMR8(n) ; FMR8(n+8)
 +#define FMR32(n) FMR16(n) ; FMR16(n+16)
 +	FMR32(0)
 +
 +FTR_SECTION_ELSE
 +/*
 + * To denormalise we need to move a copy of the register to itself.
 + * For POWER7 do that here for the first 32 VSX registers only.
 + */
 +	mfmsr	r10
 +	oris	r10,r10,MSR_VSX@h
 +	mtmsrd	r10
 +	sync
 +
 +#define XVCPSGNDP2(n) XVCPSGNDP(n,n,n) ; XVCPSGNDP(n+1,n+1,n+1)
 +#define XVCPSGNDP4(n) XVCPSGNDP2(n) ; XVCPSGNDP2(n+2)
 +#define XVCPSGNDP8(n) XVCPSGNDP4(n) ; XVCPSGNDP4(n+4)
 +#define XVCPSGNDP16(n) XVCPSGNDP8(n) ; XVCPSGNDP8(n+8)
 +#define XVCPSGNDP32(n) XVCPSGNDP16(n) ; XVCPSGNDP16(n+16)
 +	XVCPSGNDP32(0)
 +
 +ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_206)
 +
 +BEGIN_FTR_SECTION
 +	b	denorm_done
 +END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_207S)
 +/*
 + * To denormalise we need to move a copy of the register to itself.
 + * For POWER8 we need to do that for all 64 VSX registers
 + */
 +	XVCPSGNDP32(32)
 +denorm_done:
 +	mtspr	SPRN_HSRR0,r11
 +	mtcrf	0x80,r9
 +	ld	r9,PACA_EXGEN+EX_R9(r13)
 +	RESTORE_PPR_PACA(PACA_EXGEN, r10)
 +BEGIN_FTR_SECTION
 +	ld	r10,PACA_EXGEN+EX_CFAR(r13)
 +	mtspr	SPRN_CFAR,r10
 +END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 +	ld	r10,PACA_EXGEN+EX_R10(r13)
 +	ld	r11,PACA_EXGEN+EX_R11(r13)
 +	ld	r12,PACA_EXGEN+EX_R12(r13)
 +	ld	r13,PACA_EXGEN+EX_R13(r13)
 +	HRFID
 +	b	.
 +#endif
 +
 +/*
 + * An interrupt came in while soft-disabled. We set paca->irq_happened, t=
hen:
 + * - If it was a decrementer interrupt, we bump the dec to max and and re=
turn.
 + * - If it was a doorbell we return immediately since doorbells are edge
 + *   triggered and won't automatically refire.
 + * - else we hard disable and return.
 + * This is called with r10 containing the value to OR to the paca field.
 + *
 + * Warning: This code is reached using a (small) conditional branch from =
both
 + * the 1st level exception handlers below 0x8000 and the alternate feature
 + * sections of that file which the linker puts right after the text in he=
re.
 + *
 + * For that to work, we thus need this code to be roughly near the "middl=
e"
 + * so that we can reach it with <32k offsets. Here works... for now.
 + */
 +#define MASKED_INTERRUPT(_H)				\
 +masked_##_H##interrupt:					\
 +	std	r11,PACA_EXGEN+EX_R11(r13);		\
 +	lbz	r11,PACAIRQHAPPENED(r13);		\
 +	or	r11,r11,r10;				\
 +	stb	r11,PACAIRQHAPPENED(r13);		\
 +	cmpwi	r10,PACA_IRQ_DEC;			\
 +	bne	1f;					\
 +	lis	r10,0x7fff;				\
 +	ori	r10,r10,0xffff;				\
 +	mtspr	SPRN_DEC,r10;				\
 +	b	2f;					\
 +1:	cmpwi	r10,PACA_IRQ_DBELL;			\
 +	beq	2f;					\
 +	mfspr	r10,SPRN_##_H##SRR1;			\
 +	rldicl	r10,r10,48,1; /* clear MSR_EE */	\
 +	rotldi	r10,r10,16;				\
 +	mtspr	SPRN_##_H##SRR1,r10;			\
 +2:	mtcrf	0x80,r9;				\
 +	ld	r9,PACA_EXGEN+EX_R9(r13);		\
 +	ld	r10,PACA_EXGEN+EX_R10(r13);		\
 +	ld	r11,PACA_EXGEN+EX_R11(r13);		\
 +	GET_SCRATCH0(r13);				\
 +	##_H##rfid;					\
 +	b	.
 +
 +	MASKED_INTERRUPT()
 +	MASKED_INTERRUPT(H)
 +
 +/*
 + * Code from here down to __end_handlers is invoked from the
 + * exception prologs above.  Because the prologs assemble the
 + * addresses of these handlers using the LOAD_HANDLER macro,
 + * which uses an ori instruction, these handlers must be in
 + * the first 64k of the kernel image.
 + */
 +
 +/*** Common interrupt handlers ***/
 +
- 	STD_EXCEPTION_COMMON(0x100, system_reset, .system_reset_exception)
++	STD_EXCEPTION_COMMON(0x100, system_reset, system_reset_exception)
 +
 +	STD_EXCEPTION_COMMON_ASYNC(0x500, hardware_interrupt, do_IRQ)
- 	STD_EXCEPTION_COMMON_ASYNC(0x900, decrementer, .timer_interrupt)
- 	STD_EXCEPTION_COMMON(0x980, hdecrementer, .hdec_interrupt)
++	STD_EXCEPTION_COMMON_ASYNC(0x900, decrementer, timer_interrupt)
++	STD_EXCEPTION_COMMON(0x980, hdecrementer, hdec_interrupt)
 +#ifdef CONFIG_PPC_DOORBELL
- 	STD_EXCEPTION_COMMON_ASYNC(0xa00, doorbell_super, .doorbell_exception)
++	STD_EXCEPTION_COMMON_ASYNC(0xa00, doorbell_super, doorbell_exception)
 +#else
- 	STD_EXCEPTION_COMMON_ASYNC(0xa00, doorbell_super, .unknown_exception)
++	STD_EXCEPTION_COMMON_ASYNC(0xa00, doorbell_super, unknown_exception)
 +#endif
- 	STD_EXCEPTION_COMMON(0xb00, trap_0b, .unknown_exception)
- 	STD_EXCEPTION_COMMON(0xd00, single_step, .single_step_exception)
- 	STD_EXCEPTION_COMMON(0xe00, trap_0e, .unknown_exception)
- 	STD_EXCEPTION_COMMON(0xe40, emulation_assist, .emulation_assist_interrup=
t)
- 	STD_EXCEPTION_COMMON(0xe60, hmi_exception, .unknown_exception)
++	STD_EXCEPTION_COMMON(0xb00, trap_0b, unknown_exception)
++	STD_EXCEPTION_COMMON(0xd00, single_step, single_step_exception)
++	STD_EXCEPTION_COMMON(0xe00, trap_0e, unknown_exception)
++	STD_EXCEPTION_COMMON(0xe40, emulation_assist, emulation_assist_interrupt)
++	STD_EXCEPTION_COMMON(0xe60, hmi_exception, unknown_exception)
 +#ifdef CONFIG_PPC_DOORBELL
- 	STD_EXCEPTION_COMMON_ASYNC(0xe80, h_doorbell, .doorbell_exception)
++	STD_EXCEPTION_COMMON_ASYNC(0xe80, h_doorbell, doorbell_exception)
 +#else
- 	STD_EXCEPTION_COMMON_ASYNC(0xe80, h_doorbell, .unknown_exception)
++	STD_EXCEPTION_COMMON_ASYNC(0xe80, h_doorbell, unknown_exception)
 +#endif
- 	STD_EXCEPTION_COMMON_ASYNC(0xf00, performance_monitor, .performance_moni=
tor_exception)
- 	STD_EXCEPTION_COMMON(0x1300, instruction_breakpoint, .instruction_breakp=
oint_exception)
- 	STD_EXCEPTION_COMMON(0x1502, denorm, .unknown_exception)
++	STD_EXCEPTION_COMMON_ASYNC(0xf00, performance_monitor, performance_monit=
or_exception)
++	STD_EXCEPTION_COMMON(0x1300, instruction_breakpoint, instruction_breakpo=
int_exception)
++	STD_EXCEPTION_COMMON(0x1502, denorm, unknown_exception)
 +#ifdef CONFIG_ALTIVEC
- 	STD_EXCEPTION_COMMON(0x1700, altivec_assist, .altivec_assist_exception)
++	STD_EXCEPTION_COMMON(0x1700, altivec_assist, altivec_assist_exception)
 +#else
- 	STD_EXCEPTION_COMMON(0x1700, altivec_assist, .unknown_exception)
++	STD_EXCEPTION_COMMON(0x1700, altivec_assist, unknown_exception)
 +#endif
 +#ifdef CONFIG_CBE_RAS
- 	STD_EXCEPTION_COMMON(0x1200, cbe_system_error, .cbe_system_error_excepti=
on)
- 	STD_EXCEPTION_COMMON(0x1600, cbe_maintenance, .cbe_maintenance_exception)
- 	STD_EXCEPTION_COMMON(0x1800, cbe_thermal, .cbe_thermal_exception)
++	STD_EXCEPTION_COMMON(0x1200, cbe_system_error, cbe_system_error_exceptio=
n)
++	STD_EXCEPTION_COMMON(0x1600, cbe_maintenance, cbe_maintenance_exception)
++	STD_EXCEPTION_COMMON(0x1800, cbe_thermal, cbe_thermal_exception)
 +#endif /* CONFIG_CBE_RAS */
 +
 +	/*
 +	 * Here r13 points to the paca, r9 contains the saved CR,
 +	 * SRR0 and SRR1 are saved in r11 and r12,
 +	 * r9 - r13 are saved in paca->exgen.
 +	 */
  	.align	7
  	.globl data_access_common
  data_access_common:
@@@ -1109,10 -1071,73 +1109,10 @@@ instruction_access_common
  	ld	r3,_NIP(r1)
  	andis.	r4,r12,0x5820
  	li	r5,0x400
- 	b	.do_hash_page		/* Try to handle as hpte fault */
+ 	b	do_hash_page		/* Try to handle as hpte fault */
 =20
- 	STD_EXCEPTION_COMMON(0xe20, h_instr_storage, .unknown_exception)
+ 	STD_EXCEPTION_COMMON(0xe20, h_instr_storage, unknown_exception)
 =20
 -/*
 - * Here is the common SLB miss user that is used when going to virtual
 - * mode for SLB misses, that is currently not used
 - */
 -#ifdef __DISABLED__
 -	.align	7
 -	.globl	slb_miss_user_common
 -slb_miss_user_common:
 -	mflr	r10
 -	std	r3,PACA_EXGEN+EX_DAR(r13)
 -	stw	r9,PACA_EXGEN+EX_CCR(r13)
 -	std	r10,PACA_EXGEN+EX_LR(r13)
 -	std	r11,PACA_EXGEN+EX_SRR0(r13)
 -	bl	slb_allocate_user
 -
 -	ld	r10,PACA_EXGEN+EX_LR(r13)
 -	ld	r3,PACA_EXGEN+EX_R3(r13)
 -	lwz	r9,PACA_EXGEN+EX_CCR(r13)
 -	ld	r11,PACA_EXGEN+EX_SRR0(r13)
 -	mtlr	r10
 -	beq-	slb_miss_fault
 -
 -	andi.	r10,r12,MSR_RI		/* check for unrecoverable exception */
 -	beq-	unrecov_user_slb
 -	mfmsr	r10
 -
 -.machine push
 -.machine "power4"
 -	mtcrf	0x80,r9
 -.machine pop
 -
 -	clrrdi	r10,r10,2		/* clear RI before setting SRR0/1 */
 -	mtmsrd	r10,1
 -
 -	mtspr	SRR0,r11
 -	mtspr	SRR1,r12
 -
 -	ld	r9,PACA_EXGEN+EX_R9(r13)
 -	ld	r10,PACA_EXGEN+EX_R10(r13)
 -	ld	r11,PACA_EXGEN+EX_R11(r13)
 -	ld	r12,PACA_EXGEN+EX_R12(r13)
 -	ld	r13,PACA_EXGEN+EX_R13(r13)
 -	rfid
 -	b	.
 -
 -slb_miss_fault:
 -	EXCEPTION_PROLOG_COMMON(0x380, PACA_EXGEN)
 -	ld	r4,PACA_EXGEN+EX_DAR(r13)
 -	li	r5,0
 -	std	r4,_DAR(r1)
 -	std	r5,_DSISR(r1)
 -	b	handle_page_fault
 -
 -unrecov_user_slb:
 -	EXCEPTION_PROLOG_COMMON(0x4200, PACA_EXGEN)
 -	DISABLE_INTS
 -	bl	save_nvgprs
 -1:	addi	r3,r1,STACK_FRAME_OVERHEAD
 -	bl	unrecoverable_exception
 -	b	1b
 -
 -#endif /* __DISABLED__ */
 -
 =20
  	/*
  	 * Machine check is different because we use a different

--Sig_/N/qEL/lZ0PmQ913pmc2rK2.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcXz3AAoJEMDTa8Ir7ZwV4HIP/iRx2DDpLy0G1Z6J/QfSY0BO
H2DVu7WzdIAQ/ek4ycCvvOH6ztmTcgPBBOxv1IzEFl/bEv1nfoDGj0Y6MUYfssTc
9HX+/6UNwOwo8oU+N7GbdG9Y92/8P0FljyJFPGoizQCEO1Y4znB94N988/Tvu0Qi
ucKIzPVWHTjF/rD+7IH7p9XuxEdm7COJhf2yvSPAEr0S/zNs46IzIPRmGXpjw2Ls
K3KBhQi/4S93tsXd6yhsoPmRwT4uFOoPbZznRQo8LkU92w3sM+fnIObCUkZEns9Q
H/wdtE6Hw5G2tJTT2xS+MkhvTzUoo22+wz4UyonH21ji7GmFbfGHeLlztQfkvXld
WpVrrDkWtkShShArBHM81eXZnTsPs3knu5OGrB/0kGIFXkPFnTLPSw3F5mzIjcsj
FqUkrCdFZkMdDwRZbUCmL7RFo+N8jYIOeKnkXFe0NobpbyXayn4QfrVl8DlV5Qtb
EPe2Pzi/7L/O0ECv4XdghLKWY81hyy8pjVHvSWu+VS93oF0bPNZ+VVwFJetlmWq6
2n3ckG3BvZnit9GKF3aosUMzNWyRmPidxEmQkxQJXaUcd/x/DFAhIEoE8S+t85yP
82QT1mieJq0ozoDawDORysYa61EohFU0Fv76bHDDn4lbxUlMiLQBYvTyvsPBrupu
6yLfpKTMGW+ClKwoXrL0
=sxyj
-----END PGP SIGNATURE-----

--Sig_/N/qEL/lZ0PmQ913pmc2rK2.--
