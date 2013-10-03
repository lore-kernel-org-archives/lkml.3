Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3JCVvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:51:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37537 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab3JCVvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:51:38 -0400
Message-ID: <524DE6DB.1070003@pengutronix.de>
Date: Thu, 03 Oct 2013 23:51:23 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130929 Icedove/17.0.9
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH|RFC] of: let of_match_device() always return best match
References: <1380826284-18381-1-git-send-email-mkl@pengutronix.de> <524DD5A6.6020204@gmail.com>
In-Reply-To: <524DD5A6.6020204@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="v0KE8CsolDMopliL9MsIlFSXoq8g7LH74"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--v0KE8CsolDMopliL9MsIlFSXoq8g7LH74
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/03/2013 10:37 PM, Rob Herring wrote:
> On 10/03/2013 01:51 PM, Marc Kleine-Budde wrote:
>> The function of_match_device() should tell if a struct device matches =
an
>> of_device_id list and return the specific entry of that table matches =
the
>> device best.
>>
>> The underlying __of_match_node() implements the wrong search algorithm=
=2E It
>> iterates over the list of of_device_ids, comparing the first compatibl=
e with
>> _all_ compatibles of the struct device, then the second compatible of
>> of_device_id and so on.
>>
>> This leads to a problem, if the device has more than one compatible th=
at match
>> the of_device_id list. The implemented search algorithm may find not t=
he "best"
>> match. As the compatible list in the device is sorted from most to lea=
st
>> specific.
>>
>> For example:
>>
>> The imx28.dtsi gives this compatible string for its CAN core:
>>
>>> 	compatible =3D "fsl,imx28-flexcan", "fsl,p1010-flexcan";
>>
>> The flexcan driver defines:
>>
>>> static const struct of_device_id flexcan_of_match[] =3D {
>>> 	{ .compatible =3D "fsl,p1010-flexcan", .data =3D &fsl_p1010_devtype_=
data, },
>>> 	{ .compatible =3D "fsl,imx28-flexcan", .data =3D &fsl_imx28_devtype_=
data, },
>>> 	{ .compatible =3D "fsl,imx6q-flexcan", .data =3D &fsl_imx6q_devtype_=
data, },
>>> 	{ /* sentinel */ },
>>> };
>>
>> The "p1010" was the first Freescale SoC with the flexcan core. But thi=
s SoC has
>> a bug, so a workaround has to be enabled in the driver. The mx28 has t=
his bug
>> fixed, so we don't need this quite costly workaround.
>>
>> The __of_match_node() will compare:
>>
>>     from  of_device_id		from device
>>     fsl,p1010-flexcan		fsl,imx28-flexcan
>>     fsl,p1010-flexcan		fsl,p1010-flexcan	-> MATCH
>>
>> The of_match_device() function as it currently is implemented will alw=
ays
>> return p1010 not the mx28.
>>
>> This patch fixes the problem by exchanging outer and inner loop. The f=
irst
>> compatible of a device is compared against all compatible from the of_=
device_id
>> list, then the second device compatible and so on.
>=20
> This has been an issue for some time. A fix has been attempted before
> and reverted if you look at the git history:

=2E.should have done this before creating the patch.

> commit bc51b0c22cebf5c311a6f1895fcca9f78efd0478
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Tue Jul 10 12:49:32 2012 -0700
>=20
>     Revert "of: match by compatible property first"
>=20
>     This reverts commit 107a84e61cdd3406c842a0e4be7efffd3a05dba6.
>=20
>     Meelis Roos reports a regression since 3.5-rc5 that stops Sun Fire =
V100
>     and Sun Netra X1 sparc64 machines from booting, hanging after enabl=
ing
>     serial console.  He bisected it to commit 107a84e61cdd.
>=20
>     Rob Herring explains:
>      "The problem is match combinations of compatible plus name and/or =
type
>       fail to match correctly.  I have a fix for this, but given how la=
te it
>       is for 3.5 I think it is best to revert this for now.  There coul=
d be
>       other cases that rely on the current although wrong behavior.  I =
will
>       post an updated version for 3.6."
>=20
>     Bisected-and-reported-by: Meelis Roos <mroos@linux.ee>
>     Requested-by: Rob Herring <rob.herring@calxeda.com>
>     Cc: Thierry Reding <thierry.reding@avionic-design.de>
>     Cc: Grant Likely <grant.likely@secretlab.ca>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>=20
> There was also a fix attempted for this and the discussion here:
>=20
> http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg60163.html=

>=20
> You patch would hit the same issues I believe.

Yes probably, are the OF patterns from the failing sparcs available
somewhere, so that we can test a better implementation?

I'll rearrange the drivers instead. BTW: what about the patch you
mentioned in the above revert?

tnx,
Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--v0KE8CsolDMopliL9MsIlFSXoq8g7LH74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iEYEARECAAYFAlJN5tsACgkQjTAFq1RaXHOlGACfTqGAYQCUP3yKPaJTZ/7DDL/f
BUMAn3dn/4YaenVPbbMBUyNHzzCt8IYj
=MSye
-----END PGP SIGNATURE-----

--v0KE8CsolDMopliL9MsIlFSXoq8g7LH74--
