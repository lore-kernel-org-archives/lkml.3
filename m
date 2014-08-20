Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaHTDOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:14:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaHTDOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:14:05 -0400
Date: Wed, 20 Aug 2014 13:13:52 +1000
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] RCU-walk support for autofs
Message-ID: <20140820131352.2aad3ca5@notabene.brown>
In-Reply-To: <1408451815.11314.15.camel@perseus.themaw.net>
References: <20140818062844.9860.43007.stgit@notabene.brown>
	<1408350340.2533.3.camel@perseus.fritz.box>
	<1408442547.11314.9.camel@perseus.themaw.net>
	<20140819211654.5ec3853a@notabene.brown>
	<1408451815.11314.15.camel@perseus.themaw.net>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/UW14_NMvjSt0e5U1A0V0nGX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UW14_NMvjSt0e5U1A0V0nGX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Aug 2014 20:36:55 +0800 Ian Kent <raven@themaw.net> wrote:

> On Tue, 2014-08-19 at 21:16 +1000, NeilBrown wrote:
> > On Tue, 19 Aug 2014 18:02:27 +0800 Ian Kent <raven@themaw.net> wrote:
> >=20
> > > On Mon, 2014-08-18 at 16:25 +0800, Ian Kent wrote:
> > > > On Mon, 2014-08-18 at 16:33 +1000, NeilBrown wrote:
> > > > > Hi Ian,
> > > > >  Have you had a chance to run your tests in these patches yet?
> > > > >  I've done what testing I can think of and cannot fault them.
> > > >=20
> > > > I haven't, I've been plagued with illness so I'm not getting nearly
> > > > enough done. I'll try to put a kernel together and run the test in =
the
> > > > next week or so.
> > >=20
> > > Just to let you know that I managed to spend some time on this. I bui=
lt
> > > a kernel (3.17.0-rc1) with the series and ran a couple of tests.
> > >=20
> > > I'm not certain that the patches I used are identical to your posting=
, I
> > > saw one difference, after the fact, that shouldn't matter, I'll have =
to
> > > check that.
> > >=20
> > > It isn't possible to test expire to mount races because the mounts in
> > > the tree never expire.
> > >=20
> > > At first I thought it was because so many processes were accessing the
> > > tree all the time but manually constructing the maps and mounting the
> > > mounts shows that nothing ever expires, at least for this tree.
> > >=20
> > > However, issuing a shut down does expire all the mounts and shuts down
> > > autofs cleanly.
> > >=20
> > > So there is something not quite right with the expire check or my
> > > patches have mistakes.
> >=20
> > Ahh.. I bet I know what it is.
> > autofs4_can_expire() isn't idempotent.
> > Because we call should_expire twice, autofs4_can_expire() is called twi=
ce and
> > the second time it failed because  the first time it resets ->last_used.
> >=20
> > diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
> > index eb4b770a4bf6..80133a9d9427 100644
> > --- a/fs/autofs4/expire.c
> > +++ b/fs/autofs4/expire.c
> > @@ -26,6 +26,9 @@ static inline int autofs4_can_expire(struct dentry *d=
entry,
> >  	if (ino =3D=3D NULL)
> >  		return 0;
> > =20
> > +	if (ino->flags & AUTOFS_INF_NO_RCU)
> > +		/* Already performed this test */
> > +		return 1;
>=20
> Wouldn't it be better to perform this check, or similar, further down
> where the last_used time is updated? After all it's only updated to
> prevent rapid fire expires on dentrys that refuse to umount for some
> reason.
>=20

How about the follow approach instead?
Though I must admit that I find the 'now' global variable feels a bit
clumsy...
Is there a reason for not just using "jiffies" everywhere?

I've created a tag 'autofs4' in git://neil.brown.name/md/ which has this in
with all the others, in case that is useful.

Thanks,
NeilBrown



=46rom 201f75bc25906e8f64e28b37f1bb478958bf2987 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 20 Aug 2014 12:40:06 +1000
Subject: [PATCH] autofs4: make "autofs4_can_expire" idempotent.

Have a "test" function change the value it is testing can
be confusing, particularly as a future patch will be calling
this function twice.

So move the update for 'last_used' to avoid repeat expiry
to the place where the final determination on what to expire is known.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index bee939efca2b..af09dada91bc 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -30,12 +30,6 @@ static inline int autofs4_can_expire(struct dentry *dent=
ry,
 		/* Too young to die */
 		if (!timeout || time_after(ino->last_used + timeout, now))
 			return 0;
-
-		/* update last_used here :-
-		   - obviously makes sense if it is in use now
-		   - less obviously, prevents rapid-fire expire
-		     attempts if expire fails the first time */
-		ino->last_used =3D now;
 	}
 	return 1;
 }
@@ -541,6 +535,8 @@ int autofs4_expire_run(struct super_block *sb,
=20
 	spin_lock(&sbi->fs_lock);
 	ino =3D autofs4_dentry_ino(dentry);
+	/* avoid rapid-fire expire attempts if expiry fails */
+	ino->last_used =3D now;
 	ino->flags &=3D ~AUTOFS_INF_EXPIRING;
 	complete_all(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
@@ -567,6 +563,8 @@ int autofs4_do_expire_multi(struct super_block *sb, str=
uct vfsmount *mnt,
 		ret =3D autofs4_wait(sbi, dentry, NFY_EXPIRE);
=20
 		spin_lock(&sbi->fs_lock);
+		/* avoid rapid-fire expire attempts if expiry fails */
+		ino->last_used =3D now;
 		ino->flags &=3D ~AUTOFS_INF_EXPIRING;
 		complete_all(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);

--Sig_/UW14_NMvjSt0e5U1A0V0nGX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/QScDnsnt1WYoG5AQJ5uhAAkX1aWxCgs+pD2TNB7tILcnSMOjlJ9U2H
xmMm8W0zMJyulGT7QFkINW2uArx9c6UV3Q9KiIsqtyRqm9OuqtVY+qU1FGX3qw+y
kLncbJ6HgICf3W+8UY/ESGCNb50op/H+1X4gFsWH6leNuVd1Gn6ESJ29L6DfUYCm
sLOl0y5Ync5SbD7jdpAiqdZTY9DYb0ZI5wDkYfxYOJ2yUF9oirfpAbeyYftLNeDv
VhzxvGSiVNpN5a8LcF82LnrXxrkdzjCQgQ2Gck7fNxGdznIWAsT22vx8cLQEus5A
yEz0BOYP5ZHHugEBJbvsz9qOQ++UA63n59giIJo5yT5CKHj4CbMYCbP5irAC/ds4
BKI5qI9yYzlzTDMJ3XVeMk2y+2/1WmhsUX6RTYG3uErxr7rfRNbKjQk+pCREFI3e
0w1281uz84SeKUjzHFIHBnBuaKe6fPLEC72q/pHa9q883qnVD0ZRelAuk1Bs12lc
Ny8MlAslHRYajr2Uu5reuLd00g4JgtpIZnQANPO4nRIZXMu0ycURa+sAxvXlp3mp
BfG5SEEw8e8D4oxX5d9LzB79xwdtYYXVZJnu7q/k1qkBMA8qHyAGDSTbbm6O0KBx
j1NoCty2hul+N/tpdezzDYNrSiiAZQiFIHbX3BKabm3Xd+D3Mug6/hy74SkNZpfG
VAloQHPCG9I=
=4un4
-----END PGP SIGNATURE-----

--Sig_/UW14_NMvjSt0e5U1A0V0nGX--
