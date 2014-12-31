Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaLaGXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 01:23:07 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:37604 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaLaGXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 01:23:04 -0500
Date: Wed, 31 Dec 2014 01:23:03 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>,
        Colin Watson <cjwatson@debian.org>, 772807@bugs.debian.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: Bug#772807: binfmt-support: unable to close
 /proc/sys/fs/binfmt_misc/register: Invalid argument
Message-ID: <20141231062303.GE3906@vapier.wh0rd.info>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	Arthur Marsh <arthur.marsh@internode.on.net>,
	Colin Watson <cjwatson@debian.org>, 772807@bugs.debian.org,
	linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
References: <20141211102439.5047.90481.reportbug@localhost>
 <20141211104408.GQ3020@riva.ucam.org>
 <548987B8.8090202@internode.on.net>
 <20141211124024.GR3020@riva.ucam.org>
 <548A6D63.3010106@internode.on.net>
 <20141212060138.GC22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="19uQFt6ulqmgNgg1"
Content-Disposition: inline
In-Reply-To: <20141212060138.GC22149@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--19uQFt6ulqmgNgg1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12 Dec 2014 06:01, Al Viro wrote:
> On Fri, Dec 12, 2014 at 02:51:55PM +1030, Arthur Marsh wrote:
> > 6b899c4e9a049dfca759d990bd53b14f81c3626c is the first bad commit
> > commit 6b899c4e9a049dfca759d990bd53b14f81c3626c
> > Author: Mike Frysinger <vapier@gentoo.org>
> > Date:   Wed Dec 10 15:52:08 2014 -0800
> >=20
> >     binfmt_misc: add comments & debug logs
> >=20
> >     When trying to develop a custom format handler, the errors returned=
 all
> >     effectively get bucketed as EINVAL with no kernel messages.  The ot=
her
> >     errors (ENOMEM/EFAULT) are internal/obvious and basic.  Thus any ti=
me a
> >     bad handler is rejected, the developer has to walk the dense code a=
nd
> >     try to guess where it went wrong.  Needing to dive into kernel code=
 is
> >     itself a fairly high barrier for a lot of people.
> >=20
> >     To improve this situation, let's deploy extensive pr_debug markers =
at
> >     logical parse points, and add comments to the dense parsing logic. =
 It
> >     let's you see exactly where the parsing aborts, the string the kern=
el
> >     received (useful when dealing with shell code), how it translated t=
he
> >     buffers to binary data, and how it will apply the mask at runtime.
>=20
> ... and looking at it shows the following garbage:
>                 p[-1] =3D '\0';
> -               if (!e->magic[0])
> +               if (p =3D=3D e->magic)
>=20
> That code makes no sense whatsoever - if p *was* equal to e->magic, the
> assignment before it would be obviously broken.  And a few lines later we
> have another chunk just like that.
>=20
> Moreover, if you look at further context, you'll see that it's
>                 e->magic =3D p;
>                 p =3D scanarg(p, del);
>                 if (!p)
>                         sod off
>                 p[-1] =3D '\0';
>                 if (p =3D=3D e->magic)
> 			sod off
> Now, that condition could be true only if scanarg(p, del) would return p,
> right?  Let's take a look at scanarg():
> static char *scanarg(char *s, char del)
> {
>         char c;
>=20
>         while ((c =3D *s++) !=3D del) {
>                 if (c =3D=3D '\\' && *s =3D=3D 'x') {
>                         s++; =20
>                         if (!isxdigit(*s++))=20
>                                 return NULL;
>                         if (!isxdigit(*s++))
>                                 return NULL;
>                 }
>         }
>         return s;
> }
>=20
> See that s++ in the loop condition?  There's no way in hell it would *not*
> increment s.  If we return non-NULL, we know that c was equal to del *and*
> c is equal to previous_value_of_s[0], i.e. s[-1].  IOW, return value poin=
ts
> to the byte following the first instance of delimeter starting at the arg=
ument.
>=20
> And p[-1] =3D '\0' replaces delimiter with NUL.  IOW, the checks used to =
be
> correct.  And got buggered.

the checks are not correct.  magic & mask are binary fields hence checking =
for a=20
NUL byte to indicate string parsing failed makes no sense.  your patch rest=
ores=20
the bug i attempted to fix -- if i wanted to ignore the first byte of the f=
ile=20
by setting the mask or magic to 0, then binfmt_misc will wrongly reject it.

the current code does reject some bad inputs -- namely, when the magic or m=
ask=20
is not specified.  i was counting on the scanarg not incrementing the point=
er in=20
that case, but as you pointed out, that doesn't work since the func always=
=20
increments the pointer.  i'll see if i can handle both cases.

> Subject: unfuck fs/binfmt_misc.c
>=20
> Undo some of the "prettifying" braindamage.

commit 7d65cf10e3d7747033b83fa18c5f3d2a498f66bc has merged at this point, b=
ut=20
the attribution to e6084d4 is wrong.  of course coding style changes &=20
functional changes shouldn't be done which is why i didn't do it.  the chan=
ge=20
you're referring to above has nothing to do e6084d4 as it was added before =
that=20
in 6b899c4e9a049dfca759d990bd53b14f81c3626c (where i added extended debug=
=20
output).  arguably those few non-debug related lines shouldn't be in that=
=20
commit, but it's a long cry from style changes.
-mike

--19uQFt6ulqmgNgg1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUo5ZHAAoJEEFjO5/oN/WBcd0P/1SXJ6tXiB5XMALeZkxs20ff
uDi355wc5Qqt9pu30tUtpexzkxcaj1ve8BMRr3OvIGHC77r++gy8qYO8X7/gNWHJ
LuoRv4weVZznHr7zfCNhiw7MlqGfI3jdASRdhD150Uib19fPICZZuhM7mQGxs9eJ
VecivFOWZlo6sRikdNbIXh6/dzj+JabwkS1o7ucmPk8n/teFQ9g4gxus2yuYGmG3
0y5hfQlKNDYTGpHkyc7GPB1rkaVmCZzna1WruxqTRXk1ZyXwSGPcL7cCrKVG7F+K
xOoR3Fk00Slmonf6uKNYlD6Ejq/j4UmUpZpC45LqLMeRWcb1cpna2UHWIws4w3GQ
VLy426s/xTiAvqoChoyREFbJ403xLqTRP7ASYcirscId3YqcjCFrpZuEnPxKKX4m
uqYe9qi3mgJU1J3ofzIDpe2sp8fsJr4o763t8rZuRcQ954e/3KwcPV/JAp/Gcc2k
aWpQWlz24FWW6b8GgMHgyNSWwxQJalxhrqebryU1Io0hUgF0BlaptaJa6S3hv2PB
/zNA8qBEj8RPAMUlpU+DIs3TYzODTuN1s3He7z1KT9d9riVC2Wp9+5UAssd7KyzG
aH7sv2lIIi/HHrivSyotFKjct+FJZykVBP9MfTRmAvx7RmkpaeX/womcsllqKPgn
Eqht26z6mRyA4gibxKgs
=zqr6
-----END PGP SIGNATURE-----

--19uQFt6ulqmgNgg1--
