Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaIWEcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:32:41 -0400
Received: from ozlabs.org ([103.22.144.67]:48528 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaIWEcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:32:39 -0400
Date: Tue, 23 Sep 2014 14:32:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: linux-next: manual merge of the tiny tree with the tip tree
Message-ID: <20140923143232.5ffff46e@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/W0PVaB=RE712MmUYgW_dV/5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/W0PVaB=RE712MmUYgW_dV/5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Josh,

Today's linux-next merge of the tiny tree got conflicts in
arch/x86/kernel/process_32.c and arch/x86/kernel/process_64.c between
commits dc56c0f9b870 ("x86, fpu: Shift "fpu_counter =3D 0" from
copy_thread() to arch_dup_task_struct()") and 6f46b3aef003 ("x86:
copy_thread: Don't nullify ->ptrace_bps twice") from the tip tree and
commits a1cf09f93e66 ("x86: process: Unify 32-bit and 64-bit
copy_thread I/O bitmap handling") and e4a191d1e05b ("x86: Support
compiling out userspace I/O (iopl and ioperm)") from the tiny tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/process_32.c
index 8f3ebfe710d0,e37f006fda6e..000000000000
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@@ -153,7 -153,9 +154,7 @@@ int copy_thread(unsigned long clone_fla
  		childregs->orig_ax =3D -1;
  		childregs->cs =3D __KERNEL_CS | get_kernel_rpl();
  		childregs->flags =3D X86_EFLAGS_IF | X86_EFLAGS_FIXED;
- 		p->thread.io_bitmap_ptr =3D NULL;
 -		p->thread.fpu_counter =3D 0;
+ 		clear_thread_io_bitmap(p);
 -		memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
  		return 0;
  	}
  	*childregs =3D *current_pt_regs();
@@@ -164,22 -166,12 +165,9 @@@
  	p->thread.ip =3D (unsigned long) ret_from_fork;
  	task_user_gs(p) =3D get_user_gs(current_pt_regs());
 =20
- 	p->thread.io_bitmap_ptr =3D NULL;
 -	p->thread.fpu_counter =3D 0;
+ 	clear_thread_io_bitmap(p);
  	tsk =3D current;
- 	err =3D -ENOMEM;
-=20
- 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
- 		p->thread.io_bitmap_ptr =3D kmemdup(tsk->thread.io_bitmap_ptr,
- 						IO_BITMAP_BYTES, GFP_KERNEL);
- 		if (!p->thread.io_bitmap_ptr) {
- 			p->thread.io_bitmap_max =3D 0;
- 			return -ENOMEM;
- 		}
- 		set_tsk_thread_flag(p, TIF_IO_BITMAP);
- 	}
-=20
- 	err =3D 0;
 =20
 -	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 -
  	/*
  	 * Set a new TLS for the child thread?
  	 */
diff --cc arch/x86/kernel/process_64.c
index 3ed4a68d4013,80f348659edd..000000000000
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@@ -163,7 -164,8 +164,7 @@@ int copy_thread(unsigned long clone_fla
  	p->thread.sp =3D (unsigned long) childregs;
  	p->thread.usersp =3D me->thread.usersp;
  	set_tsk_thread_flag(p, TIF_FORK);
- 	p->thread.io_bitmap_ptr =3D NULL;
 -	p->thread.fpu_counter =3D 0;
+ 	clear_thread_io_bitmap(p);
 =20
  	savesegment(gs, p->thread.gsindex);
  	p->thread.gs =3D p->thread.gsindex ? 0 : me->thread.gs;
@@@ -191,17 -193,8 +192,6 @@@
  	if (sp)
  		childregs->sp =3D sp;
 =20
- 	err =3D -ENOMEM;
- 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
- 		p->thread.io_bitmap_ptr =3D kmemdup(me->thread.io_bitmap_ptr,
- 						  IO_BITMAP_BYTES, GFP_KERNEL);
- 		if (!p->thread.io_bitmap_ptr) {
- 			p->thread.io_bitmap_max =3D 0;
- 			return -ENOMEM;
- 		}
- 		set_tsk_thread_flag(p, TIF_IO_BITMAP);
- 	}
 -	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
--
  	/*
  	 * Set a new TLS for the child thread?
  	 */

--Sig_/W0PVaB=RE712MmUYgW_dV/5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUIPfkAAoJEMDTa8Ir7ZwVMmQP/3Q3r9PNTzf14poTxHvUe26O
gc3EO6L9PERiHq4zFLYD+SCDOdlwULebIG5V9d7E1HznPXH34EYH24f+VtbnA03G
HAaSYoqCRasQBxVLJuHCbTu5YJVXPsWM24eRoBmdrVce3bYJygjBabYl01kC+/h/
UqamcefPmzJaJQ+SUXUrAB6yuOi0Zdx8oyQ/2YJB2Ul6N8dcdUGeAeqa+0w+ca/T
RV6kYJ2pwuvNuRUzqePTurmvJPyoO/1FFRyhbp0tjL2Ou5BoKY7xHmm5ad+GzZg+
TBopQI2YZxYWIDoKvzknofBJ/dlphU7b9TZCI+wHKx0iObq/OAPsT7v7zxRt1LpT
lqPfCB7fRVmM6U+VIYjIfPPEkKZK8H3bIrMdXV7zxtsc5UX36ewWyhGGZXLwxUYH
EbOlE8//llIHH5YyKq2yZ64UqM/vhMBye9l8yJwOyXgPRC8WMFTYthFQAkrV074M
oIH8DNB7jS6c3iobASFCzFy3wdALbFStO3jFne0y2GGB5X1ygUPfF6gQ/++BCA2U
p2NDHBTnVbQy2lzjtPf8FtbWiPTbWhONXxLqL0zKc+XlpVI82d7ulHguN9A6TIcm
mgTytRvlK+QKP3p4elf40SZltj7SfP2YW9oft2STWAu+Qjh6PGEdbrXSn2wP3vFO
psnmJCnC4asZwOPFWEuz
=d8w6
-----END PGP SIGNATURE-----

--Sig_/W0PVaB=RE712MmUYgW_dV/5--
