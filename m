Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaHNEYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 00:24:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaHNEX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 00:23:59 -0400
Date: Thu, 14 Aug 2014 14:23:48 +1000
From: NeilBrown <neilb@suse.de>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-cachefs@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/3] FS-Cache: Reduce cookie ref count if submit fails.
Message-ID: <20140814142348.161b2eca@notabene.brown>
In-Reply-To: <53EB992D.6040608@adfin.com>
References: <cover.1407948737.git.milosz@adfin.com>
	<53EB992D.6040608@adfin.com>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/_gG7l_H9o05UjHtchm==euo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_gG7l_H9o05UjHtchm==euo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Aug 2014 12:58:21 -0400 Milosz Tanski <milosz@adfin.com> wrote:

> I've been seeing issues with disposing cookies under vma pressure. The sy=
mptom
> is that the refcount gets out of sync. In this case we fail to decrement =
the
> refcount if submit fails. I found this while auditing the error in and ar=
ound
> cookie operations.
>=20
> Signed-off-by: Milosz Tanski <milosz@adfin.com>
> ---
>  fs/fscache/object.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/fscache/object.c b/fs/fscache/object.c
> index d3b4539..e1eb1f5 100644
> --- a/fs/fscache/object.c
> +++ b/fs/fscache/object.c
> @@ -982,6 +982,8 @@ nomem:
>  submit_op_failed:
>  	clear_bit(FSCACHE_OBJECT_IS_LIVE, &object->flags);
>  	spin_unlock(&cookie->lock);
> +	if (__fscache_unuse_cookie(cookie))
> +		__fscache_wake_unused_cookie(cookie);
>  	kfree(op);
>  	_leave(" [EIO]");
>  	return transit_to(KILL_OBJECT);

Should this simple by
  +     fscache_unuse_cookie(cookie);

it does both the "unuse" and the "wake".

Otherwise they all look good to me.

NeilBrown

--Sig_/_gG7l_H9o05UjHtchm==euo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+w51Dnsnt1WYoG5AQJHxw//VUnzfyvLAjX/ZkDwjXJJaPCrXcHMDbov
rKx8QBH8z0txjNRLWMjtHcSYWIpFajzE3AMKKYm+vIMNq6997cudC688Eaduw1HD
h3zr4ILfJbQNAPrCzJGRQvjcswtL2JOf0/yUbXTCApG+yCdCyDOqWda96p4lpLx9
B+0LBb0fR+zfx2I4bniSokfbFaurYQPokNw4rLgZsQRyZGm/JUBtVDoOdFR49tFq
6e+26SEGwrbS8BAQjdYBtDJVMyDFqYqrK2mcFCXt2A4PfstWQUleLASebHh6kNsW
cECW7GPxUXxECLbzwMvG1szrXRRfONszC8RGwlRfMKDlWZxRarNIZl2ehGU/XSAZ
W2iHslDDjGTgP+PfDOMiaCg9A7Auoo4+FFakLz/VQgYuw9de0JJYWXOzAmKIUxfZ
48GB08V8CH2Hg1/atBrzQrsitN6xCEaCrCB4b/30Z0VycDoSlFhGklNaxMtvh8+a
whpvotcxgeACrr97BpylphrWSdUFM1NtySvSkgILkFFmqXiS6sZb+Sk9uY8YxbbV
3xhyb30Uu2kU+9ioDEtBT/2E7GSoztZUkitGmbZRdUCPpu67bMUK7NNQsNFQt1fY
lMVgDV8CovH4xezbMjltm/FjEPKXopiA8IXxfxqGcKpfKg4UHhk0+1rzhKLs+/a6
MA2Wkh8StiU=
=AnJ+
-----END PGP SIGNATURE-----

--Sig_/_gG7l_H9o05UjHtchm==euo--
