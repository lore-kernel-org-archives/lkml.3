Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3ANH5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:57:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43921 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab3ANH5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:57:48 -0500
Date: Mon, 14 Jan 2013 09:57:40 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH RFC] usb: dwc3: Remove dwc3 dependency on gadget.
Message-ID: <20130114075740.GC10176@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1356357513-8892-1-git-send-email-gautam.vivek@samsung.com>
 <20130110130238.GW28920@arwen.pp.htv.fi>
 <CAFp+6iHEJvCPHbSvqYhjuTjzvkKQVuKz8f8TupqFcZ9gdvpt-A@mail.gmail.com>
 <20130111135931.GE12715@arwen.pp.htv.fi>
 <CAFp+6iEvO2z=bWF7awN4vxN5W1YT0eXcpwarXoB8Mf_=BsQBpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
In-Reply-To: <CAFp+6iEvO2z=bWF7awN4vxN5W1YT0eXcpwarXoB8Mf_=BsQBpQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 11, 2013 at 07:58:23PM +0530, Vivek Gautam wrote:
> Hi,
>=20
>=20
> On Fri, Jan 11, 2013 at 7:29 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Fri, Jan 11, 2013 at 07:13:55PM +0530, Vivek Gautam wrote:
> >> On Thu, Jan 10, 2013 at 6:32 PM, Felipe Balbi <balbi@ti.com> wrote:
> >> > Hi,
> >> >
> >> > On Mon, Dec 24, 2012 at 07:28:33PM +0530, Vivek Gautam wrote:
> >> >> DWC3 controller curretly depends on CONFIG_USB and CONFIG_USB_GADGE=
T.
> >> >> Some hardware may like to use only host feature on dwc3.
> >> >> So, removing the dependency of USB_DWC3 on USB_GADGET
> >> >> and further modulating the dwc3 core to enable gadget features
> >> >> only with USB_GADGET.
> >> >>
> >> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> >> CC: Doug Anderson <dianders@chromium.org>
> >> >
> >> > right, right... Eventually we need to do it, but you're only making
> >> > gadget side optional. Host side should be optional too, but then you
> >> > need to make sure we don't build dwc3 without gadget and host.
> >> >
> >>
> >> Yes, true we need to make host side also optional, build dwc3 only when
> >> either of host or gadget are built.
> >
> > btw, make the default Dual-Role, if user/defconfig doesn't select
> > anything we want to build with all features.
> >
>=20
> Yes we can try something like this ?
>=20
>          if (USB || USB_GADGET)

no need for this if, actually...

>          menuconfig USB_DWC3
>                  tristate "DesignWare USB3 DRD Core Support"

make it a "depends on (USB || USB_GAGDGET)" here

other than that, it looks correct. Just make sure to compile test in all
options.

>           if USB_DWC3
>           choice
>           default USB_DWC3_DUAL_ROLE_MODE
>           ...
>=20
>           config USB_DWC3_HOST_MODE

this one should depend on USB

>           ...
>=20
>           config USB_DWC3_DEVICE_MODE

this one should depend on USB_GADGET

>           ...
>=20
>           config USB_DWC3_DUAL_ROLE_MODE

should depend on USB && USB_GADGET

> >> >>  int dwc3_gadget_init(struct dwc3 *dwc);
> >> >>  void dwc3_gadget_exit(struct dwc3 *dwc);
> >> >> +#else
> >> >> +static inline int dwc3_gadget_init(struct dwc3 *dwc)
> >> >> +{ return -EINVAL; }
> >> >> +static inline void dwc3_gadget_exit(struct dwc3 *dwc)
> >> >> +{ }
> >> >> +#endif
> >> >>
> >> >>  #endif /* __DRIVERS_USB_DWC3_CORE_H */
> >> >> diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
> >> >> index d4a30f1..553bbaa 100644
> >> >> --- a/drivers/usb/dwc3/debugfs.c
> >> >> +++ b/drivers/usb/dwc3/debugfs.c
> >> >> @@ -535,7 +535,8 @@ static ssize_t dwc3_testmode_write(struct file =
*file,
> >> >>               testmode =3D 0;
> >> >>
> >> >>       spin_lock_irqsave(&dwc->lock, flags);
> >> >> -     dwc3_gadget_set_test_mode(dwc, testmode);
> >> >> +     if (dwc3_gadget_set_test_mode(dwc, testmode))
> >> >> +             dev_dbg(dwc->dev, "host: Invalid request\n");
> >> >>       spin_unlock_irqrestore(&dwc->lock, flags);
> >> >>
> >> >>       return count;
> >> >
> >> > wrong, if you don't have gadget mode, you just don't create this fil=
e.
> >> >
> >>
> >> dwc3-core makes call to dwc3_debugfs_init() invariably depending on DE=
BUG_FS.
> >> Will this not go ahead and create this file ?
> >> I think i am missing here something.  :-(
> >
> > right, you can change dwc3_debugfs_init() to take into account the fact
> > that you're a gadget/drd or host-only.
> >
> > In case of host only, you stil want regdump to be available :-)
> >
>=20
> So in dwc3_debugfs_init() we shall actually create just 'regdump' file
> in case of host only mode, otherwise keep the dwc3_debugfs_init() happy
> with creating other files too.
> Right ?

right.

--=20
balbi

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ87p0AAoJEIaOsuA1yqREKuUP/jzwgCgCdQ4VzZ3yucXg8b46
418Iy5qaWerIQdO5L3tOF5728WIM0k7PgA/6+vHreKVFZNrJKXzWDNKxFi2pSX6i
g3bY13Dmsh4dOUVO87wmzpEAY53E4Pk/tc29yN6ZgieByUGdw2f8rf3hxntIa3bY
qF72YyPd+kWY62L9SUIuk5S76rM6jkKFJOMnqPuptXI7XuHn0+eWb2/HfNxiaVnj
7IymA/Goy08U/+1Qqvz7Z0XJdPYCp5zEzrffwPlun28gXKI4pHV6ESp2vfG7GaJ7
9kky9UtAKwpy8/sfUzwb1DFgMsuFStWhLlxvNS5FHGgZnwca/2jozDHNSX/+w7+l
1o/D7tIYPfbGfYRDB8IQgZLCms3jtd6t4zwS8p7hudbPbkvx2jL8euqYYRdW6ccR
4yjc3XTGvyHIyNDDUluBaPtwrXPgASDR9XZcJ5YHk8lizx5Ry1QvIDE2dVRjceJf
U1SbVv5wEYtk6wHs4DnpE4WPa/0Od7YdeqcQdh7zkImmgiQbGag+F+e6HK5/4WEn
SRBsX71kBzaCajjkRKl/q2aFWgvI3zJpDu+hVBnIE9XNr7pGRVJ4Ve5HZzYHTcOG
YW/l/MsZ08uqm7t83LNQKyPQGBT91ukDv4iLMRA8CZpNHHiCOwT9nEe3kGBoZ3KY
GhoM3RvIrzSN4lyJJCsn
=yB4X
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
