Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaEPMl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:41:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58120 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaEPMl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:41:26 -0400
Date: Fri, 16 May 2014 07:41:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
CC: Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <david.a.cohen@linux.intel.com>, Yuan Hang <hang.yuan@intel.com>,
        Li Jiebing <jiebing.li@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] usb: dwc3: gadget: check link trb after free_slot is
 increased
Message-ID: <20140516124106.GA20386@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140515215757.GD16153@intel.com>
 <20140515153757.GB7360@saruman.home>
 <20140516155013.GE16153@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20140516155013.GE16153@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, May 16, 2014 at 11:50:13PM +0800, Zhuang Jin Can wrote:
> > On Fri, May 16, 2014 at 05:57:57AM +0800, Zhuang Jin Can wrote:
> > > In ISOC transfers, when free_slot points to the last TRB (i.e. Link
> > > TRB), and all queued requests meet Missed Interval Isoc error, busy_s=
lot
> > > points to trb0.
> > > 	busy_slot->trb0
> > > 		   trb1
> > > 		   ...
> > > 	free_slot->trb31(Link TRB)
> > >=20
> > > After end transfer and receiving the XferNotReady event, trb_left is
> > > caculated as 1 which is wrong, and no TRB will be primed to the
> > > endpoint.
> > >=20
> > > The root cause is free_slot is not increased the same way as busy_slo=
t.
> > > When busy_slot is increased by one, it checks if points to a link TRB
> > > after increasement, but free_slot checks it before increasement.
> > > free_slot should behave the same as busy_slot to make the trb_left
> > > caculation correct.
> > >=20
> > > Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> > > Signed-off-by: Jiebing Li <jiebing.li@intel.com>
> > > ---
> > >  drivers/usb/dwc3/gadget.c |    8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > > index 54da8c8..2ebe82b 100644
> > > --- a/drivers/usb/dwc3/gadget.c
> > > +++ b/drivers/usb/dwc3/gadget.c
> > > @@ -828,10 +828,6 @@ static void dwc3_prepare_one_trb(struct dwc3_ep =
*dep,
> > >  			length, last ? " last" : "",
> > >  			chain ? " chain" : "");
> > > =20
> > > -	/* Skip the LINK-TRB on ISOC */
> > > -	if (((dep->free_slot & DWC3_TRB_MASK) =3D=3D DWC3_TRB_NUM - 1) &&
> > > -			usb_endpoint_xfer_isoc(dep->endpoint.desc))
> > > -		dep->free_slot++;
> > > =20
> > >  	trb =3D &dep->trb_pool[dep->free_slot & DWC3_TRB_MASK];
> >=20
> > I have a feeling this has a negative side effect of letting us use the
> > link TRB for data transfer... I mean, if we don't increment free_slot
> > before accessing our trb_pool, we have no way to skip link trb on this
> > access here.
> After every free_slot++ Link TRB is checked and increased if appropriate,
> this guarantees you next time access free_slot, it can't be a Link
> TRB.

right, next access will be fine, but you're forgetting about current
access.

> > How did you find the bug ? do you have good instructions on how to
> > reproduce it ? How did you test the patch and for how long ?
> The bug is reproduced on Android with f_audio_source.c enabled, which
> has an isoc-in endpoint keeps sending audio data to host in an interval
> of 1 ms. Normally, you need to run for 12+ hours to hit the issue.
> So I think you can just run some isoc transfers for a long time to
> reproduce it. To accelarte the reproducing, you can run some concurrent
> data transfer as well, so the possibility to meet missed interval error
> is larger.
>=20
> The patch is tested for basic functionality like enumeration, data
> transfers. For this bug, it was tested for 20+ hours.

thanks, g_audio loop should be fine.

--=20
balbi

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTdgdiAAoJEIaOsuA1yqRE/YQP+wUl8UuKG3hDR5YZnfSVuBGJ
INcVDDaC8WpqfnCy9U7oeOGEnA3yFf7kjmumF3fSE91vFlI9yIQ1b5MPED3SXV62
OMxsHDE31ua4IMb+KJ8Tm/eRvjIf9UzAFOH1BqS32NsCpsc1GNQnjQvgXePpDdGB
HEPG0gLLccDOPoBExgjzTIsPHvxiuQFUxjougQEXKEjI0ZdFTuvSoXoidT31Kqc2
0hJn+gkTekPMhXNvH6gx1cC57gueDtcRwF6aPUYB+sQvMCzC2ZtdCfY/my7G0z/T
VJev9NRaeABI44f6y3CWiI16GORTNR6hj+iL7NaNmdCwUbrnVB9yp/am4Snp0fFJ
UQtbpmXKTaUPqg1vgAcFPzo5fE2QoykX5N144hbbZEejTOWNtziqyb1qbCz1Hixi
sMERQyKwjM9WzL3HAyipT2CJgISE4Uhl75N80X1ZrKgS0A6BQo/vZ2m26lkh9fe/
NwBtN8Bg4CN8kldkDp5LOYSYuOlRaENHGEO82yFRYNHSUs0BzDIT2Ql2OaLgfoO7
kxLk81aZ3HcBS9tZjCYs8eYvMjJoC3hVe92U4BrgYoEMa/6ddrDIBZUXKqFvFXSj
be3fh7e2SlCjLy/oXOxexgk7UM8ZUhsM5p+2PQj7O6KLn51aNQTsERtkiqKU9rCW
7CQm12XHvOwjN+IPIh9u
=uBd+
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
