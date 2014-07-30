Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaG3OUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:20:18 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaG3OUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:20:15 -0400
Message-ID: <53D8FF16.2030409@sigma-star.at>
Date: Wed, 30 Jul 2014 16:20:06 +0200
From: Richard Weinberger <richard@sigma-star.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: viro@zeniv.linux.org.uk, hch@infradead.org, paulmck@linux.vnet.ibm.com,
        jeffm@suse.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Fix RCU usage in __propagate_umount()
References: <1406728756-32443-1-git-send-email-richard@sigma-star.at>
In-Reply-To: <1406728756-32443-1-git-send-email-richard@sigma-star.at>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="5aU7PpL1miDttUgttsRSEkgpnao2te5In"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5aU7PpL1miDttUgttsRSEkgpnao2te5In
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 30.07.2014 15:59, schrieb Richard Weinberger:
> If we use the plain list_empty() we might not see the
> hlist_del_init_rcu() and therefore miss one member of the
> list.
>=20
> It fixes the following issue:
> $ unshare -m /usr/bin/sleep 10000 &
> $ mkdir -p foo/proc
> $ mount -t proc none foo/proc
> $ mount -t binfmt_misc none foo/proc/sys/fs/binfmt_misc
> $ umount -l foo/proc
> $ rmdir foo/proc
> rmdir: failed to remove =E2=80=98foo/proc=E2=80=99: Device or resource =
busy
>=20
> rmdir fails because the last entry in the RCU list, "proc", was
> not propagated as list_empty() still returned false instead of true.
>=20
> Signed-off-by: Richard Weinberger <richard@sigma-star.at>

Please drop this patch, it is wrong. :-\

Thanks,
//richard

> ---
> Hi!
>=20
> Please review this patch with care, the comments in rculist.h
> confused me like hell:
>=20
> First it says:
> /*
>  * Why is there no list_empty_rcu()?  Because list_empty() serves this
>  * purpose.  The list_empty() function fetches the RCU-protected pointe=
r
>  * and compares it to the address of the list head, but neither derefer=
ences
>  * this pointer itself nor provides this pointer to the caller.  Theref=
ore,
>  * it is not necessary to use rcu_dereference(), so that list_empty() c=
an
>  * be used anywhere you would want to use a list_empty_rcu().
>  */
>=20
> And later:
> /**
>  * Where are list_empty_rcu() and list_first_entry_rcu()?
>  *
>  * Implementing those functions following their counterparts list_empty=
() and
>  * list_first_entry() is not advisable because they lead to subtle race=

>  * conditions as the following snippet shows:
>  *
>  * if (!list_empty_rcu(mylist)) {
>  *      struct foo *bar =3D list_first_entry_rcu(mylist, struct foo, li=
st_member);
>  *      do_something(bar);
>  * }
>  *
>  * The list may not be empty when list_empty_rcu checks it, but it may =
be when
>  * list_first_entry_rcu rereads the ->next pointer.
>  *
>  * Rereading the ->next pointer is not a problem for list_empty() and
>  * list_first_entry() because they would be protected by a lock that bl=
ocks
>  * writers.
>  *
>  * See list_first_or_null_rcu for an alternative.
>  */
>=20
> To my understanding we cannot use list_empty() and have to use list_fir=
st_or_null_rcu(),
> or am I missing something?
>=20
> Thanks,
> //richard
>=20
>  fs/pnode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/pnode.c b/fs/pnode.c
> index 302bf22..883901c 100644
> --- a/fs/pnode.c
> +++ b/fs/pnode.c
> @@ -380,7 +380,8 @@ static void __propagate_umount(struct mount *mnt)
>  		 * umount the child only if the child has no
>  		 * other children
>  		 */
> -		if (child && list_empty(&child->mnt_mounts)) {
> +		if (child && list_first_or_null_rcu(&child->mnt_mounts,
> +						    struct mount, mnt_mounts)) {
>  			hlist_del_init_rcu(&child->mnt_hash);
>  			hlist_add_before_rcu(&child->mnt_hash, &mnt->mnt_hash);
>  		}
>=20

--=20
sigma star gmbh - Bundesstrasse 3 - 6111 Volders - Austria
ATU66964118 - FN 374287y


--5aU7PpL1miDttUgttsRSEkgpnao2te5In
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJT2P8WAAoJEEtJtSqsAOnWiwkQAJxz6y6sYnkTWGMw6jQV6QxV
dlgiOI//yPnSQjCAtw44HbPU8/Ulbc+bHAXr13Zg5iOUjLUKoDRhAC4DE5KsQe/w
MH2Kcd+UnJZH/su6WxdHBZXJf8rlcb+1HPnQ0W9gPU2b1m84TBybjTjqR6Y1OvCN
IEXYTOr2Eol7Q0Iuk/DG/UQk9it/1C1JE+mQ1DHzIone7q8qbCQVMAkiNOvRbi7T
g4+eitKceq6XRHwkaVR7n+AU3u4PwkIvHBNBmGAxYbDjfSMEjn1eGurnGLlTuQ9g
uJeQvtn6sn721MJA9/53YN7jAGANozJKE81QLFub33Mtz684B9GvoJu61lJgAb3o
Mlxfcu1Nvc8XSX7b0ukUE72vKlO+fkLP9jgO0CoMPlGs/0lUZfrl2GNAVcONvU7W
bHEv4FMDPP1CnRBsxkdtlDO9RMjsDDRiA78DEJ9eH/7pZamIzjBVO88JJsnIHEjJ
ZQXY8gV2+1xrzLAorS9jD7FzWP69M0z4UgjZF37gtshCwMD932wbL84t+qy9IkV8
wH2PvUWXCU+bdmXYM5kI0kJ5fHvqwbpTOJGC0lVr1cpaBIY2u0hHsCeQ3F4LZ3Mt
P68IbPHI1i7OXiJcsUM8/DhENKcWzuse8gAuUi6pIjTsquqSPtkYx8GaXws3OT+7
Rx35Bi1zPkZUQkzsfjri
=A/8O
-----END PGP SIGNATURE-----

--5aU7PpL1miDttUgttsRSEkgpnao2te5In--
