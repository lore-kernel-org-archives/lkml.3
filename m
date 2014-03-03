Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaCCNaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 08:30:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34843 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753751AbaCCNaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 08:30:04 -0500
Date: Mon, 3 Mar 2014 14:26:22 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-sunxi@googlegroups.com, Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [linux-sunxi] [PATCH v2 2/5] clk: sun6i: Reparent AHB clock on
 PLL6
Message-ID: <20140303132622.GY607@lukather>
References: <1393605440-14643-1-git-send-email-maxime.ripard@free-electrons.com>
 <1393605440-14643-3-git-send-email-maxime.ripard@free-electrons.com>
 <53120BA8.3000508@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UXMJB0aDqGdn9A0V"
Content-Disposition: inline
In-Reply-To: <53120BA8.3000508@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UXMJB0aDqGdn9A0V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hans,

On Sat, Mar 01, 2014 at 05:32:40PM +0100, Hans de Goede wrote:
> On 02/28/2014 05:37 PM, Maxime Ripard wrote:
> > In order for the DMA controller to work for SDRAM to devices transfers,=
 the AHB
> > clock should be reparented on the PLL6.
> >=20
> > Force that parenting in the clock driver.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/clk/sunxi/clk-sunxi.c | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunx=
i.c
> > index f6f61cc..a5c5882 100644
> > --- a/drivers/clk/sunxi/clk-sunxi.c
> > +++ b/drivers/clk/sunxi/clk-sunxi.c
> > @@ -1286,7 +1286,7 @@ static void __init of_sunxi_table_clock_setup(con=
st struct of_device_id *clk_mat
> >   */
> >  static void __init sunxi_clock_protect(void)
> >  {
> > -	struct clk *clk;
> > +	struct clk *clk, *parent;
> > =20
> >  	/* memory bus clock - sun5i+ */
> >  	clk =3D clk_get(NULL, "mbus");
> > @@ -1307,6 +1307,22 @@ static void __init sunxi_clock_protect(void)
> >  	if (!IS_ERR(clk))
> >  		clk_prepare_enable(clk);
> > =20
> > +	clk =3D clk_get(NULL, "ahb1_mux");
> > +	if (IS_ERR(clk)) {
> > +		pr_err("Couldn't get AHB1 Mux\n");
> > +		return;
> > +	}
>=20
> I think Emilio already made a similar remark for v1, but since this
> is still here in v2, ahb1_mux is only available on sun6i, so
> at a minimum the pr_err should be dropped. Preferably I would like
> to see this changed to something like:
>=20
> 	clk =3D clk_get(NULL, "ahb1_mux");
> 	parent =3D clk_get(NULL, "pll6");
> 	if (!IS_ERR(clk) && !IS_ERR(parent))
> 		clk_set_parent(clk, parent);
> 	if (!IS_ERR(parent))
> 		clk_put(parent);
> 	if (!IS_ERR(clk))
> 		clk_put(clk);

Still. The DMA doesn't work at all if the parenting is not set, so
having an error if it fails is mandatory.

And the statement that you made can also apply to any clock we enable
here, that might or might not be present in all the SoCs.

I guess we can solve this in two steps:
  - split out the reparenting, and move this into the DMA driver. That
    would isolate things in the driver itself, and prevent a
    reparenting attempt on every SoCs.
  - Split this function into several functions, one for each SoC. That
    would allow to do pretty much anything we want without having to
    care about wether it applies to other platforms.

> > +	parent =3D clk_get(NULL, "pll6");
> > +	if (IS_ERR(clk)) {
>=20
> Copy paste error should be IS_ERR(parent).

Ah, yep, thanks!

>=20
> > +		pr_err("Couldn't get PLL6\n");
>=20
> If we keep things this way this error path should do a clk_put(clk);

Good catch too.

> > +		return;
> > +	}
> > +
> > +	clk_set_parent(clk, parent);
> > +
> > +	clk_put(clk);
> > +	clk_put(parent);
> >  }
> > =20
> >  static void __init sunxi_init_clocks(void)
> >=20
>=20
> Regards,
>=20
> Hans
>=20
> p.s.
>=20
> Given Russell's remarks it would also be good to have a
> patch in this set dropping the clk_put calls of the existing
> enables / protections.

Yes, I'll do it in the v3.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--UXMJB0aDqGdn9A0V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTFIL+AAoJEBx+YmzsjxAgFQoP+wXYWaStAg1Z2odMb7qu4otz
STjlcqLqwGIV4JtuQiqfp5IONVRi3cPZVOBEsf6gWXAuOwv1idKGY0bqpltXvN5v
Evbi1/w3PIxgxpJVu2gKa9JfMRP6VOYcwAMIEIQUfd8m3A1CFtuilBm/WU3uOiga
IS5SYgIlToq0PCkGdUyI4VlO795m1zz1aVadfW+BVvhQ4AfxDcDE0e3mGmDcS4ci
CwlSsNvUHrgECL95nb/B7HgiEGtkqkTAkmhVprc+fJoRNeXU8R3d+t5QCSWLjiD4
V9otne9uIu7PbdkUIABfLtjGebRe9KN2TIqmTLM9iXUU+naEBuCK3l03EULtx6Ze
ef4oxYrx36HzxKIkIMLRl+8FA6zEXSA/iLLG+nYO6Q3CJCQc4mtySdRc6pnkopH/
l3X77WYJxKW8sDn0RH5fmIu5/TM/XLzxIc6+im+/EspJQ/CPvPS+NYsPbz2HgbE2
kIbRDSPkVbj02Dnhh3wGEDqUY8QrApub6bSQ23mkAQohAuSaVOUzua18zHduKvuv
sJtLwdSzLUuAWyWyzHdok8twx4tnf0lLW1A0AoYdctwB4/yq8jQAxEhrAxUDx8uh
vWHgHFDR3KgUk0C1JS/WbVKXyovgx6ShLJxi4pAxG8e4t5lvH0Jxw01Rqe7ZmT9d
6YrJOuVTxlFdMudEmtG1
=ZBeB
-----END PGP SIGNATURE-----

--UXMJB0aDqGdn9A0V--
