Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3ITHyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 03:54:21 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:38583 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab3ITHyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 03:54:19 -0400
Date: Fri, 20 Sep 2013 09:53:03 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Manish Badarkhe <badarkhe.manish@gmail.com>,
        Darbha Sriharsha <dsriharsha@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [Patch V2] drivers: power: Add support for bq24735 charger
Message-ID: <20130920075302.GB8575@ulmo>
References: <1379607514-11200-1-git-send-email-rklein@nvidia.com>
 <20130919202706.GB4470@ulmo>
 <523B6257.4040302@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <523B6257.4040302@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 19, 2013 at 04:45:11PM -0400, Rhyland Klein wrote:
> On 9/19/2013 4:27 PM, Thierry Reding wrote:
> > * PGP Signed by an unknown key
> >=20
> > On Thu, Sep 19, 2013 at 12:18:33PM -0400, Rhyland Klein wrote:
> >> From: Darbha Sriharsha <dsriharsha@nvidia.com>
> >>
> >> Adding driver support for bq24735 charger chipset.
> ...snip
> >=20
> >> +             return -ENOMEM;
> >> +     }
> >> +
> >> +     charger_device->pdata =3D client->dev.platform_data;
> >> +
> >> +     if (!charger_device->pdata && client->dev.of_node)
> >=20
> > If you use IS_ENABLED(CONFIG_OF) here, the compiler will see that it
> > evaluates to 0 if OF is not selected, in which case it will be clever
> > enough to see that bq24735_parse_dt_data() is not used and just discard
> > it (because it is static). Then the #ifdefery above is not needed and
> > you will get compile coverage whether or not OF has been selected. Which
> > is a good thing.
> >=20
> > That said, I've mentioned before that you may want to not support the
> > non-DT at all since there's no immediate need, so this may not even be
> > an issue.
>=20
> The main reason I don't want to break non-DT support (or just not
> implement it) is that this driver is going to be used in our downstream
> kernels, and I prefer to minimize the patches they will have on top of
> it so we don't diverge.

I was under the impression that our downstream kernels used DT for a lot
of devices already. This doesn't look like a very special binding, and I
don't see a reason why we'd have to use platform data in our downstream
kernels.

> >> +     name =3D charger_device->pdata->name;
> >> +     if (!name) {
> >> +             name =3D kasprintf(GFP_KERNEL, "bq24735-%s",
> >> +                              dev_name(&client->dev));
> >=20
> > Won't the device name already include bq24735 because of the driver
> > name?
>=20
> In my experience this comes up with a name like "bq24735-5-0009". Thats
> why I added the bq24735 in the beginning, so the name is more descriptive.

Yes, you're right. Perhaps in that case it's even easier to just stick
with a static string such as "bq24735" or "bq24735-charger". It's likely
to be the only device of that type in a machine. If you want to include
the device name, perhaps something like "%s/bq24735" (5-0009/bq24735) is
clearer that 5-0009 is actually the bus-specific name.

> > Also I don't see where charging is disabled. Or enabled when AC power is
> > plugged after the device has been probed. How does that work?
>=20
> I believe charging is auto-disabled when the adapter is unplugged, but I
> will verify and if that doesn't seem to be the case. This is something
> that should likely be added to the ISR (enable/disable).

I can very well imagine that it's auto-disabled when the power supply is
unplugged, but probably more importantly charging should be reenabled
when the supply is plugged again.

> >> +#define BQ24735_CHG_OPT_REG          0x12
> >> +#define BQ24735_CHG_OPT_CHARGE_ENABLE        (1 << 0)
> >> +#define BQ24735_ENABLE_CHARGING              0
> >> +#define BQ24735_DISABLE_CHARGING     1
> >=20
> > I don't think these are really useful. The field is already named
> > CHARGE_ENABLE, so it should be pretty clear what you're supposed to put
> > in here. For that matter, I'm not a huge fan of the whole "update bits"
> > API because it encourages these things and they are just confusing.
>=20
> The only thing about the enable bit is that isn't kind of inverted what
> what you might expect. 1 is disabling. Thats why I think the bit
> definitions for enable/disable make sense. What would you suggest to
> replace the "update bits" API?

Well, especially for single bits I find it much more intuitive to do
something like this:

	value =3D read();
	value |=3D ENABLE;
	write(value);

or

	value =3D read();
	value &=3D ~ENABLE;
	write(value);

And if the meaning of the bit is inverted, then you can just rename
ENABLE to DISABLE. "update bits" might be fine for fields wider than a
single bit, but even in those cases, I find something like the above
much easier to read. But perhaps that's just personal preference.

Thierry

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSO/7eAAoJEN0jrNd/PrOhmnsP/08lv4ERwi0uF/kd4URz6XZ4
EVt3+tm/uaKgWZXRCEiZGDvZlCY/6pnXpQ1dPZPqozuOny+f0N1Mcw+BoF7Id436
fBsObcdWq8YrcUX13BN8QWPd5NxV6M2pm+SOfmes9H92EOJ/4xhhjPuELt8EpStK
ugvyw6pxYVW/lPNd+s22Bv419mbU7oOYO3FVo3ew5+Bn0qpbNYnriyLMFgH4T1rF
dFWnpHdEBZrqPiHqR56RsPRuOl+WeRcZBji2gStWigkHM2DFlJj5yo5d695D3Irg
pA6R8Mn71s1TXNVDAvCmBhiJY57/+gSFQJFVUTaXj8K+4FZ4n3cWNAjs76Ss4bNU
D+SUejHBiitFfBqFqhK+7MDhHRuLxJBUgb7Q654xauUnJXwN334UEVSUCe8l6BzY
MmNuCOkqNVTYBD0wrdiRAjrwXLF/I/vPPdTmnXG1blk5bdy+01P5gcKtaSYTugXT
NCJTVXoDDSYAdS7tyf6HOdzg5jXpyyI2G6pP2ZRwlWZZiGBJ7d/oImx3o1hERQ1D
PsNH2Al1+oQLMRe+WCixLemBc+tQVeqFGTF2D/8vhpWpUFNXFapc9DO37zDoTGkk
UPkwCgmhV+nr3w01MOELZgwDkd/BoRGV5O00wmSaTn/s6Yt78mmHBo7nxBeTGhnd
EovnbdJ8mFq5RsZ80M9g
=Om+c
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
