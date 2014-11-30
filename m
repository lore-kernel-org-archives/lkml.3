Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaK3KLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 05:11:40 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36338 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaK3KLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 05:11:39 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Date: Sun, 30 Nov 2014 11:11:35 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Gabriele Mazzotta <gabriele.mzt@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com> <201411292007.36975@pali> <547A71F5.4030306@roeck-us.net>
In-Reply-To: <547A71F5.4030306@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3175210.ObkvbKeBlV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201411301111.35988@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3175210.ObkvbKeBlV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 30 November 2014 02:25:09 Guenter Roeck wrote:
> On 11/29/2014 11:07 AM, Pali Roh=C3=A1r wrote:
> [ ... ]
>=20
> > Original Dell DOS executable ignores all temperature sensors
> > if type SMM function fails (if I decoded and understand
> > that DOS assembler code correctly). So maybe we should do
> > same...
>=20
> Pali,
>=20
> Makes me wonder - does the assembler code tell you what to do
> if the reported temperature is invalid, and does it
> distinguish between error codes ?

I do not see anything like that. But there are lot of indirect=20
calls (offset to pointer to function is stored in some global at=20
init zero data), so it is hard to understand what that DOS binary=20
is doing. I'm happy that I decoded loop which trying to call that=20
type function and if it does not fail then it call read=20
temperature function. And in that section I do not see any error=20
handling of invalid values (but it could be somewhere else).

Anyway DOS binary is quite old (7 years maybe?). It is not even=20
available for my last E6440 model. Now all new Dell laptops have=20
EFI system and ePSA application (new version of diagnostic tool=20
which reports info about fan, temperature, ...). That tool looks=20
like is burned directly into machine (I can start it with empty=20
HDD from Setup screen) or into BIOS image.

And what is interesting about this ePSA:

* it show more temperature sensors (battery temperature)
* it show correct RPM of fan and *can* control fan speed

I think that DOS binary has no idea about Optimus or PowerExpress=20
cards so for that error handling we need to understand what is=20
doing new EFI ePSA application...

And because function for turning card on/off is controlled via=20
ACPI I bet that DOS or EFI application does not touch it, so=20
assume that card is always on and does not need any error=20
handling.

Another info about DOS binary: After SMM code for reading fan RPM=20
is finished, then function divide returned RPM value by some=20
number stored in local data. So now I think that magic fan=20
multiplier is not constant, but runtime value. I will try to look=20
at it, if we can fix this problem in linux i8k.c.

> So far we have
> 	0x99 - presumably a spurious error
> 	0xc1 - GPU temperature sensor, GPU turned off
>=20
> It would be nice if we could find a better solution for error
> handling.
>=20

Yes, but now we can only guess... My idea is that Dell SMM=20
handler does not check GPU presence at runtime and just try to=20
read info from PCI bus. And because turned off card is not there=20
just random (or non random) garbage is returned...

> Thanks,
> Guenter

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3175210.ObkvbKeBlV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR67VcACgkQi/DJPQPkQ1JotACfVSoNB4mffPDu4po8l1Xf4ojV
g4oAoLHSsUnEEGqwzZPxx2f2bIO1BxpR
=1SC2
-----END PGP SIGNATURE-----

--nextPart3175210.ObkvbKeBlV--
