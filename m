Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbaHVRMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:12:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43068 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbaHVRMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:12:20 -0400
Date: Fri, 22 Aug 2014 12:12:10 -0500
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
Subject: Re: [RFC 1/2] USB: OTG: Hold wakeupsource when VBUS present
Message-ID: <20140822171210.GD27616@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408700972-8518-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <1408700972-8518-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 22, 2014 at 03:19:32PM +0530, Kiran Kumar Raparthy wrote:
> From: Todd Poynor <toddpoynor@google.com>
>=20
> USB: OTG: Hold wakeupsource when VBUS present
>=20
> Enabled by default, can disable with:

I would turn this around and make it disabled by default so that it
doesn't change behavior for distro kernels.

>    echo N > /sys/module/otg_wakeupsource/parameters/enabled
>=20
> This is one of the number of patches from the Android AOSP common.git tre=
e,
> which is used on almost all Android devices. so I wanted to submit it for
> review to see if it should go upstream.

you never explain why this is needed and you have also added some
information to commit log which shouldn't be here.

> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Arve Hj=EF=BF=BDnnev=EF=BF=BDg <arve@android.com>
> Cc: Benoit Goby <benoit@android.com>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> [kiran: Added context to commit message
> 	Included build fix from Benoit Goby and Arve Arve Hj=EF=BF=BDnnev=EF=BF=
=BDg
> 	Removed lock->held field in driver as this mechanism is provided in wake=
up.c
> 	wakelock(wl) terminology replaced with wakeup_source(ws)
> 	sys entry(module param) field modified to otg_wakeupsource
> 	__pm_stay_awake and __pm_relax called directly from the main
> 	code instead of calling them via otgws_grab,otgws_drop]
> ---
>  drivers/usb/phy/Kconfig            |   8 ++
>  drivers/usb/phy/Makefile           |   1 +
>  drivers/usb/phy/otg-wakeupsource.c | 171 +++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 180 insertions(+)
>  create mode 100644 drivers/usb/phy/otg-wakeupsource.c
>=20
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index e253fa0..9c747b2 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -6,6 +6,14 @@ menu "USB Physical Layer drivers"
>  config USB_PHY
>  	def_bool n
> =20
> +config USB_OTG_WAKEUPSOURCE
> +	bool "Hold a wakeupsource when USB connected"
> +	depends on PM_SLEEP
> +	select USB_PHY
> +	help
> +	  Select this to automatically hold a wakeupsource when USB is
> +	  connected, preventing suspend.
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
> index 0000000..fa44e11
> --- /dev/null
> +++ b/drivers/usb/phy/otg-wakeupsource.c
> @@ -0,0 +1,171 @@
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
> +static bool enabled =3D true;
> +static struct usb_phy *otgws_xceiv;
> +static struct notifier_block otgws_nb;

this aches to be a per-PHY thing rather forcing it to be a one-for-all.

We have systems with more than one port and the PHY framework is also
starting to be used by the host side stack.

> +static DEFINE_SPINLOCK(otgws_spinlock);
> +
> +/*
> + * Only one lock, but since these 2 fields are associated with each othe=
r...
> + */

one line comment

> +
> +struct otgws_lock {
> +	char name[40];
> +	struct wakeup_source wsource;
> +};
> +
> +/*
> + * VBUS present lock.
> + */

one line comment

> +static struct otgws_lock vbus_lock;

should be per-PHY

--=20
balbi

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT93nqAAoJEIaOsuA1yqREuxMQAKIi1BGaskMH6biGk6A+jaRq
HVrvHPj5G6ZhZ/N1cBAOipYdGAWXCIciZebB9Rzj27oyLjrmmnWXRgTMNim/t/IZ
Pef1T3iQncNuvxWb6cI77K8w4pbqE9jIJ4GScKrmvkzF/x2zxuggvPc0eru8Kp06
f6WEPtneZfbH6tpavGaRClW08xOby6703OtvIYtGpyYTEeno5SUYj87JgZ7IRLkn
jHg/Jam38O1keZjwqO8oYZg1SsV0omAb3XAwbIRmPSTTalT3WPZq7eIqa0t7tVLS
8fAREHmJMnfWDs7BV0ARymKMnVZfqu3VXa58tZx2dPDN1nnf6qF9P1DtZRORzyJT
mejAIQYAbIPTPdWEkhIB2TxMEQKXeqcnbRJYBGqw+MD4ayP/XwQPziQ/dn2rhk5+
JO5FOcwL90nhKo8irGJ5j6PklqlSDOYY2svMWloP/EXQ49LH7n0KbkBnqapyAcAQ
DvrxdctQqJlreGFUEO3ltt2nFjUtsK+OhPPaXTYEjcMCU/sBzSnonThrob7eu7/s
F2HkXu2V9q7VAWPjiEE4AaCRt9Edwf4WiLHIIrKuiY0xFXdTUqLsDeQR2/jZybl1
/R6fBfdK0j/hwrrXVOU8lu1/NsOEU5P3vD0aXwnQmUP+Zm+hSEPZyAJvs13Bz6ld
VuMWLTJjRp6oYIUl/g/3
=zT5S
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
