Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbaJGXql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:46:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46434 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbaJGXqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:46:39 -0400
Date: Tue, 7 Oct 2014 18:46:31 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Priya Bansal <p.bansal@samsung.com>
Cc: ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NULL pointer dereference in ecryptfs (ecryptfs_setxattr)
Message-ID: <20141007234630.GA7935@boyd>
References: <1630743052.107781411541880641.JavaMail.weblogic@epmlwas02d>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <1630743052.107781411541880641.JavaMail.weblogic@epmlwas02d>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Priya - Thanks for the report and patch. I have some inline comments.

On 2014-09-24 06:58:01, Priya Bansal wrote:
> This patch fixes the issue which was found in
>  ecryptfs_setxattr(). Previously, while trying to create a file when ecry=
ptfs
>  is mounted over ext4 filesystem  with  encrypted view enabled, the kernel
>  crashes. the reason being the function fsstack_copy_attr_all was trying =
to
>  access dentry->d_inode which was null hence the kernel crashes with NULL
>  pointer dereference. Now a check has been applied which prevents such
>  condition.
>=20
> From 74856445756aba18f98aa5b98ad46e7d98f54737 Mon Sep 17 00:00:00 2001
> From: Priya Bansal <p.bansal@samsung.com>
> Date: Fri, 29 Aug 2014 10:27:27 +0530
> Subject: [PATCH] Fix in ecryptfs_setxattr for NULL check before calling
>  fsstack_copy_attr_all. This patch fixes the issue which was found in
>  ecryptfs_setxattr(). Previously, while trying to create a file when ecry=
ptfs
>  is mounted over ext4 filesystem  with  encrypted view enabled, the kernel
>  crashes. the reason being the function fsstack_copy_attr_all was trying =
to
>  access dentry->d_inode which was null hence the kernel crashes with NULL
>  pointer dereference. Now a check has been applied which prevents such
>  condition.
> Signed-off-by: Priya Bansal <p.bansal@samsung.com>

This commit message is poorly formatted. Have a look at the
"15) The canonical patch format" section of the
Documentation/SubmittingPatches file. It gives a nice description of how
the commit message should be formatted.

> ---
>  linux-3.16.1/fs/ecryptfs/inode.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> diff --git a/linux-3.16.1/fs/ecryptfs/inode.c b/linux-3.16.1/fs/ecryptfs/=
inode.c
> index d4a9431..7da03e5 100644
> --- a/linux-3.16.1/fs/ecryptfs/inode.c
> +++ b/linux-3.16.1/fs/ecryptfs/inode.c
> @@ -1031,6 +1031,8 @@ ecryptfs_setxattr(struct dentry *dentry, const char=
 *name, const void *value,
>  {
>   int rc =3D 0;
>   struct dentry *lower_dentry;
> + struct ecryptfs_mount_crypt_stat *mount_crypt_stat =3D
> +  &ecryptfs_superblock_to_private(dentry->d_sb)->mount_crypt_stat;
> =20
>   lower_dentry =3D ecryptfs_dentry_to_lower(dentry);
>   if (!lower_dentry->d_inode->i_op->setxattr) {
> @@ -1039,8 +1041,20 @@ ecryptfs_setxattr(struct dentry *dentry, const cha=
r *name, const void *value,
>   }
> =20
>   rc =3D vfs_setxattr(lower_dentry, name, value, size, flags);
> - if (!rc)
> -  fsstack_copy_attr_all(dentry->d_inode, lower_dentry->d_inode);
> + if (!rc) {
> +  if (dentry->d_inode =3D=3D NULL) {
> +   if (mount_crypt_stat->flags
> +     & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
> +    rc =3D -EPERM;
> +   else if (mount_crypt_stat->flags
> +     & ECRYPTFS_XATTR_METADATA_ENABLED)
> +    goto out;
> +  } else {
> +   fsstack_copy_attr_all(dentry->d_inode,
> +     lower_dentry->d_inode);
> +  }
> + }
> +
>  out:
>   return rc;
>  }
> --=20

I don't think this is the proper fix. It fixes the NULL pointer
dereference but ecryptfs_setxattr() shouldn't be reachable in encrypted
view mounts. There's a feeble attempt to prevent the modification of
files in ecryptfs_open() when encrypted view is in use but I think we
should force the MS_RDONLY flag on the superblock when the
ecryptfs_encrypted_view mount option is specified.

I'll follow this email up with a patch. I'd appreciate any review and/or
testing you can provide. Thanks!

Tyler

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUNHtWAAoJENaSAD2qAscKfE8P/3hNkCWDyUZPEh09kubSKy2N
eXScZMZyUFbzLiIWAqKaLvxLjU3oW2nv0xJFl7jbf6gIyunfvXNhN8uU3+kwZI4s
cBtTs/PN/rv4kXTZWr7thIKXAq4XgMlN7WmyzQPAxMLlw9xhIJdOp3oMhHWbdSHr
q35GfnxTOCdO3B+JHEorQTH5j2Og/76p2HXcMhl0LUopzR98hVCK5F+7XL3YbSBR
lIxrwWsWO3cP636BNoDBQ1WG0wb39mRQzr5gQ7f5MbzQvajX19FqqLxmFB1pdyE1
82GC9UfmH0Z7gkyjjKo/0HQFoWaBSU6DKTB+cUJc+LgemNo14fwtKOAxO+W7f0ib
JpNAEpI0ZdwGXJOEhhNkkOthvBKMfG4gFLXyWt88cnFIx//ADgrNh8bSh/TP8Ip3
s7gZGPV2qTtPhGW44YuO5PG+nA5lxo2JXv2YtjW6QWUkOMXVs4VjogfzZAKPgPi/
pFN+/DRw70z583jUOOKj7ohuIahotEw5urIGlbkV0sgT2xGIBQ9xdm9hGEn6H0Um
mMwW5BTFpfzSlDyfuRB3yCT6bk9HsRVGI8aaZmigsDL4ITSELLf1rO8IU2sQSRft
tbslqdS+qgzoKi+hBY4pq2CoPmbYAL41s8dkzmOk87VVJSujr4EWZKEy4LppeWSY
agJ3iFgEhN6LBX/G0HHh
=dB9Q
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
