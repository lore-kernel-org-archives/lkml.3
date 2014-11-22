Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaKVSLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 13:11:15 -0500
Received: from sauhun.de ([89.238.76.85]:34537 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaKVSLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 13:11:14 -0500
Date: Sat, 22 Nov 2014 19:12:29 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Stijn Devriendt <highguy@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 2/3] i2c: slave-eeprom: add eeprom simulator driver
Message-ID: <20141122181229.GB9698@katana>
References: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
 <1416326695-13083-3-git-send-email-wsa@the-dreams.de>
 <CAOY=C6FSXWn2AKn9gp0oU69U8VkkyJAE7MMUTZsToy0P_Tf6AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <CAOY=C6FSXWn2AKn9gp0oU69U8VkkyJAE7MMUTZsToy0P_Tf6AA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Please quote only relevant parts of the message (like I did). This
improves readability a lot.

> > +static int i2c_slave_eeprom_slave_cb(struct i2c_client *client,
> > +                                    enum i2c_slave_event event, u8 *va=
l)
> > +{
> > +       struct eeprom_data *eeprom =3D i2c_get_clientdata(client);
> > +
> > +       switch (event) {
> > +       case I2C_SLAVE_REQ_WRITE_END:
> > +               if (eeprom->first_write) {
> > +                       eeprom->buffer_idx =3D *val;
> > +                       eeprom->first_write =3D false;
> > +               } else {
> > +                       spin_lock(&eeprom->buffer_lock);
> > +                       eeprom->buffer[eeprom->buffer_idx++] =3D *val;
> > +                       spin_unlock(&eeprom->buffer_lock);
> > +               }
> > +               break;
> > +
> > +       case I2C_SLAVE_REQ_READ_START:
> > +               spin_lock(&eeprom->buffer_lock);
> > +               *val =3D eeprom->buffer[eeprom->buffer_idx];
> > +               spin_unlock(&eeprom->buffer_lock);
> > +               break;
> > +
> > +       case I2C_SLAVE_REQ_READ_END:
> > +               eeprom->buffer_idx++;
> > +               break;
> > +
> > +       case I2C_SLAVE_STOP:
> > +               eeprom->first_write =3D true;
> > +               break;
> > +
> > +       default:
> > +               break;
> > +       }
> > +
> > +       return 0;
> > +}
>=20
>=20
> Would it make sense to have:
> WRITE_START
> WRITE_NEXT
> WRITE_STOP
> WRITE_REPEAT_START
> READ_START
> READ_NEXT
> READ_STOP
> READ_REPEAT_START
>=20
> Some devices may want different behavior for subsequent
> reads when they are separate transactions, compared to
> a single larger transaction.

This can all be handled with I2C_SLAVE_STOP.

> e.g. a single transaction may wraparound inside a >8bit
> register (e.g. for 16bit: msb, lsb, msb, lsb, ...), but step
> to the next register when a separate read/write is issued.
> Alternatively, a WRITE/READ_NEXT may be implemented
> more efficiently. This may not matter for current systems
> compared to the low-frequency bus, but who knows what
> IoT devices may bring to the table.

Let's start simple until we have more use cases. WRITE_NEXT may be
useful when you have an internal u8 pointer to be set before actually
sending data, but already less useful if this is u16. Also, slaves may
decide to handle stops at unexpected places differently. Furthermore, my
feeling is that slave drivers will be more robust if they handle those
simple primitives properly.

What I could imagine, though, is that somewhen the eeprom simulator will
be able to get data via other means than the shared memory, maybe via
some callback. Then, the callback really only has to deal with "read
this byte" or "write that byte" while for the outer world we have a
proper well-known EEPROM like I2C interface.

That being said, the list of I2C_SLAVE_* events is extensible, of
course. Though, I rather see low-level stuff there like "General Call
Adress received".

>=20
> Also, behavior may be different for repeat start versus
> stop/start, although a repeat start could be a start
> without a previous stop as well...

IMO a repeated start is to ensure that two messages arrive at the slave
without interruption from another master. I can't think why a slave
should know which type of start that was. In fact, if it does that would
raise an eyebrow for me. Do you have an example?

> Of course, if an I2C adapter cannot distinguish these
> events, this is probably a futile attempt at adding
> semantics that will silently break depending on the
> actual hardware/driver used.

That as well. I have not seen an I2C adapter which could provide this
information so far.

Thanks,

   Wolfram


--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUcNIMAAoJEBQN5MwUoCm2PugQAKjjIK4D8pzc1nECdCwUflEO
B/sWORvZHHq+PUiJwf5j/f2lNR/pJ9UMizTGi2apZwTmpurRsgZh6GtSlpSjoPco
pTF3nsfNH4LYiTqCUU5tnIjjLriIy+TjMSceR+laEFF78a5/1DqGAL+Gcb9CfbOj
A8myWHpGx+5NcDoQLr438SjOBun6h7JWCM2zaAGl7MUwMkTirvN+3scOFurj7lI4
Cs0qMhCnT7kZmp4XAUbTUXo9Zp9N4VbhlCRmyLo7jx1c4fkAFk9yZeMVqgS6ErRN
pEXf6Abun5zsrrPuOYhIXgex10MkJs17Y1zhHfyHV7BuOXVqJOwpAE+sTpT27B5U
7iy3OeZBhFXKyb5w8lGA6663gRl9e6+juHd6J+8ks2xUPMNfzd1xHFyrBifWwGA4
4MqSxSBjc26CyJ4irwvgW4K0lwWAiHcXl6YBMFe21D/jPdUaVhJp1N/x6BMHVDYR
BAcHjWcgcLnFAN2fwBWIxV7/3mQbCnIhuwKzR+yzcrTVDwuW5UGN+I57ScPa/DY4
8k5i7VA0v39bTS7CFgzYXMW8+9kMOVWLQBknBidfa+h2y2btHec2KijcAkTeM2Eu
/6wouYgOxBtC2itPdvTaVgNLnDnlXNrQ3Nwy2zCGl1R084Qt3oINjW3FWLSbPmTp
2CFGdOsjd/r6sraa3k11
=0dAB
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
