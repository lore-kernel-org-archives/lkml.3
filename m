Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3IJEML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:12:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48377 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3IJEMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:12:07 -0400
Date: Tue, 10 Sep 2013 14:12:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130910141200.750478a4a78799c5c97bc277@canb.auug.org.au>
In-Reply-To: <20130910140923.5a75463c9f8803afe14c4498@canb.auug.org.au>
References: <20130910140923.5a75463c9f8803afe14c4498@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Sep_2013_14_12_00_+1000_5wQh9PV.rrVcTJ.q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Sep_2013_14_12_00_+1000_5wQh9PV.rrVcTJ.q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[ Just adding Dave Chinner to the cc list]

On Tue, 10 Sep 2013 14:09:23 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi Andrew,
>=20
> Today's linux-next merge of the akpm tree got a conflict in fs/dcache.c
> between commit 8aab6a27332b ("vfs: reorganize dput() memory accesses")
> from Linus' tree and commit "dentry: move to per-sb LRU locks" from the
> akpm tree.
>=20
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc fs/dcache.c
> index 664554e,6e212bd..0000000
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@@ -362,9 -332,8 +361,9 @@@ static void dentry_unlink_inode(struct=20
>    */
>   static void dentry_lru_add(struct dentry *dentry)
>   {
>  -	if (list_empty(&dentry->d_lru)) {
>  +	if (unlikely(!(dentry->d_flags & DCACHE_LRU_LIST))) {
> - 		spin_lock(&dcache_lru_lock);
> + 		spin_lock(&dentry->d_sb->s_dentry_lru_lock);
>  +		dentry->d_flags |=3D DCACHE_LRU_LIST;
>   		list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
>   		dentry->d_sb->s_nr_dentry_unused++;
>   		this_cpu_inc(nr_dentry_unused);
> @@@ -394,9 -363,8 +393,9 @@@ static void dentry_lru_del(struct dentr
>  =20
>   static void dentry_lru_move_list(struct dentry *dentry, struct list_hea=
d *list)
>   {
> - 	spin_lock(&dcache_lru_lock);
> + 	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
>   	if (list_empty(&dentry->d_lru)) {
>  +		dentry->d_flags |=3D DCACHE_LRU_LIST;
>   		list_add_tail(&dentry->d_lru, list);
>   		dentry->d_sb->s_nr_dentry_unused++;
>   		this_cpu_inc(nr_dentry_unused);

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Sep_2013_14_12_00_+1000_5wQh9PV.rrVcTJ.q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSLpwUAAoJEECxmPOUX5FEj6QP/R8RAW3pTYuZtgdypEljfLtd
ZADMEPqP745RptNzXzBusb7tr5FI+SJLRi+F5d2yla5X7LqtsARdohujgspxoViv
LOerT8SPXnKe0Hkb5m25r38cSxWCuGCEk+zXBTTVk8BYG2p2C3c2wQ0YHDoefKsX
b8PD3NSOSNjQpsTINCplJ9f2I6aaaZsaETwo8t1xrPZtoUu7Ys+QtWkOS30YTQCI
I6uTq9z0Xp+UU0pbrEX2MXahkxuYo6qYdj8AMoWWNFRAWq1l2Qge5bBPdYeY3jzV
LOfTAiqodKDOIY6n9Rod/uQq2TJhedmTBnWFz3cbJaWzc8USubMtjzSYyyeqnI3A
X2gqeX6zID+fVtUzNXU9ClKQNDyX9AsZ9bq8yZ4+K7GeQVzYIjs4L12udbb8jZCu
6aa+yLQ311ESwGhcAWAsx3pZ738SrfCRjZSLUhr/NEePhIrXquHPjfWzAtGudeia
R4kHRCExp6wwDHK6fg0VjNfqSYUG/LE6ThdW0o5gGjx5CsylaC1IZpWLYnsNluPJ
03Ft4xhD7shMCNWPSf/iguzoWTiH7YYId/4BKtrcySnTkRWJxw0un35eNFs1zjcT
FkPDtyTwklU9FeiDIMZfzFL2yzRIYXOmy6eOEhfcof+uK/oaKcy6za1TvY/9TdLa
Md+2RwYIolGclsNUWqMO
=H00O
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Sep_2013_14_12_00_+1000_5wQh9PV.rrVcTJ.q--
