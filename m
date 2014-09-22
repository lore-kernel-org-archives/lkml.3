Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbaIVJ7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 05:59:17 -0400
Received: from sauhun.de ([89.238.76.85]:48640 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaIVJ7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 05:59:16 -0400
Date: Mon, 22 Sep 2014 11:59:39 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Anders Berg <anders.berg@avagotech.com>
Cc: devicetree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: axxia: Add I2C driver for AXM55xx
Message-ID: <20140922095939.GB1406@katana>
References: <1408967482-17723-1-git-send-email-anders.berg@avagotech.com>
 <20140920121242.GA3833@katana>
 <CAE0=X_0VQ8rWrUgbsgKm1MwCP8bwWm3UJPq9p=xNDfjP4CC7Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <CAE0=X_0VQ8rWrUgbsgKm1MwCP8bwWm3UJPq9p=xNDfjP4CC7Bg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >> +             if (idev->msg_xfrd =3D=3D 0 && i2c_m_recv_len(msg)) {
> >> +                     /*
> >> +                      * Check length byte for SMBus block read
> >> +                      */
> >> +                     if (c <=3D 0) {
> >> +                             idev->msg_err =3D -EPROTO;
> >> +                             i2c_int_disable(idev, ~0);
> >> +                             complete(&idev->msg_complete);
> >> +                             break;
> >> +                     } else if (c > I2C_SMBUS_BLOCK_MAX) {
> >> +                             c =3D I2C_SMBUS_BLOCK_MAX;
> >
> > What about returning -EPROTO here as well? I don't think that reading
> > just a slice of all the data is helpful.
> >
>=20
> Right, that is probably true. This came from the device I was using to
> test the block-read operation. This device violated the
> I2C_SMBUS_BLOCK_MAX limit, so I added this truncation to at least get
> something out...

Which device was it? I know there are some doing that, yet I like to
know which ones.

> >> +{
> >> +     struct axxia_i2c_dev *idev =3D _dev;
> >> +     u32 status;
> >> +
> >> +     if (!idev->msg)
> >> +             return IRQ_NONE;
> >
> > This is actually not true. There might be interrupt bits set, so there
> > is an IRQ. There shouldn't be one, right, but that's another case IMO.
> >
>=20
> You could see it as: there is no interrupt that this handler is
> interested in serving. I'd like to keep this test as there is some
> legacy software that could be run on platforms with this driver that
> access the I2C controller directly. If this happens, this test assures
> that the user get an informative "unhandled irq" error message
> (instead of a null pointer dereference).

IRQ_NONE is "this interrupt wasn't by me" so for shared IRQs, the next
handler can check. You shouldn't remove the check per se. Still,  since
this interrupt was definately from the I2C core, you should return
IRQ_HANDLED and print an error message to the logs.

> >> +static int
> >> +axxia_i2c_xfer_msg(struct axxia_i2c_dev *idev, struct i2c_msg *msg)
> >> +{
> >> +     u32 int_mask =3D MST_STATUS_ERR | MST_STATUS_SNS;
> >> +     u32 rx_xfer, tx_xfer;
> >> +     u32 addr_1, addr_2;
> >> +     int ret;
> >> +
> >> +     if (msg->len =3D=3D 0 || msg->len > 255)
> >> +             return -EINVAL;
> >
> > Ouch, really? Maybe we should warn the user here.
>=20
> Yeah, the transfer length register limits the length to 255. I'll add
> a warning here.

Please also add this information to the Kconfig description and
somewhere at the top of the source file. This is an important flaw which
people should easily find out about.


--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUH/MKAAoJEBQN5MwUoCm2ymYP/1JbkMkXmmKIVrRuwQht2Q5T
6JoCLwzMGNOoip8e8PsgjQUeiHrI45QPL2o81SZIxikQkfQKDTtrkIc2gm1wywub
cKziXpQaPhQgXyoDIxml1v3m12Tyr5pczi55pge9U/WOtt5dAyU8RdAQj068m+Pq
DGNlv2lF2ZGB3Xx46hXC9QyUF/V033eXvt3pJTphDKCsalWf7c/Ew60xioU36bxp
dHLj43u9V+ITRE3ZkWWul5D9sWfn9kSt6/uWvM8FZQUQmC5YbDxcV7hHNosFBC9R
I2B0ejXakpjtZ8d68cj8yvcqniul/ee6kQlWBE/EaD9SHSU/a/r6AlUNAEfD9KY2
sPnbJU1qZSRXtDg0611jY++sVZ2fMUUIh2Malqp1vyCiVb4seW02rrDzUquMyRJr
i4LuvbMCdTd1fXCvuKGFVdiEyHJs5wdyKIo4bQffYD/rbzmPs4m55GnFQ8lMFOBE
cjHtgou8FEbzmS/IhLQ37+4uLdPnM4h2ScqLSLDmakz2IW6tq0gJdUJrU7X4nRaA
nEmTDOwxsniy15Op9oReYya1QsPxl8ynC82qu5fe2YC/noCVJ08oAXUPPAQXec6E
t6KTQVXz7X4mHDol7Al/gUSHNZc+6zN9vTZw9IHXN4gKtp6r65B9MxHYkU7nVaZF
kACawNtgt9TUEkLnUehO
=tNHL
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
