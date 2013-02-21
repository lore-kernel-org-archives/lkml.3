Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab3BUEwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 23:52:22 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47078 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab3BUEwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 23:52:21 -0500
Date: Thu, 21 Feb 2013 15:52:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the signal tree with the powerpc tree
Message-Id: <20130221155208.bcb1295ab9bdecf394d48bfc@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Feb_2013_15_52_08_+1100_kq=5zqOSOODP4M5x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Feb_2013_15_52_08_+1100_kq=5zqOSOODP4M5x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got conflicts in
arch/powerpc/kernel/signal_32.c and arch/powerpc/kernel/signal_64.c
between commit 2b0a576d15e0 ("powerpc: Add new transactional memory state
to the signal context") from the powerpc tree and commit 7cce246557bf
("powerpc: switch to generic sigaltstack") from the signal tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/kernel/signal_32.c
index e4a88d3,802ab5e..0000000
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@@ -817,223 -513,7 +742,140 @@@ static long restore_user_regs(struct pt
  	return 0;
  }
 =20
 +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 +/*
 + * Restore the current user register values from the user stack, except f=
or
 + * MSR, and recheckpoint the original checkpointed register state for pro=
cesses
 + * in transactions.
 + */
 +static long restore_tm_user_regs(struct pt_regs *regs,
 +				 struct mcontext __user *sr,
 +				 struct mcontext __user *tm_sr)
 +{
 +	long err;
 +	unsigned long msr;
 +#ifdef CONFIG_VSX
 +	int i;
 +#endif
 +
 +	/*
 +	 * restore general registers but not including MSR or SOFTE. Also
 +	 * take care of keeping r2 (TLS) intact if not a signal.
 +	 * See comment in signal_64.c:restore_tm_sigcontexts();
 +	 * TFHAR is restored from the checkpointed NIP; TEXASR and TFIAR
 +	 * were set by the signal delivery.
 +	 */
 +	err =3D restore_general_regs(regs, tm_sr);
 +	err |=3D restore_general_regs(&current->thread.ckpt_regs, sr);
 +
 +	err |=3D __get_user(current->thread.tm_tfhar, &sr->mc_gregs[PT_NIP]);
 +
 +	err |=3D __get_user(msr, &sr->mc_gregs[PT_MSR]);
 +	if (err)
 +		return 1;
 +
 +	/* Restore the previous little-endian mode */
 +	regs->msr =3D (regs->msr & ~MSR_LE) | (msr & MSR_LE);
 +
 +	/*
 +	 * Do this before updating the thread state in
 +	 * current->thread.fpr/vr/evr.  That way, if we get preempted
 +	 * and another task grabs the FPU/Altivec/SPE, it won't be
 +	 * tempted to save the current CPU state into the thread_struct
 +	 * and corrupt what we are writing there.
 +	 */
 +	discard_lazy_cpu_state();
 +
 +#ifdef CONFIG_ALTIVEC
 +	regs->msr &=3D ~MSR_VEC;
 +	if (msr & MSR_VEC) {
 +		/* restore altivec registers from the stack */
 +		if (__copy_from_user(current->thread.vr, &sr->mc_vregs,
 +				     sizeof(sr->mc_vregs)) ||
 +		    __copy_from_user(current->thread.transact_vr,
 +				     &tm_sr->mc_vregs,
 +				     sizeof(sr->mc_vregs)))
 +			return 1;
 +	} else if (current->thread.used_vr) {
 +		memset(current->thread.vr, 0, ELF_NVRREG * sizeof(vector128));
 +		memset(current->thread.transact_vr, 0,
 +		       ELF_NVRREG * sizeof(vector128));
 +	}
 +
 +	/* Always get VRSAVE back */
 +	if (__get_user(current->thread.vrsave,
 +		       (u32 __user *)&sr->mc_vregs[32]) ||
 +	    __get_user(current->thread.transact_vrsave,
 +		       (u32 __user *)&tm_sr->mc_vregs[32]))
 +		return 1;
 +#endif /* CONFIG_ALTIVEC */
 +
 +	regs->msr &=3D ~(MSR_FP | MSR_FE0 | MSR_FE1);
 +
 +	if (copy_fpr_from_user(current, &sr->mc_fregs) ||
 +	    copy_transact_fpr_from_user(current, &tm_sr->mc_fregs))
 +		return 1;
 +
 +#ifdef CONFIG_VSX
 +	regs->msr &=3D ~MSR_VSX;
 +	if (msr & MSR_VSX) {
 +		/*
 +		 * Restore altivec registers from the stack to a local
 +		 * buffer, then write this out to the thread_struct
 +		 */
 +		if (copy_vsx_from_user(current, &sr->mc_vsregs) ||
 +		    copy_transact_vsx_from_user(current, &tm_sr->mc_vsregs))
 +			return 1;
 +	} else if (current->thread.used_vsr)
 +		for (i =3D 0; i < 32 ; i++) {
 +			current->thread.fpr[i][TS_VSRLOWOFFSET] =3D 0;
 +			current->thread.transact_fpr[i][TS_VSRLOWOFFSET] =3D 0;
 +		}
 +#endif /* CONFIG_VSX */
 +
 +#ifdef CONFIG_SPE
 +	/* SPE regs are not checkpointed with TM, so this section is
 +	 * simply the same as in restore_user_regs().
 +	 */
 +	regs->msr &=3D ~MSR_SPE;
 +	if (msr & MSR_SPE) {
 +		if (__copy_from_user(current->thread.evr, &sr->mc_vregs,
 +				     ELF_NEVRREG * sizeof(u32)))
 +			return 1;
 +	} else if (current->thread.used_spe)
 +		memset(current->thread.evr, 0, ELF_NEVRREG * sizeof(u32));
 +
 +	/* Always get SPEFSCR back */
 +	if (__get_user(current->thread.spefscr, (u32 __user *)&sr->mc_vregs
 +		       + ELF_NEVRREG))
 +		return 1;
 +#endif /* CONFIG_SPE */
 +
 +	/* Now, recheckpoint.  This loads up all of the checkpointed (older)
 +	 * registers, including FP and V[S]Rs.  After recheckpointing, the
 +	 * transactional versions should be loaded.
 +	 */
 +	tm_enable();
 +	/* This loads the checkpointed FP/VEC state, if used */
 +	tm_recheckpoint(&current->thread, msr);
 +	/* The task has moved into TM state S, so ensure MSR reflects this */
 +	regs->msr =3D (regs->msr & ~MSR_TS_MASK) | MSR_TS_S;
 +
 +	/* This loads the speculative FP/VEC state, if used */
 +	if (msr & MSR_FP) {
 +		do_load_up_transact_fpu(&current->thread);
 +		regs->msr |=3D (MSR_FP | current->thread.fpexc_mode);
 +	}
 +	if (msr & MSR_VEC) {
 +		do_load_up_transact_altivec(&current->thread);
 +		regs->msr |=3D MSR_VEC;
 +	}
 +
 +	return 0;
 +}
 +#endif
 +
  #ifdef CONFIG_PPC64
- long compat_sys_rt_sigaction(int sig, const struct sigaction32 __user *ac=
t,
- 		struct sigaction32 __user *oact, size_t sigsetsize)
- {
- 	struct k_sigaction new_ka, old_ka;
- 	int ret;
-=20
- 	/* XXX: Don't preclude handling different sized sigset_t's.  */
- 	if (sigsetsize !=3D sizeof(compat_sigset_t))
- 		return -EINVAL;
-=20
- 	if (act) {
- 		compat_uptr_t handler;
-=20
- 		ret =3D get_user(handler, &act->sa_handler);
- 		new_ka.sa.sa_handler =3D compat_ptr(handler);
- 		ret |=3D get_sigset_t(&new_ka.sa.sa_mask, &act->sa_mask);
- 		ret |=3D __get_user(new_ka.sa.sa_flags, &act->sa_flags);
- 		if (ret)
- 			return -EFAULT;
- 	}
-=20
- 	ret =3D do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
- 	if (!ret && oact) {
- 		ret =3D put_user(to_user_ptr(old_ka.sa.sa_handler), &oact->sa_handler);
- 		ret |=3D put_sigset_t(&oact->sa_mask, &old_ka.sa.sa_mask);
- 		ret |=3D __put_user(old_ka.sa.sa_flags, &oact->sa_flags);
- 	}
- 	return ret;
- }
-=20
- /*
-  * Note: it is necessary to treat how as an unsigned int, with the
-  * corresponding cast to a signed int to insure that the proper
-  * conversion (sign extension) between the register representation
-  * of a signed int (msr in 32-bit mode) and the register representation
-  * of a signed int (msr in 64-bit mode) is performed.
-  */
- long compat_sys_rt_sigprocmask(u32 how, compat_sigset_t __user *set,
- 		compat_sigset_t __user *oset, size_t sigsetsize)
- {
- 	sigset_t s;
- 	sigset_t __user *up;
- 	int ret;
- 	mm_segment_t old_fs =3D get_fs();
-=20
- 	if (set) {
- 		if (get_sigset_t(&s, set))
- 			return -EFAULT;
- 	}
-=20
- 	set_fs(KERNEL_DS);
- 	/* This is valid because of the set_fs() */
- 	up =3D (sigset_t __user *) &s;
- 	ret =3D sys_rt_sigprocmask((int)how, set ? up : NULL, oset ? up : NULL,
- 				 sigsetsize);
- 	set_fs(old_fs);
- 	if (ret)
- 		return ret;
- 	if (oset) {
- 		if (put_sigset_t(oset, &s))
- 			return -EFAULT;
- 	}
- 	return 0;
- }
-=20
- long compat_sys_rt_sigpending(compat_sigset_t __user *set, compat_size_t =
sigsetsize)
- {
- 	sigset_t s;
- 	int ret;
- 	mm_segment_t old_fs =3D get_fs();
-=20
- 	set_fs(KERNEL_DS);
- 	/* The __user pointer cast is valid because of the set_fs() */
- 	ret =3D sys_rt_sigpending((sigset_t __user *) &s, sigsetsize);
- 	set_fs(old_fs);
- 	if (!ret) {
- 		if (put_sigset_t(set, &s))
- 			return -EFAULT;
- 	}
- 	return ret;
- }
-=20
-=20
  int copy_siginfo_to_user32(struct compat_siginfo __user *d, siginfo_t *s)
  {
  	int err;
@@@ -1202,10 -607,8 +971,7 @@@ int handle_rt_signal32(unsigned long si
  	/* Put the siginfo & fill in most of the ucontext */
  	if (copy_siginfo_to_user(&rt_sf->info, info)
  	    || __put_user(0, &rt_sf->uc.uc_flags)
- 	    || __put_user(current->sas_ss_sp, &rt_sf->uc.uc_stack.ss_sp)
- 	    || __put_user(sas_ss_flags(regs->gpr[1]),
- 			  &rt_sf->uc.uc_stack.ss_flags)
- 	    || __put_user(current->sas_ss_size, &rt_sf->uc.uc_stack.ss_size)
 -	    || __put_user(0, &rt_sf->uc.uc_link)
+ 	    || __save_altstack(&rt_sf->uc.uc_stack, regs->gpr[1])
  	    || __put_user(to_user_ptr(&rt_sf->uc.uc_mcontext),
  		    &rt_sf->uc.uc_regs)
  	    || put_sigset_t(&rt_sf->uc.uc_sigmask, oldset))
diff --cc arch/powerpc/kernel/signal_64.c
index 7a76ee4,807b5b1..0000000
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@@ -723,29 -413,10 +721,26 @@@ int handle_rt_signal64(int signr, struc
 =20
  	/* Create the ucontext.  */
  	err |=3D __put_user(0, &frame->uc.uc_flags);
- 	err |=3D __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
- 	err |=3D __put_user(sas_ss_flags(regs->gpr[1]),
- 			  &frame->uc.uc_stack.ss_flags);
- 	err |=3D __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
 -	err |=3D __put_user(0, &frame->uc.uc_link);
+ 	err |=3D __save_altstack(&frame->uc.uc_stack, regs->gpr[1]);
 -	err |=3D setup_sigcontext(&frame->uc.uc_mcontext, regs, signr, NULL,
 -				(unsigned long)ka->sa.sa_handler, 1);
 +#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 +	if (MSR_TM_ACTIVE(regs->msr)) {
 +		/* The ucontext_t passed to userland points to the second
 +		 * ucontext_t (for transactional state) with its uc_link ptr.
 +		 */
 +		err |=3D __put_user(&frame->uc_transact, &frame->uc.uc_link);
 +		err |=3D setup_tm_sigcontexts(&frame->uc.uc_mcontext,
 +					    &frame->uc_transact.uc_mcontext,
 +					    regs, signr,
 +					    NULL,
 +					    (unsigned long)ka->sa.sa_handler);
 +	} else
 +#endif
 +	{
 +		err |=3D __put_user(0, &frame->uc.uc_link);
 +		err |=3D setup_sigcontext(&frame->uc.uc_mcontext, regs, signr,
 +					NULL, (unsigned long)ka->sa.sa_handler,
 +					1);
 +	}
  	err |=3D __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
  	if (err)
  		goto badframe;

--Signature=_Thu__21_Feb_2013_15_52_08_+1100_kq=5zqOSOODP4M5x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJaf4AAoJEECxmPOUX5FE680P/RyF3Dng1EdQFusJ/o/buy75
qXIN6q4/6dExKgil//YlDJtaUrnSzEPVNyUiZIVtvzAsp/TLU0MwdxxMQ9MbvCAN
AHC75Up0xoE9E7m1HpVN1l03utrbEBvOdrlOt9dg6rT5a2kIHAeT6UkdoCVwZOLT
2xHRrmepIN2+FGlrD1cD9a/pgw2gMWrsMDN7KeMpFGYxKVNpVp6pZsJNDu+0n13b
4nEx40KZq2Y+gM2JEeiWLrka1Fr8ahOwZppUeWRoZ7DsKhxpRLmdk00Kobs8+MAF
N59NCSEDZhCWWd9LqAr0YXTPs+ddPD/VZUuWRnZsu3HiMsUjdW3cQNug7cCBAJmW
3oSopCc6O77hvAgccwLpJ2k34VwVkNqhv1PVryYocb6us9x7IAKF/br0gGkzgwgC
5C+HpovlDzPq1Y5+qqnnCStpQJzCnTt6tMDoW5LnO9ybOqM4p813yKLkON1/1bsy
nd/XvFbcdLv+88MDKoN2YlKa70gbThNTaWz7wt9nQLDyCS9rEDq4RIiljpLrywsV
SFF2j1b+QJS1AvIxTNrmB0jVh4zm7jVVHRtP4LcRhemO561HymPN0KTYfOzWN2MH
BhKm0pl9bZazlwfex9kFNI3poi2xQFolOAj82/iC9GVV/vCFSCKI52pApr58ro+N
wvXtQL+ATe4s3HuPzqFp
=/FlX
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Feb_2013_15_52_08_+1100_kq=5zqOSOODP4M5x--
