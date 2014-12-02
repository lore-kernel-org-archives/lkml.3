Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaLBOoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:44:20 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:46675 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaLBOoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:44:19 -0500
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: make generic_block_fiemap sig-tolerant PING...
In-Reply-To: <1413552269-32203-1-git-send-email-dmonakhov@openvz.org>
References: <1413552269-32203-1-git-send-email-dmonakhov@openvz.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
CC: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 02 Dec 2014 17:43:51 +0300
Message-ID: <871toikt7c.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Andrew can you please get this patch. IMHO it is simple and clean.
BTW: W/o patch unprivileged may abuse system resources simply by spawning
wast number of unkilable busyloops (works on ext2/ext3):

truncate --size 1T test
for ((i=3D0;i<1024;i++))
do
        filefrag test > /dev/null &
done

> __generic_block_fiemap may spin very long time for large sparse files.
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ioctl.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 8ac3fad..6fbeb68 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -379,6 +379,11 @@ int __generic_block_fiemap(struct inode *inode,
>  				past_eof =3D true;
>  		}
>  		cond_resched();
> +		if (fatal_signal_pending(current)) {
> +			ret =3D -EINTR;
> +			break;
> +		}
> +
>  	} while (1);
>=20=20
>  	/* If ret is 1 then we just hit the end of the extent array */
> --=20
> 1.7.1

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUfdAnAAoJELhyPTmIL6kBgUgH/j8OIu0ick+M6qP6RikzYn17
Hj9xrPhoLrSOqwxN0gF+KnjR2CZ6W+b1UP8F0v1CiQLZ58bcX0wuuueVwFleCkJS
61bcOYhfxR+8N7OoZSFtJNLD8xDCbPi5bU4ryvClB5P9YAT7hx3O7i5YptVDEWei
CkkeJ+WHvwjcXRsrdHZRCCNKqNYWBGm+Y+MjkqGixD35e+NBieXxYAYjD5bpCSs3
/eLV0CeevoBwgeNoPGWci4NHovR4ApT9nhDJeziHS2I3pt9224uStK8op3gYt7zE
j3hZa4YTpD8wO6JpSyMIi/nXShNccetTVtlbh7t3QtvPrmvWiTktzDiv++BBo4k=
=FSg/
-----END PGP SIGNATURE-----
--=-=-=--
