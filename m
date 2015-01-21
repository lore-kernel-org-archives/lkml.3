Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbbAUPJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:09:14 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:54161 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbbAUPFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:05:17 -0500
Date: Wed, 21 Jan 2015 16:05:12 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 01/36] clk: Introduce clk_try_parent()
Message-ID: <20150121150511.GB22884@ulmo.nvidia.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
 <1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
 <54BEAAB4.9030803@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <54BEAAB4.9030803@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2015 at 11:21:24AM -0800, Stephen Boyd wrote:
> On 01/20/2015 02:48 AM, Thierry Reding wrote:
> > =20
> >  /**
> > + * clk_try_parent - check if a clock can be the parent clock source of=
 another
> > + * @clk: clock source
> > + * @parent: parent clock source
> > + *
> > + * This is like clk_set_parent(), except that it only checks that pare=
nt can
> > + * be the parent clock source for clock.
> > + *
> > + * Returns success (0) or negative errno.
> > + */
> > +int clk_try_parent(struct clk *clk, struct clk *parent)
> > +{
> > +	int err =3D 0;
> > +
> > +	if (!clk || !parent)
> > +		return -EINVAL;
>=20
> NULL clock should be a nop, so return success in either case.

Okay.

> > +
> > +	if ((clk->num_parents > 1) && !clk->ops->set_parent)
> > +		return -ENOSYS;
>=20
> This suffers from the same problem as discussed in another thread where
> the mux is read-only and the parent is the current parent. That case
> shouldn't fail.

Okay, if I do a lookup on the parent names array as you suggested below
I don't need to consider this anyway.

> > +
> > +	clk_prepare_lock();
> > +
> > +	if (clk->parent =3D=3D parent)
> > +		goto unlock;
> > +
> > +	err =3D clk_fetch_parent_index(clk, parent);
> > +	if (err > 0)
> > +		err =3D 0;
> > +
>=20
> Given that we just throw away the index, perhaps we should just loop
> over the parent_names array searching for a name match on the parent's
> name. If we did that this entire function would be lockless too.

Done.

> > +unlock:
> > +	clk_prepare_unlock();
> > +
> > +	return err;
> > +}
> > +EXPORT_SYMBOL_GPL(clk_try_parent);
> > +
> > +/**
> >   * clk_set_parent - switch the parent of a mux clk
> >   * @clk: the mux clk whose input we are switching
> >   * @parent: the new input to clk
> > diff --git a/include/linux/clk.h b/include/linux/clk.h
> > index fb1ac65f127c..94da8c68a515 100644
> > --- a/include/linux/clk.h
> > +++ b/include/linux/clk.h
> > @@ -328,6 +328,15 @@ long clk_round_rate(struct clk *clk, unsigned long=
 rate);
> >  int clk_set_rate(struct clk *clk, unsigned long rate);
> > =20
> >  /**
> > + * clk_try_parent - check if a clock can be the parent clock source of=
 another
> > + * @clk: clock source
> > + * @parent: parent clock source
> > + *
> > + * Returns success (0) or negative errno.
>=20
> Why not a bool? Do we really care why we can't set the parent in the
> error case?

A bool should do fine. I guess a negative error code would've been
easier to propagate, but we can probably just return an -EINVAL if
clk_has_parent() fails.

> > + */
> > +int clk_try_parent(struct clk *clk, struct clk *parent);
>=20
> The name makes me think of mutex_trylock(), so I immediately think this
> tries to set the parent. Perhaps a better name would be
> clk_can_have_parent() or clk_has_parent()?

clk_has_parent() sounds good to me.

Thierry

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUv8AnAAoJEN0jrNd/PrOhB5sQAJnhGRMYSv6JJb4OkVU1V1sw
rpxMQyuN1JL2Mqr02+Mc6Xo8YXeyhXn3qQabG8WBcnrA221oFHO5EtMGojr1Vfys
eRNgvWWR+ETChW2b5N52IDYDWhtVz82whgi4//2jg7bMx93c3AzaSN65Hw4izcwi
DtzXG3qGEu9QvXyCBwAQjbHsuD6XiWTKrPYq3pcCHoF4z62Z5zax2j4C+G1GU0pK
FrWim7/jLfnQQHr5FfQNwlIsLqXvAabxQr46DmVnwXmJ1sDrCXDIjZjuHwenZN9X
aj9BgCqrF8YY71QeZHYpvSt7GUl8XaFelD+a+BjOo0UxOxMSP4L4JZVlZR/slyqG
EY2s/tz6u3cRWyXqwVvv7OWADaj7eQeV/11yqQFbXHqPgvVsfEV5QgJuTh34ESJr
/crk42D5piFeepWTlUzCURufB/QhKN42DuSYYCOoSim7nkncvbwx3YLRdSTxFtXW
AK6+6Fwu/tYGFoYLvAK9DUXRkRVRWT5yTvtd60czM4K8/KaALfiqdjJ+z4HJX7Nj
S3b1IZeXr7r1Shv75OHC6MjOidc4ft836enxiEE/5uC2Ymdsw05DxetkhhxUTd+Z
haXSEGLBQcf5DNCviAcRmOGh6yqefnxVC7h8hqoYJez5eyGvMi6KhepCnSJkioeC
GkrWj89mk9RjWuMs/Bvb
=XWy/
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
