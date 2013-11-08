Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3KHIT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:19:56 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46135 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3KHITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:19:54 -0500
Date: Fri, 8 Nov 2013 19:19:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: linux-next: manual merge of the akpm tree with the aio-direct tree
Message-Id: <20131108191942.562d918a44599ba0c07e6605@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__8_Nov_2013_19_19_42_+1100_eZ7zVYUqXLs.pmwn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Nov_2013_19_19_42_+1100_eZ7zVYUqXLs.pmwn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/filemap.c
between dropping the aio-direct tree and commit "mm: drop actor argument
of do_generic_file_read()" from the akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).  The followup fix up patch is no longer (for
now) needed.

(This is part of the pain of maintaining a rebasing patch series on top
of linux-next.)

The patch now looks like this:

diff --git a/mm/filemap.c b/mm/filemap.c
index ae4846ff4849..b7749a92021c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1090,7 +1090,6 @@ static void shrink_readahead_size_eio(struct file *fi=
lp,
  * @filp:	the file to read
  * @ppos:	current file position
  * @desc:	read_descriptor
- * @actor:	read method
  *
  * This is a generic file read routine, and uses the
  * mapping->a_ops->readpage() function for the actual low-level stuff.
@@ -1099,7 +1098,7 @@ static void shrink_readahead_size_eio(struct file *fi=
lp,
  * of the logic when it comes to error handling etc.
  */
 static void do_generic_file_read(struct file *filp, loff_t *ppos,
-		read_descriptor_t *desc, read_actor_t actor)
+		read_descriptor_t *desc)
 {
 	struct address_space *mapping =3D filp->f_mapping;
 	struct inode *inode =3D mapping->host;
@@ -1200,13 +1199,14 @@ page_ok:
 		 * Ok, we have the page, and it's up-to-date, so
 		 * now we can copy it to user space...
 		 *
-		 * The actor routine returns how many bytes were actually used..
+		 * The file_read_actor routine returns how many bytes were
+		 * actually used..
 		 * NOTE! This may not be the same as how much of a user buffer
 		 * we filled up (we may be padding etc), so we can only update
 		 * "pos" here (the actor routine has to update the user buffer
 		 * pointers and the remaining count).
 		 */
-		ret =3D actor(desc, page, offset, nr);
+		ret =3D file_read_actor(desc, page, offset, nr);
 		offset +=3D ret;
 		index +=3D offset >> PAGE_CACHE_SHIFT;
 		offset &=3D ~PAGE_CACHE_MASK;
@@ -1479,7 +1479,7 @@ generic_file_aio_read(struct kiocb *iocb, const struc=
t iovec *iov,
 		if (desc.count =3D=3D 0)
 			continue;
 		desc.error =3D 0;
-		do_generic_file_read(filp, ppos, &desc, file_read_actor);
+		do_generic_file_read(filp, ppos, &desc);
 		retval +=3D desc.written;
 		if (desc.error) {
 			retval =3D retval ?: desc.error;

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/filemap.c
index ae4846ff4849,9cb5b0dea852..000000000000
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@@ -1455,41 -1426,46 +1455,41 @@@ generic_file_aio_read(struct kiocb *ioc
  		}
  	}
 =20
 -	desc.written =3D 0;
 -	desc.arg.data =3D iter;
 -	desc.count =3D count;
 -	desc.error =3D 0;
 -	do_generic_file_read(filp, ppos, &desc);
 -	if (desc.written)
 -		retval =3D desc.written;
 -	else
 -		retval =3D desc.error;
 -out:
 -	return retval;
 -}
 -EXPORT_SYMBOL(generic_file_read_iter);
 +	count =3D retval;
 +	for (seg =3D 0; seg < nr_segs; seg++) {
 +		read_descriptor_t desc;
 +		loff_t offset =3D 0;
 =20
 -/**
 - * generic_file_aio_read - generic filesystem read routine
 - * @iocb:      kernel I/O control block
 - * @iov:       io vector request
 - * @nr_segs:   number of segments in the iovec
 - * @pos:       current file position
 - *
 - * This is the "read()" routine for all filesystems
 - * that can use the page cache directly.
 - */
 -ssize_t
 -generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 -		unsigned long nr_segs, loff_t pos)
 -{
 -	struct iov_iter iter;
 -	int ret;
 -	size_t count;
 -
 -	count =3D 0;
 -	ret =3D generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
 -	if (ret)
 -		return ret;
 -
 -	iov_iter_init(&iter, iov, nr_segs, count, 0);
 +		/*
 +		 * If we did a short DIO read we need to skip the section of the
 +		 * iov that we've already read data into.
 +		 */
 +		if (count) {
 +			if (count > iov[seg].iov_len) {
 +				count -=3D iov[seg].iov_len;
 +				continue;
 +			}
 +			offset =3D count;
 +			count =3D 0;
 +		}
 =20
 -	return generic_file_read_iter(iocb, &iter, pos);
 +		desc.written =3D 0;
 +		desc.arg.buf =3D iov[seg].iov_base + offset;
 +		desc.count =3D iov[seg].iov_len - offset;
 +		if (desc.count =3D=3D 0)
 +			continue;
 +		desc.error =3D 0;
- 		do_generic_file_read(filp, ppos, &desc, file_read_actor);
++		do_generic_file_read(filp, ppos, &desc);
 +		retval +=3D desc.written;
 +		if (desc.error) {
 +			retval =3D retval ?: desc.error;
 +			break;
 +		}
 +		if (desc.count > 0)
 +			break;
 +	}
 +out:
 +	return retval;
  }
  EXPORT_SYMBOL(generic_file_aio_read);
 =20

--Signature=_Fri__8_Nov_2013_19_19_42_+1100_eZ7zVYUqXLs.pmwn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSfJ6iAAoJEMDTa8Ir7ZwVNHUQAInR8F3rkHYGBLYgKeBdNDqb
ySel1HtababpVRexPEiQbiwuLwjMR16UoI8xyPnfPYz+VczurIaNWn1Ko0tpn+PP
8A7DKlSKxFFZusdpuwEsA1YlRibRvK5Q9mYa6SdNNwtGM5UP8Ut7KJY5MiamnCws
N5KpuGSr3kFxWC65H18r0z2eq1LHA2L6hdsh1hwB1b0cwCaWkrkTegOJAZ+yp/eg
REKATmTzj9UFdfrPXINfr/afbIWylnQvDNH8eiJu2RRsRaH8epNGBol3Nxmg12CP
O8iCBoBKMyKG/clsTxgKFWkpLC9Ymvux6uYbOZhD8mnqaXVtQj+gS4M+Dbi17Z/F
v8rQlVB+cFVenVQOy80oEVnaAQM6OzVSAV9kKOQbnruFmOj85HVr4AdQwNjjW5k+
+k9qdMwhZneAtWe0z1G1lxSAPi4RdOU7/eN72wa6gJClqDobn9ca9M9ixVNW7eKs
7KVpWP2K6kqh2jFko5O/1q7ki3UrAQk5ingdJcifU2zuuJfYI03IG7Obsiru9j4w
D5BH656F5ngLFtJb3e1iMSk+0ROLSt81YqQtfvInRe3kscgHrkNlkTC0BhccyLDI
Hmyu83oOuYtjTomhRtq/vf/0OLkjSqxKQv3nilJahDdw2MRawt4MhdxthxwQFBeG
SY6rgNUCU4rzwmkQ8ElC
=gmim
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Nov_2013_19_19_42_+1100_eZ7zVYUqXLs.pmwn--
