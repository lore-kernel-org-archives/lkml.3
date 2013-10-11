Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab3JKMxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:53:09 -0400
Received: from multi.imgtec.com ([194.200.65.239]:56029 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605Ab3JKMxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:53:07 -0400
Message-ID: <5257F456.8060809@imgtec.com>
Date: Fri, 11 Oct 2013 13:51:34 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: <linux-mips@linux-mips.org>, <ralf@linux-mips.org>, <kvm@vger.kernel.org>,
        Sanjay Lal <sanjayl@kymasys.com>, <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 15/31] mips/kvm: Exception handling to leave and reenter
 guest mode.
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com> <1370646215-6543-16-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1370646215-6543-16-git-send-email-ddaney.cavm@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="nPNcRa8v7DDmoctP7esqv1m0w7SNaeO6F"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_10_11_13_53_02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nPNcRa8v7DDmoctP7esqv1m0w7SNaeO6F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi David,

I know it's been a while since you posted this patchset, but thought you
might appreciate the feedback anyway.

Some of my comments/suggestions relate to portability with MIPS32. I
don't object if you respond to those by just adding "depends on 64BIT"
so that I & others can fix it up in subsequent patches.

On 08/06/13 00:03, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
>=20
> Currently this is a little complex, here are the facts about how it wor=
ks:
>=20
> o When running in Guest mode we set the high bit of CP0_XCONTEXT.  If
>   this bit is clear, we don't do anything special on an exception.
>=20
> o If we are in guest mode, upon an exception we:
>=20
>   1) load the stack pointer from the mips_kvm_rootsp array instead of
>      kernelsp.
>=20
>   2) Clear GuestCtl[GM] and high bit of CP0_XCONTEXT.
>=20
>   3) Restore host ASID and PGD pointer.
>=20
> o Upon restarting from an exception we test the task TIF_GUESTMODE
>   flag if it is clear, nothing special is done.
>=20
> o If Guest mode is active for the thread we:
>=20
>   1) Compare the stack pointer to mips_kvm_rootsp, if it doesn't match
>      we are not reentering guest mode, so no more special processing
>      is done.
>=20
>   2) If reentering guest mode:
>=20
>   2a) Set high bit of CP0_XCONTEXT and GuestCtl[GM].
>=20
>   2b) Set Guest mode ASID and PGD pointer.
>=20
> This allows a single set of exception handlers to be used for both
> host and guest mode operation.
>=20
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  arch/mips/include/asm/stackframe.h | 135 +++++++++++++++++++++++++++++=
+++++++-
>  1 file changed, 132 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/mips/include/asm/stackframe.h b/arch/mips/include/asm=
/stackframe.h
> index 20627b2..bf2ec48 100644
> --- a/arch/mips/include/asm/stackframe.h
> +++ b/arch/mips/include/asm/stackframe.h
> @@ -17,6 +17,7 @@
>  #include <asm/asmmacro.h>
>  #include <asm/mipsregs.h>
>  #include <asm/asm-offsets.h>
> +#include <asm/thread_info.h>
> =20
>  /*
>   * For SMTC kernel, global IE should be left set, and interrupts
> @@ -98,7 +99,9 @@
>  #define CPU_ID_REG CP0_CONTEXT
>  #define CPU_ID_MFC0 MFC0
>  #endif
> -		.macro	get_saved_sp	/* SMP variation */
> +#define CPU_ID_MASK ((1 << 13) - 1)

(I was going to say this could be made more portable by using the lowest
bit of PTEBASE (i.e. bit PTEBASE_SHIFT) for the guest mode state instead
of bit 63, and setting CPU_ID_MASK to -2 to mask off the lowest instead
of highest bit, but now I see you test it with bgez... In that case I
suppose it makes sense to use bit 31 for 32BIT, which still leaves 6
bits for the processor id - potentially expandable back to 7 by shifting
the processor id down a couple of bits and utilising the masking that
you've added).

> +
> +		.macro	get_saved_sp_for_save_some	/* SMP variation */
>  		CPU_ID_MFC0	k0, CPU_ID_REG

I suspect this shouldn't be here since both users of the macro already
seem to ensure it's done.

>  #if defined(CONFIG_32BIT) || defined(KBUILD_64BIT_SYM32)
>  		lui	k1, %hi(kernelsp)
> @@ -110,15 +113,49 @@
>  		dsll	k1, 16
>  #endif
>  		LONG_SRL	k0, PTEBASE_SHIFT
> +#ifdef CONFIG_KVM_MIPSVZ
> +		andi	k0, CPU_ID_MASK /* high bits indicate guest mode. */
> +#endif
>  		LONG_ADDU	k1, k0
>  		LONG_L	k1, %lo(kernelsp)(k1)
>  		.endm
> =20
> +		.macro get_saved_sp
> +		CPU_ID_MFC0	k0, CPU_ID_REG
> +		get_saved_sp_for_save_some
> +		.endm
> +
> +		.macro	get_mips_kvm_rootsp	/* SMP variation */
> +#if defined(CONFIG_32BIT) || defined(KBUILD_64BIT_SYM32)
> +		lui	k1, %hi(mips_kvm_rootsp)
> +#else
> +		lui	k1, %highest(mips_kvm_rootsp)
> +		daddiu	k1, %higher(mips_kvm_rootsp)
> +		dsll	k1, 16
> +		daddiu	k1, %hi(mips_kvm_rootsp)
> +		dsll	k1, 16
> +#endif
> +		LONG_SRL	k0, PTEBASE_SHIFT
> +		andi	k0, CPU_ID_MASK /* high bits indicate guest mode. */
> +		LONG_ADDU	k1, k0
> +		LONG_L	k1, %lo(mips_kvm_rootsp)(k1)
> +		.endm
> +
>  		.macro	set_saved_sp stackp temp temp2
>  		CPU_ID_MFC0	\temp, CPU_ID_REG
>  		LONG_SRL	\temp, PTEBASE_SHIFT
> +#ifdef CONFIG_KVM_MIPSVZ
> +		andi	k0, CPU_ID_MASK /* high bits indicate guest mode. */
> +#endif
>  		LONG_S	\stackp, kernelsp(\temp)
>  		.endm
> +
> +		.macro	set_mips_kvm_rootsp stackp temp
> +		CPU_ID_MFC0	\temp, CPU_ID_REG
> +		LONG_SRL	\temp, PTEBASE_SHIFT
> +		andi	k0, CPU_ID_MASK /* high bits indicate guest mode. */

Should that be s/k0/\temp/?

> +		LONG_S	\stackp, mips_kvm_rootsp(\temp)
> +		.endm
>  #else
>  		.macro	get_saved_sp	/* Uniprocessor variation */
>  #ifdef CONFIG_CPU_JUMP_WORKAROUNDS
> @@ -152,9 +189,27 @@
>  		LONG_L	k1, %lo(kernelsp)(k1)
>  		.endm
> =20
> +		.macro	get_mips_kvm_rootsp	/* Uniprocessor variation */
> +#if defined(CONFIG_32BIT) || defined(KBUILD_64BIT_SYM32)
> +		lui	k1, %hi(mips_kvm_rootsp)
> +#else
> +		lui	k1, %highest(mips_kvm_rootsp)
> +		daddiu	k1, %higher(mips_kvm_rootsp)
> +		dsll	k1, k1, 16
> +		daddiu	k1, %hi(mips_kvm_rootsp)
> +		dsll	k1, k1, 16
> +#endif
> +		LONG_L	k1, %lo(mips_kvm_rootsp)(k1)
> +		.endm
> +
> +
>  		.macro	set_saved_sp stackp temp temp2
>  		LONG_S	\stackp, kernelsp
>  		.endm
> +
> +		.macro	set_mips_kvm_rootsp stackp temp
> +		LONG_S	\stackp, mips_kvm_rootsp
> +		.endm
>  #endif
> =20
>  		.macro	SAVE_SOME
> @@ -164,11 +219,21 @@
>  		mfc0	k0, CP0_STATUS
>  		sll	k0, 3		/* extract cu0 bit */
>  		.set	noreorder
> +#ifdef CONFIG_KVM_MIPSVZ
> +		bgez	k0, 7f

brief comments around here would make it easier to follow, e.g.
/* from kernel */
=2E..

> +		 CPU_ID_MFC0	k0, CPU_ID_REG
> +		bgez	k0, 8f

/* from userland */

> +		 move	k1, sp

/* from guest */

> +		get_mips_kvm_rootsp
> +		b	8f
> +		 nop
> +#else
>  		bltz	k0, 8f
>  		 move	k1, sp
> +#endif
>  		.set	reorder
>  		/* Called from user mode, new stack. */
> -		get_saved_sp
> +7:		get_saved_sp_for_save_some

you don't appear to have defined a !CONFIG_SMP version of
get_saved_sp_for_save_some?

>  #ifndef CONFIG_CPU_DADDI_WORKAROUNDS
>  8:		move	k0, sp
>  		PTR_SUBU sp, k1, PT_SIZE
> @@ -227,6 +292,35 @@
>  		LONG_S	$31, PT_R31(sp)
>  		ori	$28, sp, _THREAD_MASK
>  		xori	$28, _THREAD_MASK
> +#ifdef CONFIG_KVM_MIPSVZ
> +		CPU_ID_MFC0	k0, CPU_ID_REG
> +		.set	noreorder
> +		bgez	k0, 8f
> +		/* Must clear GuestCtl0[GM] */
> +		 dins	k0, zero, 63, 1

Looks like we need a LONG_INS (and friends) defined in asm.h for this

> +		.set	reorder
> +		dmtc0	k0, CPU_ID_REG

Lets define a CPU_ID_MTC0 similar to CPU_ID_MFC0.

> +		mfc0	k0, CP0_GUESTCTL0
> +		ins	k0, zero, MIPS_GUESTCTL0B_GM, 1
> +		mtc0	k0, CP0_GUESTCTL0
> +		LONG_L	v0, TI_TASK($28)
> +		lw	v1, THREAD_MM_ASID(v0)
> +		dmtc0	v1, CP0_ENTRYHI

MTC0.

> +		LONG_L	v1, TASK_MM(v0)
> +		.set	noreorder
> +		jal	tlbmiss_handler_setup_pgd_array
> +		 LONG_L	a0, MM_PGD(v1)
> +		.set	reorder
> +		/*
> +		 * With KVM_MIPSVZ, we must not clobber k0/k1
> +		 * they were saved before they were used
> +		 */
> +8:
> +		MFC0	k0, CP0_KSCRATCH1
> +		MFC0	v1, CP0_KSCRATCH2
> +		LONG_S	k0, PT_R26(sp)
> +		LONG_S	v1, PT_R27(sp)
> +#endif
>  #ifdef CONFIG_CPU_CAVIUM_OCTEON
>  		.set	mips64
>  		pref	0, 0($28)	/* Prefetch the current pointer */
> @@ -439,10 +533,45 @@
>  		.set	mips0
>  #endif /* CONFIG_MIPS_MT_SMTC */
>  		LONG_L	v1, PT_EPC(sp)
> +		LONG_L	$25, PT_R25(sp)

Is this an optimisation? It's unclear why it's been moved.

>  		MTC0	v1, CP0_EPC
> +#ifdef CONFIG_KVM_MIPSVZ
> +	/*
> +	 * Only if TIF_GUESTMODE && sp is the saved KVM sp, return to
> +	 * guest mode.
> +	 */
> +		LONG_L	v0, TI_FLAGS($28)
> +		li	k1, _TIF_GUESTMODE
> +		and	v0, v0, k1
> +		beqz	v0, 8f
> +		CPU_ID_MFC0	k0, CPU_ID_REG
> +		get_mips_kvm_rootsp
> +		PTR_SUBU k1, k1, PT_SIZE
> +		bne	k1, sp, 8f
> +	/* Set the high order bit of CPU_ID_REG to indicate guest mode. */
> +		dli	v0, 1

I think li will do here.

> +		dmfc0	v1, CPU_ID_REG

CPU_ID_MFC0

> +		dins	v1, v0, 63, 1

LONG_INS

> +		dmtc0	v1, CPU_ID_REG

CPU_ID_MTC0

> +		/* Must set GuestCtl0[GM] */
> +		mfc0	v1, CP0_GUESTCTL0
> +		ins	v1, v0, MIPS_GUESTCTL0B_GM, 1
> +		mtc0	v1, CP0_GUESTCTL0
> +
> +		LONG_L	v0, TI_TASK($28)
> +		lw	v1, THREAD_GUEST_ASID(v0)
> +		dmtc0	v1, CP0_ENTRYHI

MTC0

> +		LONG_L	v1, THREAD_VCPU(v0)
> +		LONG_L	v1, KVM_VCPU_KVM(v1)
> +		LONG_L	v1, KVM_ARCH_IMPL(v1)
> +		.set	noreorder
> +		jal	tlbmiss_handler_setup_pgd_array
> +		 LONG_L	a0, KVM_MIPS_VZ_PGD(v1)
> +		.set	reorder
> +8:
> +#endif
>  		LONG_L	$31, PT_R31(sp)
>  		LONG_L	$28, PT_R28(sp)
> -		LONG_L	$25, PT_R25(sp)
>  #ifdef CONFIG_64BIT
>  		LONG_L	$8, PT_R8(sp)
>  		LONG_L	$9, PT_R9(sp)
>=20

Cheers
James


--nPNcRa8v7DDmoctP7esqv1m0w7SNaeO6F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSV/RcAAoJEKHZs+irPybfzMEQAIv3exXmG7EuWGa1RiKClqFN
uz8XsTjwEU2I19FeV2OcySKknJotiN7pS191G90q3zF+LDIZXxG2PY8/lAqN6sYC
r8uGa2UoBnasZ0yVB5YqXSAGvG2YcKcCBQfVd6AN1pPny6RywLbItphTxF35PRx+
WYQe7YXbfRTEXepVHPRLf1uMpodSL+xdOrIgyiUVvI9evJURiD0KNG3vMF6pmQis
PcP9D2VF1TvXBvEbk9INJNRDdi8T2vNlWvVU57UWjUHdI09YCJlhBn+CDoRM0RVJ
ZGu9dENKXwpUOC5XP2p9x2toyHfCWOI/Om8vHnQoRSgfUX/hLujiLOnDnoSmwWPH
yH9Cdq94oampnOLNt2OLwIRAwOiugBHZQLjRfSD9jZhSsVM979atkgXmSU3LoT3l
zh/Mz7S96e7MxGkO0peHM27DqK6bDgxXCGfw6byLrv9HyibLkMZEJMjxpyAcwWmQ
uOq/AfDbQsryQM8Bzs2bd2g94N3PT6M8PagOHLBd7KR8AqVEuLUWW9LHAzOug623
tEdWSt/BbQoNXRUJlubOwtS2NNO8li495dMH0ica8RuHpwoJ5seTpFEolxxoF8Xr
m8a8Aqiw9hZNA0VR3dgMAW4AZq3Z27n46xVEfkA57IfvvypZjJ+ltdmuxajfobk1
+3qSW5gkTGX6nJzG86A7
=Gs+h
-----END PGP SIGNATURE-----

--nPNcRa8v7DDmoctP7esqv1m0w7SNaeO6F--

