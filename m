Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbaIPA3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:29:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbaIPA3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:29:17 -0400
Date: Tue, 16 Sep 2014 08:27:40 +0800
From: Amos Kong <akong@redhat.com>
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        herbert@gondor.apana.org.au, mpm@selenic.com, rusty@rustcorp.com.au,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] hw_random: increase schedule timeout in
 rng_dev_read()
Message-ID: <20140916002740.GA5671@zen>
References: <1410796949-2221-1-git-send-email-akong@redhat.com>
 <1410796949-2221-4-git-send-email-akong@redhat.com>
 <20140915181331.4e3f5fed@wiggum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20140915181331.4e3f5fed@wiggum>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2014 at 06:13:31PM +0200, Michael B=FCsch wrote:
> On Tue, 16 Sep 2014 00:02:29 +0800
> Amos Kong <akong@redhat.com> wrote:
>=20
> > This patch increases the schedule timeout to 10 jiffies, it's more
> > appropriate, then other takes can easy to hold the mutex lock.
> >=20
> > Signed-off-by: Amos Kong <akong@redhat.com>
> > ---
> >  drivers/char/hw_random/core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/cor=
e.c
> > index 263a370..b5d1b6f 100644
> > --- a/drivers/char/hw_random/core.c
> > +++ b/drivers/char/hw_random/core.c
> > @@ -195,7 +195,7 @@ static ssize_t rng_dev_read(struct file *filp, char=
 __user *buf,
> > =20
> >  		mutex_unlock(&rng_mutex);
> > =20
> > -		schedule_timeout_interruptible(1);
> > +		schedule_timeout_interruptible(10);
> > =20
> >  		if (signal_pending(current)) {
> >  			err =3D -ERESTARTSYS;
>=20
> Does a schedule of 1 ms or 10 ms decrease the throughput?

In my test environment, 1 jiffe always works (100%), as suggested by
Amit 10 jiffes is more appropriate.

After applied current 3 patches, there is a throughput regression.

  1.2 M/s -> 6 K/s

We can only schedule in the end of loop (size =3D=3D 0), and only for
non-smp guest. So smp guest won't be effected.

|               if (!size && num_online_cpus() =3D=3D 1)
|                       schedule_timeout_interruptible(timeout);


Set timeout to 1:
  non-smp guest with quick backend (1.2M/s) -> about 49K/s)

Set timeout to 10:
  non-smp guest with quick backend (1.2M/s) -> about 490K/s)

We might need other benchmark to test the performance, but we can
see the bug clearly caused a regression.

As we discussed in other thread, need_resched() should work in this
case, so those patches might be wrong fixing.

> I think we need some benchmarks.
>=20
> --=20
> Michael



--=20
			Amos.

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUF4P8AAoJELxSv6I5vP9jDQIP/1SWaW8NOJ2tpJyi5aGWvao1
eXCVplVinycjWydrWTAsh+gYmvaBrAn5CGwvcQtbZA1DGnkFzA/WvkSm4nCVWsUc
3bF5eOgga9GeYNOdkTmYNTbPIBe2uHKRGPhu8uvNgJ/dCnDWBKX1OAPxrmPl8P5y
w5AUC2qXAx/CWHu5pdeDxj+ZJaorhwEHmv+pFLM5w/DRw+pFdJRVoxuqLavQ03Pu
6a1KlnT/7J+mVT4UK/N6M63BHx22vegIa0RpgUKgEXCISRM2Dp32WP3bEDI+FWqw
tqhfsRRk5Cx0xtN052JfYT2NKn1A2VDy7fGYlDZKqqZYLchb2tSADjHrqNW76QbU
WWOEzsA/IbQj8vx25XX6Gn8Ra9NrYOChnoPjEO2ISSOLWdnKB2TIOoVxlLXnkdyC
P8IuvUH9aK2cPkst2ReVY0iqkKxnGX+FKp73jCVPO0shVIrKAdseIBYlAmldZuTD
QOC5JwtWZinjAHBzHKKAhrAxtJ+N3SGqE8/fphHyPHFvGrgMMuZJVEqPdVJO2QW3
Ad95alLhvEv5h5eAk5iQJ6twiWlEvUxITddXEQknO2oH3v7FRYcej8/8p+5LndAR
SAulyGSmOMohCLvz5Yy9eIeWwoWr5ctuO6zLwBLqoqMOTgwisKpvsbmA3dGgIawb
essr5qAn9dLjESg9gHeP
=8tzL
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
