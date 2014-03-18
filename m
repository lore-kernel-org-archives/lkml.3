Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaCRLmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:42:15 -0400
Received: from [217.156.133.130] ([217.156.133.130]:43255 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752329AbaCRLmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:42:13 -0400
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Tue, 18 Mar 2014 11:41:50 +0000
Message-ID: <532830F6.8090305@imgtec.com>
Date: Tue, 18 Mar 2014 11:41:42 +0000
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
References: <1393804646-7797-1-git-send-email-richard@nod.at> <1393804646-7797-2-git-send-email-richard@nod.at> <53146440.707@imgtec.com>
In-Reply-To: <53146440.707@imgtec.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="Xv2dRd4QbdO0uLoxOfUOlEn63mHEUm8WF"
X-Originating-IP: [192.168.154.65]
X-ESG-ENCRYPT-TAG: 542c405f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Xv2dRd4QbdO0uLoxOfUOlEn63mHEUm8WF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/03/14 11:15, James Hogan wrote:
> Hi Richard,
>=20
> On 02/03/14 23:57, Richard Weinberger wrote:
>> @@ -235,10 +230,8 @@ static void handle_signal(unsigned long sig, sigi=
nfo_t *info,
>>  static int do_signal(struct pt_regs *regs, int syscall)
>>  {
>>  	unsigned int retval =3D 0, continue_addr =3D 0, restart_addr =3D 0;
>> -	struct k_sigaction ka;
>> -	siginfo_t info;
>> -	int signr;
>>  	int restart =3D 0;
>> +	struct ksignal ksig;
>> =20
>>  	/*
>>  	 * By the end of rt_sigreturn the context describes the point that t=
he
>> @@ -272,30 +265,30 @@ static int do_signal(struct pt_regs *regs, int s=
yscall)
>>  	}
>> =20
>>  	/*
>> -	 * Get the signal to deliver. When running under ptrace, at this poi=
nt
>> -	 * the debugger may change all our registers ...
>> -	 */
>> -	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
>> -	/*
>>  	 * Depending on the signal settings we may need to revert the decisi=
on
>>  	 * to restart the system call. But skip this if a debugger has chose=
n to
>>  	 * restart at a different PC.
>>  	 */
>>  	if (regs->REG_PC !=3D restart_addr)
>>  		restart =3D 0;
>> -	if (signr > 0) {
>> +
>> +	/*
>> +	 * Get the signal to deliver. When running under ptrace, at this poi=
nt
>> +	 * the debugger may change all our registers ...
>> +	 */
>> +	if (get_signal(&ksig)) {
>=20
> The patch all looks good to me except for this bit. You've moved the bi=
t
> at which a ptrace debugger can alter the registers to after the check
> for whether the PC has been altered, which would still need to cancel
> the restart.
>=20
> Does something like the hunks below look reasonable to you?
>=20
> Would you like me to take this patch through the metag tree or do you
> want to keep them together?

I've applied the altered version of this patch to the metag tree for v3.1=
5.

Thanks
James

>=20
> Cheers
> James
>=20
> @@ -275,7 +268,7 @@ static int do_signal(struct pt_regs *regs, int sysc=
all)
>  	 * Get the signal to deliver. When running under ptrace, at this poin=
t
>  	 * the debugger may change all our registers ...
>  	 */
> -	signr =3D get_signal_to_deliver(&info, &ka, regs, NULL);
> +	get_signal(&ksig);
>  	/*
>  	 * Depending on the signal settings we may need to revert the decisio=
n
>  	 * to restart the system call. But skip this if a debugger has chosen=
 to
> @@ -283,19 +276,19 @@ static int do_signal(struct pt_regs *regs, int sy=
scall)
>  	 */
>  	if (regs->REG_PC !=3D restart_addr)
>  		restart =3D 0;
> -	if (signr > 0) {
> +	if (ksig.sig > 0) {
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


--Xv2dRd4QbdO0uLoxOfUOlEn63mHEUm8WF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTKDD9AAoJEGwLaZPeOHZ65bgP/iyE+ySo0E5wPRP5zDvQb5qA
LTYlxrR+sfnaO5cqnMuSmu5jnGI4bhokApgZGPPHcz8RsX7RnwsVOBOfnDrNf348
qtFT32/WFObeqw9gZl7ZreVa/vAGXLtOQqN6y3rBh0OKqL/q3aDCHuU+FGY37bb4
xCDSucR1Fqgjo/LyFWFrbWAWrWH1IgbJcGa0BD6cpxNNWVkE4w+VIzEq40jwOP/O
e9LYrPIhRVSBi4c25hIknxY8qUHEO6WmyKBCzxdN0lDtnqszmpDfHF1qTFZVd+Wg
xQEj4bJ7QDON/kJ0n3evOa9b9d77YbhlB4NomKApamSJlhYaCN4U87wbX3Eu3Wgo
J4dHbhuyeDihMZjrDWZkkkpDVppmQdiROO4tyUVZAm9Kj1todibna1csqMnKwJfU
MNL6BUo0LnHbhz8soCfpKDCKSuH71e3zWmfoZg/7znCLr80b10WwoYlm11OhLC8n
C744SorxtNRP/UgJNMzLQCCUTjB4e5n4n0A3Nnr6+TNXY5D3Iz5fmtbxJIt1EWAU
IJgDxwY1uiSDlZISQCMlkLmJc/w33JnjFeFQAAZHp6DUsEaqrTxrWRV3Z5wKvUie
V6Z3AMhre8RGvAWFeOh4WkvCqRWWPg3lrCfwqRO2OgZrgoqgWQy6PHPEbmHj/WpV
p0T8cQysOdtR2LTCl/x0
=iV3W
-----END PGP SIGNATURE-----

--Xv2dRd4QbdO0uLoxOfUOlEn63mHEUm8WF--
