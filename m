Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751155Ab3BPFSV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 00:18:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57873 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792Ab3BPFST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 00:18:19 -0500
Message-ID: <1360991890.5374.414.camel@deadeye.wl.decadent.org.uk>
Subject: Re: 3.2.38 most of the time has 100% cpu use reported
From: Ben Hutchings <ben@decadent.org.uk>
To: tmhikaru@gmail.com
Cc: linux-kernel@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>
Date: Sat, 16 Feb 2013 05:18:10 +0000
In-Reply-To: <20130216032327.GA2094@roll>
References: <1360160863.32217.30.camel@deadeye.wl.decadent.org.uk>
	 <20130207173630.GA8355@roll> <20130208190819.GA16894@roll>
	 <20130210151140.GA2307@roll> <20130212050116.GA2146@roll>
	 <1360818247.5374.300.camel@deadeye.wl.decadent.org.uk>
	 <20130216032327.GA2094@roll>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HkZRIvXBVD++yCHq5c3T"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HkZRIvXBVD++yCHq5c3T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-02-15 at 22:23 -0500, tmhikaru@gmail.com wrote:
> On Thu, Feb 14, 2013 at 05:04:07AM +0000, Ben Hutchings wrote:
> > On Tue, 2013-02-12 at 00:01 -0500, tmhikaru@gmail.com wrote:
> > > 	Okay, I finally have located the patch causing this bizzare problem
> > > for me. Before I discuss it, I'm going to drag out the kernel bug rep=
orting
> > > guidelines and try to make a proper bug report out of this.
> > >=20
> > > [1.] One line summary of the problem:
> > > 3.2.38 most of the time has 100% cpu use reported
> > >=20
> > > [2.] Full description of the problem/report:
> > > Reverse applying the patch for
> > >=20
> > > [9a1f08a1a192f9177d7063d903773aed800b840f] drivers/firmware/dmi_scan.=
c: fetch dmi version from SMBIOS if it exists
> > >=20
> > > on top of a clean 3.2.38 tree makes the problem go away.
> > [...]
> > > I have to admit I have no idea what the patch I'm reversing actually =
does,
> >=20
> > It changes how we look for the version of a BIOS interface (DMI or
> > SMBIOS).  All the code that it touches, and the version number variable=
,
> > are discarded after boot and therefore can have very limited effect on
> > what happens later!
>=20
> Actually upon poking about, I noticed something VERY different about what
> the patch does to my computer during the boot process.  Let me show you
> dmesg output from a good kernel without the patch, then a bad one with th=
e
> patch, then I'll point out the important differences I noticed:
[...]
> Important bits I noticed: The 'bad' kernel initially boots with acpi
> disabled, then later turns it back on, whereas the 'good' one boots with
> acpi completely enabled with no problems.
>
> Also, very early on just after yelling about the NX bit not existing in m=
y
> cpu, it says this: (-good/+bad)
>=20
> -[    0.000000] DMI 2.3 present.
> -[    0.000000] DMI: ECS M848A/M848A, BIOS 07.00T 04/02/01
> +[    0.000000] Legacy DMI 0.0 present.
> +[    0.000000] DMI:  , BIOS =20

Oh wow, this has really gone very wrong.

> The 'good' kernel without the patch finds something for DMI (That is in f=
act
> my motherboard model number, so I know it's doing *something* right) wher=
eas
> the bad one with the patch...  Does not.
>
> Anyway, I suppose I could try using acpi=3Dforce as the kernel suggests f=
or a
> workaround for now, but I'm still convinced something went wrong with tha=
t
> patch now more than ever.  Due to the fact that ACPI gets reenabled I did=
n't
> catch on that something was going wrong so early in the boot process with=
 it
> until now.
>
> One thing I want to emphasize is that the only difference between the two
> kernels is that lone patch.
>
> As for perf top, I tried running it as you suggested, but I honestly can'=
t
> figure out how to get this thing to dump output to a file. Every time I
> redirect stdio/stderr I get a empty file, I don't know what I'm doing wro=
ng.
> Any tips?
[...]

Don't worry about it - I think the log messages are a pretty good clue.

Does this patch fix the log messages and/or the other issues?

--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -416,6 +416,9 @@ static int __init dmi_present(const char __iomem *p)
=20
 	memcpy_fromio(buf, p, 15);
 	if (dmi_checksum(buf, 15)) {
+		print_hex_dump(KERN_INFO, "DMI entry: ", DUMP_PREFIX_NONE,
+			       16, 1, buf, 15, false);
+
 		dmi_num =3D (buf[13] << 8) | buf[12];
 		dmi_len =3D (buf[7] << 8) | buf[6];
 		dmi_base =3D (buf[11] << 24) | (buf[10] << 16) |
@@ -442,10 +445,12 @@ static int __init dmi_present(const char __iomem *p)
 static int __init smbios_present(const char __iomem *p)
 {
 	u8 buf[32];
-	int offset =3D 0;
=20
 	memcpy_fromio(buf, p, 32);
 	if ((buf[5] < 32) && dmi_checksum(buf, buf[5])) {
+		print_hex_dump(KERN_INFO, "SMBIOS entry: ", DUMP_PREFIX_NONE,
+			       16, 1, buf, 16, false);
+
 		dmi_ver =3D (buf[6] << 8) + buf[7];
=20
 		/* Some BIOS report weird SMBIOS version, fix that up */
@@ -461,9 +466,9 @@ static int __init smbios_present(const char __iomem *p)
 			dmi_ver =3D 0x0206;
 			break;
 		}
-		offset =3D 16;
+		return dmi_present(p + 16);
 	}
-	return dmi_present(buf + offset);
+	return 1;
 }
=20
 void __init dmi_scan_machine(void)
--- END ---

If not, can you report back the 'SMBIOS entry:' and 'DMI entry:' log
lines this produces.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-HkZRIvXBVD++yCHq5c3T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUR8Wkue/yOyVhhEJAQrB/Q//e/wQ0pvtjhorOb2UUilssIQZwLqGJTpQ
G9vOb17NQkvV6xpd1s3u2XRbLHa0nrB2NAA/5mx4w+3kfd1QJu+z0LymoLUw48Xy
JmRpolzCbdFUESDWLHvdIO4rHMbQKf3aJ+mtfQg5evtw4r57cmR+9rdX0w0P2c5v
h1249UA1XPUIcp5R1qCbtTZywowLiX0/Ts6OR4kbNGUtYKMZ8JYeHTD7yQSoBQqU
GMQ2s0KBbkNr7jYJ9HlcJVJyfgUmUL0W3Tpp+jzY901oh6U9mqPJQE7AQiM8nuNM
sA7mJJWTDkpxImcZFRfHuJlhgXSoqGSwHv4shscSS9QUxbGPSjME9D+FAzgeHcPV
Hzig8s629nWp6lPU4Fvy5xt32EgdYal6VocfJXpsach/lBDMO+Il25sfi+0U9hPi
qlgZD24QMTYDIpXZtg7jNYx3WpzxTcgAD16e+wQMlhV78wCP11GNoB7nniUE2jjl
aO1NVVsYz3gtdI9Ue53yVfMs4FnHTqxLlBitLOdqh5ancl9uIDTG2rlLWhHzbv/N
/azD3hmtA9uueuag0xxrAE2iaqrtPrChuLOmzA/fo+e5d2rkJYpwfKAt3+mVSWCX
CtfEOvgZC8Max0ufCS5+fqF3lTLCUoxI/WgD+aTrIgCwAKY0sDPettS5B7y5Zv6A
HEdu6yeVDbA=
=1/rP
-----END PGP SIGNATURE-----

--=-HkZRIvXBVD++yCHq5c3T--
