Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3CAAti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:49:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:33509 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3CAAtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:49:36 -0500
Date: Fri, 1 Mar 2013 11:49:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeff Layton <jlayton@redhat.com>
Subject: linux-next: manual merge of the nfsd tree with Linus' tree
Message-Id: <20130301114923.056dab07563c70bb2802e972@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__1_Mar_2013_11_49_23_+1100_am/NkGNMOanJs.uE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Mar_2013_11_49_23_+1100_am/NkGNMOanJs.uE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the nfsd tree got a conflict in
fs/nfsd/nfscache.c between commit b67bfe0d42ca ("hlist: drop the node
parameter from iterators") from Linus' tree and commit a4a3ec329124
("nfsd: break out hashtable search into separate function") from the nfsd
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nfsd/nfscache.c
index da3dbd0,ca43664..0000000
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@@ -112,10 -182,130 +182,129 @@@ hash_refile(struct svc_cacherep *rp
  	hlist_add_head(&rp->c_hash, cache_hash + request_hash(rp->c_xid));
  }
 =20
+ static inline bool
+ nfsd_cache_entry_expired(struct svc_cacherep *rp)
+ {
+ 	return rp->c_state !=3D RC_INPROG &&
+ 	       time_after(jiffies, rp->c_timestamp + RC_EXPIRE);
+ }
+=20
+ /*
+  * Walk the LRU list and prune off entries that are older than RC_EXPIRE.
+  * Also prune the oldest ones when the total exceeds the max number of en=
tries.
+  */
+ static void
+ prune_cache_entries(void)
+ {
+ 	struct svc_cacherep *rp, *tmp;
+=20
+ 	list_for_each_entry_safe(rp, tmp, &lru_head, c_lru) {
+ 		if (!nfsd_cache_entry_expired(rp) &&
+ 		    num_drc_entries <=3D max_drc_entries)
+ 			break;
+ 		nfsd_reply_cache_free_locked(rp);
+ 	}
+=20
+ 	/*
+ 	 * Conditionally rearm the job. If we cleaned out the list, then
+ 	 * cancel any pending run (since there won't be any work to do).
+ 	 * Otherwise, we rearm the job or modify the existing one to run in
+ 	 * RC_EXPIRE since we just ran the pruner.
+ 	 */
+ 	if (list_empty(&lru_head))
+ 		cancel_delayed_work(&cache_cleaner);
+ 	else
+ 		mod_delayed_work(system_wq, &cache_cleaner, RC_EXPIRE);
+ }
+=20
+ static void
+ cache_cleaner_func(struct work_struct *unused)
+ {
+ 	spin_lock(&cache_lock);
+ 	prune_cache_entries();
+ 	spin_unlock(&cache_lock);
+ }
+=20
+ static int
+ nfsd_reply_cache_shrink(struct shrinker *shrink, struct shrink_control *s=
c)
+ {
+ 	unsigned int num;
+=20
+ 	spin_lock(&cache_lock);
+ 	if (sc->nr_to_scan)
+ 		prune_cache_entries();
+ 	num =3D num_drc_entries;
+ 	spin_unlock(&cache_lock);
+=20
+ 	return num;
+ }
+=20
+ /*
+  * Walk an xdr_buf and get a CRC for at most the first RC_CSUMLEN bytes
+  */
+ static __wsum
+ nfsd_cache_csum(struct svc_rqst *rqstp)
+ {
+ 	int idx;
+ 	unsigned int base;
+ 	__wsum csum;
+ 	struct xdr_buf *buf =3D &rqstp->rq_arg;
+ 	const unsigned char *p =3D buf->head[0].iov_base;
+ 	size_t csum_len =3D min_t(size_t, buf->head[0].iov_len + buf->page_len,
+ 				RC_CSUMLEN);
+ 	size_t len =3D min(buf->head[0].iov_len, csum_len);
+=20
+ 	/* rq_arg.head first */
+ 	csum =3D csum_partial(p, len, 0);
+ 	csum_len -=3D len;
+=20
+ 	/* Continue into page array */
+ 	idx =3D buf->page_base / PAGE_SIZE;
+ 	base =3D buf->page_base & ~PAGE_MASK;
+ 	while (csum_len) {
+ 		p =3D page_address(buf->pages[idx]) + base;
+ 		len =3D min_t(size_t, PAGE_SIZE - base, csum_len);
+ 		csum =3D csum_partial(p, len, csum);
+ 		csum_len -=3D len;
+ 		base =3D 0;
+ 		++idx;
+ 	}
+ 	return csum;
+ }
+=20
+ /*
+  * Search the request hash for an entry that matches the given rqstp.
+  * Must be called with cache_lock held. Returns the found entry or
+  * NULL on failure.
+  */
+ static struct svc_cacherep *
+ nfsd_cache_search(struct svc_rqst *rqstp, __wsum csum)
+ {
+ 	struct svc_cacherep	*rp;
 -	struct hlist_node	*hn;
+ 	struct hlist_head 	*rh;
+ 	__be32			xid =3D rqstp->rq_xid;
+ 	u32			proto =3D  rqstp->rq_prot,
+ 				vers =3D rqstp->rq_vers,
+ 				proc =3D rqstp->rq_proc;
+=20
+ 	rh =3D &cache_hash[request_hash(xid)];
 -	hlist_for_each_entry(rp, hn, rh, c_hash) {
++	hlist_for_each_entry(rp, rh, c_hash) {
+ 		if (xid =3D=3D rp->c_xid && proc =3D=3D rp->c_proc &&
+ 		    proto =3D=3D rp->c_prot && vers =3D=3D rp->c_vers &&
+ 		    rqstp->rq_arg.len =3D=3D rp->c_len && csum =3D=3D rp->c_csum &&
+ 		    rpc_cmp_addr(svc_addr(rqstp), (struct sockaddr *)&rp->c_addr) &&
+ 		    rpc_get_port(svc_addr(rqstp)) =3D=3D rpc_get_port((struct sockaddr =
*)&rp->c_addr))
+ 			return rp;
+ 	}
+ 	return NULL;
+ }
+=20
  /*
   * Try to find an entry matching the current call in the cache. When none
-  * is found, we grab the oldest unlocked entry off the LRU list.
-  * Note that no operation within the loop may sleep.
+  * is found, we try to grab the oldest expired entry off the LRU list. If
+  * a suitable one isn't there, then drop the cache_lock and allocate a
+  * new one, then search again in case one got inserted while this thread
+  * didn't hold the lock.
   */
  int
  nfsd_cache_lookup(struct svc_rqst *rqstp)

--Signature=_Fri__1_Mar_2013_11_49_23_+1100_am/NkGNMOanJs.uE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRL/sTAAoJEECxmPOUX5FEQW0P/1pjn3cUrLn4tyW9gW3EyKm0
BqzkaTpomWylZzLBf5IAq4hDBne/AKLZLHrwhNg/pNkaTJFnFa2XmzOQEkDG8eAK
0TojC7TC7xV4zlJOEP6NzKd8sgUOTkhZBWFOxGwLDmBgV6j+bMj/v8FDyyiKvfZ6
NzMWFlqU9XVrFYrLZtEu4QvfwUKDPBNFFcZ3h+OyjJwlAb2XAknJ2aqyPzJjx/0c
3dHQq39baTrjpL8c2AOnDfipRL+IRB7vzDOYEaPsrF/jrk12f8CSDBhNswj7mGaF
MXRLEId/zLso5WBO1Ylx/MlN9vXim7XlbYNyXhoqHm+YdgO0e6TD2taHWJyKs9yE
/ZK0/Kq+JP3JCQnm0YUzttdNC3VZs50LfsWtMZ8Lms4TFXoEohecxLS6g1wNNL5v
vlKc++P7LLxW05Uduen3Dc7PNZil8INE6BSEg6EqCMMHnWFriPU/59UWCVa7/ugX
0LRCbpROKlTvj8icKB56e5eWl1+vLL9zXLp89p2ATxn/XTGGZW5XCxSh6illFkfk
LVqmXlwpxO0ZpuGJVUPDhto6uHHoXe2PnOpP3TnLNnldnrgM0bstHVDUp/Zde0Bo
U51Iy6dV/rE5atyOOev0ElV04JJ9B6DrJ3Jlq16lPTRJ7oGAu5srm+WlCsQLZPXB
ZT2ByvY9dHsJBhtAH+it
=F2N2
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Mar_2013_11_49_23_+1100_am/NkGNMOanJs.uE--
