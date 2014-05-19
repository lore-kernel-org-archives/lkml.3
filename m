Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaESVgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:36:46 -0400
Received: from ozlabs.org ([103.22.144.67]:36350 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaESVgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:36:44 -0400
Date: Tue, 20 May 2014 07:36:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the akpm tree
Message-ID: <20140520073634.40179424@canb.auug.org.au>
In-Reply-To: <1400512396.2560.9.camel@buesod1.americas.hpqcorp.net>
References: <20140519181314.1b92c548@canb.auug.org.au>
	<1400512396.2560.9.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/IGw=MeMZ5sSQESajwb_xusi"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IGw=MeMZ5sSQESajwb_xusi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 19 May 2014 08:13:16 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> On Mon, 2014-05-19 at 18:13 +1000, Stephen Rothwell wrote:
> > Hi Andrew,
> >=20
> > After merging the akpm tree, today's linux-next build (arm
> > multi_v7_defconfig) produced these warnings:
> >=20
> >=20
> > ipc/ipcns_notifier.c:22:8: warning: excess elements in struct initializ=
er [enabled by default]
> > ipc/ipcns_notifier.c:22:8: warning: (near initialization for 'ipcns_cha=
in.rwsem') [enabled by default]
> > ipc/ipcns_notifier.c:22:8: warning: excess elements in struct initializ=
er [enabled by default]
> > ipc/ipcns_notifier.c:22:8: warning: (near initialization for 'ipcns_cha=
in.rwsem') [enabled by default]
> >=20
> > and many more in other files ...
>=20
> Hmm are all the warning the same? Is this just on arm? have you seen it
> in other archs? (Could you please send me the .config)

The warnings were all the same, I saw it only on arm (since that was
what I built) and I mentioned the config above.

> > Presumably a result of commit fe2038c57c03 ("rwsem: Support optimistic
> > spinning").
>=20
> If CONFIG_SMP, we add two new fields to the rwsem structure
> (include/linux/rwsem.h) and likewise we update the
> __RWSEM_INITIALIZER(name) macro. Afaict the only way to trigger
> something like that is to be using the spinlock variant
> (rwsem-spinlock.h).

Actually quite a few architectures do set
CONFIG_RWSEM_GENERIC_SPINLOCK, and so wouldn't it make more sense to
actually directly test that?

> The fix for that would be:
>=20
> diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> index 3e108f1..091d993 100644
> --- a/include/linux/rwsem.h
> +++ b/include/linux/rwsem.h
> @@ -64,7 +64,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *=
sem)
>  # define __RWSEM_DEP_MAP_INIT(lockname)
>  #endif
> =20
> -#ifdef CONFIG_SMP
> +#if defined(CONFIG_SMP) && defined(CONFIG_RWSEM_XCHGADD_ALGORITHM)

so

#if defined(CONFIG_SMP) && !defined(CONFIG_RWSEM_GENERIC_SPINLOCK)

?

> This was picked up today by -tip maintainers, so I guess it should also
> be removed from -mm.

Was a fix also picked up?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/IGw=MeMZ5sSQESajwb_xusi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTenlpAAoJEMDTa8Ir7ZwVbeUQAI39ZZvqxUdZFrCTIy0yF7Wc
wAM2l/Y2JdPwWMJmOsO7v6VU6EgngsiCTa30MRMd449IlUoktc5Yt+ZPvG83uwiQ
ShMxWglKUIygTJYxygdhqENMELWI9Kz8sd7QYDlZ8/A217PCHi8vP1F01ULDTYRY
Xb0RXCFGwzTToy5s2FQP8O+CoMa+paf/l3/oeInu70p3iq36BSLJgETu4k+u1VdT
GcikOYgta4PDSumanfQhjSxpbXSqKQ3RLnB9iHvBArsf+REtoEUgp1W8sg8RpdZ+
DbWcrQWBRYaF+O398y8bLmVWmLFywPBZqXpIHbTyqXUFJBu+D5uK7dN1s7kPsOSo
tbsDxmNzoTdpC1z+oBWucG09W9dnLGf4qBmJbffMZFtaaty+SDEVYQhHuqlhXuJz
y+vcan+SlrBGcDSGKU8agST/uQSJLwEF6kacDZkskIkYM7B3HatdHWVczENjfMWX
GqLoP7W6G7OUF7yvFEmxv+0izLDjWsDO4yp1Ac6LLbJrguQ/GFdDuVB0wg4Zfz0O
lOGe+scTf57kZpLWBEz7iTwhwUcg2p8izzdH/LDw3VWFvkAZpQLULX2OH1i34lVd
wRAHCcRZZAr0qBO4crUYCX4pxJi7tiGFYWc4o8mYTS3bTaAwWnBCsHXYa4Bgi39C
pmfC7LwJ85EBLWZfvhpW
=9vmQ
-----END PGP SIGNATURE-----

--Sig_/IGw=MeMZ5sSQESajwb_xusi--
