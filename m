Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab3DCABX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 20:01:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53320 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3DCABV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 20:01:21 -0400
Date: Wed, 3 Apr 2013 11:01:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: linux-next: manual merge of the nfsd tree with Linus' tree
Message-Id: <20130403110108.e669ebda4b5a88550d96a485@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Apr_2013_11_01_08_+1100_aP3/i96E5eM.6bkm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Apr_2013_11_01_08_+1100_aP3/i96E5eM.6bkm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Today's linux-next merge of the nfsd tree got a conflict in
fs/nfsd/nfscache.c between commit a517b608fa3d ("nfsd: only unhash DRC
entries that are in the hashtable") from Linus' tree and commit
559aa350587e ("nfsd: track memory utilization in the DRC") from the nfsd
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nfsd/nfscache.c
index ca05f6d,3af1767..0000000
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@@ -100,12 -130,14 +130,15 @@@ nfsd_reply_cache_alloc(void
  static void
  nfsd_reply_cache_free_locked(struct svc_cacherep *rp)
  {
- 	if (rp->c_type =3D=3D RC_REPLBUFF)
+ 	if (rp->c_type =3D=3D RC_REPLBUFF && rp->c_replvec.iov_base) {
+ 		drc_mem_usage -=3D rp->c_replvec.iov_len;
  		kfree(rp->c_replvec.iov_base);
+ 	}
 -	hlist_del(&rp->c_hash);
 +	if (!hlist_unhashed(&rp->c_hash))
 +		hlist_del(&rp->c_hash);
  	list_del(&rp->c_lru);
  	--num_drc_entries;
+ 	drc_mem_usage -=3D sizeof(*rp);
  	kmem_cache_free(drc_slab, rp);
  }
 =20

--Signature=_Wed__3_Apr_2013_11_01_08_+1100_aP3/i96E5eM.6bkm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRW3FEAAoJEECxmPOUX5FEkeUQAKACPQ6iI583rDG1cOoxgbXg
yRtmuIDzJsDMUqvSHX/fkh0dL4SzUCXIUiagUj6ZCRHHZLnwbCL/8YuCFnnXLnd3
vSNpYE+UGABODXhNjDAu5O6v2fInaMHnccq/2/7jF4zL9FeT9zWp+gOQHbgYrxPF
HxFVzB58JtBIeMUM7OEQWfz+oImksm7t0El5wjoG4VyP1U6yUAhfMCN9gsNfm92e
i9WFHmgk9j/hUeztalzv9aZ6a6vqfs6fHQhOia9Zz7MD2s2DeK/RrpqKMIndJPrO
K/x01DUNqS1tvWUtJrOORo3ifPXqFnQ1ct9U3WBMoSkyr2pvxeiiLnGnIlwx1UAP
XWvEwMk9gsR/c11wSCFQF/33Id21ZIxH0B72bKY3KKXTcV/4nbwgRIK4H8vRF4z5
ebdrbVd7iST0awG9vMlsr/ybRlV3WpD61i9RZVln74rWxuZda0fY10wHT4YJfeS3
WILODNgHHEtV4o4iZ6KX1ekL40AVRPBtOSf3ib0Sg8JaLS82xhw5QiZsvkmnktM1
x1t+u7l13FACLUmeOxYqmWS5d2QnOnEOysELEoxI1sp0FT9rrM79pJA1j262JoVI
IFOC8tJDkwtoVZUtXieUDP0vWeY0/K+so6A5+1qugsRLaoKRK2xCH5laO1xUrUWH
w+JA82RUowdWm2HhOtNv
=rpK4
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Apr_2013_11_01_08_+1100_aP3/i96E5eM.6bkm--
