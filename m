Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbaJ2Jnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:43:51 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53988 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbaJ2Jnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:43:46 -0400
Date: Wed, 29 Oct 2014 10:43:40 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH RESEND V4 5/9] of: Add NVIDIA Tegra xHCI controller
 binding
Message-ID: <20141029094338.GA28356@ulmo.nvidia.com>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
 <1414535277-15645-6-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <1414535277-15645-6-git-send-email-abrestic@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 03:27:50PM -0700, Andrew Bresticker wrote:
[...]
> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xu=
sb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-x=
usb-padctl.txt
[...]
> +Optional properties:
> +-------------------
> +- vbus-{0,1,2}-supply: VBUS regulator for the corresponding UTMI pad.
> +- vddio-hsic-supply: VDDIO regulator for the HSIC pads.
> +- nvidia,usb3-port-{0,1}-lane: PCIe/SATA lane to which the corresponding=
 USB3
> +  port is mapped.  See <dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for th=
e list
> +  of valid values.

I dislike how we now need to provide a list of all pins in the header
file, where previously we used strings for this. This could become very
ugly if the set of pins changes in future generations of this IP block.

Could we instead derive this from the pinmux nodes? For example you have
this in the example below:

	usb3p0 {
		nvidia,lanes =3D "pcie-0";
		...
	};

Perhaps what we need is to either key off the node name or add another
property, such as:

	nvidia,usb3-port =3D <0>;

This would match the nvidia,usb2-port property that you've added below.

>  Lane muxing:
>  ------------
> @@ -50,6 +62,17 @@ Optional properties:
>    pin or group should be assigned to. Valid values for function names are
>    listed below.
>  - nvidia,iddq: Enables IDDQ mode of the lane. (0: no, 1: yes)
> +- nvidia,usb2-port-num: USB2 port (0, 1, or 2) to which the lane is mapp=
ed.

I'd leave away the -num suffix since it is implied that it's a number.

> +- nvidia,hsic-strobe-trim: HSIC strobe trimmer value.
> +- nvidia,hsic-rx-strobe-trim: HSIC RX strobe trimmer value.
> +- nvidia,hsic-rx-data-trim: HSIC RX data trimmer value.
> +- nvidia,hsic-tx-rtune-n: HSIC TX RTUNEN value.
> +- nvidia,hsic-tx-rtune-p: HSIC TX RTUNEP value.
> +- nvidia,hsic-tx-slew-n: HSIC TX SLEWN value.
> +- nvidia,hsic-tx-slew-p: HSIC TX SLEWP value.

It would be useful for these to provide a range of valid values. I also
see that there are other registers that contain values for tuning. I
take it that the ones you've included here are the only ones that need
to be overridden on hardware you've tested this on? That should be fine,
we can always add new ones if necessary.

> +- nvidia,hsic-auto-term: Enables HSIC AUTO_TERM. (0: no, 1: yes)
> +- nvidia,otg-hs-curr-level-offset: Offset to be applied to the pad's fus=
ed
> +  HS_CURR_LEVEL value.
> =20
>  Note that not all of these properties are valid for all lanes. Lanes can=
 be
>  divided into three groups:
> @@ -58,18 +81,21 @@ divided into three groups:
> =20
>      Valid functions for this group are: "snps", "xusb", "uart", "rsvd".
> =20
> -    The nvidia,iddq property does not apply to this group.
> +    The nvidia,otg-hs-curr-level-offset property only applies.

The wording is confusing here in my opinion. Maybe better: "Only the ...
property applies."?

>    - ulpi-0, hsic-0, hsic-1:
> =20
>      Valid functions for this group are: "snps", "xusb".
> =20
> -    The nvidia,iddq property does not apply to this group.
> +    The nvidia,hsic-* properties apply only to the pins hsic-{0,1} when
> +    the function is xusb.

I assume that hsic-* properties also only apply to the hsic-* pins?
That's not clear from the above sentence.

Thierry

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUULbKAAoJEN0jrNd/PrOh3n4QAKhd76oJnVJUt4H0zD0Dmf5T
WLLg/4LXsTsJZ5TJ1TSq7hniC/Zg7rA8gjEvFiT1K21sxJpOD9GYemFCG/MxkBgY
5kviYsft0Cvg/5cKP5TMEu+ptRfeykd8pmUBzFTz5eqgI/E02CWRgAvFKhjDoVF/
nutz4k/48ibBT4wbNjZXdKduBp8JXzcdXVetpMTpZuOKKMtTMl+kCuQh0mR+UY8R
N+57esfoLWDZAepvD2DWX5FZhwexY4YeoTgDNG8Drxm3JltpbC3xtfFHcaZlGgA+
vzWYU2HrlGaXO8XFLOmON2qIQ9dMtdiJgOSIHKr2MTp+7VSxZeT6v67i142a/+5l
eb2dl/VuDrSs85mQNfEx/oFOt18xcJibmnfGMoy4O8bT8R6NH6FuxmyTj3zHR46X
L8Jbi0s2Ts+1ByDzID3XnpV6KSWZZ8Fs3Q2XB0dZzlF7qrzYCwvbcxQFYLGTipuK
CMHwJogIPTmXBVTAzQysZiXLxrwrv1IMHW3gnnLP4iYv0YBZIgxNzml27fYQ3e8H
Nq1maVwwP/BrkwqFMm+sAE1UWjiTrok8TmQesPGZkYAb9qEHSAe5F3os8Iklcjzr
ndBmPDdUyqfys+ny0T1TqGyswD0juosHYUID1mt+B2RRQDtjqzXjbhI4+j8HoU+N
mpuSPJ8jVbvRkYlET69M
=jthM
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
