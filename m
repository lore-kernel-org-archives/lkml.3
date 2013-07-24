Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab3GXF54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 01:57:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44761 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3GXF5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 01:57:54 -0400
Date: Wed, 24 Jul 2013 15:57:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peng Tao <bergwolf@gmail.com>, Oleg Drokin <green@whamcloud.com>,
        Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the akpm-current tree with the staging
 tree
Message-Id: <20130724155742.ff98a3230b70b4737fe0c31c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Jul_2013_15_57_42_+1000_1=6qAfSVVnWIha7o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Jul_2013_15_57_42_+1000_1=6qAfSVVnWIha7o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
drivers/staging/lustre/lustre/ldlm/ldlm_pool.c between commit
91a50030f05e ("staging/lustre/ldlm: split client namespaces into active
and inactive") from the staging tree and commit 48a91248649f
("staging/lustre/ldlm: convert to shrinkers to count/scan API") from the
akpm-current tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
index 101af4b,4c41e02..0000000
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
@@@ -597,16 -594,17 +593,17 @@@ int ldlm_pool_recalc(struct ldlm_pool *
  		count =3D pl->pl_ops->po_recalc(pl);
  		lprocfs_counter_add(pl->pl_stats, LDLM_POOL_RECALC_STAT,
  				    count);
 -		return count;
  	}
 +	recalc_interval_sec =3D pl->pl_recalc_time - cfs_time_current_sec() +
 +			      pl->pl_recalc_period;
 =20
 -	return 0;
 +	return recalc_interval_sec;
  }
 -EXPORT_SYMBOL(ldlm_pool_recalc);
 =20
- /**
+ /*
   * Pool shrink wrapper. Will call either client or server pool recalc cal=
lback
-  * depending what pool \a pl is used.
+  * depending what pool pl is used. When nr =3D=3D 0, just return the numb=
er of
+  * freeable locks. Otherwise, return the number of canceled locks.
   */
  int ldlm_pool_shrink(struct ldlm_pool *pl, int nr,
  		     unsigned int gfp_mask)
@@@ -1028,26 -1025,20 +1025,21 @@@ static struct ptlrpc_thread *ldlm_pools
  static struct completion ldlm_pools_comp;
 =20
  /*
-  * Cancel \a nr locks from all namespaces (if possible). Returns number of
-  * cached locks after shrink is finished. All namespaces are asked to
-  * cancel approximately equal amount of locks to keep balancing.
+  * count locks from all namespaces (if possible). Returns number of
+  * cached locks.
   */
- static int ldlm_pools_shrink(ldlm_side_t client, int nr,
- 			     unsigned int gfp_mask)
+ static unsigned long ldlm_pools_count(ldlm_side_t client, unsigned int gf=
p_mask)
  {
- 	int total =3D 0, cached =3D 0, nr_ns;
+ 	unsigned long total =3D 0, nr_ns;
  	struct ldlm_namespace *ns;
 +	struct ldlm_namespace *ns_old =3D NULL; /* loop detection */
  	void *cookie;
 =20
- 	if (client =3D=3D LDLM_NAMESPACE_CLIENT && nr !=3D 0 &&
- 	    !(gfp_mask & __GFP_FS))
- 		return -1;
+ 	if (client =3D=3D LDLM_NAMESPACE_CLIENT && !(gfp_mask & __GFP_FS))
+ 		return 0;
 =20
- 	CDEBUG(D_DLMTRACE, "Request to shrink %d %s locks from all pools\n",
- 	       nr, client =3D=3D LDLM_NAMESPACE_CLIENT ? "client" : "server");
+ 	CDEBUG(D_DLMTRACE, "Request to count %s locks from all pools\n",
+ 	       client =3D=3D LDLM_NAMESPACE_CLIENT ? "client" : "server");
 =20
  	cookie =3D cl_env_reenter();
 =20
@@@ -1094,8 -1080,8 +1096,8 @@@ static unsigned long ldlm_pools_scan(ld
  	/*
  	 * Shrink at least ldlm_namespace_nr(client) namespaces.
  	 */
- 	for (nr_ns =3D ldlm_namespace_nr_read(client) - nr_ns;
- 	     nr_ns > 0; nr_ns--)
 -	for (tmp =3D nr_ns =3D atomic_read(ldlm_namespace_nr(client));
++	for (tmp =3D nr_ns =3D ldlm_namespace_nr_read(client) - nr_ns;
+ 	     tmp > 0; tmp--)
  	{
  		int cancel, nr_locks;
 =20
@@@ -1125,26 -1108,36 +1124,36 @@@
  		ldlm_namespace_put(ns);
  	}
  	cl_env_reexit(cookie);
- 	/* we only decrease the SLV in server pools shrinker, return -1 to
- 	 * kernel to avoid needless loop. LU-1128 */
- 	return (client =3D=3D LDLM_NAMESPACE_SERVER) ? -1 : cached;
+ 	/*
+ 	 * we only decrease the SLV in server pools shrinker, return
+ 	 * SHRINK_STOP to kernel to avoid needless loop. LU-1128
+ 	 */
+ 	return (client =3D=3D LDLM_NAMESPACE_SERVER) ? SHRINK_STOP : freed;
+ }
+=20
+ static unsigned long ldlm_pools_srv_count(struct shrinker *s, struct shri=
nk_control *sc)
+ {
+ 	return ldlm_pools_count(LDLM_NAMESPACE_SERVER, sc->gfp_mask);
  }
 =20
- static int ldlm_pools_srv_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
+ static unsigned long ldlm_pools_srv_scan(struct shrinker *s, struct shrin=
k_control *sc)
  {
- 	return ldlm_pools_shrink(LDLM_NAMESPACE_SERVER,
- 				 shrink_param(sc, nr_to_scan),
- 				 shrink_param(sc, gfp_mask));
+ 	return ldlm_pools_scan(LDLM_NAMESPACE_SERVER, sc->nr_to_scan,
+ 			       sc->gfp_mask);
  }
 =20
- static int ldlm_pools_cli_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
+ static unsigned long ldlm_pools_cli_count(struct shrinker *s, struct shri=
nk_control *sc)
  {
- 	return ldlm_pools_shrink(LDLM_NAMESPACE_CLIENT,
- 				 shrink_param(sc, nr_to_scan),
- 				 shrink_param(sc, gfp_mask));
+ 	return ldlm_pools_count(LDLM_NAMESPACE_CLIENT, sc->gfp_mask);
+ }
+=20
+ static unsigned long ldlm_pools_cli_scan(struct shrinker *s, struct shrin=
k_control *sc)
+ {
+ 	return ldlm_pools_scan(LDLM_NAMESPACE_CLIENT, sc->nr_to_scan,
+ 			       sc->gfp_mask);
  }
 =20
 -void ldlm_pools_recalc(ldlm_side_t client)
 +int ldlm_pools_recalc(ldlm_side_t client)
  {
  	__u32 nr_l =3D 0, nr_p =3D 0, l;
  	struct ldlm_namespace *ns;

--Signature=_Wed__24_Jul_2013_15_57_42_+1000_1=6qAfSVVnWIha7o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR72zbAAoJEECxmPOUX5FE4PIQAJw2diBK0rkQ20AU9KUJ4IFZ
foeCs+jK/MNXnKTlkWCv5JcaWnabcKxQ5fyqwk4KweKAND4EBFhxmyfFgJoZHtE0
uYLwWZ5vlUvwEx6gAhIip070izr7bfqfMseI/u/lyC3FghHQJaz6mNcUp84cEYnA
gbDtt6YIBEhSHADTVQoZoA37Z6IU8CNohXrhvSCQEPi6KwJIn8QZjQAzm/BS+Clu
/W0xN9oQVxC8rphX6J5zwYrZB+Pv30Luq6KAvDcuaDK+biBEqf3PrbDRucnsYbZ0
jH0m1jO/CL49S2YF/Eglh8dRp2D/jSNbBFacKddP7JUTSmaZ3Voh1xCMKbygxEzj
pPT2WAkZn6rwQWLp26vmCv97Z8S6nXUmAzOH9Olyu5zLQQ+X75ZNWRlflccLqhZ8
JwJZLuQ5PZgdY/7dH/CQiyZ9aVvMFJhHWvOCQ8XXvFaLOcEsohd/UWwqj82B9NdV
d1VFvR/5fGJejFj36NvTvCKPjAAzHiM2TLmBorRz/SUDo5wC+3BUmXDA8Uwhm5Jn
DZc7ohM9GmhyCrcgOOBm3SvyRCNeWbjF7wCOGmbixAUAJu+ymltsMKmaBCQRhtoN
q/GN6iEeYwz0wmjwcE4lMxeCHGe0jY6vpqJwsVuL9AhDswzfygfYoHDNi2cIyg5S
Je+rRfYnWaX7iCaoDEAA
=NZIy
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Jul_2013_15_57_42_+1000_1=6qAfSVVnWIha7o--
