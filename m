Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaIXFrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:47:47 -0400
Received: from ozlabs.org ([103.22.144.67]:40870 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaIXFrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:47:45 -0400
Date: Wed, 24 Sep 2014 15:47:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: linux-next: manual merge of the tip tree with the audit tree
Message-ID: <20140924154737.50db90eb@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.9Pw.rTSoBVLGw5_Un.O+r9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.9Pw.rTSoBVLGw5_Un.O+r9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/ptrace.c between commit 91397401bb50 ("ARCH: AUDIT:
audit_syscall_entry() should not require the arch") from the audit tree
and commit e0ffbaabc46d ("x86: Split syscall_trace_enter into two
phases") from the tip tree.

I fixed it up (see below - there is more cleanup possible since
do_audit_syscall_entry() no longer needs its "arch" argument) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/ptrace.c
index eb1c87f0b03b,29576c244699..000000000000
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@@ -1441,24 -1441,126 +1441,126 @@@ void send_sigtrap(struct task_struct *t
  	force_sig_info(SIGTRAP, &info, tsk);
  }
 =20
-=20
- #ifdef CONFIG_X86_32
- # define IS_IA32	1
- #elif defined CONFIG_IA32_EMULATION
- # define IS_IA32	is_compat_task()
- #else
- # define IS_IA32	0
+ static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
+ {
+ #ifdef CONFIG_X86_64
+ 	if (arch =3D=3D AUDIT_ARCH_X86_64) {
 -		audit_syscall_entry(arch, regs->orig_ax, regs->di,
++		audit_syscall_entry(regs->orig_ax, regs->di,
+ 				    regs->si, regs->dx, regs->r10);
+ 	} else
  #endif
+ 	{
 -		audit_syscall_entry(arch, regs->orig_ax, regs->bx,
++		audit_syscall_entry(regs->orig_ax, regs->bx,
+ 				    regs->cx, regs->dx, regs->si);
+ 	}
+ }
 =20
  /*
-  * We must return the syscall number to actually look up in the table.
-  * This can be -1L to skip running any syscall at all.
+  * We can return 0 to resume the syscall or anything else to go to phase
+  * 2.  If we resume the syscall, we need to put something appropriate in
+  * regs->orig_ax.
+  *
+  * NB: We don't have full pt_regs here, but regs->orig_ax and regs->ax
+  * are fully functional.
+  *
+  * For phase 2's benefit, our return value is:
+  * 0:			resume the syscall
+  * 1:			go to phase 2; no seccomp phase 2 needed
+  * anything else:	go to phase 2; pass return value to seccomp
   */
- long syscall_trace_enter(struct pt_regs *regs)
+ unsigned long syscall_trace_enter_phase1(struct pt_regs *regs, u32 arch)
+ {
+ 	unsigned long ret =3D 0;
+ 	u32 work;
+=20
+ 	BUG_ON(regs !=3D task_pt_regs(current));
+=20
+ 	work =3D ACCESS_ONCE(current_thread_info()->flags) &
+ 		_TIF_WORK_SYSCALL_ENTRY;
+=20
+ 	/*
+ 	 * If TIF_NOHZ is set, we are required to call user_exit() before
+ 	 * doing anything that could touch RCU.
+ 	 */
+ 	if (work & _TIF_NOHZ) {
+ 		user_exit();
+ 		work &=3D ~TIF_NOHZ;
+ 	}
+=20
+ #ifdef CONFIG_SECCOMP
+ 	/*
+ 	 * Do seccomp first -- it should minimize exposure of other
+ 	 * code, and keeping seccomp fast is probably more valuable
+ 	 * than the rest of this.
+ 	 */
+ 	if (work & _TIF_SECCOMP) {
+ 		struct seccomp_data sd;
+=20
+ 		sd.arch =3D arch;
+ 		sd.nr =3D regs->orig_ax;
+ 		sd.instruction_pointer =3D regs->ip;
+ #ifdef CONFIG_X86_64
+ 		if (arch =3D=3D AUDIT_ARCH_X86_64) {
+ 			sd.args[0] =3D regs->di;
+ 			sd.args[1] =3D regs->si;
+ 			sd.args[2] =3D regs->dx;
+ 			sd.args[3] =3D regs->r10;
+ 			sd.args[4] =3D regs->r8;
+ 			sd.args[5] =3D regs->r9;
+ 		} else
+ #endif
+ 		{
+ 			sd.args[0] =3D regs->bx;
+ 			sd.args[1] =3D regs->cx;
+ 			sd.args[2] =3D regs->dx;
+ 			sd.args[3] =3D regs->si;
+ 			sd.args[4] =3D regs->di;
+ 			sd.args[5] =3D regs->bp;
+ 		}
+=20
+ 		BUILD_BUG_ON(SECCOMP_PHASE1_OK !=3D 0);
+ 		BUILD_BUG_ON(SECCOMP_PHASE1_SKIP !=3D 1);
+=20
+ 		ret =3D seccomp_phase1(&sd);
+ 		if (ret =3D=3D SECCOMP_PHASE1_SKIP) {
+ 			regs->orig_ax =3D -1;
+ 			ret =3D 0;
+ 		} else if (ret !=3D SECCOMP_PHASE1_OK) {
+ 			return ret;  /* Go directly to phase 2 */
+ 		}
+=20
+ 		work &=3D ~_TIF_SECCOMP;
+ 	}
+ #endif
+=20
+ 	/* Do our best to finish without phase 2. */
+ 	if (work =3D=3D 0)
+ 		return ret;  /* seccomp and/or nohz only (ret =3D=3D 0 here) */
+=20
+ #ifdef CONFIG_AUDITSYSCALL
+ 	if (work =3D=3D _TIF_SYSCALL_AUDIT) {
+ 		/*
+ 		 * If there is no more work to be done except auditing,
+ 		 * then audit in phase 1.  Phase 2 always audits, so, if
+ 		 * we audit here, then we can't go on to phase 2.
+ 		 */
+ 		do_audit_syscall_entry(regs, arch);
+ 		return 0;
+ 	}
+ #endif
+=20
+ 	return 1;  /* Something is enabled that we can't handle in phase 1 */
+ }
+=20
+ /* Returns the syscall nr to run (which should match regs->orig_ax). */
+ long syscall_trace_enter_phase2(struct pt_regs *regs, u32 arch,
+ 				unsigned long phase1_result)
  {
  	long ret =3D 0;
+ 	u32 work =3D ACCESS_ONCE(current_thread_info()->flags) &
+ 		_TIF_WORK_SYSCALL_ENTRY;
 =20
- 	user_exit();
+ 	BUG_ON(regs !=3D task_pt_regs(current));
 =20
  	/*
  	 * If we stepped into a sysenter/syscall insn, it trapped in

--Sig_/.9Pw.rTSoBVLGw5_Un.O+r9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUIlr9AAoJEMDTa8Ir7ZwVtn0P/14MLH8jPYrOSHgxfZmZr0T3
Z2CB0tL0fT5yWGtvzad9ny26+579Qupa4NlC/LerdMVDSMM1WNp1INJRusVfNFd1
SThkjaUFVuc0Z0uU66YIhPTgFXj7cntceLzxjNA/KU/Uazj5VDDacuMMK9mqamBc
qUSMEo6fKt2x0X9JqW6pe1Eu2zlPjnhCV45mr8KcxTj45sUYHXpEjNoE07n4gTsw
oiIFKglMNP0GcLJ4giDmW8uqYPOS8sDxfayOuUvDn6sUn+q9Cq9G2NmR7V3gaOZT
tOaemLNWThWRdL49e3/iuo+wrV8Al8S/g8kDncAgILRrlY3zWJ0KJU09refsGy+/
GWQIk+TZDYImi7Fe7hAZOGwut/4scWvcXT8ywRpzmnps/3E6RECsMIHK549uysr4
5MF/H2oWQxMmtVAo9/qnsPN4viehDHjp3suEG2ZORqd6JwKfXQUJgbUUBwhFcvqk
r4zCwwWMWsQGdS6JqeXaAqFQoJctcCnwDYnV4fpfRU04ml2F+EXdsIGQ4/vV0KDv
RWDZpoa5O3qJgS9GKYQA9vSO3AzZWHLVNlL2xznYHdvJNFITds+Qqg5CEwAvV28r
YX1vyjrwE33hV5vuyVN8FkY7ERy1EIm+2QN4xo3mYRzZCnWuhO9IHSzeSTzmF3/Q
zCgRBCigRADKIaenPpEO
=pIQp
-----END PGP SIGNATURE-----

--Sig_/.9Pw.rTSoBVLGw5_Un.O+r9--
