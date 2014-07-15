Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbaGOHaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:30:35 -0400
Received: from ozlabs.org ([103.22.144.67]:60974 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757712AbaGOHad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:30:33 -0400
Date: Tue, 15 Jul 2014 17:30:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>, Torsten Duwe <duwe@lst.de>
Subject: linux-next: manual merge of the random tree with the crypto-current
 tree
Message-ID: <20140715173025.0aaa9a51@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/dLIUgCjKlCQ45Uw0j6BhD//"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dLIUgCjKlCQ45Uw0j6BhD//
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Theodore,

Today's linux-next merge of the random tree got a conflict in
drivers/char/hw_random/core.c between commit d3cc7996473a ("hwrng:
fetch randomness only after device init") from the crypto-current tree
and commit b77e62203be2 ("hwrng: create filler thread") and
53f52341d87b ("hwrng: add per-device entropy derating") from the random
tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/hw_random/core.c
index c4419ea1ab07,349a3b852be9..000000000000
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@@ -53,42 -55,42 +55,62 @@@ static struct task_struct *hwrng_fill
  static LIST_HEAD(rng_list);
  static DEFINE_MUTEX(rng_mutex);
  static int data_avail;
- static u8 *rng_buffer;
+ static u8 *rng_buffer, *rng_fillbuf;
+ static unsigned short current_quality;
+ static unsigned short default_quality; /* =3D 0; default to "off" */
+=20
+ module_param(current_quality, ushort, 0644);
+ MODULE_PARM_DESC(current_quality,
+ 		 "current hwrng entropy estimation per mill");
+ module_param(default_quality, ushort, 0644);
+ MODULE_PARM_DESC(default_quality,
+ 		 "default entropy content of hwrng per mill");
+=20
+ static void start_khwrngd(void);
 =20
 +static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
 +			       int wait);
 +
  static size_t rng_buffer_size(void)
  {
  	return SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES;
  }
 =20
 -static inline int hwrng_init(struct hwrng *rng)
 +static void add_early_randomness(struct hwrng *rng)
  {
 -	int err;
 +	unsigned char bytes[16];
 +	int bytes_read;
 +
 +	/*
 +	 * Currently only virtio-rng cannot return data during device
 +	 * probe, and that's handled in virtio-rng.c itself.  If there
 +	 * are more such devices, this call to rng_get_data can be
 +	 * made conditional here instead of doing it per-device.
 +	 */
 +	bytes_read =3D rng_get_data(rng, bytes, sizeof(bytes), 1);
 +	if (bytes_read > 0)
 +		add_device_randomness(bytes, bytes_read);
 +}
 =20
 +static inline int hwrng_init(struct hwrng *rng)
 +{
  	if (rng->init) {
 -		err =3D rng->init(rng);
 -		if (err)
 -			return err;
 +		int ret;
 +
 +		ret =3D  rng->init(rng);
 +		if (ret)
 +			return ret;
  	}
 +	add_early_randomness(rng);
+=20
+ 	current_quality =3D rng->quality ? : default_quality;
+ 	current_quality &=3D 1023;
+=20
+ 	if (current_quality =3D=3D 0 && hwrng_fill)
+ 		kthread_stop(hwrng_fill);
+ 	if (current_quality > 0 && !hwrng_fill)
+ 		start_khwrngd();
+=20
  	return 0;
  }
 =20

--Sig_/dLIUgCjKlCQ45Uw0j6BhD//
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxNiXAAoJEMDTa8Ir7ZwVjxwP/AsSIiX+lOu52xeiaTGLVEul
ElJVfhz4Yzrn4oMfn/CxehqTRVgGgl5IZrbnC6siOIsBtVcf+OmaICM0QgflWV0Z
IoXtSNjdBJSSqknIml7sIgwBRuChHxS+M5FTbVWoUAr4OrnFSADckaU73Az46nwK
0qLBsDFXrl5cqI2j/YsISDnWXNSt1it7F9z5q19qU4bsJpGn43Qye50Eco3zlHVi
29RSpMEq0APSCOJdtugrVAxpJAu/ARi/63hkOxP5NKgXMsFqQ0PbiFXS+JlV3XFG
/zDXFhR2CkzVT/9WWM5v3P1iZXRMDTZmUmlXKnzAu6QQwrYX7hQb0O38hj1w3d1J
tXsNhycUpoO+s9ncm9BfQ7vF44s4ybBhQG74vViwgS1K/w+WCUj/UDPAYcJYWkrJ
NNu6Wj4BCsgsOnV6X94c0Jr5jm68Tu02KXsSZnAy0gXlH5+g+2ccML5FRRVjG3JJ
hU0csX1bJcXjTApwJSdZBnCOW5wDBB+q7gWowosV6N2gg2fh1XlQNbnqK4czxy5x
r1pUSuladklcBjF8ARd+T+3F1slpP/Sz4owJEvr4zpgwvDkF+YOHG4aVtsIyKidm
s4od8kMcWqHlRQGRlpAghK+YoRU1jFUJ1jxTsCmgpFwpN5UadlZXJwBqi5ruiK7L
ahYycRQxaLQhnEWSHt+y
=jmXk
-----END PGP SIGNATURE-----

--Sig_/dLIUgCjKlCQ45Uw0j6BhD//--
