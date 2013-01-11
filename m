Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3AKN7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:59:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60387 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3AKN7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:59:52 -0500
Date: Fri, 11 Jan 2013 15:59:31 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH RFC] usb: dwc3: Remove dwc3 dependency on gadget.
Message-ID: <20130111135931.GE12715@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1356357513-8892-1-git-send-email-gautam.vivek@samsung.com>
 <20130110130238.GW28920@arwen.pp.htv.fi>
 <CAFp+6iHEJvCPHbSvqYhjuTjzvkKQVuKz8f8TupqFcZ9gdvpt-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DEueqSqTbz/jWVG1"
Content-Disposition: inline
In-Reply-To: <CAFp+6iHEJvCPHbSvqYhjuTjzvkKQVuKz8f8TupqFcZ9gdvpt-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DEueqSqTbz/jWVG1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 11, 2013 at 07:13:55PM +0530, Vivek Gautam wrote:
> On Thu, Jan 10, 2013 at 6:32 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Mon, Dec 24, 2012 at 07:28:33PM +0530, Vivek Gautam wrote:
> >> DWC3 controller curretly depends on CONFIG_USB and CONFIG_USB_GADGET.
> >> Some hardware may like to use only host feature on dwc3.
> >> So, removing the dependency of USB_DWC3 on USB_GADGET
> >> and further modulating the dwc3 core to enable gadget features
> >> only with USB_GADGET.
> >>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> CC: Doug Anderson <dianders@chromium.org>
> >
> > right, right... Eventually we need to do it, but you're only making
> > gadget side optional. Host side should be optional too, but then you
> > need to make sure we don't build dwc3 without gadget and host.
> >
>=20
> Yes, true we need to make host side also optional, build dwc3 only when
> either of host or gadget are built.

btw, make the default Dual-Role, if user/defconfig doesn't select
anything we want to build with all features.

> > Maybe make a mode selection for Host-only, Peripheral-only, Dual-Role
> > Device ??
> >
>=20
> True this will be good idea to use modes: host only, gadget only or dual =
role.
> May be the platform glue layers can use them later to put the controller
> in a specific mode ?

probably not as that's likely to change from board to board.

> >>  int dwc3_gadget_init(struct dwc3 *dwc);
> >>  void dwc3_gadget_exit(struct dwc3 *dwc);
> >> +#else
> >> +static inline int dwc3_gadget_init(struct dwc3 *dwc)
> >> +{ return -EINVAL; }
> >> +static inline void dwc3_gadget_exit(struct dwc3 *dwc)
> >> +{ }
> >> +#endif
> >>
> >>  #endif /* __DRIVERS_USB_DWC3_CORE_H */
> >> diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
> >> index d4a30f1..553bbaa 100644
> >> --- a/drivers/usb/dwc3/debugfs.c
> >> +++ b/drivers/usb/dwc3/debugfs.c
> >> @@ -535,7 +535,8 @@ static ssize_t dwc3_testmode_write(struct file *fi=
le,
> >>               testmode =3D 0;
> >>
> >>       spin_lock_irqsave(&dwc->lock, flags);
> >> -     dwc3_gadget_set_test_mode(dwc, testmode);
> >> +     if (dwc3_gadget_set_test_mode(dwc, testmode))
> >> +             dev_dbg(dwc->dev, "host: Invalid request\n");
> >>       spin_unlock_irqrestore(&dwc->lock, flags);
> >>
> >>       return count;
> >
> > wrong, if you don't have gadget mode, you just don't create this file.
> >
>=20
> dwc3-core makes call to dwc3_debugfs_init() invariably depending on DEBUG=
_FS.
> Will this not go ahead and create this file ?
> I think i am missing here something.  :-(

right, you can change dwc3_debugfs_init() to take into account the fact
that you're a gadget/drd or host-only.

In case of host only, you stil want regdump to be available :-)

--=20
balbi

--DEueqSqTbz/jWVG1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ8BrDAAoJEIaOsuA1yqREy04P/i71Ou2Eg7K0+/QdMUg3ATmV
k+J31hV7CVoed8+TGkEpbltNzcYcfZIi7G21NP3INeDgaNBIMbaJjAGa6YAttQSW
yE7isDUEYytM0uTv+q5ZNe7YGOKOWv1DhPXl0b/qW5qz+sc4hFp9XsB/QSdbdC4t
W+7x4owqRT9hAccW6BWxJNhgiWHkgtTjtrd+TJHAKGKoU8ezM3goBWjz3NZ04ibi
88ufXqrxSWbEvhe4WBUCyABEJpUUTVL8OPrBRgIaY4NfF/RGfdZFF2QTA3F9Xkfb
pDEAMyEbzgu3Xs+pZVjY1G0hVFju1yUqVn59Oemz1vUxSdXBqth1iEBvrMqeJYTu
KsS/QqEM7jDZliQmWz/ggPEo/pPc7dikKaZpoY+jLyx6k8wmI94Wf131BILCZi3U
Q5v+qMxFjM57Cd2GrGpdsKPVP53s2VKQcwghKwkspT10Qkl2jJKaj68TaiADr6oT
F7oaa3XNo1/vBka796RXjiOPsos7XJbngcmqq8NWloXTB+EHuEW9vz+V3X+/Dg5e
Jy9tYz/4oPQPvuHx7zV6litC+mgVpZhXGGmb8PkPu2VfCBThyRysO/RxilyC3Tuj
h3LV2riQM0rvWow9JtabmEqdrmCz8zRg/der3s9LbKIapqfDZO0JDFoi1YRHkd8I
GrxKJwoypMP28JO0e+ix
=8B7j
-----END PGP SIGNATURE-----

--DEueqSqTbz/jWVG1--
