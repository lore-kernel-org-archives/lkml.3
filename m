Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbaE2DZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:25:44 -0400
Received: from ozlabs.org ([103.22.144.67]:40712 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbaE2DZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:25:43 -0400
Date: Thu, 29 May 2014 13:25:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Weston Andros Adamson <dros@primarydata.com>,
        Anna Schumaker <Anna.Schumaker@netapp.com>
Subject: linux-next: manual merge of the vfs tree with the  tree
Message-ID: <20140529132535.40d6789e@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/eGszSh918s/A6G=OcMEHT0v"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/eGszSh918s/A6G=OcMEHT0v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/nfs/direct.c between commit fab5fc25d230 ("nfs: remove
->read_pageio_init from rpc ops") and possibly others from the nfs tree
and commits 619d30b4b8c4 ("convert the guts of nfs_direct_IO() to
iov_iter"), a6cbcd4a4a85 ("get rid of pointless iov_length() in
->direct_IO()") and 91f79c43d1b5 ("new helper:
iov_iter_get_pages_alloc()") from the vfs tree.

I fixed it up (I hope - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nfs/direct.c
index 4ad7bc388679,b122fe21fea0..000000000000
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@@ -414,60 -322,37 +414,37 @@@ static const struct nfs_pgio_completion
   * handled automatically by nfs_direct_read_result().  Otherwise, if
   * no requests have been sent, just return an error.
   */
- static ssize_t nfs_direct_read_schedule_segment(struct nfs_pageio_descrip=
tor *desc,
- 						const struct iovec *iov,
- 						loff_t pos, bool uio)
- {
- 	struct nfs_direct_req *dreq =3D desc->pg_dreq;
- 	struct nfs_open_context *ctx =3D dreq->ctx;
- 	struct inode *inode =3D ctx->dentry->d_inode;
- 	unsigned long user_addr =3D (unsigned long)iov->iov_base;
- 	size_t count =3D iov->iov_len;
- 	size_t rsize =3D NFS_SERVER(inode)->rsize;
- 	unsigned int pgbase;
- 	int result;
- 	ssize_t started =3D 0;
- 	struct page **pagevec =3D NULL;
- 	unsigned int npages;
-=20
- 	do {
- 		size_t bytes;
- 		int i;
 =20
- 		pgbase =3D user_addr & ~PAGE_MASK;
- 		bytes =3D min(max_t(size_t, rsize, PAGE_SIZE), count);
+ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
+ 					      struct iov_iter *iter,
+ 					      loff_t pos)
+ {
+ 	struct nfs_pageio_descriptor desc;
+ 	struct inode *inode =3D dreq->inode;
+ 	ssize_t result =3D -EINVAL;
+ 	size_t requested_bytes =3D 0;
+ 	size_t rsize =3D max_t(size_t, NFS_SERVER(inode)->rsize, PAGE_SIZE);
 =20
- 		result =3D -ENOMEM;
- 		npages =3D nfs_page_array_len(pgbase, bytes);
- 		if (!pagevec)
- 			pagevec =3D kmalloc(npages * sizeof(struct page *),
- 					  GFP_KERNEL);
- 		if (!pagevec)
- 			break;
- 		if (uio) {
- 			down_read(&current->mm->mmap_sem);
- 			result =3D get_user_pages(current, current->mm, user_addr,
- 					npages, 1, 0, pagevec, NULL);
- 			up_read(&current->mm->mmap_sem);
- 			if (result < 0)
- 				break;
- 		} else {
- 			WARN_ON(npages !=3D 1);
- 			result =3D get_kernel_page(user_addr, 1, pagevec);
- 			if (WARN_ON(result !=3D 1))
- 				break;
- 		}
 -	NFS_PROTO(dreq->inode)->read_pageio_init(&desc, dreq->inode,
++	nfs_pageio_init_read(&desc, dreq->inode, false,
+ 			     &nfs_direct_read_completion_ops);
+ 	get_dreq(dreq);
+ 	desc.pg_dreq =3D dreq;
+ 	atomic_inc(&inode->i_dio_count);
 =20
- 		if ((unsigned)result < npages) {
- 			bytes =3D result * PAGE_SIZE;
- 			if (bytes <=3D pgbase) {
- 				nfs_direct_release_pages(pagevec, result);
- 				break;
- 			}
- 			bytes -=3D pgbase;
- 			npages =3D result;
- 		}
+ 	while (iov_iter_count(iter)) {
+ 		struct page **pagevec;
+ 		size_t bytes;
+ 		size_t pgbase;
+ 		unsigned npages, i;
 =20
+ 		result =3D iov_iter_get_pages_alloc(iter, &pagevec,=20
+ 						  rsize, &pgbase);
+ 		if (result < 0)
+ 			break;
+ =09
+ 		bytes =3D result;
+ 		iov_iter_advance(iter, bytes);
+ 		npages =3D (result + pgbase + PAGE_SIZE - 1) / PAGE_SIZE;
  		for (i =3D 0; i < npages; i++) {
  			struct nfs_page *req;
  			unsigned int req_len =3D min_t(size_t, bytes, PAGE_SIZE - pgbase);
@@@ -965,24 -719,58 +813,57 @@@ static ssize_t nfs_direct_write_schedul
  	struct inode *inode =3D dreq->inode;
  	ssize_t result =3D 0;
  	size_t requested_bytes =3D 0;
- 	unsigned long seg;
+ 	size_t wsize =3D max_t(size_t, NFS_SERVER(inode)->wsize, PAGE_SIZE);
 =20
 -	NFS_PROTO(inode)->write_pageio_init(&desc, inode, FLUSH_COND_STABLE,
 +	nfs_pageio_init_write(&desc, inode, FLUSH_COND_STABLE, false,
  			      &nfs_direct_write_completion_ops);
  	desc.pg_dreq =3D dreq;
  	get_dreq(dreq);
  	atomic_inc(&inode->i_dio_count);
 =20
- 	NFS_I(dreq->inode)->write_io +=3D iov_length(iov, nr_segs);
- 	for (seg =3D 0; seg < nr_segs; seg++) {
- 		const struct iovec *vec =3D &iov[seg];
- 		result =3D nfs_direct_write_schedule_segment(&desc, vec, pos, uio);
+ 	NFS_I(inode)->write_io +=3D iov_iter_count(iter);
+ 	while (iov_iter_count(iter)) {
+ 		struct page **pagevec;
+ 		size_t bytes;
+ 		size_t pgbase;
+ 		unsigned npages, i;
+=20
+ 		result =3D iov_iter_get_pages_alloc(iter, &pagevec,=20
+ 						  wsize, &pgbase);
  		if (result < 0)
  			break;
- 		requested_bytes +=3D result;
- 		if ((size_t)result < vec->iov_len)
+=20
+ 		bytes =3D result;
+ 		iov_iter_advance(iter, bytes);
+ 		npages =3D (result + pgbase + PAGE_SIZE - 1) / PAGE_SIZE;
+ 		for (i =3D 0; i < npages; i++) {
+ 			struct nfs_page *req;
+ 			unsigned int req_len =3D min_t(size_t, bytes, PAGE_SIZE - pgbase);
+=20
 -			req =3D nfs_create_request(dreq->ctx, inode,
 -						 pagevec[i],
++			req =3D nfs_create_request(dreq->ctx, pagevec[i], NULL,
+ 						 pgbase, req_len);
+ 			if (IS_ERR(req)) {
+ 				result =3D PTR_ERR(req);
+ 				break;
+ 			}
+ 			nfs_lock_request(req);
+ 			req->wb_index =3D pos >> PAGE_SHIFT;
+ 			req->wb_offset =3D pos & ~PAGE_MASK;
+ 			if (!nfs_pageio_add_request(&desc, req)) {
+ 				result =3D desc.pg_error;
+ 				nfs_unlock_and_release_request(req);
+ 				break;
+ 			}
+ 			pgbase =3D 0;
+ 			bytes -=3D req_len;
+ 			requested_bytes +=3D req_len;
+ 			pos +=3D req_len;
+ 			dreq->bytes_left -=3D req_len;
+ 		}
+ 		nfs_direct_release_pages(pagevec, npages);
+ 		kvfree(pagevec);
+ 		if (result < 0)
  			break;
- 		pos +=3D vec->iov_len;
  	}
  	nfs_pageio_complete(&desc);
 =20

--Sig_/eGszSh918s/A6G=OcMEHT0v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThqi0AAoJEMDTa8Ir7ZwV4EsP/2e/77rTekiJyDi+Gt53BuGB
rKrkYWPpcAgQOhQWcRAZh9ThZYIFKy0Wpqqk/q01VYa4LplskNjAjMg+LXF+M51g
yzD6W9EbISEZkUZXUsARwbfPNYrN3JApi2YAQlOU2SSpkaOcSbmUB7fWJtifAL2M
tvD3ig8cIqpWpDBFROK6tXj84MGmm9roZUkJnwlZWeZOP2304HyLJk43/odKsZDu
pw/Z4s7rHoSh2mjInkkHAuXW8C6ft1RvT+jk38NimabkEDf0kwHCPjz09zpjG6Bn
kr450HN4pJSyYYxZnNADutvU3KrMdvQQUO6GlP+8jIIr9ZuOM6hpY1m4xjOXEjn7
7EdqyQppFlWlAEl9Z4ZdyiRMHaKeJvqRaeGVTe+qULC8E06dcX5Y7bRGMQpWJ8KD
/3a3BK9gKeoeZIJTs6XILIObdcQm/q2oL+3kwox+SyzuVwFCSe6M9bcOoJA6Uhri
gMtPs5i8XaM6Fp5isJRaX7lG1rAUVFIScnZjkkybRLJVD6UEqiqSIoRxDUIp/4oR
sABOTyiKQIgBPXvo5wznmgqjoslp7z87fwRlDpMNHTwUAJ1QZ7016RR/nL1Mxs4H
9Dd9cDCPkw47ZgpTQGPR7xLyiY263849f1lYR4eiJTVZGZFWUWbr+FsWAbY+XiQA
vJCwb3kb+QHM74AYsdhR
=cAcy
-----END PGP SIGNATURE-----

--Sig_/eGszSh918s/A6G=OcMEHT0v--
