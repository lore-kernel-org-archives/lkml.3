Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaDVAvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 20:51:11 -0400
Received: from pide.tip.net.au ([101.0.96.218]:41187 "EHLO pide.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbaDVAvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 20:51:06 -0400
Date: Tue, 22 Apr 2014 10:50:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Prabhu <sprabhu@redhat.com>, Steve French <smfrench@gmail.com>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20140422105059.ed297b85f12c3aea2cc57d84@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_10_50_59_+1000_MRlib+Puc+b3=RzR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_10_50_59_+1000_MRlib+Puc+b3=RzR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in fs/cifs/file.c
between commit c11f1df5003d ("cifs: Wait for writebacks to complete
before attempting write") from Linus' tree and commit 30b11990262e
("cifs: switch to ->write_iter()") from the vfs tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/cifs/file.c
index 5ed03e0b8b40,bd6c36d005f3..000000000000
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@@ -2628,13 -2620,9 +2624,12 @@@ cifs_strict_writev(struct kiocb *iocb,=20
  	if (CIFS_CACHE_WRITE(cinode)) {
  		if (cap_unix(tcon->ses) &&
  		(CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability))
 -		    && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) =3D=3D 0))
 -			return generic_file_write_iter(iocb, from);
 -		return cifs_writev(iocb, from);
 +		  && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) =3D=3D 0)) {
- 			written =3D generic_file_aio_write(
- 					iocb, iov, nr_segs, pos);
++			written =3D generic_file_write_iter(iocb, from);
 +			goto out;
 +		}
- 		written =3D cifs_writev(iocb, iov, nr_segs, pos);
++		written =3D cifs_writev(iocb, from);
 +		goto out;
  	}
  	/*
  	 * For non-oplocked files in strict cache mode we need to write the data

--Signature=_Tue__22_Apr_2014_10_50_59_+1000_MRlib+Puc+b3=RzR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVbz4AAoJEMDTa8Ir7ZwVGc4P/i43iXr8VwCncX74tDnIZ2Lr
XQfNyR3aiTiKfBuqKhOIY0JQIDA9CqtL02Ud3RjHVapOjN4ZWphi4tAho9EJbdF/
gUBOd4S+faI/vLzHDMO4zO/BwhFpthWRWevk9BvVcu3AjQNpTi797Zrxzivywkl4
rNYFb9OanBRmBXEsNUXZnS3Tnc0rLg2sRfWfHXVSkPmZz7OuTNEdzCjEGqskEzVo
lCqRggcclKBXHHHaIchw9pXqju6rUlVbznLOkM3xIP2w/wcbXCYkl0Gvn/2j20Wp
zoaApc/NcVmyIuhc7I7OcJ0FkxFk3U7bF4KOCwygeoiYshvPml/2YakmQJeoTYZG
TZ+BBfLNFTh1sQjgmm7F/GwSkm/huCkUAtw6f0vFVevkFEAL7tdwc6edfT0/oI5g
pED0/u2f1Z2rQxTTPRE7xjaGDJUWA8OgmMakxE8E5jveda6q8J42gCDd8PdTr4qD
zTnRE3mTbDyumIpyc6arhf3686IfzL4j8vXGbMq5nJy2ms5DCFoIx8aUEQgFwqU8
/3IW+ngv4GgyES/zPs/P1qbYfLf7OgyLOYaD0nRta/P5pR5p8LFntNilRjMwzNtC
HFygBZgsBoQ+pvPW3lMAVr1y6RVoUsNRhkMtG9cEAll9bQ2ByiKhKu9YRRNyim9c
1gSMxVPNpK+q6ux/j2AU
=OQMy
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_10_50_59_+1000_MRlib+Puc+b3=RzR--
