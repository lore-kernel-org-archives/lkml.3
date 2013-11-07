Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750904Ab3KGFAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:00:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab3KGFAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:00:06 -0500
Date: Thu, 7 Nov 2013 15:59:50 +1100
From: NeilBrown <neilb@suse.de>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Kent Overstreet <kmo@daterainc.com>, <axboe@kernel.dk>,
        <linux-kernel@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] block: Revert bio_clone() default behaviour
Message-ID: <20131107155950.564ffc0c@notabene.brown>
In-Reply-To: <20131106202236.3802.2079@localhost.localdomain>
References: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
	<20131106161130.3802.97153@localhost.localdomain>
	<20131106200222.GA3842@kmo>
	<20131106202236.3802.2079@localhost.localdomain>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9ixTTc2si_xTGig=rMS3fA="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9ixTTc2si_xTGig=rMS3fA=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Nov 2013 15:22:36 -0500 Chris Mason <chris.mason@fusionio.com>
wrote:


> > Yup - that should actually be safe for all the existing bio_clone() use=
rs
> > actually, I audited all of them - because normally you're not going to =
complete
> > the original bio until the clone finishes.
>=20
> I'd say we need an ack from Neil before we can switch to _fast.  The
> completions look non-trivial and _fast adds new ordering requirements on
> free.

I think it should be fairly straight forward to use _fast in md.
As Kent says, the original bio that is cloned is (almost) never going to ha=
ve
endio called until all the clones have done their thing and finished up.

The only exception is the "behind_pages" stuff in raid1.c.  We clearly need
to be more careful there.
If the  "ordering requirements" you mention are simply that the owner of the
original may free the biovec, so the clone must have finished using it befo=
re
that can happen, then that would most easily be fix with
   mbio->bi_io_vec =3D r1_bio->behind_bvecs;
rather than the current loop which copies all the bv_page pointers.

NeilBrown


--Sig_/9ixTTc2si_xTGig=rMS3fA=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnseRjnsnt1WYoG5AQKaDw/9E4Hd0LzBaswR4rodvTMKP4WWfiGdu2cN
oICMo39mPDPWw4eCn9kNW5i4P9tmeMd8zeqbLeoZKd4L0MEL4eGgoMgUQJIwW3gt
gr9DIAplXVrNQwhbojJTQR8qocrU6uEK+i4UU6D8XQ0H3rFlOS7Pis9BeHp2hAqf
BZkmCX77fk9xwwqm6lwUha48Pc0lbOeIGV+03ODF8yGVoMq2ekyNC4/PXBvcdxRW
uieeBhFjZwUVhkgYEhCJIr9C4ebP4pjR1lpcbmLbMy44C6VHFaPBmT8WsTaHmNoL
CK9D8wN2U4csGbNI8bloOqgRCcWohJC4xA9kF9I0FsLA/NWigFwY0fzZp+sBuVqV
pNkZS77nuhP0v8XGEjELkkWvMNdUR4bBfMEhLKrqL7RnvSLyWZOOI9oyATPiQers
keInlid50xL+DLiNA63AX7bxkY5nsZJu9uihlC1EGlx0zoPGIXPpBiUs/IxpRCEj
PhIQ6zXSG56SQqCI3iq0TMxlKMoIGeO7ujsiozAXLHtVx0QCIKYzdE+zryUAgpnO
GGyEurAuWEvFS+w9DTT9D3YJOln2jz2ffYt77t2AyjYPC5AdYqE0m8o5HpkYLfWW
SgOvu5fFUB8qjNzJfi0IJrt2B3XLJ2oTOqvQeSmv35BQfFAnRLXBopEe7VZjy+S7
f0+cFVekFFU=
=XVO2
-----END PGP SIGNATURE-----

--Sig_/9ixTTc2si_xTGig=rMS3fA=--
