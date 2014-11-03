Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaKCW7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:59:32 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:43810 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaKCW73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:59:29 -0500
Date: Mon, 3 Nov 2014 14:35:13 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: "R, Durgadoss" <durgadoss.r@intel.com>
Cc: Yao Dongdong <yaodongdong@huawei.com>, "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Thermal:Fix memory leak if occur goto unregister
Message-ID: <20141103183510.GA441@developer>
References: <5444C778.8050008@huawei.com>
 <20141020123338.GA3744@developer>
 <4D68720C2E767A4AA6A8796D42C8EB590902F30A@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB590902F30A@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Nov 03, 2014 at 06:17:37PM +0000, R, Durgadoss wrote:
> >-----Original Message-----
> >From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> >owner@vger.kernel.org] On Behalf Of Eduardo Valentin
> >Sent: Monday, October 20, 2014 6:04 PM
> >To: Yao Dongdong
> >Cc: Zhang, Rui; linux-pm@vger.kernel.org; LKML
> >Subject: Re: [PATCH 1/2] Thermal:Fix memory leak if occur goto unregister
> >
> >Hello,
> >
> >On Mon, Oct 20, 2014 at 04:27:36PM +0800, Yao Dongdong wrote:
> >> Signed-off-by:yaodongdong@huawei.com
> >
> >Acked-by: Eduardo Valentin <edubezval@gmail.com>
> >
> >Rui, would you take care of this?
> >
>=20
> If I remember it right, this 'tz' is freed in the thermal_release()
> function, during device_unregister().
>=20
> It is similar in all other functions in thermal_core.c
>=20
> So, Yao, Did you really test this patch ?
> And did not see any crashes ?
>=20

Yao, reading the patch change carefully, now I see that Durga is correct
here.=20

> Thanks,
> Durga
>=20
> >>
> >> ---
> >>  drivers/thermal/thermal_core.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_=
core.c
> >> index 71b0ec0..5b7d466 100644
> >> --- a/drivers/thermal/thermal_core.c
> >> +++ b/drivers/thermal/thermal_core.c
> >> @@ -1574,6 +1574,7 @@ struct thermal_zone_device
> >*thermal_zone_device_register(const char *type,
> >>  unregister:
> >>     release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
> >>     device_unregister(&tz->device);
> >> +   kfree(tz);

The device unregister is called above your kfree call, which will cause
the thermal_release to be called. Did you test the code for double kfree
calls? Your patch probably inserts a memory corruption.

I will revert your patch from my tree until you provide an answer about
your testing.

Thanks,


Eduardo Valentin

> >>     return ERR_PTR(result);
> >>  }
> >>  EXPORT_SYMBOL_GPL(thermal_zone_device_register);
> >> --
> >> 1.8.0.1
> >>
> >>

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV8rCAAoJEMLUO4d9pOJWWo4IAJ/X4Jek2EtwUIzUEOdfr80e
r4eXVUZ5AsvzGZGYqEXcMXMl8G319qd88TCAhokHWGAkJhfGccSGL2rQ9boiZ8du
Mbaieb/maAGxxG1cSJ4MRlmVP9crfrGCunLZcjvecq1iKrNJJt2wBB6PFDRaXqg0
X2QRPCw23cUXfUVy3pNuUds9/mOYV3VPCwIjDWgmUWB1cNfLegAnNe8Gjg838hBn
G1XfGq2CHl4nb87ryelG61aA2u2hlaNAwWpk2K/U18Oxk0tJlG0vLowywH4xwEKC
wLnIPP9lvcwPjBTFBULfz+CMlgiMwPk9OJjVQkdqmQdwym67EFakk9r5IgM3vVw=
=UFIU
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
