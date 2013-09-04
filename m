Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633Ab3IDBLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:11:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52246 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3IDBLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:11:23 -0400
Date: Wed, 4 Sep 2013 11:11:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [tip:x86/smap] Introduce [compat_]save_altstack_ex() to unbreak
 x86 SMAP
Message-Id: <20130904111109.a324685422cf680403678e4e@canb.auug.org.au>
In-Reply-To: <tip-es5p6y64if71k8p5u08agv9n@git.kernel.org>
References: <tip-es5p6y64if71k8p5u08agv9n@git.kernel.org>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Sep_2013_11_11_09_+1000_EK+z0W5Ca+NXYg5h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Sep_2013_11_11_09_+1000_EK+z0W5Ca+NXYg5h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Sep 2013 14:45:56 -0700 tip-bot for Al Viro <tipbot@zytor.com> wr=
ote:
>
> Commit-ID:  bd1c149aa9915b9abb6d83d0f01dfd2ace0680b5
> Gitweb:     http://git.kernel.org/tip/bd1c149aa9915b9abb6d83d0f01dfd2ace0=
680b5
> Author:     Al Viro <viro@ZenIV.linux.org.uk>
> AuthorDate: Sun, 1 Sep 2013 20:35:01 +0100
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Sun, 1 Sep 2013 14:16:33 -0700
>=20
> Introduce [compat_]save_altstack_ex() to unbreak x86 SMAP
>=20
> For performance reasons, when SMAP is in use, SMAP is left open for an
> entire put_user_try { ... } put_user_catch(); block, however, calling
> __put_user() in the middle of that block will close SMAP as the
> STAC..CLAC constructs intentionally do not nest.
>=20
> Furthermore, using __put_user() rather than put_user_ex() here is bad
> for performance.
>=20
> Thus, introduce new [compat_]save_altstack_ex() helpers that replace
> __[compat_]save_altstack() for x86, being currently the only
> architecture which supports put_user_try { ... } put_user_catch().
>=20
> Reported-by: H. Peter Anvin <hpa@linux.intel.com>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v3.8+
> Link: http://lkml.kernel.org/n/tip-es5p6y64if71k8p5u08agv9n@git.kernel.org
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index 7f0c1dd..ec1aee4 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -669,6 +669,13 @@ asmlinkage long compat_sys_sigaltstack(const compat_=
stack_t __user *uss_ptr,
> =20
>  int compat_restore_altstack(const compat_stack_t __user *uss);
>  int __compat_save_altstack(compat_stack_t __user *, unsigned long);
> +#define compat_save_altstack_ex(uss, sp) do { \
> +	compat_stack_t __user *__uss =3D uss; \
> +	struct task_struct *t =3D current; \
> +	put_user_ex(ptr_to_compat((void __user *)t->sas_ss_sp), &__uss->ss_sp);=
 \
> +	put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
> +	put_user_ex(t->sas_ss_size, &__uss->ss_size); \
> +} while (0);

I am just wondering if there is some reason that these macros are not
implemented as (static inline) C functions?

> +#define save_altstack_ex(uss, sp) do { \
> +	stack_t __user *__uss =3D uss; \
> +	struct task_struct *t =3D current; \
> +	put_user_ex((void __user *)t->sas_ss_sp, &__uss->ss_sp); \
> +	put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
> +	put_user_ex(t->sas_ss_size, &__uss->ss_size); \
> +} while (0);
> +
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__4_Sep_2013_11_11_09_+1000_EK+z0W5Ca+NXYg5h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSJoiyAAoJEECxmPOUX5FE7SwP/jo1J94qRxYDyTiccUKMnFeO
4j3wjIQV3dXyH46HnQRix/oT4VeRaWXd5WOPMv+OkUuNgP2T177Vyvx9wzGU47I9
8Kf226LRNuWsAlKmsLhW0m9Fqeo1QLJluZh3gm6FKEZoLMLQUcQsxEEPtU7moGRE
YrT48xffYDGI/5t9DpGfcViU875mGNaYWpNapXjjFjaKkRgulVIxMHWfUG+07blj
6j7266LERbGRcskmxg4tUbS+XzKfj4EOtUVUSG3RHfhm+16Bh8RGKAvQ5pErgWYq
TV+ra8/+XfLE/zlQDKOfvtPtaGhfgg4HftZppba0G9wAgZlhnOGf/mr8puAX65I9
u51RVouZUaDalnmUZcp0jSZdsu6181MMrM4bqANDMQZgK4Jr/YKL+ve96yd9sKqR
8hW4jX4rlxZWSbpHHxTEdZMO6GWXZkc8cqDKKaBLi386uGG+7y/kOwgXQYnMz0Ff
VYstPAIoRNQmv2c6WkWZeutYV9W/DRaOYTUQRRfGpQIWZKOMz0JmTr6k1AveKQBn
2ZDZ7zqsB4oryUQKs5TLSOPNVnl6t1DPwbGqzm50niENRhjLtrqIl39ar8c9w6Ph
6RA2IuM4KRJu7iPjeR5H20+Ief60uoOPTo8EcStNQT5taxGcKaFffctaq+a1cViO
j2Q371DRz+W9fulYZZP5
=sTp4
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Sep_2013_11_11_09_+1000_EK+z0W5Ca+NXYg5h--
