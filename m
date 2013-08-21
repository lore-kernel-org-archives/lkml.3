Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab3HUIer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:34:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35738 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3HUIep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:34:45 -0400
Date: Wed, 21 Aug 2013 18:34:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: linux-next: manual merge of the akpm-current tree with the
 aio-direct tree
Message-Id: <20130821183443.7f2c54e0d0c2a2e15fd7882e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Aug_2013_18_34_43_+1000_FRYsjjkBmy7lQ+ZE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Aug_2013_18_34_43_+1000_FRYsjjkBmy7lQ+ZE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/filemap.c between commit 6c45b468c3e6 ("s: pull iov_iter use higher up
the stack") from the aio-direct tree and commit ebde8e7e937d ("mm: drop
actor argument of do_generic_file_read()") from the akpm-current tree.

I fixed it up (see below - thanks, Dave, for the hint patch) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/filemap.c
index 45cfcfc,ae5cc01..0000000
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@@ -1198,13 -1201,14 +1201,14 @@@ page_ok
  		 * Ok, we have the page, and it's up-to-date, so
  		 * now we can copy it to user space...
  		 *
- 		 * The actor routine returns how many bytes were actually used..
 -		 * The file_read_actor routine returns how many bytes were
++		 * The file_read_iter_actor routine returns how many bytes were
+ 		 * actually used..
  		 * NOTE! This may not be the same as how much of a user buffer
  		 * we filled up (we may be padding etc), so we can only update
  		 * "pos" here (the actor routine has to update the user buffer
  		 * pointers and the remaining count).
  		 */
- 		ret =3D actor(desc, page, offset, nr);
 -		ret =3D file_read_actor(desc, page, offset, nr);
++		ret =3D file_read_iter_actor(desc, page, offset, nr);
  		offset +=3D ret;
  		index +=3D offset >> PAGE_CACHE_SHIFT;
  		offset &=3D ~PAGE_CACHE_MASK;
@@@ -1424,15 -1457,39 +1428,15 @@@ generic_file_read_iter(struct kiocb *io
  		}
  	}
 =20
 -	count =3D retval;
 -	for (seg =3D 0; seg < nr_segs; seg++) {
 -		read_descriptor_t desc;
 -		loff_t offset =3D 0;
 -
 -		/*
 -		 * If we did a short DIO read we need to skip the section of the
 -		 * iov that we've already read data into.
 -		 */
 -		if (count) {
 -			if (count > iov[seg].iov_len) {
 -				count -=3D iov[seg].iov_len;
 -				continue;
 -			}
 -			offset =3D count;
 -			count =3D 0;
 -		}
 -
 -		desc.written =3D 0;
 -		desc.arg.buf =3D iov[seg].iov_base + offset;
 -		desc.count =3D iov[seg].iov_len - offset;
 -		if (desc.count =3D=3D 0)
 -			continue;
 -		desc.error =3D 0;
 -		do_generic_file_read(filp, ppos, &desc);
 -		retval +=3D desc.written;
 -		if (desc.error) {
 -			retval =3D retval ?: desc.error;
 -			break;
 -		}
 -		if (desc.count > 0)
 -			break;
 -	}
 +	desc.written =3D 0;
 +	desc.arg.data =3D iter;
 +	desc.count =3D count;
 +	desc.error =3D 0;
- 	do_generic_file_read(filp, ppos, &desc, file_read_iter_actor);
++	do_generic_file_read(filp, ppos, &desc);
 +	if (desc.written)
 +		retval =3D desc.written;
 +	else
 +		retval =3D desc.error;
  out:
  	return retval;
  }

--Signature=_Wed__21_Aug_2013_18_34_43_+1000_FRYsjjkBmy7lQ+ZE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFHujAAoJEECxmPOUX5FE5c0P/1zdHjEZXV7rVSk57TLW1gOR
KqhN1gC0qgnGOdb5eEJTcbHXf3/0v0prbL5VeH91R2Zrtpd1Ts7TFuSmru7L6Xie
8gfakvh7cBKPhchUpYyMDr+wGjUBPdMZIVAOExciv+lgxe8TiP/H7NmiWaFtpBYI
WfQSrmXBs8tZFe0t3ImOmdGZeVqYbJpHpwf3bR6aJbJ9IBwN276qf+P0KebT/2FX
NTwH5mKfJKEKw3pVsulJTFOrsGNwVcVzRdrAEBhtAFukAwFgoUd37Vnb9xsHOtbF
TowG9o6M+s4wO/5qx6Z5abuN17BPapi4ANbRqna7PcXImzXjfXyuoywdAYsLivkN
tJbOvZgD9GdwQUPWR4NItu4rMl4H/R0jWtmB+gkdMS2zQuDo299RiM1UmfZFHjAq
lUt4oi19C5xqbEQp/22DPd1CpiCzcRTzLrIa2M8IvT+HDIT+NqRg5963LPyifsSD
xwaHWnS3TPHBpNJVX3tqTqRKWKCrlyE+vA3HxEuaaGiHGL/bRRNIyU+yCsTPTRYa
R0GNMluYuafSV7XR+ykQHg64gnzflAeVhuzPEBJMtVkF8djp9RbqQztXl+mjI5Jq
ml941DHQpjlHxaHgIZzyicgk77tZBdVICvqjv+J3P2ppKmA6P+JrlGrZK26TvLkR
eOVFoe7038HFOreiOXHy
=3yBD
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Aug_2013_18_34_43_+1000_FRYsjjkBmy7lQ+ZE--
