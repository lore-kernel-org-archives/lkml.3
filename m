Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963AbaKXUio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:38:44 -0500
Received: from sauhun.de ([89.238.76.85]:54288 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaKXUin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:38:43 -0500
Date: Mon, 24 Nov 2014 21:40:01 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] i2c: slave-eeprom: add eeprom simulator driver
Message-ID: <20141124204001.GB26751@katana>
References: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
 <1416326695-13083-3-git-send-email-wsa@the-dreams.de>
 <20141121071941.GK27002@pengutronix.de>
 <20141122182630.GD9698@katana>
 <20141123202008.GE4431@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <20141123202008.GE4431@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > > When the eeprom driver is probed and the adapter driver notices a read
> > > request for the respective i2c address, this callback is called with
> > > event=3DI2C_SLAVE_REQ_READ_START. Returning 0 here and provide the fi=
rst
> > > byte to send make the adapter ack the read request and send the data
> > > provided. If something !=3D 0 is returned a NAK is sent?
> >=20
> > We only send NAK on write requests (I use read/write from the master
> I don't understand this. Who is "we" in this case?=20

We as the slave serving the request of a remote master.

> > No single call. I had this first, but my experiments showed that it is
> > important for the EEPROM driver to only increase the internal pointer
> > when the byte was ACKed. Otherwise, I was off-by-one.
> Sure, the driver has to know how his read response was received by the
> master. But assuming I understand your abstraction right there is some
> redundancy. There are only three cases on a read request (well plus error
> handling):
>=20
>  - master sends ACK, reads next byte
>    in this case the slave must provide another word
>    In your abstraction this implies
>      callback(I2C_SLAVE_REQ_READ_END); <-- this is redundant

Well, in the way that a new start of something means automatically the
end of the previous something, like some closing html tags which can be
left out. However, I think being explicit here isn't much of a drawback.
You lose a little bit of performance and gain flexibility. A sensor-like
device could decide that on READ_END it is safe to discard the old value
and start acquiring the new one, so it will be available on next
READ_START. Be aware that the master decides how much time there will be
between END and START (although it will be very close in most cases).

>      callback(I2C_SLAVE_REQ_READ_START);
>=20
>  - master sends ACK, then P or Sr
>      callback(I2C_SLAVE_REQ_READ_END);
>      maybe callback(I2C_SLAVE_STOP)
>=20
>  - master sends NACK
>    in this case the message ends and the master has to send Sr or P.
>    In your case this results in:
>      nothing for the NACK?
>      maybe callback(I2C_SLAVE_STOP)
>=20
> The situations where the slave has to react are:
>=20
>  - slave was addressed with R
>    input: address
>    output: NAK or (ACK + data byte)
>  - slave was addressed with #W:
>    input: address
>    output: NAK or ACK

On most slave IP cores I have seen so far, there is nothing to do for a
slave driver for those two. Address recognition and sending ACK are all
done by the hardware and you are notified of that by an interrupt. For
the read case, you have to deliver the first byte, of course.


>  - data sent by slave-transmitter was acked
>    output: next data byte (maybe unused because master sends Sr or P)

The driver I modified in the next patch cannot know if the master
acked/nacked something. It just knows if the output buffer is empty or
if a stop was signalled (which really should come after NAK from the
master). So, we can't depend on this difference.

>  - data sent by slave-transmitter was nacked
>    output: void (unless we want to support IGNORE_NAK :-)

:)

>  - slave received a data byte (write)
>    input: data
>    output: NAK or ACK
>=20
> This looks like a better model in my eyes. In this model the slave
> driver doesn't even need to be informed about P. Not entirely sure about
> "data sent by slave-transmitter was nacked".

I think we definately need a STOP notification. Devices might want to do
something like reducing power etc after stop.

What I like about my version is that it reflects pretty closely what
happens on the bus. I can't currently tell what somebody could do with
WRITE_START (precharging something?). But it feels better to me to
directly reflect what a real slave device would see, too, for
flexibility.

>=20
> > For DMA, I haven't seen DMA slave support yet. Makes sense to me, we
> haha, there is only a single slave driver yet and you're the author.

I meant IP cores here which support DMA for slave transmissions.

Regardings buffers: I wouldn't like all bus drivers to have code
handling the buffer when all they have to do is to put one byte on the
bus. So, buffer handling should go into the core then probably. So,
there'd be still one level of indirection?

Also, since we don't know when the master will collect the data, there
is a chance it might get stale?

To me that sounds like too much complexity for too litle gain. At this
moment, at least.

Regards,

   Wolfram

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUc5ehAAoJEBQN5MwUoCm2HCUP/jO3XmHXLnMZhSe5AwYp+pAM
S6km7UmFvCeM77iUg4ESExJ9eHYKqgNk6gW4lL0fmFVO8IRQ+UuOxpVumWpo2DeR
epWS/+CI4kqozcjgEzh498fH+RGKZ4f7T/Ps4PUE/cNxXkv9iua+FbP0HpqpucFf
OZlAYB2iYecTs42XAXFWi7cU0BWE66ofKFxNtzcqVaZK1Kufq2Sr1eoMqsX2txE5
dStLUMZLpiKBQDzEFw762ZfpWltY0XYidUu4uGKuY8U95kcWTRH3OxWU7xhUX02l
L1tkhDN2/jip8nT/j5lYuvOBSmddK+vyBkcmfCJv2nA+wZPIy38/NQpYhnMZYDoO
Rla4dmwf3X2cXSdLqsgC+QrAwekdOLjVOwk9eO8cm2HUTRX+gt8po2ANn6XA4Ki1
XbmSo4RvvtfR27IJXdVZNja3Nw37tZpvoUTVy0mYEoFXZtgtaU+vDTEZjqHa03+M
F9mla2fToE9IBDgJ7Rm/IjyDg/+8rhn0o4jdFKU7iRQfSr1FvDzY6wE+I6DyllW2
RBKCsmXOrC5514Yh385dqIN6ibevNQO+hPo260AyhkVJ1guID5Yov4XEYNicGfk2
QArWe6NUl3ynnu+rg5bWp/qXRmMJqj7fJP2U04Z6TG6KOfAAaczep964ld4kAeBA
0257R3z48Y0FvHrKDA/u
=yTTI
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
