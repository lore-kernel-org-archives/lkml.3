Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab3JILKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:10:19 -0400
Received: from multi.imgtec.com ([194.200.65.239]:18666 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab3JILKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:10:17 -0400
Message-ID: <52553980.6020704@imgtec.com>
Date: Wed, 9 Oct 2013 12:09:52 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <vgupta@synopsys.com>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <hskinnemoen@gmail.com>, <egtvedt@samfundet.no>, <vapier@gentoo.org>,
        <msalter@redhat.com>, <a-jacquiot@ti.com>, <starvik@axis.com>,
        <jesper.nilsson@axis.com>, <dhowells@redhat.com>,
        <rkuo@codeaurora.org>, <tony.luck@intel.com>, <fenghua.yu@intel.com>,
        <takata@linux-m32r.org>, <geert@linux-m68k.org>, <monstr@monstr.eu>,
        <yasutake.koichi@jp.panasonic.com>, <ralf@linux-mips.org>,
        <jonas@southpole.se>, <jejb@parisc-linux.org>, <deller@gmx.de>,
        <benh@kernel.crashing.org>, <paulus@samba.org>,
        <schwidefsky@de.ibm.com>, <heiko.carstens@de.ibm.com>,
        <liqin.linux@gmail.com>, <lennox.wu@gmail.com>, <lethal@linux-sh.org>,
        <cmetcalf@tilera.com>, <gxt@mprc.pku.edu.cn>,
        <linux-xtensa@linux-xtensa.org>, <akpm@linux-foundation.org>,
        <oleg@redhat.com>, <tj@kernel.org>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH 13/29] metag: Use get_signal() signal_setup_done()
References: <1381231994-4192-1-git-send-email-richard@nod.at> <1381231994-4192-4-git-send-email-richard@nod.at>
In-Reply-To: <1381231994-4192-4-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="gASKUWF2VMSLkQmVaXPJ5sHL2qD9t9iT2"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_10_09_12_10_02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gASKUWF2VMSLkQmVaXPJ5sHL2qD9t9iT2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Richard,

(cc'd linux-metag)

On 08/10/13 12:33, Richard Weinberger wrote:
> Use the more generic functions get_signal() signal_setup_done()
> for signal delivery.
>=20
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/metag/kernel/signal.c | 55 ++++++++++++++++++++------------------=
--------
>  1 file changed, 24 insertions(+), 31 deletions(-)
>=20
> diff --git a/arch/metag/kernel/signal.c b/arch/metag/kernel/signal.c
> index 3be61cf..9fa27c2 100644
> --- a/arch/metag/kernel/signal.c
> +++ b/arch/metag/kernel/signal.c
> @@ -152,18 +152,18 @@ static void __user *get_sigframe(struct k_sigacti=
on *ka, unsigned long sp,
>  	return (void __user *)sp;
>  }
> =20
> -static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *=
info,
> -			  sigset_t *set, struct pt_regs *regs)
> +static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
> +			  struct pt_regs *regs)
>  {
>  	struct rt_sigframe __user *frame;
> -	int err =3D -EFAULT;
> +	int err;
>  	unsigned long code;
> =20
> -	frame =3D get_sigframe(ka, regs->REG_SP, sizeof(*frame));
> +	frame =3D get_sigframe(&ksig->ka, regs->REG_SP, sizeof(*frame));
>  	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
> -		goto out;
> +		return -EFAULT;
> =20
> -	err =3D copy_siginfo_to_user(&frame->info, info);
> +	err =3D copy_siginfo_to_user(&frame->info, &ksig->info);
> =20
>  	/* Create the ucontext.  */
>  	err |=3D __put_user(0, &frame->uc.uc_flags);
> @@ -174,7 +174,7 @@ static int setup_rt_frame(int sig, struct k_sigacti=
on *ka, siginfo_t *info,
>  	err |=3D __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
> =20
>  	if (err)
> -		goto out;
> +		return -EFAULT;
> =20
>  	/* Set up to return from userspace.  */
> =20
> @@ -187,15 +187,15 @@ static int setup_rt_frame(int sig, struct k_sigac=
tion *ka, siginfo_t *info,
>  	err |=3D __put_user(code, (unsigned long __user *)(&frame->retcode[1]=
));
> =20
>  	if (err)
> -		goto out;
> +		return -EFAULT;
> =20
>  	/* Set up registers for signal handler */
>  	regs->REG_RTP =3D (unsigned long) frame->retcode;
>  	regs->REG_SP =3D (unsigned long) frame + sizeof(*frame);
> -	regs->REG_ARG1 =3D sig;
> +	regs->REG_ARG1 =3D ksig->sig;
>  	regs->REG_ARG2 =3D (unsigned long) &frame->info;
>  	regs->REG_ARG3 =3D (unsigned long) &frame->uc;
> -	regs->REG_PC =3D (unsigned long) ka->sa.sa_handler;
> +	regs->REG_PC =3D (unsigned long) ksig->ka.sa.sa_handler;
> =20
>  	pr_debug("SIG deliver (%s:%d): sp=3D%p pc=3D%08x pr=3D%08x\n",
>  		 current->comm, current->pid, frame, regs->REG_PC,
> @@ -205,24 +205,19 @@ static int setup_rt_frame(int sig, struct k_sigac=
tion *ka, siginfo_t *info,
>  	 * effective cache flush - directed rather than 'full flush'.
>  	 */
>  	flush_cache_sigtramp(regs->REG_RTP, sizeof(frame->retcode));
> -out:
> -	if (err) {
> -		force_sigsegv(sig, current);
> -		return -EFAULT;
> -	}
> +
>  	return 0;
>  }
> =20
> -static void handle_signal(unsigned long sig, siginfo_t *info,
> -			  struct k_sigaction *ka, struct pt_regs *regs)
> +static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
>  {
>  	sigset_t *oldset =3D sigmask_to_save();
> +	int ret;
> =20
>  	/* Set up the stack frame */
> -	if (setup_rt_frame(sig, ka, info, oldset, regs))
> -		return;
> +	ret =3D setup_rt_frame(ksig, oldset, regs);
> =20
> -	signal_delivered(sig, info, ka, regs, test_thread_flag(TIF_SINGLESTEP=
));
> +	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
>  }
> =20
>   /*
> @@ -235,10 +230,8 @@ static void handle_signal(unsigned long sig, sigin=
fo_t *info,
>  static int do_signal(struct pt_regs *regs, int syscall)
>  {
>  	unsigned int retval =3D 0, continue_addr =3D 0, restart_addr =3D 0;
> -	struct k_sigaction ka;
> -	siginfo_t info;
> -	int signr;
>  	int restart =3D 0;
> +	struct ksignal ksig;
> =20
>  	/*
>  	 * By the end of rt_sigreturn the context describes the point that th=
e
> @@ -272,30 +265,30 @@ static int do_signal(struct pt_regs *regs, int sy=
scall)
>  	}
> =20
>  	/*
> -	 * Get the signal to deliver. When running under ptrace, at this poin=
t
> -	 * the debugger may change all our registers ...
> -	 */
> -	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
> -	/*
>  	 * Depending on the signal settings we may need to revert the decisio=
n
>  	 * to restart the system call. But skip this if a debugger has chosen=
 to
>  	 * restart at a different PC.
>  	 */
>  	if (regs->REG_PC !=3D restart_addr)
>  		restart =3D 0;

You've reordered the point where a ptrace debugger can change the registe=
rs
(get_signal_to_deliver) and the check of whether the PC has been changed =
by
the debugger (REG_PC !=3D restart_addr).

I suggest this is changed to do something like 7e243643 (arm: switch to s=
truct
ksignal * passing) does, moving the above REG_PC !=3D restart_addr check =
into
the restart conditions below.

> -	if (signr > 0) {
> +
> +	/*
> +	 * Get the signal to deliver. When running under ptrace, at this poin=
t
> +	 * the debugger may change all our registers ...
> +	 */
> +	if (get_signal(&ksig)) {
>  		if (unlikely(restart)) {
>  			if (retval =3D=3D -ERESTARTNOHAND
>  			    || retval =3D=3D -ERESTART_RESTARTBLOCK
>  			    || (retval =3D=3D -ERESTARTSYS
> -				&& !(ka.sa.sa_flags & SA_RESTART))) {
> +				&& !(ksig.ka.sa.sa_flags & SA_RESTART))) {
>  				regs->REG_RETVAL =3D -EINTR;
>  				regs->REG_PC =3D continue_addr;
>  			}
>  		}
> =20
>  		/* Whee! Actually deliver the signal.  */
> -		handle_signal(signr, &info, &ka, regs);
> +		handle_signal(&ksig, regs);
>  		return 0;
>  	}
> =20
>=20

How does the fixup patch below look?

The rest looks good, so other than that problem:
Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks
James

diff --git a/arch/metag/kernel/signal.c b/arch/metag/kernel/signal.c
index 9fa27c2..6f64ea2 100644
--- a/arch/metag/kernel/signal.c
+++ b/arch/metag/kernel/signal.c
@@ -265,19 +265,16 @@ static int do_signal(struct pt_regs *regs, int sysc=
all)
 	}
=20
 	/*
+	 * Get the signal to deliver. When running under ptrace, at this point
+	 * the debugger may change all our registers ...
+	 *
 	 * Depending on the signal settings we may need to revert the decision
 	 * to restart the system call. But skip this if a debugger has chosen t=
o
 	 * restart at a different PC.
 	 */
-	if (regs->REG_PC !=3D restart_addr)
-		restart =3D 0;
-
-	/*
-	 * Get the signal to deliver. When running under ptrace, at this point
-	 * the debugger may change all our registers ...
-	 */
 	if (get_signal(&ksig)) {
-		if (unlikely(restart)) {
+		/* Handler */
+		if (unlikely(restart) && regs->REG_PC =3D=3D restart_addr) {
 			if (retval =3D=3D -ERESTARTNOHAND
 			    || retval =3D=3D -ERESTART_RESTARTBLOCK
 			    || (retval =3D=3D -ERESTARTSYS
@@ -289,19 +286,24 @@ static int do_signal(struct pt_regs *regs, int sysc=
all)
=20
 		/* Whee! Actually deliver the signal.  */
 		handle_signal(&ksig, regs);
-		return 0;
-	}
-
-	/* Handlerless -ERESTART_RESTARTBLOCK re-enters via restart_syscall */
-	if (unlikely(restart < 0))
-		regs->REG_SYSCALL =3D __NR_restart_syscall;
-
-	/*
-	 * If there's no signal to deliver, we just put the saved sigmask back.=

-	 */
-	restore_saved_sigmask();
+	} else {
+		/*
+		 * If there's no signal to deliver, we just put the saved
+		 * sigmask back.
+		 */
+		restore_saved_sigmask();
=20
-	return restart;
+		/*
+		 * Handlerless -ERESTART_RESTARTBLOCK re-enters via
+		 * restart_syscall
+		 */
+		if (unlikely(restart) && regs->REG_PC =3D=3D restart_addr) {
+			if (restart < 0)
+				regs->REG_SYSCALL =3D __NR_restart_syscall;
+			return restart;
+		}
+	}
+	return 0;
 }
=20
 int do_work_pending(struct pt_regs *regs, unsigned int thread_flags,


--gASKUWF2VMSLkQmVaXPJ5sHL2qD9t9iT2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSVTmGAAoJEKHZs+irPybf01YP+gLmckIjBnXeF42LKuOt2RTu
iKOmZZQ0rOxyW9qridMUz7nN+fzwaP/+iUXE9HXY6jhExpdnQFFccBgJRszumpoi
RZUAAX1PLtf9kpw9q8ZL3TtOmNS9RAn7ymyl1Cv9atSdiZBFD948WH5D+q4AWzRh
4V5D6HIWkojqGE+srOfm4WCKCYoXonNzgQtPQ2eVtZdM5UZsmDSeuqYuFR0Z1z14
/E/e8oFU6xzH5TE1saGO1E+Nm5YZlulm+YhBh85tGk2CIAaRB9A+tAMgPYn3wddq
83Pe2S/ARvV25qRGT4xbObkb5qWAqAnbjxpP5IkNSLi9ArLtuB7WSEs3v3/3Xtay
DPTrDgc5Bm+EU4VGqb3NDjDLXh3yjT5B47Sks6kX98f2BCMPxbts5lHAyJtUwUNY
UhLthzxX/SKXUBIgIlpLVdqCQ/iSWgDprJNwqtOSO2vRUGI2wng6NQhf2DJq1T0d
5I+62s9UiJyL0f0TNQewksiE2Rxh7ThuRc7OWNLRfOsw1s9GJ8wEt2zcIpI0aS5Q
8ojBN6lXCeBamsUdRYS9Ux7PxISW2VNecbPdn6R5Dzd35Btqta0ko7KmI1aQefaV
b80sSjySNogFXbEFyYCcKOS6qoWJhzZ79J2GH+J5sYyC+B94X2UZsn0GA8Gj8G7Q
0RlHEmpusYa79LX0CUY3
=Y+hn
-----END PGP SIGNATURE-----

--gASKUWF2VMSLkQmVaXPJ5sHL2qD9t9iT2--

