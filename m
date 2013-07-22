Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab3GVVEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:04:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48347 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3GVVEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:04:11 -0400
Date: Tue, 23 Jul 2013 00:04:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Illia Smyrnov <x0194613@ti.com>
CC: <balbi@ti.com>, Illia Smyrnov <illia.smyrnov@globallogic.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 2/2] Input: omap-keypad: Cleanup - remove unnecessary IRQ
 enabling/disabling
Message-ID: <20130722210406.GE12726@radagast>
Reply-To: <balbi@ti.com>
References: <1374239027-3927-1-git-send-email-illia.smyrnov@globallogic.com>
 <1374239027-3927-3-git-send-email-illia.smyrnov@globallogic.com>
 <20130719132648.GB17188@arwen.pp.htv.fi>
 <51ED6AF1.9070605@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OZkY3AIuv2LYvjdk"
Content-Disposition: inline
In-Reply-To: <51ED6AF1.9070605@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OZkY3AIuv2LYvjdk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 22, 2013 at 08:25:05PM +0300, Illia Smyrnov wrote:
> >please don't remove this code. It'll be good to have this around when we
> >move the driver to threaded IRQs without IRQF_ONESHOT. In fact, it would
> >be very simple to implement such a change, wanna take it up ?
> >
> >It should be doable in few patches:
> >
> >1) switch over to request_threaded_irq()
> >
> >	just blind move to a thread, without hardirq handler, so
> >	IRQF_ONESHOT is mandatory.
> >
> >2) add hardirq handler
> >
> >	read IRQSTATUS to check if our device has generated IRQs
> >	returning IRQ_WAKE_THREAD if true
> >
> >3) move 'IRQ masking logic' to hardirq handler, before returning
> >IRQ_WAKE_THREAD
> >
> >	this will let you remove IRQF_ONESHOT
> >
> >4) finally remove IRQF_ONESHOT
> >
> >	this makes sure that IRQs aren't kept disabled until we have
> >	time to iterate over the entire keypad matrix. Only the keypad
> >	IRQ will be masked.
> >
>=20
> Ok, but why we need to remove IRQF_ONESHOT flag for omap keypad driver?

well, we might want to use this HW with the RT patchset. In that case,
we want to run with IRQs disabled for as short time as possible.

> The keypad IRQ isn't shared IRQ and in our case hardirq handler will
> always return IRQ_WAKE_THREAD like default

not entirely true, you still want to check if *this* HW generated to
interrupt in case you get spurious IRQs and whatnot.

> irq_default_primary_handler do. With IRQF_ONESHOT flag IRQ line will
> be masked until the threaded
> handler finished, but there is only keypad on this line.
>=20
> I tested two versions:
> the first one - just threaded IRQs with IRQF_ONESHOT and without
> specific hardirq handler.
> the second version - threaded IRQs without IRQF_ONESHOT as you described.
> Both versions was successfully tested on Blaze's keypad.

you can't simply remove IRQF_ONESHOT, you need to mask this interrupt at
the keypad level, basically you clear IRQ_ENABLE_SET (or write to
IRQ_CLEAR or whatever it's called).

Remember that the hardirq handler runs with IRQs disabled and what you
need to guarantee is that once you go over your hardirq, you mask
keypad's IRQs only.

Currently, the RT patchset forces all IRQs to run as threads, but that's
less than optimal.

--=20
balbi

--OZkY3AIuv2LYvjdk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR7Z5GAAoJEIaOsuA1yqREMmEP/1517gypoT3As/2C/jqplUvi
WoGkBSb1cDklyeRRsHU+Yz3simlDDC2dcFQcLJ+YXJjxCItaPEUbdseY3TdySpax
EXR773Dw+1gQrZklvjloPYDO4YbLAfchDAck6kt8fDnGXhQSMzwoZ/vBqHHTjyOC
mL8FFY1U203ZwoSSMThjL76DRTAWm/FoQb7ApBI7H0Z9aUoyTi1AOaQxfEpIwXe3
rF9liO8DavMh/SlHMibmi3OTwwduyazoqpeLvhhkb6l/QX72No5qH6Sn0i20AG1M
WMf0cY6S+cpr2sWq+I8H4ZW4FA9J3n3R1c95RCBWJCuL6lwjyebnWuG9ZA8zmOE9
RsXC5F58ejkcKyGx8Iy7QD4I/mMSWiEZCxftjxs2xVZShCdjZPcoy8IAKCOunQCC
tLSMtQKIlt3eFdRvqFZKNhMyf5DlKiP9ANQhlDU/9C/QuoKa2eR9WVR+cHkyhvF5
uiLt/zfeDC5CnEO9rdCdGpe2beoxBxvzd253ni/7YB5keA+IjSJsd3SZ3Zz+0V4t
1NN7hOUVYXi04nmF0fQH3W6pxbUnCdAyWTIciGwVQ24Awoulm0mkP58/1uBp2zUe
2Ggb8kf/9rit1D0Nvc0Jd+3a68XjTRIh9CYBFjJNkCgt9ijkhUVBqCwkObbCxPZc
uJ5fdHIEn4iFdauZyZNM
=1WOy
-----END PGP SIGNATURE-----

--OZkY3AIuv2LYvjdk--
