Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaIZAgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 20:36:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53603 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbaIZAga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 20:36:30 -0400
Date: Fri, 26 Sep 2014 10:36:20 +1000
From: NeilBrown <neilb@suse.de>
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: avoid potential long delay under pers_lock
Message-ID: <20140926103620.7c397832@notabene.brown>
In-Reply-To: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
References: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/jASjM37T=RQ9pDhaA_8U+Al"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jASjM37T=RQ9pDhaA_8U+Al
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Sep 2014 15:28:34 +0800 Chao Yu <chao2.yu@samsung.com> wrote:

> printk may cause long time lapse if value of printk_delay in sysctl is
> configured large by user. If register_md_personality takes long time to p=
rint in
> spinlock pers_lock, we may encounter high CPU usage rate when there are o=
ther
> pers_lock competitors who may be blocked to spin.
> We can avoid this condition by moving printk out of coverage of pers_lock
> spinlock.
>=20
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  drivers/md/md.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e02de05..5fcf215 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7200,9 +7200,10 @@ static const struct file_operations md_seq_fops =
=3D {
> =20
>  int register_md_personality(struct md_personality *p)
>  {
> +	printk(KERN_INFO "md: %s personality registered for level %d\n",
> +						p->name, p->level);
>  	spin_lock(&pers_lock);
>  	list_add_tail(&p->list, &pers_list);
> -	printk(KERN_INFO "md: %s personality registered for level %d\n", p->nam=
e, p->level);
>  	spin_unlock(&pers_lock);
>  	return 0;
>  }

I'm not sure I see the pressing need for this - have you noticed actual
problems?
However it seems to make sense so I've applied it.

Thanks,
NeilBrown

--Sig_/jASjM37T=RQ9pDhaA_8U+Al
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIUAwUBVCS1BDnsnt1WYoG5AQLr6A/4gQrk0LUF0nzgvvq3Id2C0AFmx8zuoXFt
PbT3zTlEMNqOXurdy63KMnM21OmMkl+N+SeQtrqWiodjtJGvGpwnvsgyI/Tvugnw
RJ6uIk9HdsmfwOZ7/6e4thTq5xp8uQtblqrMQbKwjAbN0u6R4JVr7qF2sxZO1UGa
3WThI4vii4le5UjGjoDD3ImWIpBoFCBbBTYU20E2Y6nokUaZNenE2VEFj3ZNP6cH
wIJeK/Lji+Q58tpjlHTzkslsWwsLsGYhTr2C11Fkcil4gQ/x5D46a90FgP5g70aC
wYNdM/2oGIkkbByg1CZg1qA3H5CN3y29/FT+otVDgz+aCmfwe60h6kDkwsa2P5by
m9fmdVe0/ncPgRPAT0fyKXRXmRG/aFazwrZRmJTplnZ7bmb64PYWzjqica1XnLVC
WYMNPentmLfbzWehTSyoB321kvVk/ylqk99I0n2NjVbPoYrH0oo/mJoPJhmBjrEh
znddy9iOgbhCEX6gzYsllMeyO3dVaM/9F0lcfAN1e+WG+Ttotcrr820Zb4//24wl
QfAJSUN+SXUGvhs+mC1JIoroLWrN4PKUghKnqgSByMGTqM3EXJJOjHrLRbbOiwdi
RicFpwyiayko0ZjpSOOh2kIAv9usTr9YZfvhZKOGe2IjJER+qT5z/4OzLypX3YJF
7/V86MkR2Q==
=7zVt
-----END PGP SIGNATURE-----

--Sig_/jASjM37T=RQ9pDhaA_8U+Al--
