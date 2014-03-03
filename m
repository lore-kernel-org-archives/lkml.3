Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaCCLPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:15:44 -0500
Received: from [217.156.133.130] ([217.156.133.130]:32835 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754697AbaCCLPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:15:42 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Mon, 03 Mar 2014 11:15:26 +0000
Message-ID: <53146440.707@imgtec.com>
Date: Mon, 3 Mar 2014 11:15:12 +0000
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
        <liqin.linux@gmail.com>, <lennox.wu@gmail.com>, <cmetcalf@tilera.com>,
        <gxt@mprc.pku.edu.cn>, <linux-xtensa@linux-xtensa.org>,
        <akpm@linux-foundation.org>, <oleg@redhat.com>, <tj@kernel.org>,
        <hch@infradead.org>, linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH 12/44] metag: Use get_signal() signal_setup_done()
References: <1393804646-7797-1-git-send-email-richard@nod.at> <1393804646-7797-2-git-send-email-richard@nod.at>
In-Reply-To: <1393804646-7797-2-git-send-email-richard@nod.at>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="d8V3PGl5ELvXKeuSWonKftvQgGEsidMj5"
X-Originating-IP: [192.168.154.65]
X-ESG-ENCRYPT-TAG: e1bf74bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--d8V3PGl5ELvXKeuSWonKftvQgGEsidMj5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On 02/03/14 23:57, Richard Weinberger wrote:
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
> -	if (signr > 0) {
> +
> +	/*
> +	 * Get the signal to deliver. When running under ptrace, at this poin=
t
> +	 * the debugger may change all our registers ...
> +	 */
> +	if (get_signal(&ksig)) {

The patch all looks good to me except for this bit. You've moved the bit
at which a ptrace debugger can alter the registers to after the check
for whether the PC has been altered, which would still need to cancel
the restart.

Does something like the hunks below look reasonable to you?

Would you like me to take this patch through the metag tree or do you
want to keep them together?

Cheers
James

@@ -275,7 +268,7 @@ static int do_signal(struct pt_regs *regs, int syscal=
l)
 	 * Get the signal to deliver. When running under ptrace, at this point
 	 * the debugger may change all our registers ...
 	 */
-	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
+	get_signal(&ksig);
 	/*
 	 * Depending on the signal settings we may need to revert the decision
 	 * to restart the system call. But skip this if a debugger has chosen t=
o
@@ -283,19 +276,19 @@ static int do_signal(struct pt_regs *regs, int sysc=
all)
 	 */
 	if (regs->REG_PC !=3D restart_addr)
 		restart =3D 0;
-	if (signr > 0) {
+	if (ksig.sig > 0) {
 		if (unlikely(restart)) {
 			if (retval =3D=3D -ERESTARTNOHAND
 			    || retval =3D=3D -ERESTART_RESTARTBLOCK
 			    || (retval =3D=3D -ERESTARTSYS
-				&& !(ka.sa.sa_flags & SA_RESTART))) {
+				&& !(ksig.ka.sa.sa_flags & SA_RESTART))) {
 				regs->REG_RETVAL =3D -EINTR;
 				regs->REG_PC =3D continue_addr;
 			}
 		}
=20
 		/* Whee! Actually deliver the signal.  */
-		handle_signal(signr, &info, &ka, regs);
+		handle_signal(&ksig, regs);
 		return 0;
 	}
=20


--d8V3PGl5ELvXKeuSWonKftvQgGEsidMj5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTFGRMAAoJEKHZs+irPybfNMkQAKVmUuho1EqnH4mXchsFEDZT
qEsiOMB9WKgE1DqtlhU1Aumj+ji1Ck8JKtXMZiKmXCLp09ZLQYT/w5y0T4riXGqr
O55XUDjXh9qEbSiN2ZlndzOOFCxxSBA7kNflQMZv4QYLarayadoaeR5ubw9KLxJy
JtkUH2SR5FZ00rtGQz+TZe2B5tXwwq7A3E7xr2gGamza9KqJyS+tznRplKkXimqA
DYghTcyY6MtOdF72XWsTNBuejRyfMTVEfJ6kq6hzhz9qA9nxW8R79o6KsLOApezq
BowqWUu3T+TJsNAO6FjmjZXoEw6Q+cbECdE7VMNYOKjQ3CdqxROBl7YrsLjgmakm
VhFArpBIHO7mLYigKtrNTUr61nzohMEWzXvdtpM+RMLUuMtYe7EzzSk1JZEikDUs
VY3LHeCCap3K5U7dcDrdTg/khcDSnXZ2uQN+9V8TQ75zoOXf4otDSl6j8DtpZCVZ
s+MZrxL9ewvT+Rc42YDKBUHdoIEiasCI/bNx2yFBoE/gu0Kof31Y1P7c4GFhncO/
TMBmyfKI9IipgVCO19xu+WEVwLmPbHaok8QHBni952dUrOPaIrUqUNpxJ1oF2Eya
apQducBpF5ep9vUDfRYOqDHwZ2PdwI3Ch8uU9CnjE/e3zRuRB+0LMsf3Io2urZlk
KEghC1TqDIgQ2fAucpQT
=fyQJ
-----END PGP SIGNATURE-----

--d8V3PGl5ELvXKeuSWonKftvQgGEsidMj5--
