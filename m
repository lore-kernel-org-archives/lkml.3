Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3C0Fkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 01:40:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52599 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760Ab3C0Fku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 01:40:50 -0400
Message-ID: <1364362839.3520.52.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 116/150] vfs,proc: guarantee unique inodes in /proc
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Mar 2013 05:40:39 +0000
In-Reply-To: <1364311249-14454-117-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
	 <1364311249-14454-117-git-send-email-luis.henriques@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SjAN3eDpG8UsJxtPJJbb"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:e40a:77e1:ece1:499b
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SjAN3eDpG8UsJxtPJJbb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-26 at 15:20 +0000, Luis Henriques wrote:
> 3.5.7.9 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Linus Torvalds <torvalds@linux-foundation.org>
>=20
> commit 51f0885e5415b4cc6535e9cdcc5145bfbc134353 upstream.
>=20
> Dave Jones found another /proc issue with his Trinity tool: thanks to
> the namespace model, we can have multiple /proc dentries that point to
> the same inode, aliasing directories in /proc/<pid>/net/ for example.
>=20
> This ends up being a total disaster, because it acts like hardlinked
> directories, and causes locking problems.  We rely on the topological
> sort of the inodes pointed to by dentries, and if we have aliased
> directories, that odering becomes unreliable.
>=20
> In short: don't do this.  Multiple dentries with the same (directory)
> inode is just a bad idea, and the namespace code should never have
> exposed things this way.  But we're kind of stuck with it.
>=20
> This solves things by just always allocating a new inode during /proc
> dentry lookup, instead of using "iget_locked()" to look up existing
> inodes by superblock and number.  That actually simplies the code a bit,
> at the cost of potentially doing more inode [de]allocations.
>=20
> That said, the inode lookup wasn't free either (and did a lot of locking
> of inodes), so it is probably not that noticeable.  We could easily keep
> the old lookup model for non-directory entries, but rather than try to
> be excessively clever this just implements the minimal and simplest
> workaround for the problem.
>=20
> Reported-and-tested-by: Dave Jones <davej@redhat.com>
> Analyzed-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> [ luis: backported to 3.5; adjust context ]

Prior to commit d3d009cb965eae7e002ea5badf603ea8f4c34915, callers of
proc_get_inode() don't expect it to call pde_put() before returning NULL
- only when returning an existing inode, which it will never do after
this.  So I think you must either cherry-pick that first, or delete
'else pde_put(de);' as part of this fix.

Ben.

> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  fs/proc/inode.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 7ac817b..b02ddd0 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -443,12 +443,10 @@ static const struct file_operations proc_reg_file_o=
ps_no_compat =3D {
> =20
>  struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_ent=
ry *de)
>  {
> -	struct inode * inode;
> +	struct inode *inode =3D new_inode_pseudo(sb);
> =20
> -	inode =3D iget_locked(sb, de->low_ino);
> -	if (!inode)
> -		return NULL;
> -	if (inode->i_state & I_NEW) {
> +	if (inode) {
> +		inode->i_ino =3D de->low_ino;
>  		inode->i_mtime =3D inode->i_atime =3D inode->i_ctime =3D CURRENT_TIME;
>  		PROC_I(inode)->fd =3D 0;
>  		PROC_I(inode)->pde =3D de;
> @@ -477,7 +475,6 @@ struct inode *proc_get_inode(struct super_block *sb, =
struct proc_dir_entry *de)
>  				inode->i_fop =3D de->proc_fops;
>  			}
>  		}
> -		unlock_new_inode(inode);
>  	} else
>  	       pde_put(de);
>  	return inode;

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-SjAN3eDpG8UsJxtPJJbb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVKGV+e/yOyVhhEJAQrbNg/+IPHXcDTvj7WecIqwZeGpOK2BxelzM8zs
plYlNmsW7Nae6WhT+KHHRn3CEZ51XFl4UpisyUkRmXERkH45gbKfJv8wW90IcMsR
2pndy7RoCYl+ANMlFvRrhJdtq1fWjkPbZVdxnFLE8h4SB3vuP1YRlUuwEewZBnIs
lTxdpXTrZoOLce+igcERftwZCI2Y7JnTWSCdjnQBn070t5Fk7XcCJkplTW060kq1
BaXJ9oNmm0Y8/3H330cl/5ngM8Jn6IdE9Y0mRVUrVJEKt3bvmKOV+inHMXOzPwPA
K0DI/aeHEAsAIVmPyikNLE8Abl6Fwr7vPygBE0cVJKMQJizhDKQ9VULwOvl/vUf8
T/ner7xvt2Ai+utFlmjjqmOD+7tRKN6LNC20Bx1QVNoEfJhRNegOLJjcz4rfm3am
jD9goYf8XoVUzrWd9pQsYSFFrpYblycbwAEf9nef1mc1Bh8QbaOwZ3ymP0cbV9vY
jQPMSQmnhQlSrHbNNfua6vgDccVVKDZT4962lYuD5IqGWgotjsYYeWqLee2LOGWc
k1RWxm2+rBq/5BqBJsIdXkk7+mnELCZuDe7kCQYLoWG+2liCaB7yblNBslILAitx
jVheJI5RHnNq7g8IajpiJ1k0T8hdvbuBDKR7qLA78srnc9Qnr0Hq5cH+S8ydtmue
/fRbEvGdvs0=
=283G
-----END PGP SIGNATURE-----

--=-SjAN3eDpG8UsJxtPJJbb--
