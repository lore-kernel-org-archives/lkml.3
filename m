Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaIOQhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:37:00 -0400
Received: from bues.ch ([80.190.117.144]:42395 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbaIOQg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:36:58 -0400
Date: Mon, 15 Sep 2014 18:13:20 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Amos Kong <akong@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        herbert@gondor.apana.org.au, mpm@selenic.com, rusty@rustcorp.com.au,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] virtio-rng cleanup: move some code out of mutex
 protection
Message-ID: <20140915181320.28f642d6@wiggum>
In-Reply-To: <1410796949-2221-2-git-send-email-akong@redhat.com>
References: <1410796949-2221-1-git-send-email-akong@redhat.com>
 <1410796949-2221-2-git-send-email-akong@redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/b+3DAsvP3MC=drvS1CjQUv1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b+3DAsvP3MC=drvS1CjQUv1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Sep 2014 00:02:27 +0800
Amos Kong <akong@redhat.com> wrote:

> It doesn't save too much cpu time as expected, just a cleanup.
>=20
> Signed-off-by: Amos Kong <akong@redhat.com>
> ---
>  drivers/char/hw_random/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index aa30a25..c591d7e 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -270,8 +270,8 @@ static ssize_t hwrng_attr_current_show(struct device =
*dev,
>  		return -ERESTARTSYS;
>  	if (current_rng)
>  		name =3D current_rng->name;
> -	ret =3D snprintf(buf, PAGE_SIZE, "%s\n", name);
>  	mutex_unlock(&rng_mutex);
> +	ret =3D snprintf(buf, PAGE_SIZE, "%s\n", name);

I'm not sure this is safe.
Name is just a pointer.
What if the hwrng gets unregistered after unlock and just before the snprin=
tf?

>  	return ret;
>  }
> @@ -284,19 +284,19 @@ static ssize_t hwrng_attr_available_show(struct dev=
ice *dev,
>  	ssize_t ret =3D 0;
>  	struct hwrng *rng;
> =20
> +	buf[0] =3D '\0';
>  	err =3D mutex_lock_interruptible(&rng_mutex);
>  	if (err)
>  		return -ERESTARTSYS;
> -	buf[0] =3D '\0';
>  	list_for_each_entry(rng, &rng_list, list) {
>  		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
>  		ret +=3D strlen(rng->name);
>  		strncat(buf, " ", PAGE_SIZE - ret - 1);
>  		ret++;
>  	}
> +	mutex_unlock(&rng_mutex);
>  	strncat(buf, "\n", PAGE_SIZE - ret - 1);
>  	ret++;
> -	mutex_unlock(&rng_mutex);
> =20
>  	return ret;
>  }

This looks ok.

--=20
Michael

--Sig_/b+3DAsvP3MC=drvS1CjQUv1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUFxAgAAoJEPUyvh2QjYsOlD0QAJ7vPppiW/SwP6O8Wa5lLNy2
bHLVCvuJO5C4zbmPK0xyLiROu1MAuWZu7+9JD+LMRXSiUjhkb1K96rZ4DAP5HRJG
xh6Qv77AEVD7P4usmjQsyiMBi5mzFImXoEjfTM2+6IbIf3p14hTeIIqw+qDYk027
d7I19H8u8N6wRWqdgeZ6Y4X5MgUFF/y2QZ9tugLanv+ASJT4f8AMbewV3HXuXixu
rJbJ59EO5/uyhFxEqBgZNo93Df+43zGKYmsdSBvzFvdWchfdSXcVyWwxOy3T1KeL
t9XaYRAF5OBKY4/L+jjn0csuVz2k4FIvHRsTBxtyNKjWRSL/rekes17CpmwPYYk5
ku8ACnodSGde6B/qCFwMMgqGdqVeENlS0AxE69Ic1+YFOs4o6B2FddSpk/s3i2XQ
wdcxele3BteLtXKRvo0omrKKkQI8satdDDmW/k2dGjnWehBRH7cGXtf+R+OaPPRf
8rHpoR8S+QuyJIoqBODxCOZ+8HLmHHI8BX26Bd1oIRogYboB+ReVzGQoFtTg2+c2
ozywJt89kOThCOv/+iKoE0I77twJmz3VHuo9x8/WQKukc8sBG92fnrzEnvqlg0B9
o6scMaoZPN7hOI1MoxVCKcmw+0U7XtwIhsCXP9s5z4QpqcjcNzMs1sKB6ff4Dh1N
QJkWhKeM13qp8JaBA1B0
=DfGc
-----END PGP SIGNATURE-----

--Sig_/b+3DAsvP3MC=drvS1CjQUv1--
