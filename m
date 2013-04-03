Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab3DCOS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:18:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42736 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3DCOSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:18:54 -0400
Date: Wed, 3 Apr 2013 17:18:31 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <sarah.a.sharp@linux.intel.com>,
        <rob.herring@calxeda.com>, <kgene.kim@samsung.com>,
        <dianders@chromium.org>, <t.figa@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
Message-ID: <20130403141831.GJ14680@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
 <1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
 <515BB951.40702@ti.com>
 <CAFp+6iG8WdWHXVCANx77OiTXLeZ-4qE4jySWqPLhfR1KOEP4fw@mail.gmail.com>
 <20130403081532.GE25837@arwen.pp.htv.fi>
 <CAFp+6iHXW8z2sc44c1hq2au_UnUyVZEr9D0t5BM4mfqcQKZgbA@mail.gmail.com>
 <20130403135414.GG14680@arwen.pp.htv.fi>
 <20130403135659.GH14680@arwen.pp.htv.fi>
 <CAFp+6iEmJtS2vxz8YHXP+FbNsxK2bR94rDrrSiKbGRRuUhBA5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jtcAeju3WzRmRF+o"
Content-Disposition: inline
In-Reply-To: <CAFp+6iEmJtS2vxz8YHXP+FbNsxK2bR94rDrrSiKbGRRuUhBA5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jtcAeju3WzRmRF+o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 03, 2013 at 07:40:44PM +0530, Vivek Gautam wrote:
> >> > >> >> +static inline void usb_phy_autopm_enable(struct usb_phy *x)
> >> > >> >> +{
> >> > >> >> +       if (!x || !x->dev) {
> >> > >> >> +               dev_err(x->dev, "no PHY or attached device ava=
ilable\n");
> >> > >> >> +               return;
> >> > >> >> +               }
> >> > >> >> +
> >> > >> >> +       pm_runtime_enable(x->dev);
> >> > >> >> +}
> >> > >> >
> >> > >> >
> >> > >> > IMO we need not have wrapper APIs for runtime_enable and runtim=
e_disable
> >> > >> > here. Generally runtime_enable and runtime_disable is done in p=
robe and
> >> > >> > remove of a driver respectively. So it's better to leave the
> >> > >> > runtime_enable/runtime_disable to be done in *phy provider* dri=
ver than
> >> > >> > having an API for it to be done by *phy user* driver. Felipe, w=
hat do you
> >> > >> > think?
> >> > >>
> >> > >> Thanks!!
> >> > >> That's very true, runtime_enable() and runtime_disable() calls ar=
e made by
> >> > >> *phy_provider* only. But a querry here.
> >> > >> Wouldn't in any case a PHY consumer might want to disable runtime=
_pm on PHY ?
> >> > >> Say, when consumer failed to suspend the PHY properly
> >> > >> (*put_sync(phy->dev)* fails), how much sure is the consumer about=
 the
> >> > >> state of PHY ?
> >> > >
> >> > > no no, wait a minute. We might not want to enable runtime pm for t=
he PHY
> >> > > until the UDC says it can handle runtime pm, no ? I guess this mak=
es a
> >> > > bit of sense (at least in my head :-p).
> >> > >
> >> > > Imagine if PHY is runtime suspended but e.g. DWC3 isn't runtime pm
> >> > > enabled... Does it make sense to leave that control to the USB
> >> > > controller drivers ?
> >> > >
> >> > > I'm open for suggestions
> >> >
> >> > Of course unless the PHY consumer can handle runtime PM for PHY,
> >> > PHY should not ideally be going into runtime_suspend.
> >> >
> >> > Actually trying out few things, here are my observations
> >> >
> >> > Enabling runtime_pm on PHY pushes PHY to go into runtime_suspend sta=
te.
> >> > But a device detection wakes up DWC3 controller, and if i don't wake
> >> > up PHY (using get_sync(phy->dev)) here
> >> > in runtime_resume() callback of DWC3, i don't get PHY back in active=
 state.
> >> > So it becomes the duty of DWC3 controller to handle PHY's sleep and =
wake-up.
> >> > Thereby it becomes logical that DWC3 controller has the right to
> >> > enable runtime_pm
> >> > of PHY.
> >> >
> >> > But there's a catch here. if there are multiple consumers of PHY (li=
ke
> >> > USB2 type PHY can
> >> > have DWC3 controller as well as EHCI/OHCI or even HSGadget) then in =
that case,
> >> > only one of the consumer can enable runtime_pm on PHY. So who decide=
s this.
> >> >
> >> > Aargh!! lot of confusion here :-(
> >>
> >>
> >> hmmm, maybe add a flag to struct usb_phy and check it on
> >> usb_phy_autopm_enable() ??
> >>
> >> How does usbcore handle it ? They request class drivers to pass
> >> supports_autosuspend, but while we should have a similar flag, that's
> >> not enough. We also need a flag to tell us when pm_runtime has already
> >> been enabled.
>=20
> True
>=20
> >>
> >> So how about:
> >>
> >> usb_phy_autopm_enable()
> >> {
> >>       if (!phy->suports_autosuspend)
> >>               return -ENOSYS;
> >>
> >>       if (phy->autosuspend_enabled)
> >>               return 0;
> >>
> >>       phy->autosuspend_enabled =3D true;
> >>       return pm_runtime_enable(phy->dev);
> >> }
> >>
> >> ???
>=20
> Great
>=20
> >
> > and of course I missed the fact that pm_runtime_enable returns nothing
> > :-) But you got my point.
>=20
> Yea, this is a way around this. :-)
>=20
> Just one more query :-)
>=20
> Lets suppose DWC3 enables runtime_pm on USB 2 type phy,
> it will try to go into suspend state and thereby call runtime_suspend(), =
if any.
> And PHY will come to active state only when its consumer wakes it up,
> and this consumer is operational
> only when its related PHY is in fully functional state.
> So do we have a situation in which this PHY goes into low power state
> in its runtime_suspend(),
> resulting in non-detection of devices on further attach (since PHY is
> in low power state) ?
>=20
> Will the controller (like EHCI/OHCI) be functional now ?

ehci/ohci need to cope with that by calling usb_phy_autopm_get_sync(),
right ? (so does DWC3 :-)

--=20
balbi

--jtcAeju3WzRmRF+o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXDo3AAoJEIaOsuA1yqRE5NoQAJA8R7FL6zNlJO89td0BRMk4
sMwNIYF5ymvGkj+bc/rpaYkUA7g6YyKwEYUdZoK9jwGchMEe9nGkF4VkUXFYYtGs
UPBlB0FaQIvg1CtiR95rdKP+cB4oZU3u4a7I0Lzv0VxYOFhPui94rjZpxq45+d1w
0H6Q+i+EPJ/lhXnyClpB5Sjud8OMVnFh7sR/vHe0Rx5oI8diGxQ8+T5NqfzMs84C
Ng+/Oq9hgeUTk5I0FA8R/81YxCQ0rvo8lt9mo/4oeZbmSo22+5DoJyupxknqzKLY
9bI/QTRm2CNqO8grfNh7PAQwg2qLORM/NABq3sFgRa3+m3FTGA8dOTMovi6E6nee
Mbxpu5RPL+Bb8hj/aGDuNx7vVqT4olE/i5SbKhymOiwRrpeg7nKQ6mmBg3xpU9Uw
8CgByMzKP7P2t2bvA8bCVqmxV/kYZ4sh9uCyKCYQq+N0MIkmFaD1mw+HgQ7YQXq/
BAn/LZPRr1I+lHrCU/7iogWNNg6sCAE8V3Upcb0nAvrVPzfE9kuzYms9qBVTkDk8
jHliehyo45gQdAfPooMH1LVYZ6Gkxl/7tvbrJeXXfZjS4xPHnGB2kQwD5wd5d8Tk
pg3U6b7UszLFbdY8bMTrEOu+O9r7gdkMDdVahWsesqnIw0Rwuh4DKSYMiXJQstmd
bSIGFZm8Gf/mr29lRiDl
=oKDm
-----END PGP SIGNATURE-----

--jtcAeju3WzRmRF+o--
