Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab3CNBWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 21:22:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57433 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755677Ab3CNBWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 21:22:52 -0400
Message-ID: <1363224161.3937.115.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 029/100] NFSv4.1: Hold reference to layout hdr in layoutget
From: Ben Hutchings <ben@decadent.org.uk>
To: Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tigran Mkrtchyan <tigran.mkrtchyan@desy.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 14 Mar 2013 01:22:41 +0000
In-Reply-To: <20130312223126.165828459@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
	 <20130312223126.165828459@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-suTckW39laxgWm4v7UGp"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-suTckW39laxgWm4v7UGp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-12 at 15:31 -0700, Greg Kroah-Hartman wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Weston Andros Adamson <dros@netapp.com>
>=20
> commit a47970ff7814718fec31b7d966747c6aa1a3545f upstream.
[....]
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -6087,11 +6087,13 @@ static struct page **nfs4_alloc_pages(si
>  static void nfs4_layoutget_release(void *calldata)
>  {
>  	struct nfs4_layoutget *lgp =3D calldata;
> -	struct nfs_server *server =3D NFS_SERVER(lgp->args.inode);
> +	struct inode *inode =3D lgp->args.inode;
> +	struct nfs_server *server =3D NFS_SERVER(inode);
>  	size_t max_pages =3D max_response_pages(server);
> =20
>  	dprintk("--> %s\n", __func__);
>  	nfs4_free_pages(lgp->args.layout.pages, max_pages);
> +	pnfs_put_layout_hdr(NFS_I(inode)->layout);
>  	put_nfs_open_context(lgp->args.ctx);
>  	kfree(calldata);
>  	dprintk("<-- %s\n", __func__);
> @@ -6106,7 +6108,8 @@ static const struct rpc_call_ops nfs4_la
>  struct pnfs_layout_segment *
>  nfs4_proc_layoutget(struct nfs4_layoutget *lgp, gfp_t gfp_flags)
>  {
> -	struct nfs_server *server =3D NFS_SERVER(lgp->args.inode);
> +	struct inode *inode =3D lgp->args.inode;
> +	struct nfs_server *server =3D NFS_SERVER(inode);
>  	size_t max_pages =3D max_response_pages(server);
>  	struct rpc_task *task;
>  	struct rpc_message msg =3D {
> @@ -6136,6 +6139,10 @@ nfs4_proc_layoutget(struct nfs4_layoutge
>  	lgp->res.layoutp =3D &lgp->args.layout;
>  	lgp->res.seq_res.sr_slot =3D NULL;
>  	nfs41_init_sequence(&lgp->args.seq_args, &lgp->res.seq_res, 0);
> +
> +	/* nfs4_layoutget_release calls pnfs_put_layout_hdr */
> +	pnfs_get_layout_hdr(NFS_I(inode)->layout);
> +

But this function also calls nfs4_layoutget_release() if
nfs4_alloc_pages() fails, i.e. before it calls pnfs_get_layout_hdr().
This will lead to a reference imbalance.

Ben.

>  	task =3D rpc_run_task(&task_setup_data);
>  	if (IS_ERR(task))
>  		return ERR_CAST(task);
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-suTckW39laxgWm4v7UGp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUEmYee/yOyVhhEJAQo6Fg//RLX7iZCagGDOTsW7GD0aFm/EgwPuED3V
va0J4RJvwQyY5Ww1s5XL7/aauOykR3qpXeuw6kCatca1UoS11TZawUPb0WYm9emj
I7LEdxp8GF0f4569w3ZiYnZnnsacoGHuhIyPRd/LYxExwgMWcgg/4WQrQ8ahBk6F
AbeeaE2v6r+brocgiWR3DJeJj2XOPMLHDcqkFNFipY/H1NubtONrAr3uh3A0gSKM
UP6mzTbp32xSQutr9f2ivQG528hQV6eVN+l/zb9jG7I9MsKTC1U2Cq9eNkQz+rHi
rvLU7N3WnRFnlHfe+t8jeJSeJA/g1C6CyIIe++yUwaJgcE9Rt7sH9fC4d4JqAK1r
Edamxb5dstiCLi5/Aq9vP07oZUDgR1vgGXryr9p7DgOtY2gPaUleeG3juZPcM+tK
jpEjX6wVuYQMJOJZs+wmzhiULX1TLWUmtoa/55OkS93D4kf0p+zH0jwefccSnjEG
G7Dt6yY7A65kiu75B/m5lAdBbmDTKCJla/2Q57SdICV/o7UAi5SBZk3+5GNfzLla
5baaGZQwJoUQa0K3z1BQP9R5uj63zOShl/JWgvZjvRiMNb8efQh06eYxlWOshhH3
a3nAx1YJjY3/KIMSmnkAf7+PLcSyuCTBAhvfkX4whKGkbnl95q8rJ7F/+opr3Jw1
3SFcNfqIlpA=
=aIYY
-----END PGP SIGNATURE-----

--=-suTckW39laxgWm4v7UGp--
