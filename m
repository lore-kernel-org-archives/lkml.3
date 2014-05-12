Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbaELPFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:05:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59239 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758216AbaELPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:05:04 -0400
Date: Mon, 12 May 2014 17:04:09 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: linux-sunxi <linux-sunxi@googlegroups.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Hans De Goede <hdegoede@redhat.com>,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-usb <linux-usb@vger.kernel.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, Shuge <shuge@allwinnertech.com>,
        zhuzhenhua@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH v2 3/7] phy: usb: sunxi: Introduce
 Allwinner A31 USB PHY support
Message-ID: <20140512150409.GB17154@lukather>
References: <1399726619-30150-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399726619-30150-4-git-send-email-maxime.ripard@free-electrons.com>
 <CAGb2v65Pstk6MqEeK838VUpNXw2cQH8K66Oo4oG3__zzWO3pig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bn2rw/3z4jIqBvZU"
Content-Disposition: inline
In-Reply-To: <CAGb2v65Pstk6MqEeK838VUpNXw2cQH8K66Oo4oG3__zzWO3pig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bn2rw/3z4jIqBvZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 05:14:26PM +0800, Chen-Yu Tsai wrote:
> Hi,
>=20
> On Sat, May 10, 2014 at 8:56 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > The USB phy controller in the A31 differs mostly from the older control=
lers
> > because it has a clock dedicated for each phy, while the older ones wer=
e having
> > a single clock for all the phys.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> > ---
> >  drivers/phy/phy-sun4i-usb.c | 35 ++++++++++++++++++++++++++---------
> >  1 file changed, 26 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
> > index e6e6c4ba7145..8bd89430d945 100644
> > --- a/drivers/phy/phy-sun4i-usb.c
> > +++ b/drivers/phy/phy-sun4i-usb.c
> > @@ -61,7 +61,6 @@
> >  #define MAX_PHYS                       3
> >
> >  struct sun4i_usb_phy_data {
> > -       struct clk *clk;
> >         void __iomem *base;
> >         struct mutex mutex;
> >         int num_phys;
> > @@ -71,6 +70,7 @@ struct sun4i_usb_phy_data {
> >                 void __iomem *pmu;
> >                 struct regulator *vbus;
> >                 struct reset_control *reset;
> > +               struct clk *clk;
> >                 int index;
> >         } phys[MAX_PHYS];
> >  };
> > @@ -146,13 +146,13 @@ static int sun4i_usb_phy_init(struct phy *_phy)
> >         struct sun4i_usb_phy_data *data =3D to_sun4i_usb_phy_data(phy);
> >         int ret;
> >
> > -       ret =3D clk_prepare_enable(data->clk);
> > +       ret =3D clk_prepare_enable(phy->clk);
> >         if (ret)
> >                 return ret;
> >
> >         ret =3D reset_control_deassert(phy->reset);
> >         if (ret) {
> > -               clk_disable_unprepare(data->clk);
> > +               clk_disable_unprepare(phy->clk);
> >                 return ret;
> >         }
> >
> > @@ -170,11 +170,10 @@ static int sun4i_usb_phy_init(struct phy *_phy)
> >  static int sun4i_usb_phy_exit(struct phy *_phy)
> >  {
> >         struct sun4i_usb_phy *phy =3D phy_get_drvdata(_phy);
> > -       struct sun4i_usb_phy_data *data =3D to_sun4i_usb_phy_data(phy);
> >
> >         sun4i_usb_phy_passby(phy, 0);
> >         reset_control_assert(phy->reset);
> > -       clk_disable_unprepare(data->clk);
> > +       clk_disable_unprepare(phy->clk);
> >
> >         return 0;
> >  }
> > @@ -228,8 +227,10 @@ static int sun4i_usb_phy_probe(struct platform_dev=
ice *pdev)
> >         struct phy_provider *phy_provider;
> >         struct reset_control *reset;
> >         struct regulator *vbus;
> > +       bool dedicated_clocks;
>=20
> No default?
>=20
> >         struct resource *res;
> >         struct phy *phy;
> > +       struct clk *clk;
> >         char name[16];
> >         int i;
> >
> > @@ -249,15 +250,20 @@ static int sun4i_usb_phy_probe(struct platform_de=
vice *pdev)
> >         else
> >                 data->disc_thresh =3D 2;
> >
> > +       if (of_device_is_compatible(np, "allwinner,sun6i-a31-usb-phy"))
> > +               dedicated_clocks =3D true;
> > +
>=20
> dedicated_clocks is more than likely to be true from leftover data
> on the stack. This results in the usb phy driver probe failing, and
> the usb host drivers left in perpetual probe deferral on my Cubietruck.
>=20
> Adding an else section fixes this.

Oh, yes. Stupid me. It used to be in a kzalloc'd section, so I didn't
have the error, and didn't properly test it because it was trivial.

Thanks for catching this, I'll submit a v3.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Bn2rw/3z4jIqBvZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTcOLoAAoJEBx+YmzsjxAgVmYQAICIL3S90snp4fF65d0i1+QS
Ndc4SwXNOeH+1oj/vNb2x/WfCAfjvgU7eP9Fd+eTtmfyVEW9pk7MAC6uA4zCZw1H
7suD0L+T2W40PwbAWlHcanNVSX0Ma3UunAJ3v9PHD7asuRu7YLykYrkE4D0mF5Dz
/MU5M0hsoPswl3r6tBqn9w1rIyM/sDAdgQfo/stjEj14XojIUFmLd+zvpIyFiiB1
5S3xfLJz9U9fTHKy8sbD+o1rwtAcoH/6d87rDqJLYrJix7I5CFRcibH0Fmz8TEZw
azAoGbdXvlzst4e0y6LT7VgfWlfbBYyFv+hBfP3aFbPLRe5V+Hcgznf8QU83kM0W
SVr3E96A+UmqsSdvtPPN/+3fCE46YUN20q43k8tfN6RcT4etCuEMwmk/CT5ZWvQv
8yYv5VyvxmcAJx7A1QmWkD0YkcgsB0xd9WGdh1nHCNX+wW8H8uw5tFk3AZcoQsik
RunrAzRP3IkD07sHS/TyDnyY/KRjjj7DKV6qwkOcV+3sxf9u+QoSLvGti8CKiM5S
wlOZev21TPDszuPdCrvzjSV/YAU+oVn9qMerSoHXts3UoHQ1brqihSKEagouP5d5
4JzDam/JWDZkBP4iGZ6H84TffTk6vFXI8Kc0x+49CftRahLy9igulgm5WBbAorX5
zQnGi/OP6eE+nOmYCLWl
=gTE2
-----END PGP SIGNATURE-----

--Bn2rw/3z4jIqBvZU--
