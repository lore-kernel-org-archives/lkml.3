Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab3DCN5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:57:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58424 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757908Ab3DCN5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:57:20 -0400
Date: Wed, 3 Apr 2013 16:56:59 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Vivek Gautam <gautamvivek1987@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <sarah.a.sharp@linux.intel.com>,
        <rob.herring@calxeda.com>, <kgene.kim@samsung.com>,
        <dianders@chromium.org>, <t.figa@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
Message-ID: <20130403135659.GH14680@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
 <1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
 <515BB951.40702@ti.com>
 <CAFp+6iG8WdWHXVCANx77OiTXLeZ-4qE4jySWqPLhfR1KOEP4fw@mail.gmail.com>
 <20130403081532.GE25837@arwen.pp.htv.fi>
 <CAFp+6iHXW8z2sc44c1hq2au_UnUyVZEr9D0t5BM4mfqcQKZgbA@mail.gmail.com>
 <20130403135414.GG14680@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nywXBoy70X0GaB8B"
Content-Disposition: inline
In-Reply-To: <20130403135414.GG14680@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nywXBoy70X0GaB8B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 03, 2013 at 04:54:14PM +0300, Felipe Balbi wrote:
> > >> >> +static inline void usb_phy_autopm_enable(struct usb_phy *x)
> > >> >> +{
> > >> >> +       if (!x || !x->dev) {
> > >> >> +               dev_err(x->dev, "no PHY or attached device availa=
ble\n");
> > >> >> +               return;
> > >> >> +               }
> > >> >> +
> > >> >> +       pm_runtime_enable(x->dev);
> > >> >> +}
> > >> >
> > >> >
> > >> > IMO we need not have wrapper APIs for runtime_enable and runtime_d=
isable
> > >> > here. Generally runtime_enable and runtime_disable is done in prob=
e and
> > >> > remove of a driver respectively. So it's better to leave the
> > >> > runtime_enable/runtime_disable to be done in *phy provider* driver=
 than
> > >> > having an API for it to be done by *phy user* driver. Felipe, what=
 do you
> > >> > think?
> > >>
> > >> Thanks!!
> > >> That's very true, runtime_enable() and runtime_disable() calls are m=
ade by
> > >> *phy_provider* only. But a querry here.
> > >> Wouldn't in any case a PHY consumer might want to disable runtime_pm=
 on PHY ?
> > >> Say, when consumer failed to suspend the PHY properly
> > >> (*put_sync(phy->dev)* fails), how much sure is the consumer about the
> > >> state of PHY ?
> > >
> > > no no, wait a minute. We might not want to enable runtime pm for the =
PHY
> > > until the UDC says it can handle runtime pm, no ? I guess this makes a
> > > bit of sense (at least in my head :-p).
> > >
> > > Imagine if PHY is runtime suspended but e.g. DWC3 isn't runtime pm
> > > enabled... Does it make sense to leave that control to the USB
> > > controller drivers ?
> > >
> > > I'm open for suggestions
> >=20
> > Of course unless the PHY consumer can handle runtime PM for PHY,
> > PHY should not ideally be going into runtime_suspend.
> >=20
> > Actually trying out few things, here are my observations
> >=20
> > Enabling runtime_pm on PHY pushes PHY to go into runtime_suspend state.
> > But a device detection wakes up DWC3 controller, and if i don't wake
> > up PHY (using get_sync(phy->dev)) here
> > in runtime_resume() callback of DWC3, i don't get PHY back in active st=
ate.
> > So it becomes the duty of DWC3 controller to handle PHY's sleep and wak=
e-up.
> > Thereby it becomes logical that DWC3 controller has the right to
> > enable runtime_pm
> > of PHY.
> >=20
> > But there's a catch here. if there are multiple consumers of PHY (like
> > USB2 type PHY can
> > have DWC3 controller as well as EHCI/OHCI or even HSGadget) then in tha=
t case,
> > only one of the consumer can enable runtime_pm on PHY. So who decides t=
his.
> >=20
> > Aargh!! lot of confusion here :-(
>=20
>=20
> hmmm, maybe add a flag to struct usb_phy and check it on
> usb_phy_autopm_enable() ??
>=20
> How does usbcore handle it ? They request class drivers to pass
> supports_autosuspend, but while we should have a similar flag, that's
> not enough. We also need a flag to tell us when pm_runtime has already
> been enabled.
>=20
> So how about:
>=20
> usb_phy_autopm_enable()
> {
> 	if (!phy->suports_autosuspend)
> 		return -ENOSYS;
>=20
> 	if (phy->autosuspend_enabled)
> 		return 0;
>=20
> 	phy->autosuspend_enabled =3D true;
> 	return pm_runtime_enable(phy->dev);
> }
>=20
> ???

and of course I missed the fact that pm_runtime_enable returns nothing
:-) But you got my point.

--=20
balbi

--nywXBoy70X0GaB8B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXDUrAAoJEIaOsuA1yqREtFEP+gL//Z+0QrVOfr5WOruzqmn5
EUs9vo5wNDNOgNjilLhlRRAoTYiNfr+m9v7eS3ckcl+lT+oEwy1iXX6G3dmvBnT2
J9TQs/wbrmDHviq+TYyZxF2QJ181Remj/D1nnglsOrUf5oyCDOhWMDEfH7ML/013
AwvqbyYNJPvwd2sTMYVtuPZmKjRSJ55UDZ2YXikDf9P4vjMcAInSRnylmpM9mDe4
lZZcBN6Guuvn68HxwDo8osE68fJyT2/YRiGIloleoave2In6PjbQR6LhJ0xmcLqF
8nFg31mFoWALHU/IApGLsm03m5Zc62o0axV6iVc5Qp3LanxmOx5/vJnRscd1sZxP
U8RKyaLagyVL8ZJeURF6LsBOgGczEVCC6moqdkx5lYwKRYl8cQtdVwrGfRTkMlco
dczpuGIc7mSFwEnvgeW7h619G7KrNd58eFJ1/UFQAw1v1eufAk80Xsd55V0diLpn
v7Y6E2i/3TbSYfNt7pgUZGT05LJJG86sjeN1JAFA3doP6YV6J+ZNmjWGdtoskvUY
6SacIvcVxIQjfc4+xdDALDD7YF3Iui65PhKZOWsP7mWKIXCIdYyBtdQfCr+aFM/y
YwgHC+PUwqOmI+qEwf4/2lNR4jDNcTyxHklBLlsPVqqzN7NtLSk/TzJxvFBN0K0t
ey8bLFnw/9vfW6Eh8Z7U
=HUtF
-----END PGP SIGNATURE-----

--nywXBoy70X0GaB8B--
