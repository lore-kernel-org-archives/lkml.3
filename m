Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3G0Vdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 17:33:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60696 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab3G0Vdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 17:33:44 -0400
Message-ID: <1374960811.3607.15.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 71/79] ext4: fix error handling in ext4_ext_truncate()
From: Ben Hutchings <ben@decadent.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 27 Jul 2013 22:33:31 +0100
In-Reply-To: <20130726204730.256399621@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
	 <20130726204730.256399621@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PM8weRonQzeUUqOf1wXc"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PM8weRonQzeUUqOf1wXc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-07-26 at 13:48 -0700, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Theodore Ts'o <tytso@mit.edu>
>=20
> commit 8acd5e9b1217e58a57124d9e225afa12efeae20d upstream.
>=20
> Previously ext4_ext_truncate() was ignoring potential error returns
> from ext4_es_remove_extent() and ext4_ext_remove_space().  This can
> lead to the on-diks extent tree and the extent status tree cache
> getting out of sync, which is particuarlly bad, and can lead to file
> system corruption and potential data loss.
>=20
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  fs/ext4/extents.c |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4386,9 +4386,20 @@ void ext4_ext_truncate(handle_t *handle,
> =20
>  	last_block =3D (inode->i_size + sb->s_blocksize - 1)
>  			>> EXT4_BLOCK_SIZE_BITS(sb);
> +retry:
>  	err =3D ext4_es_remove_extent(inode, last_block,
>  				    EXT_MAX_BLOCKS - last_block);
> +	if (err =3D=3D ENOMEM) {

Positive ENOMEM?!  It looks like this value is bubbled up from
__es_insert_extent() which returns the usual negative error codes.

Ben.

> +		cond_resched();
> +		congestion_wait(BLK_RW_ASYNC, HZ/50);
> +		goto retry;
> +	}
> +	if (err) {
> +		ext4_std_error(inode->i_sb, err);
> +		return;
> +	}
>  	err =3D ext4_ext_remove_space(inode, last_block, EXT_MAX_BLOCKS - 1);
> +	ext4_std_error(inode->i_sb, err);
>  }
> =20
>  static void ext4_falloc_update_inode(struct inode *inode,
>=20

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-PM8weRonQzeUUqOf1wXc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfQ8q+e/yOyVhhEJAQqw9Q//ccFhuchhNH69oi71f9DjGMNM26DRqJc0
C6DA8upee4yGcXMHuRMwpMolyzLABWHpqL3fHwXX1+pOGrnBtV9IQCVGfEme4HH0
g1QlvYKIlRVfk/tlu/fb51xmcPRBS/wpwJ4XI/gu5v6HLskoO/HrtPP/wTIpNagX
f+aDhmV6oQGBosxbzARWOm+sDCku5wk4Csx59zxlMiaKCCs55+jxnX3wmVTwcBn4
n5KtuAbKNtapx/4U0GV0soVsapyz5oLnj6v+JwIjktwc3GpGozRqRJmdnmiFLpXh
TWwrm9kD3mXsfhiUiiztHBDSqHZ9yBB6S48Lb8h/PHagAgdGbsbXJNdPLuos4/do
k7xKFY4AIaTi9XXq7mgJaJeGNol/l2zMn52bYL+vrzYdjtUpsoc+6RVBkSB01zMM
tfyjqndFnYVupHGHCJKWzakYrVe9qgAwuDNc0C4VwXMShBHdL/1Bz8pnOiU1ve2h
w5Ho6IxZOHocjKqJfo6EQJfamrJ1vrO+JdpSpbe42KDrKgYWbPrRsi0Spwf154Dw
De3is9+BXRRZZDD9GW33XAz4DaTaRko5adQd0uxOgi03tPNim04fZi9hGdkLQFh8
MQevzZlmdP1YfbcxN7Pg3iiSjWREZ9kYEMO2pUle+wVlO1Q2xgm+ohkiAHi1/WRw
UDd30yysFQc=
=2dd/
-----END PGP SIGNATURE-----

--=-PM8weRonQzeUUqOf1wXc--
