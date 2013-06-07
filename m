Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3FGFm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:42:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50209 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898Ab3FGFm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:42:27 -0400
Message-ID: <1370583725.4021.85.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 130/184] CVE-2012-4508 kernel: ext4: AIO vs fallocate stale
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>, Jamie Iles <jamie.iles@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Lukas Czerner <lczerner@redhat.com>, dann frazier <dannf@debian.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 07 Jun 2013 06:42:05 +0100
In-Reply-To: <20130604172135.695967415@1wt.eu>
References: <20130604172135.695967415@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-EZpCa2LLXRIQEy6j2PCE"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EZpCa2LLXRIQEy6j2PCE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>  data exposure
>=20
> From: Jamie Iles <jamie.iles@oracle.com>
>=20
> CVE-2012-4508 kernel: ext4: AIO vs fallocate stale data exposure
> [dannf: backported to Debian's 2.6.32]

Well, this has an interesting ancestry.  The original upstream commits
were c278531d39f3158bfee93dc67da0b77e09776de2,
60d4616f3dc63371b3dc367e5e88fd4b4f037f65 and (most importantly)
dee1f973ca341c266229faa5a1a5bb268bed3531 by Dmitry Monakhov
<dmonakhov@openvz.org>.  They were backported into the RHEL 6 kernel by
Lukas Czerner, according to its changelog.  Dann got this version from
Oracle's redpatch repository, where, if I understand rightly, Jamie Iles
attempted to regenerate Lukas's patch(es).

Would any of the above named be prepared to put their Signed-off-by to
this?

Ben.

> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  fs/ext4/extents.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 66 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index f4b471d..3f022ea 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -62,6 +62,7 @@ ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
>   * idx_pblock:
>   * combine low and high parts of a leaf physical block number into ext4_=
fsblk_t
>   */
> +#define EXT4_EXT_DATA_VALID	0x8  /* extent contains valid data */
>  ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
>  {
>  	ext4_fsblk_t block;
> @@ -2933,6 +2934,30 @@ static int ext4_split_unwritten_extents(handle_t *=
handle,
>  		ext4_ext_mark_uninitialized(ex3);
>  		err =3D ext4_ext_insert_extent(handle, inode, path, ex3, flags);
>  		if (err =3D=3D -ENOSPC && may_zeroout) {
> +			/*
> +			 * This is different from the upstream, because we
> +			 * need only a flag to say that the extent contains
> +			 * the actual data.
> +			 *
> +			 * If the extent contains valid data, which can only
> +			 * happen if AIO races with fallocate, then we got
> +			 * here from ext4_convert_unwritten_extents_dio().
> +			 * So we have to be careful not to zeroout valid data
> +			 * in the extent.
> +			 *
> +			 * To avoid it, we only zeroout the ex3 and extend the
> +			 * extent which is going to become initialized to cover
> +			 * ex3 as well. and continue as we would if only
> +			 * split in two was required.
> +			 */
> +			if (flags & EXT4_EXT_DATA_VALID) {
> +				err =3D  ext4_ext_zeroout(inode, ex3);
> +				if (err)
> +					goto fix_extent_len;
> +				max_blocks =3D allocated;
> +				ex2->ee_len =3D cpu_to_le16(max_blocks);
> +				goto skip;
> +			}
>  			err =3D  ext4_ext_zeroout(inode, &orig_ex);
>  			if (err)
>  				goto fix_extent_len;
> @@ -2978,6 +3003,7 @@ static int ext4_split_unwritten_extents(handle_t *h=
andle,
> =20
>  		allocated =3D max_blocks;
>  	}
> +skip:
>  	/*
>  	 * If there was a change of depth as part of the
>  	 * insertion of ex3 above, we need to update the length
> @@ -3030,11 +3056,16 @@ fix_extent_len:
>  	ext4_ext_dirty(handle, inode, path + depth);
>  	return err;
>  }
> +
>  static int ext4_convert_unwritten_extents_dio(handle_t *handle,
>  					      struct inode *inode,
> +					      ext4_lblk_t iblock,
> +					      unsigned int max_blocks,
>  					      struct ext4_ext_path *path)
>  {
>  	struct ext4_extent *ex;
> +	ext4_lblk_t ee_block;
> +	unsigned int ee_len;
>  	struct ext4_extent_header *eh;
>  	int depth;
>  	int err =3D 0;
> @@ -3043,6 +3074,30 @@ static int ext4_convert_unwritten_extents_dio(hand=
le_t *handle,
>  	depth =3D ext_depth(inode);
>  	eh =3D path[depth].p_hdr;
>  	ex =3D path[depth].p_ext;
> +	ee_block =3D le32_to_cpu(ex->ee_block);
> +	ee_len =3D ext4_ext_get_actual_len(ex);
> +
> +	ext_debug("ext4_convert_unwritten_extents_endio: inode %lu, logical"
> +		  "block %llu, max_blocks %u\n", inode->i_ino,
> +		  (unsigned long long)ee_block, ee_len);
> +
> +	/* If extent is larger than requested then split is required */
> +
> +	if (ee_block !=3D iblock || ee_len > max_blocks) {
> +		err =3D ext4_split_unwritten_extents(handle, inode, path,
> +					iblock, max_blocks,
> +					EXT4_EXT_DATA_VALID);
> +		if (err < 0)
> +			goto out;
> +		ext4_ext_drop_refs(path);
> +		path =3D ext4_ext_find_extent(inode, iblock, path);
> +		if (IS_ERR(path)) {
> +			err =3D PTR_ERR(path);
> +			goto out;
> +		}
> +		depth =3D ext_depth(inode);
> +		ex =3D path[depth].p_ext;
> +	}
> =20
>  	err =3D ext4_ext_get_access(handle, inode, path + depth);
>  	if (err)
> @@ -3129,7 +3184,8 @@ ext4_ext_handle_uninitialized_extents(handle_t *han=
dle, struct inode *inode,
>  	/* async DIO end_io complete, convert the filled extent to written */
>  	if (flags =3D=3D EXT4_GET_BLOCKS_DIO_CONVERT_EXT) {
>  		ret =3D ext4_convert_unwritten_extents_dio(handle, inode,
> -							path);
> +							 iblock, max_blocks,
> +							 path);
>  		if (ret >=3D 0)
>  			ext4_update_inode_fsync_trans(handle, inode, 1);
>  		goto out2;
> @@ -3498,6 +3554,12 @@ void ext4_ext_truncate(struct inode *inode)
>  	int err =3D 0;
> =20
>  	/*
> +	 * finish any pending end_io work so we won't run the risk of
> +	 * converting any truncated blocks to initialized later
> +	 */
> +	flush_aio_dio_completed_IO(inode);
> +
> +	/*
>  	 * probably first extent we're gonna free will be last in block
>  	 */
>  	err =3D ext4_writepage_trans_blocks(inode);
> @@ -3630,6 +3692,9 @@ long ext4_fallocate(struct inode *inode, int mode, =
loff_t offset, loff_t len)
>  		mutex_unlock(&inode->i_mutex);
>  		return ret;
>  	}
> +
> +	/* Prevent race condition between unwritten */
> +	flush_aio_dio_completed_IO(inode);
>  retry:
>  	while (ret >=3D 0 && ret < max_blocks) {
>  		block =3D block + ret;

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-EZpCa2LLXRIQEy6j2PCE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbFyree/yOyVhhEJAQq8nxAApeNjX7XGglKnlGqexbqTmtqB0ZHdUcIZ
xISIJVYMeeehlHWDO+y0XfFPeIEGua69J/bACyBYttFEPcBiE+4pLi4LLoOP6EEO
7D5mTByp+ZhUGEwQRT4BgbphnitJDl97ZPbV6N11Wn1IhLODGsipzQoi7N5bbewy
BG5N7nYzc/q4na/CTvvCbYtv9rWfc61o8aaL5M/Dcvbk0mBHsAtpvTMWxy0M3C3A
X2bfXINQjN1ZzeAKIv6Tli/z4ITYop+FBEB1bAKHadKxhujuCOMox5dvV4IoZTJQ
D4vGDsMrKFw0KrWWsN5swWlXhs+qROVQCiXWL4qmAq86o7SSZ/8rxfcNv3RfN7YW
yysRR8WuFNUTetQSDn7c+Ofr3Vk8iVZHjl66BsoeUW20mZe7v35flIQALXnpVdet
MG1AsYbGCa4YbN+u1xs5VqcB3XGV4Sdc8k/nw3+cpncmSNvh/oo+l/jWLi0wtwM6
3HBggbY7Dm2im/1bnj2V3clkmVhLpYOgPoeVMSwVrJfd8HskD2BmuARcksJ7/cvk
xg1IqagG6+ZnNLLjgNp579jgSMf5hyBn6+Bh7i/YhosLomBwr8Gs4epTdD+2Wm3w
+zj3/AshGOoqNu6QO/3pHaRLoqZPVMbZKT8OlNB/hJgC1h8swkcyNSJ3v+/3RudN
s0XFqG55PbQ=
=9OaB
-----END PGP SIGNATURE-----

--=-EZpCa2LLXRIQEy6j2PCE--
