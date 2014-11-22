Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaKVSZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 13:25:08 -0500
Received: from sauhun.de ([89.238.76.85]:34642 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaKVSZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 13:25:06 -0500
Date: Sat, 22 Nov 2014 19:26:30 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] i2c: slave-eeprom: add eeprom simulator driver
Message-ID: <20141122182630.GD9698@katana>
References: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
 <1416326695-13083-3-git-send-email-wsa@the-dreams.de>
 <20141121071941.GK27002@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Content-Disposition: inline
In-Reply-To: <20141121071941.GK27002@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EY/WZ/HvNxOox07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> this mail is thematically more a reply to patch 1 and maybe just serves
> my understanding of the slave support.

Sure. This shows how badly needed the documentation is :)

...
> > +		break;
> > +
> > +	case I2C_SLAVE_STOP:
> > +		eeprom->first_write = true;
> > +		break;
> > +
> > +	default:
> > +		break;
> > +	}
> > +
> > +	return 0;
> > +}
> This is the most interesting function here because it uses the new
> interface, the functions below are only to update and show the simulated
> eeprom contents and driver boilerplate, right?

Yes.

> When the eeprom driver is probed and the adapter driver notices a read
> request for the respective i2c address, this callback is called with
> event=I2C_SLAVE_REQ_READ_START. Returning 0 here and provide the first
> byte to send make the adapter ack the read request and send the data
> provided. If something != 0 is returned a NAK is sent?

We only send NAK on write requests (I use read/write from the master
perspective). Then, we have to say if the received byte was successfully
processed. When reading, the master has to ack the successful reception
of the byte.

> How is the next byte requested from the slave driver? I assume with two
> additional calls to the callback, first with
> event=I2C_SLAVE_REQ_READ_END, then event=I2C_SLAVE_REQ_READ_START once
> more. Would it make sense to reduce this to a single call? Does the
> driver at READ_END time already know if its write got acked? If so, how?

No single call. I had this first, but my experiments showed that it is
important for the EEPROM driver to only increase the internal pointer
when the byte was ACKed. Otherwise, I was off-by-one.

Ideally, I2C_SLAVE_REQ_READ_END should be used when the master ACKed the
byte, right. However, the rcar hardware doesn't have an interrupt for
this, so I imply that the start of a new read request ends the old one.
I probably should add a comment for that.

> This means that for each byte the callback is called. Would it make
> sense to make the API more flexible and allow the slave driver to return
> a buffer? This would remove some callback overhead and might allow to
> let the adapter driver make use of its DMA mechanism.

For DMA, I haven't seen DMA slave support yet. Makes sense to me, we
wouldn't know the transfer size, since the master can send a stop
anytime. This makes possible gains of using a buffer also speculative.
Also, I2C is still a low-bandwith bus, so usually we have a high number
of small transfers.

For now, I'd skip this idea. As I said in another thread, we need more
use cases. If the need arises, we can come up with something. I don't
think the current design prevents such an addition?

Thanks,

   Wolfram


--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcNVWAAoJEBQN5MwUoCm2SUAP+gPntDQlwAds3olYBN4OBeIX
2kaIGzxE4u2iP7IRsmW4vODAicXHBVTop7Br5UkHczz8554pdQOEnMw9aGDffOZX
08mdoDdsMfYlkeBRzWbqkpG02TAqXVgNzIxJeNTn2y0gsewzBgfkEEzyLuL30coS
zRJBWgGjgS1hX7EPcOwmljW7ap5zn2ex3MCsZrZqi2CcRCFtD7pNowoeaT36i4xL
OjAImOVsERD0RipwhvDEljZXxNq7J1SxfszuCQ2OJGrkjydg4Awk/Iv3ZCwXZ0yV
wzSRKQGa/c/zkxg/oOH+lIoUQFFhorWLJioEsiOhaZOaRNFu84JWqiXXSabJDpU5
CoGD8v+a2FGF9IIsu4adlicwi+Ym6LYhpz+F5Nmr9YXY5egzYXFjEf+NJfgh01rY
zD5+14d9JdmZj4OuH/s0FxZuGpW6VutCybtNoMwwiA21ewYByBfi/jxwL0PX9o4W
SvLbNfsMDG8+uayCT9dZzwDPaowFSHbJM5zye9zawKWzmZSEDAWZrgNnDQpJz5fW
aeNE4xX9MElhAf0ABLRIyld6Zr3zP2W3WjhEIWXJP3hL4ge1gg+vWPjUA3Q+66BV
QFlQs5CN3huaJTyXVV50s7u6iGtZuO6YThmNGp985f56tRZt4zvt/3alUvRo8lCf
UBcf3sr3scn6KvbdAUNj
=axt6
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--
