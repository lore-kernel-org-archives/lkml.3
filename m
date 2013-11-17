Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab3KQRIx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 12:08:53 -0500
Received: from sauhun.de ([89.238.76.85]:37963 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab3KQRIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 12:08:45 -0500
Date: Sun, 17 Nov 2013 18:08:38 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Andreas Werner <wernerandy@gmx.de>
Cc: khali@linux-fr.org, jacmet@sunsite.dk, hskinnemoen@gmail.com,
        dianders@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] I2C: busses: i2c-eg20t Do not print error message in
 syslog if no ACK received
Message-ID: <20131117170838.GA8577@katana>
References: <1384678731-10399-1-git-send-email-wernerandy@gmx.de>
 <20131117110846.GA3093@katana>
 <20131117123902.GA3834@awedesk.fritz.box>
 <20131117121809.GC3093@katana>
 <20131117165329.GA1562@thinkpad.fritz.box>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20131117165329.GA1562@thinkpad.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 17, 2013 at 05:53:29PM +0100, Andreas Werner wrote:
> On Sun, Nov 17, 2013 at 01:18:09PM +0100, Wolfram Sang wrote:
> >=20
> > > Is there another reason why pch_i2c_getack returned EPROTO?
> > > May be ENXIO was introduced later?
> >=20
> > Imperfect review :)
> >=20
> > > I think we can just replace the -EIO with -ENXIO or do you want to pi=
ck up the return
> > > vale of pch_i2c_getack and return that ?
> >=20
> > The latter. As a rule of thumb, it is usually more sustainable to pass
> > through error codes. Overloading them should only be done when really
> > necessary IMO.
> >=20
> Ok, if that will be ok in pch_i2c_wait_for_check_xfer i will resend=20
> the patch.
>=20
>         ret =3D pch_i2c_getack(adap);
>=20
>         if (ret)
>                 pch_dbg(adap, "Receive NACK for slave address setting\n");
>=20
>         return (int)ret;

Hmm, the cast looks ugly. Looking at the driver more closely, my
preferred solution would be to elimiate the getack function and just do
that directly in wait_for_check_xfer:

	if (ioread32(adap->pch_base_address + PCH_I2CSR) & PCH_GETACK) {
		pch_dbg ...
		return -ENXIO;
	}

Something like that...


--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSiPgWAAoJEBQN5MwUoCm2AREP/3ZPVUCfuOL+s7hcoHnhVLFo
LloXtt5ZLDiwBmXOI8tQs1+07eUPvETtAEBGXQN1L5WioMhjLePyLaX/UiXBQZjk
yoIjl4yJhGppzhqgbIIelOgooHrhgcAxxOPRwBb4VDcfbRIargwknm8Hp2cEEgbZ
2Sd7WK3gj8fA8Y/mE96dapt5vD7U14oMlVqDe73AAUAWOELUcZedijljfLYwsCKs
OliNYc0ov8vdfK76JbJ5ldmFWR5VSk5ZZNBWgUYP6JwCi24BOiFLAN/P0BXgy/6H
3JKebudlfwEKF/yFzg03HmTlCVoDaT5blVGPP01QMuEvDosDzfaMjSv3ULixsglE
8OniQpPEE7peiVnLMZHvrlIgBgzeaP/gIZ/pSkOY/WBN57LXEepeyz95RaQmhfP1
ooEYtFrC1TcetdPddLfmbwNGJh52jjDgClEZ7Gzx6tP7hfvOQglhbRefI7+JCaLo
XU3IOcCAWjSqXTRT6jEMEJvJQzgTvh3D07g6JcNLn/cqGpf+meuToBSAFYf/ufZo
gfwCaZCKU616Kjpvdcnee67zEVYQuj1gSx+aDrgN9xFY5bRul3zgppQOjzwyxSQu
edSxkT/mqHEhQ8Woq2RHRoPo8JjXGYGSaxQggRH/Ni4UBKBshPR5AxWFU/06cFNu
N1FvInMiifUDTnK5DK6p
=oFJf
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
