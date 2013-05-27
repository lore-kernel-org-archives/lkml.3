Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3E0GUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:20:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56313 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab3E0GUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:20:37 -0400
Date: Mon, 27 May 2013 16:20:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130527162026.3eebd45b3755a138e443c28e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_May_2013_16_20_26_+1000_nACQOIDwzduNZHre"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_May_2013_16_20_26_+1000_nACQOIDwzduNZHre
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/aio.c
between commit 03e04f048d27 ("aio: fix kioctx not being freed after
cancellation at exit time") from Linus' tree and commit "aio: reqs_active
-> reqs_available" from the akpm tree.

I fixed it up (see below - taken from a similar patch later in the akpm
tree) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/aio.c
index 7fe5bde,009a7b5..0000000
--- a/fs/aio.c
+++ b/fs/aio.c
@@@ -306,10 -312,8 +312,10 @@@ static void free_ioctx(struct kioctx *c
  	head =3D ring->head;
  	kunmap_atomic(ring);
 =20
- 	while (atomic_read(&ctx->reqs_active) > 0) {
+ 	while (atomic_read(&ctx->reqs_available) < ctx->nr_events - 1) {
 -		wait_event(ctx->wait, head !=3D ctx->tail);
 +		wait_event(ctx->wait,
- 				head !=3D ctx->tail ||
- 				atomic_read(&ctx->reqs_active) <=3D 0);
++			   (head !=3D ctx->tail) ||
++			   (atomic_read(&ctx->reqs_available) >=3D ctx->nr_events - 1));
 =20
  		avail =3D (head <=3D ctx->tail ? ctx->tail : ctx->nr_events) - head;
 =20

--Signature=_Mon__27_May_2013_16_20_26_+1000_nACQOIDwzduNZHre
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRovsuAAoJEECxmPOUX5FEVRwP/1bqpVoXXiZkVM+NrvBCxezz
K0EL1QX9HOjJ4PtHupvLsQfIXZQdYbOoRMNw6M5LSUzQ9Mo2HisitNUm01XO1Bb0
no70GEtdlOREeHo+tA+faB+p+oo1NV9vYVTrOgoXg7hVcRlJmCbIBy9bJWzyNR/a
8pKCwEZqo8JNs2BMJeEaFgyErFQOQte74Ufe6/ysuv+6aSQRXxUkK1A+npuoWlkr
/qU9yu/R5QUcCRMUAZE5FNdjrliPpoLySlusUDaNOfsocLCNK8gXJLIjkzbxenks
uIZ4R1+DMiFO2rl9KmyEO2095r7GFG2pnEY92PzcwnSYzuZpdgKxshQdlJvfioMg
h/d2maQMm3yH0+YUcxr27mn2hEd470wVTmENkfcTykGTPd5Iuc2UdSLatgiuTcJ2
/QNBbSXRQfPOS49NEJn8tIlHVPQgI2r5Xume/4OFdxLsZ9ofSBDXZEV4P6jF99B6
26y3o8zNdDSeuvildzCmswUvzvEdnEyZv8Fmq2zZaeDz4cZqsvYu/wg2TDRVwsKn
jk3N2ztlPbyQh9+/VZd/5Oc/XH0R1rKhJfVruPEbzRh6zEm4fvtmCWaKOl+UQbAR
UWDtFFFpSNQSvU2fI8B4JhDaKKulLe8StNvyNrTGVtF/E4I4pv/zcrTi1GvN8WMq
IfO+flUeXrvGpL+VEqNV
=8JqT
-----END PGP SIGNATURE-----

--Signature=_Mon__27_May_2013_16_20_26_+1000_nACQOIDwzduNZHre--
