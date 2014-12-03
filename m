Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaLCRtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:49:43 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56456 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaLCRtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:49:41 -0500
Date: Wed, 3 Dec 2014 11:49:38 -0600
From: Felipe Balbi <balbi@ti.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
CC: <balbi@ti.com>, Kevin Hilman <khilman@kernel.org>,
        Tony Lindgren <tony@atomide.com>, Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about patch "i2c: omap: resize fifos before each
 message"
Message-ID: <20141203174938.GJ16138@saruman>
Reply-To: <balbi@ti.com>
References: <A20987D6-DEEC-488D-9655-36A4D186599B@gmail.com>
 <20141203154936.GF16138@saruman>
 <8C51B585-BFD6-48CC-A2C4-EB88CB820426@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HmK7y6O+lKZIGkr"
Content-Disposition: inline
In-Reply-To: <8C51B585-BFD6-48CC-A2C4-EB88CB820426@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+HmK7y6O+lKZIGkr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Dec 03, 2014 at 08:34:21PM +0300, Alexander Kochetkov wrote:
> >> 2. I want to avoid changing fifos before message submission, because
> >> IP can start receiving message in a slave mode (race).
> >=20
> > I2C is not full-duplex. There's no way it will receive any data while
> > you're transmitting, right ?
> >=20
>=20
> I2C is half duplex, right. But, IP work in slave receiver and master
> transmitter modes.  And IP switch to slave receiver mode after master

it has more modes than that. It can also be a master receiver and a
slave transmitter. Note also that MST bit does *not* auto clear. This
means that as the driver is today, IP will always be in Master mode
which further strengthens my suspicion that what you describe can't
possibly happen.

> transfer (simply clear MST bit and ready for reception and that TRM
> state about).=20

this is wrong. Clear MST bit and IP switches to slave mode. Transmit or
receive is selected through another bit (TRX -> bit 9 on I2C_CON). Also,
the IP won't do anything (considering it's always in master mode) until
STT bit is set again, so there's really no way for what you describe
below to ever happen with current driver.

> And question sounds like: what happen if we reset or change FIFO
> threshold value (in order to submit new master transfer) when IP start
> receiving data to the fifo.  How many bytes we have to read on RRDY?

I don't see how this would ever happen.

> That race I'am talking about. And there is only one place where race
> couldn't happen: it's ISR (thread). So I want to move almost all
> master initialization code into ISR.

if you do that, you'll end up with an IRQ handler that takes a lot of
time to run, because at every IRQ you'll reprogram the thing, it's
better to program things from omap_i2c_xfer_msg() and wait for the IRQ
to happen. Just as it is today.

> >> 3. dev->threshold is changed in range 1-fifo_size/2. So instead of RDR
> >> we get RRDY and for messages larger then fifo_size/2 we still get RRDY
> >> and RDR.
> >=20
> > we will only get RDR if message_size % threshold > 0. If we have a 16
> > byte transfer and we program threshold to 8 bytes, we will get two RRDY
> > IRQs.
> >=20
> >> Felipe, do you have in mind why do you want to avoid RDR and XDR event=
s?
> >> Something about errata?
> >=20
> > nothing about errata. As the commit log say (or tried to say), if the
> > entire message fits into the FIFO we save one interrupt. It's a
> > micro-optimization.
>=20
> I see, thank you. But due to error only half of fifo is utilized for
> that.

right, it also tries to use double buffering, so that while IP is
shifting data onto SDA, we can feed the other half of the FIFO with more
data.

> And, I'll try to move fifo threshold init code into ISR. Don't see
> something wrong.

I wouldn't do that. It's just too late... look, IRQs won't fire until
I2C_CON is setup to start a transfer (transmit or receive), you *must*
resize FIFO before starting a transfer otherwise, well, you know...

--=20
balbi

--+HmK7y6O+lKZIGkr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUf00yAAoJEIaOsuA1yqREtsAQAJ29fYo87KTDK2mbrtFOjuaE
sj9sfz3TQxSbKwnrQ9TOrVJP42Mw7JIUpNC9KKD8a8rddFDRfLlDpmm09rjzkus1
HU034z1gs19SwzSs1kzzVQ1e8kFN5H/8u0CoX6DdcahTvquxb1/AHEk61Tj/3fZH
3QxPsWwy7cs9fAx1flR1Kp0LHsMykQNfEbcGGOTBjWQk1XHxrnFnnxVWy7kVY4WW
VWE2bcGAxty2OYoOeQm/bsvAIBxFOINpAFcJOZGR4BHn+Y5jWlBYrTQ5LNsJusnl
r/QhlyccWuz6nxFhAW+9ygUm+3Lb2344/1/h5VBykhPohQGHAAvezI5tMD6kEPBS
hThauv4KWuzwIJG/9IPzDvLUtPe3GnQsvW/qDlTNDkDVTlm7Lm9o0Ls0SJJQdGXf
Luv4HKeiXKFxU8Y1AbqXlv6/SuEkG4O5LumiECNO28SaLax9vL7iZ7aAh3n6Ml9g
bmP7xrfSqfRGUCdHDd5CMf4Zd0xG1yN+oJnnVbSzNwTKlgHo6NX7s6cOgu7EeqL+
vupP0nngYbBW8T0ejDQEvo81TotzpwXcgntCzQ82FT+nGdHSF201FGPOlTC8vg5D
J5FT8+1gG11sYSHvZcZH4WdjrSEszfOqiXbA995sLNuY58WZMaAWEtyRjedk+Ffp
92S/tn+Ol71QPtR99tT2
=Cvaa
-----END PGP SIGNATURE-----

--+HmK7y6O+lKZIGkr--
