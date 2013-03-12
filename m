Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3CLBnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 21:43:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab3CLBnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 21:43:45 -0400
Date: Tue, 12 Mar 2013 12:43:31 +1100
From: NeilBrown <neilb@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-arch@vger.kernel.org,
        sfr@canb.auug.org.au, Joakim.Tjernlund@transmode.se, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 3/4] UAPI: Fix endianness conditionals in
 linux/raid/md_p.h
Message-ID: <20130312124331.221fcc15@notabene.brown>
In-Reply-To: <20130306204751.31327.18239.stgit@warthog.procyon.org.uk>
References: <20130306204724.31327.43118.stgit@warthog.procyon.org.uk>
	<20130306204751.31327.18239.stgit@warthog.procyon.org.uk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZJTX6adI9zZ/4/IrFenN+b2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZJTX6adI9zZ/4/IrFenN+b2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 06 Mar 2013 20:47:51 +0000 David Howells <dhowells@redhat.com> wrot=
e:

> In the UAPI header files, __BIG_ENDIAN and __LITTLE_ENDIAN must be compar=
ed
> against __BYTE_ORDER in preprocessor conditionals where these are exposed=
 to
> userspace (that is they're not inside __KERNEL__ conditionals).
>=20
> However, in the main kernel the norm is to check for "defined(__XXX_ENDIA=
N)"
> rather than comparing against __BYTE_ORDER and this has incorrectly leaked
> into the userspace headers.
>=20
> The definition of struct mdp_superblock_s in linux/raid/md_p.h is wrong i=
n this
> way.  Note that userspace will likely interpret the ordering of the fields
> incorrectly as the big-endian variant on a little-endian machines - depen=
ding
> on header inclusion order.
>=20
> [!!!] NOTE [!!!]  This patch may adversely change the userspace API.  It =
might
> be better to fix the ordering of events_hi, events_lo, cp_events_hi and
> cp_events_lo in struct mdp_superblock_s / typedef mdp_super_t.

Thanks David - looks good to me.
Changing the ordering of fields isn't really an option at this stage - over
10 years too late :-(.
I think any user-space tools that use this data structure have their own co=
py
of the include file.

Acked-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown


>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Neil Brown <neilb@suse.de>
> cc: linux-raid@vger.kernel.org
> ---
>=20
>  include/uapi/linux/raid/md_p.h |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_=
p.h
> index ee75353..fe1a540 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -145,16 +145,18 @@ typedef struct mdp_superblock_s {
>  	__u32 failed_disks;	/*  4 Number of failed disks		      */
>  	__u32 spare_disks;	/*  5 Number of spare disks		      */
>  	__u32 sb_csum;		/*  6 checksum of the whole superblock        */
> -#ifdef __BIG_ENDIAN
> +#if defined(__BYTE_ORDER) ? __BYTE_ORDER =3D=3D __BIG_ENDIAN : defined(_=
_BIG_ENDIAN)
>  	__u32 events_hi;	/*  7 high-order of superblock update count   */
>  	__u32 events_lo;	/*  8 low-order of superblock update count    */
>  	__u32 cp_events_hi;	/*  9 high-order of checkpoint update count   */
>  	__u32 cp_events_lo;	/* 10 low-order of checkpoint update count    */
> -#else
> +#elif defined(__BYTE_ORDER) ? __BYTE_ORDER =3D=3D __LITTLE_ENDIAN : defi=
ned(__LITTLE_ENDIAN)
>  	__u32 events_lo;	/*  7 low-order of superblock update count    */
>  	__u32 events_hi;	/*  8 high-order of superblock update count   */
>  	__u32 cp_events_lo;	/*  9 low-order of checkpoint update count    */
>  	__u32 cp_events_hi;	/* 10 high-order of checkpoint update count   */
> +#else
> +#error unspecified endianness
>  #endif
>  	__u32 recovery_cp;	/* 11 recovery checkpoint sector count	      */
>  	/* There are only valid for minor_version > 90 */


--Sig_/ZJTX6adI9zZ/4/IrFenN+b2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUT6IQznsnt1WYoG5AQI+hxAAurxPHJ36bjQjs/USfO+oq3bIT3v/7amX
s3BsLjj+8TAsWXHSNWMLnCKackt6p59PZS73urB1sZ/kIxmw2Gw+A8Ih977P8RhU
XrNEY08ob4N+oqHKmopdAVixfq4Siv/Mz6DcBrMsjA1oDctuT8Kv8T8OgDA96gVD
t71oICUZZreVROU1sknDxkqIi5WK7DwSyQpOq4Zhwn5t3juLq8LF3lrxTqxj/Ez4
I3JjF8WzR7EGRSl6D9+mZekLJeLMdz7RXzd38xxlIAOjsQUTCbTf6Y/PVJUWUL3L
yn4kTyozjSh5FHpRPHkYIsZNHVXAM++6JPIlAFfn3MRByjDJMhkwx5QnojKHPsub
8rSI86/LzOu/qbqDtUK7EGVUnCxCHme+7/dqhGSwmYxgrQCRXsS4hZHIc1uOGWOW
l0AbGLN0cNGozyCKobjgO2DkpO2oq6nkVXdQdFPz4l6hYWt6mG5ahIe1h82du2AB
AjorZDzEkA4K2Uk4OzgDCM1teYUmZdRLwLLYBJLDM6giqfxHnSaZQRk8QaTUsD1L
XD8aSPR9yxokDUl4EN9/JLh6yoE0JL1YOHc2Cea9yvXuk1bLJSmeMihwt1PpzjmV
IziX4K+1HV5MJZ6bgSOg6Yim4Cvl1XEtcOBsrY2iAf570Meqagvd5l4sTyLJuEyH
0uusZJUDi2c=
=9Sit
-----END PGP SIGNATURE-----

--Sig_/ZJTX6adI9zZ/4/IrFenN+b2--
