Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbbABPlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 10:41:10 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:16185 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752292AbbABPlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 10:41:07 -0500
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Fri, 02 Jan 2015 15:41:04 +0000
Message-ID: <54A6BC0E.50008@imgtec.com>
Date: Fri, 2 Jan 2015 15:41:02 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-metag@vger.kernel.org>
Subject: Re: [PATCH repost 09/16] metag/uaccess: fix sparse errors
References: <1419499661-8566-1-git-send-email-mst@redhat.com> <1419499661-8566-10-git-send-email-mst@redhat.com>
In-Reply-To: <1419499661-8566-10-git-send-email-mst@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="pgQm8DhnOOXqKxe6IOmdSnG6G1VsvIH0V"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: da4c5968
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pgQm8DhnOOXqKxe6IOmdSnG6G1VsvIH0V
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

On 25/12/14 09:29, Michael S. Tsirkin wrote:
> virtio wants to read bitwise types from userspace using get_user.  At t=
he
> moment this triggers sparse errors, since the value is passed through a=
n
> integer.
>=20
> Fix that up using __force.

I still see these sparse warnings with metag even with your patch:

  CHECK   drivers/vhost/vhost.c
drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio16
drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio16
drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio16
drivers/vhost/vhost.c:1004:13: warning: cast from restricted __virtio16
drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio16
drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio16
drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio16
drivers/vhost/vhost.c:1022:13: warning: cast from restricted __virtio16
drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio32
drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio32
drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio32
drivers/vhost/vhost.c:1373:21: warning: cast from restricted __virtio32
drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio32
drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio32
drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio32
drivers/vhost/vhost.c:1377:21: warning: cast from restricted __virtio32
drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio16
drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio16
drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio16
drivers/vhost/vhost.c:1425:13: warning: cast from restricted __virtio16

Which something like the following hunk fixes in a similar way to yours:

diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/asm/ua=
ccess.h
index 0748b0a97986..594497053748 100644
--- a/arch/metag/include/asm/uaccess.h
+++ b/arch/metag/include/asm/uaccess.h
@@ -112,13 +112,17 @@ do {                                               =
             \
 	retval =3D 0;                                             \
 	switch (size) {                                         \
 	case 1:								\
-		retval =3D __put_user_asm_b((unsigned int)x, ptr); break;	\
+		retval =3D __put_user_asm_b((__force unsigned int)x, ptr); \
+		break;							\
 	case 2:								\
-		retval =3D __put_user_asm_w((unsigned int)x, ptr); break;	\
+		retval =3D __put_user_asm_w((__force unsigned int)x, ptr); \
+		break;							\
 	case 4:								\
-		retval =3D __put_user_asm_d((unsigned int)x, ptr); break;	\
+		retval =3D __put_user_asm_d((__force unsigned int)x, ptr); \
+		break;							\
 	case 8:								\
-		retval =3D __put_user_asm_l((unsigned long long)x, ptr); break; \
+		retval =3D __put_user_asm_l((__force unsigned long long)x, ptr); \
+		break;							\
 	default:							\
 		__put_user_bad();					\
 	}=09

As far as I understand it, using __force on the value (as opposed to the
pointer) is safe here, in the sense of not masking any genuine defects.
Do you agree? Do you want to apply that hunk with your patch too?

Note, this change also suppresses warnings for writing a pointer to
userland due to the casts to unsigned int / unsigned long long, such as
the following (each 4 times due to 4 cases above):

kernel/signal.c:2740:25: warning: cast removes address space of expressio=
n
kernel/signal.c:2747:24: warning: cast removes address space of expressio=
n
kernel/signal.c:2760:24: warning: cast removes address space of expressio=
n
kernel/signal.c:2761:24: warning: cast removes address space of expressio=
n
kernel/signal.c:2775:24: warning: cast removes address space of expressio=
n
kernel/signal.c:2779:24: warning: cast removes address space of expressio=
n
kernel/signal.c:3202:25: warning: cast removes address space of expressio=
n
kernel/signal.c:3225:17: warning: cast removes address space of expressio=
n
kernel/futex.c:2769:16: warning: cast removes address space of expression=


>=20
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/metag/include/asm/uaccess.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/asm/=
uaccess.h
> index 0748b0a..c314b45 100644
> --- a/arch/metag/include/asm/uaccess.h
> +++ b/arch/metag/include/asm/uaccess.h
> @@ -135,7 +135,7 @@ extern long __get_user_bad(void);
>  ({                                                              \
>  	long __gu_err, __gu_val;                                \
>  	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
> -	(x) =3D (__typeof__(*(ptr)))__gu_val;                     \
> +	(x) =3D (__force __typeof__(*(ptr)))__gu_val;                     \

Can you adjust the position of the \ to line up please

>  	__gu_err;                                               \
>  })
> =20
> @@ -145,7 +145,7 @@ extern long __get_user_bad(void);
>  	const __typeof__(*(ptr)) __user *__gu_addr =3D (ptr);		\
>  	if (access_ok(VERIFY_READ, __gu_addr, size))			\
>  		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
> -	(x) =3D (__typeof__(*(ptr)))__gu_val;                             \
> +	(x) =3D (__force __typeof__(*(ptr)))__gu_val;                        =
     \

same here (this one causes a checkpatch error due to 80 column limit)

>  	__gu_err;                                                       \
>  })
> =20
>=20

With those changes,
Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James


--pgQm8DhnOOXqKxe6IOmdSnG6G1VsvIH0V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUprwOAAoJEGwLaZPeOHZ64/wP/jcnjLfGkNj0av6fKgGC/0Sr
fW2BbDcvNlYh3LUbUZteVrLGynCesIkyToNxn23d1pTyzz21ZmujuhY1PK01o3AU
ocUB4O2S0ToeV5Xef/ziMsnihu9ohkJnL2649BPULl8rufhOyQ30RBaQMtr7Xyxh
SgtSGhT9qJA3zetIhNNoDzgMchBD1omwDCuf+fcm/8LFPupZDwLhjXsS62046Ofq
G+VI1GzwA1khecDCreQ1fCHqsBR4v6lGyD9Ko1hKfieGR4ykEHs+RDqk7kJihJtj
0PpqmmMRFJMfFUOlrY46yOM59RsMviBkKAZviFLpX8qKhjfsVpNwTa0U108V3Vh8
smk52uB3i88+ed4al6EECv2Uh+MmTXGxUze5pzJCE3j6bgjYZklvoVj1+C//GrwN
SkJP+sgdfvVZoxMmlBMl3vGDf+fSHTZTGS0evfQYzsN85t2ctjlhE+QCbR99yGB7
B+U/eUvSTSOTTe8aLk6YFUaH79hDX5CBAP85TuDrq3pdiAUEJVCaP7llK3bsrDJt
Q3mJd8CTPo57Jl/SYHoKIfdP75pSTehLkrvNIG/D6B88aPol4nKOVqpQbe3as+7+
9K6bAxwSxxufcj/AIpVuZM+jbsgGsXpwvsOiUipe6xdnuGHFxs6Fnicd0VzCMikM
FTHkHWmTkZ6SSbs0HFRR
=HpvT
-----END PGP SIGNATURE-----

--pgQm8DhnOOXqKxe6IOmdSnG6G1VsvIH0V--
