Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaIBOxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:53:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52677 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbaIBOx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:53:28 -0400
Date: Tue, 2 Sep 2014 09:53:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC v2 1/2] usb: phy: Hold wakeupsource when USB is enumerated
 in peripheral mode
Message-ID: <20140902145319.GE16872@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409658428-12281-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FEz7ebHBGB6b2e8X"
Content-Disposition: inline
In-Reply-To: <1409658428-12281-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FEz7ebHBGB6b2e8X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 02, 2014 at 05:17:08PM +0530, Kiran Kumar Raparthy wrote:
> From: Todd Poynor <toddpoynor@google.com>
>=20
> usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode
>=20
> Purpose of this is to prevent the system to enter into suspend state from=
 USB
> peripheral traffic by hodling a wakeupsource when USB is connected and
> enumerated in peripheral mode(say adb).
>=20
> Disabled by default, can enable with:
>    echo Y > /sys/module/otg_wakeupsource/parameters/enabled
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Arve Hj=EF=BF=BDnnev=EF=BF=BDg <arve@android.com>
> Cc: Benoit Goby <benoit@android.com>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> [kiran: Added context to commit message.
> 	Included build fix from Benoit Goby and Arve Hj=EF=BF=BDnnev=EF=BF=BDg.
> 	Removed lock->held field in driver as this mechanism is
> 	provided in wakeupsource driver.
> 	wakelock(wl) terminology replaced with wakeup_source(ws).
> 	changed to "disabled by default" from "enable by default".
> 	sys entry(module param) field modified to otg_wakeupsource.
> 	included Todd's refactoring logic.
> 	Introduced get_phy_hook to handle otgws_xceiv per-PHY.
> 	otgws_nb moved to otg_wakeupsource_init function.
> 	wakeupsource handling implemeted per-PHY(in phy core).
> 	modified Kconfig help text]
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> ---
>  drivers/usb/phy/Kconfig            |   8 +++
>  drivers/usb/phy/Makefile           |   1 +
>  drivers/usb/phy/otg-wakeupsource.c | 140 +++++++++++++++++++++++++++++++=
++++++
>  drivers/usb/phy/phy.c              |  42 +++++++++++
>  include/linux/usb/phy.h            |   8 +++
>  5 files changed, 199 insertions(+)
>  create mode 100644 drivers/usb/phy/otg-wakeupsource.c
>=20
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index e253fa0..d9ddd85 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -6,6 +6,14 @@ menu "USB Physical Layer drivers"
>  config USB_PHY
>  	def_bool n
> =20
> +config USB_OTG_WAKEUPSOURCE
> +	bool "Hold wakeupsource when USB is enumerated in peripheral mode"
> +	depends on PM_SLEEP
> +	select USB_PHY
> +	help
> +	  Prevent the system going into automatic suspend while
> +	  it is attached as a USB peripheral by holding a wakeupsource.
> +
>  #
>  # USB Transceiver Drivers
>  #
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index 24a9133..ca2fbaf 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -3,6 +3,7 @@
>  #
>  obj-$(CONFIG_USB_PHY)			+=3D phy.o
>  obj-$(CONFIG_OF)			+=3D of.o
> +obj-$(CONFIG_USB_OTG_WAKEUPSOURCE)		+=3D otg-wakeupsource.o
> =20
>  # transceiver drivers, keep the list sorted
> =20
> diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wak=
eupsource.c
> new file mode 100644
> index 0000000..fca2010
> --- /dev/null
> +++ b/drivers/usb/phy/otg-wakeupsource.c
> @@ -0,0 +1,140 @@
> +/*
> + * otg-wakeupsource.c
> + *
> + * Copyright (C) 2011 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/notifier.h>
> +#include <linux/pm_wakeup.h>
> +#include <linux/spinlock.h>
> +#include <linux/usb/otg.h>
> +
> +bool enabled =3D false;
> +
> +static DEFINE_SPINLOCK(otgws_spinlock);
> +static struct usb_phy *get_phy_hook(void);

how many times do I have to say that this needs to be per-PHY ? This
means that you shouldn't have a global PHY pointer. Embed this directly
into struct usb_phy and have phy-core handle this.

--=20
balbi

--FEz7ebHBGB6b2e8X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUBdnfAAoJEIaOsuA1yqREjwkQAI+ecRh//QWH0a0l80i9AZqZ
E5GJ59VHye28+QIuJa1rXmKqjFR+GHPbrm0NPCsT/XGFgGURa/uSXpBvv6DlIEox
yTssGpY6E6sgED/PlhcAC0MHCEvNjviLbZY+74a0CyJCBtNEwfmmshhqtdgBWusr
dAi2HhxL0dqEt/j1eXPL6hRYD02MZMeFUM7QOJPJuDNfFn2iRx2cPDTc9tNwMjTN
WCq0zbmNuI1vnBxnUNzlVCsWfxb7ca0GqgWJzYn+KZTZKr2Js22pkG55Va4pfKNu
2+z8I+RvqiEpkypBHfT1ItCjfcmqJN/lqTcPIG0J1HZiJXs2M42q0yNiUHjizXQF
WYXDKc5yjQSbql+u++a3o4ZSb3yPGe1rXtbKeGw+oVdb/jpLOaWxCYlZ2Hn4Cqm6
mLV5gri/0/GLCrpx6JelZ0LFofrHIUugs4CTIDLqVw8BJiqKg/5kz0tho/pYBw3f
7q2XMFvmWM4Wb4jpPriJVbVFF+mis7OoR2M9Pm6pSbBWu5UyYLnn0z2Pxn/GkOJn
1p5o57TKvMEyGQ7HVmrpvRH+qbQA/K//04CvOaF1rP+o+b9YX7ed6MJDssWWW8Ly
f2CmqlNdS/NsDWnPjHWAyFEmbFOrBLV0KdcHxfkpbbuWpWhuhUB6niNZvScFt6uP
i9uee2w6nmZ2RWkjxil0
=V4iT
-----END PGP SIGNATURE-----

--FEz7ebHBGB6b2e8X--
