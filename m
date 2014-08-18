Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaHRSxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:53:17 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39160 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHRSxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:53:15 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_DA72B75E-E2DC-4846-95E0-A254CE0A6DD8"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] KVM: x86: Avoid emulating instructions on #UD mistakenly
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <53F1B9E4.2090008@redhat.com>
Date: Mon, 18 Aug 2014 21:53:11 +0300
Cc: gleb@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nadav Amit <namit@cs.technion.ac.il>
Message-Id: <E7912D02-373F-4822-8F38-E259038EFA19@gmail.com>
References: <1407937813-1461-1-git-send-email-namit@cs.technion.ac.il> <B8075446-5721-4D41-99A1-19B729691F42@gmail.com> <53F1B9E4.2090008@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_DA72B75E-E2DC-4846-95E0-A254CE0A6DD8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Aug 18, 2014, at 11:31 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 13/08/2014 16:21, Nadav Amit ha scritto:
>> Correction: the word =93never=94 in the message is too harsh.
>> Nonetheless, there is a regression bug. I encountered it with =
=93wrfsbase=94 instruction.
>=20
> So KVM is emulating wrfsbase even if the host doesn't support it?
KVM doesn=92t know wrfsbase - wrfsbase is encoded like clflush with =
rep-prefix.
Therefore, the emulator thinks it can emulate it as clflush, and =
eliminates the #UD.

>=20
> I'm swapping the order of the two operands of &&, since the first one =
will almost
> always be true and the second one will almost always be false.
>=20
> Also, there's now no need to test EmulateOnUD in the condition below.  =
Does the
> below look good to you?
>=20
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 37a83b24e040..ef117b842334 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4394,11 +4394,11 @@ done_prefixes:
>=20
>  	ctxt->execute =3D opcode.u.execute;
>=20
> -	if (!(ctxt->d & EmulateOnUD) && ctxt->ud)
> +	if (unlikely(ctxt->ud) && likely(!(ctxt->d & EmulateOnUD)))
>  		return EMULATION_FAILED;
>=20
>  	if (unlikely(ctxt->d &
> -		     =
(NotImpl|EmulateOnUD|Stack|Op3264|Sse|Mmx|Intercept|CheckPerm))) {
> +		     =
(NotImpl|Stack|Op3264|Sse|Mmx|Intercept|CheckPerm))) {
>  		/*
>  		 * These are copied unconditionally here, and checked =
unconditionally
>  		 * in x86_emulate_insn.
>=20

Sure. Until I find some bugs in it. ;-)

Thanks,
Nadav

--Apple-Mail=_DA72B75E-E2DC-4846-95E0-A254CE0A6DD8
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQEcBAEBCgAGBQJT8kuXAAoJEHlOP0Zr1lTYWGwH/3DJb77/ylL1TZG7xVF2fI4v
5aoUuh9cyONE4lWNq+l17u2cqnQZOwySoAfoCYx5/ZBt+dS3q4o/RsnOXOXlJ11I
xV+pMZLIjYDbBhSkBZeT4H3pmoa9deNe9NH8Vn6tcnP1IR+dPaqHKTfUc6J1aM26
BwdLAfLWpQejZCsryJ6EbN5Kazig+R8zlB0gSkAzNeap2IlI0IH6eYzsXTqUDIGB
36uHGTpBIyiWllbSEhndEB12VPR53ZE5+2NSCFLv1oDv4pqy0LhIQSVODYdYjAvi
MDGdO7XSo++TPI/REVL/hy0d9zkk2kJvgZo/qQCfOechUnoy42hx+4yTYCuLTQQ=
=anox
-----END PGP SIGNATURE-----

--Apple-Mail=_DA72B75E-E2DC-4846-95E0-A254CE0A6DD8--
