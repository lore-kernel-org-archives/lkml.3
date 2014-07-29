Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaG2BvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 21:51:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34711 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaG2BvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 21:51:12 -0400
Date: Tue, 29 Jul 2014 11:51:01 +1000
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] autofs4: allow RCU-walk to walk through autofs4.
Message-ID: <20140729115101.0805ecd8@notabene.brown>
In-Reply-To: <1405592252.20621.63.camel@perseus.fritz.box>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	<20140709234114.4525.46882.stgit@notabene.brown>
	<1405485857.2527.38.camel@perseus.fritz.box>
	<20140716155150.044c2ea3@notabene.brown>
	<1405493777.2527.72.camel@perseus.fritz.box>
	<1405573256.3002.25.camel@perseus.fritz.box>
	<20140717180414.2e2596d1@notabene.brown>
	<1405592252.20621.63.camel@perseus.fritz.box>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/NxZx/LjE5hvAELhTxv_3=SQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/NxZx/LjE5hvAELhTxv_3=SQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Jul 2014 18:17:32 +0800 Ian Kent <raven@themaw.net> wrote:

>=20
> On Thu, 2014-07-17 at 18:04 +1000, NeilBrown wrote:
> > If there some documentation about the interactions between the automoun=
td and
> > the kernel?
>=20
> Not really, only the ioctl interaction described in
> Documentation/filesystems/autofs4-mount-control.txt
>=20
> > It looks like:
> >  With V5, every name in the root directory gets something mounted on it,
> >       either another autofs or the target filesystem.
> >  With V4, you don't mount an autofs onto an autofs, but when a name in =
the
> >       root is automounted, all the names beneath there are created and =
the
> >       target filesystems are mounted before the top level automount is
> >       acknowledged.
> >=20
> > Does that sound at all right (I suspect I haven't explained it very cle=
arly).
>=20
> Mostly, but let me try and simplify it (or perhaps confuse you even more
> and bore you as a bonus, ;)) and offer a broader picture.

Thanks for going into all that detail!  Having read that, and read the code
(a few times) and having tried to document it myself I think I really
understand it all now.

I wanted to be sure I understood from the perspective of what the module
actually supports rather than just how the automount daemon uses it, so I p=
ut
together a document describing the module.  At 3000 words, I'm not sure
whether to call it "verbose" or "thorough".  I'll post it separately.

I did discover one thing that is important for the RCU-walk work.
If you have a "root-less multimount" then the top-level directory will have
DCACHE_NEED_AUTOMOUNT set even though it is not a mount-trap.
As it contains a sub-directory (or more), d_manage will return -EISDIR so
normal REF-walking will side-step d_automount and it will be treated as a
normal directory.
However in RCU-walk mode, d_manage cannot usefully return -EISDIR so the VFS
will always drop into REF-walk mode, which negates some of the value of my
RCU-walk patches.

I see two ways to fix this:
 1- clear DCACHE_NEED_AUTOMOUNT when creating a subdir or symlink, just like
    we do with protocol-version 4
 2- teach the VFS to accept -EISDIR from d_manage and to ignore
    DCACHE_NEED_AUTOMOUNT in that case.  I have a patch to do this and it is
    fairly straight forward.

I think I prefer 2 (it seems easier to document:-) but thought I'd ask if y=
ou
have an opinion before I post it (I haven't even tested it properly yet).

Thanks,
NeilBrown


--Sig_/NxZx/LjE5hvAELhTxv_3=SQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9b+Bjnsnt1WYoG5AQL+Yw//ZB28KfdeHNgTBkMd/Tr1YfrgNRy8fYF1
ZaWZZpCVH2s1qUGvRwlyy2aeahU+snqU2pLw2GgTadULldSSsywQ8wTI2Kax6M8R
CHljMc/a/TMok5eH2kZUDRNxdiXw+JpEjitAo9HhEJhTvvUsi1DsDPeispe5Z67P
/AOZgynkDcOzDoy4BB0c5tc0v4cXsnI4ZHZ7ikvus8a+GgIZPKowyfRb7UpPX0xy
s4YKWWdhahIhwz/xNtKfy50rg/H+JkLtB0TNuogvPbgQMmuf+97IskqSnuKUEqaC
lDq7898iXQaXNOfrrHC3NBqs+/0PJtenS5JGPJLw1Cogyzk1gjF7aNhCRTYhuDDp
bEeuj/6utLl1xuw28RBr3t7JfOxR1L8fjRmF0ZmYsNfdRg6LL+NC1rn/M2O8lFpT
V3P5NkTe+yISSCNvvIKpJrEsKSB1CIfGCloRsNnD7d55d5Hl4+qv9eaW45Pcm4s5
hR/kk4t+wofFrY13329U2Tx4iuRCrW9xZ9unRMweb2GsX3CuCdw+OeB3glr6eRa+
MOkmmp5jE5zpoSDX2ixK8b1tvCCm6UromjepMnwE8ArgvkOnx3LU2n2TWfjAW4tq
EqbFtSw+DqBFZafQ3fei34TTkvcD5QZMHxeW5bVSuRaRb69eKvq+yQT9IclwFuYc
8gf8jpzwS94=
=VMWS
-----END PGP SIGNATURE-----

--Sig_/NxZx/LjE5hvAELhTxv_3=SQ--
