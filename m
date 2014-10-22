Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbaJVIDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:03:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48018 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932383AbaJVIDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:03:21 -0400
Message-ID: <54476492.6090105@ti.com>
Date: Wed, 22 Oct 2014 11:02:26 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@intel.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linuxppc-dev@lists.ozlabs.org>,
        <platform-driver-x86@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
CC: Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jens Frederich <jfrederich@gmail.com>, Daniel Drake <dsd@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] drivers: depend on instead of select BACKLIGHT_CLASS_DEVICE
 and ACPI_VIDEO
References: <1413580403-16225-1-git-send-email-jani.nikula@intel.com>
In-Reply-To: <1413580403-16225-1-git-send-email-jani.nikula@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="21TxCm1o2DuMu5ascVJ3KWtW1Jv7nNj4S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--21TxCm1o2DuMu5ascVJ3KWtW1Jv7nNj4S
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 18/10/14 00:13, Jani Nikula wrote:
> Documentation/kbuild/kconfig-language.txt warns to use select with care=
,
> and in general use select only for non-visible symbols and for symbols
> with no dependencies, because select will force a symbol to a value
> without visiting the dependencies.
>=20
> Select has become particularly problematic, interdependently, with the
> BACKLIGHT_CLASS_DEVICE and ACPI_VIDEO configs. For example:
>=20
> scripts/kconfig/conf --randconfig Kconfig
> KCONFIG_SEED=3D0x48312B00
> warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 &&
> DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLA=
Y
> && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI &&
> EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVIC=
E
> which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT=
)
> warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 &&
> DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLA=
Y
> && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI &&
> EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVIC=
E
> which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT=
)
>=20
> With tristates it's possible to end up selecting FOO=3Dy depending on
> BAR=3Dm in the config, which gets discovered at build time, not config
> time, like reported in the thread referenced below.
>=20
> Do the following to fix the dependencies:
>=20
> * Depend on instead of select BACKLIGHT_CLASS_DEVICE everywhere. Drop
>   select BACKLIGHT_LCD_SUPPORT in such cases, as it's a dependency of
>   BACKLIGHT_CLASS_DEVICE.
>=20
> * Remove config FB_BACKLIGHT altogether, and replace it with a
>   dependency on BACKLIGHT_CLASS_DEVICE. All configs selecting
>   FB_BACKLIGHT select or depend on FB anyway, so we can simplify.
>=20
> * Depend on (ACPI && ACPI_VIDEO) || ACPI=3Dn in several places instead =
of
>   selecting ACPI_VIDEO and a number of its dependencies if ACPI is
>   enabled. This is tied to backlight, as ACPI_VIDEO depends on
>   BACKLIGHT_CLASS_DEVICE.
>=20
> * Replace a couple of select INPUT/VT with depends as it seemed to be
>   necessary.

While doing 'depends on' instead of 'select' is an "easy" fix for this,
I do dislike it quite a bit. It's a major pain to go around the kernel
config, trying to find all the dependencies that a particular driver
wants. If I need fb-foobar, I should just be able to enable it, instead
of first searching and selecting its minor dependencies individually.

So, not a NACK, but a "isn't there an another way to fix this?".

Looking at backlight... BACKLIGHT_LCD_SUPPORT seems to be a "meta"
option, it only enables a Kconfig submenu.

So I think we could just remove the whole BACKLIGHT_LCD_SUPPORT option.
But if we do that, all the items in drivers/video/backlight/Kconfig with
default 'y' or 'm' would get enabled by default, so I think we should
remove the 'default's from that file. That makes sense in any case, as I
don't see why "HP Jornada 700 series LCD Driver" should be "default y".

BACKLIGHT_CLASS_DEVICE doesn't depend on anything except
BACKLIGHT_LCD_SUPPORT, so after removing BACKLIGHT_LCD_SUPPORT it should
be safe to 'select' BACKLIGHT_CLASS_DEVICE.

BACKLIGHT_CLASS_DEVICE could be made a hidden option, and the drivers in
drivers/video/backlight/Kconfig which are under BACKLIGHT_CLASS_DEVICE
could be made to select BACKLIGHT_CLASS_DEVICE instead.

That doesn't exactly fix anything, but I think it makes sense as
BACKLIGHT_CLASS_DEVICE is something that's selected from all around the
kernel, so it should be a selectable "library" instead of a Kconfig menu
option.

I didn't look at the ACPI_VIDEO side, so no idea how messy that is.

 Tomi



--21TxCm1o2DuMu5ascVJ3KWtW1Jv7nNj4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUR2SSAAoJEPo9qoy8lh71U/cP/2aPWUb10WkX1VriTkyjZu7v
9yzPGs1KOYpMmOxeiWcgiqGCighxoxk1/AGzxWhf1z5Pd1+6LKelevyjekyAyNRF
bhIydVPvPJsC/gRoIGyZH5JJjb93ued1I75TD9Z46v6TzLBYm1sPk0dosleNrSCj
advJvHF+8x7mMsM68A1wkvbdV2rWhDhu11FBoMmncFwxWYtIbfiBxitkmmJ6IcEf
fasvyuxsAA+B6Qj7sqOftn3WZLsa/0HyPOj9meDsE5WHbs+4UuJaYo+mBXif7x2F
JmbQgRQWpU1eZsFLkhkw2AwCD7ppwHyW7oerHWeDYmIwHdLtY38J8fcV6rgg4R1O
V7Bwon0bTCsxtPpbPgdLU8zhz9Z7M62HfdFaF1icF1I8aeCOOyxY6d8unL3B3x0P
TD6pxQNkDP90pug9ptG61CLcjsdlolceoj0GoaJdXKAsX+/KM9H3HaSdCq4aDuax
/YzXSq1eLbC3ausIe6FJ5xGaljBFdPDhordjLm3gTjO3KU6Y9ftAXHPWiGhLb5YI
FbDF69WfAHymNzHL4uu3SBYnMSzpNw9kqOG5VWRuaSaFpdyW92fAuzCtHMn78PDZ
Iu6Qfif/mwJXpKF0iprf6bX0TJg8T6elv/EvbqmZsuTn73dXBdr7HqvckYb5bNFd
Eoj0RcSWzvnsrmH6rtr4
=ET8r
-----END PGP SIGNATURE-----

--21TxCm1o2DuMu5ascVJ3KWtW1Jv7nNj4S--
