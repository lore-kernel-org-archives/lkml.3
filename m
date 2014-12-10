Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaLJBUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 20:20:47 -0500
Received: from ozlabs.org ([103.22.144.67]:45099 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbaLJBUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 20:20:44 -0500
Date: Wed, 10 Dec 2014 12:20:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20141210122036.133457c9@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Lw_EIoOHkstf/6nkyWm99gc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Lw_EIoOHkstf/6nkyWm99gc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
drivers/net/ethernet/amd/xgbe/xgbe-desc.c between commit 03ccc4c0a9da
("amd-xgbe: Do not clear interrupt indicator") from the net tree and
commit c9f140ebb008 ("amd-xgbe: Separate Tx/Rx ring data fields into
new structs") from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ethernet/amd/xgbe/xgbe-desc.c
index b15551bad7fa,51b68d1299fe..000000000000
--- a/drivers/net/ethernet/amd/xgbe/xgbe-desc.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-desc.c
@@@ -354,8 -450,30 +450,29 @@@ static void xgbe_unmap_rdata(struct xgb
  		rdata->skb =3D NULL;
  	}
 =20
- 	rdata->tso_header =3D 0;
- 	rdata->len =3D 0;
+ 	if (rdata->rx.hdr.pa.pages)
+ 		put_page(rdata->rx.hdr.pa.pages);
+=20
+ 	if (rdata->rx.hdr.pa_unmap.pages) {
+ 		dma_unmap_page(pdata->dev, rdata->rx.hdr.pa_unmap.pages_dma,
+ 			       rdata->rx.hdr.pa_unmap.pages_len,
+ 			       DMA_FROM_DEVICE);
+ 		put_page(rdata->rx.hdr.pa_unmap.pages);
+ 	}
+=20
+ 	if (rdata->rx.buf.pa.pages)
+ 		put_page(rdata->rx.buf.pa.pages);
+=20
+ 	if (rdata->rx.buf.pa_unmap.pages) {
+ 		dma_unmap_page(pdata->dev, rdata->rx.buf.pa_unmap.pages_dma,
+ 			       rdata->rx.buf.pa_unmap.pages_len,
+ 			       DMA_FROM_DEVICE);
+ 		put_page(rdata->rx.buf.pa_unmap.pages);
+ 	}
+=20
+ 	memset(&rdata->tx, 0, sizeof(rdata->tx));
+ 	memset(&rdata->rx, 0, sizeof(rdata->rx));
+=20
 -	rdata->interrupt =3D 0;
  	rdata->mapped_as_page =3D 0;
 =20
  	if (rdata->state_saved) {

--Sig_/Lw_EIoOHkstf/6nkyWm99gc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUh5/pAAoJEMDTa8Ir7ZwV4QoQAIUWTzHnZ9wWIl/D0ByNjcFF
8L74x9eEZFTyP0WnJgOAwrtSbx5P6nvMQaVEbaBJUl9fQLUIWndZkSVXp97hj39I
48uglquyPOF2a1m6Z7obxqU3z/GGmcYNj0PJO9HPdpy1PE3VON8P2pBwy45Nk67b
esQ8RXg1M9jFIF8ny8/SmhWU5KMZOne3UUaaPTTRFC/eZ7UsuZueUP0sQnAV91Dz
o7xMPf5tI7N7vnsNEKQp8tBPRnEjqQq1EbxZK0Tt/rMKSukqlT5Ng8CDT+O0cWc0
VWCRSJ5n6IIi5BUoWmgpPb1VWGN04+724gL7T+A9nvV9unjdNaCmGQF+qXZwBDYb
vAlRV8Izm6mnuppT33rF5zWp2K9RyfXpRizw+njqumScWoxUG7M2n1TX3rhSKII8
dXIzGrQrRA6AYIHaOpayoPzMFXza70NybPJ0vA8uxPaGIeXve2pjkVW7LjbzcbHN
pQwvEifU+qU3mCmwzTAqlzzJme/GNATEq1Y+HJHZSCyc4Cu4MeCy+0ug88yuCR0B
axIuO5v8oFEDuJ42C+PfaOkmgzEF/5SPQr3IDMEpfiQRT5knAJe/WxSvThmo9Jsh
j4CtQP8BkO489Um0mE61NT3US9JTUDw6kmdhSrYszcw7n2m18eQgKJz0bl18QRlS
WFc5uj9nPvA8ladXIYl+
=S+Zi
-----END PGP SIGNATURE-----

--Sig_/Lw_EIoOHkstf/6nkyWm99gc--
