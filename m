Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaB0Ve6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:34:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaB0Vez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:34:55 -0500
Date: Fri, 28 Feb 2014 08:34:43 +1100
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux RAID <linux-raid@vger.kernel.org>,
        "majianpeng" <majianpeng@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md / procfs: avoid Oops if md-mod removed while
 /proc/mdstat is being polled.
Message-ID: <20140228083443.64c92382@notabene.brown>
In-Reply-To: <20140227125807.d034c50c7fe2e1a9f3c38ec1@linux-foundation.org>
References: <20140227172445.13644477@notabene.brown>
	<20140227125807.d034c50c7fe2e1a9f3c38ec1@linux-foundation.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XeRoyv0w6oH+tjZGbyfgw29"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XeRoyv0w6oH+tjZGbyfgw29
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Feb 2014 12:58:07 -0800 Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Thu, 27 Feb 2014 17:24:45 +1100 NeilBrown <neilb@suse.de> wrote:
>=20
> > If poll or select is waiting on /proc/mdstat when md-mod is unloaded
> > an oops will ensure when the poll/select completes.
> >=20
> > This is because the wait_queue_head which is registered with poll_wait()
> > is local to the module and no longer exists when the poll completes and
> > detaches that wait_queue_head (in poll_free_wait -> remove_wait_queue).
> >=20
> > To fix this we need the wait_queue_head to have (at least) the same life
> > time as the proc_dir_entry.  So this patch places it in that structure.
> >=20
> > We:
> >   - add pde_poll_wait to struct proc_dir_entry
> >   - call poll_wait() passing this when poll() is called on the proc file
> >   - export a function proc_wake_up which will call wake_up() on pde_pol=
l_wait
> >=20
> > and make use of all that in md.c
>=20
> This sounds wrong.  If a userspace process is waiting on
> md_event_waiters then the md module is "busy" and the rmmod attempt
> should fail?

Al Viro says "no" quite firmly.

I think the core argument is that

  rmmod md-mod < /proc/mdstat

would deadlock.

http://marc.info/?l=3Dlinux-fsdevel&m=3D133024267507384

Thanks,
NeilBrown

--Sig_/XeRoyv0w6oH+tjZGbyfgw29
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUw+vcznsnt1WYoG5AQLrIw//eVpHtTvwY0i92AY5JDUFMALF7PhX3mfR
usGbgxlOb7Wmn1xU++h4pOD2Ve49HhZl0KVYV4Mfekz2w+gGVTfhZPc34uriaqJ5
VDYVf1Nl9tjNa3VHaQUApSvGTleFmBMO20xyMLfaaSY356yjYWidclOutdHu0HR6
CRIiXhZ267QK6Ag2xtS+2IL67TYUbHAB9FJeWyvtypz6VV5eAYdBQMZle4jUokOl
Oe9mQ+Kd20+qmHS2iFg0Hyc8WxW2S1THe80yHLTeHDdSjA8IYnDKJc409UcV5SsH
hpW9ktbHNDqIlLkbXtS8LnxB49m4Uv5ALyiYIHeh/hNECKmpm85WikR6VGs+nou3
BTTDID2el2ZWnAqh8nxOoXdCdeDEFnesI13tcMOJBr0W4YRDaVWrmZrJwC16yBwY
AH7dCQgMWPLgjuwi0De0gbHuwmT2eCU4CWZMWNjRmT8ZIzff2SQaiDkW23tqs2qZ
/wRzW72CTOSQeHr5fBX1x+XSZAojUtMReTlKcwNfTxypRy5+r1FIajbT0ZXFToIx
K6FIMpUGWE3jPqT3W68ujtzhm0Tj3ha7EXqX5KrLr9mGr5n4GJyRjwdYbnw38Zx/
LVi54EMrz+UQ8zVGXwctB4AvJZMCKKKli1AC+eLziey+ejaME3LOwa0FU0jqtn9y
/Yp8kin7+t0=
=l793
-----END PGP SIGNATURE-----

--Sig_/XeRoyv0w6oH+tjZGbyfgw29--
