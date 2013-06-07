Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3FGGWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 02:22:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50322 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272Ab3FGGWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 02:22:53 -0400
Message-ID: <1370586167.3693.0.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 184/184] tipc: fix info leaks via msg_name in
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jon Maloy <jon.maloy@ericsson.com>,
        Allan Stephens <allan.stephens@windriver.com>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 07 Jun 2013 07:22:47 +0100
In-Reply-To: <20130604172137.930866926@1wt.eu>
References: <20130604172137.930866926@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-US7A5Ka7v0GBJy/M/yjm"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-US7A5Ka7v0GBJy/M/yjm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:24 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>  recv_msg/recv_stream
>=20
> From: Mathias Krause <minipli@googlemail.com>

commit 60085c3d009b0df252547adb336d1ccca5ce52ec upstream.

> The code in set_orig_addr() does not initialize all of the members of
> struct sockaddr_tipc when filling the sockaddr info -- namely the union
> is only partly filled. This will make recv_msg() and recv_stream() --
> the only users of this function -- leak kernel stack memory as the
> msg_name member is a local variable in net/socket.c.
>=20
> Additionally to that both recv_msg() and recv_stream() fail to update
> the msg_namelen member to 0 while otherwise returning with 0, i.e.
> "success". This is the case for, e.g., non-blocking sockets. This will
> lead to a 128 byte kernel stack leak in net/socket.c.
>=20
> Fix the first issue by initializing the memory of the union with
> memset(0). Fix the second one by setting msg_namelen to 0 early as it
> will be updated later if we're going to fill the msg_name member.
>=20
> Cc: Jon Maloy <jon.maloy@ericsson.com>
> Cc: Allan Stephens <allan.stephens@windriver.com>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [dannf: backported to Debian's 2.6.32]
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  net/tipc/socket.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index 8ebf4975..eccb86b 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -800,6 +800,7 @@ static void set_orig_addr(struct msghdr *m, struct ti=
pc_msg *msg)
>  	if (addr) {
>  		addr->family =3D AF_TIPC;
>  		addr->addrtype =3D TIPC_ADDR_ID;
> +		memset(&addr->addr, 0, sizeof(addr->addr));
>  		addr->addr.id.ref =3D msg_origport(msg);
>  		addr->addr.id.node =3D msg_orignode(msg);
>  		addr->addr.name.domain =3D 0;   	/* could leave uninitialized */
> @@ -916,6 +917,9 @@ static int recv_msg(struct kiocb *iocb, struct socket=
 *sock,
>  		goto exit;
>  	}
> =20
> +	/* will be updated in set_orig_addr() if needed */
> +	m->msg_namelen =3D 0;
> +
>  restart:
> =20
>  	/* Look for a message in receive queue; wait if necessary */
> @@ -1049,6 +1053,9 @@ static int recv_stream(struct kiocb *iocb, struct s=
ocket *sock,
>  		goto exit;
>  	}
> =20
> +	/* will be updated in set_orig_addr() if needed */
> +	m->msg_namelen =3D 0;
> +
>  restart:
> =20
>  	/* Look for a message in receive queue; wait if necessary */

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-US7A5Ka7v0GBJy/M/yjm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbF8N+e/yOyVhhEJAQqIBg/9EmIpk5ObalTOaZxVktX7V9Fr0NqSZ5Hb
semNyB9Aak1VF0ffWerqJzq6JB/ZTdH/h7iy/5ISCj+UnNI1hjPMN+Uiad1+yZ1A
fySh0rjEcvc2rCIPdqL9BNtoWcJMqEV4qNky28BB8xR7uV7iO03a+gP4w0GDr1io
NhIEKpkVkrjATjRMX0oWsg/R2QsUJnAKWHBOeXsb8Ks5NfVe7OtukbO/kWoHFtDI
mdPK2i8IJTMVHlAbm2dxolhejnCUVTWWa5Yblj5A8Xo2UYbP/6p/AyUeNru4KNRH
uNJYo4AOwWUYU+97rYfDZK5H2Wir2Z5xiLA+5ryfn/VR+3K6o6/lFJnx31GOsuOc
vZzFllG0eNWNga9RYT/z5seMJIFWlo1fRg8akQIyXWvJubggWDU7rQuPTnv0+Ud4
4fEpGYgDdLO1NaGHI7OjoagLuqPTrh5W1fkhVxmSRv6df7Kemp88aPc3gjmnJrZ9
+MmkWR1RkbXZ8MuOjhf/pfLx3MUKQAQYq1isQGY/u5/eGqbnJzVdEUEtdM2R/Mp7
rmz0xyUOH/NCYHYXMQJRk18dJ22ePtL8BBpX8HZvImpjqw/Ko9HmRln8vjssxO+F
JT3hSn2a4dAAT85wa9jKB8+cgrgdkXF43PK6/3uDc1wFrv8hODMPlZBhPaSZ/1mb
hZBz5C0aeGc=
=2lQw
-----END PGP SIGNATURE-----

--=-US7A5Ka7v0GBJy/M/yjm--
