Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab3JRS0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 14:26:20 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:59195 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab3JRS0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 14:26:18 -0400
Message-ID: <52617D3C.1060702@gmail.com>
Date: Sat, 19 Oct 2013 02:26:04 +0800
From: Lennox Wu <lennox.wu@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 21/29] score: Use get_signal() signal_setup_done()
References: <1381232085-4288-1-git-send-email-richard@nod.at> <1381232085-4288-2-git-send-email-richard@nod.at>
In-Reply-To: <1381232085-4288-2-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="FI6OctkeeQg5sdGis9Vsk2gm9Escx9mO1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FI6OctkeeQg5sdGis9Vsk2gm9Escx9mO1
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: quoted-printable

It's fine for Score. Pass the compiling and other tests.
Thank you.
Acked-by: Lennox Wu <lennox.wu@gmail.com>

=A9=F3 2013/10/8 =A4U=A4=C8 07:34, Richard Weinberger =B4=A3=A8=EC:
> Use the more generic functions get_signal() signal_setup_done()
> for signal delivery.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/score/kernel/signal.c | 43 ++++++++++++++++++--------------------=
-----
>  1 file changed, 18 insertions(+), 25 deletions(-)
>
> diff --git a/arch/score/kernel/signal.c b/arch/score/kernel/signal.c
> index a00fba3..1651807 100644
> --- a/arch/score/kernel/signal.c
> +++ b/arch/score/kernel/signal.c
> @@ -173,15 +173,15 @@ badframe:
>  	return 0;
>  }
> =20
> -static int setup_rt_frame(struct k_sigaction *ka, struct pt_regs *regs=
,
> -		int signr, sigset_t *set, siginfo_t *info)
> +static int setup_rt_frame(struct ksignal *ksig, struct pt_regs *regs,
> +			  sigset_t *set)
>  {
>  	struct rt_sigframe __user *frame;
>  	int err =3D 0;
> =20
> -	frame =3D get_sigframe(ka, regs, sizeof(*frame));
> +	frame =3D get_sigframe(&ksig->ka, regs, sizeof(*frame));
>  	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
> -		goto give_sigsegv;
> +		return -EFAULT;
> =20
>  	/*
>  	 * Set up the return code ...
> @@ -194,7 +194,7 @@ static int setup_rt_frame(struct k_sigaction *ka, s=
truct pt_regs *regs,
>  	err |=3D __put_user(0x80008002, frame->rs_code + 1);
>  	flush_cache_sigtramp((unsigned long) frame->rs_code);
> =20
> -	err |=3D copy_siginfo_to_user(&frame->rs_info, info);
> +	err |=3D copy_siginfo_to_user(&frame->rs_info, &ksig->info);
>  	err |=3D __put_user(0, &frame->rs_uc.uc_flags);
>  	err |=3D __put_user(NULL, &frame->rs_uc.uc_link);
>  	err |=3D __save_altstack(&frame->rs_uc.uc_stack, regs->regs[0]);
> @@ -202,26 +202,23 @@ static int setup_rt_frame(struct k_sigaction *ka,=
 struct pt_regs *regs,
>  	err |=3D __copy_to_user(&frame->rs_uc.uc_sigmask, set, sizeof(*set));=

> =20
>  	if (err)
> -		goto give_sigsegv;
> +		return -EFAULT;
> =20
>  	regs->regs[0] =3D (unsigned long) frame;
>  	regs->regs[3] =3D (unsigned long) frame->rs_code;
> -	regs->regs[4] =3D signr;
> +	regs->regs[4] =3D ksig->sig;
>  	regs->regs[5] =3D (unsigned long) &frame->rs_info;
>  	regs->regs[6] =3D (unsigned long) &frame->rs_uc;
> -	regs->regs[29] =3D (unsigned long) ka->sa.sa_handler;
> -	regs->cp0_epc =3D (unsigned long) ka->sa.sa_handler;
> +	regs->regs[29] =3D (unsigned long) ksig->ka.sa.sa_handler;
> +	regs->cp0_epc =3D (unsigned long) ksig->ka.sa.sa_handler;
> =20
>  	return 0;
> -
> -give_sigsegv:
> -	force_sigsegv(signr, current);
> -	return -EFAULT;
>  }
> =20
> -static void handle_signal(unsigned long sig, siginfo_t *info,
> -	struct k_sigaction *ka, struct pt_regs *regs)
> +static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
>  {
> +	int ret;
> +
>  	if (regs->is_syscall) {
>  		switch (regs->regs[4]) {
>  		case ERESTART_RESTARTBLOCK:
> @@ -229,7 +226,7 @@ static void handle_signal(unsigned long sig, siginf=
o_t *info,
>  			regs->regs[4] =3D EINTR;
>  			break;
>  		case ERESTARTSYS:
> -			if (!(ka->sa.sa_flags & SA_RESTART)) {
> +			if (!(ksig->ka.sa.sa_flags & SA_RESTART)) {
>  				regs->regs[4] =3D EINTR;
>  				break;
>  			}
> @@ -245,17 +242,14 @@ static void handle_signal(unsigned long sig, sigi=
nfo_t *info,
>  	/*
>  	 * Set up the stack frame
>  	 */
> -	if (setup_rt_frame(ka, regs, sig, sigmask_to_save(), info) < 0)
> -		return;
> +	ret =3D setup_rt_frame(ksig, regs, sigmask_to_save());
> =20
> -	signal_delivered(sig, info, ka, regs, 0);
> +	signal_setup_done(ret, ksig, 0);
>  }
> =20
>  static void do_signal(struct pt_regs *regs)
>  {
> -	struct k_sigaction ka;
> -	siginfo_t info;
> -	int signr;
> +	struct ksignal ksig;
> =20
>  	/*
>  	 * We want the common case to go fast, which is why we may in certain=

> @@ -265,10 +259,9 @@ static void do_signal(struct pt_regs *regs)
>  	if (!user_mode(regs))
>  		return;
> =20
> -	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
> -	if (signr > 0) {
> +	if (get_signal(&ksig)) {
>  		/* Actually deliver the signal.  */
> -		handle_signal(signr, &info, &ka, regs);
> +		handle_signal(&ksig, regs);
>  		return;
>  	}
> =20



--FI6OctkeeQg5sdGis9Vsk2gm9Escx9mO1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEVAwUBUmF9PxIBnItolwGVAQKDNAgAqgXpBeNIHsnyPxNTqep3e7KzQGJJnN3G
vQfvtRT0gj+LUNKLfA2aJTm85BwNI8/hA7iEEcWBf/JBeCgs2xyLf4JrQ/HEaIiB
/Usf6ZkF1pSXOzWpiDjVewthCD2v8/peOr6cx+H/eu5D0F2hcSeRyP0QL9oSvQBN
hsjpKq8YePqXFclyX5KsYdEu/ReebtoPekeZW4+c9LXZqkHTZQWeSi6m2LzR2HxP
8Mx2TsEfkjZzICXuadHA7UIN0Ro00QyIalcwzJdXQpjQ0oX1U+9bXAGBWTwMDYOk
7zDi//bmxxjoVZwKWGGNV0BQamHo+71VT091Nxt8shdm7JHnNlVlGg==
=AwJJ
-----END PGP SIGNATURE-----

--FI6OctkeeQg5sdGis9Vsk2gm9Escx9mO1--
