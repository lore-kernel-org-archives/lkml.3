Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaHaSOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 14:14:32 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55034 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaHaSOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 14:14:31 -0400
Date: Sun, 31 Aug 2014 11:14:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] unicore32: Fix build error
Message-ID: <20140831181426.GA27355@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

unicore32 builds fail with

arch/unicore32/kernel/signal.c: In function =E2=80=98setup_frame=E2=80=99:
arch/unicore32/kernel/signal.c:257: error:
			=E2=80=98usig=E2=80=99 undeclared (first use in this function)
arch/unicore32/kernel/signal.c:279: error:
			=E2=80=98usig=E2=80=99 undeclared (first use in this function)
arch/unicore32/kernel/signal.c: In function =E2=80=98handle_signal=E2=80=99:
arch/unicore32/kernel/signal.c:306: warning: unused variable =E2=80=98tsk=
=E2=80=99
arch/unicore32/kernel/signal.c: In function =E2=80=98do_signal=E2=80=99:
arch/unicore32/kernel/signal.c:376: error:
			implicit declaration of function =E2=80=98get_signsl=E2=80=99
make[1]: *** [arch/unicore32/kernel/signal.o] Error 1
make: *** [arch/unicore32/kernel/signal.o] Error 2

Bisect points to commit 649671c90eaf ("unicore32: Use get_signal()
signal_setup_done()").

This code never even compiled. Reverting the patch does not work,
since previously used functions no longer exist, so try to fix it up.
Compile tested only.

Fixes: 649671c90eaf ("unicore32: Use get_signal() signal_setup_done()")
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Resending after rebase to current upstream kernel.

Linus, please consider adding this patch directly to your tree.
This is the one remaining build failure regression in the upstream kernel.

 arch/unicore32/kernel/signal.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
index 780d773..7c8fb70 100644
--- a/arch/unicore32/kernel/signal.c
+++ b/arch/unicore32/kernel/signal.c
@@ -254,7 +254,8 @@ static int setup_frame(struct ksignal *ksig, sigset_t *=
set,
=20
 	err |=3D setup_sigframe(frame, regs, set);
 	if (err =3D=3D 0)
-		err |=3D setup_return(regs, &ksig->ka, frame->retcode, frame, usig);
+		err |=3D setup_return(regs, &ksig->ka, frame->retcode, frame,
+				    ksig->sig);
=20
 	return err;
 }
@@ -276,7 +277,8 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_=
t *set,
 	err |=3D __save_altstack(&frame->sig.uc.uc_stack, regs->UCreg_sp);
 	err |=3D setup_sigframe(&frame->sig, regs, set);
 	if (err =3D=3D 0)
-		err |=3D setup_return(regs, &ksig->ka, frame->sig.retcode, frame, usig);
+		err |=3D setup_return(regs, &ksig->ka, frame->sig.retcode, frame,
+				    ksig->sig);
=20
 	if (err =3D=3D 0) {
 		/*
@@ -303,7 +305,6 @@ static void handle_signal(struct ksignal *ksig, struct =
pt_regs *regs,
 			  int syscall)
 {
 	struct thread_info *thread =3D current_thread_info();
-	struct task_struct *tsk =3D current;
 	sigset_t *oldset =3D sigmask_to_save();
 	int usig =3D ksig->sig;
 	int ret;
@@ -373,7 +374,7 @@ static void do_signal(struct pt_regs *regs, int syscall)
 	if (!user_mode(regs))
 		return;
=20
-	if (get_signsl(&ksig)) {
+	if (get_signal(&ksig)) {
 		handle_signal(&ksig, regs, syscall);
 		return;
 	}
--=20
1.9.1


--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUA2YCAAoJEMsfJm/On5mBSXMP/00k9foQm760ykmKDybZ89F8
R3OCxM0MC1X38q1I7sZQ4N14orj2GKf2O1RMGuf3YBHlBaUWR9nkY4kcJP9ggbxb
HpqgOj223j+7jyj72ZCq8X55PtBfoU5nHjnL68D8nwuZC8/yRPcWgSkNaG8HX3Pc
gPwizYxfi5//SoPC7PlSkeYFUQEo3zkoNU8477OataC00sStOc4tLfgxuIN9wAnc
jw4CsX8Z77Rs1dNHhoHEZ2BvkGtlfXCyP/AMW90P2IQ18AAir/wERzSt+BhAcYNJ
oNL5TPDxH+BNxGG11eSj2dv+B/wdsvfxHVKNZTHtKKLWMl3nSGpzOIGNuy6pqb0e
MNlVEw7C4R3TVSXgeg31RPCcQlpksvZX5t26QtTbgcCvOgP5zcWMX2+EvoNCdbmM
htzy2GFbKMxCzo3pgUcchmzE8y7k6CkeCCotNeBfUVXXLSnHbLyh5bTviVMnfCk4
lx83me6MvnIke9Vtmt57f9+Iart2/ASMxNnGEgAJNb8/rdav/ArfgMo8I920cqcw
Ky5mO9r0FQHNK32AumRn3Ejq+hMnSBuwpSY2UKsb3GG1Ed8RGwem+NBP//9d2Jjg
H17ZWc9jkdsUjkIywNAe8Kpz0yDf8tvJN4HyHM2D0leQfcyhfDIONr92ZsL5Ea64
GUmxxhuU2gIM78SBuxJA
=+/fi
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
