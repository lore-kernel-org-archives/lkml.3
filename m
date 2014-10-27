Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaJ0NOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:14:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42242 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbaJ0NON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:14:13 -0400
Message-ID: <544E44E9.4040208@ti.com>
Date: Mon, 27 Oct 2014 15:13:13 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jani Nikula <jani.nikula@intel.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linuxppc-dev@lists.ozlabs.org>, <platform-driver-x86@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
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
References: <1413580403-16225-1-git-send-email-jani.nikula@intel.com> <54476492.6090105@ti.com> <87a94hu3j0.fsf@intel.com>
In-Reply-To: <87a94hu3j0.fsf@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="IThmeWp4bmW702xcFe3J70JjLFnfi99Q7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IThmeWp4bmW702xcFe3J70JjLFnfi99Q7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 27/10/14 13:59, Jani Nikula wrote:

>> While doing 'depends on' instead of 'select' is an "easy" fix for this=
,
>> I do dislike it quite a bit. It's a major pain to go around the kernel=

>> config, trying to find all the dependencies that a particular driver
>> wants. If I need fb-foobar, I should just be able to enable it, instea=
d
>> of first searching and selecting its minor dependencies individually.
>=20
> Agreed, but I don't think that's specific to this patch.

Well, no, the generic problem is not specific to this patch, but we can
avoid the issue with proper use of 'select' (at least in some cases),
which is specific to this patch.

>> So, not a NACK, but a "isn't there an another way to fix this?".
>=20
> I think the real answer would be to fix kconfig to also show menu items=

> whose dependencies are not met, and then recursively enabling the
> dependencies when the item is enabled. Beyond my scope.
>=20
>> Looking at backlight... BACKLIGHT_LCD_SUPPORT seems to be a "meta"
>> option, it only enables a Kconfig submenu.
>>
>> So I think we could just remove the whole BACKLIGHT_LCD_SUPPORT option=
=2E
>> But if we do that, all the items in drivers/video/backlight/Kconfig wi=
th
>> default 'y' or 'm' would get enabled by default, so I think we should
>> remove the 'default's from that file. That makes sense in any case, as=
 I
>> don't see why "HP Jornada 700 series LCD Driver" should be "default y"=
=2E
>>
>> BACKLIGHT_CLASS_DEVICE doesn't depend on anything except
>> BACKLIGHT_LCD_SUPPORT, so after removing BACKLIGHT_LCD_SUPPORT it shou=
ld
>> be safe to 'select' BACKLIGHT_CLASS_DEVICE.
>>
>> BACKLIGHT_CLASS_DEVICE could be made a hidden option, and the drivers =
in
>> drivers/video/backlight/Kconfig which are under BACKLIGHT_CLASS_DEVICE=

>> could be made to select BACKLIGHT_CLASS_DEVICE instead.
>=20
> I think it should be possible to choose between y and m when it's

If I'm not mistaken, if CONFIG_FOO is 'm', and it 'select's CONFIG_BAR,
and CONFIG_BAR is tristate, then CONFIG_BAR will be set to 'm'.

> selected, and it should be possible to enable it when it's not selected=

> by any drivers. I'm not sure a hidden option is good for that.

Why would you want to enable it if no one uses it? Does
BACKLIGHT_CLASS_DEVICE enable something even if no driver uses it?

>> That doesn't exactly fix anything, but I think it makes sense as
>> BACKLIGHT_CLASS_DEVICE is something that's selected from all around th=
e
>> kernel, so it should be a selectable "library" instead of a Kconfig me=
nu
>> option.
>=20
> At least for drm/i915 BACKLIGHT_CLASS_DEVICE is "an option". We use it
> if it's enabled, but we are just fine if it's not. I've learned the way=

> to express that is
>=20
> 	depends on BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=3Dn
>=20
> but I don't think there's a way to express that in terms of select, is
> there? The dependency above guarantees there's no DRM_I915=3Dy and
> BACKLIGHT_CLASS_DEVICE=3Dm combo which would fail. And this, btw, is wh=
ere
> this whole patch got started, as select didn't handle that properly.

If backlight support is considered an option for drm/i915, then I think
there should be a Kconfig option for i915 to enable backlight support,
which in turn selects BACKLIGHT_CLASS_DEVICE. And that select will force
BACKLIGHT_CLASS_DEVICE to be built-in if drm/i915 is built-in.

Oh, but it doesn't work optimally with modules. The new option needed
for that would be boolean, so BACKLIGHT_CLASS_DEVICE would always be
either y or n. Sigh...

>> I didn't look at the ACPI_VIDEO side, so no idea how messy that is.
>=20
> Basically it's another dependency on BACKLIGHT_CLASS_DEVICE. I can only=

> imagine trying to solve this problem with select is going to end up in
> recursive dependencies that spread out and need changing about as wide
> as this patch.

If ACPI_VIDEO uses select to enable BACKLIGHT_CLASS_DEVICE, then, I
think, selecting ACPI_VIDEO will also select BACKLIGHT_CLASS_DEVICE. So
I don't right away see any recursive dependencies. Or what did you have
in mind?

> In the end, I agree with the problem you have with this patch, but yet =
I
> think it's the right thing to do in terms of expressing the
> dependencies.

Well, dri/i915 doesn't exactly depend on backlight, if I understood you
correctly. Instead, backlight is an option for dri/i915, and you kind of
hack it to be implemented with that 'depends on BACKLIGHT_CLASS_DEVICE
|| BACKLIGHT_CLASS_DEVICE=3Dn'.

I guess it's debatable whether drivers should automatically use features
in the kernel if they happen to be enabled in the Kconfig, or should
they be individually enabled for that driver. I personally like the
latter option, as it allows more precise control, but it probably also
depends on the feature in question.

I also think the 'depends on BACKLIGHT_CLASS_DEVICE ||
BACKLIGHT_CLASS_DEVICE=3Dn' pattern is quite... interesting (i.e. sounds
like a hack to me =3D).

 Tomi



--IThmeWp4bmW702xcFe3J70JjLFnfi99Q7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTkTpAAoJEPo9qoy8lh71U98P/0ToqL27YX+eqcL/5N0AoPLI
a6RzpXaYXyOhR+qs+SuJN9pbdtq5UIoyfCiH622788KHWde6ySZ6WUSFE5VD4V6D
DTugUTu4P6Ro4ousv2snQy2OFB3nlqOFzN5ew0comtuizWnyeuzUSDhntEzRHZT7
r3ziGIKdf6rdid6JkeUpDC5U5vhXhFTMGmLoHU3geHgwTLeP2D1CQze/V7Y+M3zp
zIQfHP1BpOvaA8HZSvNqXbQyA6MQyOfE2pc16ZK5oMpwc3K49mBjQLiuEMwnCIpu
5qOXqh5rkfmY13jKQz9FMVo7VY3lJ9oG5+N9H4V3UPQYaHPBzgM+tNqLRUVL9e0T
SxspA36SpwHYTeV1sV9fzyugVpdssc/u2175Qxm3mNMu4YKW8G5sXWslPbY6LjRN
qijQ+A9UsR9041Bkn1u73EF8KGBEtf5MmS+lUYfceGRJ59zb5C/QmPokw9y8WjEs
omyHKlK/io5nLYWJZdOx+fgy5lZCzRobQ0Q1swICX8jDwBhZOPUBb6R4K/ibnTXl
1eipk3BkJtuFiNjhkTetlLJ3s/cboxuMuy34oCylxh/6676IYUVXDANsw5eOsyuK
erDeNiqQ4DDy/TQhtitLRjJpM7PBorxILcEGg7N8EAKmQiDwE+VYFmeRkd7jUHSr
LMPXbmpPV4jf9SgNhf4E
=iLH8
-----END PGP SIGNATURE-----

--IThmeWp4bmW702xcFe3J70JjLFnfi99Q7--
